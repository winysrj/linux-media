Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:52575 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752885AbeGBI24 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 04:28:56 -0400
Subject: Re: [PATCH v4 03/17] omap4iss: Add vb2_queue lock
To: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com
References: <20180615190737.24139-1-ezequiel@collabora.com>
 <20180615190737.24139-4-ezequiel@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <73b3a8aa-90c9-9bba-92df-b243a394f6bb@xs4all.nl>
Date: Mon, 2 Jul 2018 10:28:54 +0200
MIME-Version: 1.0
In-Reply-To: <20180615190737.24139-4-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/06/18 21:07, Ezequiel Garcia wrote:
> vb2_queue lock is now mandatory. Add it, remove driver ad-hoc
> locks, and implement wait_{prepare, finish}.

I don't see any wait_prepare/finish implementation?!

Regards,

	Hans

> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/staging/media/omap4iss/iss_video.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
> index a3a83424a926..d919bae83828 100644
> --- a/drivers/staging/media/omap4iss/iss_video.c
> +++ b/drivers/staging/media/omap4iss/iss_video.c
> @@ -873,8 +873,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	if (type != video->type)
>  		return -EINVAL;
>  
> -	mutex_lock(&video->stream_lock);
> -
>  	/*
>  	 * Start streaming on the pipeline. No link touching an entity in the
>  	 * pipeline can be activated or deactivated once streaming is started.
> @@ -978,8 +976,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  
>  	media_graph_walk_cleanup(&graph);
>  
> -	mutex_unlock(&video->stream_lock);
> -
>  	return 0;
>  
>  err_omap4iss_set_stream:
> @@ -996,8 +992,6 @@ iss_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  err_graph_walk_init:
>  	media_entity_enum_cleanup(&pipe->ent_enum);
>  
> -	mutex_unlock(&video->stream_lock);
> -
>  	return ret;
>  }
>  
> @@ -1013,10 +1007,8 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
>  	if (type != video->type)
>  		return -EINVAL;
>  
> -	mutex_lock(&video->stream_lock);
> -
>  	if (!vb2_is_streaming(&vfh->queue))
> -		goto done;
> +		return 0;
>  
>  	/* Update the pipeline state. */
>  	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> @@ -1041,8 +1033,6 @@ iss_video_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
>  		video->iss->pdata->set_constraints(video->iss, false);
>  	media_pipeline_stop(&video->video.entity);
>  
> -done:
> -	mutex_unlock(&video->stream_lock);
>  	return 0;
>  }
>  
> @@ -1137,6 +1127,7 @@ static int iss_video_open(struct file *file)
>  	q->buf_struct_size = sizeof(struct iss_buffer);
>  	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>  	q->dev = video->iss->dev;
> +	q->lock = &video->stream_lock;
>  
>  	ret = vb2_queue_init(q);
>  	if (ret) {
> 
