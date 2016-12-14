Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44505 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753753AbcLNQaz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 11:30:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCHv3 2/4] v4l: vsp1: Refactor video pipeline configuration
Date: Wed, 14 Dec 2016 18:30:17 +0200
Message-ID: <4767731.yfAkbfDzfC@avalon>
In-Reply-To: <1481651984-7687-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com> <1481651984-7687-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Tuesday 13 Dec 2016 17:59:42 Kieran Bingham wrote:
> With multiple inputs through the BRU it is feasible for the streams to
> race each other at stream-on.

Could you please explain the race condition in the commit message ? The issue 
is that multiple VIDIOC_STREAMON calls racing each other could have process 
N-1 skipping over the pipeline setup section and then start the pipeline, if 
videobuf2 has already enqueued buffers to the driver for process N but not 
called the .start_streaming() operation yet.

> In the case of the video pipelines, this
> can present two serious issues.
> 
>  1) A null-dereference if the pipe->dl is committed at the same time as
>     the vsp1_video_setup_pipeline() is processing
> 
>  2) A hardware hang, where a display list is committed without having
>     called vsp1_video_setup_pipeline() first
> 
> Along side these race conditions, the work done by
> vsp1_video_setup_pipeline() is undone by the re-initialisation during a
> suspend resume cycle, and an active pipeline does not attempt to
> reconfigure the correct routing and init parameters for the entities.
> 
> To repair all of these issues, we can move the call to a conditional
> inside vsp1_video_pipeline_run() and ensure that this can only be called
> on the last stream which calls into vsp1_video_start_streaming()
> 
> As a convenient side effect of this, by specifying that the
> configuration has been lost during suspend/resume actions - the
> vsp1_video_pipeline_run() call can re-initialise pipelines when
> necessary thus repairing resume actions for active m2m pipelines.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> ---
> v3:
>  - Move 'flag reset' to be inside the vsp1_reset_wpf() function call
>  - Tidy up the wpf->pipe reference for the configured flag
> 
>  drivers/media/platform/vsp1/vsp1_drv.c   |  4 ++++
>  drivers/media/platform/vsp1/vsp1_pipe.c  |  1 +
>  drivers/media/platform/vsp1/vsp1_pipe.h  |  2 ++
>  drivers/media/platform/vsp1/vsp1_video.c | 20 +++++++++-----------
>  4 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
> b/drivers/media/platform/vsp1/vsp1_drv.c index 57c713a4e1df..1dc3726c4e83
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -413,6 +413,7 @@ static int vsp1_create_entities(struct vsp1_device
> *vsp1)
> 
>  int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
>  {
> +	struct vsp1_rwpf *wpf = vsp1->wpf[index];
>  	unsigned int timeout;
>  	u32 status;
> 
> @@ -429,6 +430,9 @@ int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned
> int index) usleep_range(1000, 2000);
>  	}
> 
> +	if (wpf->pipe)
> +		wpf->pipe->configured = false;
> +
>  	if (!timeout) {
>  		dev_err(vsp1->dev, "failed to reset wpf.%u\n", index);
>  		return -ETIMEDOUT;
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
> b/drivers/media/platform/vsp1/vsp1_pipe.c index 756ca4ea7668..7ddf862ee403
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
> @@ -208,6 +208,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
> 
>  	INIT_LIST_HEAD(&pipe->entities);
>  	pipe->state = VSP1_PIPELINE_STOPPED;
> +	pipe->configured = false;
>  }
> 
>  /* Must be called with the pipe irqlock held. */
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
> b/drivers/media/platform/vsp1/vsp1_pipe.h index ac4ad2655551..0743b9fcb655
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -61,6 +61,7 @@ enum vsp1_pipeline_state {
>   * @pipe: the media pipeline
>   * @irqlock: protects the pipeline state
>   * @state: current state
> + * @configured: determines routing configuration active on cell.

I'm not sure to understand that. How about "true if the pipeline has been set 
up" ? Or maybe "true if the pipeline has been set up for video streaming" as 
it only applies to pipelines handled through the V4L2 API ?

>   * @wq: wait queue to wait for state change completion
>   * @frame_end: frame end interrupt handler
>   * @lock: protects the pipeline use count and stream count
> @@ -86,6 +87,7 @@ struct vsp1_pipeline {
> 
>  	spinlock_t irqlock;
>  	enum vsp1_pipeline_state state;
> +	bool configured;
>  	wait_queue_head_t wq;
> 
>  	void (*frame_end)(struct vsp1_pipeline *pipe);
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index 44b687c0b8df..7ff9f4c19ff0
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -388,6 +388,8 @@ static int vsp1_video_setup_pipeline(struct
> vsp1_pipeline *pipe) VSP1_ENTITY_PARAMS_INIT);
>  	}
> 
> +	pipe->configured = true;
> +
>  	return 0;
>  }
> 
> @@ -411,6 +413,9 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline
> *pipe) struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
>  	struct vsp1_entity *entity;
> 
> +	if (!pipe->configured)
> +		vsp1_video_setup_pipeline(pipe);
> +

