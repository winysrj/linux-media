Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52794 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934269AbcKWM2U (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Nov 2016 07:28:20 -0500
Subject: Re: [PATCH] v4l: vsp1: Prevent commencing pipelines before they are
 setup
To: laurent.pinchart@ideasonboard.com
References: <1478860318-14792-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <ac4eeacc-4211-830b-8b70-2cc88d03f01c@ideasonboard.com>
Date: Wed, 23 Nov 2016 12:28:15 +0000
MIME-Version: 1.0
In-Reply-To: <1478860318-14792-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just FYI,

Whilst this patch is functional on its own, it is likely to be
superseded before it gets a chance to be integrated as I am currently
reworking vsp1_video_start_streaming(), in particular the use of
vsp1_video_setup_pipeline().

The re-work will of course also consider and tackle the issue repaired here.

--
Regards

Kieran

On 11/11/16 10:31, Kieran Bingham wrote:
> With multiple inputs through the BRU it is feasible for the streams to
> race each other at stream-on. In the case of the video pipelines, this
> can present two serious issues.
> 
>  1) A null-dereference if the pipe->dl is committed at the same time as
>     the vsp1_video_setup_pipeline() is processing
> 
>  2) A hardware hang, where a display list is committed without having
>     called vsp1_video_setup_pipeline() first.
> 
> To prevent these scenarios from occurring, we ensure that only the thread
> that calls the vsp1_video_setup_pipeline() is capable of committing and
> commencing the display list.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> ---
> 
> I considered a few options to fix this issue. If anyone disagrees with my
> reasoning, and believes one of the below approaches should be used, let me
> know and I'll rework the patch.
> 
>  A) Moving the vsp1_video_pipeline_run() call into the upper if block.
>   - This changes the locking, and brings in unneccessary nested locking
> 
>  B) Adapting vsp1_pipeline_ready() such that it checks for a configured
>     pipeline event as well.
> 
>   - This was tempting - but this particular issue is local to this
>     function only. Changing vsp1_pipeline_ready() to watch for a flag
>     set by vsp1_video_setup_pipeline() would require adding unneccessary
>     changes to the vsp1_drm objects to cater for this.
> 
> To test this race, I have used the vsp-unit-test-0007.sh from Laurent's
> VSP-Tests [0] in iteration. Without this patch, failures can be seen be
> seen anywhere up to the 150 iterations mark.
> 
> With this patch in place, tests have successfully iterated over 1500
> loops.
> 
> The function affected by this change appears to have been around since
> v4.6-rc2-105-g351bbf99f245 and thus may want inclusion in stable trees
> from that point forward. The issue may have been prevalent before that
> but the solution would need reworking for earlier version.
> 
> [0] http://git.ideasonboard.com/renesas/vsp-tests.git
> 
>  drivers/media/platform/vsp1/vsp1_video.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> index 94b428596c4f..cc44b27f3e47 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -813,6 +813,7 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);
>  	struct vsp1_pipeline *pipe = video->rwpf->pipe;
>  	unsigned long flags;
> +	bool configured = false;
>  	int ret;
>  
>  	mutex_lock(&pipe->lock);
> @@ -822,13 +823,20 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
>  			mutex_unlock(&pipe->lock);
>  			return ret;
>  		}
> +
> +		/*
> +		 * Multiple streams will execute this function in parallel.
> +		 * Only the thread which configures the pipeline is allowed to
> +		 * execute the vsp1_video_pipeline_run() call below
> +		 */
> +		configured = true;
>  	}
>  
>  	pipe->stream_count++;
>  	mutex_unlock(&pipe->lock);
>  
>  	spin_lock_irqsave(&pipe->irqlock, flags);
> -	if (vsp1_pipeline_ready(pipe))
> +	if (vsp1_pipeline_ready(pipe) && configured)
>  		vsp1_video_pipeline_run(pipe);
>  	spin_unlock_irqrestore(&pipe->irqlock, flags);
>  
> 
