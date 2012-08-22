Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:5000 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2HVLnm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 07:43:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv8 19/26] v4l: vb2: add buffer exporting via dmabuf
Date: Wed, 22 Aug 2012 13:43:24 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	dmitriyz@google.com, s.nawrocki@samsung.com, k.debski@samsung.com
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-20-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1344958496-9373-20-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221343.24982.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 17:34:49 Tomasz Stanislawski wrote:
> This patch adds extension to videobuf2-core. It allow to export a mmap buffer
> as a file descriptor.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/videobuf2-core.c |   67 ++++++++++++++++++++++++++++++++++
>  include/media/videobuf2-core.h       |    2 +
>  2 files changed, 69 insertions(+)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index aed21e4..61354ec 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -1743,6 +1743,73 @@ static int __find_plane_by_offset(struct vb2_queue *q, unsigned long off,
>  }
>  
>  /**
> + * vb2_expbuf() - Export a buffer as a file descriptor
> + * @q:		videobuf2 queue
> + * @eb:		export buffer structure passed from userspace to vidioc_expbuf
> + *		handler in driver
> + *
> + * The return values from this function are intended to be directly returned
> + * from vidioc_expbuf handler in driver.
> + */
> +int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb)
> +{
> +	struct vb2_buffer *vb = NULL;
> +	struct vb2_plane *vb_plane;
> +	unsigned int buffer, plane;
> +	int ret;
> +	struct dma_buf *dbuf;
> +
> +	if (q->memory != V4L2_MEMORY_MMAP) {
> +		dprintk(1, "Queue is not currently set up for mmap\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!q->mem_ops->get_dmabuf) {
> +		dprintk(1, "Queue does not support DMA buffer exporting\n");
> +		return -EINVAL;
> +	}
> +
> +	if (eb->flags & ~O_CLOEXEC) {
> +		dprintk(1, "Queue does support only O_CLOEXEC flag\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Find the plane corresponding to the offset passed by userspace.
> +	 */
> +	ret = __find_plane_by_offset(q, eb->mem_offset, &buffer, &plane);
> +	if (ret) {
> +		dprintk(1, "invalid offset %u\n", eb->mem_offset);
> +		return ret;
> +	}
> +
> +	vb = q->bufs[buffer];
> +	vb_plane = &vb->planes[plane];
> +
> +	dbuf = call_memop(q, get_dmabuf, vb_plane->mem_priv);
> +	if (IS_ERR_OR_NULL(dbuf)) {
> +		dprintk(1, "Failed to export buffer %d, plane %d\n",
> +			buffer, plane);
> +		return -EINVAL;
> +	}
> +
> +	ret = dma_buf_fd(dbuf, eb->flags);
> +	if (ret < 0) {
> +		dprintk(3, "buffer %d, plane %d failed to export (%d)\n",
> +			buffer, plane, ret);
> +		dma_buf_put(dbuf);
> +		return ret;
> +	}
> +
> +	dprintk(3, "buffer %d, plane %d exported as %d descriptor\n",
> +		buffer, plane, ret);
> +	eb->fd = ret;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(vb2_expbuf);
> +
> +/**
>   * vb2_mmap() - map video buffers into application address space
>   * @q:		videobuf2 queue
>   * @vma:	vma passed to the mmap file operation handler in the driver
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index c306fec..b034424 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -81,6 +81,7 @@ struct vb2_fileio_data;
>  struct vb2_mem_ops {
>  	void		*(*alloc)(void *alloc_ctx, unsigned long size);
>  	void		(*put)(void *buf_priv);
> +	struct dma_buf *(*get_dmabuf)(void *buf_priv);
>  
>  	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
>  					unsigned long size, int write);
> @@ -363,6 +364,7 @@ int vb2_queue_init(struct vb2_queue *q);
>  void vb2_queue_release(struct vb2_queue *q);
>  
>  int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
> +int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
>  int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
>  
>  int vb2_streamon(struct vb2_queue *q, enum v4l2_buf_type type);
> 

Please add a vb2_ioctl_expbuf helper function as well!

Regards,

	Hans
