Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54490 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1CDQdL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 11:33:11 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [PATCH 4/4] omap3isp: lane shifter support
Date: Fri, 4 Mar 2011 17:33:23 +0100
Cc: linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <1299229084-8335-1-git-send-email-michael.jones@matrix-vision.de> <1299229084-8335-5-git-send-email-michael.jones@matrix-vision.de>
In-Reply-To: <1299229084-8335-5-git-send-email-michael.jones@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201103041733.23754.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi sMichal,

Thanks for the patch.

On Friday 04 March 2011 09:58:04 Michael Jones wrote:
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
>  drivers/media/video/omap3-isp/isp.c      |   82
> +++++++++++++++++++++++++++++- drivers/media/video/omap3-isp/isp.h      | 
>   4 +-
>  drivers/media/video/omap3-isp/ispccdc.c  |    2 +-
>  drivers/media/video/omap3-isp/ispvideo.c |   65 +++++++++++++++++-------
>  drivers/media/video/omap3-isp/ispvideo.h |    3 +
>  5 files changed, 134 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/video/omap3-isp/isp.c
> b/drivers/media/video/omap3-isp/isp.c index 08d90fe..20e6daa 100644
> --- a/drivers/media/video/omap3-isp/isp.c
> +++ b/drivers/media/video/omap3-isp/isp.c
> @@ -273,6 +273,44 @@ static void isp_power_settings(struct isp_device *isp,
> int idle) }
> 
>  /*
> + * Decide whether desired output pixel code can be obtained with
> + * the lane shifter by shifting the input pixel code.
> + * return 1 if the combination is possible
> + * return 0 otherwise
> + */
> +int omap3isp_is_shiftable(enum v4l2_mbus_pixelcode in,
> +		enum v4l2_mbus_pixelcode out)

As you only use this function in ispvideo.c, I would move it there. You could 
also make the function return a bool.

> +{
> +	const struct isp_format_info *in_info, *out_info;
> +	int shiftable = 0;
> +	if ((in == 0) || (out == 0))
> +		return 0;

Can this happen ?

> +
> +	if (in == out)
> +		return 1;
> +
> +	in_info = omap3isp_video_format_info(in);
> +	out_info = omap3isp_video_format_info(out);
> +	if ((!in_info) || (!out_info))
> +		return 0;

Can this happen ?

> +
> +	if (in_info->flavor != out_info->flavor)
> +		return 0;
> +
> +	switch (in_info->bpp - out_info->bpp) {
> +	case 2:
> +	case 4:
> +	case 6:
> +		shiftable = 1;
> +		break;
> +	default:
> +		shiftable = 0;
> +	}

What about

return in_info->bpp - out_info->bpp <= 6;

> +
> +	return shiftable;
> +}
> +
> +/*
>   * Configure the bridge and lane shifter. Valid inputs are
>   *
>   * CCDC_INPUT_PARALLEL: Parallel interface
> @@ -288,6 +326,10 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>  			       const struct isp_parallel_platform_data *pdata)
>  {
>  	u32 ispctrl_val;
> +	u32 depth_in = 0, depth_out = 0;
> +	u32 shift;
> +	const struct isp_format_info *fmt_info;
> +	struct media_pad *srcpad;
> 
>  	ispctrl_val  = isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
>  	ispctrl_val &= ~ISPCTRL_SHIFT_MASK;
> @@ -298,7 +340,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>  	switch (input) {
>  	case CCDC_INPUT_PARALLEL:
>  		ispctrl_val |= ISPCTRL_PAR_SER_CLK_SEL_PARALLEL;
> -		ispctrl_val |= pdata->data_lane_shift << ISPCTRL_SHIFT_SHIFT;
>  		ispctrl_val |= pdata->clk_pol << ISPCTRL_PAR_CLK_POL_SHIFT;
>  		ispctrl_val |= pdata->bridge << ISPCTRL_PAR_BRIDGE_SHIFT;
>  		break;
> @@ -319,6 +360,45 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>  		return;
>  	}
> 
> +	/* find output format from the remote end of the link connected to
> +	 * CCDC sink pad
> +	 */
> +	srcpad = media_entity_remote_source(&isp->isp_ccdc.pads[CCDC_PAD_SINK]);
> +	if (srcpad == NULL)
> +		dev_err(isp->dev, "No active input to CCDC.\n");

There's no need to test for NULL, as this function will only be called on 
streamon, so the pipeline will be valid.

