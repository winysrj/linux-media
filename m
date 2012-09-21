Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4032 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab2IUJgO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 05:36:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [PATCH 1/4] v4l: vb2: add prepare/finish callbacks to allocators
Date: Fri, 21 Sep 2012 11:36:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>
References: <1348219298-23273-1-git-send-email-federico.vaga@gmail.com>
In-Reply-To: <1348219298-23273-1-git-send-email-federico.vaga@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211136.02263.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 21 2012 11:21:35 Federico Vaga wrote:
> This patch adds support for prepare/finish callbacks in VB2 allocators.
> These callback are used for buffer flushing.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Federico Vaga <federico.vaga@gmail.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 11 +++++++++++
>  include/media/videobuf2-core.h           |  7 +++++++
>  2 file modificati, 18 inserzioni(+)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 4da3df6..079fa79 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -790,6 +790,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned long flags;
> +	unsigned int plane;
>  
>  	if (vb->state != VB2_BUF_STATE_ACTIVE)
>  		return;
> @@ -800,6 +801,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
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
> @@ -975,9 +980,15 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
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
> index 8dd9b6c..f374f99 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -41,6 +41,10 @@ struct vb2_fileio_data;
>   *		 argument to other ops in this structure
>   * @put_userptr: inform the allocator that a USERPTR buffer will no longer
>   *		 be used
> + * @prepare:	called everytime the buffer is passed from userspace to the

nitpick: everytime -> every time

> + *		driver, usefull for cache synchronisation, optional
> + * @finish:	called everytime the buffer is passed back from the driver

ditto.

> + *		to the userspace, also optional
>   * @vaddr:	return a kernel virtual address to a given memory buffer
>   *		associated with the passed private structure or NULL if no
>   *		such mapping exists
> @@ -65,6 +69,9 @@ struct vb2_mem_ops {
>  					unsigned long size, int write);
>  	void		(*put_userptr)(void *buf_priv);
>  
> +	void		(*prepare)(void *buf_priv);
> +	void		(*finish)(void *buf_priv);
> +
>  	void		*(*vaddr)(void *buf_priv);
>  	void		*(*cookie)(void *buf_priv);
>  
> 
