Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43571 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZFKXHw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 19:07:52 -0400
Date: Thu, 11 Jun 2009 20:07:46 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, v4l-dvb-maintainer@linuxtv.org,
	"Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090611200746.40b14855@pedra.chehab.org>
In-Reply-To: <200906120026.13897.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906112222.50283.hverkuil@xs4all.nl>
	<20090611192052.782d47af@pedra.chehab.org>
	<200906120026.13897.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 12 Jun 2009 00:26:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On Friday 12 June 2009 00:20:52 Mauro Carvalho Chehab wrote:
> > Em Thu, 11 Jun 2009 22:22:50 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > 
> > > On Thursday 11 June 2009 22:18:10 Hans Verkuil wrote:
> > > > On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> > > > > Hi all,
> > > > > 
> > > > > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> > > > > 
> > > > > 	bttv0: audio absent, no audio device found!
> > > > > 
> > > > > and audio does not work. This worked up to and including 2.6.29. Is this a
> > > > > known issue? Does anyone have a fix or a patch for me to try?
> > > > 
> > > > You've no doubt compiled the bttv driver into the kernel and not as a module.
> > > > 
> > > > I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> > > 
> > > I've also attached a diff against 2.6.30 since the patch in my tree is against
> > > the newer v4l-dvb repository and doesn't apply cleanly against 2.6.30.
> > 
> > 
> > > # All i2c modules must come first:
> > 
> > Argh! this is an ugly solution. This can be an workaround for 2.6.30, but the
> > proper solution is to make sure that i2c core got initialized before any i2c
> > client.
> > 
> > Jean,
> > 
> > is there any patch meant to fix the usage of i2c when I2C and drivers are compiled with 'Y' ?
> 
> No, the i2c core is initialized just fine,

I remember I had to commit a patch moving drivers/media to be compiled after to
i2c core due to a similar problem (git changeset a357482a1e8fdd39f0a58c33ed2ffd0f1becb825).

> but the msp3400 module is later in
> the init sequence than bttv. So when bttv initializes and tries to find and
> init the msp3400 module it won't find it.

> 
> There is something weird going on with either the tveeprom module and/or the
> ir-kbd-i2c module. I'm looking into that.

I suspect that we'll need to work with the initialization order after the new
i2c binding model to avoid such troubles.

I remember that we had a similar issue with alsa and saa7134. At the end, Linus [1]
had to do add this, as a quick hack (unfortunately, it is still there - it
seems that alsa guys forgot about that issue):

late_initcall(saa7134_alsa_init);

On that time, he suggested the usage of subsys_initcall() for alsa. I suspect
that we'll need to do the same for I2C and for V4L core. I'm not sure what
would be the alternative to be done with i2c ancillary drivers.

Maybe one alternative would be to use fs_initcall, that seems to be already
used by some non-fs related calls, like cpu governor [2].

[1] http://lkml.org/lkml/2007/3/23/285
[2] http://tomoyo.sourceforge.jp/cgi-bin/lxr/ident?i=fs_initcall


Cheers,
Mauro
