Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60423 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbbBPK7a (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 05:59:30 -0500
Date: Mon, 16 Feb 2015 08:59:25 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCHv4 15/25] [media] tuner-core: properly initialize media
 controller subdev
Message-ID: <20150216085925.3b52a558@recife.lan>
In-Reply-To: <54E1B3F0.7060807@xs4all.nl>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<5c8a3752af88ba4c349d9d2416cad937f96a0423.1423867976.git.mchehab@osg.samsung.com>
	<54E1B3F0.7060807@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Feb 2015 10:10:08 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 02/13/2015 11:57 PM, Mauro Carvalho Chehab wrote:
> > Properly initialize tuner core subdev at the media controller.
> > 
> > That requires a new subtype at the media controller API.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> > index 559f8372e2eb..9a83b27a7e8f 100644
> > --- a/drivers/media/v4l2-core/tuner-core.c
> > +++ b/drivers/media/v4l2-core/tuner-core.c
> > @@ -134,6 +134,9 @@ struct tuner {
> >  	unsigned int        type; /* chip type id */
> >  	void                *config;
> >  	const char          *name;
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	struct media_pad	pad;
> > +#endif
> >  };
> >  
> >  /*
> > @@ -434,6 +437,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
> >  		t->name = analog_ops->info.name;
> >  	}
> >  
> > +	t->sd.entity.name = t->name;
> > +
> >  	tuner_dbg("type set to %s\n", t->name);
> >  
> >  	t->mode_mask = new_mode_mask;
> > @@ -592,6 +597,9 @@ static int tuner_probe(struct i2c_client *client,
> >  	struct tuner *t;
> >  	struct tuner *radio;
> >  	struct tuner *tv;
> > +#ifdef CONFIG_MEDIA_CONTROLLER
> > +	int ret;
> > +#endif
> >  
> >  	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
> >  	if (NULL == t)
> > @@ -684,6 +692,18 @@ static int tuner_probe(struct i2c_client *client,
> >  
> >  	/* Should be just before return */
> >  register_client:
> > +#if defined(CONFIG_MEDIA_CONTROLLER)
> > +	t->pad.flags = MEDIA_PAD_FL_SOURCE;
> > +	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
> > +	t->sd.entity.name = t->name;
> 
> Will this be a unique name in the case of one board with multiple identical tuners?

Good point. Well, it should, as otherwise the logs will be confusing, but
we need to double check it, if we have such case.

> I don't know if we have any cards like that (my PVR-500 is really two PCI boards on
> one PCB).

Except for PVR-500, I can't remember any case where the same tuner is used
more than once.

There is the case of a device with two tuners, one for TV and another one
for FM. Yet, on such case, the name of the FM tuner will be different,
anyway. So, I don't think this is a current issue, but if the name should
be unique, then we need to properly document it.

> Laurent, the name should be unique, right? In any case, the spec needs to be updated
> to clearly state whether or not the name should be unique.

Regards,
Mauro
