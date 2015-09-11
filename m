Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:52234 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbbIKQ0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 12:26:53 -0400
Message-ID: <55F30085.504@xs4all.nl>
Date: Fri, 11 Sep 2015 18:25:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 03/11] vb2: Move cache synchronisation from buffer
 done to dqbuf handler
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> The cache synchronisation may be a time consuming operation and thus not
> best performed in an interrupt which is a typical context for
> vb2_buffer_done() calls. This may consume up to tens of ms on some
> machines, depending on the buffer size.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 64fce4d..c5c0707a 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1177,7 +1177,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
> -	unsigned int plane;
>  
>  	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>  		return;
> @@ -1197,10 +1196,6 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	dprintk(4, "done processing on buffer %d, state: %d\n",
>  			vb->v4l2_buf.index, state);
>  
> -	/* sync buffers */
> -	for (plane = 0; plane < vb->num_planes; ++plane)
> -		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> -

Ah, OK, so it is removed here,

>  	/* Add the buffer to the done buffers list */
>  	spin_lock_irqsave(&q->done_lock, flags);
>  	vb->state = state;
> @@ -2086,7 +2081,7 @@ EXPORT_SYMBOL_GPL(vb2_wait_for_all_buffers);
>  static void __vb2_dqbuf(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	unsigned int i;
> +	unsigned int plane;
>  
>  	/* nothing to do if the buffer is already dequeued */
>  	if (vb->state == VB2_BUF_STATE_DEQUEUED)
> @@ -2094,13 +2089,18 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>  
>  	vb->state = VB2_BUF_STATE_DEQUEUED;
>  
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; plane++)
> +		call_void_memop(vb, finish, vb->planes[plane].mem_priv);
> +

to here.

I'm not sure if this is correct... So __vb2_dqbuf is called from __vb2_queue_cancel(),
but now the buf_finish() callback is called *before* the memop finish() callback,
where this was the other way around in __vb2_queue_cancel(). I don't think that is
right since buf_finish() expects that the buffer is synced for the cpu.

Was this tested with CONFIG_VIDEO_ADV_DEBUG set and with 'v4l2-compliance -s'?
Not that that would help if things are done in the wrong order...

Regards,

	Hans

>  	/* unmap DMABUF buffer */
>  	if (q->memory == V4L2_MEMORY_DMABUF)
> -		for (i = 0; i < vb->num_planes; ++i) {
> -			if (!vb->planes[i].dbuf_mapped)
> +		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			if (!vb->planes[plane].dbuf_mapped)
>  				continue;
> -			call_void_memop(vb, unmap_dmabuf, vb->planes[i].mem_priv);
> -			vb->planes[i].dbuf_mapped = 0;
> +			call_void_memop(vb, unmap_dmabuf,
> +					vb->planes[plane].mem_priv);
> +			vb->planes[plane].dbuf_mapped = 0;
>  		}
>  }
>  
> 

