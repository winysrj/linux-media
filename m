Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2923 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087AbZFKXSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 19:18:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Fri, 12 Jun 2009 01:18:20 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean Delvare <khali@linux-fr.org>,
	"Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org> <200906120026.13897.hverkuil@xs4all.nl> <20090611200746.40b14855@pedra.chehab.org>
In-Reply-To: <20090611200746.40b14855@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906120118.20700.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 01:07:46 Mauro Carvalho Chehab wrote:
> Em Fri, 12 Jun 2009 00:26:13 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Friday 12 June 2009 00:20:52 Mauro Carvalho Chehab wrote:
> > > Em Thu, 11 Jun 2009 22:22:50 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > On Thursday 11 June 2009 22:18:10 Hans Verkuil wrote:
> > > > > On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> > > > > > Hi all,
> > > > > > 
> > > > > > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> > > > > > 
> > > > > > 	bttv0: audio absent, no audio device found!
> > > > > > 
> > > > > > and audio does not work. This worked up to and including 2.6.29. Is this a
> > > > > > known issue? Does anyone have a fix or a patch for me to try?
> > > > > 
> > > > > You've no doubt compiled the bttv driver into the kernel and not as a module.
> > > > > 
> > > > > I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb
> > > > 
> > > > I've also attached a diff against 2.6.30 since the patch in my tree is against
> > > > the newer v4l-dvb repository and doesn't apply cleanly against 2.6.30.
> > > 
> > > 
> > > > # All i2c modules must come first:
> > > 
> > > Argh! this is an ugly solution. This can be an workaround for 2.6.30, but the
> > > proper solution is to make sure that i2c core got initialized before any i2c
> > > client.
> > > 
> > > Jean,
> > > 
> > > is there any patch meant to fix the usage of i2c when I2C and drivers are compiled with 'Y' ?
> > 
> > No, the i2c core is initialized just fine,
> 
> I remember I had to commit a patch moving drivers/media to be compiled after to
> i2c core due to a similar problem (git changeset a357482a1e8fdd39f0a58c33ed2ffd0f1becb825).
> 
> > but the msp3400 module is later in
> > the init sequence than bttv. So when bttv initializes and tries to find and
> > init the msp3400 module it won't find it.
> 
> > 
> > There is something weird going on with either the tveeprom module and/or the
> > ir-kbd-i2c module. I'm looking into that.
> 
> I suspect that we'll need to work with the initialization order after the new
> i2c binding model to avoid such troubles.
> 
> I remember that we had a similar issue with alsa and saa7134. At the end, Linus [1]
> had to do add this, as a quick hack (unfortunately, it is still there - it
> seems that alsa guys forgot about that issue):
> 
> late_initcall(saa7134_alsa_init);
> 
> On that time, he suggested the usage of subsys_initcall() for alsa. I suspect
> that we'll need to do the same for I2C and for V4L core. I'm not sure what
> would be the alternative to be done with i2c ancillary drivers.
> 
> Maybe one alternative would be to use fs_initcall, that seems to be already
> used by some non-fs related calls, like cpu governor [2].

As long as the i2c modules come first there shouldn't be any problem. That's
pretty easy to arrange. So the i2c core inits first, then i2c drivers, then
v4l2 drivers. That's the proper order.

The ir-kbd-i2c module needed to be after the v4l2 modules since that still
relies on autoprobing. If it comes first, then it seems to mess up tveeprom
for some reason. Once ir-kbd-i2c no longer does autoprobing, then it probably
should move back to the other i2c modules.

Regards,

	Hans

> 
> [1] http://lkml.org/lkml/2007/3/23/285
> [2] http://tomoyo.sourceforge.jp/cgi-bin/lxr/ident?i=fs_initcall
> 
> 
> Cheers,
> Mauro
> 
> _______________________________________________
> v4l-dvb-maintainer mailing list
> v4l-dvb-maintainer@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/v4l-dvb-maintainer
> 
> 



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
