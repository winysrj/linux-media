Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:43920 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751747AbeERUz1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 16:55:27 -0400
Subject: Re: [PATCH v11 01/10] media: v4l: vsp1: Release buffers for each
 video node
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org
References: <cover.4fb0850a617881b465a66140fdf06941777212ae.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
 <f05e7c227e8ab1f0c5d65ccdcb92c7c20c00594a.1526675940.git-series.kieran.bingham+renesas@ideasonboard.com>
 <2666334.YPxzfcQE7O@avalon>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <ffce81c5-673d-37b3-0cda-8b97e2178616@ideasonboard.com>
Date: Fri, 18 May 2018 21:55:23 +0100
MIME-Version: 1.0
In-Reply-To: <2666334.YPxzfcQE7O@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 18/05/18 21:53, Laurent Pinchart wrote:
> Hi Kieran,
> 
> Thank you for the patch.
> 
> On Friday, 18 May 2018 23:41:54 EEST Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> Commit 372b2b0399fc ("media: v4l: vsp1: Release buffers in
>> start_streaming error path") introduced a helper to clean up buffers on
>> error paths, but inadvertently changed the code such that only the
>> output WPF buffers were cleaned, rather than the video node being
>> operated on.
>>
>> Since then vsp1_video_cleanup_pipeline() has grown to perform both video
>> node cleanup, as well as pipeline cleanup. Split the implementation into
>> two distinct functions that perform the required work, so that each
>> video node can release it's buffers correctly on streamoff. The pipe
> 
> s/it's/its/
> 
>> cleanup that was performed in the vsp1_video_stop_streaming() (releasing
>> the pipe->dl) is moved to the function for clarity.
>>
>> Fixes: 372b2b0399fc ("media: v4l: vsp1: Release buffers in start_streaming
>> error path")
>> Cc: stable@vger.kernel.org # v4.13+
> 
> Commit 372b2b0399fc was introduced in v4.14, should this be v4.14+ ?

Yes, thank you - that's me mis-interpreting my own scripts to get the version
for fixes.


>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> No need to resubmit for this, I'll fix the commit message when applying.

Great.

--
Kieran

> 
>> ---
>>  drivers/media/platform/vsp1/vsp1_video.c | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/platform/vsp1/vsp1_video.c
>> b/drivers/media/platform/vsp1/vsp1_video.c index c8c12223a267..ba89dd176a13
>> 100644
>> --- a/drivers/media/platform/vsp1/vsp1_video.c
>> +++ b/drivers/media/platform/vsp1/vsp1_video.c
>> @@ -842,9 +842,8 @@ static int vsp1_video_setup_pipeline(struct
>> vsp1_pipeline *pipe) return 0;
>>  }
>>
>> -static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
>> +static void vsp1_video_release_buffers(struct vsp1_video *video)
>>  {
>> -	struct vsp1_video *video = pipe->output->video;
>>  	struct vsp1_vb2_buffer *buffer;
>>  	unsigned long flags;
>>
>> @@ -854,12 +853,18 @@ static void vsp1_video_cleanup_pipeline(struct
>> vsp1_pipeline *pipe) vb2_buffer_done(&buffer->buf.vb2_buf,
>> VB2_BUF_STATE_ERROR);
>>  	INIT_LIST_HEAD(&video->irqqueue);
>>  	spin_unlock_irqrestore(&video->irqlock, flags);
>> +}
>> +
>> +static void vsp1_video_cleanup_pipeline(struct vsp1_pipeline *pipe)
>> +{
>> +	lockdep_assert_held(&pipe->lock);
>>
>>  	/* Release our partition table allocation */
>> -	mutex_lock(&pipe->lock);
>>  	kfree(pipe->part_table);
>>  	pipe->part_table = NULL;
>> -	mutex_unlock(&pipe->lock);
>> +
>> +	vsp1_dl_list_put(pipe->dl);
>> +	pipe->dl = NULL;
>>  }
>>
>>  static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int
>> count) @@ -874,8 +879,9 @@ static int vsp1_video_start_streaming(struct
>> vb2_queue *vq, unsigned int count) if (pipe->stream_count ==
>> pipe->num_inputs) {
>>  		ret = vsp1_video_setup_pipeline(pipe);
>>  		if (ret < 0) {
>> -			mutex_unlock(&pipe->lock);
>> +			vsp1_video_release_buffers(video);
>>  			vsp1_video_cleanup_pipeline(pipe);
>> +			mutex_unlock(&pipe->lock);
>>  			return ret;
>>  		}
>>
>> @@ -925,13 +931,12 @@ static void vsp1_video_stop_streaming(struct vb2_queue
>> *vq) if (ret == -ETIMEDOUT)
>>  			dev_err(video->vsp1->dev, "pipeline stop timeout\n");
>>
>> -		vsp1_dl_list_put(pipe->dl);
>> -		pipe->dl = NULL;
>> +		vsp1_video_cleanup_pipeline(pipe);
>>  	}
>>  	mutex_unlock(&pipe->lock);
>>
>>  	media_pipeline_stop(&video->video.entity);
>> -	vsp1_video_cleanup_pipeline(pipe);
>> +	vsp1_video_release_buffers(video);
>>  	vsp1_video_pipeline_put(pipe);
>>  }
> 
