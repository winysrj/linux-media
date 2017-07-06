Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:35590 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752783AbdGFHqt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Jul 2017 03:46:49 -0400
Subject: Re: [PATCH 02/12] [media] vb2: split out queueing from vb_core_qbuf()
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
References: <20170616073915.5027-1-gustavo@padovan.org>
 <20170616073915.5027-3-gustavo@padovan.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8969cb24-95cc-3056-e6ad-8990801f326d@xs4all.nl>
Date: Thu, 6 Jul 2017 09:46:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170616073915.5027-3-gustavo@padovan.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/17 09:39, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> In order to support explicit synchronization we need to divide
> vb2_core_qbuf() in two parts, one to be executed before the fence
> signals and another one to do the actual queueing of the buffer.
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

This should be called *after* the __vb2_core_qbuf call. That call changes
vb->state which is used by buffer to fill in v4l2_buffer. So the order
should be swapped here to ensure we return the latest state of the buffer.

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
> 

Regards,

	Hans
