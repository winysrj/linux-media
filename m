Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0002.hostedemail.com ([216.40.44.2]:59032 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751394AbbADANl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jan 2015 19:13:41 -0500
Message-ID: <1420330417.2619.1.camel@perches.com>
Subject: Re: [PATCH 2/7] cx25840: fill the media controller entity
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>
Date: Sat, 03 Jan 2015 16:13:37 -0800
In-Reply-To: <487a406afc2d79b2027f1d9667dfad4a716ed630.1420315245.git.mchehab@osg.samsung.com>
References: <cover.1420315245.git.mchehab@osg.samsung.com>
	 <487a406afc2d79b2027f1d9667dfad4a716ed630.1420315245.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2015-01-03 at 18:09 -0200, Mauro Carvalho Chehab wrote:
> Instead of keeping the media controller entity not initialized,
> fill it and create the pads for cx25840.

Won't you get an unused variable for ret
without CONFIG_MEDIA_CONTROLLER?

> diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
[]
> @@ -5134,7 +5134,7 @@ static int cx25840_probe(struct i2c_client *client,
>  {
>  	struct cx25840_state *state;
>  	struct v4l2_subdev *sd;
> -	int default_volume;
> +	int default_volume, ret;
>  	u32 id;
>  	u16 device_id;
>  
> @@ -5178,6 +5178,18 @@ static int cx25840_probe(struct i2c_client *client,
>  
>  	sd = &state->sd;
>  	v4l2_i2c_subdev_init(sd, client, &cx25840_ops);
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	/* TODO: need to represent analog inputs too */
> +	state->pads[0].flags = MEDIA_PAD_FL_SINK;	/* Tuner or input */
> +	state->pads[1].flags = MEDIA_PAD_FL_SOURCE;	/* Video */
> +	state->pads[2].flags = MEDIA_PAD_FL_SOURCE;	/* VBI */
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_DECODER;
> +
> +	ret = media_entity_init(&sd->entity, ARRAY_SIZE(state->pads),
> +				state->pads, 0);
> +	if (ret < 0)
> +		v4l_info(client, "failed to initialize media entity!\n");
> +#endif
>  
>  	switch (id) {
>  	case CX23885_AV:

Maybe write this without ret at all.

	if (media_entry_init(...) < 0)
		v4l_info(...)


