Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052Ab2CWVbx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Mar 2012 17:31:53 -0400
Message-ID: <4F6CEBBA.6050705@redhat.com>
Date: Fri, 23 Mar 2012 18:31:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Paulo Cavalcanti <promac@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
Subject: Re: bttv 0.9.19 driver
References: <CAMgUmn=XLnTbKJaOegStdi8bDwO2GfnohuODFr8=UTaSeJeFgg@mail.gmail.com>
In-Reply-To: <CAMgUmn=XLnTbKJaOegStdi8bDwO2GfnohuODFr8=UTaSeJeFgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Paulo,

Em 23-03-2012 07:14, Paulo Cavalcanti escreveu:
> 
> Hi,
> 
> I have been using an analog bttv capture card (a Pixelview PV-M4900 FM.RC - PV-BT878P+ (Rev.4C,8E)) since 2006 with these parameters
> in modprobe.conf:
> 
> options bttv card=70 radio=1 tuner=69 audiomux=0x21,0x20,0x23,0x23,
> 0x28 gpiomask=0x3f vcr_hack=1 chroma_agc=1
> 
> However, since RHLE6 start shipping the kernel-2.6.32-220 series, the radio does not work any more (the TV is fine, though).
> 
> I have another computer running Fedora with kernel 2.6.35.14 with the same card, and
> I tried to update video4linux to the newest snapshot and the same thing happened.
> In /var/log/messages I only see these differences:
> 
> bttv driver 0.9.18 <----- work
> 
> tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
> Mar 19 17:24:43 cascavel kernel: [    8.332740] tuner-simple 1-0061: creating new instance
> Mar 19 17:24:43 cascavel kernel: [    8.332744] tuner-simple 1-0061: type set to 69 (Tena TNF 5335 and similar models)
> 
> 
> bttv driver 0.9.19 <------ broke
> 
> Mar 21 18:18:55 cascavel kernel: [    6.492175] tuner 1-0061: Tuner -1 found with type(s) Radio TV.
> Mar 21 18:18:55 cascavel kernel: [    6.533837] tuner-simple 1-0061: creating new instance
> Mar 21 18:18:55 cascavel kernel: [    6.533841] tuner-simple 1-0061: type set to 69 (Tena TNF 5335 and similar models)
> 
> The rest of the log is the same:
> 
> bttv: driver version 0.9.19 loaded
> Mar 21 21:44:36 cascavel kernel: [    7.978998] bttv: using 8 buffers with 2080k (520 pages) each for capture
> Mar 21 21:44:36 cascavel kernel: [    7.979161] bttv: Bt8xx card found (0)
> Mar 21 21:44:36 cascavel kernel: [    7.979186] bttv 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> Mar 21 21:44:36 cascavel kernel: [    7.979195] bttv: 0: Bt878 (rev 17) at 0000:04:00.0, irq: 21, latency: 32, mmio: 0xe3101000
> Mar 21 21:44:36 cascavel kernel: [    7.979227] bttv: 0: detected: Prolink Pixelview PV-BT [card=72], PCI subsystem ID is 1554:4011
> Mar 21 21:44:36 cascavel kernel: [    7.979230] bttv: 0: using: Prolink Pixelview PV-BT878P+ (Rev.4C,8E) [card=70,insmod option]
> Mar 21 21:44:36 cascavel kernel: [    7.979232] bttv: 0: gpio config override: mask=0x3f, mux=0x21,0x20,0x23,0x23
> Mar 21 21:44:36 cascavel kernel: [    7.979319] bttv: 0: tuner type=69
> 
> It is like I could not change the radio stations any more, because I only hear noise, and some times the last TV channel
> synchronized.
> 
> Does anyone know if anything has changed in the new bttv driver?

There was a known regression at the radio core. Not sure when it happened, nor on what
kernel it were fixed. Could you please test a 3.x kernel?

If you're a RHEL6 customer, you can open a case with via the proper
Red Hat channels, in order to backport fix it on RHEL6 kernel.
Yet, even in this case, it would be important to test the latest kernel,
to see if the fixes applied upstream fixes the issue.

Thanks,
Mauro.
