Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <zhuyu87@gmail.com>) id 1OkYpi-0002bD-LU
	for linux-dvb@linuxtv.org; Sun, 15 Aug 2010 10:44:48 +0200
Received: from mail-vw0-f54.google.com ([209.85.212.54])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-c) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OkYph-0004MY-3k; Sun, 15 Aug 2010 10:44:46 +0200
Received: by vws7 with SMTP id 7so3412986vws.41
	for <linux-dvb@linuxtv.org>; Sun, 15 Aug 2010 01:44:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 15 Aug 2010 16:44:44 +0800
Message-ID: <AANLkTik6Z-uxE-a66LEE0kffX+dcSNMJwgOUZ2808CMx@mail.gmail.com>
From: zhu yu <zhuyu87@gmail.com>
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary=0016e6464ec4403ff0048dd8ba97
Subject: [linux-dvb] em28xx device problem (idVendor=1578, idProduct=800c)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: Mauro Carvalho Chehab <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--0016e6464ec4403ff0048dd8ba97
Content-Type: multipart/alternative; boundary=0016e6464ec4403fe6048dd8ba95

--0016e6464ec4403fe6048dd8ba95
Content-Type: text/plain; charset=ISO-8859-1

HI,
I have a em28xx based device (Huaqi DLCW-130), after modify em28xx-card.c to
add the device 1578:800c, it's succeed to find "video0" file at /dev/ . and
succeed to capture picture with "cheese" webcam software,  it works well in
320*256, but when the resolution sets to 512*408, there are some green
stripes on the picture, and it gets to be worse when set higher.

for example
512 * 408    2010-08-15-164347.jpg

[80340.339028] usb 1-8: new high speed USB device using ehci_hcd and address
11
[80340.458032] usb 1-8: New USB device found, idVendor=1578, idProduct=800c

[80340.458044] usb 1-8: New USB device strings: Mfr=0, Product=1,
SerialNumber=0
[80340.458054] usb 1-8: Product: HuaQi Digital Lab DL-800C

[80340.458181] usb 1-8: configuration #1 chosen from 1 choice

[80340.458345] em28xx: New device HuaQi Digital Lab DL-800C @ 480 Mbps
(1578:800c, interface 0, class 0)

[80340.458457] em28xx #0: chip ID is em2870

[80340.533907] em28xx #0: i2c eeprom 00: 1a eb 67 95 78 15 0c 80 00 00 11 00
6a 36 00 00
[80340.533937] em28xx #0: i2c eeprom 10: 00 00 04 57 82 00 00 00 00 00 00 00
00 00 00 00
[80340.533963] em28xx #0: i2c eeprom 20: 01 00 00 01 f0 10 00 00 00 00 00 00
5b 00 00 00
[80340.533987] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00
00 00 00 00
[80340.534025] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
ff ff ff ff
[80340.534058] em28xx #0: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff
[80340.534089] em28xx #0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 36 03
48 00 75 00
[80340.534122] em28xx #0: i2c eeprom 70: 61 00 51 00 69 00 20 00 44 00 69 00
67 00 69 00
[80340.534155] em28xx #0: i2c eeprom 80: 74 00 61 00 6c 00 20 00 4c 00 61 00
62 00 20 00
[80340.534185] em28xx #0: i2c eeprom 90: 44 00 4c 00 2d 00 38 00 30 00 30 00
43 00 00 00
[80340.534210] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534235] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534260] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534289] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534322] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534354] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[80340.534389] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb938d5df
[80340.534398] em28xx #0: EEPROM info:
[80340.534404] em28xx #0:       No audio on board.
[80340.534410] em28xx #0:       500mA max power
[80340.534417] em28xx #0:       Table at 0x04, strings=0x366a, 0x0000,
0x0000
[80340.621015] em28xx #0: Sensor is mt9m001, using model
EM2710/EM2750/EM2751 webcam grabber entry.
[80340.621028] em28xx #0: Identified as EM2710/EM2750/EM2751 webcam grabber
(card=22)
[80340.621039] em28xx #0: v4l2 driver version 0.1.2
[80340.625721] em28xx #0: V4L2 video device registered as video0

Anyone have some idea?
Thank you!

Regards

--0016e6464ec4403fe6048dd8ba95
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<span class=3D"Apple-style-span" style=3D"font-family: arial, sans-serif; f=
ont-size: 13px; border-collapse: collapse; ">HI,<div>I have a em28xx based =
device (Huaqi DLCW-130), after modify em28xx-card.c to add the device 1578:=
800c, it&#39;s succeed to find &quot;video0&quot; file at /dev/ . and succe=
ed to capture picture with &quot;cheese&quot; webcam software, =A0it works =
well in 320*256, but when the resolution sets to 512*408, there are some gr=
een stripes on the picture, and it gets to be worse when set higher.</div>
<div><br></div><div>for example</div><div>512 * 408 =A0 =A02010-08-15-16434=
7.jpg =A0</div>
<div><br></div><div><div>[80340.339028] usb 1-8: new high speed USB device =
using ehci_hcd and address 11 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0</div><div>[80340.458032] usb 1-8: New USB device found, idVendor=3D1578=
, idProduct=3D800c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0<=
/div>
<div>[80340.458044] usb 1-8: New USB device strings: Mfr=3D0, Product=3D1, =
SerialNumber=3D0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0</div><div>[=
80340.458054] usb 1-8: Product: HuaQi Digital Lab DL-800C =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0<=
/div>
<div>[80340.458181] usb 1-8: configuration #1 chosen from 1 choice =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
</div><div>[80340.458345] em28xx: New device HuaQi Digital Lab DL-800C @ 48=
0 Mbps (1578:800c, interface 0, class 0) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0</div>
<div>[80340.458457] em28xx #0: chip ID is em2870 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0</div><div>[80340.533907] em28xx #0: i2c eeprom 00: 1a =
eb 67 95 78 15 0c 80 00 00 11 00 6a 36 00 00 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=
</div>
<div>[80340.533937] em28xx #0: i2c eeprom 10: 00 00 04 57 82 00 00 00 00 00=
 00 00 00 00 00 00 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0</div><div>[80340.533963] =
