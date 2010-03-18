Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mylists@wilsononline.id.au>) id 1Ns72u-0000jb-5b
	for linux-dvb@linuxtv.org; Thu, 18 Mar 2010 05:09:21 +0100
Received: from m0-if0.velocitynet.com.au ([203.17.154.50]
	helo=m0.velocity.net.au)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-a) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Ns72s-0004ZR-Ug; Thu, 18 Mar 2010 05:09:19 +0100
Received: from [192.168.0.10] (110.143.46.202-static.velocitynet.com.au
	[202.46.143.110])
	by m0.velocity.net.au (Postfix) with ESMTP id E902F6012B
	for <linux-dvb@linuxtv.org>; Thu, 18 Mar 2010 15:09:09 +1100 (EST)
Message-ID: <4BA1A766.3020406@wilsononline.id.au>
Date: Thu, 18 Mar 2010 15:09:10 +1100
From: Paul <mylists@wilsononline.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] audio drive fails to initialise after latest FC12 kernel
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have a digitalnow DNTV Live! DVB-T Pro [card=42,] which has a Audio 
input jack, and after the new cx88 drivers which the kernal I don't see 
that audio device any more
uname -a
Linux mythbox.salsola 2.6.32.9-70.fc12.i686 #1 SMP Wed Mar 3 05:14:32 
UTC 2010 i686 athlon i386 GNU/Linux

here are copies of my /var/log/dmesg from the boot

working dmesg file:
cx88[0]: subsystem: 1822:0025, board: digitalnow DNTV Live! DVB-T Pro 
[card=42,insmod option], frontend(s): 1
cx88[0]: TV tuner type 63, Radio tuner type -1
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
Intel ICH 0000:00:04.0: PCI INT A -> Link[APCJ] -> GSI 22 (level, low) 
-> IRQ 22
Intel ICH 0000:00:04.0: setting latency timer to 64
tuner 5-0061: chip found @ 0xc2 (cx88[0])
tuner-simple 5-0061: creating new instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
input: cx88 IR (digitalnow DNTV Live!  as 
/devices/pci0000:00/0000:00:09.0/0000:01:08.2/input/input5
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC1] -> GSI 16 
(level, low) -> IRQ 16
cx88[0]/2: found at 0000:01:08.2, rev: 5, irq: 16, latency: 32, mmio: 
0xf7000000
IRQ 16/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx8800 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> 
IRQ 16
cx88[0]/0: found at 0000:01:08.0, rev: 5, irq: 16, latency: 32, mmio: 
0xf5000000
IRQ 16/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88_audio 0000:01:08.1: PCI INT A -> Link[APC1] -> GSI 16 (level, low) 
-> IRQ 16
IRQ 16/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 1822:0025, board: digitalnow DNTV Live! DVB-T Pro 
[card=42]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
tuner-simple 5-0061: attaching existing instance
tuner-simple 5-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
DVB: registering new adapter (cx88[0])
DVB: registering adapter 1 frontend 0 (Zarlink MT352 DVB-T)...


not working dmesg:

cx88[0]: subsystem: 1822:0025, board: digitalnow DNTV Live! DVB-T Pro 
[card=42,insmod option], frontend(s): 1
cx88[0]: TV tuner type 63, Radio tuner type -1
HDA Intel 0000:05:00.1: PCI INT A -> Link[APC3] -> GSI 18 (level, low) 
-> IRQ 18
HDA Intel 0000:05:00.1: setting latency timer to 64
DiB0070: successfully identified
dvb-usb: Artec T14BR DVB-T successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
intel8x0_measure_ac97_clock: measured 50907 usecs (2504 samples)
intel8x0: clocking to 46841
tuner 7-0043: chip found @ 0x86 (cx88[0])
ALSA sound/pci/hda/hda_generic.c:683: hda_generic: no proper input path 
found
ALSA sound/pci/hda/hda_generic.c:431: hda_generic: no proper output path 
found
ALSA sound/pci/hda/hda_generic.c:683: hda_generic: no proper input path 
found
ALSA sound/pci/hda/hda_generic.c:431: hda_generic: no proper output path 
found
tda9887 7-0043: creating new instance
tda9887 7-0043: tda988[5/6/7] found
udev: renamed network interface eth0 to eth2
tuner 7-0061: chip found @ 0xc2 (cx88[0])
udev: renamed network interface _rename to eth0
ALSA sound/pci/hda/hda_generic.c:683: hda_generic: no proper input path 
found
ALSA sound/pci/hda/hda_generic.c:431: hda_generic: no proper output path 
found
ALSA sound/pci/hda/hda_generic.c:683: hda_generic: no proper input path 
found
ALSA sound/pci/hda/hda_generic.c:431: hda_generic: no proper output path 
found
ALSA sound/pci/hda/hda_generic.c:1030: hda_generic: no PCM found
ALSA sound/pci/hda/hda_generic.c:1030: hda_generic: no PCM found
ALSA sound/pci/hda/hda_generic.c:1030: hda_generic: no PCM found
ALSA sound/pci/hda/hda_generic.c:1030: hda_generic: no PCM found
tuner-simple 7-0061: creating new instance
tuner-simple 7-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
input: cx88 IR (digitalnow DNTV Live!  as 
/devices/pci0000:00/0000:00:09.0/0000:01:08.2/input/input5
cx88[0]/2: cx2388x 8802 Driver Manager
ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC1] -> GSI 16 
(level, low) -> IRQ 16
cx88[0]/2: found at 0000:01:08.2, rev: 5, irq: 16, latency: 32, mmio: 
0xf7000000
IRQ 16/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
ALSA sound/core/init.c:197: cannot find the slot for index 1 (range 
0-7), error: -16
cx88_audio: probe of 0000:01:08.1 failed with error -16
cx8800 0000:01:08.0: PCI INT A -> Link[APC1] -> GSI 16 (level, low) -> 
IRQ 16
cx88[0]/0: found at 0000:01:08.0, rev: 5, irq: 16, latency: 32, mmio: 
0xf5000000
IRQ 16/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88/2: cx2388x dvb driver version 0.0.7 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 1822:0025, board: digitalnow DNTV Live! DVB-T Pro 
[card=42]
cx88[0]/2: cx2388x based DVB/ATSC card
cx8802_alloc_frontends() allocating 1 frontend(s)
tuner-simple 7-0061: attaching existing instance
tuner-simple 7-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
