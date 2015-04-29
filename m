Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37141 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbbD2TKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 15:10:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	Simon Horman <horms@verge.net.au>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH/RFC] v4l: vsp1: Fix Suspend-to-RAM
Date: Wed, 29 Apr 2015 22:10:38 +0300
Message-ID: <1823698.5Nvuu0NHzD@avalon>
In-Reply-To: <1426429987-3134-1-git-send-email-ykaneko0929@gmail.com>
References: <1426429987-3134-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kaneko-san,

I'm so sorry for the very late reply, I had missed your patch :-/

First of all, thank you for the patch. Please see below for a few comments.

On Sunday 15 March 2015 23:33:07 Yoshihiro Kaneko wrote:
> From: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>
> 
> Fix Suspend-to-RAM
> so that VSP1 driver continues to work after resuming.
> 
> In detail,
>   - Fix the judgment of ref count in resuming.
>   - Add stopping VSP1 during suspend.

That's two fixes, I believe they should be split in two patches, one to fix 
the ref_count bug at resume time, and the other one to stop/restart the video 
stream.

> Signed-off-by: Sei Fumizono <sei.fumizono.jw@hitachi-solutions.com>
> Signed-off-by: Yoshifumi Hosoya <yoshifumi.hosoya.wj@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> This patch is based on the master branch of linuxtv.org/media_tree.git.
> 
>  drivers/media/platform/vsp1/vsp1_drv.c   | 39 +++++++++++++++++++++++++----
>  drivers/media/platform/vsp1/vsp1_video.c | 31 ++++++++++++++++++++++++-
>  drivers/media/platform/vsp1/vsp1_video.h |  5 +++-
>  3 files changed, 69 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> b/drivers/media/platform/vsp1/vsp1_drv.c index 913485a..b6e9cbc 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -1,7 +1,7 @@
>  /*
>   * vsp1_drv.c  --  R-Car VSP1 Driver
>   *
> - * Copyright (C) 2013-2014 Renesas Electronics Corporation
> + * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
>   *
> @@ -397,26 +397,57 @@ void vsp1_device_put(struct vsp1_device *vsp1)
>  static int vsp1_pm_suspend(struct device *dev)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> +	unsigned int i = 0;

There's no need to initialize i to 0 here, the for loop takes care of it.

> +	int ret = 0;
> 
>  	WARN_ON(mutex_is_locked(&vsp1->lock));
> 
>  	if (vsp1->ref_count == 0)
>  		return 0;
> 
> +	/* Suspend pipeline */
> +	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
> +		struct vsp1_rwpf *wpf = vsp1->wpf[i];
> +		struct vsp1_pipeline *pipe;
> +
> +		if (wpf == NULL)
> +			continue;
> +
> +		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
> +		ret = vsp1_pipeline_suspend(pipe);
> +		if (ret < 0)
> +			break;
> +	}

This will stop all running pipelines sequentially, which would increase the 
system suspend time quite a bit if all pipelines are running. I would instead 
first set the state of all pipelines to VSP1_PIPELINE_STOPPING in one loop, 
and then loop over all pipelines again to wait for them to finish. Something 
like

	/* To avoid increasing the system suspend time needlessly, loop over the
	 * pipelines twice, first to set them all to the stopping state, and then
	 * to wait for the stop to complete.
	 */
	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
		struct vsp1_rwpf *wpf = vsp1->wpf[i];
		struct vsp1_pipeline *pipe;

		if (wpf == NULL)
			continue;

		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
		if (pipe == NULL)
			continue;

		spin_lock_irqsave(&pipe->irqlock, flags);
		if (pipe->state == VSP1_PIPELINE_RUNNING)
			pipe->state = VSP1_PIPELINE_STOPPING;
		spin_unlock_irqrestore(&pipe->irqlock, flags);
	}

	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
		struct vsp1_rwpf *wpf = vsp1->wpf[i];
		struct vsp1_pipeline *pipe;

		if (wpf == NULL)
			continue;

		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
		if (pipe == NULL)
			continue;

		ret = wait_event_timeout(pipe->wq,
				pipe->state == VSP1_PIPELINE_STOPPED,
                  msecs_to_jiffies(500));
		if (ret == 0)
			dev_warn(vsp1->dev, "pipeline stop timeout\n");
	}

