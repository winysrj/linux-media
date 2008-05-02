Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1Jrv7G-0001uE-VK
	for linux-dvb@linuxtv.org; Fri, 02 May 2008 15:16:01 +0200
From: Andy Walls <awalls@radix.net>
To: Matthias Dahl <mldvb@mortal-soul.de>
In-Reply-To: <200805020849.15170.mldvb@mortal-soul.de>
References: <200805020849.15170.mldvb@mortal-soul.de>
Date: Fri, 02 May 2008 09:15:50 -0400
Message-Id: <1209734150.3475.48.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] KNC1 DVB-C (MK3) w/ CI causes i2c_timeouts
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

On Fri, 2008-05-02 at 08:49 +0200, Matthias Dahl wrote:
> Hello everyone.
> 
> A few days ago I swapped my old KNC1 TV Station Plus for a newer revision TV 
> Station (MK3; non plus) which was slightly modified by KNC1 to better handle 
> my cable provider's QAM256 modulated signal. So far the BER value has dropped 
> to zero and things seem to work fine except that I now get the following msgs 
> from time to time:
> 
> "saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer"
> 
> and
> 
> "DVB: TDA10023: tda10023_readreg: readreg error (ret == -512)"
> 
> Also infrequently, it takes a few more extra seconds to tune to another 
> channel after I have been switching around a lot. It's not related to any 
> specific channel and happens (more or less) totally randomly.
> 
> All this worked fine with my old card which had a tda10021 and besides that 
> was mostly the same. I haven't changed anything software-wise between the 
> swap, so it's somehow related to the new card.

Given that your software hasn't changed, and assuming the driver code is
correct (for a large majority of users), then the remaining problem
areas I see are the card itself, the mainboard's PCI bus, and the
possibility of a marginal power supply.  (Can anyone else think of
something else?)

Focusing on the PCI bus:

Can you check the output of
# lspci -nnxxx

for your Host and PCI bridges and the video card?

If you look at register offset 0x07, PCI bus errors of various types
(and DEVSEL timing) are flagged there.

For example, on my machine:

# lspci -nnxxx
00:00.0 Host bridge [0600]: ATI Technologies Inc RS480 Host Bridge [1002:5950] (rev 10)
00: 02 10 50 59 06 00 20 22 10 00 00 06 00 40 00 00
                         ^
                         |
                         |
The host bridge detected a Master Abort on the PCI bus since the machine
was booted.

You may want to reset these error status flags so thay you can see if
actions or logging related to the video card, correlate to any of these
error flags getting set.

To reset the status of this device, so I could run experiments to watch
for what actions caused error flags to be set, I used "setpci" to read
the register and write it back.  (Writing back a 1 to an error status
bit clears the status bit).

# setpci -s 00:00.0 STATUS
2220
# setpci -s 00:00.0 STATUS=2220
# setpci -s 00:00.0 STATUS
0220


Also could you look at the latency timer of all the PCI devices on the
bus?  Values that are very high (e.g. nVidia likes to use 248) and
values less than or equal to 32 (n.b. 0 is OK for some bridge devices)
can cause problems.


The latency timer determines how long a device can grab the bus as a bus
master.  Approximately 4*latency_timer bytes can be transferred before
the master is forced to give up the PCI bus.  Values that are too small
can deny a master the ability to transfer useful amounts of data and
cause aborts.  Values that are too large can hold other devices off of
the bus for a while.  Also, since modern devices are allowed 16 setup
cycles if not ready as a target, latency values less than or equal to 16
could be a problem for masters trying to work with targets that take all
16 cycles occasionally.


Tweaking PCI bus latency timers with "setpci" may resolve your problems.



> By the way, I am using a mercurial checkout from 20 Apr 08.