I don't like this much. The vsp1_video_pipeline_run() is called with a 
spinlock held. We should avoid operations as time consuming as 
vsp1_video_setup_pipeline() here.

>  	if (!pipe->dl)
>  		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
> 
> @@ -793,25 +798,18 @@ static int vsp1_video_start_streaming(struct vb2_queue
> *vq, unsigned int count) struct vsp1_video *video = vb2_get_drv_priv(vq);
>  	struct vsp1_pipeline *pipe = video->rwpf->pipe;
>  	unsigned long flags;
> -	int ret;
> 
>  	mutex_lock(&pipe->lock);
>  	if (pipe->stream_count == pipe->num_inputs) {
> -		ret = vsp1_video_setup_pipeline(pipe);
> -		if (ret < 0) {
> -			mutex_unlock(&pipe->lock);
> -			return ret;
> -		}
> +		spin_lock_irqsave(&pipe->irqlock, flags);
> +		if (vsp1_pipeline_ready(pipe))
> +			vsp1_video_pipeline_run(pipe);
> +		spin_unlock_irqrestore(&pipe->irqlock, flags);
>  	}
> 
>  	pipe->stream_count++;
>  	mutex_unlock(&pipe->lock);
> 
> -	spin_lock_irqsave(&pipe->irqlock, flags);
> -	if (vsp1_pipeline_ready(pipe))
> -		vsp1_video_pipeline_run(pipe);
> -	spin_unlock_irqrestore(&pipe->irqlock, flags);
> -

How about the following ?

	bool start_pipeline = false;

 	mutex_lock(&pipe->lock);
 	if (pipe->stream_count == pipe->num_inputs) {
		ret = vsp1_video_setup_pipeline(pipe);
		if (ret < 0) {
			mutex_unlock(&pipe->lock);
			return ret;
		}

		start_pipeline = true;
 	}

 	pipe->stream_count++;
 	mutex_unlock(&pipe->lock);

	/*
	 * Don't attempt to start the pipeline if we haven't configured it
	 * explicitly, as otherwise multiple streamon calls could race each
	 * other and one of them try to start the pipeline unconfigured.
	 */
	if (!start_pipeline)
		return 0;

	spin_lock_irqsave(&pipe->irqlock, flags);
	if (vsp1_pipeline_ready(pipe))
		vsp1_video_pipeline_run(pipe);
	spin_unlock_irqrestore(&pipe->irqlock, flags);


This won't fix the suspend/resume issue, but I think splitting that to a 
separate patch would be a good idea anyway.

I'm also wondering whether we could have a streamon/suspend race. If the 
pipeline is setup and the DL allocated but not committed at suspend time I 
think we'll leak the DL at resume time.

>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart

