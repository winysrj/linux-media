Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <hfvogt@gmx.net>) id 1LJbY7-0006f8-D7
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 23:34:25 +0100
From: "Hans-Frieder Vogt" <hfvogt@gmx.net>
To: Peter Hoeg <peter@hoeg.com>,
 linux-dvb@linuxtv.org
Date: Sun, 4 Jan 2009 23:33:47 +0100
References: <loom.20090103T043514-870@post.gmane.org>
	<200901031727.26569.hfvogt@gmx.net> <496056B4.4050603@hoeg.com>
In-Reply-To: <496056B4.4050603@hoeg.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LlTYJlDqb6UoHHk"
Message-Id: <200901042333.47704.hfvogt@gmx.net>
Subject: Re: [linux-dvb] HVR-1200,
	cx23885 driver and Message Signaled Interrupts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_LlTYJlDqb6UoHHk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Sunday 04 January 2009 07:27:00 schrieben Sie:
> Hans-Frieder,
>
> > Hi Peter, hi List,
> >
> > attached is a patch that enables MSI on the cx23885. I tested this patch
> > for a while now on a Dvico FusionHDTV Dual Express and have not found any
> > side effects. It works on versions 2.6.27.x and 2.6.28. 2.6.28-gitx not
> > tried yet.
>
> I applied your patch against trunk v4l-dvb tree on stock Ubuntu kernel
> 2.6.27-9.
>
> While the module loads properly when passed enable_msi=1 and
> /proc/interrupts as well as lspci tell me that everything should be set
> up fine, I am not getting any interrupts delivered as per attached
> output of:
>   cat /proc/interrupts
>
> For troubleshooting purposes I have also attached the output of:
>   dmesg | egrep -i "tv|dvb|haupp|cx|tda"
>
> /peter

Hm, strange!

I attached the same data that you collected for my environment. The only 
difference that I see is, that I get in dmesg (or kern.log) immediately after 
the line
cx23885 0000:03:00.0: setting latency timer to 64
the confirmation that MSI is activated:
cx23885 0000:03:00.0: irq 315 for MSI/MSI-X

It seems that for your card, the PCI code is stuck halfways?!
As you have other devices running with MSI, can you please check whether you 
see a line ... irq xyz for MSI/MSI-X for them? This would narrow down the 
region in the code to search for the problem.

Regards,
Hans-Frieder




--Boundary-00=_LlTYJlDqb6UoHHk
Content-Type: text/plain;
  charset="UTF-8";
  name="kern.log-cx23885.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kern.log-cx23885.out"

[    8.928904] cx23885 driver version 0.0.1 loaded
[    8.930726] cx23885 0000:03:00.0: PCI INT A -> Link[LN0A] -> GSI 19 (level, low) -> IRQ 19
[    8.931185] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express [card=11,autodetected]
[    9.258821] input: i2c IR (FusionHDTV) as /devices/virtual/input/input2
[    9.317611] ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-0/0-006b/ir0 [cx23885[0]]
[    9.318109] cx23885_dvb_register() allocating 1 frontend(s)
[    9.318178] cx23885[0]: cx23885 based dvb card
[    9.398854] xc2028 0-0061: creating new instance
[    9.398916] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
[    9.398980] DVB: registering new adapter (cx23885[0])
[    9.399036] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
[    9.399555] cx23885_dvb_register() allocating 1 frontend(s)
[    9.399612] cx23885[0]: cx23885 based dvb card
[    9.400354] xc2028 1-0061: creating new instance
[    9.400408] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
[    9.400464] DVB: registering new adapter (cx23885[0])
[    9.400519] DVB: registering adapter 1 frontend 0 (Zarlink ZL10353 DVB-T)...
[    9.400927] cx23885_dev_checkrevision() Hardware revision = 0xb0
[    9.400990] cx23885[0]/0: found at 0000:03:00.0, rev: 2, irq: 19, latency: 0, mmio: 0xfea00000
[    9.401069] cx23885 0000:03:00.0: setting latency timer to 64
[    9.401140] cx23885 0000:03:00.0: irq 315 for MSI/MSI-X
[   34.554403] i2c-adapter i2c-0: firmware: requesting xc3028-v27.fw
[   34.655312] xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   34.856389] xc2028 0-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   36.003429] xc2028 0-0061: Loading firmware for type=D2633 DTV8 (210), id 0000000000000000.
[   36.017390] xc2028 0-0061: Loading SCODE for type=DTV78 ZARLINK456 SCODE HAS_IF_4760 (62000100), id 0000000000000000.
[   36.381875] i2c-adapter i2c-1: firmware: requesting xc3028-v27.fw
[   36.393020] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[   36.393225] xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 0000000000000000.
[   37.336752] xc2028 1-0061: Loading firmware for type=D2633 DTV8 (210), id 0000000000000000.
[   37.350886] xc2028 1-0061: Loading SCODE for type=DTV78 ZARLINK456 SCODE HAS_IF_4760 (62000100), id 0000000000000000.
[  177.654931] xc2028 1-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[  177.669134] xc2028 1-0061: Loading SCODE for type=DTV78 ZARLINK456 SCODE HAS_IF_4760 (62000100), id 0000000000000000.

--Boundary-00=_LlTYJlDqb6UoHHk
Content-Type: text/plain;
  charset="UTF-8";
  name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci.txt"

03:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02)
	Subsystem: DViCO Corporation Device db78
	Flags: bus master, fast devsel, latency 0, IRQ 315
	Memory at fea00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885


--Boundary-00=_LlTYJlDqb6UoHHk
Content-Type: text/plain;
  charset="UTF-8";
  name="proc_int.out"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc_int.out"

           CPU0       CPU1       
  0:         45          1   IO-APIC-edge      timer
  1:          0          2   IO-APIC-edge      i8042
  6:          0          5   IO-APIC-edge      floppy
  7:          1          0   IO-APIC-edge    
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          0          5   IO-APIC-edge      i8042
 20:          1        668   IO-APIC-fasteoi   nvidia
 21:          0          0   IO-APIC-fasteoi   ehci_hcd:usb3
 22:          0          0   IO-APIC-fasteoi   ohci_hcd:usb2, ohci_hcd:usb4
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
314:          6      13426   PCI-MSI-edge      eth1
315:          3       2383   PCI-MSI-edge      cx23885[0]
316:          0        215   PCI-MSI-edge      HDA Intel
317:         11      11955   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:      27488      21523   Local timer interrupts
RES:       2678       2372   Rescheduling interrupts
CAL:       1001         85   Function call interrupts
TLB:        417        173   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          1
MIS:          0

--Boundary-00=_LlTYJlDqb6UoHHk
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_LlTYJlDqb6UoHHk--
