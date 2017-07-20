Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38900 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935486AbdGTPUI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 11:20:08 -0400
Date: Thu, 20 Jul 2017 18:20:03 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 17/23] camss: vfe: Add interface for scaling
Message-ID: <20170720152003.34jm4hwhgejy2rsy@valkosipuli.retiisi.org.uk>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
 <1500287629-23703-18-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1500287629-23703-18-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Jul 17, 2017 at 01:33:43PM +0300, Todor Tomov wrote:
> Add compose selection ioctls to handle scaling configuration.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 189 ++++++++++++++++++++-
>  drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   1 +
>  2 files changed, 188 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> index 327f158..8ec6ce7 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
> @@ -211,6 +211,8 @@
>  #define CAMIF_TIMEOUT_SLEEP_US 1000
>  #define CAMIF_TIMEOUT_ALL_US 1000000
>  
> +#define SCALER_RATIO_MAX 16
> +
>  static const u32 vfe_formats[] = {
>  	MEDIA_BUS_FMT_UYVY8_2X8,
>  	MEDIA_BUS_FMT_VYUY8_2X8,
> @@ -1905,6 +1907,25 @@ __vfe_get_format(struct vfe_line *line,
>  	return &line->fmt[pad];
>  }
>  
> +/*
> + * __vfe_get_compose - Get pointer to compose selection structure
> + * @line: VFE line
> + * @cfg: V4L2 subdev pad configuration
> + * @which: TRY or ACTIVE format
> + *
> + * Return pointer to TRY or ACTIVE compose rectangle structure
> + */
> +static struct v4l2_rect *
> +__vfe_get_compose(struct vfe_line *line,
> +		  struct v4l2_subdev_pad_config *cfg,
> +		  enum v4l2_subdev_format_whence which)
> +{
> +	if (which == V4L2_SUBDEV_FORMAT_TRY)
> +		return v4l2_subdev_get_try_compose(&line->subdev, cfg,
> +						   MSM_VFE_PAD_SINK);
> +
> +	return &line->compose;
> +}
>  
>  /*
>   * vfe_try_format - Handle try format by pad subdev method
> @@ -1951,7 +1972,14 @@ static void vfe_try_format(struct vfe_line *line,
>  		*fmt = *__vfe_get_format(line, cfg, MSM_VFE_PAD_SINK,
>  					 which);
>  
> -		if (line->id == VFE_LINE_PIX)
> +		if (line->id == VFE_LINE_PIX) {
> +			struct v4l2_rect *rect;
> +
> +			rect = __vfe_get_compose(line, cfg, which);
> +
> +			fmt->width = rect->width;
> +			fmt->height = rect->height;
> +
>  			switch (fmt->code) {
>  			case MEDIA_BUS_FMT_YUYV8_2X8:
>  				if (code == MEDIA_BUS_FMT_YUYV8_1_5X8)
> @@ -1979,6 +2007,7 @@ static void vfe_try_format(struct vfe_line *line,
>  					fmt->code = MEDIA_BUS_FMT_VYUY8_2X8;
>  				break;
>  			}
> +		}
>  
>  		break;
>  	}
> @@ -1987,6 +2016,50 @@ static void vfe_try_format(struct vfe_line *line,
>  }
>  
>  /*
> + * vfe_try_compose - Handle try compose selection by pad subdev method
> + * @line: VFE line
> + * @cfg: V4L2 subdev pad configuration
> + * @rect: pointer to v4l2 rect structure
> + * @which: wanted subdev format
> + */
> +static void vfe_try_compose(struct vfe_line *line,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_rect *rect,
> +			    enum v4l2_subdev_format_whence which)
> +{
> +	struct v4l2_mbus_framefmt *fmt;
> +
> +	rect->width = rect->width - rect->left;
> +	rect->left = 0;

This is the compose rectangle i.e. left and top should be zero (unless it's
about composing on e.g. a frame buffer). No need to decrement from width;
similarly for height below.

> +	rect->height = rect->height - rect->top;
> +	rect->top = 0;
> +
> +	fmt = __vfe_get_format(line, cfg, MSM_VFE_PAD_SINK, which);
> +
> +	if (rect->width > fmt->width)
> +		rect->width = fmt->width;
> +
> +	if (rect->height > fmt->height)
> +		rect->height = fmt->height;
> +
> +	if (fmt->width > rect->width * SCALER_RATIO_MAX)
> +		rect->width = (fmt->width + SCALER_RATIO_MAX - 1) /
> +							SCALER_RATIO_MAX;
> +
> +	rect->width &= ~0x1;
> +
> +	if (fmt->height > rect->height * SCALER_RATIO_MAX)
> +		rect->height = (fmt->height + SCALER_RATIO_MAX - 1) /
> +							SCALER_RATIO_MAX;
> +
> +	if (rect->width < 16)
> +		rect->width = 16;
> +
> +	if (rect->height < 4)
> +		rect->height = 4;
> +}
> +
> +/*
>   * vfe_enum_mbus_code - Handle pixel format enumeration
>   * @sd: VFE V4L2 subdevice
>   * @cfg: V4L2 subdev pad configuration
> @@ -2081,6 +2154,10 @@ static int vfe_get_format(struct v4l2_subdev *sd,
>  	return 0;
>  }
>  
> +static int vfe_set_selection(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_selection *sel);
> +
>  /*
>   * vfe_set_format - Handle set format by pads subdev method
>   * @sd: VFE V4L2 subdevice
> @@ -2103,20 +2180,126 @@ static int vfe_set_format(struct v4l2_subdev *sd,
>  	vfe_try_format(line, cfg, fmt->pad, &fmt->format, fmt->which);
>  	*format = fmt->format;
>  
> -	/* Propagate the format from sink to source */
>  	if (fmt->pad == MSM_VFE_PAD_SINK) {
> +		struct v4l2_subdev_selection sel = { 0 };
> +		int ret;
> +
> +		/* Propagate the format from sink to source */
>  		format = __vfe_get_format(line, cfg, MSM_VFE_PAD_SRC,
>  					  fmt->which);
>  
>  		*format = fmt->format;
>  		vfe_try_format(line, cfg, MSM_VFE_PAD_SRC, format,
>  			       fmt->which);
> +
> +		if (line->id != VFE_LINE_PIX)
> +			return 0;
> +
> +		/* Reset sink pad compose selection */
> +		sel.which = fmt->which;
> +		sel.pad = MSM_VFE_PAD_SINK;
> +		sel.target = V4L2_SEL_TGT_COMPOSE;
> +		sel.r.width = fmt->format.width;
> +		sel.r.height = fmt->format.height;
> +		ret = vfe_set_selection(sd, cfg, &sel);
> +		if (ret < 0)
> +			return ret;
>  	}
>  
>  	return 0;
>  }
>  
>  /*
> + * vfe_get_selection - Handle get selection by pads subdev method
> + * @sd: VFE V4L2 subdevice
> + * @cfg: V4L2 subdev pad configuration
> + * @sel: pointer to v4l2 subdev selection structure
> + *
> + * Return -EINVAL or zero on success
> + */
> +static int vfe_get_selection(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_selection *sel)
> +{
> +	struct vfe_line *line = v4l2_get_subdevdata(sd);
> +	struct v4l2_subdev_format fmt = { 0 };
> +	struct v4l2_rect *compose;
> +	int ret;
> +
> +	if (line->id != VFE_LINE_PIX || sel->pad != MSM_VFE_PAD_SINK)
> +		return -EINVAL;
> +
> +	switch (sel->target) {
> +	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
> +		fmt.pad = sel->pad;
> +		fmt.which = sel->which;
> +		ret = vfe_get_format(sd, cfg, &fmt);
> +		if (ret < 0)
> +			return ret;
> +		sel->r.left = 0;
> +		sel->r.top = 0;
> +		sel->r.width = fmt.format.width;
> +		sel->r.height = fmt.format.height;
> +		break;
> +	case V4L2_SEL_TGT_COMPOSE:
> +		compose = __vfe_get_compose(line, cfg, sel->which);
> +		if (compose == NULL)
> +			return -EINVAL;
> +
> +		sel->r = *compose;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * vfe_set_selection - Handle set selection by pads subdev method
> + * @sd: VFE V4L2 subdevice
> + * @cfg: V4L2 subdev pad configuration
> + * @sel: pointer to v4l2 subdev selection structure
> + *
> + * Return -EINVAL or zero on success
> + */
> +int vfe_set_selection(struct v4l2_subdev *sd,
> +			     struct v4l2_subdev_pad_config *cfg,
> +			     struct v4l2_subdev_selection *sel)
> +{
> +	struct vfe_line *line = v4l2_get_subdevdata(sd);
> +	struct v4l2_rect *compose;
> +	struct v4l2_subdev_format fmt = { 0 };
> +	int ret;
> +
> +	if (line->id != VFE_LINE_PIX || sel->pad != MSM_VFE_PAD_SINK)
> +		return -EINVAL;
> +
> +	if (sel->target != V4L2_SEL_TGT_COMPOSE)
> +		return -EINVAL;
> +
> +	compose = __vfe_get_compose(line, cfg, sel->which);
> +	if (compose == NULL)
> +		return -EINVAL;
> +
> +	vfe_try_compose(line, cfg, &sel->r, sel->which);
> +	*compose = sel->r;
> +
> +	/* Reset source pad format width and height */
> +	fmt.which = sel->which;
> +	fmt.pad = MSM_VFE_PAD_SRC;
> +	ret = vfe_get_format(sd, cfg, &fmt);
> +	if (ret < 0)
> +		return ret;
> +
> +	fmt.format.width = compose->width;
> +	fmt.format.height = compose->height;
> +	ret = vfe_set_format(sd, cfg, &fmt);
> +
> +	return ret;
> +}
> +
> +/*
>   * vfe_init_formats - Initialize formats on all pads
>   * @sd: VFE V4L2 subdevice
>   * @fh: V4L2 subdev file handle
> @@ -2310,6 +2493,8 @@ static const struct v4l2_subdev_pad_ops vfe_pad_ops = {
>  	.enum_frame_size = vfe_enum_frame_size,
>  	.get_fmt = vfe_get_format,
>  	.set_fmt = vfe_set_format,
> +	.get_selection = vfe_get_selection,
> +	.set_selection = vfe_set_selection,
>  };
>  
>  static const struct v4l2_subdev_ops vfe_v4l2_ops = {
> diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
> index b0598e4..6518c7a 100644
> --- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
> +++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
> @@ -80,6 +80,7 @@ struct vfe_line {
>  	struct v4l2_subdev subdev;
>  	struct media_pad pads[MSM_VFE_PADS_NUM];
>  	struct v4l2_mbus_framefmt fmt[MSM_VFE_PADS_NUM];
> +	struct v4l2_rect compose;
>  	struct camss_video video_out;
>  	struct vfe_output output;
>  };
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
