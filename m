Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50591 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaAVSPy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 13:15:54 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so626776wgh.26
        for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 10:15:52 -0800 (PST)
Received: from [192.168.0.104] (host86-170-10-210.range86-170.btcentralplus.com. [86.170.10.210])
        by mx.google.com with ESMTPSA id ju6sm16439104wjc.1.2014.01.22.10.15.47
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 22 Jan 2014 10:15:51 -0800 (PST)
Message-ID: <52E00AD0.2020402@googlemail.com>
Date: Wed, 22 Jan 2014 18:15:44 +0000
From: Robert Longbottom <rongblor@googlemail.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Conexant PCI-8604PW 4 channel BNC Video capture card (bttv)
References: <52DD977E.3000907@googlemail.com> <1c25db0a-f11f-4bc0-b544-692140799b2a@email.android.com> <7D00B0B1-8873-4CB2-903F-8B98749C75FF@googlemail.com> <20140121101950.GA13818@minime.bse> <52DECF44.1070609@googlemail.com> <52DEDFCB.6010802@googlemail.com> <20140122115334.GA14710@minime.bse> <52DFC300.8010508@googlemail.com> <20140122135036.GA14871@minime.bse>
In-Reply-To: <20140122135036.GA14871@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/14 13:50, Daniel Glöckner wrote:
> On Wed, Jan 22, 2014 at 01:09:20PM +0000, Robert Longbottom wrote:
>>>   - The unlabled chip is probably a CPLD/FGPA. It filters the PCI REQ#
>>>     lines from the 878As and has access to the GNT# and INT# lines,
>>>     as well as to the GPIOs you mentioned. The bypass caps have a layout
>>>     that fits to the Lattice ispMACH 4A.
>>
>> Ah, ok, so this is something to do with interfacing to the PCI bus?
>
> Yes, they probably try to improve the scheduling between those four
> chips.
>
>> I've just had a go at this, modprobe bttv pll=35,35,35,35, and using
>> the composite0 input in xawtv (first in the list) and still no joy.
>> I just get the same timeout errors repeating in dmesg:
>>
>> [63204.009013] bttv: 3: timeout: drop=0 irq=46/26548, risc=3085d000,
>> bits: HSYNC OFLOW
>
> D'oh, I should have checked what this message means.
> It says we did not receive an interrupt.
> The unlabled chip can't prevent an interrupt from being delivered.
> It can only request additional interrupts.
>
>> 02:0c.0 Multimedia video controller [0400]: Brooktree Corporation
>>          Flags: bus master, medium devsel, latency 32, IRQ 16
>
>> 02:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>>          Flags: bus master, medium devsel, latency 32, IRQ 5
>
>> 02:0d.0 Multimedia video controller [0400]: Brooktree Corporation
>>          Flags: bus master, medium devsel, latency 32, IRQ 17
>
>> 02:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>>          Flags: bus master, medium devsel, latency 32, IRQ 10
>
>> 02:0e.0 Multimedia video controller [0400]: Brooktree Corporation
>>          Flags: bus master, medium devsel, latency 32, IRQ 18
>
>> 02:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>>          Flags: bus master, medium devsel, latency 32, IRQ 10
>
>> 02:0f.0 Multimedia video controller [0400]: Brooktree Corporation
>>          Flags: bus master, medium devsel, latency 32, IRQ 19
>
>> 02:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878
>>          Flags: bus master, medium devsel, latency 32, IRQ 11
>
> This is strange. There are 7 different IRQs assigned to that card but
> PCI slots only have 4. According to the pictures each 878A gets one of
> these. The .0 and .1 functions of a 878A must always share the same IRQ.
>
> Does your system print information on the PCI IRQ routing when Linux
> starts?

I think so if whats below is what you mean (from /var/log/messages).  It 
hasn't pasted very well so it's also here if thats any easier to read: 
http://pastebin.com/1cRwPPUH

Also, in case it's useful, I've included /proc/interrupts and lscpi 
again with everything this time, not just the bits that I think relate 
to this video capture card.

Note that I have another 4 channel bttv capture card in this machine 
thats also an IVC-200 variant (that is working) - hence 8 bt878 chips in 
lspci.  I've been doing these tests it hasn't been in use by any 
applications, so I'm hoping that isn't interfering in any way.  But 
looking at the output from that. (I think) 02:nnn is the PCI-8604 card 
and 03:nn is the IVC-200 card and looking at lspci for the IVC-200 that 
is also using more than 4 IRQ's...?

Thanks,
Rob.


robert@quad ~/tmp $ cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3
   0:        118          0          0          0   IO-APIC-edge      timer
   1:          2          0          0          0   IO-APIC-edge      i8042
   7:          2          0          0          0   IO-APIC-edge 
parport0
   9:          0          0          0          0   IO-APIC-fasteoi   acpi
  12:          4          0          0          0   IO-APIC-edge      i8042
  16:    5157412          0          0          0   IO-APIC-fasteoi 
bttv0, bttv7
  17:    5152493          0          0          0   IO-APIC-fasteoi 
bttv1, bttv4
  18:    5147396          0          0          0   IO-APIC-fasteoi 
bttv2, bttv5
  19:    5148082          0          0          0   IO-APIC-fasteoi 
bttv3, bttv6
  21:    1080916          0          0          0   IO-APIC-fasteoi   ahci
  22:     708590          0          0          0   IO-APIC-fasteoi 
ehci_hcd:usb1, nvidia
  23:   81365852          0          0          0   IO-APIC-fasteoi 
snd_hda_intel, ohci_hcd:usb2
  41:     186272          0          0          0   PCI-MSI-edge      nGene
  42:   25814467          0          0          0   PCI-MSI-edge      eth0
NMI:          0          0          0          0   Non-maskable interrupts
LOC:  132837816  136416574  133132589  137338195   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance 
monitoring interrupts
IWI:         66         62         94        127   IRQ work interrupts
RTR:          0          0          0          0   APIC ICR read retries
RES:   13140884   14267108    4487811    4515863   Rescheduling interrupts
CAL:     139978     138462     391875     356859   Function call interrupts
TLB:     104426     110831     105306     118077   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:        272        272        272        272   Machine check polls
ERR:          1
MIS:          0



lspci -vnn

00:00.0 Host bridge [0600]: NVIDIA Corporation MCP73 Host Bridge 
[10de:07c1] (rev a2)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: bus master, 66MHz, fast devsel, latency 0

00:00.1 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07cb] (rev a2)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: bus master, 66MHz, fast devsel, latency 0

00:01.0 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07cd] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.1 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07ce] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.2 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07cf] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.3 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07d0] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.4 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07d1] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.5 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07d2] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:01.6 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07d3] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:02.0 RAM memory [0500]: NVIDIA Corporation nForce 630i memory 
controller [10de:07d6] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:03.0 ISA bridge [0601]: NVIDIA Corporation MCP73 LPC Bridge 
[10de:07d7] (rev a2)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5001]
	Flags: bus master, 66MHz, fast devsel, latency 0

00:03.1 SMBus [0c05]: NVIDIA Corporation MCP73 SMBus [10de:07d8] (rev a1)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:07d8]
	Flags: 66MHz, fast devsel, IRQ 5
	I/O ports at c000 [size=64]
	I/O ports at 1c00 [size=64]
	I/O ports at 1c80 [size=64]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c_nforce2

00:03.2 RAM memory [0500]: NVIDIA Corporation MCP73 Memory Controller 
[10de:07d9] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:03.4 RAM memory [0500]: NVIDIA Corporation MCP73 Memory Controller 
[10de:07c8] (rev a1)
	Subsystem: NVIDIA Corporation Device [10de:cb73]
	Flags: 66MHz, fast devsel

00:04.0 USB controller [0c03]: NVIDIA Corporation GeForce 7100/nForce 
630i USB [10de:07fe] (rev a1) (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	Memory at d5408000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
	Kernel driver in use: ohci_hcd
	Kernel modules: ohci_hcd

00:04.1 USB controller [0c03]: NVIDIA Corporation MCP73 [nForce 630i] 
USB 2.0 Controller (EHCI) [10de:056a] (rev a1) (prog-if 20 [EHCI])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:5004]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at d5407000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=0098
	Capabilities: [80] Power Management version 2
	Kernel driver in use: ehci-pci
	Kernel modules: ehci_pci

00:08.0 IDE interface [0101]: NVIDIA Corporation MCP73 IDE [10de:056c] 
(rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:b000]
	Flags: bus master, 66MHz, fast devsel, latency 0
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable)
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable)
	I/O ports at f000 [size=16]
	Capabilities: [44] Power Management version 2

00:09.0 Audio device [0403]: NVIDIA Corporation MCP73 High Definition 
Audio [10de:07fc] (rev a1)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:a002]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 23
	Memory at d5400000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel

00:0a.0 PCI bridge [0604]: NVIDIA Corporation MCP73 PCI Express bridge 
[10de:056d] (rev a1) (prog-if 01 [Subtractive decode])
	Flags: bus master, 66MHz, fast devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=03, sec-latency=32
	Memory behind bridge: d5300000-d53fffff
	Prefetchable memory behind bridge: d5000000-d51fffff
	Capabilities: [b8] Subsystem: Gigabyte Technology Co., Ltd Device 
[1458:026f]

00:0c.0 PCI bridge [0604]: NVIDIA Corporation MCP73 PCI Express bridge 
[10de:056f] (rev a1) (prog-if 00 [Normal decode])
	Flags: bus master, fast devsel, latency 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	Memory behind bridge: d5200000-d52fffff
	Capabilities: [40] Subsystem: NVIDIA Corporation Device [10de:0000]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
	Capabilities: [80] Express Root Port (Slot+), MSI 00
	Capabilities: [100] Virtual Channel
	Kernel driver in use: pcieport

00:0e.0 SATA controller [0106]: NVIDIA Corporation GeForce 7100/nForce 
630i SATA [10de:07f4] (rev a2) (prog-if 01 [AHCI 1.0])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:b002]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
	I/O ports at 09f0 [size=8]
	I/O ports at 0bf0 [size=4]
	I/O ports at 0970 [size=8]
	I/O ports at 0b70 [size=4]
	I/O ports at dc00 [size=16]
	Memory at d5404000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
	Capabilities: [8c] SATA HBA v1.0
	Capabilities: [b0] MSI: Enable- Count=1/8 Maskable- 64bit+
	Kernel driver in use: ahci

00:0f.0 Ethernet controller [0200]: NVIDIA Corporation MCP73 Ethernet 
[10de:07dc] (rev a2)
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:e000]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 42
	Memory at d5409000 (32-bit, non-prefetchable) [size=4K]
	I/O ports at e000 [size=8]
	Memory at d540a000 (32-bit, non-prefetchable) [size=256]
	Memory at d5406000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
	Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

00:10.0 VGA compatible controller [0300]: NVIDIA Corporation C73 
[GeForce 7100 / nForce 630i] [10de:07e1] (rev a2) (prog-if 00 [VGA 
controller])
	Subsystem: Gigabyte Technology Co., Ltd Device [1458:d000]
	Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 22
	Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Memory at c0000000 (64-bit, prefetchable) [size=256M]
	Memory at d3000000 (64-bit, non-prefetchable) [size=16M]
	[virtual] Expansion ROM at bff00000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
	Kernel driver in use: nvidia
	Kernel modules: nvidia

01:05.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) [3388:0021] (rev 11) (prog-if 00 [Normal decode])
	Flags: bus master, medium devsel, latency 32
	Bus: primary=01, secondary=02, subordinate=02, sec-latency=32
	Prefetchable memory behind bridge: d5000000-d50fffff
	Capabilities: [80] Power Management version 2
	Capabilities: [90] CompactPCI hot-swap <?>

01:06.0 PCI bridge [0604]: Hint Corp HB6 Universal PCI-PCI bridge 
(non-transparent mode) [3388:0021] (rev 15) (prog-if 00 [Normal decode])
	Flags: bus master, medium devsel, latency 32
	Bus: primary=01, secondary=03, subordinate=03, sec-latency=32
	Prefetchable memory behind bridge: 00000000d5100000-00000000d51fffff
	Capabilities: [80] Power Management version 2
	Capabilities: [90] CompactPCI hot-swap <?>
	Capabilities: [a0] Vital Product Data

01:07.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB23 
IEEE-1394a-2000 Controller (PHY/Link) [104c:8024] (prog-if 10 [OHCI])
	Subsystem: Gigabyte Technology Co., Ltd Motherboard [1458:1000]
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at d5304000 (32-bit, non-prefetchable) [size=2K]
	Memory at d5300000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2

02:0c.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 16
	Memory at d5000000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

