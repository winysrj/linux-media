Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34701 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab2DFN25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 09:28:57 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH 03/11] v4l: vb2: add support for shared buffer (dma_buf)
Date: Fri, 06 Apr 2012 15:29:02 +0200
Message-ID: <1462069.6RAU1Un2jt@avalon>
In-Reply-To: <1333634408-4960-4-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com> <1333634408-4960-4-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 05 April 2012 16:00:00 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> This patch adds support for DMABUF memory type in videobuf2. It calls
> relevant APIs of dma_buf for v4l reqbuf / qbuf / dqbuf operations.
> 
> For this version, the support is for videobuf2 as a user of the shared
> buffer; so the allocation of the buffer is done outside of V4L2. [A sample
> allocator of dma-buf shared buffer is given at [1]]
> 
> [1]: Rob Clark's DRM:
>    https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>    [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> ---
>  drivers/media/video/videobuf2-core.c |  184 ++++++++++++++++++++++++++++++-
>  include/media/videobuf2-core.h       |   31 ++++++
>  2 files changed, 214 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c index 2e8f1df..b37feea 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c

[snip]

> @@ -451,6 +482,21 @@ static int __verify_mmap_ops(struct vb2_queue *q)
>  }
> 
>  /**
> + * __verify_dmabuf_ops() - verify that all memory operations required for
> + * DMABUF queue type have been provided
> + */
> +static int __verify_dmabuf_ops(struct vb2_queue *q)
> +{
> +	if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf
> +			|| !q->mem_ops->detach_dmabuf
> +			|| !q->mem_ops->map_dmabuf
> +			|| !q->mem_ops->unmap_dmabuf)

That's pretty strange indentation. What about

        if (!(q->io_modes & VB2_DMABUF) || !q->mem_ops->attach_dmabuf ||
            !q->mem_ops->detach_dmabuf || !q->mem_ops->map_dmabuf ||
            !q->mem_ops->unmap_dmabuf)

> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/**
>   * vb2_reqbufs() - Initiate streaming
>   * @q:		videobuf2 queue
>   * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> @@ -484,6 +530,7 @@ int vb2_reqbufs(struct vb2_queue *q, struct
> v4l2_requestbuffers *req) }
> 
>  	if (req->memory != V4L2_MEMORY_MMAP
> +			&& req->memory != V4L2_MEMORY_DMABUF
>  			&& req->memory != V4L2_MEMORY_USERPTR) {
>  		dprintk(1, "reqbufs: unsupported memory type\n");
>  		return -EINVAL;

Ditto.

[snip]

> @@ -620,7 +672,8 @@ int vb2_create_bufs(struct vb2_queue *q, struct
> v4l2_create_buffers *create) }
> 
>  	if (create->memory != V4L2_MEMORY_MMAP
> -			&& create->memory != V4L2_MEMORY_USERPTR) {
> +			&& create->memory != V4L2_MEMORY_USERPTR
> +			&& create->memory != V4L2_MEMORY_DMABUF) {
>  		dprintk(1, "%s(): unsupported memory type\n", __func__);
>  		return -EINVAL;
>  	}

And here too.

[snip]

> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index a15d1f1..665e846 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h

[snip]

> @@ -65,6 +82,17 @@ struct vb2_mem_ops {
>  					unsigned long size, int write);
>  	void		(*put_userptr)(void *buf_priv);
> 
> +	/*
> +	 * Comment from Rob Clark: XXX: I think the attach / detach could be
> +	 * handled in the vb2 core, and vb2_mem_ops really just need to get/put
> +	 * the sglist (and make sure that the sglist fits it's needs..)
> +	 */

I think we should address this now. We've previously discussed the question, 
but haven't reached an agreement.

Quoting my reply to "[RFCv2 PATCH 3/9] v4l: vb2: Add dma-contig allocator as 
dma_buf user" on 28/03/2012:

> > Calling dma_buf_attach could be moved to vb2-core. But it gives little
> > gain. First, the pointer of dma_buf_attachment would have to be added to
> > struct vb2_plane. Second, the allocator would have to keep in the copy of
> > this pointer in its context structure for use of vb2_dc_(un)map_dmabuf
> > functions.
> 
> Right. Would it make sense to pass the vb2_plane pointer, or possibly the 
> dma_buf_attachment pointer, to the mmap_dmabuf and unmap_dmabuf operations ?
> 
> > Third, dma_buf_attach requires a pointer to 'struct device' which is not
> > available in the vb2-core layer.
> 
> OK, that's a problem.
> 
> > Because of the mentioned reasons I decided to keep attach_dmabuf in
> > allocator-specific code.
> 
> Maybe it would make sense to create a vb2_mem_buf structure from which 
> vb2_dc_buf (and other allocator-specific buffer descriptors) would inherit ? 
> That structure would store the dma_buf_attach pointer, and common dma-buf
> code could be put in videobuf2-memops.c and shared between allocators. Just
> an idea.

If we find out that the best course of action is to leave the code as-is, we 
should remove the above comment.

> +	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
> +				unsigned long size, int write);
> +	void		(*detach_dmabuf)(void *buf_priv);
> +	int		(*map_dmabuf)(void *buf_priv);
> +	void		(*unmap_dmabuf)(void *buf_priv);
> +
>  	void		*(*vaddr)(void *buf_priv);
>  	void		*(*cookie)(void *buf_priv);

-- 
Regards,

Laurent Pinchart

