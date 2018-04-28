Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53186 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757832AbeD1R35 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 13:29:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
Date: Sat, 28 Apr 2018 20:30:12 +0300
Message-ID: <1628120.9DFZQMBCSb@avalon>
In-Reply-To: <13638427.AR7oG9JFQr@avalon>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <9839f231-f91c-ab54-fdba-f100a98a558d@ideasonboard.com> <13638427.AR7oG9JFQr@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again,

On Saturday, 28 April 2018 20:25:44 EEST Laurent Pinchart wrote:
> On Saturday, 28 April 2018 20:16:11 EEST Kieran Bingham wrote:
> > On 22/04/18 23:34, Laurent Pinchart wrote:
> > > The implementation of the set_fmt pad operation is identical in the
> > > three modules. Move it to a generic helper function.
> > > 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > Only a minor pair of comments below regarding source/sink pad
> > descriptions.
> > 
> > If it's not convenient/accurate to define these with an enum then don't
> > worry about it.
> 
> It's a good point. There are however other locations in vsp1_entity.c that
> hardcode pad numbers, so I'll submit a patch on top of this series to fix
> them all in one go.

Actually I can compare the pad number to entity->source_pad, I'll update this 
patch accordingly in v3.

> > Otherwise,
> > 
> > Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> > 
> > > ---
> > > 
> > >  drivers/media/platform/vsp1/vsp1_clu.c    | 65 +++++-------------------
> > >  drivers/media/platform/vsp1/vsp1_entity.c | 75
> > >  ++++++++++++++++++++++++++
> > >  drivers/media/platform/vsp1/vsp1_entity.h |  6 +++
> > >  drivers/media/platform/vsp1/vsp1_lif.c    | 65
> > >  +++++--------------------
> > >  drivers/media/platform/vsp1/vsp1_lut.c    | 65
> > >  +++++--------------------
> > >  5 files changed, 116 insertions(+), 160 deletions(-)
> > 
> > That's a nice diffstat :-)
> > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> > > b/drivers/media/platform/vsp1/vsp1_clu.c index
> > > 9626b6308585..96a448e1504c
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_clu.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> > > @@ -114,18 +114,18 @@ static const struct v4l2_ctrl_config
> > > clu_mode_control = {>
> > > 
> > >   * V4L2 Subdevice Pad Operations
> > >   */
> > > 
> > > +static const unsigned int clu_codes[] = {
> > > +	MEDIA_BUS_FMT_ARGB8888_1X32,
> > > +	MEDIA_BUS_FMT_AHSV8888_1X32,
> > > +	MEDIA_BUS_FMT_AYUV8_1X32,
> > > +};
> > > +
> > > 
> > >  static int clu_enum_mbus_code(struct v4l2_subdev *subdev,
> > >  
> > >  			      struct v4l2_subdev_pad_config *cfg,
> > >  			      struct v4l2_subdev_mbus_code_enum *code)
> > >  
> > >  {
> > > 
> > > -	static const unsigned int codes[] = {
> > > -		MEDIA_BUS_FMT_ARGB8888_1X32,
> > > -		MEDIA_BUS_FMT_AHSV8888_1X32,
> > > -		MEDIA_BUS_FMT_AYUV8_1X32,
> > > -	};
> > > -
> > > -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> > > -					  ARRAY_SIZE(codes));
> > > +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, clu_codes,
> > > +					  ARRAY_SIZE(clu_codes));
> > > 
> > >  }
> > >  
> > >  static int clu_enum_frame_size(struct v4l2_subdev *subdev,
> > > 
> > > @@ -141,51 +141,10 @@ static int clu_set_format(struct v4l2_subdev
> > > *subdev,
> > > 
> > >  			  struct v4l2_subdev_pad_config *cfg,
> > >  			  struct v4l2_subdev_format *fmt)
> > >  
> > >  {
> > > 
> > > -	struct vsp1_clu *clu = to_clu(subdev);
> > > -	struct v4l2_subdev_pad_config *config;
> > > -	struct v4l2_mbus_framefmt *format;
> > > -	int ret = 0;
> > > -
> > > -	mutex_lock(&clu->entity.lock);
> > > -
> > > -	config = vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);
> > > -	if (!config) {
> > > -		ret = -EINVAL;
> > > -		goto done;
> > > -	}
> > > -
> > > -	/* Default to YUV if the requested format is not supported. */
> > > -	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > > -	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
> > > -	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
> > > -		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
> > > -
> > > -	format = vsp1_entity_get_pad_format(&clu->entity, config, fmt->pad);
> > > -
> > > -	if (fmt->pad == CLU_PAD_SOURCE) {
> > > -		/* The CLU output format can't be modified. */
> > > -		fmt->format = *format;
> > > -		goto done;
> > > -	}
> > > -
> > > -	format->code = fmt->format.code;
> > > -	format->width = clamp_t(unsigned int, fmt->format.width,
> > > -				CLU_MIN_SIZE, CLU_MAX_SIZE);
> > > -	format->height = clamp_t(unsigned int, fmt->format.height,
> > > -				 CLU_MIN_SIZE, CLU_MAX_SIZE);
> > > -	format->field = V4L2_FIELD_NONE;
> > > -	format->colorspace = V4L2_COLORSPACE_SRGB;
> > > -
> > > -	fmt->format = *format;
> > > -
> > > -	/* Propagate the format to the source pad. */
> > > -	format = vsp1_entity_get_pad_format(&clu->entity, config,
> > > -					    CLU_PAD_SOURCE);
> > > -	*format = fmt->format;
> > > -
> > > -done:
> > > -	mutex_unlock(&clu->entity.lock);
> > > -	return ret;
> > > +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, clu_codes,
> > > +					  ARRAY_SIZE(clu_codes),
> > > +					  CLU_MIN_SIZE, CLU_MIN_SIZE,
> > > +					  CLU_MAX_SIZE, CLU_MAX_SIZE);
> > > 
> > >  }
> > >  
> > >  /*
> > >  -----------------------------------------------------------------------
> > >  -
> > >  ----->
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_entity.c
> > > b/drivers/media/platform/vsp1/vsp1_entity.c index
> > > 72354caf5746..239df047efd0 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_entity.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> > > @@ -307,6 +307,81 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev
> > > *subdev,>
> > > 
> > >  	return ret;
> > >  
> > >  }
> > > 
> > > +/*
> > > + * vsp1_subdev_set_pad_format - Subdev pad set_fmt handler
> > > + * @subdev: V4L2 subdevice
> > > + * @cfg: V4L2 subdev pad configuration
> > > + * @fmt: V4L2 subdev format
> > > + * @codes: Array of supported media bus codes
> > > + * @ncodes: Number of supported media bus codes
> > > + * @min_width: Minimum image width
> > > + * @min_height: Minimum image height
> > > + * @max_width: Maximum image width
> > > + * @max_height: Maximum image height
> > > + *
> > > + * This function implements the subdev set_fmt pad operation for
> > > entities
> > > that
> > > + * do not support scaling or cropping. It defaults to the first
> > > supplied
> > > media
> > > + * bus code if the requested code isn't supported, clamps the size to
> > > the
> > > + * supplied minimum and maximum, and propagates the sink pad format to
> > > the
> > > + * source pad.
> > > + */
> > > +int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
> > > +			       struct v4l2_subdev_pad_config *cfg,
> > > +			       struct v4l2_subdev_format *fmt,
> > > +			       const unsigned int *codes, unsigned int ncodes,
> > > +			       unsigned int min_width, unsigned int min_height,
> > > +			       unsigned int max_width, unsigned int max_height)
> > > +{
> > > +	struct vsp1_entity *entity = to_vsp1_entity(subdev);
> > > +	struct v4l2_subdev_pad_config *config;
> > > +	struct v4l2_mbus_framefmt *format;
> > > +	unsigned int i;
> > > +	int ret = 0;
> > > +
> > > +	mutex_lock(&entity->lock);
> > > +
> > > +	config = vsp1_entity_get_pad_config(entity, cfg, fmt->which);
> > > +	if (!config) {
> > > +		ret = -EINVAL;
> > > +		goto done;
> > > +	}
> > > +
> > > +	format = vsp1_entity_get_pad_format(entity, config, fmt->pad);
> > > +
> > > +	if (fmt->pad != 0) {
> > 
> > I guess we don't have any clear way to say != *_PAD_SINK here do we ..
> > 
> > > +		/* The output format can't be modified. */
> > > +		fmt->format = *format;
> > > +		goto done;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Default to the first media bus code if the requested format is 
not
> > > +	 * supported.
> > > +	 */
> > > +	for (i = 0; i < ncodes; ++i) {
> > > +		if (fmt->format.code == codes[i])
> > > +			break;
> > > +	}
> > > +
> > > +	format->code = i < ncodes ? codes[i] : codes[0];
> > > +	format->width = clamp_t(unsigned int, fmt->format.width,
> > > +				min_width, max_width);
> > > +	format->height = clamp_t(unsigned int, fmt->format.height,
> > > +				 min_height, max_height);
> > > +	format->field = V4L2_FIELD_NONE;
> > > +	format->colorspace = V4L2_COLORSPACE_SRGB;
> > > +
> > > +	fmt->format = *format;
> > > +
> > > +	/* Propagate the format to the source pad. */
> > > +	format = vsp1_entity_get_pad_format(entity, config, 1);
> > 
> > If we can guarantee that ENTITY_PAD_SINK == 0 and ENTITY_PAD_SOURCE == 1,
> > can we put those into an enum ?
> > 
> > > +	*format = fmt->format;
> > > +
> > > +done:
> > > +	mutex_unlock(&entity->lock);
> > > +	return ret;
> > > +}
> > > +
> > > 
> > >  /*
> > >  -----------------------------------------------------------------------
> > >  -
> > >  ----->
> > >  
> > >   * Media Operations
> > >   */
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_entity.h
> > > b/drivers/media/platform/vsp1/vsp1_entity.h index
> > > fb20a1578f3b..0839a62cfa71 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_entity.h
> > > +++ b/drivers/media/platform/vsp1/vsp1_entity.h
> > > @@ -160,6 +160,12 @@ struct media_pad *vsp1_entity_remote_pad(struct
> > > media_pad *pad);>
> > > 
> > >  int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
> > >  
> > >  			       struct v4l2_subdev_pad_config *cfg,
> > >  			       struct v4l2_subdev_format *fmt);
> > > 
> > > +int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
> > > +			       struct v4l2_subdev_pad_config *cfg,
> > > +			       struct v4l2_subdev_format *fmt,
> > > +			       const unsigned int *codes, unsigned int ncodes,
> > > +			       unsigned int min_width, unsigned int min_height,
> > > +			       unsigned int max_width, unsigned int max_height);
> > > 
> > >  int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
> > >  
> > >  			       struct v4l2_subdev_pad_config *cfg,
> > >  			       struct v4l2_subdev_mbus_code_enum *code,
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_lif.c
> > > b/drivers/media/platform/vsp1/vsp1_lif.c index
> > > b20b842f06ba..fbdd5715f829
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_lif.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_lif.c
> > > @@ -33,17 +33,17 @@ static inline void vsp1_lif_write(struct vsp1_lif
> > > *lif, struct vsp1_dl_list *dl,>
> > > 
> > >   * V4L2 Subdevice Operations
> > >   */
> > > 
> > > +static const unsigned int lif_codes[] = {
> > > +	MEDIA_BUS_FMT_ARGB8888_1X32,
> > > +	MEDIA_BUS_FMT_AYUV8_1X32,
> > > +};
> > > +
> > > 
> > >  static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
> > >  
> > >  			      struct v4l2_subdev_pad_config *cfg,
> > >  			      struct v4l2_subdev_mbus_code_enum *code)
> > >  
> > >  {
> > > 
> > > -	static const unsigned int codes[] = {
> > > -		MEDIA_BUS_FMT_ARGB8888_1X32,
> > > -		MEDIA_BUS_FMT_AYUV8_1X32,
> > > -	};
> > > -
> > > -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> > > -					  ARRAY_SIZE(codes));
> > > +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lif_codes,
> > > +					  ARRAY_SIZE(lif_codes));
> > > 
> > >  }
> > >  
> > >  static int lif_enum_frame_size(struct v4l2_subdev *subdev,
> > > 
> > > @@ -59,53 +59,10 @@ static int lif_set_format(struct v4l2_subdev
> > > *subdev,
> > > 
> > >  			  struct v4l2_subdev_pad_config *cfg,
> > >  			  struct v4l2_subdev_format *fmt)
> > >  
> > >  {
> > > 
> > > -	struct vsp1_lif *lif = to_lif(subdev);
> > > -	struct v4l2_subdev_pad_config *config;
> > > -	struct v4l2_mbus_framefmt *format;
> > > -	int ret = 0;
> > > -
> > > -	mutex_lock(&lif->entity.lock);
> > > -
> > > -	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
> > > -	if (!config) {
> > > -		ret = -EINVAL;
> > > -		goto done;
> > > -	}
> > > -
> > > -	/* Default to YUV if the requested format is not supported. */
> > > -	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > > -	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
> > > -		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
> > > -
> > > -	format = vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad);
> > > -
> > > -	if (fmt->pad == LIF_PAD_SOURCE) {
> > > -		/*
> > > -		 * The LIF source format is always identical to its sink
> > > -		 * format.
> > > -		 */
> > > -		fmt->format = *format;
> > > -		goto done;
> > > -	}
> > > -
> > > -	format->code = fmt->format.code;
> > > -	format->width = clamp_t(unsigned int, fmt->format.width,
> > > -				LIF_MIN_SIZE, LIF_MAX_SIZE);
> > > -	format->height = clamp_t(unsigned int, fmt->format.height,
> > > -				 LIF_MIN_SIZE, LIF_MAX_SIZE);
> > > -	format->field = V4L2_FIELD_NONE;
> > > -	format->colorspace = V4L2_COLORSPACE_SRGB;
> > > -
> > > -	fmt->format = *format;
> > > -
> > > -	/* Propagate the format to the source pad. */
> > > -	format = vsp1_entity_get_pad_format(&lif->entity, config,
> > > -					    LIF_PAD_SOURCE);
> > > -	*format = fmt->format;
> > > -
> > > -done:
> > > -	mutex_unlock(&lif->entity.lock);
> > > -	return ret;
> > > +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lif_codes,
> > > +					  ARRAY_SIZE(lif_codes),
> > > +					  LIF_MIN_SIZE, LIF_MIN_SIZE,
> > > +					  LIF_MAX_SIZE, LIF_MAX_SIZE);
> > > 
> > >  }
> > >  
> > >  static const struct v4l2_subdev_pad_ops lif_pad_ops = {
> > > 
> > > diff --git a/drivers/media/platform/vsp1/vsp1_lut.c
> > > b/drivers/media/platform/vsp1/vsp1_lut.c index
> > > 7bdabb311c6c..f2e48a02ca7d
> > > 100644
> > > --- a/drivers/media/platform/vsp1/vsp1_lut.c
> > > +++ b/drivers/media/platform/vsp1/vsp1_lut.c
> > > @@ -90,18 +90,18 @@ static const struct v4l2_ctrl_config
> > > lut_table_control
> > > = {>
> > > 
> > >   * V4L2 Subdevice Pad Operations
> > >   */
> > > 
> > > +static const unsigned int lut_codes[] = {
> > > +	MEDIA_BUS_FMT_ARGB8888_1X32,
> > > +	MEDIA_BUS_FMT_AHSV8888_1X32,
> > > +	MEDIA_BUS_FMT_AYUV8_1X32,
> > > +};
> > > +
> > > 
> > >  static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
> > >  
> > >  			      struct v4l2_subdev_pad_config *cfg,
> > >  			      struct v4l2_subdev_mbus_code_enum *code)
> > >  
> > >  {
> > > 
> > > -	static const unsigned int codes[] = {
> > > -		MEDIA_BUS_FMT_ARGB8888_1X32,
> > > -		MEDIA_BUS_FMT_AHSV8888_1X32,
> > > -		MEDIA_BUS_FMT_AYUV8_1X32,
> > > -	};
> > > -
> > > -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> > > -					  ARRAY_SIZE(codes));
> > > +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, lut_codes,
> > > +					  ARRAY_SIZE(lut_codes));
> > > 
> > >  }
> > >  
> > >  static int lut_enum_frame_size(struct v4l2_subdev *subdev,
> > > 
> > > @@ -117,51 +117,10 @@ static int lut_set_format(struct v4l2_subdev
> > > *subdev,
> > > 
> > >  			  struct v4l2_subdev_pad_config *cfg,
> > >  			  struct v4l2_subdev_format *fmt)
> > >  
> > >  {
> > > 
> > > -	struct vsp1_lut *lut = to_lut(subdev);
> > > -	struct v4l2_subdev_pad_config *config;
> > > -	struct v4l2_mbus_framefmt *format;
> > > -	int ret = 0;
> > > -
> > > -	mutex_lock(&lut->entity.lock);
> > > -
> > > -	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
> > > -	if (!config) {
> > > -		ret = -EINVAL;
> > > -		goto done;
> > > -	}
> > > -
> > > -	/* Default to YUV if the requested format is not supported. */
> > > -	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > > -	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
> > > -	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
> > > -		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
> > > -
> > > -	format = vsp1_entity_get_pad_format(&lut->entity, config, fmt->pad);
> > > -
> > > -	if (fmt->pad == LUT_PAD_SOURCE) {
> > > -		/* The LUT output format can't be modified. */
> > > -		fmt->format = *format;
> > > -		goto done;
> > > -	}
> > > -
> > > -	format->code = fmt->format.code;
> > > -	format->width = clamp_t(unsigned int, fmt->format.width,
> > > -				LUT_MIN_SIZE, LUT_MAX_SIZE);
> > > -	format->height = clamp_t(unsigned int, fmt->format.height,
> > > -				 LUT_MIN_SIZE, LUT_MAX_SIZE);
> > > -	format->field = V4L2_FIELD_NONE;
> > > -	format->colorspace = V4L2_COLORSPACE_SRGB;
> > > -
> > > -	fmt->format = *format;
> > > -
> > > -	/* Propagate the format to the source pad. */
> > > -	format = vsp1_entity_get_pad_format(&lut->entity, config,
> > > -					    LUT_PAD_SOURCE);
> > > -	*format = fmt->format;
> > > -
> > > -done:
> > > -	mutex_unlock(&lut->entity.lock);
> > > -	return ret;
> > > +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, lut_codes,
> > > +					  ARRAY_SIZE(lut_codes),
> > > +					  LUT_MIN_SIZE, LUT_MIN_SIZE,
> > > +					  LUT_MAX_SIZE, LUT_MAX_SIZE);
> > > 
> > >  }
> > >  
> > >  /*
> > >  -----------------------------------------------------------------------
> > >  -
> > >  -----


-- 
Regards,

Laurent Pinchart
