Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53779 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZTtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 14:49:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 02/12] vb2: replace 'write' by 'dma_dir'
Date: Wed, 26 Nov 2014 21:50:21 +0200
Message-ID: <3469615.7UDLyAiVCb@avalon>
In-Reply-To: <1416315068-22936-3-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 18 November 2014 13:50:58 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The 'write' argument is very ambiguous. I first assumed that if it is 1,
> then we're doing video output but instead it meant the reverse.
> 
> Since it is used to setup the dma_dir value anyway it is now replaced by
> the correct dma_dir value which is unambiguous.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/videobuf2-core.c       | 10 ++++---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 40
> ++++++++++++++------------ drivers/media/v4l2-core/videobuf2-dma-sg.c     |
> 13 +++++----
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    | 16 ++++++-----
>  include/media/videobuf2-core.h                 |  6 ++--
>  5 files changed, 47 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> b/drivers/media/v4l2-core/videobuf2-core.c index f2e43de..573f6fb 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1358,7 +1358,8 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) void *mem_priv;
>  	unsigned int plane;
>  	int ret;
> -	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +	enum dma_data_direction dma_dir =
> +		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
> 
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1400,7 +1401,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) /* Acquire each plane's memory */
>  		mem_priv = call_ptr_memop(vb, get_userptr, q->alloc_ctx[plane],
>  				      planes[plane].m.userptr,
> -				      planes[plane].length, write);
> +				      planes[plane].length, dma_dir);
>  		if (IS_ERR_OR_NULL(mem_priv)) {
>  			dprintk(1, "failed acquiring userspace "
>  						"memory for plane %d\n", plane);
> @@ -1461,7 +1462,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const
> struct v4l2_buffer *b) void *mem_priv;
>  	unsigned int plane;
>  	int ret;
> -	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
> +	enum dma_data_direction dma_dir =
> +		V4L2_TYPE_IS_OUTPUT(q->type) ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
> 
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1509,7 +1511,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const
> struct v4l2_buffer *b)
> 
>  		/* Acquire each plane's memory */
>  		mem_priv = call_ptr_memop(vb, attach_dmabuf, q->alloc_ctx[plane],
> -			dbuf, planes[plane].length, write);
> +			dbuf, planes[plane].length, dma_dir);
>  		if (IS_ERR(mem_priv)) {
>  			dprintk(1, "failed to attach dmabuf\n");
>  			ret = PTR_ERR(mem_priv);
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 4a02ade..2bdffd3
> 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -229,7 +229,7 @@ static int vb2_dc_mmap(void *buf_priv, struct
> vm_area_struct *vma)
> 
>  struct vb2_dc_attachment {
>  	struct sg_table sgt;
> -	enum dma_data_direction dir;
> +	enum dma_data_direction dma_dir;
>  };
> 
>  static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device
> *dev, @@ -264,7 +264,7 @@ static int vb2_dc_dmabuf_ops_attach(struct
> dma_buf *dbuf, struct device *dev, wr = sg_next(wr);
>  	}
> 
> -	attach->dir = DMA_NONE;
> +	attach->dma_dir = DMA_NONE;
>  	dbuf_attach->priv = attach;
> 
>  	return 0;
> @@ -282,16 +282,16 @@ static void vb2_dc_dmabuf_ops_detach(struct dma_buf
> *dbuf, sgt = &attach->sgt;
> 
>  	/* release the scatterlist cache */
> -	if (attach->dir != DMA_NONE)
> +	if (attach->dma_dir != DMA_NONE)
>  		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> -			attach->dir);
> +			attach->dma_dir);
>  	sg_free_table(sgt);
>  	kfree(attach);
>  	db_attach->priv = NULL;
>  }
> 
>  static struct sg_table *vb2_dc_dmabuf_ops_map(
> -	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
> +	struct dma_buf_attachment *db_attach, enum dma_data_direction dma_dir)
>  {
>  	struct vb2_dc_attachment *attach = db_attach->priv;
>  	/* stealing dmabuf mutex to serialize map/unmap operations */
> @@ -303,27 +303,27 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
> 
>  	sgt = &attach->sgt;
>  	/* return previously mapped sg table */
> -	if (attach->dir == dir) {
> +	if (attach->dma_dir == dma_dir) {
>  		mutex_unlock(lock);
>  		return sgt;
>  	}
> 
>  	/* release any previous cache */
> -	if (attach->dir != DMA_NONE) {
> +	if (attach->dma_dir != DMA_NONE) {
>  		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
> -			attach->dir);
> -		attach->dir = DMA_NONE;
> +			attach->dma_dir);
> +		attach->dma_dir = DMA_NONE;
>  	}
> 
>  	/* mapping to the client with new direction */
> -	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
> +	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
>  	if (ret <= 0) {
>  		pr_err("failed to map scatterlist\n");
>  		mutex_unlock(lock);
>  		return ERR_PTR(-EIO);
>  	}
> 
> -	attach->dir = dir;
> +	attach->dma_dir = dma_dir;
> 
>  	mutex_unlock(lock);
> 
> @@ -331,7 +331,7 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>  }
> 
>  static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
> -	struct sg_table *sgt, enum dma_data_direction dir)
> +	struct sg_table *sgt, enum dma_data_direction dma_dir)
>  {
>  	/* nothing to be done here */
>  }
> @@ -460,7 +460,8 @@ static int vb2_dc_get_user_pfn(unsigned long start, int
> n_pages, }
> 
>  static int vb2_dc_get_user_pages(unsigned long start, struct page **pages,
> -	int n_pages, struct vm_area_struct *vma, int write)
> +	int n_pages, struct vm_area_struct *vma,
> +	enum dma_data_direction dma_dir)
>  {
>  	if (vma_is_io(vma)) {
>  		unsigned int i;
> @@ -482,7 +483,7 @@ static int vb2_dc_get_user_pages(unsigned long start,
> struct page **pages, int n;
> 
>  		n = get_user_pages(current, current->mm, start & PAGE_MASK,
> -			n_pages, write, 1, pages, NULL);
> +			n_pages, dma_dir == DMA_FROM_DEVICE, 1, pages, NULL);
>  		/* negative error means that no page was pinned */
>  		n = max(n, 0);
>  		if (n != n_pages) {
> @@ -551,7 +552,7 @@ static inline dma_addr_t vb2_dc_pfn_to_dma(struct device
> *dev, unsigned long pfn #endif
> 
>  static void *vb2_dc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> -	unsigned long size, int write)
> +	unsigned long size, enum dma_data_direction dma_dir)
>  {
>  	struct vb2_dc_conf *conf = alloc_ctx;
>  	struct vb2_dc_buf *buf;
> @@ -582,7 +583,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, return ERR_PTR(-ENOMEM);
> 
>  	buf->dev = conf->dev;
> -	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	buf->dma_dir = dma_dir;
> 
>  	start = vaddr & PAGE_MASK;
>  	offset = vaddr & ~PAGE_MASK;
> @@ -618,7 +619,8 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, }
> 
>  	/* extract page list from userspace mapping */
> -	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma, write);
> +	ret = vb2_dc_get_user_pages(start, pages, n_pages, vma,
> +				    dma_dir == DMA_FROM_DEVICE);
>  	if (ret) {
>  		unsigned long pfn;
>  		if (vb2_dc_get_user_pfn(start, n_pages, vma, &pfn) == 0) {
> @@ -782,7 +784,7 @@ static void vb2_dc_detach_dmabuf(void *mem_priv)
>  }
> 
>  static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
> -	unsigned long size, int write)
> +	unsigned long size, enum dma_data_direction dma_dir)
>  {
>  	struct vb2_dc_conf *conf = alloc_ctx;
>  	struct vb2_dc_buf *buf;
> @@ -804,7 +806,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx,
> struct dma_buf *dbuf, return dba;
>  	}
> 
> -	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	buf->dma_dir = dma_dir;
>  	buf->size = size;
>  	buf->db_attach = dba;
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index 9b163a4..6b54a14 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -33,8 +33,8 @@ module_param(debug, int, 0644);
>  struct vb2_dma_sg_buf {
>  	void				*vaddr;
>  	struct page			**pages;
> -	int				write;
>  	int				offset;
> +	enum dma_data_direction		dma_dir;
>  	struct sg_table			sg_table;
>  	size_t				size;
>  	unsigned int			num_pages;
> @@ -97,7 +97,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size, gfp_t gfp_fla return NULL;
> 
>  	buf->vaddr = NULL;
> -	buf->write = 0;
> +	buf->dma_dir = DMA_NONE;
>  	buf->offset = 0;
>  	buf->size = size;
>  	/* size is already page aligned */
> @@ -162,7 +162,8 @@ static inline int vma_is_io(struct vm_area_struct *vma)
>  }
> 
>  static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
> -				    unsigned long size, int write)
> +				    unsigned long size,
> +				    enum dma_data_direction dma_dir)
>  {
>  	struct vb2_dma_sg_buf *buf;
>  	unsigned long first, last;
> @@ -174,7 +175,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, return NULL;
> 
>  	buf->vaddr = NULL;
> -	buf->write = write;
> +	buf->dma_dir = dma_dir;
>  	buf->offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> 
> @@ -221,7 +222,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, num_pages_from_user = get_user_pages(current,
> current->mm,
>  					     vaddr & PAGE_MASK,
>  					     buf->num_pages,
> -					     write,
> +					     buf->dma_dir == DMA_FROM_DEVICE,
>  					     1, /* force */
>  					     buf->pages,
>  					     NULL);
> @@ -265,7 +266,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  		vm_unmap_ram(buf->vaddr, buf->num_pages);
>  	sg_free_table(&buf->sg_table);
>  	while (--i >= 0) {
> -		if (buf->write)
> +		if (buf->dma_dir == DMA_FROM_DEVICE)
>  			set_page_dirty_lock(buf->pages[i]);
>  		if (!vma_is_io(buf->vma))
>  			put_page(buf->pages[i]);
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> b/drivers/media/v4l2-core/videobuf2-vmalloc.c index 313d977..fc1eb45 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -25,7 +25,7 @@ struct vb2_vmalloc_buf {
>  	void				*vaddr;
>  	struct page			**pages;
>  	struct vm_area_struct		*vma;
> -	int				write;
> +	enum dma_data_direction		dma_dir;
>  	unsigned long			size;
>  	unsigned int			n_pages;
>  	atomic_t			refcount;
> @@ -70,7 +70,8 @@ static void vb2_vmalloc_put(void *buf_priv)
>  }
> 
>  static void *vb2_vmalloc_get_userptr(void *alloc_ctx, unsigned long vaddr,
> -				     unsigned long size, int write)
> +				     unsigned long size,
> +				     enum dma_data_direction dma_dir)
>  {
>  	struct vb2_vmalloc_buf *buf;
>  	unsigned long first, last;
> @@ -82,7 +83,7 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, if (!buf)
>  		return NULL;
> 
> -	buf->write = write;
> +	buf->dma_dir = dma_dir;
>  	offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> 
> @@ -107,7 +108,8 @@ static void *vb2_vmalloc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, /* current->mm->mmap_sem is taken by videobuf2 core */
>  		n_pages = get_user_pages(current, current->mm,
>  					 vaddr & PAGE_MASK, buf->n_pages,
> -					 write, 1, /* force */
> +					 dma_dir == DMA_FROM_DEVICE,
> +					 1, /* force */
>  					 buf->pages, NULL);
>  		if (n_pages != buf->n_pages)
>  			goto fail_get_user_pages;
> @@ -144,7 +146,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>  		if (vaddr)
>  			vm_unmap_ram((void *)vaddr, buf->n_pages);
>  		for (i = 0; i < buf->n_pages; ++i) {
> -			if (buf->write)
> +			if (buf->dma_dir == DMA_FROM_DEVICE)
>  				set_page_dirty_lock(buf->pages[i]);
>  			put_page(buf->pages[i]);
>  		}
> @@ -240,7 +242,7 @@ static void vb2_vmalloc_detach_dmabuf(void *mem_priv)
>  }
> 
>  static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx, struct dma_buf
> *dbuf, -	unsigned long size, int write)
> +	unsigned long size, enum dma_data_direction dma_dir)
>  {
>  	struct vb2_vmalloc_buf *buf;
> 
> @@ -252,7 +254,7 @@ static void *vb2_vmalloc_attach_dmabuf(void *alloc_ctx,
> struct dma_buf *dbuf, return ERR_PTR(-ENOMEM);
> 
>  	buf->dbuf = dbuf;
> -	buf->write = write;
> +	buf->dma_dir = dma_dir;
>  	buf->size = size;
> 
>  	return buf;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 70ace7c..d607871 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -87,14 +87,16 @@ struct vb2_mem_ops {
>  	struct dma_buf *(*get_dmabuf)(void *buf_priv, unsigned long flags);
> 
>  	void		*(*get_userptr)(void *alloc_ctx, unsigned long vaddr,
> -					unsigned long size, int write);
> +					unsigned long size,
> +					enum dma_data_direction dma_dir);
>  	void		(*put_userptr)(void *buf_priv);
> 
>  	void		(*prepare)(void *buf_priv);
>  	void		(*finish)(void *buf_priv);
> 
>  	void		*(*attach_dmabuf)(void *alloc_ctx, struct dma_buf *dbuf,
> -				unsigned long size, int write);
> +					  unsigned long size,
> +					  enum dma_data_direction dma_dir);
>  	void		(*detach_dmabuf)(void *buf_priv);
>  	int		(*map_dmabuf)(void *buf_priv);
>  	void		(*unmap_dmabuf)(void *buf_priv);

-- 
Regards,

Laurent Pinchart

