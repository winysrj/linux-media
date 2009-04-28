Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3S7W35s005851
	for <video4linux-list@redhat.com>; Tue, 28 Apr 2009 03:32:03 -0400
Received: from mail.aktivi.hu (mail.aktivi.hu [212.40.127.10])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n3S7Vmtc004960
	for <video4linux-list@redhat.com>; Tue, 28 Apr 2009 03:31:49 -0400
Message-ID: <49F6B0E2.7080902@freemail.hu>
Date: Tue, 28 Apr 2009 09:31:46 +0200
From: =?ISO-8859-2?Q?Kasz=E1s_Ferenc?= <apoth@freemail.hu>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Leadtek WinFast tv2100 - saa7134 sound problem
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

Hi Everybody!
I have a Leadtek WinFast tv2100 tuner, this uses the saa7134 module. 
Firstly i tried to use the generic settings. With these setting i have 
no television source, just a "generic" source, with black screen. Then i 
tried to search with Google, but unfortunately i can't found the correct 
settings. With ic2_scanning=1 i got the GENERIC/UNKNOWN type.
With the card=56 tuner=64 settings i got good quality picture, but no 
sound. But if i change the input source to composite, or s-video, i got 
the sound, if i change back to television input source, the sound is 
muted. If i unload the saa5134 module, i got the sound.

lspci -v:
05:04.0 Multimedia controller: Philips Semiconductors SAA7130 Video 
Broadcast Decoder (rev 01)
        Subsystem: LeadTek Research Inc. Device 6f30
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fb000000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [40] Power Management version 1
        Kernel driver in use: saa7134
        Kernel modules: saa7134

dmesg | grep saa:

[   15.926277] saa7130/34: v4l2 driver version 0.2.14 loaded
[   15.926333] saa7134 0000:05:04.0: PCI INT A -> GSI 20 (level, low) -> 
IRQ 20
[   15.926339] saa7130[0]: found at 0000:05:04.0, rev: 1, irq: 20, 
latency: 32, mmio: 0xfb000000
[   15.926345] saa7130[0]: subsystem: 107d:6f30, board: Avermedia AVerTV 
307 [card=56,insmod option]
[   15.926389] saa7130[0]: board init: gpio is 62000
[   15.926459] input: saa7134 IR (Avermedia AVerTV 30 as 
/devices/pci0000:00/0000:00:1e.0/0000:05:04.0/input/input6
[   16.160030] saa7130[0]: i2c eeprom 00: 7d 10 30 6f 54 20 1c 00 43 43 
a9 1c 55 d2 b2 92
[   16.160049] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff 
ff ff ff ff ff ff
[   16.160066] saa7130[0]: i2c eeprom 20: 01 40 02 03 03 ff 01 03 08 ff 
00 73 ff ff ff ff
[   16.160083] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160100] saa7130[0]: i2c eeprom 40: 50 88 00 c2 00 00 00 02 ff 04 
ff ff ff ff ff ff
[   16.160117] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160133] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160151] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160168] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160187] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160197] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160207] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160217] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160228] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160238] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.160248] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[   16.181289] tuner' 0-0061: chip found @ 0xc2 (saa7130[0])
[   16.370118] saa7130[0]: registered device video1 [v4l2]
[   16.370164] saa7130[0]: registered device vbi0


Anybody can help to me?
p.s.: sorry for my poor english

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
