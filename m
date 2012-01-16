Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47955 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445Ab2APOuE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 09:50:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 19/23] omap3isp: Default error handling for ccp2, csi2, preview and resizer
Date: Mon, 16 Jan 2012 15:50:07 +0100
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
References: <4F0DFE92.80102@iki.fi> <1326317220-15339-19-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1326317220-15339-19-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201161550.08193.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 11 January 2012 22:26:56 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  drivers/media/video/omap3isp/ispccp2.c    |    2 ++
>  drivers/media/video/omap3isp/ispcsi2.c    |    2 ++
>  drivers/media/video/omap3isp/isppreview.c |    2 ++
>  drivers/media/video/omap3isp/ispresizer.c |    2 ++
>  drivers/media/video/omap3isp/ispvideo.c   |   18 ++++++++----------
>  5 files changed, 16 insertions(+), 10 deletions(-)

[snip]

Does the below code belong to this patch ? The commit message doesn't explain 
why this is needed.

> diff --git a/drivers/media/video/omap3isp/ispvideo.c
> b/drivers/media/video/omap3isp/ispvideo.c index 2ff7f91..12b4d99 100644
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
> @@ -988,11 +986,15 @@ isp_video_streamon(struct file *file, void *fh, enum
> v4l2_buf_type type) */
>  	pipe = video->video.entity.pipe
>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
> +
> +	if (video->isp->pdata->set_constraints)
> +		video->isp->pdata->set_constraints(video->isp, true);
> +	pipe->l3_ick = clk_get_rate(video->isp->clock[ISP_CLK_L3_ICK]);
> +	pipe->max_rate = pipe->l3_ick;
> +
>  	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
> -	if (ret < 0) {
> -		mutex_unlock(&video->stream_lock);
> -		return ret;
> -	}
> +	if (ret < 0)
> +		goto error;

Won't this result in media_entity_pipeline_stop() being called without the 
pipeline having been succesfully started first ?

> 
>  	/* Verify that the currently configured format matches the output of
>  	 * the connected subdev.
> @@ -1024,10 +1026,6 @@ isp_video_streamon(struct file *file, void *fh, enum
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
