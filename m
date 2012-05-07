Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42497 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab2EGN1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2012 09:27:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	mchehab@redhat.com
Subject: Re: [RFC 05/13] v4l: vb2-dma-contig: add support for DMABUF exporting
Date: Mon, 07 May 2012 15:27:36 +0200
Message-ID: <1813415.rG2izL3i2h@avalon>
In-Reply-To: <4F8FEC04.3030700@samsung.com>
References: <1334063447-16824-1-git-send-email-t.stanislaws@samsung.com> <3143149.ZCeOjVLXgh@avalon> <4F8FEC04.3030700@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Sorry for the late reply, this one slipped through the cracks.

On Thursday 19 April 2012 12:42:12 Tomasz Stanislawski wrote:
> On 04/17/2012 04:08 PM, Laurent Pinchart wrote:
> > On Tuesday 10 April 2012 15:10:39 Tomasz Stanislawski wrote:
> >> This patch adds support for exporting a dma-contig buffer using
> >> DMABUF interface.
> >> 
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> ---
> 
> [snip]
> 
> >> +static struct sg_table *vb2_dc_dmabuf_ops_map(
> >> +	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
> >> +{
> >> +	struct dma_buf *dbuf = db_attach->dmabuf;
> >> +	struct vb2_dc_buf *buf = dbuf->priv;
> >> +	struct vb2_dc_attachment *attach = db_attach->priv;
> >> +	struct sg_table *sgt;
> >> +	struct scatterlist *rd, *wr;
> >> +	int i, ret;
> > 
> > You can make i an unsigned int :-)
> 
> Right.. splitting declaration may be also a good idea :)
> 
> >> +
> >> +	/* return previously mapped sg table */
> >> +	if (attach)
> >> +		return &attach->sgt;
> > 
> > This effectively keeps the mapping around as long as the attachment
> > exists. We don't try to swap out buffers in V4L2 as is done in DRM at the
> > moment, so it might not be too much of an issue, but the behaviour of the
> > implementation will change if we later decide to map/unmap the buffers in
> > the map/unmap handlers. Do you think that could be a problem ?
> 
> I don't that it is a problem. If an importer calls dma_map_sg then caching
> sgt on an exporter side reduces a cost of an allocating and an
> initialization of sgt.
> 
> >> +
> >> +	attach = kzalloc(sizeof *attach, GFP_KERNEL);
> >> +	if (!attach)
> >> +		return ERR_PTR(-ENOMEM);
> > 
> > Why don't you allocate the vb2_dc_attachment here instead of
> > vb2_dc_dmabuf_ops_attach() ?
> 
> Good point.
> The attachment could be allocated at vb2_dc_attachment but all its
> fields would be uninitialized. I mean an empty sgt and an undefined
> dma direction. I decided to allocate the attachment in vb2_dc_dmabuf_ops_map
> because only than all information needed to create a valid attachment
> object are available.
> 
> The other solution might be the allocation at vb2_dc_attachment. The field
> dir would be set to DMA_NONE. If this filed is equal to DMA_NONE at
> vb2_dc_dmabuf_ops_map then sgt is allocated and mapped and direction field
> is updated. If value is not DMA_NONE then the sgt is reused.
> 
> Do you think that it is a good idea?

I think I would prefer that. It sounds more logical to allocate the attachment 
in the attach operation handler.

