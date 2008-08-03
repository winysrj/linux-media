Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m73L6rGZ003878
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 17:06:53 -0400
Received: from web36104.mail.mud.yahoo.com (web36104.mail.mud.yahoo.com
	[66.163.179.218])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m73L6cQO009084
	for <video4linux-list@redhat.com>; Sun, 3 Aug 2008 17:06:39 -0400
Date: Sun, 3 Aug 2008 14:06:13 -0700 (PDT)
From: Jody Gugelhupf <knueffle@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <690835.17053.qm@web36104.mail.mud.yahoo.com>
Subject: can someone help with dvb-s card Technotrend Premium S-2300 or
	Hauppauge Nexus-S 2.3 desperate
Reply-To: knueffle@yahoo.com
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


hi there,

I have a dvb-s card, the Technotrend Premium S-2300 "modded", which is identical to Hauppauge Nexus-S 2.3, but with additional Features:
http://www.dvbshop.net/product_info.php/info/p59_Technotrend-Premium-S-2300--modded--incl--remote.html 
I also have the CI-module for that card.
I try to get it to run in ubuntu hardy with the 2.6.24-19-generic kernel. I tried to get it working, but I think there is somthing worng as it does not
work properly. My main board is a GeForce705VT-M5, I have two pci slots, in one of them is the technotrend card in the other there is a kodicom 4400R capture card with four chips.

When I try the initial channel scan for the Astra19.2E satellite I get this:

scan /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E > .szap/channels.conf
scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
>>> tune to: 12551:v:0:22000
WARNING: >>> tuning failed!!!
>>> tune to: 12551:v:0:22000 (tuning failed)
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

I know for sure that the satellite cable is ok, I have attached a receiver to the cable and it works all fine and I receive the channels, just when I connect it to the technotrend card it does not work.
Here is some information about the current condition relating to the technotrend card:

ls /dev/dvb/adapter0/
audio0     ca0        demux0     dvr0       frontend0  net0       osd0       video0

lspci
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)

lspci -v
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at febffc00 (32-bit, non-prefetchable) [size=512]
lspci -nn
01:04.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 11)
01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)

dmesg
[   34.854698] saa7146: found saa7146 @ mem f89d2c00 (revision 1, irq 20) (0x13c2,0x000e).
[   34.905714] bttv: driver version 0.9.17 loaded
[   34.905718] bttv: using 16 buffers with 2080k (520 pages) each for capture
[   35.458184] DVB: registering new adapter (Technotrend/Hauppauge WinTV Nexus-S rev2.3)
[   35.493921] adapter has MAC addr = 00:d0:5c:09:59:65
[   35.703186] dvb-ttpci: gpioirq unknown type=0 len=0
[   35.728761] dvb-ttpci: info @ card 0: firm f0240009, rtsl b0250018, vid 71010068, app 80002622
[   35.728765] dvb-ttpci: firmware @ card 0 supports CI link layer interface
[   35.772746] dvb-ttpci: Crystal audio DAC @ card 0 detected
[   35.773576] saa7146_vv: saa7146 (0): registered device video0 [v4l2]
[   35.773623] saa7146_vv: saa7146 (0): registered device vbi0 [v4l2]
[   36.052444] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[   36.052528] input: DVB on-card IR receiver as /devices/pci0000:00/0000:00:0a.0/0000:01:06.0/input/input6
[   36.084166] dvb-ttpci: found av7110-0.
[   36.084289] bttv: Bt8xx card found (0).
[   36.084602] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 18
[   36.084607] ACPI: PCI Interrupt 0000:02:0c.0[A] -> Link [LNKA] -> GSI 18 (level, low) -> IRQ 21

lsmod | egrep dvb
dvb_ttpci             103752  0 
dvb_core               81404  2 stv0299,dvb_ttpci
saa7146_vv             51072  1 dvb_ttpci
saa7146                20488  2 dvb_ttpci,saa7146_vv
ttpci_eeprom            3456  1 dvb_ttpci
i2c_core               24832  8 lnbp21,stv0299,bttv,i2c_algo_bit,tveeprom,dvb_ttpci,ttpci_eeprom,nvidia


