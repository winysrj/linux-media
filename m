Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46714 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbLHRLM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Dec 2015 12:11:12 -0500
Date: Tue, 8 Dec 2015 15:11:07 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [PATCH v8 34/55] [media] s5c73m3: fix subdev type
Message-ID: <20151208151107.0f535637@recife.lan>
In-Reply-To: <5606270.B3tOjzmPeC@avalon>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
	<9f8845993df848df703f3ab177745ea54c30e828.1440902901.git.mchehab@osg.samsung.com>
	<5606270.B3tOjzmPeC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 06 Dec 2015 03:57:56 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> Thank you for the patch.
> 
> On Sunday 30 August 2015 00:06:45 Mauro Carvalho Chehab wrote:
> > This sensor driver is abusing MEDIA_ENT_T_V4L2_SUBDEV, creating
> > some subdevs with a non-existing type.
> > 
> > As this is a sensor driver, the proper type is likely
> > MEDIA_ENT_T_CAM_SENSOR.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > 
> > diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > b/drivers/media/i2c/s5c73m3/s5c73m3-core.c index c81bfbfea32f..abae37321c0c
> > 100644
> > --- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > +++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
> > @@ -1688,7 +1688,7 @@ static int s5c73m3_probe(struct i2c_client *client,
> > 
> >  	state->sensor_pads[S5C73M3_JPEG_PAD].flags = MEDIA_PAD_FL_SOURCE;
> >  	state->sensor_pads[S5C73M3_ISP_PAD].flags = MEDIA_PAD_FL_SOURCE;
> > -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> > +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> 
> As explained in my review of "s5k5baf: fix subdev type", this is correct...
> 
> >  	ret = media_entity_init(&sd->entity, S5C73M3_NUM_PADS,
> >  							state->sensor_pads);
> > @@ -1704,7 +1704,7 @@ static int s5c73m3_probe(struct i2c_client *client,
> >  	state->oif_pads[OIF_ISP_PAD].flags = MEDIA_PAD_FL_SINK;
> >  	state->oif_pads[OIF_JPEG_PAD].flags = MEDIA_PAD_FL_SINK;
> >  	state->oif_pads[OIF_SOURCE_PAD].flags = MEDIA_PAD_FL_SOURCE;
> > -	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> > +	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
> 
> ... but this isn't.

Ok. Replacing this hunk by:

-	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
+	oif_sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;


> 
> >  	ret = media_entity_init(&oif_sd->entity, OIF_NUM_PADS,
> >  							state->oif_pads);
> 