02:0c.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 5
	Memory at d5001000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0d.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 17
	Memory at d5002000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

02:0d.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at d5003000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0e.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 18
	Memory at d5004000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

02:0e.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at d5005000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

02:0f.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 19
	Memory at d5006000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

02:0f.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 11
	Memory at d5007000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

03:04.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 17
	Memory at d5100000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

03:04.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at d5101000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

03:05.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Subsystem: Device [0001:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 18
	Memory at d5102000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

03:05.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Subsystem: Device [0001:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 10
	Memory at d5103000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

03:06.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Subsystem: Device [0002:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 19
	Memory at d5104000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

03:06.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Subsystem: Device [0002:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 11
	Memory at d5105000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

03:07.0 Multimedia video controller [0400]: Brooktree Corporation Bt878 
Video Capture [109e:036e] (rev 11)
	Subsystem: Device [0003:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 16
	Memory at d5106000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2
	Kernel driver in use: bttv
	Kernel modules: bttv

03:07.1 Multimedia controller [0480]: Brooktree Corporation Bt878 Audio 
Capture [109e:0878] (rev 11)
	Subsystem: Device [0003:a155]
	Flags: bus master, medium devsel, latency 32, IRQ 5
	Memory at d5107000 (32-bit, prefetchable) [size=4K]
	Capabilities: [44] Vital Product Data
	Capabilities: [4c] Power Management version 2

04:00.0 Multimedia video controller [0400]: Micronas Semiconductor 
Holding AG nGene PCI-Express Multimedia Controller [18c3:0720] (rev 01)
	Subsystem: Micronas Semiconductor Holding AG Device [18c3:db02]
	Flags: bus master, fast devsel, latency 0, IRQ 41
	Memory at d5200000 (32-bit, non-prefetchable) [size=64K]
	Memory at d5210000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 2
	Capabilities: [48] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [58] Express Endpoint, MSI 00
	Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
	Capabilities: [400] Virtual Channel
	Kernel driver in use: ngene
	Kernel modules: ngene






Jan 21 19:29:00 quad kernel: [    0.000000] Linux version 3.9.6 
(root@quad) (gcc version 4.7.3 (Gentoo 4.7.3-r1 p1.4, pie-0.5.5) ) #5 
SMP PREEMPT Fri Jan 17 17:03:47 GMT 2014
Jan 21 19:29:00 quad kernel: [    0.000000] e820: BIOS-provided physical 
RAM map:
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000000000-0x000000000009e7ff] usable
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x000000000009f800-0x000000000009ffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000000f0000-0x00000000000fffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x0000000000100000-0x00000000aeffffff] usable
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000af000000-0x00000000beffffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000bf000000-0x00000000bfddffff] usable
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000bfee0000-0x00000000bfee2fff] ACPI NVS
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000bfee3000-0x00000000bfeeffff] ACPI data
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000bfef0000-0x00000000bfefffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000d0000000-0x00000000d1ffffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x00000000fec00000-0x00000000ffffffff] reserved
Jan 21 19:29:00 quad kernel: [    0.000000] BIOS-e820: [mem 
0x0000000100000000-0x000000013fffffff] usable
Jan 21 19:29:00 quad kernel: [    0.000000] NX (Execute Disable) 
protection: active
Jan 21 19:29:00 quad kernel: [    0.000000] SMBIOS 2.4 present.
Jan 21 19:29:00 quad kernel: [    0.000000] DMI: Gigabyte Technology 
Co., Ltd. GA-73PVM-S2H/GA-73PVM-S2H, BIOS F8 02/13/2009
Jan 21 19:29:00 quad kernel: [    0.000000] e820: update [mem 
0x00000000-0x00000fff] usable ==> reserved
Jan 21 19:29:00 quad kernel: [    0.000000] e820: remove [mem 
0x000a0000-0x000fffff] usable
Jan 21 19:29:00 quad kernel: [    0.000000] e820: last_pfn = 0x140000 
max_arch_pfn = 0x1000000
Jan 21 19:29:00 quad kernel: [    0.000000] MTRR default type: uncachable
Jan 21 19:29:00 quad kernel: [    0.000000] MTRR fixed ranges enabled:
Jan 21 19:29:00 quad kernel: [    0.000000]   00000-9FFFF write-back
Jan 21 19:29:00 quad kernel: [    0.000000]   A0000-BFFFF uncachable
Jan 21 19:29:00 quad kernel: [    0.000000]   C0000-CCFFF write-protect
Jan 21 19:29:00 quad kernel: [    0.000000]   CD000-FFFFF uncachable
Jan 21 19:29:00 quad kernel: [    0.000000] MTRR variable ranges enabled:
Jan 21 19:29:00 quad kernel: [    0.000000]   0 base 000000000 mask 
F80000000 write-back
Jan 21 19:29:00 quad kernel: [    0.000000]   1 base 080000000 mask 
FC0000000 write-back
Jan 21 19:29:00 quad kernel: [    0.000000]   2 base 100000000 mask 
FC0000000 write-back
Jan 21 19:29:00 quad kernel: [    0.000000]   3 base 0BFF00000 mask 
FFFF00000 uncachable
Jan 21 19:29:00 quad kernel: [    0.000000]   4 disabled
Jan 21 19:29:00 quad kernel: [    0.000000]   5 disabled
Jan 21 19:29:00 quad kernel: [    0.000000]   6 disabled
Jan 21 19:29:00 quad kernel: [    0.000000]   7 disabled
Jan 21 19:29:00 quad kernel: [    0.000000] x86 PAT enabled: cpu 0, old 
0x7040600070406, new 0x7010600070106
Jan 21 19:29:00 quad kernel: [    0.000000] e820: update [mem 
0xbff00000-0xffffffff] usable ==> reserved
Jan 21 19:29:00 quad kernel: [    0.000000] initial memory mapped: [mem 
0x00000000-0x019fffff]
Jan 21 19:29:00 quad kernel: [    0.000000] Base memory trampoline at 
[c009a000] 9a000 size 16384
Jan 21 19:29:00 quad kernel: [    0.000000] init_memory_mapping: [mem 
0x00000000-0x000fffff]
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x00000000-0x000fffff] 
page 4k
Jan 21 19:29:00 quad kernel: [    0.000000] init_memory_mapping: [mem 
0x37800000-0x379fffff]
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x37800000-0x379fffff] 
page 2M
Jan 21 19:29:00 quad kernel: [    0.000000] init_memory_mapping: [mem 
0x34000000-0x377fffff]
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x34000000-0x377fffff] 
page 2M
Jan 21 19:29:00 quad kernel: [    0.000000] init_memory_mapping: [mem 
0x00100000-0x33ffffff]
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x00100000-0x001fffff] 
page 4k
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x00200000-0x33ffffff] 
page 2M
Jan 21 19:29:00 quad kernel: [    0.000000] init_memory_mapping: [mem 
0x37a00000-0x37bfdfff]
Jan 21 19:29:00 quad kernel: [    0.000000]  [mem 0x37a00000-0x37bfdfff] 
page 4k
Jan 21 19:29:00 quad kernel: [    0.000000] BRK [0x013fc000, 0x013fcfff] 
PGTABLE
Jan 21 19:29:00 quad kernel: [    0.000000] RAMDISK: [mem 
0x37d80000-0x37eb7fff]
Jan 21 19:29:00 quad kernel: [    0.000000] Allocated new RAMDISK: [mem 
0x37ac6000-0x37bfd903]
Jan 21 19:29:00 quad kernel: [    0.000000] Move RAMDISK from [mem 
0x37d80000-0x37eb7903] to [mem 0x37ac6000-0x37bfd903]
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: RSDP 000f65a0 00014 
(v00 GBT   )
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: RSDT bfee3040 00038 
(v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: FACP bfee30c0 00074 
(v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: DSDT bfee3180 05301 
(v01 GBT    GBTUACPI 00001000 MSFT 0100000C)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: FACS bfee1800 00040
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: HPET bfee8600 00038 
(v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: MCFG bfee8680 0003C 
(v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: APIC bfee8500 00098 
(v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: SSDT bfee8fe0 003AB 
(v01  PmRef    CpuPm 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Jan 21 19:29:00 quad kernel: [    0.000000] 4228MB HIGHMEM available.
Jan 21 19:29:00 quad kernel: [    0.000000] 891MB LOWMEM available.
Jan 21 19:29:00 quad kernel: [    0.000000]   mapped low ram: 0 - 37bfe000
Jan 21 19:29:00 quad kernel: [    0.000000]   low ram: 0 - 37bfe000
Jan 21 19:29:00 quad kernel: [    0.000000] BRK [0x013fd000, 0x013fdfff] 
PGTABLE
Jan 21 19:29:00 quad kernel: [    0.000000] Zone ranges:
Jan 21 19:29:00 quad kernel: [    0.000000]   DMA      [mem 
0x00001000-0x00ffffff]
Jan 21 19:29:00 quad kernel: [    0.000000]   Normal   [mem 
0x01000000-0x37bfdfff]
Jan 21 19:29:00 quad kernel: [    0.000000]   HighMem  [mem 
0x37bfe000-0x3fffffff]
Jan 21 19:29:00 quad kernel: [    0.000000] Movable zone start for each node
Jan 21 19:29:00 quad kernel: [    0.000000] Early memory node ranges
Jan 21 19:29:00 quad kernel: [    0.000000]   node   0: [mem 
0x00001000-0x0009dfff]
Jan 21 19:29:00 quad kernel: [    0.000000]   node   0: [mem 
0x00100000-0xaeffffff]
Jan 21 19:29:00 quad kernel: [    0.000000]   node   0: [mem 
0xbf000000-0xbfddffff]
Jan 21 19:29:00 quad kernel: [    0.000000]   node   0: [mem 
0x00000000-0x3fffffff]
Jan 21 19:29:00 quad kernel: [    0.000000] On node 0 totalpages: 982397
Jan 21 19:29:00 quad kernel: [    0.000000] free_area_init_node: node 0, 
pgdat c1359100, node_mem_map f52c6020
Jan 21 19:29:00 quad kernel: [    0.000000]   DMA zone: 32 pages used 
for memmap
Jan 21 19:29:00 quad kernel: [    0.000000]   DMA zone: 0 pages reserved
Jan 21 19:29:00 quad kernel: [    0.000000]   DMA zone: 3997 pages, LIFO 
batch:0
Jan 21 19:29:00 quad kernel: [    0.000000]   Normal zone: 1752 pages 
used for memmap
Jan 21 19:29:00 quad kernel: [    0.000000]   Normal zone: 224254 pages, 
LIFO batch:31
Jan 21 19:29:00 quad kernel: [    0.000000]   HighMem zone: 8457 pages 
used for memmap
Jan 21 19:29:00 quad kernel: [    0.000000]   HighMem zone: 754146 
pages, LIFO batch:31
Jan 21 19:29:00 quad kernel: [    0.000000] Using APIC driver default
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: PM-Timer IO Port: 0x1008
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: Local APIC address 
0xfee00000
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x00] 
lapic_id[0x00] enabled)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x01] 
lapic_id[0x01] enabled)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x02] 
lapic_id[0x02] enabled)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC (acpi_id[0x03] 
lapic_id[0x03] enabled)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x00] dfl dfl lint[0x1])
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x01] dfl dfl lint[0x1])
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x02] dfl dfl lint[0x1])
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: LAPIC_NMI 
(acpi_id[0x03] dfl dfl lint[0x1])
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IOAPIC (id[0x02] 
address[0xfec00000] gsi_base[0])
Jan 21 19:29:00 quad kernel: [    0.000000] IOAPIC[0]: apic_id 2, 
version 17, address 0xfec00000, GSI 0-23
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 0 global_irq 2 dfl dfl)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 9 global_irq 9 high level)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 14 global_irq 14 high edge)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: INT_SRC_OVR (bus 0 
bus_irq 15 global_irq 15 high edge)
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IRQ0 used by override.
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IRQ2 used by override.
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IRQ9 used by override.
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IRQ14 used by override.
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: IRQ15 used by override.
Jan 21 19:29:00 quad kernel: [    0.000000] Using ACPI (MADT) for SMP 
configuration information
Jan 21 19:29:00 quad kernel: [    0.000000] ACPI: HPET id: 0x10de8201 
base: 0xfeff0000
Jan 21 19:29:00 quad kernel: [    0.000000] smpboot: Allowing 4 CPUs, 0 
hotplug CPUs
Jan 21 19:29:00 quad kernel: [    0.000000] nr_irqs_gsi: 40
Jan 21 19:29:00 quad kernel: [    0.000000] e820: [mem 
0xd2000000-0xfebfffff] available for PCI devices
Jan 21 19:29:00 quad kernel: [    0.000000] Booting paravirtualized 
kernel on bare hardware
Jan 21 19:29:00 quad kernel: [    0.000000] setup_percpu: NR_CPUS:4 
nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Jan 21 19:29:00 quad kernel: [    0.000000] PERCPU: Embedded 12 
pages/cpu @f5284000 s26240 r0 d22912 u49152
Jan 21 19:29:00 quad kernel: [    0.000000] pcpu-alloc: s26240 r0 d22912 
u49152 alloc=12*4096
Jan 21 19:29:00 quad kernel: [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 
2 [0] 3
Jan 21 19:29:00 quad kernel: [    0.000000] Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 980613
Jan 21 19:29:00 quad kernel: [    0.000000] Kernel command line: 
BOOT_IMAGE=/kernel-3.9.6.2 root=UUID=72867258-cc24-4629-89e5-4f96b4735094 ro
Jan 21 19:29:00 quad kernel: [    0.000000] PID hash table entries: 4096 
(order: 2, 16384 bytes)
Jan 21 19:29:00 quad kernel: [    0.000000] Dentry cache hash table 
entries: 131072 (order: 7, 524288 bytes)
Jan 21 19:29:00 quad kernel: [    0.000000] Inode-cache hash table 
entries: 65536 (order: 6, 262144 bytes)
Jan 21 19:29:00 quad kernel: [    0.000000] __ex_table already sorted, 
skipping sort
Jan 21 19:29:00 quad kernel: [    0.000000] Initializing CPU#0
Jan 21 19:29:00 quad kernel: [    0.000000] Initializing HighMem for 
node 0 (00037bfe:00140000)
Jan 21 19:29:00 quad kernel: [    0.000000] Memory: 3882160k/5242880k 
available (2462k kernel code, 47428k reserved, 981k data, 384k init, 
3016584k highmem)
Jan 21 19:29:00 quad kernel: [    0.000000] virtual kernel memory layout:
Jan 21 19:29:00 quad kernel: [    0.000000]     fixmap  : 0xfff66000 - 
0xfffff000   ( 612 kB)
Jan 21 19:29:00 quad kernel: [    0.000000]     pkmap   : 0xffc00000 - 
0xffe00000   (2048 kB)
Jan 21 19:29:00 quad kernel: [    0.000000]     vmalloc : 0xf83fe000 - 
0xffbfe000   ( 120 MB)
Jan 21 19:29:00 quad kernel: [    0.000000]     lowmem  : 0xc0000000 - 
0xf7bfe000   ( 891 MB)
Jan 21 19:29:00 quad kernel: [    0.000000]       .init : 0xc135d000 - 
0xc13bd000   ( 384 kB)
Jan 21 19:29:00 quad kernel: [    0.000000]       .data : 0xc126797b - 
0xc135cfc0   ( 981 kB)
Jan 21 19:29:00 quad kernel: [    0.000000]       .text : 0xc1000000 - 
0xc126797b   (2462 kB)
Jan 21 19:29:00 quad kernel: [    0.000000] Checking if this processor 
honours the WP bit even in supervisor mode...Ok.
Jan 21 19:29:00 quad kernel: [    0.000000] SLUB: Genslabs=15, 
HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Jan 21 19:29:00 quad kernel: [    0.000000] Preemptible hierarchical RCU 
implementation.
Jan 21 19:29:00 quad kernel: [    0.000000] NR_IRQS:2304 nr_irqs:712 16
Jan 21 19:29:00 quad kernel: [    0.000000] CPU 0 irqstacks, 
hard=f4c08000 soft=f4c0a000
Jan 21 19:29:00 quad kernel: [    0.000000] spurious 8259A interrupt: IRQ7.
Jan 21 19:29:00 quad kernel: [    0.000000] Console: colour VGA+ 80x25
Jan 21 19:29:00 quad kernel: [    0.000000] console [tty0] enabled
Jan 21 19:29:00 quad kernel: [    0.000000] hpet clockevent registered
Jan 21 19:29:00 quad kernel: [    0.000000] tsc: Fast TSC calibration 
using PIT
Jan 21 19:29:00 quad kernel: [    0.000000] tsc: Detected 2400.192 MHz 
processor
Jan 21 19:29:00 quad kernel: [    0.001001] Calibrating delay loop 
(skipped), value calculated using timer frequency.. 4800.38 BogoMIPS 
(lpj=2400192)
Jan 21 19:29:00 quad kernel: [    0.001080] pid_max: default: 32768 
minimum: 301
Jan 21 19:29:00 quad kernel: [    0.001146] Mount-cache hash table 
entries: 512
Jan 21 19:29:00 quad kernel: [    0.001358] CPU: Physical Processor ID: 0
Jan 21 19:29:00 quad kernel: [    0.001396] CPU: Processor Core ID: 0
Jan 21 19:29:00 quad kernel: [    0.001434] mce: CPU supports 6 MCE banks
Jan 21 19:29:00 quad kernel: [    0.001476] CPU0: Thermal monitoring 
enabled (TM2)
Jan 21 19:29:00 quad kernel: [    0.001524] Last level iTLB entries: 4KB 
128, 2MB 4, 4MB 4
Jan 21 19:29:00 quad kernel: [    0.001524] Last level dTLB entries: 4KB 
256, 2MB 0, 4MB 32
Jan 21 19:29:00 quad kernel: [    0.001524] tlb_flushall_shift: -1
Jan 21 19:29:00 quad kernel: [    0.001648] Freeing SMP alternatives: 
12k freed
Jan 21 19:29:00 quad kernel: [    0.002362] ACPI: Core revision 20130117
Jan 21 19:29:00 quad kernel: [    0.004791] ACPI: All ACPI Tables 
successfully acquired
Jan 21 19:29:00 quad kernel: [    0.005044] Enabling APIC mode:  Flat. 
Using 1 I/O APICs
Jan 21 19:29:00 quad kernel: [    0.005537] ..TIMER: vector=0x30 apic1=0 
pin1=2 apic2=-1 pin2=-1
Jan 21 19:29:00 quad kernel: [    0.016007] smpboot: CPU0: Intel(R) 
Core(TM)2 Quad CPU    Q6600  @ 2.40GHz (fam: 06, model: 0f, stepping: 0b)
Jan 21 19:29:00 quad kernel: [    0.017000] Performance Events: PEBS 
fmt0+, 4-deep LBR, Core2 events, Intel PMU driver.
Jan 21 19:29:00 quad kernel: [    0.017000] perf_event_intel: PEBS 
disabled due to CPU errata
Jan 21 19:29:00 quad kernel: [    0.017000] ... version:                2
Jan 21 19:29:00 quad kernel: [    0.017000] ... bit width:              40
Jan 21 19:29:00 quad kernel: [    0.017000] ... generic registers:      2
Jan 21 19:29:00 quad kernel: [    0.017000] ... value mask: 
000000ffffffffff
Jan 21 19:29:00 quad kernel: [    0.017000] ... max period: 
000000007fffffff
Jan 21 19:29:00 quad kernel: [    0.017000] ... fixed-purpose events:   3
Jan 21 19:29:00 quad kernel: [    0.017000] ... event mask: 
0000000700000003
Jan 21 19:29:00 quad kernel: [    0.026058] CPU 1 irqstacks, 
hard=f4c8e000 soft=f4c98000
Jan 21 19:29:00 quad kernel: [    0.002000] Initializing CPU#1
Jan 21 19:29:00 quad kernel: [    0.026061] smpboot: Booting Node   0, 
Processors  #1
Jan 21 19:29:00 quad kernel: [    0.040061] CPU 2 irqstacks, 
hard=f4ca2000 soft=f4ca4000
Jan 21 19:29:00 quad kernel: [    0.002000] Initializing CPU#2
Jan 21 19:29:00 quad kernel: [    0.040141]  #2
Jan 21 19:29:00 quad kernel: [    0.054060] CPU 3 irqstacks, 
hard=f4cae000 soft=f4cc0000
Jan 21 19:29:00 quad kernel: [    0.054138]  #3 OK
Jan 21 19:29:00 quad kernel: [    0.002000] Initializing CPU#3
Jan 21 19:29:00 quad kernel: [    0.066018] Brought up 4 CPUs
Jan 21 19:29:00 quad kernel: [    0.066096] smpboot: Total of 4 
processors activated (19201.53 BogoMIPS)
Jan 21 19:29:00 quad kernel: [    0.067087] devtmpfs: initialized
Jan 21 19:29:00 quad kernel: [    0.068137] NET: Registered protocol 
family 16
Jan 21 19:29:00 quad kernel: [    0.068212] ACPI: bus type PCI registered
Jan 21 19:29:00 quad kernel: [    0.068212] PCI: MMCONFIG for domain 
0000 [bus 00-1f] at [mem 0xd0000000-0xd1ffffff] (base 0xd0000000)
Jan 21 19:29:00 quad kernel: [    0.069003] PCI: MMCONFIG at [mem 
0xd0000000-0xd1ffffff] reserved in E820
Jan 21 19:29:00 quad kernel: [    0.069044] PCI: Using MMCONFIG for 
extended config space
Jan 21 19:29:00 quad kernel: [    0.069083] PCI: Using configuration 
type 1 for base access
Jan 21 19:29:00 quad kernel: [    0.069178] mtrr: your CPUs had 
inconsistent fixed MTRR settings
Jan 21 19:29:00 quad kernel: [    0.069178] mtrr: your CPUs had 
inconsistent variable MTRR settings
Jan 21 19:29:00 quad kernel: [    0.069178] mtrr: probably your BIOS 
does not setup all CPUs.
Jan 21 19:29:00 quad kernel: [    0.069178] mtrr: corrected configuration.
Jan 21 19:29:00 quad kernel: [    0.073033] bio: create slab <bio-0> at 0
Jan 21 19:29:00 quad kernel: [    0.073081] ACPI: Added _OSI(Module Device)
Jan 21 19:29:00 quad kernel: [    0.073081] ACPI: Added _OSI(Processor 
Device)
Jan 21 19:29:00 quad kernel: [    0.073112] ACPI: Added _OSI(3.0 _SCP 
Extensions)
Jan 21 19:29:00 quad kernel: [    0.073156] ACPI: Added _OSI(Processor 
Aggregator Device)
Jan 21 19:29:00 quad kernel: [    0.074548] ACPI: EC: Look up EC in DSDT
Jan 21 19:29:00 quad kernel: [    0.077674] ACPI: SSDT bfee8700 0022A 
(v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.077995] ACPI: Dynamic OEM Table Load:
Jan 21 19:29:00 quad kernel: [    0.078059] ACPI: SSDT   (null) 0022A 
(v01  PmRef  Cpu0Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.078219] ACPI: SSDT bfee8bc0 00152 
(v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.078528] ACPI: Dynamic OEM Table Load:
Jan 21 19:29:00 quad kernel: [    0.078611] ACPI: SSDT   (null) 00152 
(v01  PmRef  Cpu1Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.078772] ACPI: SSDT bfee8d20 00152 
(v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.079106] ACPI: Dynamic OEM Table Load:
Jan 21 19:29:00 quad kernel: [    0.079188] ACPI: SSDT   (null) 00152 
(v01  PmRef  Cpu2Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.079351] ACPI: SSDT bfee8e80 00152 
(v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.079661] ACPI: Dynamic OEM Table Load:
Jan 21 19:29:00 quad kernel: [    0.079744] ACPI: SSDT   (null) 00152 
(v01  PmRef  Cpu3Ist 00003000 INTL 20040311)
Jan 21 19:29:00 quad kernel: [    0.080020] ACPI: Interpreter enabled
Jan 21 19:29:00 quad kernel: [    0.080061] ACPI: (supports S0 S5)
Jan 21 19:29:00 quad kernel: [    0.080098] ACPI: Using IOAPIC for 
interrupt routing
Jan 21 19:29:00 quad kernel: [    0.080152] PCI: Using host bridge 
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jan 21 19:29:00 quad kernel: [    0.088157] ACPI: PCI Root Bridge [PCI0] 
(domain 0000 [bus 00-ff])
Jan 21 19:29:00 quad kernel: [    0.088264] acpi PNP0A08:00: [Firmware 
Info]: MMCONFIG for domain 0000 [bus 00-1f] only partially covers this 
bridge
Jan 21 19:29:00 quad kernel: [    0.088337] PCI host bridge to bus 0000:00
Jan 21 19:29:00 quad kernel: [    0.088337] pci_bus 0000:00: root bus 
resource [bus 00-ff]
Jan 21 19:29:00 quad kernel: [    0.088337] pci_bus 0000:00: root bus 
resource [io  0x0000-0x0cf7]
Jan 21 19:29:00 quad kernel: [    0.088337] pci_bus 0000:00: root bus 
resource [io  0x0d00-0xffff]
Jan 21 19:29:00 quad kernel: [    0.088337] pci_bus 0000:00: root bus 
resource [mem 0x000a0000-0x000bffff]
Jan 21 19:29:00 quad kernel: [    0.089008] pci_bus 0000:00: root bus 
resource [mem 0x000c0000-0x000dffff]
Jan 21 19:29:00 quad kernel: [    0.089050] pci_bus 0000:00: root bus 
resource [mem 0xbff00000-0xfebfffff]
Jan 21 19:29:00 quad kernel: [    0.090027] pci 0000:00:00.0: 
[10de:07c1] type 00 class 0x060000
Jan 21 19:29:00 quad kernel: [    0.090182] pci 0000:00:00.1: 
[10de:07cb] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.090224] pci 0000:00:01.0: 
[10de:07cd] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.091023] pci 0000:00:01.1: 
[10de:07ce] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.091188] pci 0000:00:01.2: 
[10de:07cf] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.091218] pci 0000:00:01.3: 
[10de:07d0] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.091221] pci 0000:00:01.4: 
[10de:07d1] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.091222] pci 0000:00:01.5: 
[10de:07d2] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.092202] pci 0000:00:01.6: 
[10de:07d3] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.092220] pci 0000:00:02.0: 
[10de:07d6] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.0: 
[10de:07d7] type 00 class 0x060100
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.1: 
[10de:07d8] type 00 class 0x0c0500
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.1: reg 10: 
[io  0xc000-0xc03f]
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.1: reg 20: 
[io  0x1c00-0x1c3f]
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.1: reg 24: 
[io  0x1c80-0x1cbf]
Jan 21 19:29:00 quad kernel: [    0.092221] pci 0000:00:03.1: PME# 
supported from D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.093015] pci 0000:00:03.2: 
[10de:07d9] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.093136] pci 0000:00:03.4: 
[10de:07c8] type 00 class 0x050000
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.0: 
[10de:07fe] type 00 class 0x0c0310
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.0: reg 10: 
[mem 0xd5408000-0xd5408fff]
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.0: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.1: 
[10de:056a] type 00 class 0x0c0320
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.1: reg 10: 
[mem 0xd5407000-0xd54070ff]
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.1: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:04.1: PME# 
supported from D0 D1 D2 D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:08.0: 
[10de:056c] type 00 class 0x01018a
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:08.0: reg 20: 
[io  0xf000-0xf00f]
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:09.0: 
[10de:07fc] type 00 class 0x040300
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:09.0: reg 10: 
[mem 0xd5400000-0xd5403fff]
Jan 21 19:29:00 quad kernel: [    0.093190] pci 0000:00:09.0: PME# 
supported from D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.094048] pci 0000:00:0a.0: 
[10de:056d] type 01 class 0x060401
Jan 21 19:29:00 quad kernel: [    0.094086] pci 0000:00:0c.0: 
[10de:056f] type 01 class 0x060400
Jan 21 19:29:00 quad kernel: [    0.094086] pci 0000:00:0c.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: 
[10de:07f4] type 00 class 0x010601
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 10: 
[io  0x09f0-0x09f7]
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 14: 
[io  0x0bf0-0x0bf3]
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 18: 
[io  0x0970-0x0977]
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 1c: 
[io  0x0b70-0x0b73]
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 20: 
[io  0xdc00-0xdc0f]
Jan 21 19:29:00 quad kernel: [    0.094114] pci 0000:00:0e.0: reg 24: 
[mem 0xd5404000-0xd5405fff]
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: 
[10de:07dc] type 00 class 0x020000
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: reg 10: 
[mem 0xd5409000-0xd5409fff]
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: reg 14: 
[io  0xe000-0xe007]
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: reg 18: 
[mem 0xd540a000-0xd540a0ff]
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: reg 1c: 
[mem 0xd5406000-0xd540600f]
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.094126] pci 0000:00:0f.0: PME# 
supported from D0 D1 D2 D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:00:10.0: 
[10de:07e1] type 00 class 0x030000
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:00:10.0: reg 10: 
[mem 0xd2000000-0xd2ffffff]
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:00:10.0: reg 14: 
[mem 0xc0000000-0xcfffffff 64bit pref]
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:00:10.0: reg 1c: 
[mem 0xd3000000-0xd3ffffff 64bit]
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:00:10.0: reg 30: 
[mem 0x00000000-0x0001ffff pref]
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:01:05.0: 
[3388:0021] type 01 class 0x060400
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:01:05.0: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.094157] pci 0000:01:05.0: PME# 
supported from D1 D2 D3hot D3cold
Jan 21 19:29:00 quad kernel: [    0.095024] pci 0000:01:06.0: 
[3388:0021] type 01 class 0x060400
Jan 21 19:29:00 quad kernel: [    0.095109] pci 0000:01:06.0: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.095111] pci 0000:01:06.0: PME# 
supported from D0 D1 D2 D3hot
Jan 21 19:29:00 quad kernel: [    0.095141] pci 0000:01:07.0: 
[104c:8024] type 00 class 0x0c0010
Jan 21 19:29:00 quad kernel: [    0.095141] pci 0000:01:07.0: reg 10: 
[mem 0xd5304000-0xd53047ff]
Jan 21 19:29:00 quad kernel: [    0.095141] pci 0000:01:07.0: reg 14: 
[mem 0xd5300000-0xd5303fff]
Jan 21 19:29:00 quad kernel: [    0.095141] pci 0000:01:07.0: supports D1 D2
Jan 21 19:29:00 quad kernel: [    0.095141] pci 0000:01:07.0: PME# 
supported from D0 D1 D2 D3hot
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0: PCI bridge 
to [bus 01-03] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [mem 0xd5300000-0xd53fffff]
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [mem 0xd5000000-0xd51fffff pref]
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [io  0x0000-0x0cf7] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [io  0x0d00-0xffff] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [mem 0x000a0000-0x000bffff] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [mem 0x000c0000-0x000dffff] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095143] pci 0000:00:0a.0:   bridge 
window [mem 0xbff00000-0xfebfffff] (subtractive decode)
Jan 21 19:29:00 quad kernel: [    0.095148] pci 0000:02:0c.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.095148] pci 0000:02:0c.0: reg 10: 
[mem 0xd5000000-0xd5000fff pref]
Jan 21 19:29:00 quad kernel: [    0.095188] pci 0000:02:0c.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.095188] pci 0000:02:0c.1: reg 10: 
[mem 0xd5001000-0xd5001fff pref]
Jan 21 19:29:00 quad kernel: [    0.095188] pci 0000:02:0d.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.096022] pci 0000:02:0d.0: reg 10: 
[mem 0xd5002000-0xd5002fff pref]
Jan 21 19:29:00 quad kernel: [    0.096139] pci 0000:02:0d.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.096139] pci 0000:02:0d.1: reg 10: 
[mem 0xd5003000-0xd5003fff pref]
Jan 21 19:29:00 quad kernel: [    0.096171] pci 0000:02:0e.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.096171] pci 0000:02:0e.0: reg 10: 
[mem 0xd5004000-0xd5004fff pref]
Jan 21 19:29:00 quad kernel: [    0.096178] pci 0000:02:0e.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.096178] pci 0000:02:0e.1: reg 10: 
[mem 0xd5005000-0xd5005fff pref]
Jan 21 19:29:00 quad kernel: [    0.096178] pci 0000:02:0f.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.096178] pci 0000:02:0f.0: reg 10: 
[mem 0xd5006000-0xd5006fff pref]
Jan 21 19:29:00 quad kernel: [    0.096181] pci 0000:02:0f.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.097030] pci 0000:02:0f.1: reg 10: 
[mem 0xd5007000-0xd5007fff pref]
Jan 21 19:29:00 quad kernel: [    0.097157] pci 0000:01:05.0: PCI bridge 
to [bus 02]
Jan 21 19:29:00 quad kernel: [    0.097157] pci 0000:01:05.0:   bridge 
window [mem 0xd5000000-0xd50fffff pref]
Jan 21 19:29:00 quad kernel: [    0.097157] pci 0000:03:04.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.097157] pci 0000:03:04.0: reg 10: 
[mem 0xd5100000-0xd5100fff pref]
Jan 21 19:29:00 quad kernel: [    0.097187] pci 0000:03:04.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.097187] pci 0000:03:04.1: reg 10: 
[mem 0xd5101000-0xd5101fff pref]
Jan 21 19:29:00 quad kernel: [    0.097187] pci 0000:03:05.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.097187] pci 0000:03:05.0: reg 10: 
[mem 0xd5102000-0xd5102fff pref]
Jan 21 19:29:00 quad kernel: [    0.098010] pci 0000:03:05.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.098040] pci 0000:03:05.1: reg 10: 
[mem 0xd5103000-0xd5103fff pref]
Jan 21 19:29:00 quad kernel: [    0.098176] pci 0000:03:06.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.098176] pci 0000:03:06.0: reg 10: 
[mem 0xd5104000-0xd5104fff pref]
Jan 21 19:29:00 quad kernel: [    0.098187] pci 0000:03:06.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.098187] pci 0000:03:06.1: reg 10: 
[mem 0xd5105000-0xd5105fff pref]
Jan 21 19:29:00 quad kernel: [    0.098187] pci 0000:03:07.0: 
[109e:036e] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.098187] pci 0000:03:07.0: reg 10: 
[mem 0xd5106000-0xd5106fff pref]
Jan 21 19:29:00 quad kernel: [    0.098189] pci 0000:03:07.1: 
[109e:0878] type 00 class 0x048000
Jan 21 19:29:00 quad kernel: [    0.098189] pci 0000:03:07.1: reg 10: 
[mem 0xd5107000-0xd5107fff pref]
Jan 21 19:29:00 quad kernel: [    0.099062] pci 0000:01:06.0: PCI bridge 
to [bus 03]
Jan 21 19:29:00 quad kernel: [    0.099113] pci 0000:01:06.0:   bridge 
window [mem 0xd5100000-0xd51fffff 64bit pref]
Jan 21 19:29:00 quad kernel: [    0.099164] pci 0000:04:00.0: 
[18c3:0720] type 00 class 0x040000
Jan 21 19:29:00 quad kernel: [    0.099164] pci 0000:04:00.0: reg 10: 
[mem 0xd5200000-0xd520ffff]
Jan 21 19:29:00 quad kernel: [    0.099164] pci 0000:04:00.0: reg 14: 
[mem 0xd5210000-0xd521ffff 64bit]
Jan 21 19:29:00 quad kernel: [    0.099191] pci 0000:04:00.0: disabling 
ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
Jan 21 19:29:00 quad kernel: [    0.099191] pci 0000:00:0c.0: PCI bridge 
to [bus 04]
Jan 21 19:29:00 quad kernel: [    0.099191] pci 0000:00:0c.0:   bridge 
window [mem 0xd5200000-0xd52fffff]
Jan 21 19:29:00 quad kernel: [    0.099191] pci_bus 0000:00: on NUMA node 0
Jan 21 19:29:00 quad kernel: [    0.099191] acpi PNP0A08:00: ACPI _OSC 
support notification failed, disabling PCIe ASPM
Jan 21 19:29:00 quad kernel: [    0.099191] acpi PNP0A08:00: Unable to 
request _OSC control (_OSC support mask: 0x08)
Jan 21 19:29:00 quad kernel: [    0.100115] ACPI: PCI Interrupt Link 
[LNK1] (IRQs *5 7 9 10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.100403] ACPI: PCI Interrupt Link 
[LNK2] (IRQs 5 7 9 *10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.100688] ACPI: PCI Interrupt Link 
[LNK3] (IRQs 5 7 9 *10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.100973] ACPI: PCI Interrupt Link 
[LNK4] (IRQs 5 7 9 10 *11 14 15)
Jan 21 19:29:00 quad kernel: [    0.101280] ACPI: PCI Interrupt Link 
[LNK5] (IRQs 5 7 9 10 *11 14 15)
Jan 21 19:29:00 quad kernel: [    0.101566] ACPI: PCI Interrupt Link 
[LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.101906] ACPI: PCI Interrupt Link 
[LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.102269] ACPI: PCI Interrupt Link 
[LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.102609] ACPI: PCI Interrupt Link 
[LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.102950] ACPI: PCI Interrupt Link 
[LIGP] (IRQs *5 7 9 10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.103256] ACPI: PCI Interrupt Link 
[LUBA] (IRQs 5 7 9 *10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.103548] ACPI: PCI Interrupt Link 
[LUB2] (IRQs 5 7 9 10 *11 14 15)
Jan 21 19:29:00 quad kernel: [    0.103833] ACPI: PCI Interrupt Link 
[LU1B] (IRQs 5 7 9 10 11 14 15) *0
Jan 21 19:29:00 quad kernel: [    0.104164] ACPI: PCI Interrupt Link 
[LU2B] (IRQs 5 7 9 10 11 14 15) *0
Jan 21 19:29:00 quad kernel: [    0.104473] ACPI: PCI Interrupt Link 
[LMAC] (IRQs 5 7 9 10 11 14 *15)
Jan 21 19:29:00 quad kernel: [    0.104758] ACPI: PCI Interrupt Link 
[LAZA] (IRQs *5 7 9 10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.105045] ACPI: PCI Interrupt Link 
[LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.105406] ACPI: PCI Interrupt Link 
[LSMB] (IRQs *5 7 9 10 11 14 15)
Jan 21 19:29:00 quad kernel: [    0.105696] ACPI: PCI Interrupt Link 
[LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.106045] ACPI: PCI Interrupt Link 
[LSID] (IRQs 5 7 9 10 *11 14 15)
Jan 21 19:29:00 quad kernel: [    0.106389] ACPI: PCI Interrupt Link 
[APC1] (IRQs 16) *0
Jan 21 19:29:00 quad kernel: [    0.106590] ACPI: PCI Interrupt Link 
[APC2] (IRQs 17) *0
Jan 21 19:29:00 quad kernel: [    0.106791] ACPI: PCI Interrupt Link 
[APC3] (IRQs 18) *0
Jan 21 19:29:00 quad kernel: [    0.106991] ACPI: PCI Interrupt Link 
[APC4] (IRQs 19) *0
Jan 21 19:29:00 quad kernel: [    0.107187] ACPI: PCI Interrupt Link 
[APC5] (IRQs 16) *0
Jan 21 19:29:00 quad kernel: [    0.107388] ACPI: PCI Interrupt Link 
[APC6] (IRQs 16) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.107611] ACPI: PCI Interrupt Link 
[APC7] (IRQs 16) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.107835] ACPI: PCI Interrupt Link 
[APC8] (IRQs 16) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.108074] ACPI: PCI Interrupt Link 
[AIGP] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.108363] ACPI: PCI Interrupt Link 
[AUBA] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.108631] ACPI: PCI Interrupt Link 
[AUB2] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.108899] ACPI: PCI Interrupt Link 
[AU1B] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.109185] ACPI: PCI Interrupt Link 
[AU2B] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.109474] ACPI: PCI Interrupt Link 
[APCH] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.109743] ACPI: PCI Interrupt Link 
[APMU] (IRQs 20 21 22 23) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.110049] ACPI: PCI Interrupt Link 
[AAZA] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.110324] ACPI: PCI Interrupt Link 
[APCS] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.110592] ACPI: PCI Interrupt Link 
[APCM] (IRQs 20 21 22 23) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.110884] ACPI: PCI Interrupt Link 
[APCZ] (IRQs 20 21 22 23) *0, disabled.
Jan 21 19:29:00 quad kernel: [    0.111174] ACPI: PCI Interrupt Link 
[APSI] (IRQs 20 21 22 23) *0
Jan 21 19:29:00 quad kernel: [    0.111484] acpi root: \_SB_.PCI0 notify 
handler is installed
Jan 21 19:29:00 quad kernel: [    0.111484] Found 1 acpi root devices
Jan 21 19:29:00 quad kernel: [    0.111484] ACPI: No dock devices found.
Jan 21 19:29:00 quad kernel: [    0.111484] vgaarb: device added: 
PCI:0000:00:10.0,decodes=io+mem,owns=io+mem,locks=none
Jan 21 19:29:00 quad kernel: [    0.111484] vgaarb: loaded
Jan 21 19:29:00 quad kernel: [    0.112002] vgaarb: bridge control 
possible 0000:00:10.0
Jan 21 19:29:00 quad kernel: [    0.112107] SCSI subsystem initialized
Jan 21 19:29:00 quad kernel: [    0.112107] ACPI: bus type ATA registered
Jan 21 19:29:00 quad kernel: [    0.112107] libata version 3.00 loaded.
Jan 21 19:29:00 quad kernel: [    0.112107] PCI: Using ACPI for IRQ routing
Jan 21 19:29:00 quad kernel: [    0.113460] PCI: pci_cache_line_size set 
to 64 bytes
Jan 21 19:29:00 quad kernel: [    0.113587] e820: reserve RAM buffer 
[mem 0x0009e800-0x0009ffff]
Jan 21 19:29:00 quad kernel: [    0.113589] e820: reserve RAM buffer 
[mem 0xaf000000-0xafffffff]
Jan 21 19:29:00 quad kernel: [    0.113591] e820: reserve RAM buffer 
[mem 0xbfde0000-0xbfffffff]
Jan 21 19:29:00 quad kernel: [    0.113605] HPET: 3 timers in total, 0 
timers will be used for per-cpu timer
Jan 21 19:29:00 quad kernel: [    0.113605] hpet0: at MMIO 0xfeff0000, 
IRQs 2, 8, 31
Jan 21 19:29:00 quad kernel: [    0.114038] hpet0: 3 comparators, 32-bit 
25.000000 MHz counter
Jan 21 19:29:00 quad kernel: [    0.118018] Switching to clocksource hpet
Jan 21 19:29:00 quad kernel: [    0.118144] pnp: PnP ACPI init
Jan 21 19:29:00 quad kernel: [    0.118155] ACPI: bus type PNP registered
Jan 21 19:29:00 quad kernel: [    0.118397] system 00:00: [io 
0x1000-0x107f] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118445] system 00:00: [io 
0x1080-0x10ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118486] system 00:00: [io 
0x1400-0x147f] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118527] system 00:00: [io 
0x1480-0x14ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118579] system 00:00: [io 
0x1800-0x187f] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118620] system 00:00: [io 
0x1880-0x18ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118662] system 00:00: [mem 
0xfefe0000-0xfefe01ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118704] system 00:00: [mem 
0xfefe1000-0xfefe10ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118746] system 00:00: [mem 
0xaf000000-0xbeffffff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118790] system 00:00: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Jan 21 19:29:00 quad kernel: [    0.118933] system 00:01: [io 
0x04d0-0x04d1] has been reserved
Jan 21 19:29:00 quad kernel: [    0.118989] system 00:01: [io 
0x0800-0x087f] has been reserved
Jan 21 19:29:00 quad kernel: [    0.119045] system 00:01: [io 
0x0295-0x0314] has been reserved
Jan 21 19:29:00 quad kernel: [    0.119086] system 00:01: [io 
0x0290-0x0294] has been reserved
Jan 21 19:29:00 quad kernel: [    0.119127] system 00:01: [io 
0x0880-0x088f] has been reserved
Jan 21 19:29:00 quad kernel: [    0.119169] system 00:01: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Jan 21 19:29:00 quad kernel: [    0.119180] pnp 00:02: [dma 4]
Jan 21 19:29:00 quad kernel: [    0.119256] pnp 00:02: Plug and Play 
ACPI device, IDs PNP0200 (active)
Jan 21 19:29:00 quad kernel: [    0.119389] pnp 00:03: Plug and Play 
ACPI device, IDs PNP0103 (active)
Jan 21 19:29:00 quad kernel: [    0.119504] pnp 00:04: Plug and Play 
ACPI device, IDs PNP0b00 (active)
Jan 21 19:29:00 quad kernel: [    0.119590] pnp 00:05: Plug and Play 
ACPI device, IDs PNP0800 (active)
Jan 21 19:29:00 quad kernel: [    0.119677] pnp 00:06: Plug and Play 
ACPI device, IDs PNP0c04 (active)
Jan 21 19:29:00 quad kernel: [    0.120015] pnp 00:07: Plug and Play 
ACPI device, IDs PNP0501 (active)
Jan 21 19:29:00 quad kernel: [    0.120302] pnp 00:08: Plug and Play 
ACPI device, IDs PNP0400 (active)
Jan 21 19:29:00 quad kernel: [    0.120952] system 00:09: [mem 
0xd0000000-0xd1ffffff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.121002] system 00:09: Plug and Play 
ACPI device, IDs PNP0c02 (active)
Jan 21 19:29:00 quad kernel: [    0.121220] system 00:0a: [mem 
0x000d2800-0x000d3fff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.121269] system 00:0a: [mem 
0x000f0000-0x000f7fff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121312] system 00:0a: [mem 
0x000f8000-0x000fbfff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121354] system 00:0a: [mem 
0x000fc000-0x000fffff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121397] system 00:0a: [mem 
0xbfee0000-0xbfefffff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121440] system 00:0a: [mem 
0xffff0000-0xffffffff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.121482] system 00:0a: [mem 
0x00000000-0x0009ffff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121524] system 00:0a: [mem 
0x00100000-0xbfedffff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121567] system 00:0a: [mem 
0xfec00000-0xfec00fff] could not be reserved
Jan 21 19:29:00 quad kernel: [    0.121610] system 00:0a: [mem 
0xfee00000-0xfee00fff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.121652] system 00:0a: [mem 
0xfeff0000-0xfeff03ff] has been reserved
Jan 21 19:29:00 quad kernel: [    0.121694] system 00:0a: Plug and Play 
ACPI device, IDs PNP0c01 (active)
Jan 21 19:29:00 quad kernel: [    0.121700] pnp: PnP ACPI: found 11 devices
Jan 21 19:29:00 quad kernel: [    0.121737] ACPI: bus type PNP unregistered
Jan 21 19:29:00 quad kernel: [    0.163288] pci 0000:00:10.0: BAR 6: 
assigned [mem 0xbff00000-0xbff1ffff pref]
Jan 21 19:29:00 quad kernel: [    0.163342] pci 0000:01:05.0: PCI bridge 
to [bus 02]
Jan 21 19:29:00 quad kernel: [    0.163388] pci 0000:01:05.0:   bridge 
window [mem 0xd5000000-0xd50fffff pref]
Jan 21 19:29:00 quad kernel: [    0.163444] pci 0000:01:06.0: PCI bridge 
to [bus 03]
Jan 21 19:29:00 quad kernel: [    0.163489] pci 0000:01:06.0:   bridge 
window [mem 0xd5100000-0xd51fffff 64bit pref]
Jan 21 19:29:00 quad kernel: [    0.163545] pci 0000:00:0a.0: PCI bridge 
to [bus 01-03]
Jan 21 19:29:00 quad kernel: [    0.163587] pci 0000:00:0a.0:   bridge 
window [mem 0xd5300000-0xd53fffff]
Jan 21 19:29:00 quad kernel: [    0.163630] pci 0000:00:0a.0:   bridge 
window [mem 0xd5000000-0xd51fffff pref]
Jan 21 19:29:00 quad kernel: [    0.163684] pci 0000:00:0c.0: PCI bridge 
to [bus 04]
Jan 21 19:29:00 quad kernel: [    0.163726] pci 0000:00:0c.0:   bridge 
window [mem 0xd5200000-0xd52fffff]
Jan 21 19:29:00 quad kernel: [    0.163775] pci 0000:00:0a.0: setting 
latency timer to 64
Jan 21 19:29:00 quad kernel: [    0.163788] pci_bus 0000:00: resource 4 
[io  0x0000-0x0cf7]
Jan 21 19:29:00 quad kernel: [    0.163791] pci_bus 0000:00: resource 5 
[io  0x0d00-0xffff]
Jan 21 19:29:00 quad kernel: [    0.163793] pci_bus 0000:00: resource 6 
[mem 0x000a0000-0x000bffff]
Jan 21 19:29:00 quad kernel: [    0.163796] pci_bus 0000:00: resource 7 
[mem 0x000c0000-0x000dffff]
Jan 21 19:29:00 quad kernel: [    0.163798] pci_bus 0000:00: resource 8 
[mem 0xbff00000-0xfebfffff]
Jan 21 19:29:00 quad kernel: [    0.163801] pci_bus 0000:01: resource 1 
[mem 0xd5300000-0xd53fffff]
Jan 21 19:29:00 quad kernel: [    0.163804] pci_bus 0000:01: resource 2 
[mem 0xd5000000-0xd51fffff pref]
Jan 21 19:29:00 quad kernel: [    0.163806] pci_bus 0000:01: resource 4 
[io  0x0000-0x0cf7]
Jan 21 19:29:00 quad kernel: [    0.163809] pci_bus 0000:01: resource 5 
[io  0x0d00-0xffff]
Jan 21 19:29:00 quad kernel: [    0.163811] pci_bus 0000:01: resource 6 
[mem 0x000a0000-0x000bffff]
Jan 21 19:29:00 quad kernel: [    0.163813] pci_bus 0000:01: resource 7 
[mem 0x000c0000-0x000dffff]
Jan 21 19:29:00 quad kernel: [    0.163816] pci_bus 0000:01: resource 8 
[mem 0xbff00000-0xfebfffff]
Jan 21 19:29:00 quad kernel: [    0.163819] pci_bus 0000:02: resource 2 
[mem 0xd5000000-0xd50fffff pref]
Jan 21 19:29:00 quad kernel: [    0.163822] pci_bus 0000:03: resource 2 
[mem 0xd5100000-0xd51fffff 64bit pref]
Jan 21 19:29:00 quad kernel: [    0.163824] pci_bus 0000:04: resource 1 
[mem 0xd5200000-0xd52fffff]
Jan 21 19:29:00 quad kernel: [    0.163850] NET: Registered protocol 
family 2
Jan 21 19:29:00 quad kernel: [    0.164030] TCP established hash table 
entries: 8192 (order: 4, 65536 bytes)
Jan 21 19:29:00 quad kernel: [    0.164093] TCP bind hash table entries: 
8192 (order: 4, 65536 bytes)
Jan 21 19:29:00 quad kernel: [    0.164153] TCP: Hash tables configured 
(established 8192 bind 8192)
Jan 21 19:29:00 quad kernel: [    0.164211] TCP: reno registered
Jan 21 19:29:00 quad kernel: [    0.164249] UDP hash table entries: 512 
(order: 2, 16384 bytes)
Jan 21 19:29:00 quad kernel: [    0.164295] UDP-Lite hash table entries: 
512 (order: 2, 16384 bytes)
Jan 21 19:29:00 quad kernel: [    0.164378] NET: Registered protocol 
family 1
Jan 21 19:29:00 quad kernel: [    0.164657] ACPI: PCI Interrupt Link 
[AUBA] enabled at IRQ 23
Jan 21 19:29:00 quad kernel: [    0.226275] ACPI: PCI Interrupt Link 
[AUB2] enabled at IRQ 22
Jan 21 19:29:00 quad kernel: [    0.237149] pci 0000:00:10.0: Boot video 
device
Jan 21 19:29:00 quad kernel: [    0.237189] PCI: CLS 32 bytes, default 64
Jan 21 19:29:00 quad kernel: [    0.237220] Unpacking initramfs...
Jan 21 19:29:00 quad kernel: [    0.402522] Freeing initrd memory: 1248k 
freed
Jan 21 19:29:00 quad kernel: [    0.404149] bounce pool size: 64 pages
Jan 21 19:29:00 quad kernel: [    0.409636] SGI XFS with security 
attributes, large block/inode numbers, no debug enabled
Jan 21 19:29:00 quad kernel: [    0.410532] msgmni has been set to 1693
Jan 21 19:29:00 quad kernel: [    0.410873] Block layer SCSI generic 
(bsg) driver version 0.4 loaded (major 254)
Jan 21 19:29:00 quad kernel: [    0.410929] io scheduler noop registered
Jan 21 19:29:00 quad kernel: [    0.410969] io scheduler cfq registered 
(default)
Jan 21 19:29:00 quad kernel: [    0.411220] pcieport 0000:00:0c.0: irq 
40 for MSI/MSI-X
Jan 21 19:29:00 quad kernel: [    0.411532] intel_idle: does not run on 
family 6 model 15
Jan 21 19:29:00 quad kernel: [    0.411613] ACPI: Requesting acpi_cpufreq
Jan 21 19:29:00 quad kernel: [    0.455228] ahci 0000:00:0e.0: version 3.0
Jan 21 19:29:00 quad kernel: [    0.455399] ACPI: PCI Interrupt Link 
[APSI] enabled at IRQ 21
Jan 21 19:29:00 quad kernel: [    0.455466] ahci 0000:00:0e.0: 
controller can do NCQ, turning on CAP_NCQ
Jan 21 19:29:00 quad kernel: [    0.455508] ahci 0000:00:0e.0: 
controller can't do PMP, turning off CAP_PMP
Jan 21 19:29:00 quad kernel: [    0.455596] ahci 0000:00:0e.0: AHCI 
0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Jan 21 19:29:00 quad kernel: [    0.455650] ahci 0000:00:0e.0: flags: 
64bit ncq sntf led clo pio
Jan 21 19:29:00 quad kernel: [    0.455692] ahci 0000:00:0e.0: setting 
latency timer to 64
Jan 21 19:29:00 quad kernel: [    0.456817] scsi0 : ahci
Jan 21 19:29:00 quad kernel: [    0.457050] scsi1 : ahci
Jan 21 19:29:00 quad kernel: [    0.457289] scsi2 : ahci
Jan 21 19:29:00 quad kernel: [    0.457501] scsi3 : ahci
Jan 21 19:29:00 quad kernel: [    0.457694] ata1: SATA max UDMA/133 abar 
m8192@0xd5404000 port 0xd5404100 irq 21
Jan 21 19:29:00 quad kernel: [    0.457752] ata2: SATA max UDMA/133 abar 
m8192@0xd5404000 port 0xd5404180 irq 21
Jan 21 19:29:00 quad kernel: [    0.457803] ata3: SATA max UDMA/133 abar 
m8192@0xd5404000 port 0xd5404200 irq 21
Jan 21 19:29:00 quad kernel: [    0.457855] ata4: SATA max UDMA/133 abar 
m8192@0xd5404000 port 0xd5404280 irq 21
Jan 21 19:29:00 quad kernel: [    0.458707] i8042: PNP: No PS/2 
controller found. Probing ports directly.
Jan 21 19:29:00 quad kernel: [    0.459289] serio: i8042 KBD port at 
0x60,0x64 irq 1
Jan 21 19:29:00 quad kernel: [    0.459335] serio: i8042 AUX port at 
0x60,0x64 irq 12
Jan 21 19:29:00 quad kernel: [    0.459593] mousedev: PS/2 mouse device 
common for all mice
Jan 21 19:29:00 quad kernel: [    0.459728] cpuidle: using governor ladder
Jan 21 19:29:00 quad kernel: [    0.459772] cpuidle: using governor menu
Jan 21 19:29:00 quad kernel: [    0.459935] hidraw: raw HID events 
driver (C) Jiri Kosina
Jan 21 19:29:00 quad kernel: [    0.460240] TCP: cubic registered
Jan 21 19:29:00 quad kernel: [    0.460278] NET: Registered protocol 
family 17
Jan 21 19:29:00 quad kernel: [    0.460325] NET: Registered protocol 
family 15
Jan 21 19:29:00 quad kernel: [    0.460370] Key type dns_resolver registered
Jan 21 19:29:00 quad kernel: [    0.460872] Using IPI Shortcut mode
Jan 21 19:29:00 quad kernel: [    0.461198] registered taskstats version 1
Jan 21 19:29:00 quad kernel: [    0.762035] ata1: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Jan 21 19:29:00 quad kernel: [    0.762095] ata2: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Jan 21 19:29:00 quad kernel: [    0.762299] ata1.00: ATA-8: KINGSTON 
SV100S2128G, D110225a, max UDMA/100
Jan 21 19:29:00 quad kernel: [    0.762345] ata1.00: 250069680 sectors, 
multi 16: LBA48 NCQ (depth 31/32)
Jan 21 19:29:00 quad kernel: [    0.762619] ata1.00: configured for UDMA/100
Jan 21 19:29:00 quad kernel: [    0.762776] scsi 0:0:0:0: Direct-Access 
     ATA      KINGSTON SV100S2 D110 PQ: 0 ANSI: 5
