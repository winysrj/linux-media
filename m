Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9CKi8s0022390
	for <video4linux-list@redhat.com>; Mon, 12 Oct 2009 16:44:08 -0400
Received: from mail-yx0-f200.google.com (mail-yx0-f200.google.com
	[209.85.210.200])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9CKhwGG029253
	for <video4linux-list@redhat.com>; Mon, 12 Oct 2009 16:43:58 -0400
Received: by yxe38 with SMTP id 38so36745281yxe.6
	for <video4linux-list@redhat.com>; Mon, 12 Oct 2009 13:43:57 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 12 Oct 2009 17:43:57 -0300
Message-ID: <f326ee1a0910121343l7770bc0dgec036e952e04b85f@mail.gmail.com>
From: =?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Subject: Kworld Analog TV 305U without audio
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi...

I'm testing a USB TV "*Kworld PlusTV Analog TV stick VS-PVR-TV 305U*" the TV
video works fine, but without audio...
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
I tried to pipe the audio via sox:
*tvtime -d /dev/video1 & sox -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp*
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
But without sucess, sox report follow error:
*Input File     : '/dev/dsp1' (ossdsp)
Channels       : 2
Sample Rate    : 48000
Precision      : 16-bit
Sample Encoding: 16-bit Signed Integer PCM

In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]
Clip:0    sox sox: /dev/dsp1: lsx_readbuf: Input/output error
In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]
Clip:0
Done.*
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Follow my dmesg:
*[   55.556050] usb 1-1: new high speed USB device using ehci_hcd and
address 5
[   55.710766] usb 1-1: configuration #1 chosen from 1 choice
[   55.858949] em28xx v4l2 driver version 0.1.0 loaded
[   55.879514] em28xx new video device (eb1a:e305): interface 0, class 255
[   55.879522] em28xx Doesn't have usb audio class
[   55.879524] em28xx #0: Alternate settings: 8
[   55.879527] em28xx #0: Alternate setting 0, max size= 0
[   55.879529] em28xx #0: Alternate setting 1, max size= 0
[   55.879531] em28xx #0: Alternate setting 2, max size= 1448
[   55.879533] em28xx #0: Alternate setting 3, max size= 2048
[   55.879536] em28xx #0: Alternate setting 4, max size= 2304
[   55.879538] em28xx #0: Alternate setting 5, max size= 2580
[   55.879540] em28xx #0: Alternate setting 6, max size= 2892
[   55.879542] em28xx #0: Alternate setting 7, max size= 3072
[   55.879821] em28xx #0: chip ID is em2860
[   56.238141] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 05 e3 d0 00 5c 00
6a 22 00 00
[   56.238150] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 00 00 00 00
00 00 00 00
[   56.238158] em28xx #0: i2c eeprom 20: 06 00 01 00 f0 10 01 00 00 00 00 00
5b 00 00 00
[   56.238166] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00
00 00 00 00
[   56.238173] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238180] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238187] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03
55 00 53 00
[   56.238194] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00
20 00 44 00
[   56.238202] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
00 00 00 00
[   56.238209] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238216] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238223] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238230] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238237] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238244] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238251] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[   56.238260] EEPROM ID= 0x9567eb1a, hash = 0x28a51142
[   56.238262] Vendor/Product ID= eb1a:e305
[   56.238264] AC97 audio (5 sample rates)
[   56.238265] 500mA max power
[   56.238267] Table at 0x04, strings=0x226a, 0x0000, 0x0000
[   56.238270] em28xx #0:
[   56.238271]
[   56.238274] em28xx #0: The support for this board weren't valid yet.
[   56.238276] em28xx #0: Please send a report of having this working
[   56.238278] em28xx #0: not to V4L mailing list (and/or to other
addresses)
[   56.238280]
[   56.293417] tuner' 1-0061: chip found @ 0xc2 (em28xx #0)
[   56.337047] xc2028 1-0061: creating new instance
[   56.337052] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[   56.337064] i2c-adapter i2c-1: firmware: requesting xc3028-v27.fw
[   56.392257] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
type: xc2028 firmware, ver 2.7
[   56.392370] xc2028 1-0061: Loading firmware for type=BASE (1), id
0000000000000000.
[   72.884040] xc2028 1-0061: Loading firmware for type=(0), id
000000000000b700.
[   73.220037] SCODE (20000000), id 000000000000b700:
[   73.220045] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
(60008000), id 0000000000008000.
[   73.836481] tvp5150 1-005c: tvp5150am1 detected.
[   76.492211] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi0
[   76.492215] em28xx #0: Found KWorld DVB-T 305U
[   76.492236] em28xx new video device (eb1a:e305): interface 1, class 255
[   76.492240] em28xx probing error: endpoint is non-ISO endpoint!
[   76.492272] usbcore: registered new interface driver em28xx
[   76.534297] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   76.534301] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[   76.534579] Em28xx: Initialized (Em28xx Audio Extension) extension
[   76.588480] tvp5150 1-005c: tvp5150am1 detected.*
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Anyone have any idea what might be happening?

Thanks.

Denis Goes
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
