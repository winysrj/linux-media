Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34969 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab2BVLMy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Feb 2012 06:12:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 28/33] omap3isp: Move setting constaints above media_entity_pipeline_start
Date: Wed, 22 Feb 2012 12:12:58 +0100
Message-ID: <1529298.XktDfWDNzA@avalon>
In-Reply-To: <1329703032-31314-28-git-send-email-sakari.ailus@iki.fi>
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-28-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 20 February 2012 03:57:07 Sakari Ailus wrote:

Could you please briefly explain why this is needed ?

> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispvideo.c |   11 +++++------
>  1 files changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index f1c68ca..2e4786d 100644
> --- a/drivers/media/video/omap3isp/ispvideo.c
> +++ b/drivers/media/video/omap3isp/ispvideo.c
> @@ -304,8 +304,6 @@ static int isp_video_validate_pipeline(struct
> isp_pipeline *pipe) struct v4l2_subdev *subdev;
>  	int ret;
> 
> -	pipe->max_rate = pipe->l3_ick;
> -
>  	subdev = isp_video_remote_subdev(pipe->output, NULL);
>  	if (subdev == NULL)
>  		return -EPIPE;
> @@ -997,6 +995,11 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe->external_rate = 0;
>  	pipe->external_bpp = 0;
> 
> +	if (video->isp->pdata->set_constraints)
> +		video->isp->pdata->set_constraints(video->isp, true);
> +	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> +	pipe->max_rate = pipe->l3_ick;
> +
>  	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
>  	if (ret < 0)
>  		goto err_media_entity_pipeline_start;
> @@ -1031,10 +1034,6 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) pipe->output = far_end;
>  	}
> 
> -	if (video->isp->pdata->set_constraints)
> -		video->isp->pdata->set_constraints(video->isp, true);
> -	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> -
>  	/* Validate the pipeline and update its state. */
>  	ret = isp_video_validate_pipeline(pipe);
>  	if (ret < 0)
-- 
Regards,

Laurent Pinchart
