Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway14.websitewelcome.com ([69.41.245.8]:41964 "HELO
	gateway14.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753446Ab0BLUSJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Feb 2010 15:18:09 -0500
Subject: Re: [PATCH 2/5] sony-tuner: Subdev conversion from wis-sony-tuner
From: Pete Eberlein <pete@sensoray.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201002121229.43924.hverkuil@xs4all.nl>
References: <1265934787.4626.251.camel@pete-desktop>
	 <201002121229.43924.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Fri, 12 Feb 2010 12:17:45 -0800
Message-Id: <1266005865.4626.281.camel@pete-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-02-12 at 12:29 +0100, Hans Verkuil wrote:
> On Friday 12 February 2010 01:33:07 Pete Eberlein wrote:
> > From: Pete Eberlein <pete@sensoray.com>
> > 
> > This is a subdev conversion of the go7007 wis-sony-tuner i2c driver,
> > and places it with the other tuner drivers.  This obsoletes the
> > wis-sony-tuner driver in the go7007 staging directory.
> 
> Thanks! Here is a quick review...

Thanks, please have a look at my questions below:


> > +#include <media/v4l2-i2c-drv.h>
> 
> The v4l2-i2c-drv.h is to be used only for drivers that also need to be compiled
> for kernels < 2.6.26. If I am not mistaken that is the case for this driver,
> right? I remember you mentioning that customers of yours use this on such old
> kernels. Just making sure.

My company, Sensoray, doesn't have any products that use this tuner.
This driver was orignally written by Micronas to support their go7007
chip in the Plextor TV402U models.  I don't have the datasheet or know
much about tuners anyway.  I used the v4l2-i2c-drv.h since it seems like
a good idea at the time.  What should I use instead?

> > +static int sony_tuner_g_frequency(struct v4l2_subdev *sd,
> > +				      struct v4l2_frequency *freq)
> > +{
> > +	struct sony_tuner *t = to_state(sd);
> > +
> > +	freq->frequency = t->freq;
> 
> You need to check both the tuner and type field of struct v4l2_frequency here.

What should I check v4l2_frequency->tuner against?  The v4l2 docs say
that it should be the same as the struct v4l2_tuner index field, which
only the parent device driver knows.

> > +static int sony_tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
> > +{
> > +	struct sony_tuner *t = to_state(sd);
> > +
> > +	memset(vt, 0, sizeof(*vt));
> 
> No need to memset, that's already been done by the v4l core.

Ok.

> You should check the vt->index field here.

The parent device driver knows the index and checks it already.  However
this could be a problem if there are multiple tuner that use this subdev
driver.  Is there some function to tell a tuner subdev what its index
should be?

> > +	strcpy(vt->name, "Television");
> 
> Please use strlcpy.

Ok.

> > +	vt->type = V4L2_TUNER_ANALOG_TV;
> > +	vt->rangelow = 0UL; /* does anything use these? */
> > +	vt->rangehigh = 0xffffffffUL;
> 
> If you know the minimum and maximum frequencies then you should set them
> here. Applications that scan for channel will typically use this.

I don't know the frequencies to use.  There are some numbers in the
struct sony_tunertype sony_tuners[], but I'm not sure what they mean.

> Regards,
> 
> 	Hans

Thanks for your review.

Pete


