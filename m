Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56930 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1LOKSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 05:18:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC 1/4] omap3isp: Implement validate_pipeline
Date: Thu, 15 Dec 2011 11:18:53 +0100
Cc: linux-media@vger.kernel.org
References: <20111215095015.GC3677@valkosipuli.localdomain> <1323942635-13058-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1323942635-13058-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151118.53618.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 15 December 2011 10:50:32 Sakari Ailus wrote:
> Validate pipeline of any external entity connected to the ISP driver.
> The validation of the pipeline for the part that involves links inside the
> domain of another driver must be done by that very driver.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index f229057..17bc03c 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -355,6 +355,18 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) fmt_source.format.height != fmt_sink.format.height)
>  			return -EPIPE;
> 
> +		if (subdev->host_priv) {
> +			/*
> +			 * host_priv != NULL: this is a sensor. Issue
> +			 * validate_pipeline. We're at our end of the
> +			 * pipeline so we quit now.
> +			 */
> +			ret = v4l2_subdev_call(subdev, pad, validate_pipeline);
> +			if (IS_ERR_VALUE(ret))

Is the validate pipeline operation expected to return a value different than 0 
on success ? If not if (ret < 0) should do.

Although there's another issue. Not all sensors will implement the 
validate_pipeline operation, so you shouldn't return an error if ret == -
ENOIOCTLCMD.

I will comment on the validate_pipeline approach itself in the "On controlling 
sensors" mail thread.

> +				return -EPIPE;
> +			break;
> +		}
> +
>  		if (shifter_link) {
>  			unsigned int parallel_shift = 0;
>  			if (isp->isp_ccdc.input == CCDC_INPUT_PARALLEL) {

-- 
Regards,

Laurent Pinchart
