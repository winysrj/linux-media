Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51439 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbcLJKFG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 05:05:06 -0500
Subject: Re: [PATCH 2/4] v4l: vsp1: Refactor video pipeline configuration
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        laurent.pinchart@ideasonboard.com
References: <1481016913-30608-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481016913-30608-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <f53ddf72-7422-9ff3-2298-d0eca4bfc3a7@ideasonboard.com>
Date: Sat, 10 Dec 2016 10:04:52 +0000
MIME-Version: 1.0
In-Reply-To: <1481016913-30608-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewing my own patch here, as I've just seen something...

On 06/12/16 09:35, Kieran Bingham wrote:
> With multiple inputs through the BRU it is feasible for the streams to
> race each other at stream-on. In the case of the video pipelines, this
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
> ---
>  drivers/media/platform/vsp1/vsp1_drv.c   |  3 +++
>  drivers/media/platform/vsp1/vsp1_pipe.c  |  1 +
>  drivers/media/platform/vsp1/vsp1_pipe.h  |  2 ++
>  drivers/media/platform/vsp1/vsp1_video.c | 20 +++++++++-----------
>  4 files changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 57c713a4e1df..dd26549a6912 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -447,6 +447,9 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
>  		ret = vsp1_reset_wpf(vsp1, i);
>  		if (ret < 0)
>  			return ret;
> +
> +		if (vsp1->wpf[i] && vsp1->wpf[i]->pipe)
> +			vsp1->wpf[i]->pipe->configured = false;

It would make a lot more sense for this to be re-set inside the
vsp1_reset_wpf() function itself, so that it is always reset in
conjunction with resetting the hardware ...

Not to mention, if the reset timesout, the reset has already been
started so the configured flag should certainly be reset.

I'll move this for a quick v2.

>  	}
>  
>  	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
> index 756ca4ea7668..7ddf862ee403 100644
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
> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
> index ac4ad2655551..0743b9fcb655 100644
> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
> @@ -61,6 +61,7 @@ enum vsp1_pipeline_state {
>   * @pipe: the media pipeline
>   * @irqlock: protects the pipeline state
>   * @state: current state
> + * @configured: determines routing configuration active on cell.
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
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 44b687c0b8df..7ff9f4c19ff0 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -388,6 +388,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
>  					       VSP1_ENTITY_PARAMS_INIT);
>  	}
>  
> +	pipe->configured = true;
> +
>  	return 0;
>  }
>  
> @@ -411,6 +413,9 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
>  	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
>  	struct vsp1_entity *entity;
>  
> +	if (!pipe->configured)
> +		vsp1_video_setup_pipeline(pipe);
> +
>  	if (!pipe->dl)
>  		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
>  
> @@ -793,25 +798,18 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);
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
>  	return 0;
>  }
>  
> 