You could move all that code to a vsp1_pipelines_suspend() function in 
vsp1_video.c.

I've only printed a warning message instead of returning an error in case the 
pipeline fails to stop, as I believe it shouldn't prevent the system from 
entering suspend.

> +
>  	clk_disable_unprepare(vsp1->clock);
> -	return 0;
> +	return ret;
>  }
> 
>  static int vsp1_pm_resume(struct device *dev)
>  {
>  	struct vsp1_device *vsp1 = dev_get_drvdata(dev);
> +	unsigned int i = 0;

There's no need to initialize i to 0 here either.

>  	WARN_ON(mutex_is_locked(&vsp1->lock));
> 
> -	if (vsp1->ref_count)
> +	if (vsp1->ref_count == 0)
>  		return 0;
> 
> -	return clk_prepare_enable(vsp1->clock);
> +	clk_prepare_enable(vsp1->clock);
> +
> +	/* Resume pipeline */
> +	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
> +		struct vsp1_rwpf *wpf = vsp1->wpf[i];
> +		struct vsp1_pipeline *pipe;
> +
> +		if (wpf == NULL)
> +			continue;
> +
> +		pipe = to_vsp1_pipeline(&wpf->entity.subdev.entity);
> +		vsp1_pipeline_resume(pipe);
> +	}

If you move the suspend code to a vsp1_pipelines_suspend() function, I believe 
it would make sense to move that loop to a vsp1_pipelines_resume() function as 
well. I would then just move to code from vsp1_pipeline_resume() inside the 
loop.

Would you like to submit a new version of this patch (split in two) ? I can 
also perform the modifications myself if you prefer.

> +
> +	return 0;
>  }
>  #endif
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index d91f19a..c744608 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -1,7 +1,7 @@
>  /*
>   * vsp1_video.c  --  R-Car VSP1 Video Node
>   *
> - * Copyright (C) 2013-2014 Renesas Electronics Corporation
> + * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
>   *
> @@ -662,6 +662,35 @@ done:
>  	spin_unlock_irqrestore(&pipe->irqlock, flags);
>  }
> 
> +int vsp1_pipeline_suspend(struct vsp1_pipeline *pipe)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	if (pipe == NULL)
> +		return 0;
> +
> +	spin_lock_irqsave(&pipe->irqlock, flags);
> +	if (pipe->state == VSP1_PIPELINE_RUNNING)
> +		pipe->state = VSP1_PIPELINE_STOPPING;
> +	spin_unlock_irqrestore(&pipe->irqlock, flags);
> +
> +	ret = wait_event_timeout(pipe->wq, pipe->state == VSP1_PIPELINE_STOPPED,
> +				 msecs_to_jiffies(500));
> +	ret = ret == 0 ? -ETIMEDOUT : 0;
> +
> +	return ret;
> +}
> +
> +void vsp1_pipeline_resume(struct vsp1_pipeline *pipe)
> +{
> +	if (pipe == NULL)
> +		return;
> +
> +	if (vsp1_pipeline_ready(pipe))
> +		vsp1_pipeline_run(pipe);
> +}
> +
>  /*
>   * Propagate the alpha value through the pipeline.
>   *
> diff --git a/drivers/media/platform/vsp1/vsp1_video.h
> b/drivers/media/platform/vsp1/vsp1_video.h index fd2851a..958a166 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.h
> +++ b/drivers/media/platform/vsp1/vsp1_video.h
> @@ -1,7 +1,7 @@
>  /*
>   * vsp1_video.h  --  R-Car VSP1 Video Node
>   *
> - * Copyright (C) 2013-2014 Renesas Electronics Corporation
> + * Copyright (C) 2013-2015 Renesas Electronics Corporation
>   *
>   * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
>   *
> @@ -149,4 +149,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline
> *pipe, struct vsp1_entity *input,
>  				   unsigned int alpha);
> 
> +int vsp1_pipeline_suspend(struct vsp1_pipeline *pipe);
> +void vsp1_pipeline_resume(struct vsp1_pipeline *pipe);
> +
>  #endif /* __VSP1_VIDEO_H__ */

-- 
Regards,

Laurent Pinchart

