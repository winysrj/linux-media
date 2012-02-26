Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:60938 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab2BZBJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Feb 2012 20:09:27 -0500
Message-ID: <4F49862A.4060302@iki.fi>
Date: Sun, 26 Feb 2012 03:08:58 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 22/33] omap3isp: Assume media_entity_pipeline_start
 may fail
References: <20120220015605.GI7784@valkosipuli.localdomain> <1329703032-31314-22-git-send-email-sakari.ailus@iki.fi> <2545266.6oAz1XvV7f@avalon>
In-Reply-To: <2545266.6oAz1XvV7f@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Thanks for the patch.

Thanks for the comments.

> On Monday 20 February 2012 03:57:01 Sakari Ailus wrote:
>> Since media_entity_pipeline_start() now does link validation, it may
>> actually fail. Perform the error handling.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>  drivers/media/video/omap3isp/ispvideo.c |   20 ++++++++++++--------
>>  1 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/video/omap3isp/ispvideo.c
>> b/drivers/media/video/omap3isp/ispvideo.c index c191f13..17522db 100644
>> --- a/drivers/media/video/omap3isp/ispvideo.c
>> +++ b/drivers/media/video/omap3isp/ispvideo.c
>> @@ -993,14 +993,16 @@ isp_video_streamon(struct file *file, void *fh, enum
>> v4l2_buf_type type) */
>>  	pipe = video->video.entity.pipe
>>  	     ? to_isp_pipeline(&video->video.entity) : &video->pipe;
>> -	media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
>> +	ret = media_entity_pipeline_start(&video->video.entity, &pipe->pipe);
>> +	if (ret < 0)
>> +		goto err_media_entity_pipeline_start;
>>
>>  	/* Verify that the currently configured format matches the output of
>>  	 * the connected subdev.
>>  	 */
>>  	ret = isp_video_check_format(video, vfh);
>>  	if (ret < 0)
>> -		goto error;
>> +		goto err_isp_video_check_format;
>>
>>  	video->bpl_padding = ret;
>>  	video->bpl_value = vfh->format.fmt.pix.bytesperline;
>> @@ -1017,7 +1019,7 @@ isp_video_streamon(struct file *file, void *fh, enum
>> v4l2_buf_type type) } else {
>>  		if (far_end == NULL) {
>>  			ret = -EPIPE;
>> -			goto error;
>> +			goto err_isp_video_check_format;
>>  		}
>>
>>  		state = ISP_PIPELINE_STREAM_INPUT | ISP_PIPELINE_IDLE_INPUT;
>> @@ -1032,7 +1034,7 @@ isp_video_streamon(struct file *file, void *fh, enum
>> v4l2_buf_type type) /* Validate the pipeline and update its state. */
>>  	ret = isp_video_validate_pipeline(pipe);
>>  	if (ret < 0)
>> -		goto error;
>> +		goto err_isp_video_check_format;
>>
>>  	pipe->error = false;
>>
>> @@ -1054,7 +1056,7 @@ isp_video_streamon(struct file *file, void *fh, enum
>> v4l2_buf_type type)
>>
>>  	ret = omap3isp_video_queue_streamon(&vfh->queue);
>>  	if (ret < 0)
>> -		goto error;
>> +		goto err_isp_video_check_format;
>>
>>  	/* In sensor-to-memory mode, the stream can be started synchronously
>>  	 * to the stream on command. In memory-to-memory mode, it will be
>> @@ -1064,19 +1066,21 @@ isp_video_streamon(struct file *file, void *fh, enum
>> v4l2_buf_type type) ret = omap3isp_pipeline_set_stream(pipe,
>>  					      ISP_PIPELINE_STREAM_CONTINUOUS);
>>  		if (ret < 0)
>> -			goto error;
>> +			goto err_omap3isp_set_stream;
>>  		spin_lock_irqsave(&video->queue->irqlock, flags);
>>  		if (list_empty(&video->dmaqueue))
>>  			video->dmaqueue_flags |= ISP_VIDEO_DMAQUEUE_UNDERRUN;
>>  		spin_unlock_irqrestore(&video->queue->irqlock, flags);
>>  	}
>>
>> -error:
>>  	if (ret < 0) {
>> +err_omap3isp_set_stream:
>>  		omap3isp_video_queue_streamoff(&vfh->queue);
>> +err_isp_video_check_format:
>> +		media_entity_pipeline_stop(&video->video.entity);
>> +err_media_entity_pipeline_start:
>>  		if (video->isp->pdata->set_constraints)
>>  			video->isp->pdata->set_constraints(video->isp, false);
>> -		media_entity_pipeline_stop(&video->video.entity);
>>  		/* The DMA queue must be emptied here, otherwise CCDC interrupts
>>  		 * that will get triggered the next time the CCDC is powered up
>>  		 * will try to access buffers that might have been freed but
> 
> As you add error labels, you can remove the if (ret < 0) test and move error 
> handling to a separate block. set_constraint() should be called before 
> media_entity_pipeline_stop() in that case. Another option is to leave error 
> handling untouched, and to return directly when media_entity_pipeline_start() 
> fails (after unlocking the mutex of course).

I've added separate error handling part and moved the constraint
settings patch before this one.

-- 
Sakari Ailus
sakari.ailus@iki.fi
