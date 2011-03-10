Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43834 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CJANI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 19:13:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH v2 4/4] omap3isp: lane shifter support
Date: Thu, 10 Mar 2011 01:13:23 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299686863-20701-1-git-send-email-michael.jones@matrix-vision.de> <1299686863-20701-5-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299686863-20701-5-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103100113.25952.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

On Wednesday 09 March 2011 17:07:43 Michael Jones wrote:
> To use the lane shifter, set different pixel formats at each end of
> the link at the CCDC input.
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>

[snip]

> diff --git a/drivers/media/video/omap3-isp/isp.h
> b/drivers/media/video/omap3-isp/isp.h index 21fa88b..3d13f8b 100644
> --- a/drivers/media/video/omap3-isp/isp.h
> +++ b/drivers/media/video/omap3-isp/isp.h
> @@ -144,8 +144,6 @@ struct isp_reg {
>   *		ISPCTRL_PAR_BRIDGE_BENDIAN - Big endian
>   */
>  struct isp_parallel_platform_data {
> -	unsigned int width;
> -	unsigned int data_lane_shift:2;

I'm afraid you can't remove the data_lane_shift field completely. Board can 
wire a 8 bits sensor to DATA[9:2] :-/ That needs to be taken into account as 
well when computing the total shift value.

Hardware configuration can be done by adding the requested shift value to 
data_lane_shift for parallel sensors in omap3isp_configure_bridge(), but we 
also need to take it into account when validating the pipeline.

I'm not aware of any board requiring data_lane_shift at the moment though, so 
we could just drop it now and add it back later when needed. This will avoid 
making this patch more complex.

>  	unsigned int clk_pol:1;
>  	unsigned int bridge:4;
>  };

[snip]

> diff --git a/drivers/media/video/omap3-isp/ispccdc.c
> b/drivers/media/video/omap3-isp/ispccdc.c index 23000b6..923a08f 100644
> --- a/drivers/media/video/omap3-isp/ispccdc.c
> +++ b/drivers/media/video/omap3-isp/ispccdc.c
> @@ -1120,21 +1120,39 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc) struct isp_parallel_platform_data *pdata = NULL;
>  	struct v4l2_subdev *sensor;
>  	struct v4l2_mbus_framefmt *format;
> +	int depth_in = 0, depth_out = 0;

Linux discourages the declaration of multiple variables on a single line. 
Could you split this ? The depths should also be unsigned int's (as well as 
the shift value below).

> +	int shift;
> +	const struct isp_format_info *fmt_info;
> +	struct v4l2_subdev_format fmt_src;
>  	struct media_pad *pad;
>  	unsigned long flags;
>  	u32 syn_mode;
>  	u32 ccdc_pattern;

Could you keep variable declaration lines (mostly) sorted by line length ?

> 
> +	pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
> +	sensor = media_entity_to_v4l2_subdev(pad->entity);
>  	if (ccdc->input == CCDC_INPUT_PARALLEL) {
> -		pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
> -		sensor = media_entity_to_v4l2_subdev(pad->entity);
>  		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
>  			->bus.parallel;
>  	}

You can remove the curly braces as the 'if' body now contains a single 
statement.

> 
> -	omap3isp_configure_bridge(isp, ccdc->input, pdata);
> +	/* set syncif.datsz */

The following lines don't set syncif.datsz, so the comment is a bit 
misleading. I think you can replace it with

	/* Compute the lane shifter shift value to configure the bridge. */

or something similar, and remove the "find CCDC input format" comment below.

> +	fmt_src.pad = pad->index;
> +	fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	if (!v4l2_subdev_call(sensor, pad, get_fmt, NULL, &fmt_src)) {
> +		fmt_info = omap3isp_video_format_info(fmt_src.format.code);
> +		depth_in = fmt_info ? fmt_info->bpp : 0;

omap3isp_video_format_info() won't return NULL, as it supports all formats 
supported by the CCDC. You can thus skip the NULL check.

> +	}
> +
> +	/* find CCDC input format */
> +	fmt_info = omap3isp_video_format_info
> +		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
> +	depth_out = fmt_info ? fmt_info->bpp : 0;

