Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m13D4a1d008606
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 08:04:36 -0500
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.187])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m13D4Fkb021977
	for <video4linux-list@redhat.com>; Sun, 3 Feb 2008 08:04:15 -0500
Received: by rv-out-0910.google.com with SMTP id k15so1327977rvb.51
	for <video4linux-list@redhat.com>; Sun, 03 Feb 2008 05:04:11 -0800 (PST)
Message-ID: <fea7c4860802030504k60ab0466ta03572a9083a69e@mail.gmail.com>
Date: Sun, 3 Feb 2008 13:04:11 +0000
From: "Andy McMullan" <andymcm@gmail.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: bt878 'interference' on fc6 but not fc1
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

I've been using a Hauppauge WinTv (bt878) card with fedora core 1 for
some time with no problems.  Yesterday I added a Fedora Core 6
installation to the same PC (dual-boot), but when running FC6 I see a
sort of wavey flickery interference pattern.   Switch back to FC1 and
there's no interference.  Here's the details:

* Inteference is seen in mythtv recordings and when viewing tv in
xawtv, so not specific to any app.
* Interference is constant - always there and doesn't vary in intensity.
* Using composite input
* Looking at the /var/log/messages on both OSes doesn't show any
obvious differences in terms of detected card/tuner etc.  I've
included the relevant sections below.  Main difference is the HSYNC
OCERR messages on the FC6 system.

Any suggestions gratefully received.


FC6 (with interference):

Feb  3 12:40:41 linshuttle kernel: bttv: driver version 0.9.16 loaded
Feb  3 12:40:41 linshuttle kernel: bttv: using 8 buffers with 2080k
(520 pages) each for capture
Feb  3 12:40:41 linshuttle kernel: bttv: Bt8xx card found (0).
Feb  3 12:40:41 linshuttle kernel: bttv0: Bt878 (rev 2) at
0000:00:0a.0, irq: 20, latency: 32, mmio: 0xee012000
Feb  3 12:40:41 linshuttle kernel: bttv0: detected: Hauppauge WinTV
[card=10], PCI subsystem ID is 0070:13eb
Feb  3 12:40:41 linshuttle kernel: bttv0: using: Hauppauge (bt878)
[card=10,autodetected]
Feb  3 12:40:41 linshuttle kernel: bttv0: Hauppauge/Voodoo msp34xx:
reset line init [5]
Feb  3 12:40:41 linshuttle kernel: bttv0: Hauppauge eeprom indicates model#61205
Feb  3 12:40:41 linshuttle kernel: bttv0: using tuner=1
Feb  3 12:40:41 linshuttle kernel: bttv0: i2c: checking for MSP34xx @
0x80... not found
Feb  3 12:40:41 linshuttle kernel: bttv0: i2c: checking for TDA9875 @
0xb0... not found
Feb  3 12:40:41 linshuttle kernel: bttv0: i2c: checking for TDA7432 @
0x8a... not found
Feb  3 12:40:41 linshuttle kernel: bttv0: i2c: checking for TDA9887 @
0x86... not found
Feb  3 12:40:41 linshuttle kernel: bttv0: registered device video0
Feb  3 12:40:41 linshuttle kernel: bttv0: registered device vbi0
Feb  3 12:40:41 linshuttle kernel: bttv0: PLL: 28636363 => 35468950 .. ok

with these occasionally:

Feb  3 12:42:03 linshuttle kernel: bttv0: OCERR @ 1e6b601c,bits: HSYNC OCERR*



FC1 (no inteference):

Feb  3 00:48:52 linshuttle kernel: bttv: driver version 0.7.107 loaded
Feb  3 00:48:52 linshuttle kernel: bttv: using 4 buffers with 2080k
(8320k total) for capture
Feb  3 00:48:52 linshuttle kernel: bttv: Host bridge is VIA
Technologies, Inc. VT8375 [KM266/KL266] Host Bridge
Feb  3 00:48:52 linshuttle kernel: bttv: Bt8xx card found (0).
Feb  3 00:48:52 linshuttle kernel: bttv0: Bt878 (rev 2) at 00:0a.0,
irq: 5, latency: 32, mmio: 0xee012000
Feb  3 00:48:52 linshuttle kernel: bttv0: detected: Hauppauge WinTV
[card=10], PCI subsystem ID is 0070:13eb
Feb  3 00:48:52 linshuttle kernel: bttv0: using: BT878(Hauppauge
(bt878)) [card=10,autodetected]
Feb  3 00:48:52 linshuttle kernel: bttv0: Hauppauge/Voodoo msp34xx:
reset line init [5]
Feb  3 00:48:52 linshuttle kernel: bttv0: Hauppauge eeprom:
model=61205, tuner=Philips FI1246 MK2 (1), radio=no
Feb  3 00:48:52 linshuttle kernel: bttv0: using tuner=1
Feb  3 00:48:52 linshuttle kernel: bttv0: i2c: checking for MSP34xx @
0x80... not found
Feb  3 00:48:52 linshuttle kernel: bttv0: i2c: checking for TDA9875 @
0xb0... not found
Feb  3 00:48:52 linshuttle kernel: bttv0: i2c: checking for TDA7432 @
0x8a... not found
Feb  3 00:48:52 linshuttle kernel: bttv0: PLL: 28636363 => 35468950 .. ok
Feb  3 00:48:52 linshuttle kernel: bttv0: registered device video0
Feb  3 00:48:52 linshuttle kernel: bttv0: registered device vbi0



