Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46382 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab2DQOIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 10:08:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [RFC 05/13] v4l: vb2-dma-contig: add support for DMABUF exporting
Date: Tue, 17 Apr 2012 16:08:50 +0200
Message-ID: <3143149.ZCeOjVLXgh@avalon>
In-Reply-To: <1334063447-16824-6-git-send-email-t.stanislaws@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com> <1334063447-16824-6-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Tuesday 10 April 2012 15:10:39 Tomasz Stanislawski wrote:
> This patch adds support for exporting a dma-contig buffer using
> DMABUF interface.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/videobuf2-dma-contig.c |  128 +++++++++++++++++++++++++
>  1 files changed, 128 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-contig.c
> b/drivers/media/video/videobuf2-dma-contig.c index 0cdcd2b..e1ad47e 100644
> --- a/drivers/media/video/videobuf2-dma-contig.c
> +++ b/drivers/media/video/videobuf2-dma-contig.c
> @@ -31,6 +31,7 @@ struct vb2_dc_buf {
>  	/* MMAP related */
>  	struct vb2_vmarea_handler	handler;
>  	atomic_t			refcount;
> +	struct dma_buf			*dma_buf;
>  	struct sg_table			*sgt_base;
> 
>  	/* USERPTR related */
> @@ -190,6 +191,8 @@ static void vb2_dc_put(void *buf_priv)
>  	if (!atomic_dec_and_test(&buf->refcount))
>  		return;
> 
> +	if (buf->dma_buf)
> +		dma_buf_put(buf->dma_buf);
>  	vb2_dc_release_sgtable(buf->sgt_base);
>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
>  	kfree(buf);
> @@ -306,6 +309,130 @@ static int vb2_dc_mmap(void *buf_priv, struct
> vm_area_struct *vma) }
> 
>  /*********************************************/
> +/*         DMABUF ops for exporters          */
> +/*********************************************/
> +
> +struct vb2_dc_attachment {
> +	struct sg_table sgt;
> +	enum dma_data_direction dir;
> +};
> +
> +static int vb2_dc_dmabuf_ops_attach(struct dma_buf *dbuf, struct device
> *dev,
> +	struct dma_buf_attachment *dbuf_attach)
> +{
> +	/* nothing to be done */
> +	return 0;
> +}
> +
> +static void vb2_dc_dmabuf_ops_detach(struct dma_buf *dbuf,
> +	struct dma_buf_attachment *db_attach)
> +{
> +	struct vb2_dc_attachment *attach = db_attach->priv;
> +	struct sg_table *sgt;
> +
> +	if (!attach)
> +		return;
> +
> +	sgt = &attach->sgt;
> +
> +	dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->nents, attach->dir);
> +	sg_free_table(sgt);
> +	kfree(attach);
> +	db_attach->priv = NULL;
> +}
> +
> +static struct sg_table *vb2_dc_dmabuf_ops_map(
> +	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
> +{
> +	struct dma_buf *dbuf = db_attach->dmabuf;
> +	struct vb2_dc_buf *buf = dbuf->priv;
> +	struct vb2_dc_attachment *attach = db_attach->priv;
> +	struct sg_table *sgt;
> +	struct scatterlist *rd, *wr;
> +	int i, ret;

You can make i an unsigned int :-)

> +
> +	/* return previously mapped sg table */
> +	if (attach)
> +		return &attach->sgt;

This effectively keeps the mapping around as long as the attachment exists. We 
don't try to swap out buffers in V4L2 as is done in DRM at the moment, so it 
might not be too much of an issue, but the behaviour of the implementation 
will change if we later decide to map/unmap the buffers in the map/unmap 
handlers. Do you think that could be a problem ?

> +
> +	attach = kzalloc(sizeof *attach, GFP_KERNEL);
> +	if (!attach)
> +		return ERR_PTR(-ENOMEM);

Why don't you allocate the vb2_dc_attachment here instead of 
vb2_dc_dmabuf_ops_attach() ?

> +	sgt = &attach->sgt;
> +	attach->dir = dir;
> +
> +	/* copying the buf->base_sgt to attachment */

I would add an explanation regarding why you need to copy the SG list. 
Something like.

"Copy the buf->base_sgt scatter list to the attachment, as we can't map the 
same scatter list to multiple devices at the same time."

> +	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
> +	if (ret) {
> +		kfree(attach);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +
> +	rd = buf->sgt_base->sgl;
> +	wr = sgt->sgl;
> +	for (i = 0; i < sgt->orig_nents; ++i) {
> +		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> +		rd = sg_next(rd);
> +		wr = sg_next(wr);
> +	}
>
> +	/* mapping new sglist to the client */
> +	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
> +	if (ret <= 0) {
> +		printk(KERN_ERR "failed to map scatterlist\n");
> +		sg_free_table(sgt);
> +		kfree(attach);
> +		return ERR_PTR(-EIO);
> +	}
> +
> +	db_attach->priv = attach;
> +
> +	return sgt;
> +}
> +
> +static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment *db_attach,
> +	struct sg_table *sgt, enum dma_data_direction dir)
> +{
> +	/* nothing to be done here */
> +}
> +
> +static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
> +{
> +	/* drop reference obtained in vb2_dc_get_dmabuf */
> +	vb2_dc_put(dbuf->priv);

Shouldn't you set vb2_dc_buf::dma_buf to NULL here ? Otherwise the next 
vb2_dc_get_dmabuf() call will return a DMABUF object that has been freed.

> +}
> +
> +static struct dma_buf_ops vb2_dc_dmabuf_ops = {
> +	.attach = vb2_dc_dmabuf_ops_attach,
> +	.detach = vb2_dc_dmabuf_ops_detach,
> +	.map_dma_buf = vb2_dc_dmabuf_ops_map,
> +	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
> +	.release = vb2_dc_dmabuf_ops_release,
> +};
> +
> +static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
> +{
> +	struct vb2_dc_buf *buf = buf_priv;
> +	struct dma_buf *dbuf;
> +
> +	if (buf->dma_buf)
> +		return buf->dma_buf;

Can't there be a race condition here if the user closes the DMABUF file handle 
before vb2 core calls dma_buf_fd() ?

> +	/* dmabuf keeps reference to vb2 buffer */
> +	atomic_inc(&buf->refcount);
> +	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
> +	if (IS_ERR(dbuf)) {
> +		atomic_dec(&buf->refcount);
> +		return NULL;
> +	}
> +
> +	buf->dma_buf = dbuf;
> +
> +	return dbuf;
> +}
> +
> +/*********************************************/
>  /*       callbacks for USERPTR buffers       */
>  /*********************************************/
> 
> @@ -615,6 +742,7 @@ static void *vb2_dc_attach_dmabuf(void *alloc_ctx,
> struct dma_buf *dbuf, const struct vb2_mem_ops vb2_dma_contig_memops = {
>  	.alloc		= vb2_dc_alloc,
>  	.put		= vb2_dc_put,
> +	.get_dmabuf	= vb2_dc_get_dmabuf,
>  	.cookie		= vb2_dc_cookie,
>  	.vaddr		= vb2_dc_vaddr,
>  	.mmap		= vb2_dc_mmap,
-- 
Regards,

Laurent Pinchart

