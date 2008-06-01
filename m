Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mxm321@gmail.com>) id 1K2kR5-0006LN-RV
	for linux-dvb@linuxtv.org; Sun, 01 Jun 2008 12:05:13 +0200
Received: by rv-out-0506.google.com with SMTP id b25so601177rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 01 Jun 2008 03:05:06 -0700 (PDT)
Message-ID: <932d9c410806010305g549d10b3v875e67f61b5d760c@mail.gmail.com>
Date: Sun, 1 Jun 2008 13:05:06 +0300
From: "mohmmad alnefieai" <mxm321@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] MAOCONY driver
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I searched for a driver without succeed

this the output

root@xx:~# dmesg | grep dvb
root@xx:~# ls -l /dev/dvb
ls: cannot access /dev/dvb: No such file or directory
root@xx:~# lspci -nnv
00:00.0 Host bridge [0600]: VIA Technologies, Inc. VT8623 [Apollo
CLE266] [1106:3123]
Subsystem: VIA Technologies, Inc. VT8623 [Apollo CLE266] [1106:3123]
Flags: bus master, 66MHz, medium devsel, latency 8
Memory at e0000000 (32-bit, prefetchable) [size=64M]
Capabilities: [a0] AGP version 2.0
Capabilities: [c0] Power Management version 2

00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8633 [Apollo
Pro266 AGP] [1106:b091] (prog-if 00 [Normal decode])
Flags: bus master, 66MHz, medium devsel, latency 0
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
Memory behind bridge: e8000000-e9ffffff
Prefetchable memory behind bridge: e4000000-e7ffffff
Capabilities: [80] Power Management version 2

00:0a.0 Multimedia video controller [0400]: JumpTec h, GMBH Unknown
device [1797:6800] (rev 11)
Flags: bus master, medium devsel, latency 32, IRQ 11
Memory at ea000000 (32-bit, non-prefetchable) [size=16M]

00:0d.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ [10ec:8139] (rev 10)
Subsystem: Realtek Semiconductor Co., Ltd. RT8139 [10ec:8139]
Flags: bus master, medium devsel, latency 32, IRQ 11
I/O ports at d000 [size=256]
Memory at eb000000 (32-bit, non-prefetchable) [size=256]
Capabilities: [50] Power Management version 2

00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80) (prog-if 00 [UHCI])
Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038]
Flags: bus master, medium devsel, latency 32, IRQ 11
I/O ports at d400 [size=32]
Capabilities: [80] Power Management version 2

00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80) (prog-if 00 [UHCI])
Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038]
Flags: bus master, medium devsel, latency 32, IRQ 5
I/O ports at d800 [size=32]
Capabilities: [80] Power Management version 2

00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80) (prog-if 00 [UHCI])
Subsystem: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038]
Flags: bus master, medium devsel, latency 32, IRQ 5
I/O ports at dc00 [size=32]
Capabilities: [80] Power Management version 2

00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
[1106:3104] (rev 82) (prog-if 20 [EHCI])
Subsystem: VIA Technologies, Inc. USB 2.0 [1106:3104]
Flags: bus master, medium devsel, latency 32, IRQ 11
Memory at eb001000 (32-bit, non-prefetchable) [size=256]
Capabilities: [80] Power Management version 2

00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge [1106:3177]
Subsystem: VIA Technologies, Inc. VT8235 ISA Bridge [1106:3177]
Flags: bus master, stepping, medium devsel, latency 0
Capabilities: [c0] Power Management version 2

00:11.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
(rev 06) (prog-if 8a [Master SecP PriP])
Subsystem: VIA Technologies, Inc.
VT82C586/B/VT82C686/A/B/VT8233/A/C/VT8235 PIPC Bus Master IDE
[1106:0571]
Flags: bus master, medium devsel, latency 32
[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
I/O ports at e000 [size=16]
Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
Subsystem: Jetway Information Co., Ltd. Unknown device [16f3:4765]
Flags: medium devsel, IRQ 5
I/O ports at e400 [size=256]
Capabilities: [c0] Power Management version 2

01:00.0 VGA compatible controller [0300]: VIA Technologies, Inc.
VT8623 [Apollo CLE266] integrated CastleRock graphics [1106:3122] (rev
03) (prog-if 00 [VGA controller])
Subsystem: VIA Technologies, Inc. VT8623 [Apollo CLE266] integrated
CastleRock graphics [1106:3122]
Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 11
Memory at e4000000 (32-bit, prefetchable) [size=64M]
Memory at e8000000 (32-bit, non-prefetchable) [size=16M]
[virtual] Expansion ROM at e9000000 [disabled] [size=64K]
Capabilities: [60] Power Management version 2
Capabilities: [70] AGP version 2.0

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
