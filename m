Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4583 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZFKUSU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:18:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Thu, 11 Jun 2009 22:18:10 +0200
Cc: "Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org>
In-Reply-To: <20090611221402.66709817@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112218.11016.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> Hi all,
> 
> With Linux 2.6.30 the BTTV driver for my WinTV card claims
> 
> 	bttv0: audio absent, no audio device found!
> 
> and audio does not work. This worked up to and including 2.6.29. Is this a
> known issue? Does anyone have a fix or a patch for me to try?

You've no doubt compiled the bttv driver into the kernel and not as a module.

I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb

Regards,

	Hans

> 
> Cheers,
> 
> 	- Udo
> 
> 
> Output for 2.6.29:
> ------------------
> Linux video capture interface: v2.00
> bttv: driver version 0.9.17 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Bt8xx card found (0).
> bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
> bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
> bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
> bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> tuner' 0-0042: chip found @ 0x84 (bt878 #0 [sw])
> tda9887 0-0042: creating new instance
> tda9887 0-0042: tda988[5/6/7] found
> tuner' 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
> tveeprom 0-0050: Hauppauge model 37284, rev B221, serial# 3546046
> tveeprom 0-0050: tuner model is Philips FM1216 (idx 21, type 5)
> tveeprom 0-0050: TV standards PAL(B/G) (eeprom 0x04)
> tveeprom 0-0050: audio processor is MSP3410D (idx 5)
> tveeprom 0-0050: has radio
> bttv0: Hauppauge eeprom indicates model#37284
> bttv0: tuner type=5
> tuner-simple 0-0061: creating new instance
> tuner-simple 0-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: registered device radio0
> bttv0: PLL: 28636363 => 35468950 .. ok
> 
> Output for 2.6.30:
> ------------------
> Linux video capture interface: v2.00
> bttv: driver version 0.9.18 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Bt8xx card found (0).
> bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
> bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
> bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
> bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> tveeprom 1-0050: Hauppauge model 37284, rev B221, serial# 3546046
> tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
> tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
> tveeprom 1-0050: audio processor is MSP3410D (idx 5)
> tveeprom 1-0050: has radio
> bttv0: Hauppauge eeprom indicates model#37284
> bttv0: tuner type=5
> tuner 1-0042: chip found @ 0x84 (bt878 #0 [sw])
> tda9887 1-0042: creating new instance
> tda9887 1-0042: tda988[5/6/7] found
> tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
> bttv0: audio absent, no audio device found!
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: registered device radio0
> 
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
