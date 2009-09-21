Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:39138 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277AbZIUBnR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2009 21:43:17 -0400
Subject: Re: Audio drop on saa7134
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Liontooth <lionteeth@cogweb.net>, linux-media@vger.kernel.org
In-Reply-To: <20090920060218.51971a45@pedra.chehab.org>
References: <4AAEFEC9.3080405@cogweb.net>
	 <20090915000841.56c24dd6@pedra.chehab.org> <4AAF11EC.3040800@cogweb.net>
	 <1252988501.3250.62.camel@pc07.localdom.local>
	 <4AAF232F.9060204@cogweb.net>
	 <1252993000.3250.97.camel@pc07.localdom.local>
	 <4AAF2F1B.2050206@cogweb.net> <4AB5E6AC.1090505@cogweb.net>
	 <20090920060218.51971a45@pedra.chehab.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 03:30:15 +0200
Message-Id: <1253496615.3257.25.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Sonntag, den 20.09.2009, 06:02 -0300 schrieb Mauro Carvalho Chehab:
> Em Sun, 20 Sep 2009 01:24:12 -0700
> David Liontooth <lionteeth@cogweb.net> escreveu:
> 
> > Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> > Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbbbb
> 
> This means mute. With this, audio will stop.
> 
> > Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x464 = 0x000000
> > Sep 18 07:00:01 prato kernel: saa7133[4]/audio: dsp write reg 0x46c = 0xbbbb10
> 
> This means unmute.
> 
> It seems that the auto-mute code is doing some bad things for you. What happens
> if you disable automute? This is a control that you can access via v4l2ctl or
> on your userspace application.
> 
> Are you using the last version of the driver? I'm not seeing some debug log messages
> that should be there...
> 
> 
> 
> Cheers,
> Mauro

despite of still 1001 messages unread, Mauro is right here.

You are also for sure not on a saa7134, likely you would not ever had a
reason to come up here on such. But the much better is to have you now.

Means, you are at least on a saa7133, not able to decode stereo TV sound
on PAL and SECAM systems, vice versa counts for the saa7134 on SYSTEM-M.

The automute is for convenience of the users, say not to have loud noise
on channel switching. It is also controlled by different registers for
analog sound and PCI dma sound.

If debugging those issues, one more thing to mention is that external
video in without audio will kick in mute on those cards too at the first
round.

It should be possible to disable all such funny stuff on production
systems, pleasant for the average user's conditions, and then see if
anything should still remain.

On bad mobos, needing PCI quirks and other such stuff, we are likely not
any further than what you have seen on bttv previously, but in 99.9
percent of the known cases it seems to work.

Else Mauro again is right, even audio_debug = 1 should deliver the
related mute ioctl prints.

Cheers,
Hermann