now all the stuff:
lspci
00:00.0 Host bridge: nVidia Corporation Unknown device 07c3 (rev a2)
00:00.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a2)
00:01.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.2 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.3 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.4 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.5 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:01.6 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:02.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
00:03.0 ISA bridge: nVidia Corporation Unknown device 07d7 (rev a2)
00:03.1 SMBus: nVidia Corporation Unknown device 07d8 (rev a1)
00:03.2 RAM memory: nVidia Corporation Unknown device 07d9 (rev a1)
00:03.4 RAM memory: nVidia Corporation Unknown device 07c8 (rev a1)
00:04.0 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1)
00:04.1 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1)
00:08.0 IDE interface: nVidia Corporation Unknown device 056c (rev a1)
00:09.0 Audio device: nVidia Corporation MCP73 High Definition Audio (rev a1)
00:0a.0 PCI bridge: nVidia Corporation Unknown device 056d (rev a1)
00:0b.0 PCI bridge: nVidia Corporation Unknown device 056e (rev a1)
00:0c.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1)
00:0d.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1)
00:0e.0 IDE interface: nVidia Corporation Unknown device 07f0 (rev a2)
00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
00:10.0 VGA compatible controller: nVidia Corporation GeForce 7050/nForce 610i (rev a2)
01:04.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) (rev 11)
01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
02:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
02:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)


lspci -nn
00:00.0 Host bridge [0600]: nVidia Corporation Unknown device [10de:07c3] (rev a2)
00:00.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cb] (rev a2)
00:01.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cd] (rev a1)
00:01.1 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07ce] (rev a1)
00:01.2 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07cf] (rev a1)
00:01.3 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d0] (rev a1)
00:01.4 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d1] (rev a1)
00:01.5 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d2] (rev a1)
00:01.6 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d3] (rev a1)
00:02.0 RAM memory [0500]: nVidia Corporation nForce 630i memory controller [10de:07d6] (rev a1)
00:03.0 ISA bridge [0601]: nVidia Corporation Unknown device [10de:07d7] (rev a2)
00:03.1 SMBus [0c05]: nVidia Corporation Unknown device [10de:07d8] (rev a1)
00:03.2 RAM memory [0500]: nVidia Corporation Unknown device [10de:07d9] (rev a1)
00:03.4 RAM memory [0500]: nVidia Corporation Unknown device [10de:07c8] (rev a1)
00:04.0 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:07fe] (rev a1)
00:04.1 USB Controller [0c03]: nVidia Corporation GeForce 7100/nForce 630i [10de:056a] (rev a1)
00:08.0 IDE interface [0101]: nVidia Corporation Unknown device [10de:056c] (rev a1)
00:09.0 Audio device [0403]: nVidia Corporation MCP73 High Definition Audio [10de:07fc] (rev a1)
00:0a.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056d] (rev a1)
00:0b.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056e] (rev a1)
00:0c.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0d.0 PCI bridge [0604]: nVidia Corporation Unknown device [10de:056f] (rev a1)
00:0e.0 IDE interface [0101]: nVidia Corporation Unknown device [10de:07f0] (rev a2)
00:0f.0 Ethernet controller [0200]: nVidia Corporation MCP73 Ethernet [10de:07dc] (rev a2)
00:10.0 VGA compatible controller [0300]: nVidia Corporation GeForce 7050/nForce 610i [10de:07e3] (rev a2)
01:04.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) [3388:0021] (rev 11)
01:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)
02:0c.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
02:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)
02:0d.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
02:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)
02:0e.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
02:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)
02:0f.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 Video Capture [109e:036e] (rev 11)
02:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio Capture [109e:0878] (rev 11)


lspci -v
[sudo] password for aile: 
00:00.0 Host bridge: nVidia Corporation Unknown device 07c3 (rev a2)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a2)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0

