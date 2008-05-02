Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd15922.kasserver.com ([85.13.137.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mldvb@mortal-soul.de>) id 1Jrp59-0002RT-82
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 08:49:24 +0200
Received: from marvin (88-134-175-128-dynip.superkabel.de [88.134.175.128])
	by dd15922.kasserver.com (Postfix) with ESMTP id D05AD2C1D3F6A
	for <linux-dvb@linuxtv.org>; Fri,  2 May 2008 08:49:20 +0200 (CEST)
From: Matthias Dahl <mldvb@mortal-soul.de>
To: linux-dvb@linuxtv.org
Date: Fri, 2 May 2008 08:49:13 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805020849.15170.mldvb@mortal-soul.de>
Subject: [linux-dvb] KNC1 DVB-C (MK3) w/ CI causes i2c_timeouts
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

Hello everyone.

A few days ago I swapped my old KNC1 TV Station Plus for a newer revision TV 
Station (MK3; non plus) which was slightly modified by KNC1 to better handle 
my cable provider's QAM256 modulated signal. So far the BER value has dropped 
to zero and things seem to work fine except that I now get the following msgs 
from time to time:

"saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer"

and

"DVB: TDA10023: tda10023_readreg: readreg error (ret == -512)"

Also infrequently, it takes a few more extra seconds to tune to another 
channel after I have been switching around a lot. It's not related to any 
specific channel and happens (more or less) totally randomly.

All this worked fine with my old card which had a tda10021 and besides that 
was mostly the same. I haven't changed anything software-wise between the 
swap, so it's somehow related to the new card.

By the way, I am using a mercurial checkout from 20 Apr 08.

If anyone can help me out on this one, I'd greatly appreciate it.

Here some infos:

uname -a:
Linux dreamgate 2.6.25 #1 SMP PREEMPT Sun Apr 20 15:25:13 CEST 2008 x86_64
AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ AuthenticAMD GNU/Linux

some log:
May  2 07:03:09 dreamgate Linux video capture interface: v2.00
May  2 07:03:09 dreamgate saa7146: register extension 'budget_av'.
May  2 07:03:09 dreamgate saa7146: found saa7146 @ mem ffffc2000002e000 
(revision 1, irq 16) (0x1894,0x0022).
May  2 07:03:09 dreamgate saa7146 (0): dma buffer size 192512
May  2 07:03:09 dreamgate DVB: registering new adapter (KNC1 DVB-C MK3)
May  2 07:03:09 dreamgate encoded MAC from EEPROM was 
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
May  2 07:03:09 dreamgate KNC1-0: MAC addr = 00:09:d6:01:ab:5b
May  2 07:03:09 dreamgate DVB: registering frontend 0 (Philips TDA10023 
DVB-C)...
May  2 07:03:09 dreamgate budget-av: ci interface initialised.
May  2 07:03:09 dreamgate budget-av: cam inserted A
May  2 07:03:09 dreamgate dvb_ca adapter 0: DVB CAM detected and initialised 
successfully

cat /proc/interrupts:
           CPU0       CPU1
  0:         81         35   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  7:          1          0   IO-APIC-edge
  8:          0          1   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          4   IO-APIC-edge      i8042
 14:         46      17884   IO-APIC-edge      pata_amd
 15:          0          0   IO-APIC-edge      pata_amd
 16:        562     480617   IO-APIC-fasteoi   sata_sil24, saa7146 (0), nvidia
 20:        149      45696   IO-APIC-fasteoi   ehci_hcd:usb1
 21:        190      91267   IO-APIC-fasteoi   sata_nv, HDA Intel
 22:          2        113   IO-APIC-fasteoi   sata_nv
 23:        109      35363   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
315:       1073     606201   PCI-MSI-edge      eth2
NMI:          0          0   Non-maskable interrupts
LOC:    1150975    1301850   Local timer interrupts
RES:     214884      78607   Rescheduling interrupts
CAL:      20235       7779   function call interrupts
TLB:       1206       1240   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts

lspci -vvv:
02:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: KNC One Device 0022
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (3750ns min, 9500ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_av
        Kernel modules: budget-av

Thanks a lot in advance,
matthew.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