> >> +	sgt = &attach->sgt;
> >> +	attach->dir = dir;
> >> +
> >> +	/* copying the buf->base_sgt to attachment */
> > 
> > I would add an explanation regarding why you need to copy the SG list.
> > Something like.
> > 
> > "Copy the buf->base_sgt scatter list to the attachment, as we can't map
> > the same scatter list to multiple devices at the same time."
> 
> ok
> 
> >> +	ret = sg_alloc_table(sgt, buf->sgt_base->orig_nents, GFP_KERNEL);
> >> +	if (ret) {
> >> +		kfree(attach);
> >> +		return ERR_PTR(-ENOMEM);
> >> +	}
> >> +
> >> +	rd = buf->sgt_base->sgl;
> >> +	wr = sgt->sgl;
> >> +	for (i = 0; i < sgt->orig_nents; ++i) {
> >> +		sg_set_page(wr, sg_page(rd), rd->length, rd->offset);
> >> +		rd = sg_next(rd);
> >> +		wr = sg_next(wr);
> >> +	}
> >> 
> >> +	/* mapping new sglist to the client */
> >> +	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
> >> +	if (ret <= 0) {
> >> +		printk(KERN_ERR "failed to map scatterlist\n");
> >> +		sg_free_table(sgt);
> >> +		kfree(attach);
> >> +		return ERR_PTR(-EIO);
> >> +	}
> >> +
> >> +	db_attach->priv = attach;
> >> +
> >> +	return sgt;
> >> +}
> >> +
> >> +static void vb2_dc_dmabuf_ops_unmap(struct dma_buf_attachment
> >> *db_attach,
> >> +	struct sg_table *sgt, enum dma_data_direction dir)
> >> +{
> >> +	/* nothing to be done here */
> >> +}
> >> +
> >> +static void vb2_dc_dmabuf_ops_release(struct dma_buf *dbuf)
> >> +{
> >> +	/* drop reference obtained in vb2_dc_get_dmabuf */
> >> +	vb2_dc_put(dbuf->priv);
> > 
> > Shouldn't you set vb2_dc_buf::dma_buf to NULL here ? Otherwise the next
> > vb2_dc_get_dmabuf() call will return a DMABUF object that has been freed.
> 
> No.
> 
> The buffer object is destroyed at vb2_dc_put when reference count drops to
> 0. It happens could happen after only REQBUF(count=0) or on last close().
> The DMABUF object is created only for MMAP buffers. The DMABUF object is
> based only on results of dma_alloc_coherent and dma_get_pages (or its future
> equivalent). Therefore the DMABUF object is valid as long as the buffer is
> valid.

OK.

> Notice that dmabuf object could be created in vb2_dc_alloc. I moved it to
> vb2_dc_get_dmabuf to avoid a creation of an object that may not be used.
> 
> >> +}
> >> +
> >> +static struct dma_buf_ops vb2_dc_dmabuf_ops = {
> >> +	.attach = vb2_dc_dmabuf_ops_attach,
> >> +	.detach = vb2_dc_dmabuf_ops_detach,
> >> +	.map_dma_buf = vb2_dc_dmabuf_ops_map,
> >> +	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
> >> +	.release = vb2_dc_dmabuf_ops_release,
> >> +};
> >> +
> >> +static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
> >> +{
> >> +	struct vb2_dc_buf *buf = buf_priv;
> >> +	struct dma_buf *dbuf;
> >> +
> >> +	if (buf->dma_buf)
> >> +		return buf->dma_buf;
> > 
> > Can't there be a race condition here if the user closes the DMABUF file
> > handle before vb2 core calls dma_buf_fd() ?
> 
> The user cannot access the file until it is associated with a file
> descriptor. How can the user close it? Could you give me a more detailed
> description of this potential race condition?

Let's assume the V4L2 buffer has already been exported once. buf->dma_buf is 
set to a non-NULL value, and the application has an open file handle for the 
buffer. The application then tries to export the buffer a second time. 
vb2_dc_get_dmabuf() gets called, checks buf->dma_buf and returns it as it's 
non-NULL. Right after that, before the vb2 core calls dma_buf_fd() on the 
struct dma_buf, the application closes the file handle to the exported buffer. 
The struct dma_buf object gets freed, as the reference count drops to 0. The 
vb2 core will then try to call dma_buf_fd() on a dma_buf object that has been 
freed.

> >> +	/* dmabuf keeps reference to vb2 buffer */
> >> +	atomic_inc(&buf->refcount);
> >> +	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
> >> +	if (IS_ERR(dbuf)) {
> >> +		atomic_dec(&buf->refcount);
> >> +		return NULL;
> >> +	}
> >> +
> >> +	buf->dma_buf = dbuf;
> >> +
> >> +	return dbuf;
> >> +}

-- 
Regards,

Laurent Pinchart

