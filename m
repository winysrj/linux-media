Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:37111 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab2BHH5F (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Feb 2012 02:57:05 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] tea575x-tuner improvements & use in maxiradio
Date: Wed, 8 Feb 2012 08:56:45 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1328447827-9842-1-git-send-email-hverkuil@xs4all.nl> <201202072320.30911.linux@rainbow-software.org> <201202080829.25201.hverkuil@xs4all.nl>
In-Reply-To: <201202080829.25201.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202080856.46025.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 08 February 2012, you wrote:
> On Tuesday, February 07, 2012 23:20:19 Ondrej Zary wrote:
> > On Sunday 05 February 2012 14:17:05 Hans Verkuil wrote:
> > > These patches improve the tea575x-tuner module to make it up to date
> > > with the latest V4L2 frameworks.
> > >
> > > The maxiradio driver has also been converted to use the tea575x-tuner
> > > and I've used that card to test it.
> > >
> > > Unfortunately, this card can't read the data pin, so the new hardware
> > > seek functionality has been tested only partially (yes, it seeks, but
> > > when it finds a channel I can't read back the frequency).
> > >
> > > Ondrej, are you able to test these patches for the sound cards that use
> > > this tea575x tuner?
> > >
> > > Note that these two patches rely on other work that I did and that
> > > hasn't been merged yet. So it is best to pull from my git tree:
> > >
> > > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/radi
> > >o-pc i2
> > >
> > > You can use the v4l-utils repository
> > > (http://git.linuxtv.org/v4l-utils.git) to test the drivers: the
> > > v4l2-compliance test should succeed and with v4l2-ctl you can test the
> > > hardware seek:
> > >
> > > To seek down:
> > >
> > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=0
> > >
> > > To seek up:
> > >
> > > v4l2-ctl -d /dev/radio0 --freq-seek=dir=1
> > >
> > > To do the compliance test:
> > >
> > > v4l2-compliance -r /dev/radio0
> >
> > It seems to work (tested with SF64-PCR - snd_fm801) but the seek is
> > severely broken. Reading the frequency immediately after seek does not
> > work, it always returns the old value (haven't found a delay that works).
> > Reading it later (copied back snd_tea575x_get_freq function) works. The
> > chip seeks randomly up or down, ignoring UP/DOWN flag and often stops at
> > wrong place (only noise) or even outside the FM range.
> >
> > So I strongly suggest not to enable this (mis-)feature. The HW seems to
> > be completely broken (unless there's some weird bug in the code).
>
> Well, it seemed like a good idea at the time :-) I'll remove this
> 'feature', it's really not worth our time to try and make this work for
> these old cards.

I'll test it with other cards, maybe it will work at least a bit. And also 
with original (Windows) software - it has some seek functionality, IIRC.

> I wonder if you are able to test the ISA radio-sf16fmr2.c driver? I'm not
> sure if you have the hardware, but since I changed this driver to use the
> proper isa kernel framework I'd like to have this tested if possible.

Yes, I have the card so I'll test it. All I can say right now is that the 
driver did not build yesterday (missing #include <linux/slab.h>).


-- 
Ondrej Zary
