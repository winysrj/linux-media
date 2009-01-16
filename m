Return-path: <linux-media-owner@vger.kernel.org>
Received: from ado-01.adocentral.net.au ([203.88.117.121]:42333 "EHLO
	ado-01.adocentral.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbZAPETf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 23:19:35 -0500
Date: Fri, 16 Jan 2009 15:19:32 +1100 (EST)
From: Aaron Theodore <aaron@bat.id.au>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <17229660.2191232079572873.JavaMail.root@ado-01>
In-Reply-To: <18887012.2171232079363334.JavaMail.root@ado-01>
Subject: Re: kernel soft lockup on boot loading cx2388x based DVB-S card
 (TeVii S420)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried:
make rmmod
make rminstall

Although there were still some drivers left over from "tevii_linuxdriver_0815"

/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/dvb-usb/dvb-usb-s600.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/dvb-usb/dvb-usb-s650.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36067.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36060.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36050.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/saa7134/saa7134-oss.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/zr36016.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/tuner-3036.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/videocodec.ko
/lib/modules/2.6.24-etchnhalf.1-686/kernel/drivers/media/video/dpc7146.ko

so i just removed manually and rebooted.
Same issue occurred on reboot.

So i thought to try manually unloading and reloading the module


barry:~# rmmod cx8802
barry:~# modprobe cx8802   

kernel: cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
kernel: cx88[0]/2: cx2388x 8802 Driver Manager
kernel: ACPI: PCI Interrupt 0000:05:08.2[A] -> Link [APC3] -> GSI 18 (level, low) -> IRQ 18
kernel: cx88[0]/2: found at 0000:05:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xd9000000
kernel: cx88/2: cx2388x dvb driver version 0.0.6 loaded
kernel: cx88/2: registering cx8802 driver, type: dvb access: shared
kernel: cx88[0]/2: subsystem: d420:9022, board: TeVii S420 DVB-S [card=73]
kernel: cx88[0]/2: cx2388x based DVB/ATSC card
kernel: cx8802_alloc_frontends() allocating 1 frontend(s)
kernel: DVB: registering new adapter (cx88[0])
kernel: DVB: registering adapter 2 frontend 0 (ST STV0288 DVB-S)...


This time it makes the devices in /dev/dvb/
Now unfortunately i can't test to see if it can actually Tune until a few hours time when i get home (i think i forgot to plug my satellite cable back in!)

Will report back later


Can i change the load order of kernel modules, it dosnt seem to like being loaded before my other dvb modules


Aaron


----- "Mauro Carvalho Chehab" <mchehab@infradead.org> wrote:

> On Fri, 16 Jan 2009 06:56:05 +1100
> Aaron Theodore <aaron@bat.id.au> wrote:
> 
> > Mauro,
> > 
> > Thanks for the speedy patch!
> 
> You should thanks to Andy. He is the author of this patch ;)
> 
> > My system can at least boot now, but has issues loading the
> frontend.
> > DVB: Unable to find symbol stv0299_attach()
> > DVB: Unable to find symbol stv0288_attach()
> 
> It seems that you didn't compile those two frontends.
> 
> Cheers,
> Mauro
