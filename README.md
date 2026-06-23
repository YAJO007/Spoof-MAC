# Spoof-MAC

เครื่องมือ PowerShell สำหรับ Windows ใช้สำหรับเปลี่ยน, คืนค่า, และตรวจสอบ MAC Address ของการ์ดเครือข่ายที่กำลังใช้งานอยู่

## ความสามารถ

- แสดงรายการการ์ดเครือข่ายที่เปิดใช้งานอยู่
- สุ่ม MAC Address แบบ locally administered
- ตั้งค่า MAC Address เอง
- คืนค่า MAC Address เดิม
- แสดง MAC Address ปัจจุบัน

## สิ่งที่ต้องมี

- Windows 10 หรือ Windows 11
- PowerShell
- สิทธิ์ Administrator

## วิธีใช้งาน

1. เปิด PowerShell แบบ Administrator
2. ถ้าระบบไม่อนุญาตให้รันสคริปต์ ให้ใช้คำสั่งนี้เฉพาะ session ปัจจุบัน:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

3. รันสคริปต์:

```powershell
.\Spoof-MAC.ps1
```

4. เลือกการ์ดเครือข่ายที่ต้องการ
5. เลือกเมนูที่ต้องการใช้งาน:

```text
1. Spoof with random MAC
2. Enter custom MAC
3. Restore original MAC
4. Show current MAC only
```

## รูปแบบ MAC Address สำหรับกำหนดเอง

ถ้าต้องการใส่ MAC Address เอง ต้องใช้รูปแบบนี้:

```text
02-1A-2B-3C-4D-5E
```

ระบบสุ่ม MAC Address จะเริ่มต้นด้วย `02` ซึ่งหมายถึง locally administered และ unicast address

## หมายเหตุ

- สคริปต์จะปิดและเปิดการ์ดเครือข่ายที่เลือกใหม่ชั่วคราว
- อินเทอร์เน็ตหรือการเชื่อมต่อเครือข่ายอาจหลุดสั้น ๆ ระหว่างเปลี่ยนค่า
- ไดรเวอร์การ์ดเครือข่ายบางรุ่นอาจไม่รองรับการเปลี่ยน MAC Address หรืออาจต้อง restart เครื่อง
- ควรใช้กับอุปกรณ์และเครือข่ายที่คุณเป็นเจ้าของ หรือได้รับอนุญาตให้จัดการเท่านั้น

## วิธีคืนค่า MAC Address เดิม

รันสคริปต์อีกครั้ง เลือกการ์ดเครือข่ายเดิม แล้วเลือก:

```text
3. Restore original MAC
```

คำสั่งนี้จะลบค่า `NetworkAddress` ใน registry ที่ใช้สำหรับ spoof MAC Address

## License

MIT