In the version of saa7146_i2c.c that I am looking at, in the function
saa7146_i2c_writeout(), the code should probably do a read back of the
register it just wrote out before calling
wait_event_interruptable_timeout(), to flush any PCI posted writes down
to actual saa7146 device.  But the timeout is so long, 10 ms, relative
to the maximum PCI latency for any one device (248 bus cycles/33 MHz =
7.5 usecs), that it's probably not an issue.


> If anyone can help me out on this one, I'd greatly appreciate it.
> 
> Here some infos:
> 
> uname -a:
> Linux dreamgate 2.6.25 #1 SMP PREEMPT Sun Apr 20 15:25:13 CEST 2008 x86_64
> AMD Athlon(tm) 64 X2 Dual Core Processor 5600+ AuthenticAMD GNU/Linux


# cat /proc/cpuinfo | grep 'model name' | uniq
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+

:)


> some log:
> May  2 07:03:09 dreamgate Linux video capture interface: v2.00
> May  2 07:03:09 dreamgate saa7146: register extension 'budget_av'.
> May  2 07:03:09 dreamgate saa7146: found saa7146 @ mem ffffc2000002e000 
> (revision 1, irq 16) (0x1894,0x0022).
> May  2 07:03:09 dreamgate saa7146 (0): dma buffer size 192512
> May  2 07:03:09 dreamgate DVB: registering new adapter (KNC1 DVB-C MK3)
> May  2 07:03:09 dreamgate encoded MAC from EEPROM was 
> ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff

I believe this is a log message from an error condition.  The EEPROM on
the i2c bus on the card was not able to be read properly.
(See: linux/drivers/media/dvb/ttpci/ttpci-eeprom.c)

Although I don't know if your "budget_av" supported card would have an
EEPROM or not.


Regards,
Andy

> May  2 07:03:09 dreamgate KNC1-0: MAC addr = 00:09:d6:01:ab:5b
> May  2 07:03:09 dreamgate DVB: registering frontend 0 (Philips TDA10023 
> DVB-C)...
> May  2 07:03:09 dreamgate budget-av: ci interface initialised.
> May  2 07:03:09 dreamgate budget-av: cam inserted A
> May  2 07:03:09 dreamgate dvb_ca adapter 0: DVB CAM detected and initialised 
> successfully
> 
> cat /proc/interrupts:
>            CPU0       CPU1
>   0:         81         35   IO-APIC-edge      timer
>   1:          0          2   IO-APIC-edge      i8042
>   7:          1          0   IO-APIC-edge
>   8:          0          1   IO-APIC-edge      rtc
>   9:          0          0   IO-APIC-fasteoi   acpi
>  12:          0          4   IO-APIC-edge      i8042
>  14:         46      17884   IO-APIC-edge      pata_amd
>  15:          0          0   IO-APIC-edge      pata_amd
>  16:        562     480617   IO-APIC-fasteoi   sata_sil24, saa7146 (0), nvidia
>  20:        149      45696   IO-APIC-fasteoi   ehci_hcd:usb1
>  21:        190      91267   IO-APIC-fasteoi   sata_nv, HDA Intel
>  22:          2        113   IO-APIC-fasteoi   sata_nv
>  23:        109      35363   IO-APIC-fasteoi   sata_nv, ohci_hcd:usb2
> 315:       1073     606201   PCI-MSI-edge      eth2
> NMI:          0          0   Non-maskable interrupts
> LOC:    1150975    1301850   Local timer interrupts
> RES:     214884      78607   Rescheduling interrupts
> CAL:      20235       7779   function call interrupts
> TLB:       1206       1240   TLB shootdowns
> TRM:          0          0   Thermal event interrupts
> THR:          0          0   Threshold APIC interrupts
> SPU:          0          0   Spurious interrupts
> 
> lspci -vvv:
> 02:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: KNC One Device 0022
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
> Stepping- SERR- FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 32 (3750ns min, 9500ns max)
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at fdfff000 (32-bit, non-prefetchable) [size=512]
>         Kernel driver in use: budget_av
>         Kernel modules: budget-av
> 
> Thanks a lot in advance,
> matthew.
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