em28xx #0: i2c eeprom 20: 01 00 00 01 f0 10 00 00 00 00 00 00 5b 00 00 00</=
div><div>[80340.533987] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 0=
1 01 00 00 00 00 00 00</div>
<div>[80340.534025] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00=
 00 00 ff ff ff ff</div><div>[80340.534058] em28xx #0: i2c eeprom 50: ff ff=
 ff ff ff ff ff ff ff ff ff ff ff ff ff ff</div><div>[80340.534089] em28xx =
#0: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 36 03 48 00 75 00</div>
<div>[80340.534122] em28xx #0: i2c eeprom 70: 61 00 51 00 69 00 20 00 44 00=
 69 00 67 00 69 00</div><div>[80340.534155] em28xx #0: i2c eeprom 80: 74 00=
 61 00 6c 00 20 00 4c 00 61 00 62 00 20 00</div><div>[80340.534185] em28xx =
#0: i2c eeprom 90: 44 00 4c 00 2d 00 38 00 30 00 30 00 43 00 00 00</div>
<div>[80340.534210] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00</div><div>[80340.534235] em28xx #0: i2c eeprom b0: 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00</div><div>[80340.534260] em28xx =
#0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00</div>
<div>[80340.534289] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00</div><div>[80340.534322] em28xx #0: i2c eeprom e0: 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00</div><div>[80340.534354] em28xx =
#0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00</div>
<div>[80340.534389] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0xb=
938d5df</div><div>[80340.534398] em28xx #0: EEPROM info:</div><div>[80340.5=
34404] em28xx #0: =A0 =A0 =A0 No audio on board.</div><div>[80340.534410] e=
m28xx #0: =A0 =A0 =A0 500mA max power</div>
<div>[80340.534417] em28xx #0: =A0 =A0 =A0 Table at 0x04, strings=3D0x366a,=
 0x0000, 0x0000</div><div>[80340.621015] em28xx #0: Sensor is mt9m001, usin=
g model EM2710/EM2750/EM2751 webcam grabber entry.</div><div>[80340.621028]=
 em28xx #0: Identified as EM2710/EM2750/EM2751 webcam grabber (card=3D22)</=
div>
<div>[80340.621039] em28xx #0: v4l2 driver version 0.1.2</div><div>[80340.6=
25721] em28xx #0: V4L2 video device registered as video0</div><div><br></di=
v><div><font face=3D"Verdana, Georgia, serif" size=3D"4"><span style=3D"fon=
t-size: 14px; ">Anyone have some idea?</span></font></div>
<div><font face=3D"Verdana, Georgia, serif" size=3D"4"><span style=3D"font-=
size: 14px; ">Thank you!</span></font></div><div><font face=3D"Verdana, Geo=
rgia, serif" size=3D"4"><span style=3D"font-size: 14px; "><br></span></font=
></div><div>
<font face=3D"Verdana, Georgia, serif" size=3D"4"><span style=3D"font-size:=
 14px; ">Regards</span></font></div></div></span>

--0016e6464ec4403fe6048dd8ba95--

--0016e6464ec4403ff0048dd8ba97
Content-Type: image/jpeg; name="2010-08-15-164347.jpg"
Content-Disposition: attachment; filename="2010-08-15-164347.jpg"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gcvngfmj0

/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0a
HBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAGYAgADASIA
AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwDjlm0h
Gysi5H+9/wDEUkraNK5Lum4nOQWB/RKxfsk47A/Q00wTg/6s15n1V9Zy+88dYL/p5L7zTnj0VYi6
AyMOQolcZ591qv5tl2sn/G4P/wATVPZKOqN+VLlh1BFXGgoqzk382aQwsYqzlJ+rf6WLnnWYz/oL
kd8XP/2NILmzB/5B0oHqJ8/+y1V34pN+O9V7GL6v73/mX9Xh3f8A4E/8y+biw4zZS+3+kf8A2NPN
xpu3D2M27/r4A/8AZazw/HSnbg3UA+maPYx7v73/AJi+rQ8//Apf5i3DQF90KtGpxhGO4j8aRGZR
w/5GjYjdV/KgQp1DEfjWq0VjZKysi7Zapf2EgltLyeBx/FHIVP5g10Nh8RvFNi4MerXMvtO3m5/7
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
tbMATtPSiinzMLu5/9k=
--0016e6464ec4403ff0048dd8ba97
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--0016e6464ec4403ff0048dd8ba97--
