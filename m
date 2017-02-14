Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48964 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdBNAZK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 19:25:10 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/4] v4l: vsp1: Prevent multiple streamon race commencing pipeline early
Date: Tue, 14 Feb 2017 02:25:34 +0200
Message-ID: <2882411.slzxzAmkTH@avalon>
In-Reply-To: <d510ad628ee135c12e7b5050ddd5606e573cf01a.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.4df11e0fa078e5cc8bc8f668951249cca0fd3d7f.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com> <d510ad628ee135c12e7b5050ddd5606e573cf01a.1483704413.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

Thank you for the patch.

On Friday 06 Jan 2017 12:15:28 Kieran Bingham wrote:
> With multiple inputs through the BRU it is feasible for the streams to
> race each other at stream-on.
> 
> Multiple VIDIOC_STREAMON calls racing each other could have process
> N-1 skipping over the pipeline setup section and then start the pipeline
> early, if videobuf2 has already enqueued buffers to the driver for
> process N but not called the .start_streaming() operation yet
> 
> In the case of the video pipelines, this
> can present two serious issues.
> 
>  1) A null-dereference if the pipe->dl is committed at the same time as
>     the vsp1_video_setup_pipeline() is processing
> 
>  2) A hardware hang, where a display list is committed without having
>     called vsp1_video_setup_pipeline() first
> 
> Repair this issue, by ensuring that only the stream which configures the
> pipeline is able to start it.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> 
> ---
> 
> v4:
>  - Revert and rework back to v1 implementation style
>  - Provide detailed comments on the race
> 
> v3:
>  - Move 'flag reset' to be inside the vsp1_reset_wpf() function call
>  - Tidy up the wpf->pipe reference for the configured flag
> 
> To test this race, I have used the vsp-unit-test-0007.sh from Laurent's
> VSP-Tests [0] in iteration. Without this patch, failures can be seen be
> seen anywhere up to the 150 iterations mark.
> 
> With this patch in place, tests have successfully iterated over 1500
> loops.
> 
> The function affected by this change appears to have been around since
> v4.6-rc2-105-g351bbf99f245 and thus could be included in stable trees
> from that point forward. The issue may have been prevalent before that
> but the solution would need reworking for earlier version.
> 
> [0] http://git.ideasonboard.com/renesas/vsp-tests.git
> ---
>  drivers/media/platform/vsp1/vsp1_video.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
> b/drivers/media/platform/vsp1/vsp1_video.c index e6592b576ca3..f7dc249eb398
> 100644
> --- a/drivers/media/platform/vsp1/vsp1_video.c
> +++ b/drivers/media/platform/vsp1/vsp1_video.c
> @@ -797,6 +797,7 @@ static int vsp1_video_start_streaming(struct vb2_queue
> *vq, unsigned int count) {
>  	struct vsp1_video *video = vb2_get_drv_priv(vq);
>  	struct vsp1_pipeline *pipe = video->rwpf->pipe;
> +	bool start_pipeline = false;
>  	unsigned long flags;
>  	int ret;
> 
> @@ -807,11 +808,23 @@ static int vsp1_video_start_streaming(struct vb2_queue
> *vq, unsigned int count) mutex_unlock(&pipe->lock);
>  			return ret;
>  		}
> +
> +		start_pipeline = true;
>  	}
> 
>  	pipe->stream_count++;
>  	mutex_unlock(&pipe->lock);
> 
> +	/*
> +	 * vsp1_pipeline_ready() is not sufficient to establish that all 
streams
> +	 * are prepared and the pipeline is configured, as multiple streams
> +	 * can race through streamon with buffers already queued; Therefore we
> +	 * don't even attempt to start the pipeline until the last stream has
> +	 * called through here.
> +	 */
> +	if (!start_pipeline)
> +		return 0;
> +
>  	spin_lock_irqsave(&pipe->irqlock, flags);
>  	if (vsp1_pipeline_ready(pipe))
>  		vsp1_video_pipeline_run(pipe);

-- 
Regards,

Laurent Pinchart
