Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gv-out-0910.google.com ([216.239.58.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajw1980@gmail.com>) id 1JU9qL-0006GK-6q
	for linux-dvb@linuxtv.org; Wed, 27 Feb 2008 01:08:17 +0100
Received: by gv-out-0910.google.com with SMTP id o2so927053gve.16
	for <linux-dvb@linuxtv.org>; Tue, 26 Feb 2008 16:08:13 -0800 (PST)
Date: Tue, 26 Feb 2008 18:08:07 -0600
From: Andy Wettstein <ajw1980@gmail.com>
To: linux-dvb@linuxtv.org
Message-ID: <20080227000807.GB14099@wettstein.homelinux.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] hvr1250 messages
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

Hi,

I just installed a hauppauge hvr1250 and it seems to be ok, but
there are ton of messages being logged.  I am wondering if these 
messages are something to be concerned about.

uname:
Linux beerme 2.6.24-1-686 #1 SMP Mon Feb 11 14:37:45 UTC 2008 i686 GNU/Linux


Relevant dmesg output:

cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt Link [APC5] enabled at IRQ 16
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [APC5] -> GSI 16 (level, low) -> IRQ 19
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250 [card=3,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 0-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885[0]/0: found at 0000:01:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xfd800000
PCI: Setting latency timer of device 0000:01:00.0 to 64


lspci:

01:00.0 Multimedia video controller: Conexant Unknown device 8852 (rev 02)
   Subsystem: Hauppauge computer works Inc. Unknown device 7911
   Flags: bus master, fast devsel, latency 0, IRQ 19
   Memory at fd800000 (64-bit, non-prefetchable) [size=2M]
   Capabilities: [40] Express Endpoint, MSI 00
   Capabilities: [80] Power Management version 2
   Capabilities: [90] Vital Product Data <?>
   Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
   Capabilities: [100] Advanced Error Reporting <?>
   Capabilities: [200] Virtual Channel <?>
   Kernel driver in use: cx23885
   Kernel modules: cx23885

Once I start watching TV with mythtv I start getting stuff like this:

cx23885[0]: mpeg risc op code error
cx23885[0]: TS2 C - dma channel status dump
cx23885[0]:   cmds: init risc lo   : 0x158ce000
cx23885[0]:   cmds: init risc hi   : 0x00000000
cx23885[0]:   cmds: cdt base       : 0x00010480
cx23885[0]:   cmds: cdt size       : 0x0000000a
cx23885[0]:   cmds: iq base        : 0x00010680
cx23885[0]:   cmds: iq size        : 0x00000010
cx23885[0]:   cmds: risc pc lo     : 0x358a3090
cx23885[0]:   cmds: risc pc hi     : 0x00000000
cx23885[0]:   cmds: iq wr ptr      : 0x000041a4
cx23885[0]:   cmds: iq rd ptr      : 0x000041a8
cx23885[0]:   cmds: cdt current    : 0x00010498
cx23885[0]:   cmds: pci target lo  : 0x371aa1a0
cx23885[0]:   cmds: pci target hi  : 0x00000000
cx23885[0]:   cmds: line / byte    : 0x03660000
cx23885[0]:   risc0: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   risc1: 0x371aa1a0 [ INVALID eol irq2 irq1 20 19 cnt1 resync 13 count=416 ]
cx23885[0]:   risc2: 0x00000000 [ INVALID count=0 ]
cx23885[0]:   risc3: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   (0x00010680) iq 0: 0x00000000 [ INVALID count=0 ]
cx23885[0]:   (0x00010684) iq 1: 0x180002a0 [ write sol count=672 ]
cx23885[0]:   iq 2: 0x371aad60 [ arg #1 ]
cx23885[0]:   iq 3: 0x00000000 [ arg #2 ]
cx23885[0]:   (0x00010690) iq 4: 0x00000000 [ INVALID count=0 ]
cx23885[0]:   (0x00010694) iq 5: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   iq 6: 0x371aa1a0 [ arg #1 ]
cx23885[0]:   iq 7: 0x00000000 [ arg #2 ]
cx23885[0]:   (0x000106a0) iq 8: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   iq 9: 0x371aa490 [ arg #1 ]
cx23885[0]:   iq a: 0x00000000 [ arg #2 ]
cx23885[0]:   (0x000106ac) iq b: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   iq c: 0x371aa780 [ arg #1 ]
cx23885[0]:   iq d: 0x00000000 [ arg #2 ]
cx23885[0]:   (0x000106b8) iq e: 0x1c0002f0 [ write sol eol count=752 ]
cx23885[0]:   iq f: 0x371aaa70 [ arg #1 ]
cx23885[0]:   iq 10: 0x92d9c054 [ arg #2 ]
cx23885[0]: fifo: 0x00006000 -> 0x7000
cx23885[0]: ctrl: 0x00010680 -> 0x106e0
cx23885[0]:   ptr1_reg: 0x000064b0
cx23885[0]:   ptr2_reg: 0x00010498
cx23885[0]:   cnt1_reg: 0x0000001c
cx23885[0]:   cnt2_reg: 0x00000007


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
