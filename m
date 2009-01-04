Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.186])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <peter@hoeg.com>) id 1LJMS9-0004Az-7C
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 07:27:18 +0100
Received: by ti-out-0910.google.com with SMTP id w7so5802983tib.13
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 22:27:07 -0800 (PST)
Message-ID: <496056B4.4050603@hoeg.com>
Date: Sun, 04 Jan 2009 14:27:00 +0800
From: Peter Hoeg <peter@hoeg.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
References: <loom.20090103T043514-870@post.gmane.org>
	<200901031727.26569.hfvogt@gmx.net>
In-Reply-To: <200901031727.26569.hfvogt@gmx.net>
Content-Type: multipart/mixed; boundary="------------040303000200090807010304"
Cc: linux-dvb@linuxtv.org
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

This is a multi-part message in MIME format.
--------------040303000200090807010304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hans-Frieder,

> Hi Peter, hi List,
> 
> attached is a patch that enables MSI on the cx23885. I tested this patch for a 
> while now on a Dvico FusionHDTV Dual Express and have not found any side 
> effects. It works on versions 2.6.27.x and 2.6.28. 2.6.28-gitx not tried yet.

I applied your patch against trunk v4l-dvb tree on stock Ubuntu kernel
2.6.27-9.

While the module loads properly when passed enable_msi=1 and
/proc/interrupts as well as lspci tell me that everything should be set
up fine, I am not getting any interrupts delivered as per attached
output of:
  cat /proc/interrupts

For troubleshooting purposes I have also attached the output of:
  dmesg | egrep -i "tv|dvb|haupp|cx|tda"

/peter


--------------040303000200090807010304
Content-Type: text/plain;
 name="ints.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ints.txt"

           CPU0       CPU1       CPU2       CPU3       
  0:         97          0          0          0   IO-APIC-edge      timer
  1:          2          0          0          0   IO-APIC-edge      i8042
  7:          1          0          0          0   IO-APIC-edge    
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 14:          0          0          0          0   IO-APIC-edge      pata_amd
 15:          0          0          0          0   IO-APIC-edge      pata_amd
 19:          3          0          0          0   IO-APIC-fasteoi   ohci1394
 22:          0          0          0          0   IO-APIC-fasteoi   ohci_hcd:usb2
 23:      36617          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
2296:      80049          0          0          0   PCI-MSI-edge      eth0
2297:      28609          0          0          0   PCI-MSI-edge      nvidia
2298:          0          0          0          0   PCI-MSI-edge      cx23885[0]
2299:      93157          0          0          0   PCI-MSI-edge      HDA Intel
2300:      40654          0          0          0   PCI-MSI-edge      ahci
NMI:          0          0          0          0   Non-maskable interrupts
LOC:      71788      53748      36915      41838   Local timer interrupts
RES:       1833       1221       2251       1362   Rescheduling interrupts
CAL:       8509      14113      12544      12361   function call interrupts
TLB:        904       2409       1062       2674   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts
ERR:          1

--------------040303000200090807010304
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[   10.300582] cx23885 driver version 0.0.1 loaded
[   10.301146] cx23885 0000:04:00.0: PCI INT A -> Link[APC8] -> GSI 16 (level, low) -> IRQ 16
[   10.301284] CORE cx23885[0]: subsystem: 0070:71d3, board: Hauppauge WinTV-HVR1200 [card=7,autodetected]
[   10.467050] tveeprom 0-0050: Hauppauge model 71949, rev H2E9, serial# 3390611
[   10.467120] tveeprom 0-0050: MAC address is 00-0D-FE-33-BC-93
[   10.467185] tveeprom 0-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
[   10.467259] tveeprom 0-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[   10.467337] tveeprom 0-0050: audio processor is CX23885 (idx 39)
[   10.467402] tveeprom 0-0050: decoder processor is CX23885 (idx 33)
[   10.467468] tveeprom 0-0050: has no radio
[   10.467531] cx23885[0]: hauppauge eeprom: model=71949
[   10.467597] cx23885_dvb_register() allocating 1 frontend(s)
[   10.467687] cx23885[0]: cx23885 based dvb card
[   10.926369] tda829x 1-0042: type set to tda8295
[   11.068189] tda18271 1-0060: creating new instance
[   11.104359] TDA18271HD/C1 detected @ 1-0060
[   12.165988] DVB: registering new adapter (cx23885[0])
[   12.166056] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
[   12.166548] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   12.166617] cx23885[0]/0: found at 0000:04:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xef800000
[   12.166697] cx23885 0000:04:00.0: setting latency timer to 64
[  373.247511] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
[  373.247518] firmware: requesting dvb-fe-tda10048-1.0.fw
[  373.262265] tda10048_firmware_upload: firmware read 24878 bytes.
[  373.262270] tda10048_firmware_upload: firmware uploading
[  375.822028] tda10048_firmware_upload: firmware uploaded

--------------040303000200090807010304
Content-Type: text/plain;
 name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="lspci.txt"

04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885 PCI Video and Audio Decoder (rev 02)
	Subsystem: Hauppauge computer works Inc. Device 71d3
	Flags: bus master, fast devsel, latency 0, IRQ 2298
	Memory at ef800000 (64-bit, non-prefetchable) [size=2M]
	Capabilities: [40] Express Endpoint, MSI 00
	Capabilities: [80] Power Management version 2
	Capabilities: [90] Vital Product Data <?>
	Capabilities: [a0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable+
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [200] Virtual Channel <?>
	Kernel driver in use: cx23885
	Kernel modules: cx23885


--------------040303000200090807010304
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------040303000200090807010304--