00:01.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.1 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.2 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.3 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.4 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.5 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:01.6 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:02.0 RAM memory: nVidia Corporation nForce 630i memory controller (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:03.0 ISA bridge: nVidia Corporation Unknown device 07d7 (rev a2)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0
	I/O ports at 4f00 [size=256]

00:03.1 SMBus: nVidia Corporation Unknown device 07d8 (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel, IRQ 11
	I/O ports at 4900 [size=64]
	I/O ports at 4d00 [size=64]
	I/O ports at 4e00 [size=64]
	Capabilities: [44] Power Management version 2

00:03.2 RAM memory: nVidia Corporation Unknown device 07d9 (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:03.4 RAM memory: nVidia Corporation Unknown device 07c8 (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: 66MHz, fast devsel

00:04.0 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1) (prog-if 10 [OHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
	Memory at feaff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2

00:04.1 USB Controller: nVidia Corporation GeForce 7100/nForce 630i (rev a1) (prog-if 20 [EHCI])
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
	Memory at feafec00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port
	Capabilities: [80] Power Management version 2

00:08.0 IDE interface: nVidia Corporation Unknown device 056c (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: Unknown device f019:2145
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [disabled] [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [disabled] [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [disabled] [size=1]
	I/O ports at ffa0 [size=16]
	Capabilities: [44] Power Management version 2

00:09.0 Audio device: nVidia Corporation MCP73 High Definition Audio (rev a1)
	Subsystem: Elitegroup Computer Systems Unknown device 2976
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 17
	Memory at feaf8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/0 Enable-

00:0a.0 PCI bridge: nVidia Corporation Unknown device 056d (rev a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=02, sec-latency=64
	Memory behind bridge: feb00000-febfffff
	Prefetchable memory behind bridge: fbf00000-fbffffff
	Capabilities: [b8] Subsystem: Elitegroup Computer Systems Unknown device 2145

00:0b.0 PCI bridge: nVidia Corporation Unknown device 056e (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0c.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0d.0 PCI bridge: nVidia Corporation Unknown device 056f (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	Capabilities: [40] Subsystem: Elitegroup Computer Systems Unknown device 2145
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable+
	Capabilities: [80] Express Root Port (Slot+) IRQ 0

00:0e.0 IDE interface: nVidia Corporation Unknown device 07f0 (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 220
	I/O ports at e480 [size=8]
	I/O ports at e400 [size=4]
	I/O ports at e080 [size=8]
	I/O ports at e000 [size=4]
	I/O ports at dc00 [size=16]
	Memory at feafc000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [8c] #12 [0010]
	Capabilities: [b0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/3 Enable+

00:0f.0 Ethernet controller: nVidia Corporation MCP73 Ethernet (rev a2)
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 219
	Memory at feaf7000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at d880 [size=8]
	Memory at feafe800 (32-bit, non-prefetchable) [size=256]
	Memory at feafe400 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+ Queue=0/3 Enable+

00:10.0 VGA compatible controller: nVidia Corporation GeForce 7050/nForce 610i (rev a2) (prog-if 00 [VGA controller])
	Subsystem: Elitegroup Computer Systems Unknown device 2145
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
	Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fc000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at feac0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-

01:04.0 PCI bridge: Hint Corp HB6 Universal PCI-PCI bridge (non-transparent mode) (rev 11) (prog-if 00 [Normal decode])
	Flags: bus master, medium devsel, latency 64
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
	Prefetchable memory behind bridge: fbf00000-fbffffff
	Capabilities: [80] Power Management version 2
	Capabilities: [90] #06 [0000]

01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Unknown device 000e
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at febffc00 (32-bit, non-prefetchable) [size=512]

02:0c.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 21
	Memory at fbfff000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0c.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Flags: medium devsel, IRQ 21
	Memory at fbffe000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 20
	Memory at fbffd000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Flags: medium devsel, IRQ 20
	Memory at fbffc000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0e.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 22
	Memory at fbffb000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0e.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Flags: medium devsel, IRQ 22
	Memory at fbffa000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0f.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
	Flags: bus master, medium devsel, latency 64, IRQ 23
	Memory at fbff9000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0f.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
	Flags: medium devsel, IRQ 23
	Memory at fbff8000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2


 lsmod
Module                  Size  Used by
af_packet              23812  2 
ipv6                  267780  17 
rfcomm                 41744  2 
l2cap                  25728  13 rfcomm
bluetooth              61156  4 rfcomm,l2cap
ppdev                  10372  0 
acpi_cpufreq           10796  1 
cpufreq_powersave       2688  0 
cpufreq_conservative     8712  0 
cpufreq_ondemand        9740  1 
cpufreq_userspace       5284  0 
cpufreq_stats           7104  0 
freq_table              5536  3 acpi_cpufreq,cpufreq_ondemand,cpufreq_stats
sbs                    15112  0 
container               5632  0 
sbshc                   7680  1 sbs
video                  19856  0 
output                  4736  1 video
dock                   11280  0 
battery                14212  0 
iptable_filter          3840  0 
ip_tables              14820  1 iptable_filter
x_tables               16132  1 ip_tables
ac                      6916  0 
lp                     12324  0 
bt878                  11832  0 
lnbp21                  3200  1 
stv0299                11528  1 
bttv                  175860  1 bt878
ir_common              36100  1 bttv
compat_ioctl32          2304  1 bttv
i2c_algo_bit            7300  1 bttv
btcx_risc               5896  1 bttv
tveeprom               16656  1 bttv
dvb_ttpci             103752  0 
dvb_core               81404  2 stv0299,dvb_ttpci
saa7146_vv             51072  1 dvb_ttpci
saa7146                20488  2 dvb_ttpci,saa7146_vv
videobuf_dma_sg        14980  2 bttv,saa7146_vv
videobuf_core          18820  3 bttv,saa7146_vv,videobuf_dma_sg
videodev               29440  2 bttv,saa7146_vv
v4l2_common            18304  3 bttv,saa7146_vv,videodev
v4l1_compat            15492  3 bttv,saa7146_vv,videodev
ttpci_eeprom            3456  1 dvb_ttpci
snd_hda_intel         344728  3 
wmi_acer                9644  0 
snd_pcm_oss            42144  0 
snd_mixer_oss          17920  1 snd_pcm_oss
snd_pcm                78596  2 snd_hda_intel,snd_pcm_oss
snd_page_alloc         11400  2 snd_hda_intel,snd_pcm
snd_hwdep              10500  1 snd_hda_intel
evdev                  13056  4 
psmouse                40336  0 
snd_seq_dummy           4868  0 
snd_seq_oss            35584  0 
serio_raw               7940  0 
snd_seq_midi            9376  0 
snd_rawmidi            25760  1 snd_seq_midi
nvidia               7105956  34 
snd_seq_midi_event      8320  2 snd_seq_oss,snd_seq_midi
snd_seq                54224  6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              24836  2 snd_pcm,snd_seq
snd_seq_device          9612  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
button                  9232  0 
snd                    56996  17 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_hwdep,snd_seq_dummy,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
parport_pc             36260  1 
parport                37832  3 ppdev,lp,parport_pc
agpgart                34760  1 nvidia
soundcore               8800  1 snd
pcspkr                  4224  0 
i2c_core               24832  8 lnbp21,stv0299,bttv,i2c_algo_bit,tveeprom,dvb_ttpci,ttpci_eeprom,nvidia
shpchp                 34452  0 
pci_hotplug            30880  1 shpchp
ext3                  136712  2 
jbd                    48404  1 ext3
mbcache                 9600  1 ext3
sg                     36880  0 
sd_mod                 30720  4 
ahci                   28420  3 
ata_generic             8324  0 
pata_amd               14212  0 
forcedeth              51980  0 
pata_acpi               8320  0 
ohci_hcd               25348  0 
ehci_hcd               37900  0 
libata                159344  4 ahci,ata_generic,pata_amd,pata_acpi
scsi_mod              151436  3 sg,sd_mod,libata
usbcore               146028  3 ohci_hcd,ehci_hcd
thermal                16796  0 
processor              36872  2 acpi_cpufreq,thermal
fan                     5636  0 
fbcon                  42912  0 
tileblit                3456  1 fbcon
font                    9472  1 fbcon
bitblit                 6784  1 fbcon
softcursor              3072  1 bitblit
fuse                   50708  3 


please help, totaly lost, thx :)
jody



      __________________________________________________________________
Be smarter than spam. See how smart SpamGuard is at giving junk email the boot with the All-new Yahoo! Mail.  Click on Options in Mail and switch to New Mail today or register for free at http://mail.yahoo.ca

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
