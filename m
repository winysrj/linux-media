Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44747 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2DFNfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 09:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com
Subject: Re: [PATCH 09/11] v4l: vb2: add prepare/finish callbacks to allocators
Date: Fri, 06 Apr 2012 15:35:43 +0200
Message-ID: <1711774.L4gqngXBGP@avalon>
In-Reply-To: <1333634408-4960-10-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com> <1333634408-4960-10-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 05 April 2012 16:00:06 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> This patch adds support for prepare/finish callbacks in VB2 allocators.
> These callback are used for buffer flushing.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/videobuf2-core.c |   11 +++++++++++
>  include/media/videobuf2-core.h       |    7 +++++++
>  2 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c index b37feea..abb0592 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -834,6 +834,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum
> vb2_buffer_state state) {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
> +	int plane;

Please make plane an unsigned int, otherwise you will compare a signed and an 
unsigned int below.

> 
>  	if (vb->state != VB2_BUF_STATE_ACTIVE)
>  		return;
> @@ -844,6 +845,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum
> vb2_buffer_state state) dprintk(4, "Done processing on buffer %d, state:
> %d\n",
>  			vb->v4l2_buf.index, vb->state);
> 
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, finish, vb->planes[plane].mem_priv);
> +
>  	/* Add the buffer to the done buffers list */
>  	spin_lock_irqsave(&q->done_lock, flags);
>  	vb->state = state;
> @@ -1131,9 +1136,15 @@ err:
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	int plane;

Same here.

>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->queued_count);
> +
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, prepare, vb->planes[plane].mem_priv);
> +
>  	q->ops->buf_queue(vb);
>  }

-- 
Regards,

Laurent Pinchart

