Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58887 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2HOUoY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 16:44:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 23/26] v4l: vb2: add support for DMA_ATTR_NO_KERNEL_MAPPING
Date: Wed, 15 Aug 2012 22:44:39 +0200
Message-ID: <1635347.9hJUtC51CO@avalon>
In-Reply-To: <1344958496-9373-24-git-send-email-t.stanislaws@samsung.com>
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com> <1344958496-9373-24-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 14 August 2012 17:34:53 Tomasz Stanislawski wrote:
> From: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>  drivers/media/video/atmel-isi.c              |    2 +-
>  drivers/media/video/blackfin/bfin_capture.c  |    2 +-
>  drivers/media/video/marvell-ccic/mcam-core.c |    3 ++-
>  drivers/media/video/mx2_camera.c             |    2 +-
>  drivers/media/video/mx2_emmaprp.c            |    2 +-
>  drivers/media/video/mx3_camera.c             |    2 +-
>  drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
>  drivers/media/video/s5p-fimc/fimc-lite.c     |    2 +-
>  drivers/media/video/s5p-g2d/g2d.c            |    2 +-
>  drivers/media/video/s5p-jpeg/jpeg-core.c     |    2 +-
>  drivers/media/video/s5p-mfc/s5p_mfc.c        |    5 ++--
>  drivers/media/video/s5p-tv/mixer_video.c     |    2 +-
>  drivers/media/video/sh_mobile_ceu_camera.c   |    2 +-
>  drivers/media/video/videobuf2-dma-contig.c   |   33 ++++++++++++++++-------
>  drivers/staging/media/dt3155v4l/dt3155v4l.c  |    2 +-
>  include/media/videobuf2-dma-contig.h         |    4 +++-
>  16 files changed, 44 insertions(+), 25 deletions(-)

[snip]

> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 11f4a46..0729187 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -23,10 +23,12 @@
> 
>  struct vb2_dc_conf {
>  	struct device		*dev;
> +	unsigned int		flags;
>  };
> 
>  struct vb2_dc_buf {
>  	struct device			*dev;
> +	unsigned int			flags;
>  	void				*vaddr;
>  	unsigned long			size;
>  	dma_addr_t			dma_addr;
> @@ -34,6 +36,7 @@ struct vb2_dc_buf {
>  	struct sg_table			*dma_sgt;
> 
>  	/* MMAP related */
> +	struct dma_attrs		dma_attrs;
>  	struct vb2_vmarea_handler	handler;
>  	atomic_t			refcount;
>  	struct sg_table			*sgt_base;
> @@ -98,6 +101,9 @@ static void *vb2_dc_vaddr(void *buf_priv)
>  {
>  	struct vb2_dc_buf *buf = buf_priv;
> 
> +	if (WARN_ON(~buf->flags & VB2_CREATE_VADDR))
> +		return NULL;
> +
>  	return buf->vaddr;
>  }
> 
> @@ -147,7 +153,8 @@ static void vb2_dc_put(void *buf_priv)
>  		sg_free_table(buf->sgt_base);
>  		kfree(buf->sgt_base);
>  	}
> -	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> +	dma_free_attrs(buf->dev, buf->size, buf->vaddr, buf->dma_addr,
> +		       &buf->dma_attrs);
>  	put_device(buf->dev);
>  	kfree(buf);
>  }
> @@ -165,7 +172,14 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned
> long size) /* prevent the device from release while the buffer is exported
> */ get_device(dev);
> 
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
> +	/* set up alloca attributes */
> +	init_dma_attrs(&buf->dma_attrs);
> +	dma_set_attr(DMA_ATTR_WRITE_COMBINE, &buf->dma_attrs);
> +	if (!(conf->flags & VB2_CREATE_VADDR))
> +		dma_set_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->dma_attrs);
> +
> +	buf->vaddr = dma_alloc_attrs(dev, size, &buf->dma_addr, GFP_KERNEL,
> +				     &buf->dma_attrs);

What address does dma_alloc_attrs() return when the DMA_ATTR_NO_KERNEL_MAPPING 
attribute is set ?

>  	if (!buf->vaddr) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>  		put_device(dev);
> @@ -174,6 +188,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size) }
> 
>  	buf->dev = dev;
> +	buf->flags = conf->flags;
>  	buf->size = size;
> 
>  	buf->handler.refcount = &buf->refcount;
> @@ -201,9 +216,8 @@ static int vb2_dc_mmap(void *buf_priv, struct
> vm_area_struct *vma) */
>  	vma->vm_pgoff = 0;
> 
> -	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> -		buf->dma_addr, buf->size);
> -
> +	ret = dma_mmap_attrs(buf->dev, vma, buf->vaddr, buf->dma_addr,
> +			     buf->size, &buf->dma_attrs);
>  	if (ret) {
>  		pr_err("Remapping memory failed, error: %d\n", ret);
>  		return ret;
> @@ -345,7 +359,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf
> *dbuf, unsigned long pgnum) {
>  	struct vb2_dc_buf *buf = dbuf->priv;
> 
> -	return buf->vaddr + pgnum * PAGE_SIZE;
> +	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;

Does this mean that a V4L2 driver that doesn't need a kernel mapping will not 
be able to export buffers to devices that require such a mapping ?

>  }
> 
>  static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> @@ -385,8 +399,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct
> vb2_dc_buf *buf) return ERR_PTR(-ENOMEM);
>  	}
> 
> -	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> -		buf->size);
> +	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> +		buf->size, &buf->dma_attrs);
>  	if (ret < 0) {
>  		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
>  		kfree(sgt);
> @@ -753,7 +767,7 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
> 
> -void *vb2_dma_contig_init_ctx(struct device *dev)
> +void *vb2_dma_contig_init_ctx(struct device *dev, unsigned int flags)
>  {
>  	struct vb2_dc_conf *conf;
> 
> @@ -762,6 +776,7 @@ void *vb2_dma_contig_init_ctx(struct device *dev)
>  		return ERR_PTR(-ENOMEM);
> 
>  	conf->dev = dev;
> +	conf->flags = flags;
> 
>  	return conf;
>  }

[snip]

> diff --git a/include/media/videobuf2-dma-contig.h
> b/include/media/videobuf2-dma-contig.h index 8197f87..8bf4b29 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -24,7 +24,9 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb,
> unsigned int plane_no) return *addr;
>  }
> 
> -void *vb2_dma_contig_init_ctx(struct device *dev);
> +#define VB2_CREATE_VADDR	(1 << 0)
> +

Would it make sense to either move the flag to a common vb2 header or to call 
it VB2_DMA_CONTIG_CREATE_VADDR ?

> +void *vb2_dma_contig_init_ctx(struct device *dev, unsigned int flags);
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
> 
>  extern const struct vb2_mem_ops vb2_dma_contig_memops;

-- 
Regards,

Laurent Pinchart

