Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36033 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaILVth (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 17:49:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/14] vb2-dma-sg: add allocation context to dma-sg
Date: Sat, 13 Sep 2014 00:49:36 +0300
Message-ID: <8499412.B528Oiqz9o@avalon>
In-Reply-To: <1410526803-25887-3-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 12 September 2014 14:59:51 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Require that dma-sg also uses an allocation context. This is in preparation
> for adding prepare/finish memops to sync the memory between DMA and CPU.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/cx23885/cx23885-417.c         |  1 +
>  drivers/media/pci/cx23885/cx23885-core.c        | 10 +++++-
>  drivers/media/pci/cx23885/cx23885-dvb.c         |  1 +
>  drivers/media/pci/cx23885/cx23885-vbi.c         |  1 +
>  drivers/media/pci/cx23885/cx23885-video.c       |  1 +
>  drivers/media/pci/cx23885/cx23885.h             |  1 +
>  drivers/media/pci/saa7134/saa7134-core.c        | 18 +++++++---
>  drivers/media/pci/saa7134/saa7134-ts.c          |  1 +
>  drivers/media/pci/saa7134/saa7134-vbi.c         |  1 +
>  drivers/media/pci/saa7134/saa7134-video.c       |  1 +
>  drivers/media/pci/saa7134/saa7134.h             |  1 +
>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 10 ++++++
>  drivers/media/pci/solo6x10/solo6x10.h           |  1 +
>  drivers/media/pci/tw68/tw68-core.c              | 15 +++++++--
>  drivers/media/pci/tw68/tw68-video.c             |  1 +
>  drivers/media/pci/tw68/tw68.h                   |  1 +
>  drivers/media/platform/marvell-ccic/mcam-core.c |  7 ++++
>  drivers/media/platform/marvell-ccic/mcam-core.h |  1 +
>  drivers/media/v4l2-core/videobuf2-core.c        |  3 +-
>  drivers/media/v4l2-core/videobuf2-dma-contig.c  |  4 ++-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c      | 44 ++++++++++++++++++++--
>  drivers/media/v4l2-core/videobuf2-vmalloc.c     |  3 +-
>  include/media/videobuf2-core.h                  |  3 +-
>  include/media/videobuf2-dma-sg.h                |  3 ++
>  24 files changed, 118 insertions(+), 15 deletions(-)

[snip]

> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index e5247a4..087cd62 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -189,6 +189,7 @@ static void __vb2_queue_cancel(struct vb2_queue *q);
>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> +	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>  	void *mem_priv;
>  	int plane;
> 
> @@ -200,7 +201,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
> 
>  		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
> -				      size, q->gfp_flags);
> +				      size, write, q->gfp_flags);
>  		if (IS_ERR_OR_NULL(mem_priv))
>  			goto free;
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 4a02ade..6675f12
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -155,7 +155,8 @@ static void vb2_dc_put(void *buf_priv)
>  	kfree(buf);
>  }
> 
> -static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, gfp_t
> gfp_flags)
> +static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size, int write,
> +			  gfp_t gfp_flags)
>  {
>  	struct vb2_dc_conf *conf = alloc_ctx;
>  	struct device *dev = conf->dev;
> @@ -176,6 +177,7 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size, gfp_t gfp_flags) /* Prevent the device from being released while the
> buffer is used */ buf->dev = get_device(dev);
>  	buf->size = size;
> +	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;

This is an unrelated bug fix, it should be split to a separate patch.

