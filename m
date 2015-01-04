Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2067 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbbADAjk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Jan 2015 19:39:40 -0500
Message-ID: <54A88BB5.1030103@linux.intel.com>
Date: Sun, 04 Jan 2015 02:39:17 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 1/7] tuner-core: properly initialize media controller subdev
References: <cover.1420315245.git.mchehab@osg.samsung.com> <4ff2de5fce002a6f6f87993440f45e0f198c57cb.1420315245.git.mchehab@osg.samsung.com>
In-Reply-To: <4ff2de5fce002a6f6f87993440f45e0f198c57cb.1420315245.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Properly initialize tuner core subdev at the media controller.
>
> That requires a new subtype at the media controller API.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> index 559f8372e2eb..114715ed0110 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -134,6 +134,9 @@ struct tuner {
>   	unsigned int        type; /* chip type id */
>   	void                *config;
>   	const char          *name;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_pad	pad;
> +#endif
>   };
>
>   /*
> @@ -434,6 +437,8 @@ static void set_type(struct i2c_client *c, unsigned int type,
>   		t->name = analog_ops->info.name;
>   	}
>
> +	t->sd.entity.name = t->name;
> +
>   	tuner_dbg("type set to %s\n", t->name);
>
>   	t->mode_mask = new_mode_mask;
> @@ -592,6 +597,7 @@ static int tuner_probe(struct i2c_client *client,
>   	struct tuner *t;
>   	struct tuner *radio;
>   	struct tuner *tv;
> +	int ret;

This will emit a compiler warning if CONFIG_MEDIA_CONTROLLER isn't defined.

>   	t = kzalloc(sizeof(struct tuner), GFP_KERNEL);
>   	if (NULL == t)
> @@ -696,6 +702,15 @@ register_client:
>   		   t->type,
>   		   t->mode_mask & T_RADIO ? " Radio" : "",
>   		   t->mode_mask & T_ANALOG_TV ? " TV" : "");
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	t->pad.flags = MEDIA_PAD_FL_SOURCE;
> +	t->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_TUNER;
> +	t->sd.entity.name = t->name;
> +
> +	ret = media_entity_init(&t->sd.entity, 1, &t->pad, 0);
> +	if (ret < 0)
> +		tuner_err("failed to initialize media entity!\n");

I might return the error back to the caller. The failing initialisation 
of a media entity itself might not be a fatal problem, but someone later 
assuming it has been initialised might be.

> +#endif
>   	return 0;
>   }
>
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 707db275f92b..5ffde035789b 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -66,6 +66,8 @@ struct media_device_info {
>   /* A converter of analogue video to its digital representation. */
>   #define MEDIA_ENT_T_V4L2_SUBDEV_DECODER	(MEDIA_ENT_T_V4L2_SUBDEV + 4)
>
> +#define MEDIA_ENT_T_V4L2_SUBDEV_TUNER	(MEDIA_ENT_T_V4L2_SUBDEV + 5)
> +
>   #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
>
>   struct media_entity_desc {
>

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
