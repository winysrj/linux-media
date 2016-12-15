Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48018 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbcLOL72 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 06:59:28 -0500
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCHv3 2/4] v4l: vsp1: Refactor video pipeline configuration
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
References: <1481651984-7687-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <1481651984-7687-3-git-send-email-kieran.bingham+renesas@ideasonboard.com>
 <4767731.yfAkbfDzfC@avalon>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Message-ID: <753d4e1b-4213-7e63-bb1b-7949304c0dfa@ideasonboard.com>
Date: Thu, 15 Dec 2016 11:50:32 +0000
MIME-Version: 1.0
In-Reply-To: <4767731.yfAkbfDzfC@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 14/12/16 16:30, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Tuesday 13 Dec 2016 17:59:42 Kieran Bingham wrote:
>> With multiple inputs through the BRU it is feasible for the streams to
>> race each other at stream-on.
> 
> Could you please explain the race condition in the commit message ? The issue 
> is that multiple VIDIOC_STREAMON calls racing each other could have process 
> N-1 skipping over the pipeline setup section and then start the pipeline, if 
> videobuf2 has already enqueued buffers to the driver for process N but not 
> called the .start_streaming() operation yet.
> 
>> In the case of the video pipelines, this
>> can present two serious issues.
>>
>>  1) A null-dereference if the pipe->dl is committed at the same time as
>>     the vsp1_video_setup_pipeline() is processing
>>
>>  2) A hardware hang, where a display list is committed without having
>>     called vsp1_video_setup_pipeline() first
>>
>> Along side these race conditions, the work done by
>> vsp1_video_setup_pipeline() is undone by the re-initialisation during a
>> suspend resume cycle, and an active pipeline does not attempt to
>> reconfigure the correct routing and init parameters for the entities.
>>
>> To repair all of these issues, we can move the call to a conditional
>> inside vsp1_video_pipeline_run() and ensure that this can only be called
>> on the last stream which calls into vsp1_video_start_streaming()
>>
>> As a convenient side effect of this, by specifying that the
>> configuration has been lost during suspend/resume actions - the
>> vsp1_video_pipeline_run() call can re-initialise pipelines when
>> necessary thus repairing resume actions for active m2m pipelines.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> ---
>> v3:
>>  - Move 'flag reset' to be inside the vsp1_reset_wpf() function call
>>  - Tidy up the wpf->pipe reference for the configured flag
>>
>>  drivers/media/platform/vsp1/vsp1_drv.c   |  4 ++++
>>  drivers/media/platform/vsp1/vsp1_pipe.c  |  1 +
>>  drivers/media/platform/vsp1/vsp1_pipe.h  |  2 ++
>>  drivers/media/platform/vsp1/vsp1_video.c | 20 +++++++++-----------
>>  4 files changed, 16 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c
>> b/drivers/media/platform/vsp1/vsp1_drv.c index 57c713a4e1df..1dc3726c4e83
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_drv.c
>> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
>> @@ -413,6 +413,7 @@ static int vsp1_create_entities(struct vsp1_device
>> *vsp1)
>>
>>  int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned int index)
>>  {
>> +	struct vsp1_rwpf *wpf = vsp1->wpf[index];
>>  	unsigned int timeout;
>>  	u32 status;
>>
>> @@ -429,6 +430,9 @@ int vsp1_reset_wpf(struct vsp1_device *vsp1, unsigned
>> int index) usleep_range(1000, 2000);
>>  	}
>>
>> +	if (wpf->pipe)
>> +		wpf->pipe->configured = false;
>> +
>>  	if (!timeout) {
>>  		dev_err(vsp1->dev, "failed to reset wpf.%u\n", index);
>>  		return -ETIMEDOUT;
>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c
>> b/drivers/media/platform/vsp1/vsp1_pipe.c index 756ca4ea7668..7ddf862ee403
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_pipe.c
>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.c
>> @@ -208,6 +208,7 @@ void vsp1_pipeline_init(struct vsp1_pipeline *pipe)
>>
>>  	INIT_LIST_HEAD(&pipe->entities);
>>  	pipe->state = VSP1_PIPELINE_STOPPED;
>> +	pipe->configured = false;
>>  }
>>
>>  /* Must be called with the pipe irqlock held. */
>> diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h
>> b/drivers/media/platform/vsp1/vsp1_pipe.h index ac4ad2655551..0743b9fcb655
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_pipe.h
>> +++ b/drivers/media/platform/vsp1/vsp1_pipe.h
>> @@ -61,6 +61,7 @@ enum vsp1_pipeline_state {
>>   * @pipe: the media pipeline
>>   * @irqlock: protects the pipeline state
>>   * @state: current state
>> + * @configured: determines routing configuration active on cell.
> 
> I'm not sure to understand that. How about "true if the pipeline has been set 
> up" ? Or maybe "true if the pipeline has been set up for video streaming" as 
> it only applies to pipelines handled through the V4L2 API ?


Yes, Reading it now - I have no idea what context I was writing that in.
I hope it was late and I was tired ... otherwise I have no excuse :D



>>   * @wq: wait queue to wait for state change completion
>>   * @frame_end: frame end interrupt handler
>>   * @lock: protects the pipeline use count and stream count
>> @@ -86,6 +87,7 @@ struct vsp1_pipeline {
>>
>>  	spinlock_t irqlock;
>>  	enum vsp1_pipeline_state state;
>> +	bool configured;
>>  	wait_queue_head_t wq;
>>
>>  	void (*frame_end)(struct vsp1_pipeline *pipe);
>> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
>> b/drivers/media/platform/vsp1/vsp1_video.c index 44b687c0b8df..7ff9f4c19ff0
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_video.c
>> +++ b/drivers/media/platform/vsp1/vsp1_video.c
>> @@ -388,6 +388,8 @@ static int vsp1_video_setup_pipeline(struct
>> vsp1_pipeline *pipe) VSP1_ENTITY_PARAMS_INIT);
>>  	}
>>
>> +	pipe->configured = true;
>> +
>>  	return 0;
>>  }
>>
>> @@ -411,6 +413,9 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline
>> *pipe) struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
>>  	struct vsp1_entity *entity;
>>
>> +	if (!pipe->configured)
>> +		vsp1_video_setup_pipeline(pipe);
>> +
> 
> I don't like this much. The vsp1_video_pipeline_run() is called with a 
> spinlock held. We should avoid operations as time consuming as 
> vsp1_video_setup_pipeline() here.


