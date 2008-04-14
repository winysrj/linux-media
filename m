Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3E1eaaV009143
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 21:40:36 -0400
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3E1eOih025991
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 21:40:24 -0400
Received: by ug-out-1314.google.com with SMTP id t39so599883ugd.6
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 18:40:24 -0700 (PDT)
Date: Mon, 14 Apr 2008 11:47:46 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: video4linux-list@redhat.com
Message-ID: <20080414114746.3955c089@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: autodetect TEA5767
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

Hi All.

I write some drivers of TV tuners for Linux from Beholder company. I have contract with this company
and of course have all information about products under NDA.

Now I rework v4l code for Beholder Columbus PCMCIA TVtuner. IR remote control add, it works well.

But tea5767 driver can`t detect a FM chip.

saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:07:00.0, rev: 209, irq: 17, latency: 64, mmio: 0x38000000
saa7133[0]: subsystem: 0000:5201, board: Beholder BeholdTV Columbus TVFM [card=128,autodetected]
saa7133[0]: board init: gpio is ac000
saa7133[0]/core: hwinit1
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [pre-init]
input: saa7134 IR (Beholder BeholdTV C as /class/input/input9
saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 20 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 84 >
saa7133[0]: i2c xfer: < 84 00 >
saa7133[0]: i2c xfer: < 85 =8f =8e =8e =8e =8e =8e =8e =8e >
saa7133[0]: i2c xfer: < 84 1f >
saa7133[0]: i2c xfer: < 85 =8e >
saa7133[0]: i2c xfer: < 84 2f >
saa7133[0]: i2c xfer: < 85 =8e >
saa7133[0]: i2c xfer: < 84 01 02 >
saa7133[0]: i2c xfer: < 84 00 00 >
saa7133[0]: i2c xfer: < 84 07 >
saa7133[0]: i2c xfer: < 85 =8e >
saa7133[0]: i2c xfer: < 84 00 d6 30 >
tuner' 1-0042: chip found @ 0x84 (saa7133[0])
tda9887 1-0042: creating new instance
tda9887 1-0042: tda988[5/6/7] found
saa7133[0]: i2c xfer: < 84 00 c0 00 00 >
tuner' i2c attach [addr=0x42,client=tda9887]
saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 96 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c0 >
saa7133[0]: i2c xfer: < c1 =84 =ac =2c =10 =00 =bc =bc >
Returned more than 5 bytes. It is not a TEA5767
tuner' 1-0060: chip found @ 0xc0 (saa7133[0])
tuner' i2c attach [addr=0x60,client=(tuner unset)]
saa7133[0]: i2c xfer: < c1 =04 >
tuner-simple 1-0060: creating new instance
tuner-simple 1-0060: type set to 12 (Alps TSBE5)
saa7133[0]: i2c xfer: < c0 1b 6f 8e 08 >
saa7133[0]: i2c xfer: < c2 >
tuner' 1-0061: chip found @ 0xc2 (saa7133[0])
tuner' i2c attach [addr=0x61,client=(tuner unset)]
saa7133[0]: i2c xfer: < c4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ca ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ce ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d2 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d4 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d6 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d8 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < da ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < dc ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < de ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < a0 00 >
saa7133[0]: i2c xfer: < a1 =00 =00 =01 =52 =54 =20 =00 =00 =00 =00 =00 =00 =00 =00 =00 =01 =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
 =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff 
=42 =54 =56 =30 =35 =30 =30 =ff =ff =ff =ff =ff =ff =ff =ff =ff >
saa7133[0]: i2c eeprom 00: 00 00 01 52 54 20 00 00 00 00 00 00 00 00 00 01
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: 42 54 56 30 35 30 30 ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c xfer: < 01 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 03 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 05 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 07 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 09 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 0b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 0d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 0f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 11 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 13 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 15 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 17 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 19 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 1b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 1d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 1f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 21 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 23 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 25 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 27 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 29 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 2b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 2d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 2f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 31 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 33 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 35 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 37 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 39 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 3b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 3d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 3f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 41 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 43 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 45 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 47 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 49 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 4b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 4d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 4f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 51 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 53 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 55 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 57 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 59 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 5f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 61 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 63 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 65 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 67 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 69 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 6b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 6d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 6f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 71 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 73 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 75 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 77 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 79 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 7b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 7d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 7f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 81 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 83 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 85 >
saa7133[0]: i2c scan: found device @ 0x84  [???]
saa7133[0]: i2c xfer: < 87 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 89 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 8f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 91 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 93 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 95 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 97 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 99 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 9b ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 9d ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 9f ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < a1 >
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: i2c xfer: < a3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < a5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < a7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < a9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ab ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ad ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < af ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < b1 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < b3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < b5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < b7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < b9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < bb ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < bd ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < bf ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c1 >
saa7133[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
saa7133[0]: i2c xfer: < c3 >
saa7133[0]: i2c scan: found device @ 0xc2  [???]
saa7133[0]: i2c xfer: < c5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cb ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cd ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < cf ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d1 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < d9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < db ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < dd ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < df ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e1 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < e9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < eb ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ed ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ef ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < f1 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < f3 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < f5 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < f7 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < f9 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < fb ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < fd ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < ff ERROR: NO_DEVICE
saa7133[0]/core: hwinit2
saa7133[0]: i2c xfer: < c0 1b 6f 8e 08 >
saa7133[0]: i2c xfer: < c0 1b 6f 8e 08 >
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [Television]
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [Television]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [Television]
saa7133[0]: i2c xfer: < 84 00 e0 00 00 >
saa7133[0]: i2c xfer: < c0 1b 6f 8e 08 >
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [Television]
saa7133[0]: i2c xfer: < 84 00 e0 00 00 >
saa7133[0]: i2c xfer: < c0 1b 6f 8e 08 >
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8004 [Television]
saa7133[0]: i2c xfer: < 84 00 e0 00 00 >
saa7133[0]: gpio: mode=0x00a8004 in=0x0004000 out=0x00a8000 [Radio]
saa7133[0]: i2c xfer: < c0 07 ac 88 a4 >
saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
tda9887 1-0042: i2c i/o error: rc == -5 (should be 4)
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0x38000000 irq 17 registered as card -1

Notice message about FM is

saa7133[0]: i2c xfer: < c0 >
saa7133[0]: i2c xfer: < c1 =84 =ac =2c =10 =00 =bc =bc >
Returned more than 5 bytes. It is not a TEA5767

How to I can determine what happens???

With my best regards, Dmitry.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
