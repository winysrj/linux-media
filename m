Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SIVYlf014318
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 14:31:34 -0400
Received: from smtp2a.orange.fr (smtp2a.orange.fr [80.12.242.139])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3SIU60V008722
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 14:30:27 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2a14.orange.fr (SMTP Server) with ESMTP id 9C44B70000AC
	for <video4linux-list@redhat.com>;
	Mon, 28 Apr 2008 20:30:00 +0200 (CEST)
Received: from ishwara.mahashakti.org
	(ADijon-258-1-135-43.w90-26.abo.wanadoo.fr [90.26.142.43])
	by mwinf2a14.orange.fr (SMTP Server) with ESMTP id 33B2570000A7
	for <video4linux-list@redhat.com>;
	Mon, 28 Apr 2008 20:30:00 +0200 (CEST)
Date: Mon, 28 Apr 2008 20:29:59 +0200
From: mahakali <mahakali@orange.fr>
To: video4linux-list@redhat.com
Message-ID: <20080428182959.GA21773@orange.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: Card Asus P7131 hybrid > no signal
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

 Hello !

I installed last week an Asus TV-Card P7131 Hybrid , I followed the
installation procedure described on an Ubuntu website.

On boot I get following messages :

saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2
92
saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff
ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
ff
saa7133[0]: i2c scan: found device @ 0x10  [???]
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1f.5 to 64
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
w83627hf: Found W83627THF chip at 0x290
w83627hf w83627hf.656: Reading VID from GPIO5
i2c /dev entries driver
tda1004x: found firmware revision 20 -- ok
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfeaff000 irq 19 registered as card -1
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda8, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda9, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
skge eth0: enabling interface
skge eth0: Link is up at 100 Mbps, full duplex, flow control both
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip6_tables: (C) 2000-2006 Netfilter Core Team
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0200000 [Radio]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
nvidia: module license 'NVIDIA' taints kernel.
NVRM: loading NVIDIA UNIX x86 Kernel Module  173.08  Tue Apr  1 23:46:53
PST 2008
NVRM: not using NVAGP, an AGPGART backend is loaded!
hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
hdc: drive_cmd: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xef
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
eth0: no IPv6 routers present
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7134 ALSA driver for DMA sound unloaded
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:02:0b.0, rev: 209, irq: 19, latency: 64, mmio:
0xfeaff000
saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid
[card=112,insmod option]
saa7133[0]: board init: gpio is 0
saa7133[0]: gpio: mode=0x0000000 in=0x0000000 out=0x0000000 [pre-init]
input: saa7134 IR (ASUSTeK P7131 Hybri as /class/input/input6
tuner 1-004b: chip found @ 0x96 (saa7133[0])
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
tda8290 1-004b: setting tuner address to 61
tuner 1-004b: type set to tda8290+75a
saa7133[0]:i2ceeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b292
saa7133[0]:i2ceeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ffff
saa7133[0]:i2ceeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ffff
saa7133[0]:i2ceeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ffff
saa7133[0]:i2ceeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ffff
saa7133[0]:i2ceeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ffff
saa7133[0]:i2ceeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ffff
saa7133[0]:i2ceeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ffff
saa7133[0]: i2c scan: found device @ 0x10  [???]
saa7133[0]: i2c scan: found device @ 0x96  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
DVB: registering new adapter (saa7133[0])
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision 20 -- ok
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0200000 [Radio]
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xfeaff000 irq 19 registered as card -1
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]/alsa: saa7133[0] at 0xfeaff000 irq 19 registered as card -1
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]
saa7133[0]: gpio: mode=0x0200000 in=0x0000000 out=0x0000000 [Television]

I think, it is O.K or ???


I use tvtime, I launch it but I get following message : No signal ....
I try to find some channels, but i can find no one.
If I use tvtime-scanner, he finds some channels, puts theme in a channel
list, but I have no image, cannot watch TV ....

I tried following command :

>>> tune to:
>>> 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to:
>>> 570000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_AUTO:FEC_AUTO:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_AUTO:HIERARCHY_NONE
>>> (tuning failed)



So my question is .... How can I make this card work ???


Thanks for your patience and help


mahakali 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
