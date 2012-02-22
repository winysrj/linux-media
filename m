Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50846 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab2BVL03 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 06:26:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 31/33] omap3isp: Remove isp_validate_pipeline and other old stuff
Date: Wed, 22 Feb 2012 12:26:30 +0100
Message-ID: <5497917.JsAkhUn8fq@avalon>
In-Reply-To: <1329703032-31314-31-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-31-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:10 Sakari Ailus wrote:
> Remove isp_set_pixel_clock().
> 
> Remove set_pixel_clock() callback from platform callbacks since the same
> information is now passed to the ISP driver by other means.
>
> Remove struct ispccdc_vp since the only field in this structure, pixelclk,
> is no longer used.
> 
> Remove isp_video_is_shiftable() --- this will live on as ccdc_is_shiftable
> in ispccdc.c.

Could you please move those changes to the patches where you add them to the 
other modules ?

> Remove isp_video_validate_pipeline(). Pipeline validation is now split into
> appropriate subdevs, so this can be removed.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/isp.c      |   14 ---
>  drivers/media/video/omap3isp/isp.h      |    1 -
>  drivers/media/video/omap3isp/ispccdc.h  |   10 --
>  drivers/media/video/omap3isp/ispvideo.c |  139
> ------------------------------- 4 files changed, 0 insertions(+), 164
> deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c index 89a9bf8..4b2290d 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -329,19 +329,6 @@ void omap3isp_configure_bridge(struct isp_device *isp,
>  	isp_reg_writel(isp, ispctrl_val, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL);
>  }
> 
> -/**
> - * isp_set_pixel_clock - Configures the ISP pixel clock
> - * @isp: OMAP3 ISP device
> - * @pixelclk: Average pixel clock in Hz
> - *
> - * Set the average pixel clock required by the sensor. The ISP will use the
> - * lowest possible memory bandwidth settings compatible with the clock. -
> **/
> -static void isp_set_pixel_clock(struct isp_device *isp, unsigned int
> pixelclk) -{
> -	isp->isp_ccdc.vpcfg.pixelclk = pixelclk;
> -}
> -
>  void omap3isp_hist_dma_done(struct isp_device *isp)
>  {
>  	if (omap3isp_ccdc_busy(&isp->isp_ccdc) ||
> @@ -2116,7 +2103,6 @@ static int isp_probe(struct platform_device *pdev)
> 
>  	isp->autoidle = autoidle;
>  	isp->platform_cb.set_xclk = isp_set_xclk;
> -	isp->platform_cb.set_pixel_clock = isp_set_pixel_clock;
> 
>  	mutex_init(&isp->isp_mutex);
>  	spin_lock_init(&isp->stat_lock);
> diff --git a/drivers/media/video/omap3isp/isp.h
> b/drivers/media/video/omap3isp/isp.h index 43a1b16..90f3743 100644
> --- a/drivers/media/video/omap3isp/isp.h
> +++ b/drivers/media/video/omap3isp/isp.h
> @@ -126,7 +126,6 @@ struct isp_reg {
> 
>  struct isp_platform_callback {
>  	u32 (*set_xclk)(struct isp_device *isp, u32 xclk, u8 xclksel);
> -	void (*set_pixel_clock)(struct isp_device *isp, unsigned int pixelclk);
>  };
> 
>  /*
> diff --git a/drivers/media/video/omap3isp/ispccdc.h
> b/drivers/media/video/omap3isp/ispccdc.h index 6d0264b..e570abe 100644
> --- a/drivers/media/video/omap3isp/ispccdc.h
> +++ b/drivers/media/video/omap3isp/ispccdc.h
> @@ -80,14 +80,6 @@ struct ispccdc_syncif {
>  	u8 bt_r656_en;
>  };
> 
> -/*
> - * struct ispccdc_vp - Structure for Video Port parameters
> - * @pixelclk: Input pixel clock in Hz
> - */
> -struct ispccdc_vp {
> -	unsigned int pixelclk;
> -};
> -
>  enum ispccdc_lsc_state {
>  	LSC_STATE_STOPPED = 0,
>  	LSC_STATE_STOPPING = 1,
> @@ -161,7 +153,6 @@ struct ispccdc_lsc {
>   * @update: Bitmask of controls to update during the next interrupt
>   * @shadow_update: Controls update in progress by userspace
>   * @syncif: Interface synchronization configuration
> - * @vpcfg: Video port configuration
>   * @underrun: A buffer underrun occurred and a new buffer has been queued
>   * @state: Streaming state
>   * @lock: Serializes shadow_update with interrupt handler
> @@ -190,7 +181,6 @@ struct isp_ccdc_device {
>  	unsigned int shadow_update;
> 
>  	struct ispccdc_syncif syncif;
> -	struct ispccdc_vp vpcfg;
> 
>  	unsigned int underrun:1;
>  	enum isp_pipeline_stream_state state;
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index 2e4786d..07832c8 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -130,37 +130,6 @@ omap3isp_video_format_info(enum v4l2_mbus_pixelcode
> code) }
> 
>  /*
> - * Decide whether desired output pixel code can be obtained with
> - * the lane shifter by shifting the input pixel code.
> - * @in: input pixelcode to shifter
> - * @out: output pixelcode from shifter
> - * @additional_shift: # of bits the sensor's LSB is offset from CAMEXT[0]
> - *
> - * return true if the combination is possible
> - * return false otherwise
> - */
> -static bool isp_video_is_shiftable(enum v4l2_mbus_pixelcode in,
> -		enum v4l2_mbus_pixelcode out,
> -		unsigned int additional_shift)
> -{
> -	const struct isp_format_info *in_info, *out_info;
> -
> -	if (in == out)
> -		return true;
> -
> -	in_info = omap3isp_video_format_info(in);
> -	out_info = omap3isp_video_format_info(out);
> -
> -	if ((in_info->flavor == 0) || (out_info->flavor == 0))
> -		return false;
> -
> -	if (in_info->flavor != out_info->flavor)
> -		return false;
> -
> -	return in_info->bpp - out_info->bpp + additional_shift <= 6;
> -}
> -
> -/*
>   * isp_video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
>   * @video: ISP video instance
>   * @mbus: v4l2_mbus_framefmt format (input)
> @@ -284,107 +253,6 @@ isp_video_far_end(struct isp_video *video)
>  	return far_end;
>  }
> 
> -/*
> - * Validate a pipeline by checking both ends of all links for format
> - * discrepancies.
> - *
> - * Compute the minimum time per frame value as the maximum of time per
> frame - * limits reported by every block in the pipeline.
> - *
> - * Return 0 if all formats match, or -EPIPE if at least one link is found
> with - * different formats on its two ends or if the pipeline doesn't start
> with a - * video source (either a subdev with no input pad, or a non-subdev
> entity). - */
> -static int isp_video_validate_pipeline(struct isp_pipeline *pipe)
> -{
> -	struct isp_device *isp = pipe->output->isp;
> -	struct v4l2_subdev_format fmt_source;
> -	struct v4l2_subdev_format fmt_sink;
> -	struct media_pad *pad;
> -	struct v4l2_subdev *subdev;
> -	int ret;
> -
> -	subdev = isp_video_remote_subdev(pipe->output, NULL);
> -	if (subdev == NULL)
> -		return -EPIPE;
> -
> -	while (1) {
> -		unsigned int shifter_link;
> -		/* Retrieve the sink format */
> -		pad = &subdev->entity.pads[0];
> -		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> -			break;
> -
> -		fmt_sink.pad = pad->index;
> -		fmt_sink.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_sink);
> -		if (ret < 0 && ret != -ENOIOCTLCMD)
> -			return -EPIPE;
> -
> -		/* Update the maximum frame rate */
> -		if (subdev == &isp->isp_res.subdev)
> -			omap3isp_resizer_max_rate(&isp->isp_res,
> -						  &pipe->max_rate);
> -
> -		/* Check ccdc maximum data rate when data comes from sensor
> -		 * TODO: Include ccdc rate in pipe->max_rate and compare the
> -		 *       total pipe rate with the input data rate from sensor.
> -		 */
> -		if (subdev == &isp->isp_ccdc.subdev && pipe->input == NULL) {
> -			unsigned int rate = UINT_MAX;
> -
> -			omap3isp_ccdc_max_rate(&isp->isp_ccdc, &rate);
> -			if (isp->isp_ccdc.vpcfg.pixelclk > rate)
> -				return -ENOSPC;
> -		}
> -
> -		/* If sink pad is on CCDC, the link has the lane shifter
> -		 * in the middle of it. */
> -		shifter_link = subdev == &isp->isp_ccdc.subdev;
> -
> -		/* Retrieve the source format. Return an error if no source
> -		 * entity can be found, and stop checking the pipeline if the
> -		 * source entity isn't a subdev.
> -		 */
> -		pad = media_entity_remote_source(pad);
> -		if (pad == NULL)
> -			return -EPIPE;
> -
> -		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> -			break;
> -
> -		subdev = media_entity_to_v4l2_subdev(pad->entity);
> -
> -		fmt_source.pad = pad->index;
> -		fmt_source.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> -		ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt_source);
> -		if (ret < 0 && ret != -ENOIOCTLCMD)
> -			return -EPIPE;
> -
> -		/* Check if the two ends match */
> -		if (fmt_source.format.width != fmt_sink.format.width ||
> -		    fmt_source.format.height != fmt_sink.format.height)
> -			return -EPIPE;
> -
> -		if (shifter_link) {
> -			unsigned int parallel_shift = 0;
> -			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {
> -				struct isp_parallel_platform_data *pdata =
> -					&((struct isp_v4l2_subdevs_group *)
> -					      subdev->host_priv)->bus.parallel;
> -				parallel_shift = pdata->data_lane_shift * 2;
> -			}
> -			if (!isp_video_is_shiftable(fmt_source.format.code,
> -						fmt_sink.format.code,
> -						parallel_shift))
> -				return -EPIPE;
> -		} else if (fmt_source.format.code != fmt_sink.format.code)
> -			return -EPIPE;
> -	}
> -
> -	return 0;
> -}
> -
>  static int
>  __isp_video_get_format(struct isp_video *video, struct v4l2_format *format)
> {
> @@ -1034,13 +902,6 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe->output = far_end;
>  	}
> 
> -	/* Validate the pipeline and update its state. */
> -	ret = isp_video_validate_pipeline(pipe);
> -	if (ret < 0)
> -		goto err_isp_video_check_format;
> -
> -	pipe->error = false;
> -
>  	spin_lock_irqsave(&pipe->lock, flags);
>  	pipe->state &= ~ISP_PIPELINE_STREAM;
>  	pipe->state |= state;
-- 
Regards,

Laurent Pinchart
