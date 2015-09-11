Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46700 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751749AbbIKRaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 13:30:00 -0400
Message-ID: <55F30F50.6090902@xs4all.nl>
Date: Fri, 11 Sep 2015 19:28:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
CC: pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@linaro.org,
	robdclark@gmail.com, daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 07/11] vb2: dma-contig: Remove redundant sgt_base
 field
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441972234-8643-8-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/11/2015 01:50 PM, Sakari Ailus wrote:
> The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
> dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
> by USERPTR.
> 
> Unify the two, leaving dma_sgt.
> 
> MMAP buffers do not need cache flushing since they have been allocated
> using dma_alloc_coherent().

I would have to see this again after it is rebased on 4.3-rc1. That will contain
Jan Kara's vb2 changes which might well affect this patch.

Are there use-cases where we want to allocate non-coherent memory? I know we
don't support this today, but is this something we might want in the future?

Just curious.

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index 94c1e64..26a0a0f 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -36,7 +36,6 @@ struct vb2_dc_buf {
>  	/* MMAP related */
>  	struct vb2_vmarea_handler	handler;
>  	atomic_t			refcount;
> -	struct sg_table			*sgt_base;
>  
>  	/* USERPTR related */
>  	struct vm_area_struct		*vma;
> @@ -117,7 +116,7 @@ static void vb2_dc_prepare(void *buf_priv)
>  	struct sg_table *sgt = buf->dma_sgt;
>  
>  	/* DMABUF exporter will flush the cache for us */
> -	if (!sgt || buf->db_attach)
> +	if (!buf->vma)
>  		return;
>  
>  	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> @@ -129,7 +128,7 @@ static void vb2_dc_finish(void *buf_priv)
>  	struct sg_table *sgt = buf->dma_sgt;
>  
>  	/* DMABUF exporter will flush the cache for us */
> -	if (!sgt || buf->db_attach)
> +	if (!buf->vma)
>  		return;
>  
>  	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> @@ -146,9 +145,9 @@ static void vb2_dc_put(void *buf_priv)
>  	if (!atomic_dec_and_test(&buf->refcount))
>  		return;
>  
> -	if (buf->sgt_base) {
> -		sg_free_table(buf->sgt_base);
> -		kfree(buf->sgt_base);
> +	if (buf->dma_sgt) {
> +		sg_free_table(buf->dma_sgt);
> +		kfree(buf->dma_sgt);
>  	}
>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
>  	put_device(buf->dev);
> @@ -252,13 +251,13 @@ static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device *dev,
>  	/* Copy the buf->base_sgt scatter list to the attachment, as we can't
>  	 * map the same scatter list to multiple attachments at the same time.
>  	 */
> -	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
> +	ret = sg_alloc_table(sgt, buf->dma_sgt->orig_nents, GFP_KERNEL);
>  	if (ret) {
>  		kfree(attach);
>  		return -ENOMEM;
>  	}
>  
> -	rd = buf->sgt_base->sgl;
> +	rd = buf->dma_sgt->sgl;
>  	wr = sgt->sgl;
>  	for (i = 0; i < sgt->orig_nents; ++i) {
>  		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> @@ -409,10 +408,10 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
>  	exp_info.flags = flags;
>  	exp_info.priv = buf;
>  
> -	if (!buf->sgt_base)
> -		buf->sgt_base = vb2_dc_get_base_sgt(buf);
> +	if (!buf->dma_sgt)
> +		buf->dma_sgt = vb2_dc_get_base_sgt(buf);
>  
> -	if (WARN_ON(!buf->sgt_base))
> +	if (WARN_ON(!buf->dma_sgt))
>  		return NULL;
>  
>  	dbuf = dma_buf_export(&exp_info);
> 