And here too.

> +
> +	shift = depth_in - depth_out;
> +	omap3isp_configure_bridge(isp, ccdc->input, pdata, shift);
> 
> -	ccdc->syncif.datsz = pdata ? pdata->width : 10;
> +	ccdc->syncif.datsz = depth_out;
>  	ccdc_config_sync_if(ccdc, &ccdc->syncif);
> 
>  	/* CCDC_PAD_SINK */
> diff --git a/drivers/media/video/omap3-isp/ispvideo.c
> b/drivers/media/video/omap3-isp/ispvideo.c index 3c3b3c4..decc744 100644
> --- a/drivers/media/video/omap3-isp/ispvideo.c
> +++ b/drivers/media/video/omap3-isp/ispvideo.c
> @@ -47,41 +47,59 @@
> 
>  static struct isp_format_info formats[] = {

[snip]

>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
> -	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
> +	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,

Should this be

 V4L2_MBUS_FMT_SGRBG10_1X10, 0,

instead ? DPCM formats are not shiftable. It won't make any difference in 
practice, as the format is already 8-bit wide, but you state in the flavor 
field documentation that "=0 if format is not shiftable".

> +	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },

[snip]

> @@ -98,6 +116,32 @@ omap3isp_video_format_info(enum v4l2_mbus_pixelcode
> code) }
> 
>  /*
> + * Decide whether desired output pixel code can be obtained with
> + * the lane shifter by shifting the input pixel code.
> + * return 1 if the combination is possible
> + * return 0 otherwise

Return true if ... or false otherwise.

> + */
> +static bool omap3isp_is_shiftable(enum v4l2_mbus_pixelcode in,
> +		enum v4l2_mbus_pixelcode out)
> +{
> +	const struct isp_format_info *in_info, *out_info;
> +
> +	if (in == out)
> +		return 1;

return true;

(and false below).

> +
> +	in_info = omap3isp_video_format_info(in);
> +	out_info = omap3isp_video_format_info(out);
> +
> +	if ((in_info->flavor == 0) || (out_info->flavor == 0))
> +		return 0;
> +
> +	if (in_info->flavor != out_info->flavor)
> +		return 0;
> +
> +	return (in_info->bpp - out_info->bpp <= 6);

No need for brackets.

> +}
> +
> +/*
>   * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
>   * @video: ISP video instance
>   * @mbus: v4l2_mbus_framefmt format (input)
> @@ -247,6 +291,7 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) return -EPIPE;
> 
>  	while (1) {
> +		unsigned int link_has_shifter;
>  		/* Retrieve the sink format */
>  		pad = &subdev->entity.pads[0];
>  		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> @@ -275,6 +320,10 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) return -ENOSPC;
>  		}
> 
> +		/* if sink pad is on CCDC, the link has the lane shifter
> +		 * in the middle of it. */

As you'll need to resubmit the patch, please capitalize the 'If'.

> +		link_has_shifter = (subdev == &isp->isp_ccdc.subdev);

And there's no need for brackets.

> +
>  		/* Retrieve the source format */
>  		pad = media_entity_remote_source(pad);
>  		if (pad == NULL ||
> @@ -290,10 +339,18 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) return -EPIPE;
> 
>  		/* Check if the two ends match */
> -		if (fmt_source.format.code != fmt_sink.format.code ||
> -		    fmt_source.format.width != fmt_sink.format.width ||
> +		if (fmt_source.format.width != fmt_sink.format.width ||
>  		    fmt_source.format.height != fmt_sink.format.height)
>  			return -EPIPE;
> +
> +		if (link_has_shifter) {
> +			if (!omap3isp_is_shiftable(fmt_source.format.code,
> +						fmt_sink.format.code)) {
> +				pr_debug("%s not shiftable.\n", __func__);

Do we need the pr_debug call ?

> +				return -EPIPE;
> +			}
> +		} else if (fmt_source.format.code != fmt_sink.format.code)
> +			return -EPIPE;
>  	}
> 
>  	return 0;

-- 
Regards,

Laurent Pinchart
