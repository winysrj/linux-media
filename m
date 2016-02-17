Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:40406 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423602AbcBQRAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 12:00:13 -0500
Subject: Re: [PATCH v6 4/5] videobuf2-dc: Let drivers specify DMA attrs
To: Douglas Anderson <dianders@chromium.org>, linux@arm.linux.org.uk,
	mchehab@osg.samsung.com, robin.murphy@arm.com, tfiga@chromium.org,
	m.szyprowski@samsung.com
References: <1452533428-12762-1-git-send-email-dianders@chromium.org>
 <1452533428-12762-5-git-send-email-dianders@chromium.org>
Cc: pawel@osciak.com, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	hch@infradead.org, kyungmin.park@samsung.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C4A712.4050403@xs4all.nl>
Date: Wed, 17 Feb 2016 18:00:02 +0100
MIME-Version: 1.0
In-Reply-To: <1452533428-12762-5-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Doug,

Is there any reason to think that different planes will need different
DMA attrs? I ask because this patch series of mine:

http://www.spinics.net/lists/linux-media/msg97522.html

does away with allocating allocation contexts (struct vb2_dc_conf).

For dma_attr this would mean that struct dma_attrs would probably be implemented
as a struct dma_attrs pointer in the vb2_queue struct once I rebase that patch series
on top of this patch. In other words, the same dma_attrs struct would be used for all
planes.

Second question: would specifying dma_attrs also make sense for videobuf2-dma-sg.c?

Regards,

	Hans

On 01/11/2016 06:30 PM, Douglas Anderson wrote:
> From: Tomasz Figa <tfiga@chromium.org>
> 
> DMA allocations might be subject to certain reqiurements specific to the
> hardware using the buffers, such as availability of kernel mapping (for
> contents fix-ups in the driver). The only entity that knows them is the
> driver, so it must share this knowledge with vb2-dc.
> 
> This patch extends the alloc_ctx initialization interface to let the
> driver specify DMA attrs, which are then stored inside the allocation
> context and will be used for all allocations with that context.
> 
> As a side effect, all dma_*_coherent() calls are turned into
> dma_*_attrs() calls, because the attributes need to be carried over
> through all DMA operations.
> 
> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> Changes in v6: None
> Changes in v5:
> - Let drivers specify DMA attrs new for v5
> 
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 33 +++++++++++++++++---------
>  include/media/videobuf2-dma-contig.h           | 11 ++++++++-
>  2 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index c33127284cfe..5361197f3e57 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -23,13 +23,16 @@
>  
>  struct vb2_dc_conf {
>  	struct device		*dev;
> +	struct dma_attrs	attrs;
>  };
>  
>  struct vb2_dc_buf {
>  	struct device			*dev;
>  	void				*vaddr;
>  	unsigned long			size;
> +	void				*cookie;
>  	dma_addr_t			dma_addr;
> +	struct dma_attrs		attrs;
>  	enum dma_data_direction		dma_dir;
>  	struct sg_table			*dma_sgt;
>  	struct frame_vector		*vec;
> @@ -131,7 +134,8 @@ static void vb2_dc_put(void *buf_priv)
>  		sg_free_table(buf->sgt_base);
>  		kfree(buf->sgt_base);
>  	}
> -	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
> +	dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
> +			&buf->attrs);
>  	put_device(buf->dev);
>  	kfree(buf);
>  }
> @@ -147,14 +151,18 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long size,
>  	if (!buf)
>  		return ERR_PTR(-ENOMEM);
>  
> -	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr,
> -						GFP_KERNEL | gfp_flags);
> -	if (!buf->vaddr) {
> +	buf->attrs = conf->attrs;
> +	buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
> +					GFP_KERNEL | gfp_flags, &buf->attrs);
> +	if (!buf->cookie) {
>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
>  		kfree(buf);
>  		return ERR_PTR(-ENOMEM);
>  	}
>  
> +	if (!dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, &buf->attrs))
> +		buf->vaddr = buf->cookie;
> +
>  	/* Prevent the device from being released while the buffer is used */
>  	buf->dev = get_device(dev);
>  	buf->size = size;
> @@ -185,8 +193,8 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
>  	 */
>  	vma->vm_pgoff = 0;
>  
> -	ret = dma_mmap_coherent(buf->dev, vma, buf->vaddr,
> -		buf->dma_addr, buf->size);
> +	ret = dma_mmap_attrs(buf->dev, vma, buf->cookie,
> +		buf->dma_addr, buf->size, &buf->attrs);
>  
>  	if (ret) {
>  		pr_err("Remapping memory failed, error: %d\n", ret);
> @@ -329,7 +337,7 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
>  {
>  	struct vb2_dc_buf *buf = dbuf->priv;
>  
> -	return buf->vaddr + pgnum * PAGE_SIZE;
> +	return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
>  }
>  
>  static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> @@ -368,8 +376,8 @@ static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
>  		return NULL;
>  	}
>  
> -	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
> -		buf->size);
> +	ret = dma_get_sgtable_attrs(buf->dev, sgt, buf->cookie, buf->dma_addr,
> +		buf->size, &buf->attrs);
>  	if (ret < 0) {
>  		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
>  		kfree(sgt);
> @@ -721,7 +729,8 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
>  
> -void *vb2_dma_contig_init_ctx(struct device *dev)
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				    struct dma_attrs *attrs)
>  {
>  	struct vb2_dc_conf *conf;
>  
> @@ -730,10 +739,12 @@ void *vb2_dma_contig_init_ctx(struct device *dev)
>  		return ERR_PTR(-ENOMEM);
>  
>  	conf->dev = dev;
> +	if (attrs)
> +		conf->attrs = *attrs;
>  
>  	return conf;
>  }
> -EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
> +EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx_attrs);
>  
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)
>  {
> diff --git a/include/media/videobuf2-dma-contig.h b/include/media/videobuf2-dma-contig.h
> index c33dfa69d7ab..2087c9a68be3 100644
> --- a/include/media/videobuf2-dma-contig.h
> +++ b/include/media/videobuf2-dma-contig.h
> @@ -16,6 +16,8 @@
>  #include <media/videobuf2-v4l2.h>
>  #include <linux/dma-mapping.h>
>  
> +struct dma_attrs;
> +
>  static inline dma_addr_t
>  vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>  {
> @@ -24,7 +26,14 @@ vb2_dma_contig_plane_dma_addr(struct vb2_buffer *vb, unsigned int plane_no)
>  	return *addr;
>  }
>  
> -void *vb2_dma_contig_init_ctx(struct device *dev);
> +void *vb2_dma_contig_init_ctx_attrs(struct device *dev,
> +				    struct dma_attrs *attrs);
> +
> +static inline void *vb2_dma_contig_init_ctx(struct device *dev)
> +{
> +	return vb2_dma_contig_init_ctx_attrs(dev, NULL);
> +}
> +
>  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx);
>  
>  extern const struct vb2_mem_ops vb2_dma_contig_memops;
> 

