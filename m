Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:47902 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0DFMUI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Apr 2010 08:20:08 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Nz7lD-0005WK-3T
	for linux-media@vger.kernel.org; Tue, 06 Apr 2010 14:20:03 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 14:20:03 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 06 Apr 2010 14:20:03 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] V4L/DVB: saa7146: Making IRQF_DISABLED or IRQF_SHARED optional
Date: Tue, 06 Apr 2010 13:41:46 +0200
Message-ID: <87ljd0byf9.fsf@nemi.mork.no>
References: <1269202135-340-1-git-send-email-bjorn@mork.no>
	<87ocigwvrf.fsf@nemi.mork.no>
	<1269351981-12292-1-git-send-email-bjorn@mork.no>
	<201003231541.03636@orion.escape-edv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oliver Endriss <o.endriss@gmx.de> writes:
> Bjørn Mork wrote:
>> As discussed many times, e.g. in http://lkml.org/lkml/2007/7/26/401
>> mixing IRQF_DISABLED with IRQF_SHARED may cause unpredictable and
>> unexpected results.
>> 
>> Add a module parameter to allow fine tuning the request_irq
>> flags based on local system requirements.  Some may need to turn
>> off IRQF_DISABLED to be able to share interrupt with drivers
>> needing interrupts enabled, while others may want to turn off
>> IRQF_SHARED to ensure that IRQF_DISABLED has an effect.
>
> NAK. We should not add module parameters for this kind of crap.

OK.  You are perfectly right.  This is something that Should Just Work(tm)
without any user intervention.  Sorry for adding confusion.

> Let's check whether IRQF_DISABLED is really required.
> Afaics it can be removed.

Thanks for reviewing.

> @all:
> Please check whether the first patch causes any problems.


Anyone?  

FWIW, I do have real stabilitity problems with IRQF_DISABLED.  Removing
it seem to have resolved these, and I have not noticed any regressions.

If it matters, this is tested on a quad core system with two DVB-C cards
(one budget-av and one mantis):

bjorn@canardo:~$ lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation 82G33/G31/P35/P31 Express DRAM Controller [8086:29c0] (rev 02)
00:01.0 PCI bridge [0604]: Intel Corporation 82G33/G31/P35/P31 Express PCI Express Root Port [8086:29c1] (rev 02)
00:1a.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 [8086:2937] (rev 02)
00:1a.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 [8086:2938] (rev 02)
00:1a.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 [8086:2939] (rev 02)
00:1a.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 [8086:293c] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 [8086:2940] (rev 02)
00:1c.4 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 [8086:2948] (rev 02)
00:1c.5 PCI bridge [0604]: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 [8086:294a] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 [8086:2934] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 [8086:2935] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 [8086:2936] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 [8086:293a] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev 92)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801IB (ICH9) LPC Interface Controller [8086:2918] (rev 02)
00:1f.2 SATA controller [0106]: Intel Corporation 82801IB (ICH9) 4 port SATA AHCI Controller [8086:2923] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801I (ICH9 Family) SMBus Controller [8086:2930] (rev 02)
01:00.0 Ethernet controller [0200]: Intel Corporation 82571EB Gigabit Ethernet Controller [8086:105e] (rev 06)
01:00.1 Ethernet controller [0200]: Intel Corporation 82571EB Gigabit Ethernet Controller [8086:105e] (rev 06)
02:00.0 Ethernet controller [0200]: Atheros Communications L1 Gigabit Ethernet Adapter [1969:1048] (rev b0)
03:00.0 SATA controller [0106]: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller [197b:2363] (rev 03)
03:00.1 IDE interface [0101]: JMicron Technology Corp. JMB362/JMB363 Serial ATA Controller [197b:2363] (rev 03)
04:00.0 RAID bus controller [0104]: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller [1095:3132] (rev 01)
05:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
05:01.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)
05:02.0 PCI bridge [0604]: Intel Corporation 80960RP (i960RP) Microprocessor/Bridge [8086:0960] (rev 05)
05:02.1 Memory controller [0580]: Intel Corporation 80960RP (i960RP) Microprocessor [8086:1960] (rev 05)
05:03.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller [1106:3044] (rev c0)
06:00.0 VGA compatible controller [0300]: ATI Technologies Inc 3D Rage IIC 215IIC [Mach64 GT IIC] [1002:4756] (rev 7a)

canardo:/tmp# lspci -vvnns 5:0
05:00.0 Multimedia controller [0480]: Twinhan Technology Co. Ltd Mantis DTV PCI Bridge Controller [Ver 1.0] [1822:4e35] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device [153b:1178]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fcfff000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis

canardo:/tmp# lspci -vvnns 5:1
05:01.0 Multimedia controller [0480]: Philips Semiconductors SAA7146 [1131:7146] (rev 01)
        Subsystem: KNC One Device [1894:0022]
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 64 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at feaffc00 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_av
        Kernel modules: budget-av


bjorn@canardo:~$ cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
  0:       2048        490         41       2367   IO-APIC-edge      timer
  1:          1          2          2          3   IO-APIC-edge      i8042
  4:        451        226        240        239   IO-APIC-edge      serial
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:   22944148   25223238 1359277942 1112660476   IO-APIC-fasteoi   uhci_hcd:usb1, firewire_ohci, sata_sil24, ahci, Mantis Core
 17:       2115      10605   88099554   83744140   IO-APIC-fasteoi   pata_jmicron, saa7146 (0)
 18:         12         10    9317665    9123739   IO-APIC-fasteoi   uhci_hcd:usb3, uhci_hcd:usb6, ehci_hcd:usb7, crid
 19:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb5
 21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 23:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb8
 29:   99482204       2166      15663      10401   PCI-MSI-edge      ahci
 30:  475961398        551        552        569   PCI-MSI-edge      eth1
NMI:          0          0          0          0   Non-maskable interrupts
LOC:  637443973  130774380  705012685  181373819   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring interrupts
PND:          0          0          0          0   Performance pending work
RES:    1140661    1111450    5481035    3395225   Rescheduling interrupts
CAL:   37565380     232935   25021255     311097   Function call interrupts
TLB:    4019151    1214696    3119638    4351900   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:       4862       4862       4862       4862   Machine check polls
ERR:          3
MIS:          0



This system has now been running continously for 16 days with
IRQF_DISABLED removed from the saa7146 driver.  With IRQF_DISABLED it
would usually lock up completely after a couple of days.


Bjørn