> +	if (media_entity_type(srcpad->entity) == MEDIA_ENT_T_V4L2_SUBDEV) {

The CCDC has no memory input, so this condition will always be true.

> +		struct v4l2_subdev *subdev =
> +		   media_entity_to_v4l2_subdev(srcpad->entity);
> +		struct v4l2_subdev_format fmt_src;
> +		fmt_src.pad = srcpad->index;
> +		fmt_src.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +		if (!v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_src)) {
> +			fmt_info =
> +			   omap3isp_video_format_info(fmt_src.format.code);
> +			depth_in = fmt_info ? fmt_info->bpp : 0;
> +		}
> +	}
> +
> +	/* find CCDC input format */
> +	fmt_info = omap3isp_video_format_info
> +		(isp->isp_ccdc.formats[CCDC_PAD_SINK].code);
> +	depth_out = fmt_info ? fmt_info->bpp : 0;
> +
> +	isp->isp_ccdc.syncif.datsz = depth_out;
> +
> +	/* determine necessary shifting */
> +	if (depth_in == depth_out + 6)
> +		shift = 3;
> +	else if (depth_in == depth_out + 4)
> +		shift = 2;
> +	else if (depth_in == depth_out + 2)
> +		shift = 1;
> +	else
> +		shift = 0;

Maybe shift = (depth_out - depth_in) / 2; ?

> +
> +	ispctrl_val |= shift << ISPCTRL_SHIFT_SHIFT;
> +
>  	ispctrl_val &= ~ISPCTRL_SYNC_DETECT_MASK;
>  	ispctrl_val |= ISPCTRL_SYNC_DETECT_VSRISE;
> 

[snip]

> diff --git a/drivers/media/video/omap3-isp/ispccdc.c
> b/drivers/media/video/omap3-isp/ispccdc.c index 166115d..efaf317 100644
> --- a/drivers/media/video/omap3-isp/ispccdc.c
> +++ b/drivers/media/video/omap3-isp/ispccdc.c
> @@ -1132,7 +1132,7 @@ static void ccdc_configure(struct isp_ccdc_device
> *ccdc)
> 
>  	omap3isp_configure_bridge(isp, ccdc->input, pdata);
> 
> -	ccdc->syncif.datsz = pdata ? pdata->width : 10;
> +	/* syncif.datsz was set in isp_configure_bridge() */

I'd rather set syncif.datsz in ispccdc.c than in isp.c, as all other syncif 
fields are set there. It might even make sense to compute the shift value here 
and pass it to omap3isp_configure_bridge, especially with the code a couple of 
lines above to retrieve the connected subdev (which would need to be moved out 
of the if(), except for the pdata line).

>  	ccdc_config_sync_if(ccdc, &ccdc->syncif);
> 
>  	/* CCDC_PAD_SINK */
> diff --git a/drivers/media/video/omap3-isp/ispvideo.c
> b/drivers/media/video/omap3-isp/ispvideo.c index c406043..4602d20 100644
> --- a/drivers/media/video/omap3-isp/ispvideo.c
> +++ b/drivers/media/video/omap3-isp/ispvideo.c
> @@ -47,37 +47,53 @@
> 
>  static struct isp_format_info formats[] = {
>  	{ V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
> -	  V4L2_MBUS_FMT_Y8_1X8, V4L2_PIX_FMT_GREY, 8, },
> +	  V4L2_MBUS_FMT_Y8_1X8, V4L2_MBUS_FMT_Y8_1X8,
> +	  V4L2_PIX_FMT_GREY, 8, },
>  	{ V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y10_1X10,
> -	  V4L2_MBUS_FMT_Y10_1X10, V4L2_PIX_FMT_Y10, 10, },
> +	  V4L2_MBUS_FMT_Y10_1X10, V4L2_MBUS_FMT_Y8_1X8,
> +	  V4L2_PIX_FMT_Y10, 10, },
>  	{ V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y10_1X10,
> -	  V4L2_MBUS_FMT_Y12_1X12, V4L2_PIX_FMT_Y12, 12, },
> +	  V4L2_MBUS_FMT_Y12_1X12, V4L2_MBUS_FMT_Y8_1X8,
> +	  V4L2_PIX_FMT_Y12, 12, },
>  	{ V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
> -	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8, },
> +	  V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_MBUS_FMT_SBGGR8_1X8,
> +	  V4L2_PIX_FMT_SBGGR8, 8, },
>  	{ V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
> -	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8, },
> +	  V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_MBUS_FMT_SGRBG8_1X8,
> +	  V4L2_PIX_FMT_SGRBG8, 8, },
>  	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
> -	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
> +	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
> +	  V4L2_PIX_FMT_SGRBG10DPCM8, 8, },
>  	{ V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR10_1X10,
> -	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10, 10, },
> +	  V4L2_MBUS_FMT_SBGGR10_1X10, V4L2_MBUS_FMT_SBGGR8_1X8,
> +	  V4L2_PIX_FMT_SBGGR10, 10, },
>  	{ V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG10_1X10,
> -	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10, 10, },
> +	  V4L2_MBUS_FMT_SGBRG10_1X10, V4L2_MBUS_FMT_SGBRG8_1X8,
> +	  V4L2_PIX_FMT_SGBRG10, 10, },
>  	{ V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG10_1X10,
> -	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10, 10, },
> +	  V4L2_MBUS_FMT_SGRBG10_1X10, V4L2_MBUS_FMT_SGRBG8_1X8,
> +	  V4L2_PIX_FMT_SGRBG10, 10, },
>  	{ V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB10_1X10,
> -	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10, 10, },
> +	  V4L2_MBUS_FMT_SRGGB10_1X10, V4L2_MBUS_FMT_SRGGB8_1X8,
> +	  V4L2_PIX_FMT_SRGGB10, 10, },
>  	{ V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR10_1X10,
> -	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SBGGR12, 12, },
> +	  V4L2_MBUS_FMT_SBGGR12_1X12, V4L2_MBUS_FMT_SBGGR8_1X8,
> +	  V4L2_PIX_FMT_SBGGR12, 12, },
>  	{ V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG10_1X10,
> -	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12, 12, },
> +	  V4L2_MBUS_FMT_SGBRG12_1X12, V4L2_MBUS_FMT_SGBRG8_1X8,
> +	  V4L2_PIX_FMT_SGBRG12, 12, },
>  	{ V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG10_1X10,
> -	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12, 12, },
> +	  V4L2_MBUS_FMT_SGRBG12_1X12, V4L2_MBUS_FMT_SGRBG8_1X8,
> +	  V4L2_PIX_FMT_SGRBG12, 12, },
>  	{ V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB10_1X10,
> -	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12, 12, },
> +	  V4L2_MBUS_FMT_SRGGB12_1X12, V4L2_MBUS_FMT_SRGGB8_1X8,
> +	  V4L2_PIX_FMT_SRGGB12, 12, },
>  	{ V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_1X16,
> -	  V4L2_MBUS_FMT_UYVY8_1X16, V4L2_PIX_FMT_UYVY, 16, },
> +	  V4L2_MBUS_FMT_UYVY8_1X16, V4L2_MBUS_FMT_UYVY8_2X8,
> +	  V4L2_PIX_FMT_UYVY, 16, },
>  	{ V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_1X16,
> -	  V4L2_MBUS_FMT_YUYV8_1X16, V4L2_PIX_FMT_YUYV, 16, },
> +	  V4L2_MBUS_FMT_YUYV8_1X16, V4L2_MBUS_FMT_YUYV8_2X8,

