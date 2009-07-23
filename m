Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f212.google.com ([209.85.219.212])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <fonta72@gmail.com>) id 1MU363-00028t-Ds
	for linux-dvb@linuxtv.org; Thu, 23 Jul 2009 20:32:53 +0200
Received: by ewy8 with SMTP id 8so1204169ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 23 Jul 2009 11:32:17 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 23 Jul 2009 20:32:17 +0200
Message-ID: <bb6641fe0907231132g3e744632x181fc44910f35ecf@mail.gmail.com>
From: Angelo Fontana <fonta72@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  DVB-T support for Pinnacle PCTV Hybrid Pro Stick
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
I'm trying to use my USB PTCV with linux (Debian Lenny).
After compiling, installing the latest version of v4l-dvb drivers and
loading em28xx-dvb module i can't use DVB features of the device.

This is the output of dmesg:

------------------------------------------------
fontang@debian:~/devel$ dmesg |=A0 tail -n 62
[=A0 757.093719] Linux video capture interface: v2.00
[=A0 757.217000] usbcore: registered new interface driver em28xx
[=A0 757.217011] em28xx driver loaded
[=A0 757.246117] Em28xx: Initialized (Em28xx dvb Extension) extension
[=A0 867.356460] usb 4-5.2: new high speed USB device using ehci_hcd and ad=
dress 4
[=A0 867.456523] usb 4-5.2: configuration #1 chosen from 1 choice
[=A0 867.458803] em28xx: New device Pinnacle Systems PCTV 330e @ 480
Mbps (2304:0226, interface 0, class 0)
[=A0 867.458835] em28xx #0: Identified as Pinnacle Hybrid Pro (2) (card=3D5=
6)
[=A0 867.459482] em28xx #0: chip ID is em2882/em2883
[=A0 867.642402] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 26 02 d0 12
5c 03 8e 16 a4 1c
[=A0 867.642418] em28xx #0: i2c eeprom 10: 6a 24 27 57 46 07 01 00 00 00
00 00 00 00 00 00
[=A0 867.642427] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 02 00 b8 00
00 00 5b e0 00 00
[=A0 867.642435] em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01
00 00 00 00 00 00
[=A0 867.642443] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642451] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642458] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
24 03 50 00 69 00
[=A0 867.642466] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00
65 00 20 00 53 00
[=A0 867.642474] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00
73 00 00 00 16 03
[=A0 867.642482] em28xx #0: i2c eeprom 90: 50 00 43 00 54 00 56 00 20 00
33 00 33 00 30 00
[=A0 867.642490] em28xx #0: i2c eeprom a0: 65 00 00 00 1c 03 30 00 37 00
30 00 34 00 30 00
[=A0 867.642498] em28xx #0: i2c eeprom b0: 31 00 38 00 38 00 33 00 38 00
35 00 38 00 00 00
[=A0 867.642506] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642514] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642522] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642530] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[=A0 867.642540] em28xx #0: EEPROM ID=3D 0x9567eb1a, EEPROM hash =3D 0xfab3=
a3bf
[=A0 867.642542] em28xx #0: EEPROM info:
[=A0 867.642544] em28xx #0:=A0=A0=A0 AC97 audio (5 sample rates)
[=A0 867.642546] em28xx #0:=A0=A0=A0 500mA max power
[=A0 867.642549] em28xx #0:=A0=A0=A0 Table at 0x27, strings=3D0x168e, 0x1ca=
4, 0x246a
[=A0 867.642554] em28xx #0:
[=A0 867.642555]
[=A0 867.642560] em28xx #0: The support for this board weren't valid yet.
[=A0 867.642563] em28xx #0: Please send a report of having this working
[=A0 867.642565] em28xx #0: not to V4L mailing list (and/or to other addres=
ses)
[=A0 867.642567]
[=A0 867.674478] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
[=A0 867.696840] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
[=A0 867.761130] xc2028 1-0061: creating new instance
[=A0 867.761142] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[=A0 867.761158] firmware: requesting xc3028-v27.fw
[=A0 867.852898] xc2028 1-0061: Loading 80 firmware images from
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[=A0 867.900375] xc2028 1-0061: Loading firmware for type=3DBASE MTS (5),
id 0000000000000000.
[=A0 868.328337] usb 4-5.4: reset low speed USB device using ehci_hcd
and address 3
[=A0 868.833424] xc2028 1-0061: Loading firmware for type=3DMTS (4), id
000000000000b700.
[=A0 868.848556] xc2028 1-0061: Loading SCODE for type=3DMTS LCD NOGD MONO
IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.
[=A0 869.032445] em28xx #0: Config register raw data: 0xd0
[=A0 869.033538] em28xx #0: AC97 vendor ID =3D 0xffffffff
[=A0 869.034037] em28xx #0: AC97 features =3D 0x6a90
[=A0 869.034052] em28xx #0: Empia 202 AC97 audio processor detected
[=A0 869.164527] tvp5150 1-005c: tvp5150am1 detected.
[=A0 869.261040] em28xx #0: v4l2 driver version 0.1.2
[=A0 869.380422] em28xx #0: V4L2 device registered as /dev/video0 and /dev/=
vbi0
[=A0 869.396451] usb 4-5.2: New USB device found, idVendor=3D2304, idProduc=
t=3D0226
[=A0 869.396474] usb 4-5.2: New USB device strings: Mfr=3D3, Product=3D1,
SerialNumber=3D2
[=A0 869.396486] usb 4-5.2: Product: PCTV 330e
[=A0 869.396494] usb 4-5.2: Manufacturer: Pinnacle Systems
[=A0 869.396502] usb 4-5.2: SerialNumber: 070401883858
[=A0 869.449285] em28xx-audio.c: probing for em28x1 non standard usbaudio
[=A0 869.449295] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[=A0 869.449643] Em28xx: Initialized (Em28xx Audio Extension) extension
[=A0 869.680595] tvp5150 1-005c: tvp5150am1 detected.

------------------------------------------------

dmesg says that this device is not yet supported but it is present in
the list of supported DVBT USB devices
(http://www.linuxtv.org/wiki/index.php/DVB-T_USB_Devices).

The analog part of the device works properly.

Something wrong in my configuration?
Is there any plan for a support of Pinnacle PCTV Hybrid Stick Pro in linux?

Thanks and regards.
Angelo Fontana.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
