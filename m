Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50668 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbeD1QHc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Apr 2018 12:07:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH v2 2/8] v4l: vsp1: Share the CLU, LIF and LUT set_fmt pad operation code
Date: Sat, 28 Apr 2018 19:07:47 +0300
Message-ID: <17550874.WPgDx0BBl0@avalon>
In-Reply-To: <20180428095048.GA18201@w540>
References: <20180422223430.16407-1-laurent.pinchart+renesas@ideasonboard.com> <20180422223430.16407-3-laurent.pinchart+renesas@ideasonboard.com> <20180428095048.GA18201@w540>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Saturday, 28 April 2018 12:50:48 EEST jacopo mondi wrote:
> Hi Laurent,
>    very minor comments below
> 
> On Mon, Apr 23, 2018 at 01:34:24AM +0300, Laurent Pinchart wrote:
> > The implementation of the set_fmt pad operation is identical in the
> > three modules. Move it to a generic helper function.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  drivers/media/platform/vsp1/vsp1_clu.c    | 65 +++++--------------------
> >  drivers/media/platform/vsp1/vsp1_entity.c | 75 ++++++++++++++++++++++++++
> >  drivers/media/platform/vsp1/vsp1_entity.h |  6 +++
> >  drivers/media/platform/vsp1/vsp1_lif.c    | 65 +++++--------------------
> >  drivers/media/platform/vsp1/vsp1_lut.c    | 65 +++++--------------------
> >  5 files changed, 116 insertions(+), 160 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_clu.c
> > b/drivers/media/platform/vsp1/vsp1_clu.c index 9626b6308585..96a448e1504c
> > 100644
> > --- a/drivers/media/platform/vsp1/vsp1_clu.c
> > +++ b/drivers/media/platform/vsp1/vsp1_clu.c
> > @@ -114,18 +114,18 @@ static const struct v4l2_ctrl_config
> > clu_mode_control = {
> >   * V4L2 Subdevice Pad Operations
> >   */
> > 
> > +static const unsigned int clu_codes[] = {
> > +	MEDIA_BUS_FMT_ARGB8888_1X32,
> > +	MEDIA_BUS_FMT_AHSV8888_1X32,
> > +	MEDIA_BUS_FMT_AYUV8_1X32,
> > +};
> > +
> >  static int clu_enum_mbus_code(struct v4l2_subdev *subdev,
> >  			      struct v4l2_subdev_pad_config *cfg,
> >  			      struct v4l2_subdev_mbus_code_enum *code)
> >  {
> > -	static const unsigned int codes[] = {
> > -		MEDIA_BUS_FMT_ARGB8888_1X32,
> > -		MEDIA_BUS_FMT_AHSV8888_1X32,
> > -		MEDIA_BUS_FMT_AYUV8_1X32,
> > -	};
> > -
> > -	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
> > -					  ARRAY_SIZE(codes));
> > +	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, clu_codes,
> > +					  ARRAY_SIZE(clu_codes));
> >  }
> >  
> >  static int clu_enum_frame_size(struct v4l2_subdev *subdev,
> > @@ -141,51 +141,10 @@ static int clu_set_format(struct v4l2_subdev
> > *subdev,
> >  			  struct v4l2_subdev_pad_config *cfg,
> >  			  struct v4l2_subdev_format *fmt)
> >  {
> > -	struct vsp1_clu *clu = to_clu(subdev);
> > -	struct v4l2_subdev_pad_config *config;
> > -	struct v4l2_mbus_framefmt *format;
> > -	int ret = 0;
> > -
> > -	mutex_lock(&clu->entity.lock);
> > -
> > -	config = vsp1_entity_get_pad_config(&clu->entity, cfg, fmt->which);
> > -	if (!config) {
> > -		ret = -EINVAL;
> > -		goto done;
> > -	}
> > -
> > -	/* Default to YUV if the requested format is not supported. */
> > -	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
> > -	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
> > -	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
> > -		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
> 
> The newly implemented vsp1_subdev_set_pad_format defaults to the first
> clu_codes[] member (ARGB888_1x32), while here the code chose the AYUV8_1x32
> format. Is it ok? Should you revers the clu_codes[] order?

But that would then change the order of the format enumeration.

I don't think it's a big deal, the change here will only affect the format 
returned if userspace tries to pick a format that is not supported (and thus 
not returned by the enumeration). This shouldn't happen in the first place, 
and if it does, the driver has never guaranteed that a specific format would 
be returned.

> > -
> > -	format = vsp1_entity_get_pad_format(&clu->entity, config, fmt->pad);
> > -
> > -	if (fmt->pad == CLU_PAD_SOURCE) {
> > -		/* The CLU output format can't be modified. */
> > -		fmt->format = *format;
> > -		goto done;
> > -	}
> > -
> > -	format->code = fmt->format.code;
> > -	format->width = clamp_t(unsigned int, fmt->format.width,
> > -				CLU_MIN_SIZE, CLU_MAX_SIZE);
> > -	format->height = clamp_t(unsigned int, fmt->format.height,
> > -				 CLU_MIN_SIZE, CLU_MAX_SIZE);
> > -	format->field = V4L2_FIELD_NONE;
> > -	format->colorspace = V4L2_COLORSPACE_SRGB;
> > -
> > -	fmt->format = *format;
> > -
> > -	/* Propagate the format to the source pad. */
> > -	format = vsp1_entity_get_pad_format(&clu->entity, config,
> > -					    CLU_PAD_SOURCE);
> > -	*format = fmt->format;
> > -
> > -done:
> > -	mutex_unlock(&clu->entity.lock);
> > -	return ret;
> > +	return vsp1_subdev_set_pad_format(subdev, cfg, fmt, clu_codes,
> > +					  ARRAY_SIZE(clu_codes),
> > +					  CLU_MIN_SIZE, CLU_MIN_SIZE,
> > +					  CLU_MAX_SIZE, CLU_MAX_SIZE);
> >  }
> >  
> >  /* ----------------------------------------------------------------------
> > diff --git a/drivers/media/platform/vsp1/vsp1_entity.c
> > b/drivers/media/platform/vsp1/vsp1_entity.c index
> > 72354caf5746..239df047efd0 100644
> > --- a/drivers/media/platform/vsp1/vsp1_entity.c
> > +++ b/drivers/media/platform/vsp1/vsp1_entity.c
> > @@ -307,6 +307,81 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev
> > *subdev,
> >  	return ret;
> >  }
> > 
> > +/*
> > + * vsp1_subdev_set_pad_format - Subdev pad set_fmt handler
> > + * @subdev: V4L2 subdevice
> > + * @cfg: V4L2 subdev pad configuration
> > + * @fmt: V4L2 subdev format
> > + * @codes: Array of supported media bus codes
> > + * @ncodes: Number of supported media bus codes
> > + * @min_width: Minimum image width
> > + * @min_height: Minimum image height
> > + * @max_width: Maximum image width
> > + * @max_height: Maximum image height
> > + *
> > + * This function implements the subdev set_fmt pad operation for entities
> > that
> > + * do not support scaling or cropping. It defaults to the first supplied
> > media
> > + * bus code if the requested code isn't supported, clamps the size to the
> > + * supplied minimum and maximum, and propagates the sink pad format to
> > the
> > + * source pad.
> > + */
> > +int vsp1_subdev_set_pad_format(struct v4l2_subdev *subdev,
> > +			       struct v4l2_subdev_pad_config *cfg,
> > +			       struct v4l2_subdev_format *fmt,
> > +			       const unsigned int *codes, unsigned int ncodes,
> > +			       unsigned int min_width, unsigned int min_height,
> > +			       unsigned int max_width, unsigned int max_height)
> > +{
> > +	struct vsp1_entity *entity = to_vsp1_entity(subdev);
> > +	struct v4l2_subdev_pad_config *config;
> > +	struct v4l2_mbus_framefmt *format;
> > +	unsigned int i;
> > +	int ret = 0;
> > +
> > +	mutex_lock(&entity->lock);
> > +
> > +	config = vsp1_entity_get_pad_config(entity, cfg, fmt->which);
> > +	if (!config) {
> > +		ret = -EINVAL;
> > +		goto done;
> > +	}
> > +
> > +	format = vsp1_entity_get_pad_format(entity, config, fmt->pad);
> > +
> > +	if (fmt->pad != 0) {
> 
> This assumes the SINK pad is always 0, which indeed is the case for
> CLU, LIF and LUT entities.
> 
> > +		/* The output format can't be modified. */
> > +		fmt->format = *format;
> > +		goto done;
> > +	}
> > +
> > +	/*
> > +	 * Default to the first media bus code if the requested format is not
> > +	 * supported.
> > +	 */
> > +	for (i = 0; i < ncodes; ++i) {
> > +		if (fmt->format.code == codes[i])
> > +			break;
> > +	}
> 
> Braces not needed?

Not strictly required but I find it more readable.

> > +
> > +	format->code = i < ncodes ? codes[i] : codes[0];
> > +	format->width = clamp_t(unsigned int, fmt->format.width,
> > +				min_width, max_width);
> > +	format->height = clamp_t(unsigned int, fmt->format.height,
> > +				 min_height, max_height);
> > +	format->field = V4L2_FIELD_NONE;
> > +	format->colorspace = V4L2_COLORSPACE_SRGB;
> > +
> > +	fmt->format = *format;
> > +
> > +	/* Propagate the format to the source pad. */
> > +	format = vsp1_entity_get_pad_format(entity, config, 1);
> > +	*format = fmt->format;
> > +
> > +done:
> > +	mutex_unlock(&entity->lock);
> > +	return ret;
> > +}

[snip]

-- 
Regards,

Laurent Pinchart
