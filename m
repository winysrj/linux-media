Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:41029 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932489AbeALL5u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 06:57:50 -0500
Subject: Re: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-2-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c11c095d-4eb2-537e-22f1-d35ff07cc3f3@xs4all.nl>
Date: Fri, 12 Jan 2018 12:57:44 +0100
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-2-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 17:07, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Explicit synchronization benefits a lot from ordered queues, they fit
> better in a pipeline with DRM for example so create a opt-in way for
> drivers notify videobuf2 that the queue is unordered.
> 
> Drivers don't need implement it if the queue is ordered.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  include/media/videobuf2-core.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f3ee4c7c2fb3..583cdc06de79 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -370,6 +370,9 @@ struct vb2_buffer {
>   *			callback by calling vb2_buffer_done() with either
>   *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
>   *			vb2_wait_for_all_buffers() function
> + * @is_unordered:	tell if the queue format is unordered. The default is

I'd replace the first sentence by this:

"tell if the queue is unordered, i.e. buffers can be dequeued in a different
order from how they were queued."

Regards,

	Hans

> + *			assumed to be ordered and this function only needs to
> + *			be implemented for unordered queues.
>   * @buf_queue:		passes buffer vb to the driver; driver may start
>   *			hardware operation on this buffer; driver should give
>   *			the buffer back by calling vb2_buffer_done() function;
> @@ -393,6 +396,7 @@ struct vb2_ops {
>  
>  	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
>  	void (*stop_streaming)(struct vb2_queue *q);
> +	int (*is_unordered)(struct vb2_queue *q);
>  
>  	void (*buf_queue)(struct vb2_buffer *vb);
>  };
> @@ -566,6 +570,7 @@ struct vb2_queue {
>  	u32				cnt_wait_finish;
>  	u32				cnt_start_streaming;
>  	u32				cnt_stop_streaming;
> +	u32				cnt_is_unordered;
>  #endif
>  };
>  
> 
