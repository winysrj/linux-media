Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n51I6xFZ000713
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 14:06:59 -0400
Received: from mail-bw0-f218.google.com (mail-bw0-f218.google.com
	[209.85.218.218])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n51I5Hi9013239
	for <video4linux-list@redhat.com>; Mon, 1 Jun 2009 14:05:18 -0400
Received: by bwz18 with SMTP id 18so7535491bwz.3
	for <video4linux-list@redhat.com>; Mon, 01 Jun 2009 11:05:17 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Jun 2009 20:05:17 +0200
Message-ID: <745af8a00906011105x7a69b478obbab7c738aaa9e06@mail.gmail.com>
From: S P <xmisterhu@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: saa7134 surveillance
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

Hi!
I have a surveillance card with saa7134 chips. It should be able to
see 8 cameras at a time, but there is only 4 video devices in /dev of
this card.
These devices are working fine, each device's channel 0(there isn't
any other channel of these devices) is an input for a camera.
So, how could I manage it to be 8 devices?

dmesg:

[  974.780280] saa7130/34: v4l2 driver version 0.2.14 loaded
[  974.780324] saa7134[0]: found at 0000:02:08.0, rev: 1, irq: 17,
latency: 16, mmio: 0xfdeff000
[  974.780329] saa7134[0]: subsystem: 17de:0001, board:
UNKNOWN/GENERIC [card=0,autodetected]
[  974.780373] saa7134[0]: board init: gpio is e210000
[  974.925203] ir-kbd-i2c: i2c IR (KNC One) detected at
i2c-2/2-0030/ir0 [saa7134[0]]
[  974.981054] saa7134[0]: i2c eeprom 00: de 17 01 00 10 a0 ff ff ff
ff ff ff ff ff ff ff
[  974.981060] saa7134[0]: i2c eeprom 10: 24 ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981065] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981069] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981074] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981078] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981083] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981087] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981091] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981096] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981100] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981105] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981109] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981114] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981118] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981123] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  974.981420] saa7134[0]: registered device video1 [v4l2]
[  974.982805] saa7134[0]: registered device vbi0
[  974.982834] saa7134[1]: found at 0000:02:09.0, rev: 1, irq: 18,
latency: 16, mmio: 0xfdefe000
[  974.982839] saa7134[1]: subsystem: 17de:0002, board:
UNKNOWN/GENERIC [card=0,autodetected]
[  974.982863] saa7134[1]: board init: gpio is c010000
[  975.140024] saa7134[1]: i2c eeprom 00: de 17 02 00 10 a0 ff ff ff
ff ff ff ff ff ff ff
[  975.140030] saa7134[1]: i2c eeprom 10: 24 ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140035] saa7134[1]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140039] saa7134[1]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140044] saa7134[1]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140048] saa7134[1]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140053] saa7134[1]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140057] saa7134[1]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140061] saa7134[1]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140066] saa7134[1]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140070] saa7134[1]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140075] saa7134[1]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140080] saa7134[1]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140084] saa7134[1]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140089] saa7134[1]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140093] saa7134[1]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.140342] saa7134[1]: registered device video2 [v4l2]
[  975.143230] saa7134[1]: registered device vbi1
[  975.143260] saa7134[2]: found at 0000:02:0a.0, rev: 1, irq: 19,
latency: 16, mmio: 0xfdefd000
[  975.143266] saa7134[2]: subsystem: 17de:0003, board:
UNKNOWN/GENERIC [card=0,autodetected]
[  975.143292] saa7134[2]: board init: gpio is 10000
[  975.300023] saa7134[2]: i2c eeprom 00: de 17 03 00 10 a0 ff ff ff
ff ff ff ff ff ff ff
[  975.300029] saa7134[2]: i2c eeprom 10: 24 ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300034] saa7134[2]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300039] saa7134[2]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300043] saa7134[2]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300047] saa7134[2]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300052] saa7134[2]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300056] saa7134[2]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300061] saa7134[2]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300065] saa7134[2]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300070] saa7134[2]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300074] saa7134[2]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300079] saa7134[2]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300083] saa7134[2]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300088] saa7134[2]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300092] saa7134[2]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.300363] saa7134[2]: registered device video3 [v4l2]
[  975.303173] saa7134[2]: registered device vbi2
[  975.303204] saa7134[3]: found at 0000:02:0b.0, rev: 1, irq: 16,
latency: 16, mmio: 0xfdefc000
[  975.303209] saa7134[3]: subsystem: 17de:0004, board:
UNKNOWN/GENERIC [card=0,autodetected]
[  975.303238] saa7134[3]: board init: gpio is 10000
[  975.460023] saa7134[3]: i2c eeprom 00: de 17 04 00 10 a0 ff ff ff
ff ff ff ff ff ff ff
[  975.460028] saa7134[3]: i2c eeprom 10: 24 ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460033] saa7134[3]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460038] saa7134[3]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460042] saa7134[3]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460047] saa7134[3]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460051] saa7134[3]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460056] saa7134[3]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460060] saa7134[3]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460065] saa7134[3]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460069] saa7134[3]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460074] saa7134[3]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460078] saa7134[3]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460083] saa7134[3]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460087] saa7134[3]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460092] saa7134[3]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff ff
[  975.460363] saa7134[3]: registered device video4 [v4l2]
[  975.462513] saa7134[3]: registered device vbi3
[  975.534948] saa7134 ALSA driver for DMA sound loaded
[  975.534972] saa7134[0]/alsa: saa7134[0] at 0xfdeff000 irq 17
registered as card -2
[  975.535185] saa7134[1]/alsa: saa7134[1] at 0xfdefe000 irq 18
registered as card -1
[  975.535364] saa7134[2]/alsa: saa7134[2] at 0xfdefd000 irq 19
registered as card -1
[  975.535544] saa7134[3]/alsa: saa7134[3] at 0xfdefc000 irq 16
registered as card -1

Regards, Peter Sarkozi

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
