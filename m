Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58225 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbbEHO0B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 10:26:01 -0400
Date: Fri, 8 May 2015 11:25:56 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 13/18] s5k5baf: fix subdev type
Message-ID: <20150508112556.04adc4e6@recife.lan>
In-Reply-To: <554CBF54.4050000@samsung.com>
References: <cover.1431046915.git.mchehab@osg.samsung.com>
	<d37f5695458429869abaae3f7974d296c3fa8349.1431046915.git.mchehab@osg.samsung.com>
	<554CBF54.4050000@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Em Fri, 08 May 2015 15:51:16 +0200
Andrzej Hajda <a.hajda@samsung.com> escreveu:

> Hi Mauro,
> 
> On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> > This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
> > some subdevs with a non-existing type.
> >
> > As this is a sensor driver, the proper type is likely
> > MEDIA_ENT_T_CAM_SENSOR.
> 
> This driver exposes two media entities:
> - pure camera sensor, it has type
> MEDIA_ENT_T_V4L2_SUBDEV_SENSOR/MEDIA_ENT_T_CAM_SENSOR,
> - image processing entity, I have assigned to it MEDIA_ENT_T_V4L2_SUBDEV
> type,
> as there were no better option.
> Maybe it would be better to introduce another define for such entities,
> for example MEDIA_ENT_T_CAM_ISP?
> The same applies to s5c73m3 driver.

Yeah, a new type is needed instead of abusing MEDIA_ENT_T_V4L2_SUBDEV.

> 
> Anyway this patch breaks current code as type field is used internally
> to distinguish both entities in subdev callbacks  -
> s5k5baf_is_cis_subdev function.
> Of course the function can be rewritten if necessary.

Ah, ok.

Yes, the better is to rewrite it to use the new ISP type.

We're still discussing the namespaces, so, for now, please consider
those patches as RFC, but this is something that needs to be
fixed anyway, by creating an specific type for ISP hardware.

Regards,
Mauro

> 
> Regards
> Andrzej
> 
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >
> > diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
> > index fadd48d35a55..8373552847ab 100644
> > --- a/drivers/media/i2c/s5k5baf.c
> > +++ b/drivers/media/i2c/s5k5baf.c
> > @@ -1919,7 +1919,7 @@ static int s5k5baf_configure_subdevs(struct s5k5baf *state,
> >  
> >  	state->pads[PAD_CIS].flags = MEDIA_PAD_FL_SINK;
> >  	state->pads[PAD_OUT].flags = MEDIA_PAD_FL_SOURCE;
> > -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> > +	sd->entity.type = MEDIA_ENT_T_CAM_SENSOR;
> >  	ret = media_entity_init(&sd->entity, NUM_ISP_PADS, state->pads, 0);
> >  
> >  	if (!ret)
> 
