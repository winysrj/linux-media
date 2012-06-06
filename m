Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44007 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab2FFIFm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 04:05:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCH 11/12] v4l: vb2-dma-contig: use sg_alloc_table_from_pages function
Date: Wed, 06 Jun 2012 10:05:41 +0200
Message-ID: <3795802.eekr7JsUpA@avalon>
In-Reply-To: <1337778455-27912-12-git-send-email-t.stanislaws@samsung.com>
References: <1337778455-27912-1-git-send-email-t.stanislaws@samsung.com> <1337778455-27912-12-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Wednesday 23 May 2012 15:07:34 Tomasz Stanislawski wrote:
> This patch makes use of sg_alloc_table_from_pages to simplify
> handling of sg tables.

Would you mind moving this patch before 04/12, to avoid introducing a 
vb2_dc_pages_to_sgt() user only to remove it in this patch ? Otherwise this 
looks good.

> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |   90 +++++++------------------
>  1 file changed, 25 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 59ee81c..b5caf1d 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -32,7 +32,7 @@ struct vb2_dc_buf {
>  	/* MMAP related */
>  	struct vb2_vmarea_handler	handler;
>  	atomic_t			refcount;
> -	struct sg_table			*sgt_base;
> +	struct sg_table			sgt_base;
> 
>  	/* USERPTR related */
>  	struct vm_area_struct		*vma;
> @@ -45,57 +45,6 @@ struct vb2_dc_buf {
>  /*        scatterlist table functions        */
>  /*********************************************/
> 
> -static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
> -	unsigned int n_pages, unsigned long offset, unsigned long size)
> -{
> -	struct sg_table *sgt;
> -	unsigned int chunks;
> -	unsigned int i;
> -	unsigned int cur_page;
> -	int ret;
> -	struct scatterlist *s;
> -
> -	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
> -	if (!sgt)
> -		return ERR_PTR(-ENOMEM);
> -
> -	/* compute number of chunks */
> -	chunks = 1;
> -	for (i = 1; i < n_pages; ++i)
> -		if (pages[i] != pages[i - 1] + 1)
> -			++chunks;
> -
> -	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
> -	if (ret) {
> -		kfree(sgt);
> -		return ERR_PTR(-ENOMEM);
> -	}
> -
> -	/* merging chunks and putting them into the scatterlist */
> -	cur_page = 0;
> -	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
> -		unsigned long chunk_size;
> -		unsigned int j;
> -
> -		for (j = cur_page + 1; j < n_pages; ++j)
> -			if (pages[j] != pages[j - 1] + 1)
> -				break;
> -
> -		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
> -		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
> -		size -= chunk_size;
> -		offset = 0;
> -		cur_page = j;
> -	}
> -
> -	return sgt;
> -}
> -
> -static void vb2_dc_release_sgtable(struct sg_table *sgt)
> -{
> -	sg_free_table(sgt);
> -	kfree(sgt);
> -}
> 
>  static void vb2_dc_sgt_foreach_page(struct sg_table *sgt,
>  	void (*cb)(struct page *pg))
> @@ -190,7 +139,7 @@ static void vb2_dc_put(void *buf_priv)
>  	if (!atomic_dec_and_test(&buf->refcount))
>  		return;
> 
> -	vb2_dc_release_sgtable(buf->sgt_base);
> +	sg_free_table(&buf->sgt_base);
>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
>  	kfree(buf);
>  }
> @@ -254,9 +203,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
> size) goto fail_pages;
>  	}
> 
> -	buf->sgt_base = vb2_dc_pages_to_sgt(pages, n_pages, 0, size);
> -	if (IS_ERR(buf->sgt_base)) {
> -		ret = PTR_ERR(buf->sgt_base);
> +	ret = sg_alloc_table_from_pages(&buf->sgt_base,
> +		pages, n_pages, 0, size, GFP_KERNEL);
> +	if (ret) {
>  		dev_err(dev, "failed to prepare sg table\n");
>  		goto fail_pages;
>  	}
> @@ -379,13 +328,13 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>  	attach->dir = dir;
> 
>  	/* copying the buf->base_sgt to attachment */
> -	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
> +	ret = sg_alloc_table(sgt, buf->sgt_base.orig_nents, GFP_KERNEL);
>  	if (ret) {
>  		kfree(attach);
>  		return ERR_PTR(-ENOMEM);
>  	}
> 
> -	rd = buf->sgt_base->sgl;
> +	rd = buf->sgt_base.sgl;
>  	wr = sgt->sgl;
>  	for (i = 0; i < sgt->orig_nents; ++i) {
>  		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> @@ -519,7 +468,8 @@ static void vb2_dc_put_userptr(void *buf_priv)
>  	if (!vma_is_io(buf->vma))
>  		vb2_dc_sgt_foreach_page(sgt, vb2_dc_put_dirty_page);
> 
> -	vb2_dc_release_sgtable(sgt);
> +	sg_free_table(sgt);
> +	kfree(sgt);
>  	vb2_put_vma(buf->vma);
>  	kfree(buf);
>  }
> @@ -586,13 +536,20 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, goto fail_vma;
>  	}
> 
> -	sgt = vb2_dc_pages_to_sgt(pages, n_pages, offset, size);
> -	if (IS_ERR(sgt)) {
> -		printk(KERN_ERR "failed to create scatterlist table\n");
> +	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
> +	if (!sgt) {
> +		printk(KERN_ERR "failed to allocate sg table\n");
>  		ret = -ENOMEM;
>  		goto fail_get_user_pages;
>  	}
> 
> +	ret = sg_alloc_table_from_pages(sgt, pages, n_pages,
> +		offset, size, GFP_KERNEL);
> +	if (ret) {
> +		printk(KERN_ERR "failed to initialize sg table\n");
> +		goto fail_sgt;
> +	}
> +
>  	/* pages are no longer needed */
>  	kfree(pages);
>  	pages = NULL;
> @@ -602,7 +559,7 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, if (sgt->nents <= 0) {
>  		printk(KERN_ERR "failed to map scatterlist\n");
>  		ret = -EIO;
> -		goto fail_sgt;
> +		goto fail_sgt_init;
>  	}
> 
>  	contig_size = vb2_dc_get_contiguous_size(sgt);
> @@ -622,10 +579,13 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
> unsigned long vaddr, fail_map_sg:
>  	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> 
> -fail_sgt:
> +fail_sgt_init:
>  	if (!vma_is_io(buf->vma))
>  		vb2_dc_sgt_foreach_page(sgt, put_page);
> -	vb2_dc_release_sgtable(sgt);
> +	sg_free_table(sgt);
> +
> +fail_sgt:
> +	kfree(sgt);
> 
>  fail_get_user_pages:
>  	if (pages && !vma_is_io(buf->vma))
-- 
Regards,

Laurent Pinchart