I'm going to argue my case here, as I thought this was a more elegant
solution (and I really seem to dislike that poorly protected global
pipe->dl);

However I will back down quickly/happily if needed. Especially knowing
that we are trying to reduce the recalculations of the DL, and I can see
where those changes will lead us anyway.

Regardless of the outcome, I felt it was useful (at least to me) to
measure the call times on these functions to get an understanding, thus
I have used ftrace to measure/monitor a full run of the vsp-test suite:

 trace-cmd record \
        -p function_graph \
        -l 'vsp1_video_setup_pipeline' \
        -l 'vsp1_irq_handler' \
        \
        ./vsp-tests.sh

* I had to mark vsp1_video_setup_pipeline() as noinline to be able to
measure it with ftrace

A) Call frequency

Whilst vsp1_video_pipeline_run() is called for every frame, it should
only be on the first frame of each stream, (or the first frame following
a resume operation) where the flag pipe->configured == false.

 - Measuring in the entirety of the vsp-test suite,  I count 121
   calls here.
   (trace-cmd report | grep vsp1_video_setup_pipeline | wc -l)


B) Function duration

The log of each of the function durations is available at:
   http://paste.ubuntu.com/23632986/

Some quick and dirty statistical analysis shows the following duration
times for this function.

trace-cmd report \
	| grep vsp1_video_setup_pipeline \
	| sed 's/.*funcgraph_entry:\W*\([0-9]*\.[0-9]*\) us.*/\1/' \
	| st

## Numbers in uS ...
N       min     max     sum     mean    stddev
121     4.68    17.76   887.885 7.33789 2.3195


