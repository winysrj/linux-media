Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <frank-info@gmx.de>) id 1PJCCH-0004Rd-Oi
	for linux-dvb@linuxtv.org; Thu, 18 Nov 2010 22:39:14 +0100
Received: from mailout-de.gmx.net ([213.165.64.23] helo=mail.gmx.net)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with smtp
	for <linux-dvb@linuxtv.org>
	id 1PJCCH-0005cg-7J; Thu, 18 Nov 2010 22:39:13 +0100
From: Frank Wohlfahrt <frank-info@gmx.de>
To: linux-dvb@linuxtv.org
Date: Thu, 18 Nov 2010 22:39:11 +0100
References: <ku687hpo17bl3c26ogyuaqiy.1290078006370@email.android.com>
In-Reply-To: <ku687hpo17bl3c26ogyuaqiy.1290078006370@email.android.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201011182239.11736.frank-info@gmx.de>
Subject: Re: [linux-dvb] cx23885 crashes with TeVii S470
Reply-To: linux-media@vger.kernel.org, frank-info@gmx.de
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

Hi Andy,

Can you give me a help how I can disable MSI ? Is it possible via module 
parameter in /etc/modprobe.d or do I have to change the source ? I did not 
find "MSI" inside.

I downloaded v4l-dvb with

  hg clone http://linuxtv.org/hg/v4l-dvb

and would like to generate a DKMS build.

Frank

Maybe this helps for more diagnosis:

frank@mond:~$ sudo lspci -v -s 2:0.0 
02:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video 
and Audio Decoder (rev 02)
	Subsystem: Device d470:9022
	Flags: bus master, fast devsel, latency 0, IRQ 19
	Memory at fba00000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 
Enable-
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885

frank@mond:~$ cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       
  0:         47          0          0          0   IO-APIC-edge      timer
  1:          3          1          2          2   IO-APIC-edge      i8042
  4:          1          1          1          0   IO-APIC-edge    
  7:          0          0          0          0   IO-APIC-edge      parport0
  8:          0          1          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 16:     366880     366692     367157     366829   IO-APIC-fasteoi   
ehci_hcd:usb1, ahci, saa7146 (0)
 17:      19653      19649      19647      19650   IO-APIC-fasteoi   
pata_jmicron
 19:      51658      51633      51139      51560   IO-APIC-fasteoi   ata_piix, 
ata_piix, cx23885[0]
 23:        159        157        154        162   IO-APIC-fasteoi   
ehci_hcd:usb2
 24:          3          0          0          0  HPET_MSI-edge      hpet2
 25:          0          0          0          0  HPET_MSI-edge      hpet3
 26:          0          0          0          0  HPET_MSI-edge      hpet4
 27:          0          0          0          0  HPET_MSI-edge      hpet5
 33:        538        548        541        534   PCI-MSI-edge      eth0
 34:          8          3          2          4   PCI-MSI-edge      i915
 35:       5782       6001       6040       5941   PCI-MSI-edge      hda_intel
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     764413     802929     744313     628137   Local timer interrupts
SPU:          0          0          0          0   Spurious interrupts
PMI:          0          0          0          0   Performance monitoring 
interrupts
PND:          0          0          0          0   Performance pending work
RES:       5054       6030       4884       3466   Rescheduling interrupts
CAL:         58         70         47         68   Function call interrupts
TLB:        404        469        612        542   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
MCE:          0          0          0          0   Machine check exceptions
MCP:          5          5          5          5   Machine check polls
ERR:          3
MIS:          0

Am Donnerstag 18 November 2010 schrieben Sie:
> Try reverting the change that enabled MSI in cx23885.
>
> R,
> Andy


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
