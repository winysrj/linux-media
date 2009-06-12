Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:47428 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876AbZFLIEd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 04:04:33 -0400
Date: Fri, 12 Jun 2009 10:04:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: v4l-dvb-maintainer@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Message-ID: <20090612100409.04bb0fe5@hyperion.delvare>
In-Reply-To: <200906120118.20700.hverkuil@xs4all.nl>
References: <20090611221402.66709817@laptop.hypervisor.org>
	<200906120026.13897.hverkuil@xs4all.nl>
	<20090611200746.40b14855@pedra.chehab.org>
	<200906120118.20700.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 12 Jun 2009 01:18:20 +0200, Hans Verkuil wrote:
> On Friday 12 June 2009 01:07:46 Mauro Carvalho Chehab wrote:
> > I suspect that we'll need to work with the initialization order after the new
> > i2c binding model to avoid such troubles.
> > 
> > I remember that we had a similar issue with alsa and saa7134. At the end, Linus [1]
> > had to do add this, as a quick hack (unfortunately, it is still there - it
> > seems that alsa guys forgot about that issue):
> > 
> > late_initcall(saa7134_alsa_init);
> > 
> > On that time, he suggested the usage of subsys_initcall() for alsa. I suspect
> > that we'll need to do the same for I2C and for V4L core. I'm not sure what
> > would be the alternative to be done with i2c ancillary drivers.
> > 
> > Maybe one alternative would be to use fs_initcall, that seems to be already
> > used by some non-fs related calls, like cpu governor [2].
> 
> As long as the i2c modules come first there shouldn't be any problem. That's
> pretty easy to arrange. So the i2c core inits first, then i2c drivers, then
> v4l2 drivers. That's the proper order.

This is already what we have in 2.6.30 as far as I can see.

> The ir-kbd-i2c module needed to be after the v4l2 modules since that still
> relies on autoprobing. If it comes first, then it seems to mess up tveeprom
> for some reason. Once ir-kbd-i2c no longer does autoprobing, then it probably
> should move back to the other i2c modules.

Hopefully this will happen in the next few days :)

-- 
Jean Delvare