So we do hit nearly 18 uS in this function, which could be considered a
lot for interrupt context, but when it is only once at the beginning of
stream start?

(Incidentally, running the same measurements on the whole of
vsp1_irq_handler nets the following statistical results:

trace-cmd report \
	| grep vsp1_irq_handler \
	| sed 's/.*funcgraph_entry:\W*\([0-9]*\.[0-9]*\) us.*/\1/' \
	| st

N       min     max     sum     mean    stddev
12360   1.32    165.481 125934  10.1889 15.0117

Of course the coverage on the IRQ handler is more broad, and I'm not
sure how to only measure the IRQ handler calls that result in calling
vsp1_video_setup_pipeline().

Anyway, like I said - possibly a moot point anyway - but I wanted to
actually measure the function times to see what we're up against.

>>  	if (!pipe->dl)
>>  		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
>>
>> @@ -793,25 +798,18 @@ static int vsp1_video_start_streaming(struct vb2_queue
>> *vq, unsigned int count) struct vsp1_video *video = vb2_get_drv_priv(vq);
>>  	struct vsp1_pipeline *pipe = video->rwpf->pipe;
>>  	unsigned long flags;
>> -	int ret;
>>
>>  	mutex_lock(&pipe->lock);
>>  	if (pipe->stream_count == pipe->num_inputs) {
>> -		ret = vsp1_video_setup_pipeline(pipe);
>> -		if (ret < 0) {
>> -			mutex_unlock(&pipe->lock);
>> -			return ret;
>> -		}
>> +		spin_lock_irqsave(&pipe->irqlock, flags);
>> +		if (vsp1_pipeline_ready(pipe))
>> +			vsp1_video_pipeline_run(pipe);
>> +		spin_unlock_irqrestore(&pipe->irqlock, flags);
>>  	}
>>
>>  	pipe->stream_count++;
>>  	mutex_unlock(&pipe->lock);
>>
>> -	spin_lock_irqsave(&pipe->irqlock, flags);
>> -	if (vsp1_pipeline_ready(pipe))
>> -		vsp1_video_pipeline_run(pipe);
>> -	spin_unlock_irqrestore(&pipe->irqlock, flags);
>> -
> 
> How about the following ?
> 
> 	bool start_pipeline = false;
> 
>  	mutex_lock(&pipe->lock);
>  	if (pipe->stream_count == pipe->num_inputs) {
> 		ret = vsp1_video_setup_pipeline(pipe);
> 		if (ret < 0) {
> 			mutex_unlock(&pipe->lock);
> 			return ret;
> 		}
> 
> 		start_pipeline = true;
>  	}
> 
>  	pipe->stream_count++;
>  	mutex_unlock(&pipe->lock);
> 
> 	/*
> 	 * Don't attempt to start the pipeline if we haven't configured it
> 	 * explicitly, as otherwise multiple streamon calls could race each
> 	 * other and one of them try to start the pipeline unconfigured.
> 	 */
> 	if (!start_pipeline)
> 		return 0;
> 
> 	spin_lock_irqsave(&pipe->irqlock, flags);
> 	if (vsp1_pipeline_ready(pipe))
> 		vsp1_video_pipeline_run(pipe);
> 	spin_unlock_irqrestore(&pipe->irqlock, flags);

Ok, I'm happy with that, it's effectively v1 of my patchset, before I
discovered that the suspend resume issue was closely related.


> This won't fix the suspend/resume issue, but I think splitting that to a 
> separate patch would be a good idea anyway.

I'll have to look again to consider how this could be done separately.


> I'm also wondering whether we could have a streamon/suspend race. If the 
> pipeline is setup and the DL allocated but not committed at suspend time I 
> think we'll leak the DL at resume time.

If there is, then I believe I resolved this in :
 "v4l: vsp1: Use local display lists and remove global pipe->dl"

but yes, if we end up not being able to use that patch then I'll take a
look and see if there's anything more needs to be done here.


>>  	return 0;
>>  }
> 

-- 
Regards

Kieran Bingham
