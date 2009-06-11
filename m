Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3676 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZFKVrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 17:47:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Udo A. Steinberg" <udo@hypervisor.org>
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Thu, 11 Jun 2009 23:46:48 +0200
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org> <200906112218.11016.hverkuil@xs4all.nl> <20090611233817.757933aa@laptop.hypervisor.org>
In-Reply-To: <20090611233817.757933aa@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906112346.48528.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 11 June 2009 23:38:17 Udo A. Steinberg wrote:
> On Thu, 11 Jun 2009 22:18:10 +0200 Hans Verkuil (HV) wrote:
> 
> HV> On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> HV> > Hi all,
> HV> > 
> HV> > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> HV> > 
> HV> > 	bttv0: audio absent, no audio device found!
> HV> > 
> HV> > and audio does not work. This worked up to and including 2.6.29. Is
> HV> > this a known issue? Does anyone have a fix or a patch for me to try?
> HV> 
> HV> You've no doubt compiled the bttv driver into the kernel and not as a
> HV> module.
> HV> 
> HV> I've just pushed a fix for this to my tree:
> HV> http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> 
> Yes, I've compiled bttv into the kernel. I've (hopefully correctly) ported
> the commit http://www.linuxtv.org/hg/~hverkuil/v4l-dvb/rev/820630b2b12f
> to 2.6.30. Now I'm getting:
> 
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
> ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-1/1-0018/ir0 [bt878 #0 [sw]]
> i2c-adapter i2c-1: sendbytes: NAK bailout.
> tveeprom 1-0050: Huh, no eeprom present (err=-5)?
> tveeprom 1-0050: Encountered bad packet header [00]. Corrupt or not a Hauppauge eeprom.
> bttv0: Hauppauge eeprom indicates model#0
> bttv0: tuner absent
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: PLL: 28636363 => 35468950

Hmm, my patch needs a bit more work. But to get your setup working try to
revert the change you made and do just this:

Go to drivers/media/video/Makefile and move this line:

obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o

in front of this line:

obj-$(CONFIG_VIDEO_BT848) += bt8xx/

Recompile and see if that is working.

I got the tveeprom error as well when I tested with ivtv, but I thought that
had something to do with the ivtv driver. Apparently not, so I need to dig a
bit more into these dependencies.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
