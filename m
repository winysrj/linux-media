Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53864 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaKZVAO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Nov 2014 16:00:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 07/12] vb2-dma-sg: add dmabuf import support
Date: Wed, 26 Nov 2014 23:00:39 +0200
Message-ID: <1506297.83XqYLfUIF@avalon>
In-Reply-To: <1416315068-22936-8-git-send-email-hverkuil@xs4all.nl>
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-8-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday 18 November 2014 13:51:03 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for importing dmabuf to videobuf2-dma-sg.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-sg.c | 149 +++++++++++++++++++++++---
>  1 file changed, 136 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index f671fab..ad6d5c7 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -41,11 +41,19 @@ struct vb2_dma_sg_buf {
>  	int				offset;
>  	enum dma_data_direction		dma_dir;
>  	struct sg_table			sg_table;
> +	/*
> +	 * This will point to sg_table when used with the MMAP or USERPTR
> +	 * memory model, and to the dma_buf sglist when used with the
> +	 * DMABUF memory model.
> +	 */
> +	struct sg_table			*dma_sgt;
>  	size_t				size;
>  	unsigned int			num_pages;
>  	atomic_t			refcount;
>  	struct vb2_vmarea_handler	handler;
>  	struct vm_area_struct		*vma;
> +
> +	struct dma_buf_attachment	*db_attach;
>  };
> 
>  static void vb2_dma_sg_put(void *buf_priv);
> @@ -112,6 +120,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size, buf->size = size;
>  	/* size is already page aligned */
>  	buf->num_pages = size >> PAGE_SHIFT;
> +	buf->dma_sgt = &buf->sg_table;
> 
>  	buf->pages = kzalloc(buf->num_pages * sizeof(struct page *),
>  			     GFP_KERNEL);
> @@ -122,7 +131,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size, if (ret)
>  		goto fail_pages_alloc;
> 
> -	ret = sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
> +	ret = sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
>  			buf->num_pages, 0, size, GFP_KERNEL);
>  	if (ret)
>  		goto fail_table_alloc;
> @@ -171,7 +180,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>  		dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  		if (buf->vaddr)
>  			vm_unmap_ram(buf->vaddr, buf->num_pages);
> -		sg_free_table(&buf->sg_table);
> +		sg_free_table(buf->dma_sgt);
>  		while (--i >= 0)
>  			__free_page(buf->pages[i]);
>  		kfree(buf->pages);
> @@ -183,7 +192,11 @@ static void vb2_dma_sg_put(void *buf_priv)
>  static void vb2_dma_sg_prepare(void *buf_priv)
>  {
>  	struct vb2_dma_sg_buf *buf = buf_priv;
> -	struct sg_table *sgt = &buf->sg_table;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	/* DMABUF exporter will flush the cache for us */
> +	if (buf->db_attach)
> +		return;

Is this actually true ? If you look at the export code in patch 08/12, I don't 
see where the exporter would sync the buffer for the importer device.

> 
>  	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  }
> @@ -191,7 +204,11 @@ static void vb2_dma_sg_prepare(void *buf_priv)
>  static void vb2_dma_sg_finish(void *buf_priv)
>  {
>  	struct vb2_dma_sg_buf *buf = buf_priv;
> -	struct sg_table *sgt = &buf->sg_table;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	/* DMABUF exporter will flush the cache for us */
> +	if (buf->db_attach)
> +		return;
> 
>  	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  }
> @@ -219,6 +236,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, buf->dma_dir = dma_dir;
>  	buf->offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> +	buf->dma_sgt = &buf->sg_table;
> 
>  	first = (vaddr           & PAGE_MASK) >> PAGE_SHIFT;
>  	last  = ((vaddr + size - 1) & PAGE_MASK) >> PAGE_SHIFT;
> @@ -271,7 +289,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
> unsigned long vaddr, if (num_pages_from_user != buf->num_pages)
>  		goto userptr_fail_get_user_pages;
> 
> -	if (sg_alloc_table_from_pages(&buf->sg_table, buf->pages,
> +	if (sg_alloc_table_from_pages(buf->dma_sgt, buf->pages,
>  			buf->num_pages, buf->offset, size, 0))
>  		goto userptr_fail_alloc_table_from_pages;
> 
> @@ -313,7 +331,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>  	if (buf->vaddr)
>  		vm_unmap_ram(buf->vaddr, buf->num_pages);
> -	sg_free_table(&buf->sg_table);
> +	sg_free_table(buf->dma_sgt);
>  	while (--i >= 0) {
>  		if (buf->dma_dir == DMA_FROM_DEVICE)
>  			set_page_dirty_lock(buf->pages[i]);
> @@ -331,14 +349,16 @@ static void *vb2_dma_sg_vaddr(void *buf_priv)
> 
>  	BUG_ON(!buf);
> 
> -	if (!buf->vaddr)
> -		buf->vaddr = vm_map_ram(buf->pages,
> -					buf->num_pages,
> -					-1,
> -					PAGE_KERNEL);
> +	if (!buf->vaddr) {
> +		if (buf->db_attach)
> +			buf->vaddr = dma_buf_vmap(buf->db_attach->dmabuf);
> +		else
> +			buf->vaddr = vm_map_ram(buf->pages,
> +					buf->num_pages, -1, PAGE_KERNEL);
> +	}
> 
>  	/* add offset in case userptr is not page-aligned */
> -	return buf->vaddr + buf->offset;
> +	return buf->vaddr ? buf->vaddr + buf->offset : NULL;

Just nitpicking here, can vm_map_ram fail and return NULL ? If so this change 
is a separate bug fix and should be split to a separate patch.

>  }
> 
>  static unsigned int vb2_dma_sg_num_users(void *buf_priv)
> @@ -385,11 +405,110 @@ static int vb2_dma_sg_mmap(void *buf_priv, struct
> vm_area_struct *vma) return 0;
>  }
> 
> +/*********************************************/
> +/*       callbacks for DMABUF buffers        */
> +/*********************************************/
> +
> +static int vb2_dma_sg_map_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dma_sg_buf *buf = mem_priv;
> +	struct sg_table *sgt;
> +
> +	if (WARN_ON(!buf->db_attach)) {
> +		pr_err("trying to pin a non attached buffer\n");
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(buf->dma_sgt)) {
> +		pr_err("dmabuf buffer is already pinned\n");
> +		return 0;
> +	}
> +
> +	/* get the associated scatterlist for this buffer */
> +	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
> +	if (IS_ERR(sgt)) {
> +		pr_err("Error getting dmabuf scatterlist\n");
> +		return -EINVAL;
> +	}
> +
> +	buf->dma_sgt = sgt;
> +	buf->vaddr = NULL;
> +
> +	return 0;
> +}
> +
> +static void vb2_dma_sg_unmap_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dma_sg_buf *buf = mem_priv;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	if (WARN_ON(!buf->db_attach)) {
> +		pr_err("trying to unpin a not attached buffer\n");
> +		return;
> +	}
> +
> +	if (WARN_ON(!sgt)) {
> +		pr_err("dmabuf buffer is already unpinned\n");
> +		return;
> +	}
> +
> +	if (buf->vaddr) {
> +		dma_buf_vunmap(buf->db_attach->dmabuf, buf->vaddr);
> +		buf->vaddr = NULL;
> +	}
> +	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
> +
> +	buf->dma_sgt = NULL;
> +}
> +
> +static void vb2_dma_sg_detach_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dma_sg_buf *buf = mem_priv;
> +
> +	/* if vb2 works correctly you should never detach mapped buffer */
> +	if (WARN_ON(buf->dma_sgt))
> +		vb2_dma_sg_unmap_dmabuf(buf);
> +
> +	/* detach this attachment */
> +	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
> +	kfree(buf);
> +}
> +
> +static void *vb2_dma_sg_attach_dmabuf(void *alloc_ctx, struct dma_buf
> *dbuf, +	unsigned long size, enum dma_data_direction dma_dir)
> +{
> +	struct vb2_dma_sg_conf *conf = alloc_ctx;
> +	struct vb2_dma_sg_buf *buf;
> +	struct dma_buf_attachment *dba;
> +
> +	if (dbuf->size < size)
> +		return ERR_PTR(-EFAULT);
> +
> +	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	buf->dev = conf->dev;
> +	/* create attachment for the dmabuf with the user device */
> +	dba = dma_buf_attach(dbuf, buf->dev);
> +	if (IS_ERR(dba)) {
> +		pr_err("failed to attach dmabuf\n");
> +		kfree(buf);
> +		return dba;
> +	}
> +
> +	buf->dma_dir = dma_dir;
> +	buf->size = size;
> +	buf->db_attach = dba;
> +
> +	return buf;
> +}
> +
>  static void *vb2_dma_sg_cookie(void *buf_priv)
>  {
>  	struct vb2_dma_sg_buf *buf = buf_priv;
> 
> -	return &buf->sg_table;
> +	return buf->dma_sgt;
>  }
> 
>  const struct vb2_mem_ops vb2_dma_sg_memops = {
> @@ -402,6 +521,10 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
>  	.vaddr		= vb2_dma_sg_vaddr,
>  	.mmap		= vb2_dma_sg_mmap,
>  	.num_users	= vb2_dma_sg_num_users,
> +	.map_dmabuf	= vb2_dma_sg_map_dmabuf,
> +	.unmap_dmabuf	= vb2_dma_sg_unmap_dmabuf,
> +	.attach_dmabuf	= vb2_dma_sg_attach_dmabuf,
> +	.detach_dmabuf	= vb2_dma_sg_detach_dmabuf,
>  	.cookie		= vb2_dma_sg_cookie,
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_sg_memops);

-- 
Regards,

Laurent Pinchart

