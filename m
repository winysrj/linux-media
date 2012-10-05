Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4796 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab2JEISZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 04:18:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCHv9 03/25] v4l: vb2: add support for shared buffer (dma_buf)
Date: Fri, 5 Oct 2012 10:17:35 +0200
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, zhangfei.gao@gmail.com,
	s.nawrocki@samsung.com, k.debski@samsung.com,
	Sumit Semwal <sumit.semwal@linaro.org>
References: <1349188056-4886-1-git-send-email-t.stanislaws@samsung.com> <1349188056-4886-4-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1349188056-4886-4-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210051017.35297.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a small heads-up for an upcoming change...

On Tue October 2 2012 16:27:14 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> This patch adds support for DMABUF memory type in videobuf2. It calls relevant
> APIs of dma_buf for v4l reqbuf / qbuf / dqbuf operations.
> 
> For this version, the support is for videobuf2 as a user of the shared buffer;
> so the allocation of the buffer is done outside of V4L2. [A sample allocator of
> dma-buf shared buffer is given at [1]]
> 
> [1]: Rob Clark's DRM:
>    https://github.com/robclark/kernel-omap4/commits/drmplane-dmabuf
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>    [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/Kconfig          |    1 +
>  drivers/media/video/videobuf2-core.c |  207 +++++++++++++++++++++++++++++++++-
>  include/media/videobuf2-core.h       |   27 +++++
>  3 files changed, 232 insertions(+), 3 deletions(-)
> 

<snip>

> @@ -970,6 +1040,109 @@ static int __qbuf_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  }
>  
>  /**
> + * __qbuf_dmabuf() - handle qbuf of a DMABUF buffer
> + */
> +static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +	struct v4l2_plane planes[VIDEO_MAX_PLANES];
> +	struct vb2_queue *q = vb->vb2_queue;
> +	void *mem_priv;
> +	unsigned int plane;
> +	int ret;
> +	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +
> +	/* Verify and copy relevant information provided by the userspace */
> +	ret = __fill_vb2_buffer(vb, b, planes);

Note that this code will have to change a bit when my multiplanar fixes go in:

http://www.spinics.net/lists/linux-media/msg54601.html

__fill_vb2_buffer is now a void function, so there won't be any need to check
the error.

> +	if (ret)
> +		return ret;
> +
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
> +
> +		if (IS_ERR_OR_NULL(dbuf)) {
> +			dprintk(1, "qbuf: invalid dmabuf fd for plane %d\n",
> +				plane);
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		/* use DMABUF size if length is not provided */
> +		if (planes[plane].length == 0)
> +			planes[plane].length = dbuf->size;
> +
> +		if (planes[plane].length < planes[plane].data_offset +
> +		    q->plane_sizes[plane]) {
> +			ret = -EINVAL;
> +			goto err;
> +		}
> +
> +		/* Skip the plane if already verified */
> +		if (dbuf == vb->planes[plane].dbuf &&
> +		    vb->v4l2_planes[plane].length == planes[plane].length) {
> +			dma_buf_put(dbuf);
> +			continue;
> +		}
> +
> +		dprintk(1, "qbuf: buffer for plane %d changed\n", plane);
> +
> +		/* Release previously acquired memory if present */
> +		__vb2_plane_dmabuf_put(q, &vb->planes[plane]);
> +		memset(&vb->v4l2_planes[plane], 0, sizeof(struct v4l2_plane));
> +
> +		/* Acquire each plane's memory */
> +		mem_priv = call_memop(q, attach_dmabuf, q->alloc_ctx[plane],
> +			dbuf, planes[plane].length, write);
> +		if (IS_ERR(mem_priv)) {
> +			dprintk(1, "qbuf: failed to attach dmabuf\n");
> +			ret = PTR_ERR(mem_priv);
> +			dma_buf_put(dbuf);
> +			goto err;
> +		}
> +
> +		vb->planes[plane].dbuf = dbuf;
> +		vb->planes[plane].mem_priv = mem_priv;
> +	}
> +
> +	/* TODO: This pins the buffer(s) with  dma_buf_map_attachment()).. but
> +	 * really we want to do this just before the DMA, not while queueing
> +	 * the buffer(s)..
> +	 */
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		ret = call_memop(q, map_dmabuf, vb->planes[plane].mem_priv);
> +		if (ret) {
> +			dprintk(1, "qbuf: failed to map dmabuf for plane %d\n",
> +				plane);
> +			goto err;
> +		}
> +		vb->planes[plane].dbuf_mapped = 1;
> +	}
> +
> +	/*
> +	 * Call driver-specific initialization on the newly acquired buffer,
> +	 * if provided.
> +	 */
> +	ret = call_qop(q, buf_init, vb);
> +	if (ret) {
> +		dprintk(1, "qbuf: buffer initialization failed\n");
> +		goto err;
> +	}
> +
> +	/*
> +	 * Now that everything is in order, copy relevant information
> +	 * provided by userspace.
> +	 */
> +	for (plane = 0; plane < vb->num_planes; ++plane)
> +		vb->v4l2_planes[plane] = planes[plane];
> +
> +	return 0;
> +err:
> +	/* In case of errors, release planes that were already acquired */
> +	__vb2_buf_dmabuf_put(vb);
> +
> +	return ret;
> +}
