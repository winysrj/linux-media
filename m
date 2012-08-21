Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49445 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2HUNrZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 09:47:25 -0400
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M930000IYBO4B40@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Aug 2012 14:47:48 +0100 (BST)
Received: from [106.116.147.108] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M930044FYAQP360@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 21 Aug 2012 14:47:23 +0100 (BST)
Message-id: <50339161.9010209@samsung.com>
Date: Tue, 21 Aug 2012 15:47:13 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, dmitriyz@google.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv8 20/26] v4l: vb2-dma-contig: add support for DMABUF
 exporting
References: <1344958496-9373-1-git-send-email-t.stanislaws@samsung.com>
 <1344958496-9373-21-git-send-email-t.stanislaws@samsung.com>
 <1972504.ZFxOnMN9eT@avalon>
In-reply-to: <1972504.ZFxOnMN9eT@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thank you for your comments.

On 08/21/2012 12:03 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> Just a couple of small comments below.
> 
> On Tuesday 14 August 2012 17:34:50 Tomasz Stanislawski wrote:
>> This patch adds support for exporting a dma-contig buffer using
>> DMABUF interface.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/videobuf2-dma-contig.c |  204 +++++++++++++++++++++++++
>>  1 file changed, 204 insertions(+)
>>
>> diff --git a/drivers/media/video/videobuf2-dma-contig.c
>> b/drivers/media/video/videobuf2-dma-contig.c index 7fc71a0..bb2b4ac8 100644
>> --- a/drivers/media/video/videobuf2-dma-contig.c
>> +++ b/drivers/media/video/videobuf2-dma-contig.c
> 
> [snip]
> 
>> +static struct sg_table *vb2_dc_dmabuf_ops_map(
>> +	struct dma_buf_attachment *db_attach, enum dma_data_direction dir)
>> +{
>> +	struct vb2_dc_attachment *attach = db_attach->priv;
>> +	/* stealing dmabuf mutex to serialize map/unmap operations */
> 
> Why isn't this operation serialized by the dma-buf core itself ?
> 

Indeed, it is a very good question. The lock was introduced in RFCv3 of
DMABUF patches. It was dedicated to serialize attach/detach calls.
No requirements for map/unmap serialization were stated so serialization
was delegated to an exporter.

A deadlock could occur if dma_map_attachment is called from inside
of attach ops. IMO, such an operation is invalid because an attachment
list is not in a valid state while attach ops is being processed.

Do you think that stealing a lock from dma-buf internals is too hacky?
I prefer not to introduce any extra locks in dma-contig allocator
but it is not a big deal to add it.

>> +	struct mutex *lock = &db_attach->dmabuf->lock;
>> +	struct sg_table *sgt;
>> +	int ret;
>> +
>> +	mutex_lock(lock);
>> +
>> +	sgt = &attach->sgt;
>> +	/* return previously mapped sg table */
>> +	if (attach->dir == dir) {
>> +		mutex_unlock(lock);
>> +		return sgt;
>> +	}
>> +
>> +	/* release any previous cache */
>> +	if (attach->dir != DMA_NONE) {
>> +		dma_unmap_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
>> +			attach->dir);
>> +		attach->dir = DMA_NONE;
>> +	}
>> +
>> +	/* mapping to the client with new direction */
>> +	ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dir);
>> +	if (ret <= 0) {
>> +		pr_err("failed to map scatterlist\n");
>> +		mutex_unlock(lock);
>> +		return ERR_PTR(-EIO);
>> +	}
>> +
>> +	attach->dir = dir;
>> +
>> +	mutex_unlock(lock);
>> +
>> +	return sgt;
>> +}
> 
> [snip]
> 
>> +static int vb2_dc_dmabuf_ops_mmap(struct dma_buf *dbuf,
>> +	struct vm_area_struct *vma)
>> +{
>> +	/* Dummy support for mmap */
>> +	return -ENOTTY;
> 
> What about calling the dma-contig mmap handler here ? Is there a specific 
> reason why you haven't implemented mmap support for dmabuf ?
> 

The mmap ops is mandatory in the latest DMABUF api.
I added a stub function to make DC work with DMABUF without any big effort.
Calling vb2_dc_mmap from mmap ops seams to be a simple and safe way to
handle mmap functionality.  Thank you for spotting this :)

>> +}
>> +
>> +static struct dma_buf_ops vb2_dc_dmabuf_ops = {
>> +	.attach = vb2_dc_dmabuf_ops_attach,
>> +	.detach = vb2_dc_dmabuf_ops_detach,
>> +	.map_dma_buf = vb2_dc_dmabuf_ops_map,
>> +	.unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
>> +	.kmap = vb2_dc_dmabuf_ops_kmap,
>> +	.kmap_atomic = vb2_dc_dmabuf_ops_kmap,
>> +	.vmap = vb2_dc_dmabuf_ops_vmap,
>> +	.mmap = vb2_dc_dmabuf_ops_mmap,
>> +	.release = vb2_dc_dmabuf_ops_release,
>> +};
>> +
>> +static struct sg_table *vb2_dc_get_base_sgt(struct vb2_dc_buf *buf)
>> +{
>> +	int ret;
>> +	struct sg_table *sgt;
>> +
>> +	sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
>> +	if (!sgt) {
>> +		dev_err(buf->dev, "failed to alloc sg table\n");
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	ret = dma_get_sgtable(buf->dev, sgt, buf->vaddr, buf->dma_addr,
>> +		buf->size);
>> +	if (ret < 0) {
>> +		dev_err(buf->dev, "failed to get scatterlist from DMA API\n");
>> +		kfree(sgt);
>> +		return ERR_PTR(ret);
>> +	}
> 
> As this function is only used below, where the exact value of the error code 
> is ignored, what about just returning NULL on failure ? Another option is to 
> return the error code in vb2_dc_get_dmabuf (not sure if that would be useful 
> though).
> 
>> +
>> +	return sgt;
>> +}
>> +
>> +static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv)
>> +{
>> +	struct vb2_dc_buf *buf = buf_priv;
>> +	struct dma_buf *dbuf;
>> +	struct sg_table *sgt = buf->sgt_base;
>> +
>> +	if (!sgt)
>> +		sgt = vb2_dc_get_base_sgt(buf);
>> +	if (WARN_ON(IS_ERR(sgt)))
>> +		return NULL;
>> +
>> +	/* cache base sgt for future use */
>> +	buf->sgt_base = sgt;
> 
> You can move this assignment inside the first if, there's no need to execute 
> it every time. The WARN_ON can also be moved inside the first if, as buf-
>> sgt_base will either be NULL or valid. You can then get rid of the sgt 
> variable initialization by testing if (!buf->sgt_base).

I agree. I will apply this fix in v9.

> 
>> +	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, 0);
>> +	if (IS_ERR(dbuf))
>> +		return NULL;
>> +
>> +	/* dmabuf keeps reference to vb2 buffer */
>> +	atomic_inc(&buf->refcount);
>> +
>> +	return dbuf;
>> +}
>

Regards,
Tomasz Stanislawski

