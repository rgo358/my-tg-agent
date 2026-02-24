from telethon import TelegramClient
from telethon.sessions import StringSession
import asyncio

print("=== ПОЛУЧЕНИЕ SESSION_STRING ===")
print("Введи данные ниже:\n")

api_id = int(input("API_ID (с my.telegram.org): "))
api_hash = input("API_HASH: ")
phone = input("Телефон (+79xxxxxxxxx): ")

client = TelegramClient(StringSession(), api_id, api_hash)

async def main():
    print("\nОтправляю код в Telegram... Проверь сообщения от Telegram.")
    await client.start(phone=phone)
    session_string = client.session.save()
    print("\n" + "═" * 80)
    print("✅ СКОПИРУЙ ЭТУ СТРОКУ ЦЕЛИКОМ и сохрани в блокнот:")
    print(session_string)
    print("═" * 80)
    print("\nГотово! Теперь вставь эту строку в Variables на Railway.")
    input("\nНажми Enter чтобы закрыть...")

asyncio.run(main())