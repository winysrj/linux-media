Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64230 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbbBKIGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Feb 2015 03:06:32 -0500
Message-id: <54DB0D84.7020600@samsung.com>
Date: Wed, 11 Feb 2015 09:06:28 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] media/videobuf2-dma-sg: Fix handling of sg_table
 structure
References: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1423498466-16718-1-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-02-09 17:14, Ricardo Ribalda Delgado wrote:
> when sg_alloc_table_from_pages() does not fail it returns a sg_table
> structure with nents and nents_orig initialized to the same value.
>
> dma_map_sg returns the dma_map_sg returns the number of areas mapped
> by the hardware, which could be different than the areas given as an input.
> The output must be saved to nent.

Thanks for catching this issue!

> Unfortunately nent differs in sign to the output of dma_map_sg, so an
> intermediate value must be used.

I don't get this part. dma_map_sg() returns the number of scatter list 
entries mapped
to the hardware or zero if anything fails. What is the problem of 
assigning it directly
to nents?

> The output of dma_map, should be used to transverse the scatter list.
>
> dma_unmap_sg needs the value passed to dma_map_sg (nents_orig).
>
> sg_free_tables uses also orig_nent.
>
> This patch fix the file to follow this paradigm.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>   drivers/media/v4l2-core/videobuf2-dma-sg.c | 22 +++++++++++++++-------
>   1 file changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index b1838ab..30bac99 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -147,9 +147,11 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned long size,
>   	 * No need to sync to the device, this will happen later when the
>   	 * prepare() memop is called.
>   	 */
> -	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
> -			     buf->dma_dir, &attrs) == 0)
> +	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> +			buf->dma_dir, &attrs);
> +	if (ret <= 0)
>   		goto fail_map;
> +	sgt->nents = ret;
>   
>   	buf->handler.refcount = &buf->refcount;
>   	buf->handler.put = vb2_dma_sg_put;
> @@ -187,7 +189,7 @@ static void vb2_dma_sg_put(void *buf_priv)
>   		dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
>   		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
>   			buf->num_pages);
> -		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
> +		dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
>   				   buf->dma_dir, &attrs);
>   		if (buf->vaddr)
>   			vm_unmap_ram(buf->vaddr, buf->num_pages);
> @@ -240,6 +242,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	struct vm_area_struct *vma;
>   	struct sg_table *sgt;
>   	DEFINE_DMA_ATTRS(attrs);
> +	int ret;
>   
>   	dma_set_attr(DMA_ATTR_SKIP_CPU_SYNC, &attrs);
>   
> @@ -314,9 +317,12 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx, unsigned long vaddr,
>   	 * No need to sync to the device, this will happen later when the
>   	 * prepare() memop is called.
>   	 */
> -	if (dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->nents,
> -			     buf->dma_dir, &attrs) == 0)
> +	ret = dma_map_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> +			     buf->dma_dir, &attrs);
> +	if (ret <= 0)
>   		goto userptr_fail_map;

dma_map_sg_attrs() return 0 in case of error, so the check can be 
simplified,
there is no need for temporary variable.

> +	sgt->nents = ret;
> +
>   	return buf;
>   
>   userptr_fail_map:
> @@ -351,7 +357,8 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>   
>   	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
>   	       __func__, buf->num_pages);
> -	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir, &attrs);
> +	dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir,
> +			&attrs);
>   	if (buf->vaddr)
>   		vm_unmap_ram(buf->vaddr, buf->num_pages);
>   	sg_free_table(buf->dma_sgt);
> @@ -463,7 +470,7 @@ static int vb2_dma_sg_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev
>   
>   	rd = buf->dma_sgt->sgl;
>   	wr = sgt->sgl;
> -	for (i = 0; i < sgt->orig_nents; ++i) {
> +	for (i = 0; i < sgt->nents; ++i) {

Here the code iterates over every memory page in the scatter list (to create
a copy of it), not the device mapped chunks, so it must use orig_nents
like it was already there.

>   		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
>   		rd = sg_next(rd);
>   		wr = sg_next(wr);
> @@ -527,6 +534,7 @@ static struct sg_table *vb2_dma_sg_dmabuf_ops_map(
>   		mutex_unlock(lock);
>   		return ERR_PTR(-EIO);
>   	}
> +	sgt->nents = ret;

This one is okay.

>   
>   	attach->dma_dir = dma_dir;
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

