Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58624
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751722AbdF3LPY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 07:15:24 -0400
Date: Fri, 30 Jun 2017 08:15:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 02/12] [media] vb2: split out queueing from
 vb_core_qbuf()
Message-ID: <20170630081448.4a8780a9@vento.lan>
In-Reply-To: <20170616073915.5027-3-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
        <20170616073915.5027-3-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 16:39:05 +0900
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> In order to support explicit synchronization we need to divide
> vb2_core_qbuf() in two parts, one to be executed before the fence
> signals and another one to do the actual queueing of the buffer.

Looks good to me.


Acked-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 51 ++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 3107e21..ea83126 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1367,6 +1367,34 @@ static int vb2_start_streaming(struct vb2_queue *q)
>  	return ret;
>  }
>  
> +static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
> +{
> +	int ret;
> +
> +	/*
> +	 * If already streaming, give the buffer to driver for processing.
> +	 * If not, the buffer will be given to driver on next streamon.
> +	 */
> +	if (q->start_streaming_called)
> +		__enqueue_in_driver(vb);
> +
> +	/*
> +	 * If streamon has been called, and we haven't yet called
> +	 * start_streaming() since not enough buffers were queued, and
> +	 * we now have reached the minimum number of queued buffers,
> +	 * then we can finally call start_streaming().
> +	 */
> +	if (q->streaming && !q->start_streaming_called &&
> +	    q->queued_count >= q->min_buffers_needed) {
> +		ret = vb2_start_streaming(q);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
> +	return 0;
> +}
> +
>  int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  {
>  	struct vb2_buffer *vb;
> @@ -1404,32 +1432,11 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  
>  	trace_vb2_qbuf(q, vb);
>  
> -	/*
> -	 * If already streaming, give the buffer to driver for processing.
> -	 * If not, the buffer will be given to driver on next streamon.
> -	 */
> -	if (q->start_streaming_called)
> -		__enqueue_in_driver(vb);
> -
>  	/* Fill buffer information for the userspace */
>  	if (pb)
>  		call_void_bufop(q, fill_user_buffer, vb, pb);
>  
> -	/*
> -	 * If streamon has been called, and we haven't yet called
> -	 * start_streaming() since not enough buffers were queued, and
> -	 * we now have reached the minimum number of queued buffers,
> -	 * then we can finally call start_streaming().
> -	 */
> -	if (q->streaming && !q->start_streaming_called &&
> -	    q->queued_count >= q->min_buffers_needed) {
> -		ret = vb2_start_streaming(q);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
> -	return 0;
> +	return __vb2_core_qbuf(vb, q);
>  }
>  EXPORT_SYMBOL_GPL(vb2_core_qbuf);
>  


-- 
Thanks,
Mauro
