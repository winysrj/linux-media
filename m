Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35184 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756189AbcINTck (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 15:32:40 -0400
Received: by mail-lf0-f42.google.com with SMTP id l131so17615779lfl.2
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 12:32:39 -0700 (PDT)
Date: Wed, 14 Sep 2016 21:32:37 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: Re: [PATCH 02/13] v4l: vsp1: Protect against race conditions between
 get and set format
Message-ID: <20160914193237.GN739@bigcity.dyn.berto.se>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473808626-19488-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160914182317.GG739@bigcity.dyn.berto.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160914182317.GG739@bigcity.dyn.berto.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2016-09-14 20:23:17 +0200, Niklas Söderlund wrote:
> Hi Laurent,
> 
> Thanks for your patch.
> 
> On 2016-09-14 02:16:55 +0300, Laurent Pinchart wrote:
> > The subdev userspace API isn't serialized in the core, serialize access
> > to formats and selection rectangles in the driver.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  drivers/media/platform/vsp1/vsp1_bru.c    | 28 +++++++++++++++-----
> >  drivers/media/platform/vsp1/vsp1_clu.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_entity.c | 22 +++++++++++++---
> >  drivers/media/platform/vsp1/vsp1_entity.h |  4 ++-
> >  drivers/media/platform/vsp1/vsp1_hsit.c   | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_lif.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_lut.c    | 15 ++++++++---
> >  drivers/media/platform/vsp1/vsp1_rwpf.c   | 44 +++++++++++++++++++++++--------
> >  drivers/media/platform/vsp1/vsp1_sru.c    | 26 +++++++++++++-----
> >  drivers/media/platform/vsp1/vsp1_uds.c    | 26 +++++++++++++-----
> >  10 files changed, 161 insertions(+), 49 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
> > index 8268b87727a7..26b9e2282a41 100644
> > --- a/drivers/media/platform/vsp1/vsp1_bru.c
> > +++ b/drivers/media/platform/vsp1/vsp1_bru.c
> > @@ -142,10 +142,15 @@ static int bru_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_bru *bru = to_bru(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&bru->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		goto done;
> > +		ret = -EINVAL;
> 
> This looks funny to me, you probably intended to do that in the other 
> order right? If you fix this feel free to add my:
> 
> Acked-by: Niklas Söderlund <niklas.soderlund@ragnatech.se>

Wops, forgot +renesas in the email. If you fix the issue and want to 
collect my Ack, please use:

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Sorry for the noise.

> 
> > +	}
> >  
> >  	bru_try_format(bru, config, fmt->pad, &fmt->format);
> >  
> > @@ -174,7 +179,9 @@ static int bru_set_format(struct v4l2_subdev *subdev,
> >  		}
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&bru->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static int bru_get_selection(struct v4l2_subdev *subdev,
> > @@ -201,7 +208,9 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
> >  		if (!config)
> >  			return -EINVAL;
> >  
> > +		mutex_lock(&bru->entity.lock);
> >  		sel->r = *bru_get_compose(bru, config, sel->pad);
> > +		mutex_unlock(&bru->entity.lock);
> >  		return 0;
> >  
> >  	default:
> > @@ -217,6 +226,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> >  	struct v4l2_rect *compose;
> > +	int ret = 0;
> >  
> >  	if (sel->pad == bru->entity.source_pad)
> >  		return -EINVAL;
> > @@ -224,9 +234,13 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
> >  	if (sel->target != V4L2_SEL_TGT_COMPOSE)
> >  		return -EINVAL;
> >  
> > +	mutex_lock(&bru->entity.lock);
> > +
> >  	config = vsp1_entity_get_pad_config(&bru->entity, cfg, sel->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* The compose rectangle top left corner must be inside the output
> >  	 * frame.
> > @@ -246,7 +260,9 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
> >  	compose = bru_get_compose(bru, config, sel->pad);
> >  	*compose = sel->r;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&bru->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static const struct v4l2_subdev_pad_ops bru_pad_ops = {
> > diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
> > index b63d2dbe5ea3..e1fd03811dda 100644
> > --- a/drivers/media/platform/vsp1/vsp1_clu.c
> > +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> > @@ -148,10 +148,15 @@ static int clu_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_clu *clu = to_clu(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&clu->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* Default to YUV if the requested format is not supported. */
> >  	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > @@ -164,7 +169,7 @@ static int clu_set_format(struct v4l2_subdev *subdev,
> >  	if (fmt->pad == CLU_PAD_SOURCE) {
> >  		/* The CLU output format can't be modified. */
> >  		fmt->format = *format;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	format->code = fmt->format.code;
> > @@ -182,7 +187,9 @@ static int clu_set_format(struct v4l2_subdev *subdev,
> >  					    CLU_PAD_SOURCE);
> >  	*format = fmt->format;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&clu->entity.lock);
> > +	return ret;
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
> > index 4cf6cc719c00..da673495c222 100644
> > --- a/drivers/media/platform/vsp1/vsp1_entity.c
> > +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> > @@ -51,6 +51,9 @@ void vsp1_entity_route_setup(struct vsp1_entity *source,
> >   * @cfg: the TRY pad configuration
> >   * @which: configuration selector (ACTIVE or TRY)
> >   *
> > + * When called with which set to V4L2_SUBDEV_FORMAT_ACTIVE the caller must hold
> > + * the entity lock to access the returned configuration.
> > + *
> >   * Return the pad configuration requested by the which argument. The TRY
> >   * configuration is passed explicitly to the function through the cfg argument
> >   * and simply returned when requested. The ACTIVE configuration comes from the
> > @@ -160,7 +163,9 @@ int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
> >  	if (!config)
> >  		return -EINVAL;
> >  
> > +	mutex_lock(&entity->lock);
> >  	fmt->format = *vsp1_entity_get_pad_format(entity, config, fmt->pad);
> > +	mutex_unlock(&entity->lock);
> >  
> >  	return 0;
> >  }
> > @@ -204,8 +209,10 @@ int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
> >  		if (!config)
> >  			return -EINVAL;
> >  
> > +		mutex_lock(&entity->lock);
> >  		format = vsp1_entity_get_pad_format(entity, config, 0);
> >  		code->code = format->code;
> > +		mutex_unlock(&entity->lock);
> >  	}
> >  
> >  	return 0;
> > @@ -235,6 +242,7 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
> >  	struct vsp1_entity *entity = to_vsp1_entity(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> >  
> >  	config = vsp1_entity_get_pad_config(entity, cfg, fse->which);
> >  	if (!config)
> > @@ -242,8 +250,12 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
> >  
> >  	format = vsp1_entity_get_pad_format(entity, config, fse->pad);
> >  
> > -	if (fse->index || fse->code != format->code)
> > -		return -EINVAL;
> > +	mutex_lock(&entity->lock);
> > +
> > +	if (fse->index || fse->code != format->code) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	if (fse->pad == 0) {
> >  		fse->min_width = min_width;
> > @@ -260,7 +272,9 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
> >  		fse->max_height = format->height;
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&entity->lock);
> > +	return ret;
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > @@ -358,6 +372,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
> >  	if (i == ARRAY_SIZE(vsp1_routes))
> >  		return -EINVAL;
> >  
> > +	mutex_init(&entity->lock);
> > +
> >  	entity->vsp1 = vsp1;
> >  	entity->source_pad = num_pads - 1;
> >  
> > diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
> > index b43457fd2c43..b5e4dbb1f7d4 100644
> > --- a/drivers/media/platform/vsp1/vsp1_entity.h
> > +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> > @@ -14,7 +14,7 @@
> >  #define __VSP1_ENTITY_H__
> >  
> >  #include <linux/list.h>
> > -#include <linux/spinlock.h>
> > +#include <linux/mutex.h>
> >  
> >  #include <media/v4l2-subdev.h>
> >  
> > @@ -96,6 +96,8 @@ struct vsp1_entity {
> >  
> >  	struct v4l2_subdev subdev;
> >  	struct v4l2_subdev_pad_config *config;
> > +
> > +	struct mutex lock;	/* Protects the pad config */
> >  };
> >  
> >  static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
> > diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
> > index 6e5077beb38c..6ffbedb5c095 100644
> > --- a/drivers/media/platform/vsp1/vsp1_hsit.c
> > +++ b/drivers/media/platform/vsp1/vsp1_hsit.c
> > @@ -71,10 +71,15 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_hsit *hsit = to_hsit(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&hsit->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	format = vsp1_entity_get_pad_format(&hsit->entity, config, fmt->pad);
> >  
> > @@ -83,7 +88,7 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
> >  		 * modified.
> >  		 */
> >  		fmt->format = *format;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	format->code = hsit->inverse ? MEDIA_BUS_FMT_AHSV8888_1X32
> > @@ -104,7 +109,9 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
> >  	format->code = hsit->inverse ? MEDIA_BUS_FMT_ARGB8888_1X32
> >  		     : MEDIA_BUS_FMT_AHSV8888_1X32;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&hsit->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static const struct v4l2_subdev_pad_ops hsit_pad_ops = {
> > diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
> > index a720063f38c5..702df863b13a 100644
> > --- a/drivers/media/platform/vsp1/vsp1_lif.c
> > +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> > @@ -66,10 +66,15 @@ static int lif_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_lif *lif = to_lif(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&lif->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* Default to YUV if the requested format is not supported. */
> >  	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > @@ -83,7 +88,7 @@ static int lif_set_format(struct v4l2_subdev *subdev,
> >  		 * format.
> >  		 */
> >  		fmt->format = *format;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	format->code = fmt->format.code;
> > @@ -101,7 +106,9 @@ static int lif_set_format(struct v4l2_subdev *subdev,
> >  					    LIF_PAD_SOURCE);
> >  	*format = fmt->format;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&lif->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static const struct v4l2_subdev_pad_ops lif_pad_ops = {
> > diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
> > index dc31de9602ba..e1c0bb7535e4 100644
> > --- a/drivers/media/platform/vsp1/vsp1_lut.c
> > +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> > @@ -124,10 +124,15 @@ static int lut_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_lut *lut = to_lut(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&lut->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* Default to YUV if the requested format is not supported. */
> >  	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > @@ -140,7 +145,7 @@ static int lut_set_format(struct v4l2_subdev *subdev,
> >  	if (fmt->pad == LUT_PAD_SOURCE) {
> >  		/* The LUT output format can't be modified. */
> >  		fmt->format = *format;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	format->code = fmt->format.code;
> > @@ -158,7 +163,9 @@ static int lut_set_format(struct v4l2_subdev *subdev,
> >  					    LUT_PAD_SOURCE);
> >  	*format = fmt->format;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&lut->entity.lock);
> > +	return ret;
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
> > index 8d461b375e91..8cb87e96b78b 100644
> > --- a/drivers/media/platform/vsp1/vsp1_rwpf.c
> > +++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
> > @@ -67,10 +67,15 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> >  	struct v4l2_rect *crop;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&rwpf->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* Default to YUV if the requested format is not supported. */
> >  	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > @@ -85,7 +90,7 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
> >  		 */
> >  		format->code = fmt->format.code;
> >  		fmt->format = *format;
> > -		return 0;
> > +		goto done;
> >  	}
> >  
> >  	format->code = fmt->format.code;
> > @@ -110,7 +115,9 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
> >  					    RWPF_PAD_SOURCE);
> >  	*format = fmt->format;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&rwpf->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
> > @@ -120,14 +127,19 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
> >  	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> >  
> >  	/* Cropping is implemented on the sink pad. */
> >  	if (sel->pad != RWPF_PAD_SINK)
> >  		return -EINVAL;
> >  
> > +	mutex_lock(&rwpf->entity.lock);
> > +
> >  	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, sel->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	switch (sel->target) {
> >  	case V4L2_SEL_TGT_CROP:
> > @@ -144,10 +156,13 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
> >  		break;
> >  
> >  	default:
> > -		return -EINVAL;
> > +		ret = -EINVAL;
> > +		break;
> >  	}
> 
> Nit-picking, maybe use goto here instead of break? I'm always scared of 
> constructs like this since code might get added after the switch 
> statement and this is a error path.
> 
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&rwpf->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
> > @@ -158,6 +173,7 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> >  	struct v4l2_rect *crop;
> > +	int ret = 0;
> >  
> >  	/* Cropping is implemented on the sink pad. */
> >  	if (sel->pad != RWPF_PAD_SINK)
> > @@ -166,9 +182,13 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
> >  	if (sel->target != V4L2_SEL_TGT_CROP)
> >  		return -EINVAL;
> >  
> > +	mutex_lock(&rwpf->entity.lock);
> > +
> >  	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, sel->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	/* Make sure the crop rectangle is entirely contained in the image. The
> >  	 * WPF top and left offsets are limited to 255.
> > @@ -206,7 +226,9 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
> >  	format->width = crop->width;
> >  	format->height = crop->height;
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&rwpf->entity.lock);
> > +	return ret;
> >  }
> >  
> >  const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops = {
> > diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
> > index 47f5e0cea2ce..6e13cdfa5ed4 100644
> > --- a/drivers/media/platform/vsp1/vsp1_sru.c
> > +++ b/drivers/media/platform/vsp1/vsp1_sru.c
> > @@ -128,6 +128,7 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
> >  	struct vsp1_sru *sru = to_sru(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> >  
> >  	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fse->which);
> >  	if (!config)
> > @@ -135,8 +136,12 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
> >  
> >  	format = vsp1_entity_get_pad_format(&sru->entity, config, SRU_PAD_SINK);
> >  
> > -	if (fse->index || fse->code != format->code)
> > -		return -EINVAL;
> > +	mutex_lock(&sru->entity.lock);
> > +
> > +	if (fse->index || fse->code != format->code) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	if (fse->pad == SRU_PAD_SINK) {
> >  		fse->min_width = SRU_MIN_SIZE;
> > @@ -156,7 +161,9 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
> >  		}
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&sru->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static void sru_try_format(struct vsp1_sru *sru,
> > @@ -217,10 +224,15 @@ static int sru_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_sru *sru = to_sru(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&sru->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	sru_try_format(sru, config, fmt->pad, &fmt->format);
> >  
> > @@ -236,7 +248,9 @@ static int sru_set_format(struct v4l2_subdev *subdev,
> >  		sru_try_format(sru, config, SRU_PAD_SOURCE, format);
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&sru->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static const struct v4l2_subdev_pad_ops sru_pad_ops = {
> > diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
> > index 652dcd895022..a8fc893a31ee 100644
> > --- a/drivers/media/platform/vsp1/vsp1_uds.c
> > +++ b/drivers/media/platform/vsp1/vsp1_uds.c
> > @@ -133,6 +133,7 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
> >  	struct vsp1_uds *uds = to_uds(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> >  
> >  	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fse->which);
> >  	if (!config)
> > @@ -141,8 +142,12 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
> >  	format = vsp1_entity_get_pad_format(&uds->entity, config,
> >  					    UDS_PAD_SINK);
> >  
> > -	if (fse->index || fse->code != format->code)
> > -		return -EINVAL;
> > +	mutex_lock(&uds->entity.lock);
> > +
> > +	if (fse->index || fse->code != format->code) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	if (fse->pad == UDS_PAD_SINK) {
> >  		fse->min_width = UDS_MIN_SIZE;
> > @@ -156,7 +161,9 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
> >  				  &fse->max_height);
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&uds->entity.lock);
> > +	return ret;
> >  }
> >  
> >  static void uds_try_format(struct vsp1_uds *uds,
> > @@ -202,10 +209,15 @@ static int uds_set_format(struct v4l2_subdev *subdev,
> >  	struct vsp1_uds *uds = to_uds(subdev);
> >  	struct v4l2_subdev_pad_config *config;
> >  	struct v4l2_mbus_framefmt *format;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&uds->entity.lock);
> >  
> >  	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fmt->which);
> > -	if (!config)
> > -		return -EINVAL;
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> >  
> >  	uds_try_format(uds, config, fmt->pad, &fmt->format);
> >  
> > @@ -221,7 +233,9 @@ static int uds_set_format(struct v4l2_subdev *subdev,
> >  		uds_try_format(uds, config, UDS_PAD_SOURCE, format);
> >  	}
> >  
> > -	return 0;
> > +done:
> > +	mutex_unlock(&uds->entity.lock);
> > +	return ret;
> >  }
> >  
> >  /* -----------------------------------------------------------------------------
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> 
> -- 
> Regards,
> Niklas Söderlund

-- 
Regards,
Niklas Söderlund
