Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2639 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2JEIXL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 04:23:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 09/25] v4l: vb2: add prepare/finish callbacks to allocators
Date: Fri, 5 Oct 2012 10:22:24 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-10-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349188056-4886-10-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051022.24107.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some small typos...

On Tue October 2 2012 16:27:20 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> This patch adds support for prepare/finish callbacks in VB2 allocators. These
> callback are used for buffer flushing.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/videobuf2-core.c |   11 +++++++++++
>  include/media/videobuf2-core.h       |    7 +++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index 901bc56..05da3b4 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -844,6 +844,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
> +	unsigned int plane;
>  
>  	if (vb->state != VB2_BUF_STATE_ACTIVE)
>  		return;
> @@ -854,6 +855,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	dprintk(4, "Done processing on buffer %d, state: %d\n",
>  			vb->v4l2_buf.index, vb->state);
>  
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, finish, vb->planes[plane].mem_priv);
> +
>  	/* Add the buffer to the done buffers list */
>  	spin_lock_irqsave(&q->done_lock, flags);
>  	vb->state = state;
> @@ -1148,9 +1153,15 @@ err:
>  static void __enqueue_in_driver(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	unsigned int plane;
>  
>  	vb->state = VB2_BUF_STATE_ACTIVE;
>  	atomic_inc(&q->queued_count);
> +
> +	/* sync buffers */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		call_memop(q, prepare, vb->planes[plane].mem_priv);
> +
>  	q->ops->buf_queue(vb);
>  }
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 84f11f2..c306fec 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -56,6 +56,10 @@ struct vb2_fileio_data;
>   *		dmabuf
>   * @unmap_dmabuf: releases access control to the dmabuf - allocator is notified
>   *		  that this driver is done using the dmabuf for now
> + * @prepare:	called everytime the buffer is passed from userspace to the
> + *		driver, usefull for cache synchronisation, optional

everytime -> every time
usefull -> useful

> + * @finish:	called everytime the buffer is passed back from the driver

everytime -> every time

> + *		to the userspace, also optional
>   * @vaddr:	return a kernel virtual address to a given memory buffer
>   *		associated with the passed private structure or NULL if no
>   *		such mapping exists
> @@ -82,6 +86,9 @@ struct vb2_mem_ops {
>  					unsigned long size, int write);
>  	void		(*put_userptr)(void *buf_priv);
>  
> +	void		(*prepare)(void *buf_priv);
> +	void		(*finish)(void *buf_priv);
> +
>  	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
>  				unsigned long size, int write);
>  	void		(*detach_dmabuf)(void *buf_priv);
> 