Jan 21 19:29:00 quad kernel: [    0.763058] ata4: SATA link down 
(SStatus 0 SControl 300)
Jan 21 19:29:00 quad kernel: [    0.763114] ata3: SATA link up 3.0 Gbps 
(SStatus 123 SControl 300)
Jan 21 19:29:00 quad kernel: [    0.763279] sd 0:0:0:0: [sda] 250069680 
512-byte logical blocks: (128 GB/119 GiB)
Jan 21 19:29:00 quad kernel: [    0.763441] sd 0:0:0:0: [sda] Write 
Protect is off
Jan 21 19:29:00 quad kernel: [    0.763495] sd 0:0:0:0: [sda] Mode 
Sense: 00 3a 00 00
Jan 21 19:29:00 quad kernel: [    0.763526] sd 0:0:0:0: [sda] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 21 19:29:00 quad kernel: [    0.766400]  sda: sda1 sda2 sda3 < sda5 
sda6 sda7 sda8 sda9 sda10 >
Jan 21 19:29:00 quad kernel: [    0.767520] sd 0:0:0:0: [sda] Attached 
SCSI disk
Jan 21 19:29:00 quad kernel: [    0.775537] ata3.00: HPA detected: 
current 1953523055, native 1953525168
Jan 21 19:29:00 quad kernel: [    0.775583] ata3.00: ATA-8: WDC 
WD1000FYPS-01ZKB0, 02.01B01, max UDMA/133
Jan 21 19:29:00 quad kernel: [    0.775628] ata3.00: 1953523055 sectors, 
multi 0: LBA48 NCQ (depth 31/32)
Jan 21 19:29:00 quad kernel: [    0.776485] ata3.00: configured for UDMA/133
Jan 21 19:29:00 quad kernel: [    0.862311] ata2.00: ATA-9: WDC 
WD30EZRX-00DC0B0, 80.00A80, max UDMA/133
Jan 21 19:29:00 quad kernel: [    0.862360] ata2.00: 5860533168 sectors, 
multi 0: LBA48 NCQ (depth 31/32)
Jan 21 19:29:00 quad kernel: [    0.865550] ata2.00: configured for UDMA/133
Jan 21 19:29:00 quad kernel: [    0.865698] scsi 1:0:0:0: Direct-Access 
     ATA      WDC WD30EZRX-00D 80.0 PQ: 0 ANSI: 5
