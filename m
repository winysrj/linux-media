Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:53538 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2JSJ6A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 05:58:00 -0400
Date: Fri, 19 Oct 2012 10:51:53 +0100 (BST)
From: "P.J. Marsh" <pjmarsh@uhf-satcom.com>
To: linux-media@vger.kernel.org
Subject: BTTV geovision gv800v3
Message-ID: <alpine.LNX.2.00.1210191048461.25416@sverjnyy.cwz.qlaqaf.bet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

[    7.534410] bttv: driver version 0.9.18 loaded
[    7.538680] bttv: using 8 buffers with 2080k (520 pages) each for 
capture
[    7.543708] bttv: Bt8xx card found (0).
[    7.548570] bttv 0000:02:00.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    7.552845] bttv0: Bt878 (rev 17) at 0000:02:00.0, irq: 16, latency: 
16, mmio: 0xfddff000
[    7.561292] bttv0: subsystem: 800a:763c (UNKNOWN)
[    7.565500] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    7.565510] bttv0: using: Geovision GV-800(S) (master) [card=157,insmod 
option]
[    7.573932] bttv0: gpio: en=00000000, out=00000000 in=00ff2aff [init]
[    7.575513] bttv0: tuner absent
[    7.581077] bttv0: registered device video0
[    7.588493] bttv0: registered device vbi0
[    7.627760] bttv: Bt8xx card found (1).
[    7.637248] bttv 0000:02:04.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    7.640841] bttv1: Bt878 (rev 17) at 0000:02:04.0, irq: 16, latency: 
16, mmio: 0xfddfd000
[    7.647904] bttv1: subsystem: 800b:763c (UNKNOWN)
[    7.651348] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    7.651358] bttv1: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    7.658895] bttv1: gpio: en=00000000, out=00000000 in=00ff7dff [init]
[    7.659169] bttv1: tuner absent
[    7.663267] bttv1: registered device video1
[    7.667087] bttv1: registered device vbi1
[    7.698209] bttv: Bt8xx card found (2).
[    7.701601] bttv 0000:02:08.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    7.705117] bttv2: Bt878 (rev 17) at 0000:02:08.0, irq: 16, latency: 
16, mmio: 0xfddfb000
[    7.712098] bttv2: subsystem: 800c:763c (UNKNOWN)
[    7.715578] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    7.715587] bttv2: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    7.722887] bttv2: gpio: en=00000000, out=00000000 in=00ffbdff [init]
[    7.723807] bttv2: tuner absent
[    7.728548] bttv2: registered device video2
[    7.764200] bttv: Bt8xx card found (3).
[    7.778541] bttv 0000:02:0c.0: PCI->APIC IRQ transform: INT A -> IRQ 16
[    7.783155] bttv3: Bt878 (rev 17) at 0000:02:0c.0, irq: 16, latency: 
16, mmio: 0xfddf9000
[    7.790921] bttv3: subsystem: 800d:763c (UNKNOWN)
[    7.794477] please mail id, board name and the correct card= insmod 
option to linux-media@vger.kernel.org
[    7.794487] bttv3: using: Geovision GV-800(S) (slave) [card=158,insmod 
option]
[    7.801568] bttv3: gpio: en=00000000, out=00000000 in=00fffdff [init]
[    7.802539] bttv3: tuner absent
[    7.807370] bttv3: registered device video3
[    7.813886] bttv3: registered device vbi3

02:00.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Device 800a:763c
         Flags: bus master, medium devsel, latency 16, IRQ 16
         Memory at fddff000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:00.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Device 800a:763c
         Flags: bus master, medium devsel, latency 4, IRQ 10
         Memory at fddfe000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:04.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Device 800b:763c
         Flags: bus master, medium devsel, latency 16, IRQ 16
         Memory at fddfd000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:04.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Device 800b:763c
         Flags: bus master, medium devsel, latency 4, IRQ 10
         Memory at fddfc000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:08.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Device 800c:763c
         Flags: bus master, medium devsel, latency 16, IRQ 16
         Memory at fddfb000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:08.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Device 800c:763c
         Flags: bus master, medium devsel, latency 4, IRQ 10
         Memory at fddfa000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2

02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video 
Capture (rev 11)
         Subsystem: Device 800d:763c
         Flags: bus master, medium devsel, latency 16, IRQ 16
         Memory at fddf9000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2
         Kernel driver in use: bttv
         Kernel modules: bttv

02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture 
(rev 11)
         Subsystem: Device 800d:763c
         Flags: bus master, medium devsel, latency 4, IRQ 10
         Memory at fddf8000 (32-bit, prefetchable) [size=4K]
         Capabilities: [44] Vital Product Data
         Capabilities: [4c] Power Management version 2



I'm using card type = 157,158,158,158 and the board is working very nicely 
indeed. Please let me know if you need additional info.

regards,

Paul.
--------------------------------------------------------------------
Contributor to: www.uhf-satcom.com - http://twitter.com/UHF_Satcom

IRC - pjm @ #hearsat on irc.starchat.net

Correspondents should note that all communications to this address
are automatically logged, monitored and/or recorded for lawful
or other purposes.

Telephone: 0044 (0)845 193 0050 Skype: M0EYT
--------------------------------------------------------------------
