Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57860 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab2DFPMw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 11:12:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH 11/11] v4l: vb2: Add dma-contig allocator as dma_buf user
Date: Fri, 06 Apr 2012 17:12:56 +0200
Message-ID: <3806078.bLkgp7kyMX@avalon>
In-Reply-To: <1333634408-4960-12-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com> <1333634408-4960-12-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 05 April 2012 16:00:08 Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> This patch makes changes for adding dma-contig as a dma_buf user. It
> provides function implementations for the {attach, detach, map,
> unmap}_dmabuf() mem_ops of DMABUF memory type.
> 
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> 	[author of the original patch]
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> 	[integration with refactored dma-contig allocator]
> ---
>  drivers/media/video/videobuf2-dma-contig.c |  117 +++++++++++++++++++++++++
>  1 files changed, 117 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 30f316588..6329483
> 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -10,6 +10,7 @@
>   * the Free Software Foundation.
>   */
> 
> +#include <linux/dma-buf.h>
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
>  #include <linux/sched.h>
> @@ -33,6 +34,9 @@ struct vb2_dc_buf {
> 
>  	/* USERPTR related */
>  	struct vm_area_struct		*vma;
> +
> +	/* DMABUF related */
> +	struct dma_buf_attachment	*db_attach;
>  };
> 
>  /*********************************************/
> @@ -425,6 +429,115 @@ fail_buf:
>  }
> 
>  /*********************************************/
> +/*       callbacks for DMABUF buffers        */
> +/*********************************************/
> +
> +static int vb2_dc_map_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dc_buf *buf = mem_priv;
> +	struct sg_table *sgt;
> +	unsigned long contig_size;
> +	int ret = 0;
> +
> +	if (WARN_ON(!buf->db_attach)) {
> +		printk(KERN_ERR "trying to pin a non attached buffer\n");
> +		return -EINVAL;
> +	}
> +
> +	if (WARN_ON(buf->dma_sgt)) {
> +		printk(KERN_ERR "dmabuf buffer is already pinned\n");
> +		return 0;
> +	}
> +
> +	/* get the associated scatterlist for this buffer */
> +	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
> +	if (IS_ERR_OR_NULL(sgt)) {
> +		printk(KERN_ERR "Error getting dmabuf scatterlist\n");
> +		return -EINVAL;
> +	}
> +
> +	/* checking if dmabuf is big enough to store contiguous chunk */
> +	contig_size = vb2_dc_get_contiguous_size(sgt);
> +	if (contig_size < buf->size) {
> +		printk(KERN_ERR "contiguous chunk of dmabuf is too small\n");
> +		ret = -EFAULT;
> +		goto fail_map;

The fail_map label is only used here, you can move the 
dma_buf_unmap_attachment() call here and return -EFAULT directly.

> +	}
> +
> +	buf->dma_addr = sg_dma_address(sgt->sgl);
> +	buf->dma_sgt = sgt;
> +
> +	return 0;
> +
> +fail_map:
> +	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
> +
> +	return ret;
> +}
> +
> +static void vb2_dc_unmap_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dc_buf *buf = mem_priv;
> +	struct sg_table *sgt = buf->dma_sgt;
> +
> +	if (WARN_ON(!buf->db_attach)) {
> +		printk(KERN_ERR "trying to unpin a not attached buffer\n");
> +		return;
> +	}
> +
> +	if (WARN_ON(!sgt)) {
> +		printk(KERN_ERR "dmabuf buffer is already unpinned\n");
> +		return;
> +	}
> +
> +	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
> +
> +	buf->dma_addr = 0;
> +	buf->dma_sgt = NULL;
> +}
> +
> +static void vb2_dc_detach_dmabuf(void *mem_priv)
> +{
> +	struct vb2_dc_buf *buf = mem_priv;
> +
> +	if (buf->dma_addr)
> +		vb2_dc_unmap_dmabuf(buf);

What would you think about calling vb2_dc_unmap_dmabuf() from vb2 core 
instead, to keep the map/unmap calls symmetrical (the second WARN_ON and the 
related printk in vb2_dc_unmap_dmabuf() might need to go then) ?

> +	/* detach this attachment */
> +	dma_buf_detach(buf->db_attach->dmabuf, buf->db_attach);
> +	kfree(buf);
> +}
> +
> +static void *vb2_dc_attach_dmabuf(void *alloc_ctx, struct dma_buf *dbuf,
> +	unsigned long size, int write)
> +{
> +	struct vb2_dc_buf *buf;
> +	struct dma_buf_attachment *dba;
> +
> +	if (dbuf->size < size)
> +		return ERR_PTR(-EFAULT);
> +
> +	buf = kzalloc(sizeof *buf, GFP_KERNEL);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	buf->dev = alloc_ctx;
> +	/* create attachment for the dmabuf with the user device */
> +	dba = dma_buf_attach(dbuf, buf->dev);
> +	if (IS_ERR(dba)) {
> +		printk(KERN_ERR "failed to attach dmabuf\n");
> +		kfree(buf);
> +		return dba;
> +	}
> +
> +	buf->dma_dir = write ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	buf->size = size;
> +	buf->db_attach = dba;
> +
> +	return buf;
> +}
> +
> +/*********************************************/
>  /*       DMA CONTIG exported functions       */
>  /*********************************************/
> 
> @@ -438,6 +551,10 @@ const struct vb2_mem_ops vb2_dma_contig_memops = {
>  	.put_userptr	= vb2_dc_put_userptr,
>  	.prepare	= vb2_dc_prepare,
>  	.finish		= vb2_dc_finish,
> +	.map_dmabuf	= vb2_dc_map_dmabuf,
> +	.unmap_dmabuf	= vb2_dc_unmap_dmabuf,
> +	.attach_dmabuf	= vb2_dc_attach_dmabuf,
> +	.detach_dmabuf	= vb2_dc_detach_dmabuf,
>  	.num_users	= vb2_dc_num_users,
>  };
>  EXPORT_SYMBOL_GPL(vb2_dma_contig_memops);
-- 
Regards,

Laurent Pinchart

