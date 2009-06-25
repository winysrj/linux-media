Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n5PH8KsN012256
	for <video4linux-list@redhat.com>; Thu, 25 Jun 2009 13:08:20 -0400
Received: from mail-pz0-f200.google.com (mail-pz0-f200.google.com
	[209.85.222.200])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n5PH84lt031722
	for <video4linux-list@redhat.com>; Thu, 25 Jun 2009 13:08:04 -0400
Received: by pzk38 with SMTP id 38so1310039pzk.23
	for <video4linux-list@redhat.com>; Thu, 25 Jun 2009 10:08:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Jun 2009 22:38:01 +0530
Message-ID: <14b5ef430906251008j49859b24k93bcf2f122bf9590@mail.gmail.com>
From: Vikraman Choudhury <vikraman.choudhury@gmail.com>
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: saa7134, help with integrated remote!
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

Hi, I have an analog TV tuner card (Enter 210-TV --
http://www.entermultimedia.com/tv_tuner_internal.html) with a Philips
SAA7134 chipset.
I can tune to all channels (PAL) by loading the module saa7134 passing
card=106 (card=3,10,42 , tuner=37,69 also work), and get audio using the
line-in cable.
However, I can't get the integrated ir remote to work, using any of the
above options. The device saa7134 IR is detected as /dev/input/event7, but
cat /dev/input/event7 either doesn't show any output or spits out the same
code repeatedly (without the remote pressed). I understand this means that
the card is not the model passed as argument. But, is there any possible way
to find the correct card= and tuner= configuration ?

System: Gentoo 2008.0 with vanilla-sources 2.6.30 CFLAGS="-O2
-march=pentium4 -pipe -fomit-frame-pointer" CHOST="i686-pc-linux-gnu"

Output from dmesg (options saa7134 card=106 in /etc/modprobe.conf) :
[    3.210960] saa7130/34: v4l2 driver version 0.2.15 loaded
[    3.211039] saa7134 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ
18
[    3.211048] saa7130[0]: found at 0000:01:00.0, rev: 1, irq: 18, latency:
32, mmio: 0xe8000000
[    3.211057] saa7130[0]: subsystem: 1131:0000, board: 10MOONS TM300 TV
Card [card=116,insmod option]
[    3.211077] saa7130[0]: board init: gpio is 17f00
[    3.211177] input: saa7134 IR (10MOONS TM300 TV Ca as
/devices/pci0000:00/0000:00:1e.0/0000:01:00.0/input/input6
[    3.211247] IRQ 18/saa7130[0]: IRQF_DISABLED is not guaranteed on shared
IRQs
[    3.312299] saa7130[0]: Huh, no eeprom present (err=-5)?
[    3.328111] tuner 1-0061: chip found @ 0xc2 (saa7130[0])
[    3.330042] tuner-simple 1-0061: creating new instance
[    3.330048] tuner-simple 1-0061: type set to 37 (LG PAL (newer TAPC
series))
[    3.336196] saa7130[0]: registered device video0 [v4l2]
[    3.336224] saa7130[0]: registered device vbi0
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
