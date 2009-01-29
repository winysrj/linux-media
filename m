Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0TBeewc012219
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 06:40:40 -0500
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.190])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0TBeOsB008668
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 06:40:25 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1424114nfc.21
	for <video4linux-list@redhat.com>; Thu, 29 Jan 2009 03:40:24 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 08:40:24 -0300
Message-ID: <255e9dee0901290340l1939ff25gdfa8ee20638671d0@mail.gmail.com>
From: "guindous (el Seba)" <guindous@cardello.com.ar>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Subject: =?windows-1252?q?Pinnacle_PCTV_Pro_110i_remote_=93read_error=94?=
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

Hi list!! My name is Sebastian from Mendoza, Argentina. And I'm
looking for some help, please.

I bought a Pinnacle PCTV Pro 110i and i'm building my own MythTV
set-top-box using Mythbuntu 8.10. Everything went smoothly with this
saa7134 analog card (video and dma sound – I haven't tried the radio,
yet-)  until the IR. The remote didn't worked. I don't get any event
when I press the buttons.

Like the wiki page says I load the saa7134 and the ir-kbd-i2c modules.
And It looks like that the control it's detected, but when I push the
buttons syslog shows (using  "modprobe saa7134 ir_debug=1"):

Jan 27 20:35:07 nena kernel: [  308.916687] Pinnacle PCTV/ir: read error
Jan 27 20:35:07 nena kernel: [  309.016684] Pinnacle PCTV/ir: read error
Jan 27 20:35:07 nena kernel: [  309.116671] Pinnacle PCTV/ir: read error

Then activating the i2c_debug module option (and pressing buttons):

Jan 27 20:36:07 nena kernel: [  368.232017] saa7133[0]: i2c xfer: < 8f
ERROR: NO_DEVICE
Jan 27 20:36:07 nena kernel: [  368.232167] Pinnacle PCTV/ir: read error

More information about the setup:

- Distro
Mythbuntu Linux 8.10

- Uname
Linux nena 2.6.27-9-generic #1 SMP Thu Nov 20 22:15:32 UTC 2008 x86_64 GNU/Linux

- lsinput
/dev/input/event6
 bustype : BUS_I2C
 vendor  : 0x0
 product : 0x0
 version : 0
 name    : "Pinnacle PCTV"
 phys    : "i2c-1/1-0047/ir0"
 bits ev : EV_SYN EV_KEY EV_REP

- Remote version
RC-42D (picture at:
http://lirc.sourceforge.net/remotes/pinnacle_systems/RC-42D.jpg).

- V4L2 Driver device info (modprobe ir-kbd-i2c saa7134 saa7134-alsa)
Jan 27 20:34:59 nena kernel: [  300.555041] saa7130/34: v4l2 driver
version 0.2.14 loaded
Jan 27 20:34:59 nena kernel: [  300.555103] saa7133[0]: found at
0000:03:07.0, rev: 209, irq: 21, latency: 32, mmio: 0xfdcff000
Jan 27 20:34:59 nena kernel: [  300.555111] saa7133[0]: subsystem:
11bd:002e, board: Pinnacle PCTV 40i/50i/110i (saa7133)
[card=77,autodetected]
Jan 27 20:34:59 nena kernel: [  300.555123] saa7133[0]: board init:
gpio is 200c000
Jan 27 20:34:59 nena kernel: [  300.700102] tuner' 1-004b: chip found
@ 0x96 (saa7133[0])
Jan 27 20:34:59 nena kernel: [  300.702652] ir-kbd-i2c: probe 0x7a @
saa7133[0]: no
Jan 27 20:34:59 nena kernel: [  300.708016] ir-kbd-i2c: probe 0x47 @
saa7133[0]: yes
Jan 27 20:34:59 nena kernel: [  300.708758] input: Pinnacle PCTV as
/devices/virtual/input/input6
Jan 27 20:34:59 nena kernel: [  300.749258] ir-kbd-i2c: Pinnacle PCTV
detected at i2c-1/1-0047/ir0 [saa7133[0]]
Jan 27 20:34:59 nena kernel: [  300.808537] saa7133[0]: i2c eeprom 00:
bd 11 2e 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Jan 27 20:34:59 nena kernel: [  300.808546] saa7133[0]: i2c eeprom 10:
ff e0 60 02 ff 20 ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808552] saa7133[0]: i2c eeprom 20:
01 2c 01 23 23 01 04 30 98 ff 00 e2 ff 22 00 c2
Jan 27 20:34:59 nena kernel: [  300.808557] saa7133[0]: i2c eeprom 30:
96 ff 03 30 15 01 ff 15 0e 6c a3 ea 03 d3 aa d1
Jan 27 20:34:59 nena kernel: [  300.808562] saa7133[0]: i2c eeprom 40:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808567] saa7133[0]: i2c eeprom 50:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808572] saa7133[0]: i2c eeprom 60:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808578] saa7133[0]: i2c eeprom 70:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808583] saa7133[0]: i2c eeprom 80:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808588] saa7133[0]: i2c eeprom 90:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808596] saa7133[0]: i2c eeprom a0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808601] saa7133[0]: i2c eeprom b0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808606] saa7133[0]: i2c eeprom c0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808611] saa7133[0]: i2c eeprom d0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808617] saa7133[0]: i2c eeprom e0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.808623] saa7133[0]: i2c eeprom f0:
ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Jan 27 20:34:59 nena kernel: [  300.892518] tda829x 1-004b: setting
tuner address to 61
Jan 27 20:34:59 nena kernel: [  300.956515] tda829x 1-004b: type set
to tda8290+75a
Jan 27 20:35:03 nena kernel: [  304.821026] saa7133[0]: registered
device video0 [v4l2]
Jan 27 20:35:03 nena kernel: [  304.821784] saa7133[0]: registered device vbi0
Jan 27 20:35:03 nena kernel: [  304.823561] saa7133[0]: registered device radio0
Jan 27 20:35:03 nena kernel: [  304.896605] saa7134 ALSA driver for
DMA sound loaded
Jan 27 20:35:03 nena kernel: [  304.897441] saa7133[0]/alsa:
saa7133[0] at 0xfdcff000 irq 21 registered as card -2

If anybody need more information about this problem, I will be glad helping.

--
guindous
(Sebastian)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
