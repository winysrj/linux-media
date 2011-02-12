Return-path: <mchehab@pedra>
Received: from web30304.mail.mud.yahoo.com ([209.191.69.66]:32328 "HELO
	web30304.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752411Ab1BLU3O convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Feb 2011 15:29:14 -0500
Message-ID: <713442.91420.qm@web30304.mail.mud.yahoo.com>
Date: Sat, 12 Feb 2011 12:22:32 -0800 (PST)
From: AW <arne_woerner@yahoo.com>
Subject: PCTV USB2 PAL / adds loud hum to correct audio
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi!

When I try to use my new USB TV tuner on Fedora 14 (log messages: in the end) 
with this:
mplayer -tv 
driver=v4l2:input=0:width=768:height=576:device=/dev/video2:norm=5:chanlist=europe-west:freq=224.25 tv://

I hear nothing, but I c good pictures...


When I use this command simultaneously:
arecord -D front:CARD=PAL,DEV=0 -f S16_LE -c 2 -r 8000 /aux/tmp/bla.wav
I get correct audio with strong noise:
http://www.wgboome.de./bla.wav
(it is from input=1 for copyright reasons... so there is silence plus noise)

according to "amixer -c1" (card 0 is the audio device on the mainboard and is 
handled by pulseaudio) the PCTV 

audio device has mono audio:
Simple mixer control 'Line',0
  Capabilities: cvolume cvolume-joined cswitch cswitch-joined penum
  Capture channels: Mono
  Limits: Capture 0 - 16
  Mono: Capture 8 [50%] [0.00dB] [on]

but arecord wants "-c2"...

when i add hw:1 as 2nd source to pulseaudio, i get the same result...

Why is that?

Thx.

Bye
Arne

attachment:
usb 1-1: new high speed USB device using ehci_hcd and address 12
usb 1-1: New USB device found, idVendor=2304, idProduct=0208
usb 1-1: New USB device strings: Mfr=2, Product=1, SerialNumber=0
usb 1-1: Product: PCTV USB2 PAL
usb 1-1: Manufacturer: Pinnacle Systems GmbH 
em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @ 480 Mbps (2304:0208, 
interface 0, class 0) 
em28xx #0: chip ID is em2820 (or em2710)
em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 08 02 10 00 1e 03 98 1e 6a 2e 
em28xx #0: i2c eeprom 10: 00 00 06 57 6e 00 00 00 8e 00 00 00 07 00 00 00 
em28xx #0: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 00 00 00 00 
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2e 03 50 00 69 00 
em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00 65 00 20 00 53 00 
em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00 73 00 20 00 47 00 
em28xx #0: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03 50 00 43 00 54 00 
em28xx #0: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00 32 00 20 00 50 00 
em28xx #0: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 0e 5d 62 35 03 ca 7b f3 
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x7623b74b
em28xx #0: EEPROM info:
em28xx #0: AC97 audio (5 sample rates)
em28xx #0: 500mA max power
em28xx #0: Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
em28xx #0: Identified as Pinnacle PCTV USB 2 (card=3)
saa7115 7-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
tda8290_probe: tda8290 couldn't read register 0x1f
tda8295_probe: tda8290 couldn't read register 0x2f
tuner 7-0043: chip found @ 0x86 (em28xx #0)
tda9887 7-0043: creating new instance
tda9887 7-0043: tda988[5/6/7] found
tuner 7-0063: chip found @ 0xc6 (em28xx #0)
tuner-simple 7-0063: creating new instance
tuner-simple 7-0063: type set to 37 (LG PAL (newer TAPC series))
em28xx #0: Config register raw data: 0x10
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as video2