Jan 21 19:29:00 quad kernel: [    0.866080] sd 1:0:0:0: [sdb] 5860533168 
512-byte logical blocks: (3.00 TB/2.72 TiB)
Jan 21 19:29:00 quad kernel: [    0.866155] sd 1:0:0:0: [sdb] 4096-byte 
physical blocks
Jan 21 19:29:00 quad kernel: [    0.866247] sd 1:0:0:0: [sdb] Write 
Protect is off
Jan 21 19:29:00 quad kernel: [    0.866295] sd 1:0:0:0: [sdb] Mode 
Sense: 00 3a 00 00
Jan 21 19:29:00 quad kernel: [    0.866311] scsi 2:0:0:0: Direct-Access 
     ATA      WDC WD1000FYPS-0 02.0 PQ: 0 ANSI: 5
Jan 21 19:29:00 quad kernel: [    0.866314] sd 1:0:0:0: [sdb] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 21 19:29:00 quad kernel: [    0.866673] sd 2:0:0:0: [sdc] 1953523055 
512-byte logical blocks: (1.00 TB/931 GiB)
Jan 21 19:29:00 quad kernel: [    0.866806] sd 2:0:0:0: [sdc] Write 
Protect is off
Jan 21 19:29:00 quad kernel: [    0.866854] sd 2:0:0:0: [sdc] Mode 
Sense: 00 3a 00 00
Jan 21 19:29:00 quad kernel: [    0.866887] sd 2:0:0:0: [sdc] Write 
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jan 21 19:29:00 quad kernel: [    0.880369]  sdc: sdc1
Jan 21 19:29:00 quad kernel: [    0.880771] sd 2:0:0:0: [sdc] Attached 
SCSI disk
Jan 21 19:29:00 quad kernel: [    0.933445]  sdb: sdb1
Jan 21 19:29:00 quad kernel: [    0.933873] sd 1:0:0:0: [sdb] Attached 
SCSI disk
Jan 21 19:29:00 quad kernel: [    0.933995] Freeing unused kernel 
memory: 384k freed
Jan 21 19:29:00 quad kernel: [    1.181093] kjournald starting.  Commit 
interval 5 seconds
Jan 21 19:29:00 quad kernel: [    1.181117] EXT3-fs (sda1): mounted 
filesystem with writeback data mode
Jan 21 19:29:00 quad kernel: [    1.193356] kjournald starting.  Commit 
interval 5 seconds
Jan 21 19:29:00 quad kernel: [    1.193381] EXT3-fs (sda5): mounted 
filesystem with writeback data mode
Jan 21 19:29:00 quad kernel: [    1.404047] tsc: Refined TSC clocksource 
calibration: 2400.000 MHz
Jan 21 19:29:00 quad kernel: [    1.404054] Switching to clocksource tsc
Jan 21 19:29:00 quad kernel:    1.586853] systemd-udevd[1630]: starting 
version 208
Jan 21 19:29:00 quad kernel: [    1.658121] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
Jan 21 19:29:00 quad kernel: [    1.658131] ACPI: Power Button [PWRB]
Jan 21 19:29:00 quad kernel: [    1.658235] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Jan 21 19:29:00 quad kernel: [    1.658238] ACPI: Power Button [PWRF]
Jan 21 19:29:00 quad kernel: [    1.671192] forcedeth: Reverse 
Engineered nForce ethernet driver. Version 0.64.
Jan 21 19:29:00 quad kernel: [    1.671412] ACPI: PCI Interrupt Link 
[APCH] enabled at IRQ 20
Jan 21 19:29:00 quad kernel: [    1.671428] forcedeth 0000:00:0f.0: 
setting latency timer to 64
Jan 21 19:29:00 quad kernel: [    1.674450] ACPI: bus type USB registered
Jan 21 19:29:00 quad kernel: [    1.674487] usbcore: registered new 
interface driver usbfs
Jan 21 19:29:00 quad kernel: [    1.674507] usbcore: registered new 
interface driver hub
Jan 21 19:29:00 quad kernel: [    1.674580] usbcore: registered new 
device driver usb
Jan 21 19:29:00 quad kernel: [    1.682975] ehci_hcd: USB 2.0 'Enhanced' 
Host Controller (EHCI) Driver
Jan 21 19:29:00 quad kernel: [    1.687205] ehci-pci: EHCI PCI platform 
driver
Jan 21 19:29:00 quad kernel: [    1.696176] IT8718 SuperIO detected.
Jan 21 19:29:00 quad kernel: [    1.696497] parport_pc 00:08: reported 
by Plug and Play ACPI
Jan 21 19:29:00 quad kernel: [    1.696539] parport0: PC-style at 0x378, 
irq 7 [PCSPP,TRISTATE]
Jan 21 19:29:00 quad kernel: [    1.707346] Serial: 8250/16550 driver, 4 
ports, IRQ sharing enabled
Jan 21 19:29:00 quad kernel: [    1.725552] nGene PCIE bridge driver, 
Copyright (C) 2005-2007 Micronas
Jan 21 19:29:00 quad kernel: [    1.725771] ACPI: PCI Interrupt Link 
[APC5] enabled at IRQ 16
Jan 21 19:29:00 quad kernel: [    1.725787] ngene: Found Mystique 
SaTiX-S2 Dual (v2)
Jan 21 19:29:00 quad kernel: [    1.729216] ngene: Device version 1
Jan 21 19:29:00 quad kernel: [    1.733007] Linux video capture 
interface: v2.00
Jan 21 19:29:00 quad kernel: [    1.735932] ohci_hcd: USB 1.1 'Open' 
Host Controller (OHCI) Driver
Jan 21 19:29:00 quad kernel: [    1.748633] ngene: Loading firmware file 
ngene_18.fw.
Jan 21 19:29:00 quad kernel: [    1.767189] bttv: driver version 0.9.19 
loaded
Jan 21 19:29:00 quad kernel: [    1.767197] bttv: using 8 buffers with 
2080k (520 pages) each for capture
Jan 21 19:29:00 quad kernel: [    1.767258] bttv: Bt8xx card found (0)
Jan 21 19:29:00 quad kernel: [    1.767551] ngene 0000:04:00.0: irq 41 
for MSI/MSI-X
Jan 21 19:29:00 quad kernel: [    1.767608] ACPI: PCI Interrupt Link 
[APC1] enabled at IRQ 16
Jan 21 19:29:00 quad kernel: [    1.767628] bttv: 0: Bt878 (rev 17) at 
0000:02:0c.0, irq: 16, latency: 32, mmio: 0xd5000000
Jan 21 19:29:00 quad kernel: [    1.767632] i2c i2c-0: cxd2099_attach: 
driver disabled by Kconfig
Jan 21 19:29:00 quad kernel: [    1.767647] bttv: 0: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 21 19:29:00 quad kernel: [    1.799654] bttv: 0: tuner type unset
Jan 21 19:29:00 quad kernel: [    1.799715] 00:07: ttyS0 at I/O 0x3f8 
(irq = 4) is a 16550A
Jan 21 19:29:00 quad kernel: [    1.799784] bttv: 0: registered device 
video0
Jan 21 19:29:00 quad kernel: [    1.799826] bttv: 0: registered device vbi0
Jan 21 19:29:00 quad kernel: [    1.803035] bttv: Bt8xx card found (1)
Jan 21 19:29:00 quad kernel: [    1.803326] ACPI: PCI Interrupt Link 
[APC2] enabled at IRQ 17
Jan 21 19:29:00 quad kernel: [    1.803367] bttv: 1: Bt878 (rev 17) at 
0000:02:0d.0, irq: 17, latency: 32, mmio: 0xd5002000
Jan 21 19:29:00 quad kernel: [    1.803394] bttv: 1: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 21 19:29:00 quad kernel: [    1.804109] tveeprom 3-0050: Huh, no 
eeprom present (err=-6)?
Jan 21 19:29:00 quad kernel: [    1.804112] bttv: 1: tuner type unset
Jan 21 19:29:00 quad kernel: [    1.804158] bttv: 1: registered device 
video1
Jan 21 19:29:00 quad kernel: [    1.804182] bttv: 1: registered device vbi1
Jan 21 19:29:00 quad kernel: [    1.807320] bttv: Bt8xx card found (2)
Jan 21 19:29:00 quad kernel: [    1.807481] ACPI: PCI Interrupt Link 
[APC3] enabled at IRQ 18
Jan 21 19:29:00 quad kernel: [    1.807498] bttv: 2: Bt878 (rev 17) at 
0000:02:0e.0, irq: 18, latency: 32, mmio: 0xd5004000
Jan 21 19:29:00 quad kernel: [    1.807511] bttv: 2: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 21 19:29:00 quad kernel: [    1.808191] tveeprom 4-0050: Huh, no 
eeprom present (err=-6)?
Jan 21 19:29:00 quad kernel: [    1.808193] bttv: 2: tuner type unset
Jan 21 19:29:00 quad kernel: [    1.808228] bttv: 2: registered device 
video2
Jan 21 19:29:00 quad kernel: [    1.808251] bttv: 2: registered device vbi2
Jan 21 19:29:00 quad kernel: [    1.811412] bttv: Bt8xx card found (3)
Jan 21 19:29:00 quad kernel: [    1.811576] ACPI: PCI Interrupt Link 
[APC4] enabled at IRQ 19
Jan 21 19:29:00 quad kernel: [    1.811595] bttv: 3: Bt878 (rev 17) at 
0000:02:0f.0, irq: 19, latency: 32, mmio: 0xd5006000
Jan 21 19:29:00 quad kernel: [    1.811608] bttv: 3: using:  *** 
UNKNOWN/GENERIC ***  [card=0,autodetected]
Jan 21 19:29:00 quad kernel: [    1.812293] tveeprom 5-0050: Huh, no 
eeprom present (err=-6)?
Jan 21 19:29:00 quad kernel: [    1.812295] bttv: 3: tuner type unset
Jan 21 19:29:00 quad kernel: [    1.812330] bttv: 3: registered device 
video3
Jan 21 19:29:00 quad kernel: [    1.812356] bttv: 3: registered device vbi3
Jan 21 19:29:00 quad kernel: [    1.815490] bttv: Bt8xx card found (4)
Jan 21 19:29:00 quad kernel: [    1.815541] bttv: 4: Bt878 (rev 17) at 
0000:03:04.0, irq: 17, latency: 32, mmio: 0xd5100000
Jan 21 19:29:00 quad kernel: [    1.815550] bttv: 4: detected: IVC-200 
[card=102], PCI subsystem ID is 0000:a155
Jan 21 19:29:00 quad kernel: [    1.815553] bttv: 4: using: IVC-200 
[card=102,autodetected]
Jan 21 19:29:00 quad kernel: [    1.815602] bttv: 4: tuner absent
Jan 21 19:29:00 quad kernel: [    1.815629] bttv: 4: registered device 
video4
Jan 21 19:29:00 quad kernel: [    1.815652] bttv: 4: registered device vbi4
Jan 21 19:29:00 quad kernel: [    1.815672] bttv: 4: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 21 19:29:00 quad kernel: [    1.829881] nvidia: module license 
'NVIDIA' taints kernel.
Jan 21 19:29:00 quad kernel: [    1.829886] Disabling lock debugging due 
to kernel taint
Jan 21 19:29:00 quad kernel: [    1.837401] bttv: PLL set ok
Jan 21 19:29:00 quad kernel: [    1.840823] bttv: Bt8xx card found (5)
Jan 21 19:29:00 quad kernel: [    1.840967] bttv: 5: Bt878 (rev 17) at 
0000:03:05.0, irq: 18, latency: 32, mmio: 0xd5102000
Jan 21 19:29:00 quad kernel: [    1.840997] bttv: 5: detected: IVC-200 
[card=102], PCI subsystem ID is 0001:a155
Jan 21 19:29:00 quad kernel: [    1.841000] bttv: 5: using: IVC-200 
[card=102,autodetected]
Jan 21 19:29:00 quad kernel: [    1.841091] bttv: 5: tuner absent
Jan 21 19:29:00 quad kernel: [    1.841193] bttv: 5: registered device 
video5
Jan 21 19:29:00 quad kernel: [    1.841245] bttv: 5: registered device vbi5
Jan 21 19:29:00 quad kernel: [    1.841271] bttv: 5: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 21 19:29:00 quad kernel: [    1.863006] bttv: PLL set ok
Jan 21 19:29:00 quad kernel: [    1.866420] bttv: Bt8xx card found (6)
Jan 21 19:29:00 quad kernel: [    1.866475] bttv: 6: Bt878 (rev 17) at 
0000:03:06.0, irq: 19, latency: 32, mmio: 0xd5104000
Jan 21 19:29:00 quad kernel: [    1.866484] bttv: 6: detected: IVC-200 
[card=102], PCI subsystem ID is 0002:a155
Jan 21 19:29:00 quad kernel: [    1.866486] bttv: 6: using: IVC-200 
[card=102,autodetected]
Jan 21 19:29:00 quad kernel: [    1.866538] bttv: 6: tuner absent
Jan 21 19:29:00 quad kernel: [    1.866585] bttv: 6: registered device 
video6
Jan 21 19:29:00 quad kernel: [    1.866628] bttv: 6: registered device vbi6
Jan 21 19:29:00 quad kernel: [    1.866648] bttv: 6: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 21 19:29:00 quad kernel: [    1.888005] bttv: PLL set ok
Jan 21 19:29:00 quad kernel: [    1.891414] bttv: Bt8xx card found (7)
Jan 21 19:29:00 quad kernel: [    1.891474] bttv: 7: Bt878 (rev 17) at 
0000:03:07.0, irq: 16, latency: 32, mmio: 0xd5106000
Jan 21 19:29:00 quad kernel: [    1.891482] bttv: 7: detected: IVC-200 
[card=102], PCI subsystem ID is 0003:a155
Jan 21 19:29:00 quad kernel: [    1.891484] bttv: 7: using: IVC-200 
[card=102,autodetected]
Jan 21 19:29:00 quad kernel: [    1.891532] bttv: 7: tuner absent
Jan 21 19:29:00 quad kernel: [    1.891574] bttv: 7: registered device 
video7
Jan 21 19:29:00 quad kernel: [    1.891614] bttv: 7: registered device vbi7
Jan 21 19:29:00 quad kernel: [    1.891633] bttv: 7: Setting PLL: 
28636363 => 35468950 (needs up to 100ms)
Jan 21 19:29:00 quad kernel: [    1.913012] bttv: PLL set ok
Jan 21 19:29:00 quad kernel: [    1.932111] input: PC Speaker as 
/devices/platform/pcspkr/input/input2
Jan 21 19:29:00 quad kernel: [    1.976843] microcode: CPU0 sig=0x6fb, 
pf=0x10, revision=0xb6
Jan 21 19:29:00 quad kernel: [    2.082507] LNBx2x attached on addr=a
Jan 21 19:29:00 quad kernel: [    2.083936] stv6110x_attach: Attaching 
STV6110x
Jan 21 19:29:00 quad kernel: [    2.083940] DVB: registering new adapter 
(nGene)
Jan 21 19:29:00 quad kernel: [    2.083945] ngene 0000:04:00.0: DVB: 
registering adapter 5 frontend 0 (STV090x Multistandard)...
Jan 21 19:29:00 quad kernel: [    2.097250] microcode: CPU1 sig=0x6fb, 
pf=0x10, revision=0xb6
Jan 21 19:29:00 quad kernel: [    2.098437] microcode: CPU2 sig=0x6fb, 
pf=0x10, revision=0xb6
Jan 21 19:29:00 quad kernel: [    2.098862] microcode: CPU3 sig=0x6fb, 
pf=0x10, revision=0xb6
Jan 21 19:29:00 quad kernel: [    2.099401] microcode: Microcode Update 
Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jan 21 19:29:00 quad kernel: [    2.122835] coretemp coretemp.0: Using 
relative temperature scale!
Jan 21 19:29:00 quad kernel: [    2.122857] coretemp coretemp.0: Using 
relative temperature scale!
Jan 21 19:29:00 quad kernel: [    2.122888] coretemp coretemp.0: Using 
relative temperature scale!
Jan 21 19:29:00 quad kernel: [    2.122916] coretemp coretemp.0: Using 
relative temperature scale!
Jan 21 19:29:00 quad kernel: [    2.129701] LNBx2x attached on addr=8
Jan 21 19:29:00 quad kernel: [    2.129708] stv6110x_attach: Attaching 
STV6110x
Jan 21 19:29:00 quad kernel: [    2.129712] DVB: registering new adapter 
(nGene)
Jan 21 19:29:00 quad kernel: [    2.129717] ngene 0000:04:00.0: DVB: 
registering adapter 6 frontend 0 (STV090x Multistandard)...
Jan 21 19:29:00 quad kernel: [    2.131117] No demod found on chan 2
Jan 21 19:29:00 quad kernel: [    2.132089] No demod found on chan 3
Jan 21 19:29:00 quad kernel: [    2.193943] forcedeth 0000:00:0f.0: 
ifname eth0, PHY OUI 0x732 @ 1, addr 00:1d:7d:e9:7e:bb
Jan 21 19:29:00 quad kernel: [    2.193950] forcedeth 0000:00:0f.0: 
highdma pwrctl mgmt gbit lnktim msi desc-v3
Jan 21 19:29:00 quad kernel: [    2.194029] i2c i2c-10: nForce2 SMBus 
adapter at 0x1c00
Jan 21 19:29:00 quad kernel: [    2.194056] i2c i2c-11: nForce2 SMBus 
adapter at 0x1c80
Jan 21 19:29:00 quad kernel: [    2.194336] ehci-pci 0000:00:04.1: 
setting latency timer to 64
Jan 21 19:29:00 quad kernel: [    2.194342] ehci-pci 0000:00:04.1: EHCI 
Host Controller
Jan 21 19:29:00 quad kernel: [    2.194353] ehci-pci 0000:00:04.1: new 
USB bus registered, assigned bus number 1
Jan 21 19:29:00 quad kernel: [    2.194365] ehci-pci 0000:00:04.1: debug 
port 1
Jan 21 19:29:00 quad kernel: [    2.194389] ehci-pci 0000:00:04.1: cache 
line size of 32 is not supported
Jan 21 19:29:00 quad kernel: [    2.194415] ehci-pci 0000:00:04.1: irq 
22, io mem 0xd5407000
Jan 21 19:29:00 quad kernel: [    2.200013] ehci-pci 0000:00:04.1: USB 
2.0 started, EHCI 1.00
Jan 21 19:29:00 quad kernel: [    2.200179] hub 1-0:1.0: USB hub found
Jan 21 19:29:00 quad kernel: [    2.200186] hub 1-0:1.0: 10 ports detected
Jan 21 19:29:00 quad kernel: [    2.200552] ACPI: PCI Interrupt Link 
[AAZA] enabled at IRQ 23
Jan 21 19:29:00 quad kernel: [    2.200558] hda_intel: Disabling MSI
Jan 21 19:29:00 quad kernel: [    2.200593] snd_hda_intel 0000:00:09.0: 
setting latency timer to 64
Jan 21 19:29:00 quad kernel: [    2.502013] usb 1-1: new high-speed USB 
device number 2 using ehci-pci
Jan 21 19:29:00 quad kernel: [    2.616966] hub 1-1:1.0: USB hub found
Jan 21 19:29:00 quad kernel: [    2.617059] hub 1-1:1.0: 4 ports detected
Jan 21 19:29:00 quad kernel: [    3.201061] usb 1-1.2: new low-speed USB 
device number 5 using ehci-pci
Jan 21 19:29:00 quad kernel: [    3.267536] ohci_hcd 0000:00:04.0: 
setting latency timer to 64
Jan 21 19:29:00 quad kernel: [    3.267543] ohci_hcd 0000:00:04.0: OHCI 
Host Controller
Jan 21 19:29:00 quad kernel: [    3.267554] ohci_hcd 0000:00:04.0: new 
USB bus registered, assigned bus number 2
Jan 21 19:29:00 quad kernel: [    3.267569] ohci_hcd 0000:00:04.0: irq 
23, io mem 0xd5408000
Jan 21 19:29:00 quad kernel: [    3.320160] hub 2-0:1.0: USB hub found
Jan 21 19:29:00 quad kernel: [    3.320168] hub 2-0:1.0: 10 ports detected
Jan 21 19:29:00 quad kernel: [    3.320547] ACPI: PCI Interrupt Link 
[AIGP] enabled at IRQ 22
Jan 21 19:29:00 quad kernel: [    3.320558] nvidia 0000:00:10.0: setting 
latency timer to 64
Jan 21 19:29:00 quad kernel: [    3.320563] vgaarb: device changed 
decodes: PCI:0000:00:10.0,olddecodes=io+mem,decodes=none:owns=io+mem
Jan 21 19:29:00 quad kernel: [    3.320845] NVRM: loading NVIDIA UNIX 
x86 Kernel Module  304.117  Tue Nov 26 21:36:39 PST 2013
Jan 21 19:29:00 quad kernel: [    3.322869] usbcore: registered new 
interface driver usbhid
Jan 21 19:29:00 quad kernel: [    3.322873] usbhid: USB HID core driver
Jan 21 19:29:00 quad kernel: [    3.325379] input: Belkin Corporation 
Flip CC as 
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.2/1-1.2:1.0/input/input3
Jan 21 19:29:00 quad kernel: [    3.325528] belkin 0003:050D:3201.0001: 
input,hiddev0,hidraw0: USB HID v1.10 Device [Belkin Corporation Flip CC] 
on usb-0000:00:04.1-1.2/input0
Jan 21 19:29:00 quad kernel: [    3.368065] usb 1-1.3: new low-speed USB 
device number 6 using ehci-pci
Jan 21 19:29:00 quad kernel: [    3.477278] input: Logitech Logitech USB 
Keyboard as 
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.3/1-1.3:1.0/input/input4
Jan 21 19:29:00 quad kernel: [    3.477367] hid-generic 
0003:046D:C308.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech 
Logitech USB Keyboard] on usb-0000:00:04.1-1.3/input0
Jan 21 19:29:00 quad kernel: [    3.490935] input: Logitech Logitech USB 
Keyboard as 
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.3/1-1.3:1.1/input/input5
Jan 21 19:29:00 quad kernel: [    3.491053] hid-generic 
0003:046D:C308.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech 
Logitech USB Keyboard] on usb-0000:00:04.1-1.3/input1
Jan 21 19:29:00 quad kernel: [    3.564065] usb 1-1.4: new low-speed USB 
device number 7 using ehci-pci
Jan 21 19:29:00 quad kernel: [    3.660736] input: ARROW STRONG USB 
Mouse as 
/devices/pci0000:00/0000:00:04.1/usb1/1-1/1-1.4/1-1.4:1.0/input/input6
Jan 21 19:29:00 quad kernel: [    3.660851] hid-generic 
0003:0AB0:0001.0004: input,hidraw3: USB HID v1.00 Mouse [ARROW STRONG 
USB Mouse] on usb-0000:00:04.1-1.4/input0
Jan 21 19:29:00 quad kernel: [    3.774030] usb 2-2: new low-speed USB 
device number 2 using ohci_hcd
Jan 21 19:29:00 quad kernel: [    4.380137] hid-generic 
0003:051D:0002.0005: hiddev0,hidraw4: USB HID v1.10 Device [American 
Power Conversion Back-UPS CS 650 FW:817.v7 .I USB FW:v7 ] on 
usb-0000:00:04.0-2/input0
Jan 21 19:29:00 quad kernel: [    4.493019] usb 2-3: new full-speed USB 
device number 3 using ohci_hcd
Jan 21 19:29:00 quad kernel: [    4.678479] usbcore: registered new 
interface driver usbserial
Jan 21 19:29:00 quad kernel: [    4.678501] usbcore: registered new 
interface driver usbserial_generic
Jan 21 19:29:00 quad kernel: [    4.678524] usbserial: USB Serial 
support registered for generic
Jan 21 19:29:00 quad kernel: [    4.680478] usbcore: registered new 
interface driver ftdi_sio
Jan 21 19:29:00 quad kernel: [    4.680505] usbserial: USB Serial 
support registered for FTDI USB Serial Device
Jan 21 19:29:00 quad kernel: [    4.680591] ftdi_sio 2-3:1.0: FTDI USB 
Serial Device converter detected
Jan 21 19:29:00 quad kernel: [    4.680624] usb 2-3: Detected FT232RL
Jan 21 19:29:00 quad kernel: [    4.680628] usb 2-3: Number of endpoints 2
Jan 21 19:29:00 quad kernel: [    4.680631] usb 2-3: Endpoint 1 
MaxPacketSize 64
Jan 21 19:29:00 quad kernel: [    4.680635] usb 2-3: Endpoint 2 
MaxPacketSize 64
Jan 21 19:29:00 quad kernel: [    4.680639] usb 2-3: Setting 
MaxPacketSize 64
Jan 21 19:29:00 quad kernel: [    4.685075] usb 2-3: FTDI USB Serial 
Device converter now attached to ttyUSB0
Jan 21 19:29:00 quad kernel: [    5.233312] device-mapper: ioctl: 
4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
Jan 21 19:29:00 quad kernel: [    5.538741] EXT3-fs (sda1): using 
internal journal
Jan 21 19:29:00 quad kernel: [    5.552523] EXT3-fs (sda5): using 
internal journal
Jan 21 19:29:00 quad kernel: [    5.640062] Adding 4295676k swap on 
/dev/sda10.  Priority:-1 extents:1 across:4295676k SS
Jan 21 19:29:00 quad kernel: [    5.680282] kjournald starting.  Commit 
interval 5 seconds
Jan 21 19:29:00 quad kernel: [    5.680407] EXT3-fs (sda6): using 
internal journal
Jan 21 19:29:00 quad kernel: [    5.680413] EXT3-fs (sda6): mounted 
filesystem with writeback data mode
Jan 21 19:29:00 quad kernel: [    5.682702] kjournald starting.  Commit 
interval 5 seconds
Jan 21 19:29:00 quad kernel: [    5.682801] EXT3-fs (sda7): using 
internal journal
Jan 21 19:29:00 quad kernel: [    5.682806] EXT3-fs (sda7): mounted 
filesystem with writeback data mode
Jan 21 19:29:00 quad kernel: [    5.685086] kjournald starting.  Commit 
interval 5 seconds
Jan 21 19:29:00 quad kernel: [    5.685186] EXT3-fs (sda8): using 
internal journal
Jan 21 19:29:00 quad kernel: [    5.685190] EXT3-fs (sda8): mounted 
filesystem with writeback data mode
Jan 21 19:29:00 quad kernel: [    5.686353] XFS (sda9): Mounting Filesystem
Jan 21 19:29:00 quad kernel: [    5.718228] XFS (sda9): Ending clean mount
Jan 21 19:29:00 quad kernel: [    5.719212] XFS (sdb1): Mounting Filesystem
Jan 21 19:29:00 quad kernel: [    5.863816] XFS (sdb1): Ending clean mount
Jan 21 19:29:00 quad kernel: [    5.864714] XFS (sdc1): Mounting Filesystem
Jan 21 19:29:00 quad kernel: [    5.981099] XFS (sdc1): Ending clean mount
Jan 21 19:29:00 quad kernel: [    7.119025] forcedeth 0000:00:0f.0: irq 
42 for MSI/MSI-X
Jan 21 19:29:00 quad kernel: [    7.119062] forcedeth 0000:00:0f.0 eth0: 
MSI enabled