lspci -vn from FC6:

00:00.0 0600: 1106:3116
	Subsystem: 1297:f641
	Flags: bus master, 66MHz, medium devsel, latency 8
	Memory at e8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 2.0
	Capabilities: [c0] Power Management version 2

00:01.0 0604: 1106:b091
	Flags: bus master, 66MHz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	Memory behind bridge: ec000000-edffffff
	Prefetchable memory behind bridge: e0000000-e7ffffff
	Capabilities: [80] Power Management version 2

00:0a.0 0400: 109e:036e (rev 02)
	Subsystem: 0070:13eb
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at ee012000 (32-bit, prefetchable) [size=4K]

00:0a.1 0480: 109e:0878 (rev 02)
	Subsystem: 0070:13eb
	Flags: bus master, medium devsel, latency 32, IRQ 20
	Memory at ee010000 (32-bit, prefetchable) [size=4K]

00:0b.0 0200: 10ec:8139 (rev 10)
	Subsystem: 10ec:8139
	Flags: bus master, medium devsel, latency 32, IRQ 21
	I/O ports at d000 [size=256]
	Memory at ee011000 (32-bit, non-prefetchable) [size=256]
	[virtual] Expansion ROM at 30000000 [disabled] [size=64K]
	Capabilities: [50] Power Management version 2

00:0c.0 0c00: 1106:3044 (rev 46) (prog-if 10)
	Subsystem: 1106:3044
	Flags: bus master, medium devsel, latency 32, IRQ 18
	Memory at ee013000 (32-bit, non-prefetchable) [size=2K]
	I/O ports at d400 [size=128]
	Capabilities: [50] Power Management version 2

00:10.0 0c03: 1106:3038 (rev 80)
	Subsystem: 1106:3038
	Flags: bus master, medium devsel, latency 32, IRQ 17
	I/O ports at d800 [size=32]
	Capabilities: [80] Power Management version 2

00:10.1 0c03: 1106:3038 (rev 80)
	Subsystem: 1106:3038
	Flags: bus master, medium devsel, latency 32, IRQ 17
	I/O ports at dc00 [size=32]
	Capabilities: [80] Power Management version 2

00:10.2 0c03: 1106:3038 (rev 80)
	Subsystem: 1106:3038
	Flags: bus master, medium devsel, latency 32, IRQ 17
	I/O ports at e000 [size=32]
	Capabilities: [80] Power Management version 2

00:10.3 0c03: 1106:3104 (rev 82) (prog-if 20)
	Subsystem: 1297:f641
	Flags: bus master, medium devsel, latency 32, IRQ 17
	Memory at ee014000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

00:11.0 0601: 1106:3177
	Subsystem: 1297:f641
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:11.1 0101: 1106:0571 (rev 06) (prog-if 8a)
	Subsystem: 1297:f641
	Flags: bus master, medium devsel, latency 32, IRQ 16
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at e400 [size=16]
	Capabilities: [c0] Power Management version 2

00:11.5 0401: 1106:3059 (rev 50)
	Subsystem: 1297:c160
	Flags: medium devsel, IRQ 22
	I/O ports at e800 [size=256]
	Capabilities: [c0] Power Management version 2

01:00.0 0300: 10de:0181 (rev a2)
	Subsystem: 1043:80bb
	Flags: bus master, 66MHz, medium devsel, latency 248, IRQ 19
	Memory at ec000000 (32-bit, non-prefetchable) [size=16M]
	Memory at e0000000 (32-bit, prefetchable) [size=128M]
	[virtual] Expansion ROM at ed000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
	Capabilities: [44] AGP version 3.0

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
