import os
import asyncio
import logging
from datetime import datetime, timedelta
from telethon import TelegramClient, events
from telethon.sessions import StringSession
from telethon.tl.types import User
from openai import OpenAI
import chromadb
from sentence_transformers import SentenceTransformer

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

SESSION_STRING = os.getenv('SESSION_STRING')
API_ID_STR = os.getenv('API_ID')
API_HASH = os.getenv('API_HASH')
XAI_KEY = os.getenv('XAI_API_KEY')

# Проверка переменных
if not all([SESSION_STRING, API_ID_STR, API_HASH, XAI_KEY]):
    logger.error("❌ Отсутствуют переменные окружения!")
    logger.error(f"SESSION_STRING: {bool(SESSION_STRING)}")
    logger.error(f"API_ID: {bool(API_ID_STR)}")
    logger.error(f"API_HASH: {bool(API_HASH)}")
    logger.error(f"XAI_API_KEY: {bool(XAI_KEY)}")
    raise ValueError("Не все переменные окружения установлены")

API_ID = int(API_ID_STR)

client = TelegramClient(StringSession(SESSION_STRING), API_ID, API_HASH)
grok = OpenAI(api_key=XAI_KEY, base_url="https://api.x.ai/v1")
embedder = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

chroma = chromadb.PersistentClient(path="./tg_memory_db_v3")
collection = chroma.get_or_create_collection("tg_3months")

async def index_3months():
    await client.send_message('me', "🔄 Индексация за 3 месяца запущена...")
    three_months_ago = datetime.now() - timedelta(days=90)
    dialogs = await client.get_dialogs(limit=200)
    for dialog in dialogs:
        entity = dialog.entity
        if isinstance(entity, User): continue
        name = getattr(entity, 'title', str(entity.id))
        prefix = "📢 Канал" if getattr(entity, 'broadcast', False) else "👥 Группа"
        async for msg in client.iter_messages(entity, min_date=three_months_ago, limit=300):
            if not msg.text or len(msg.text.strip()) < 10: continue
            doc_id = f"{entity.id}_{msg.id}"
            if collection.get(ids=[doc_id])['ids']: continue
            emb = embedder.encode(msg.text).tolist()
            collection.add(ids=[doc_id], embeddings=[emb], documents=[msg.text],
                           metadatas=[{"chat": name, "prefix": prefix, "date": msg.date.isoformat()}])
    await client.send_message('me', "✅ База обновлена!")

async def analyze(query):
    results = collection.query(query_texts=[query], n_results=40)
    context = "\n".join([f"[{m['prefix']} {m['chat']}] {doc}" for doc, m in zip(results['documents'][0], results['metadatas'][0])])
    resp = grok.chat.completions.create(
        model="grok-4",
        messages=[{"role": "user", "content": f"Анализируй по-простому: {query}\nКонтекст:\n{context[:30000]}"}]
    )
    await client.send_message('me', resp.choices[0].message.content)

@client.on(events.NewMessage)
async def handler(event):
    me = await client.get_me()
    if event.is_private and event.sender_id == me.id:
        text = event.message.text.lower()
        if "индекс" in text or "обнови" in text or "проиндексир" in text:
            await index_3months()
        else:
            await analyze(event.message.text)

async def main():
    await client.start()
    await client.send_message('me', "Агент онлайн! Пиши обычным текстом.")
    await client.run_until_disconnected()

if __name__ == '__main__':
    asyncio.run(main())