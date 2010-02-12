Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1346 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab0BLVBF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 16:01:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pete Eberlein <pete@sensoray.com>
Subject: Re: [PATCH 2/5] sony-tuner: Subdev conversion from wis-sony-tuner
Date: Fri, 12 Feb 2010 22:03:15 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <1265934787.4626.251.camel@pete-desktop> <201002121229.43924.hverkuil@xs4all.nl> <1266005865.4626.281.camel@pete-desktop>
In-Reply-To: <1266005865.4626.281.camel@pete-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002122203.15491.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 February 2010 21:17:45 Pete Eberlein wrote:
> On Fri, 2010-02-12 at 12:29 +0100, Hans Verkuil wrote:
> > On Friday 12 February 2010 01:33:07 Pete Eberlein wrote:
> > > From: Pete Eberlein <pete@sensoray.com>
> > > 
> > > This is a subdev conversion of the go7007 wis-sony-tuner i2c driver,
> > > and places it with the other tuner drivers.  This obsoletes the
> > > wis-sony-tuner driver in the go7007 staging directory.
> > 
> > Thanks! Here is a quick review...
> 
> Thanks, please have a look at my questions below:
> 
> 
> > > +#include <media/v4l2-i2c-drv.h>
> > 
> > The v4l2-i2c-drv.h is to be used only for drivers that also need to be compiled
> > for kernels < 2.6.26. If I am not mistaken that is the case for this driver,
> > right? I remember you mentioning that customers of yours use this on such old
> > kernels. Just making sure.
> 
> My company, Sensoray, doesn't have any products that use this tuner.
> This driver was orignally written by Micronas to support their go7007
> chip in the Plextor TV402U models.  I don't have the datasheet or know
> much about tuners anyway.  I used the v4l2-i2c-drv.h since it seems like
> a good idea at the time.  What should I use instead?

We way i2c devices are handled changed massively in kernel 2.6.26. In order to
stay backwards compatible with older kernels the v4l2-i2c-drv.h header was
introduced. However, this is a bit of a hack and any i2c driver that does not
need it shouldn't use it.

So only if an i2c driver is *never* used by parent drivers that have to support
kernels < 2.6.26, then can it drop the v4l2-i2c-drv.h. An example of such an
i2c driver is tvp514x.c.

Eventually support for such old kernels will be dropped and the v4l2-i2c-drv.h
header will disappear altogether, but that's not going to happen anytime soon.

What this means for go7007 is that you have to decide whether you want this
go7007 driver to work only for kernels >= 2.6.26, or whether it should also
work for older kernels. My understanding is that Sensoray wants to be able to
compile go7007 for older kernels. In that case the use of v4l2-i2c-drv.h is
correct. Note that this is not about whether any of *Sensoray's* products use
a particular i2c device, but whether the *go7007* driver uses it.

I hope this clarifies this.

> > > +static int sony_tuner_g_frequency(struct v4l2_subdev *sd,
> > > +				      struct v4l2_frequency *freq)
> > > +{
> > > +	struct sony_tuner *t = to_state(sd);
> > > +
> > > +	freq->frequency = t->freq;
> > 
> > You need to check both the tuner and type field of struct v4l2_frequency here.
> 
> What should I check v4l2_frequency->tuner against?  The v4l2 docs say
> that it should be the same as the struct v4l2_tuner index field, which
> only the parent device driver knows.

Oops, you are correct. That test belongs in the parent driver. Sorry about that.

> 
> > > +static int sony_tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > > +{
> > > +	struct sony_tuner *t = to_state(sd);
> > > +
> > > +	memset(vt, 0, sizeof(*vt));
> > 
> > No need to memset, that's already been done by the v4l core.
> 
> Ok.
> 
> > You should check the vt->index field here.
> 
> The parent device driver knows the index and checks it already.  However
> this could be a problem if there are multiple tuner that use this subdev
> driver.  Is there some function to tell a tuner subdev what its index
> should be?

You are correct again, my mistake.

> 
> > > +	strcpy(vt->name, "Television");
> > 
> > Please use strlcpy.
> 
> Ok.
> 
> > > +	vt->type = V4L2_TUNER_ANALOG_TV;
> > > +	vt->rangelow = 0UL; /* does anything use these? */
> > > +	vt->rangehigh = 0xffffffffUL;
> > 
> > If you know the minimum and maximum frequencies then you should set them
> > here. Applications that scan for channel will typically use this.
> 
> I don't know the frequencies to use.  There are some numbers in the
> struct sony_tunertype sony_tuners[], but I'm not sure what they mean.

Ah, I thought you had a datasheet for this tuner. In that case I would set
rangelow to 16 and rangehigh to 16 * 999.99.

Regards,

	Hans

> 
> > Regards,
> > 
> > 	Hans
> 
> Thanks for your review.
> 
> Pete
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