>  	buf->handler.refcount = &buf->refcount;
>  	buf->handler.put = vb2_dc_put;
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index adefc31..9b7a041 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -30,11 +30,17 @@ module_param(debug, int, 0644);
>  			printk(KERN_DEBUG "vb2-dma-sg: " fmt, ## arg);	\
>  	} while (0)
> 
> +struct vb2_dma_sg_conf {
> +	struct device		*dev;
> +};
> +
>  struct vb2_dma_sg_buf {
> +	struct device			*dev;
>  	void				*vaddr;
>  	struct page			**pages;
>  	int				write;
>  	int				offset;
> +	enum dma_data_direction		dma_dir;
>  	struct sg_table			sg_table;
>  	size_t				size;
>  	unsigned int			num_pages;
> @@ -86,22 +92,27 @@ static int vb2_dma_sg_alloc_compacted(struct
> vb2_dma_sg_buf *buf, return 0;
>  }
> 
> -static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, gfp_t
> gfp_flags)
> +static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size, int
> write,
> +			      gfp_t gfp_flags)
>  {
> +	struct vb2_dma_sg_conf *conf = alloc_ctx;
>  	struct vb2_dma_sg_buf *buf;
>  	int ret;
>  	int num_pages;
> 
> +	if (WARN_ON(alloc_ctx == NULL))
> +		return NULL;
>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>  	if (!buf)
>  		return NULL;
> 
>  	buf->vaddr = NULL;
> -	buf->write = 0;
> +	buf->write = write;
>  	buf->offset = 0;
>  	buf->size = size;
>  	/* size is already page aligned */
>  	buf->num_pages = size >> PAGE_SHIFT;
> +	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> 
>  	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
>  			     GFP_KERNEL);
> @@ -117,6 +128,8 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size, gfp_t gfp_fla if (ret)
>  		goto fail_table_alloc;
> 
> +	/* Prevent the device from being released while the buffer is used */
> +	buf->dev = get_device(conf->dev);
>  	buf->handler.refcount = &buf->refcount;
>  	buf->handler.put = vb2_dma_sg_put;
>  	buf->handler.arg = buf;
> @@ -152,6 +165,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>  		while (--i >= 0)
>  			__free_page(buf->pages[i]);
>  		kfree(buf->pages);
> +		put_device(buf->dev);
>  		kfree(buf);
>  	}
>  }
> @@ -164,6 +178,7 @@ static inline int vma_is_io(struct vm_area_struct *vma)
>  static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>  				    unsigned long size, int write)
>  {
> +	struct vb2_dma_sg_conf *conf = alloc_ctx;
>  	struct vb2_dma_sg_buf *buf;
>  	unsigned long first, last;
>  	int num_pages_from_user;
> @@ -177,6 +192,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, buf->write = write;
>  	buf->offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> +	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> 
>  	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
>  	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
> @@ -233,6 +249,8 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, buf->num_pages, buf->offset, size, 0))
>  		goto userptr_fail_alloc_table_from_pages;
> 
> +	/* Prevent the device from being released while the buffer is used */
> +	buf->dev = get_device(conf->dev);
>  	return buf;
> 
>  userptr_fail_alloc_table_from_pages:
> @@ -272,6 +290,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  	}
>  	kfree(buf->pages);
>  	vb2_put_vma(buf->vma);
> +	put_device(buf->dev);
>  	kfree(buf);
>  }
> 
> @@ -354,6 +373,27 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);
> 
> +void *vb2_dma_sg_init_ctx(struct device *dev)
> +{
> +	struct vb2_dma_sg_conf *conf;
> +
> +	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
> +	if (!conf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	conf->dev = dev;

This is unrelated to this patch, but given that the dc and dma-sg allocation 
contexts only need to store a struct device pointer, wouldn't it be simpler to 
teach vb2 about struct device ?

> +
> +	return conf;
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_sg_init_ctx);
> +
> +void vb2_dma_sg_cleanup_ctx(void *alloc_ctx)
> +{
> +	if (!IS_ERR_OR_NULL(alloc_ctx))
> +		kfree(alloc_ctx);
> +}
> +EXPORT_SYMBOL_GPL(vb2_dma_sg_cleanup_ctx);
> +
>  MODULE_DESCRIPTION("dma scatter/gather memory handling routines for
> videobuf2"); MODULE_AUTHOR("Andrzej Pietrasiewicz");
>  MODULE_LICENSE("GPL");
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> b/drivers/media/v4l2-core/videobuf2-vmalloc.c index 313d977..d77e397 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -35,7 +35,8 @@ struct vb2_vmalloc_buf {
> 
>  static void vb2_vmalloc_put(void *buf_priv);
> 
> -static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t
> gfp_flags)
> +static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, int
> write,
> +			       gfp_t gfp_flags)
>  {
>  	struct vb2_vmalloc_buf *buf;
> 
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index fff159c..02b96ef 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -82,7 +82,8 @@ struct vb2_threadio_data;
>   *				  unmap_dmabuf.
>   */
>  struct vb2_mem_ops {
> -	void		*(*alloc)(void *alloc_ctx, unsigned long size, gfp_t gfp_flags);
> +	void		*(*alloc)(void *alloc_ctx, unsigned long size, int write,

I know that we're already using a write flag in other parts of the API, but I 
find it a bit confusing. I think we should either document what the write flag 
means in the comment block above this structure, or replace it with a more 
explicit dma direction (which the alloc function will need to compute anyway).

> +				  gfp_t gfp_flags);
>  	void		(*put)(void *buf_priv);
>  	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
> 
> diff --git a/include/media/videobuf2-dma-sg.h
> b/include/media/videobuf2-dma-sg.h index 7b89852..14ce306 100644
> --- a/include/media/videobuf2-dma-sg.h
> +++ b/include/media/videobuf2-dma-sg.h
> @@ -21,6 +21,9 @@ static inline struct sg_table *vb2_dma_sg_plane_desc(
>  	return (struct sg_table *)vb2_plane_cookie(vb, plane_no);
>  }
> 
> +void *vb2_dma_sg_init_ctx(struct device *dev);
> +void vb2_dma_sg_cleanup_ctx(void *alloc_ctx);
> +
>  extern const struct vb2_mem_ops vb2_dma_sg_memops;
> 
>  #endif

-- 
Regards,

Laurent Pinchart

