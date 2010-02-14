Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1382 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0BNPQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Feb 2010 10:16:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 2/5 v2] sony-tuner: Subdev conversion from wis-sony-tuner
Date: Sun, 14 Feb 2010 16:18:13 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>
References: <1265934787.4626.251.camel@pete-desktop> <1266014180.4626.293.camel@pete-desktop> <201002130017.44931.hverkuil@xs4all.nl>
In-Reply-To: <201002130017.44931.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002141618.13113.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 13 February 2010 00:17:44 Hans Verkuil wrote:
> On Friday 12 February 2010 23:36:20 Pete Eberlein wrote:
> > On Fri, 2010-02-12 at 22:03 +0100, Hans Verkuil wrote:
> > > > > > +#include <media/v4l2-i2c-drv.h>
> > > > > 
> > > > > The v4l2-i2c-drv.h is to be used only for drivers that also need to be compiled
> > > > > for kernels < 2.6.26. If I am not mistaken that is the case for this driver,
> > > > > right? I remember you mentioning that customers of yours use this on such old
> > > > > kernels. Just making sure.
> > > > 
> > > > My company, Sensoray, doesn't have any products that use this tuner.
> > > > This driver was orignally written by Micronas to support their go7007
> > > > chip in the Plextor TV402U models.  I don't have the datasheet or know
> > > > much about tuners anyway.  I used the v4l2-i2c-drv.h since it seems like
> > > > a good idea at the time.  What should I use instead?
> > > 
> > > We way i2c devices are handled changed massively in kernel 2.6.26. In order to
> > > stay backwards compatible with older kernels the v4l2-i2c-drv.h header was
> > > introduced. However, this is a bit of a hack and any i2c driver that does not
> > > need it shouldn't use it.
> > > 
> > > So only if an i2c driver is *never* used by parent drivers that have to support
> > > kernels < 2.6.26, then can it drop the v4l2-i2c-drv.h. An example of such an
> > > i2c driver is tvp514x.c.
> > > 
> > > Eventually support for such old kernels will be dropped and the v4l2-i2c-drv.h
> > > header will disappear altogether, but that's not going to happen anytime soon.
> > > 
> > > What this means for go7007 is that you have to decide whether you want this
> > > go7007 driver to work only for kernels >= 2.6.26, or whether it should also
> > > work for older kernels. My understanding is that Sensoray wants to be able to
> > > compile go7007 for older kernels. In that case the use of v4l2-i2c-drv.h is
> > > correct. Note that this is not about whether any of *Sensoray's* products use
> > > a particular i2c device, but whether the *go7007* driver uses it.
> > > 
> > > I hope this clarifies this.
> > 
> > Yes it does, thank you.  We do want to allow our customers to use the
> > go7007 driver with our products on older kernels, so I would like to
> > keep the v4l2-i2c-drv.h for now.  I've addressed your other comments in
> > the revised patch:
> 
> I've two small comments. See below.
> 
> I also realized that this is really two drivers in one: one driver for the
> actual tuner device and one for the mpx device which seems similar in
> functionality to the vp27smpx.c driver.
> 
> I will look at it again tomorrow, but I might decide that it is better to
> split it up into two drivers: one for the tuner and one for the mpx.

After thinking about this a bit more I decided that this tuner should be split
up into two drivers: one for the mpx device and one for the actual tuner. This
should be fairly easy to do.

One other thing that this accomplishes is that it is easier to see whether the
tuner code can actually be merged into tuner-types.c. From what I can see now
I would say that that is possible for the NTSC_M and NTSC_M_JP models. The
PAL/SECAM model is harder since it needs to setup the tuner whenever the
standard changes. But it seems that that is also possible by adding code
to simple_std_setup() in tuner-simple.c.

I'm pretty sure that these tuners can just be folded into tuner-types.c
and tuner-simple.c. We probably only need an mpx driver.

Andy, can you also take a look?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