I don't think these two are correct. YUYV8_1X16 doesn't magically become 
YUYV8_2X8 when shifted. As those formats can only be used by the preview 
engine and the resizer, they're pretty much unshiftable.

> +	  V4L2_PIX_FMT_YUYV, 16, },
>  };
> 
>  const struct isp_format_info *
> @@ -243,6 +259,7 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) return -EPIPE;
> 
>  	while (1) {
> +		unsigned int link_has_shifter;
>  		/* Retrieve the sink format */
>  		pad = &subdev->entity.pads[0];
>  		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> @@ -271,6 +288,10 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) return -ENOSPC;
>  		}
> 
> +		/* if sink pad is on CCDC, the link has the lane shifter
> +		 * in the middle of it. */
> +		link_has_shifter = (subdev == &isp->isp_ccdc.subdev);
> +
>  		/* Retrieve the source format */
>  		pad = media_entity_remote_source(pad);
>  		if (pad == NULL ||
> @@ -286,10 +307,18 @@ static int isp_video_validate_pipeline(struct
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
> +				return -EPIPE;
> +			}
> +		} else if (fmt_source.format.code != fmt_sink.format.code)
> +			return -EPIPE;
>  	}
> 
>  	return 0;
> diff --git a/drivers/media/video/omap3-isp/ispvideo.h
> b/drivers/media/video/omap3-isp/ispvideo.h index 524a1ac..7794cb4 100644
> --- a/drivers/media/video/omap3-isp/ispvideo.h
> +++ b/drivers/media/video/omap3-isp/ispvideo.h
> @@ -49,6 +49,8 @@ struct v4l2_pix_format;
>   *	bits. Identical to @code if the format is 10 bits wide or less.
>   * @uncompressed: V4L2 media bus format code for the corresponding
> uncompressed
>   *	format. Identical to @code if the format is not DPCM compressed.
> + *	@flavor: V4L2 media bus format code for the same pixel layout but

@flavor should be aligned left on @uncompressed and @pixelformat.

> + *	shifted to be 8 bits per pixel.
>   * @pixelformat: V4L2 pixel format FCC identifier
>   * @bpp: Bits per pixel
>   */
> @@ -56,6 +58,7 @@ struct isp_format_info {
>  	enum v4l2_mbus_pixelcode code;
>  	enum v4l2_mbus_pixelcode truncated;
>  	enum v4l2_mbus_pixelcode uncompressed;
> +	enum v4l2_mbus_pixelcode flavor;
>  	u32 pixelformat;
>  	unsigned int bpp;
>  };

-- 
Regards,

Laurent Pinchart
