Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46707 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2DKMR2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 08:17:28 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2B003T6E587R50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Apr 2012 13:17:33 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2B00H8PE4ZQ9@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 11 Apr 2012 13:17:24 +0100 (BST)
Date: Wed, 11 Apr 2012 14:17:24 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 11/11] v4l: vb2: Add dma-contig allocator as dma_buf user
In-reply-to: <3806078.bLkgp7kyMX@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com,
	Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <4F857654.2010900@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com>
 <1333634408-4960-12-git-send-email-t.stanislaws@samsung.com>
 <3806078.bLkgp7kyMX@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thanks for review.

On 04/06/2012 05:12 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> On Thursday 05 April 2012 16:00:08 Tomasz Stanislawski wrote:
>> From: Sumit Semwal <sumit.semwal@ti.com>
>>
>> This patch makes changes for adding dma-contig as a dma_buf user. It
>> provides function implementations for the {attach, detach, map,
>> unmap}_dmabuf() mem_ops of DMABUF memory type.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>> 	[author of the original patch]
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> 	[integration with refactored dma-contig allocator]
>> ---
>>  drivers/media/video/videobuf2-dma-contig.c |  117 +++++++++++++++++++++++++
>>  1 files changed, 117 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-dma-contig.c
>> b/drivers/media/video/videobuf2-dma-contig.c index 30f316588..6329483
>> 100644
>> --- a/drivers/media/video/videobuf2-dma-contig.c
>> +++ b/drivers/media/video/videobuf2-dma-contig.c
>> @@ -10,6 +10,7 @@
>>   * the Free Software Foundation.
>>   */
>>
>> +#include <linux/dma-buf.h>
>>  #include <linux/module.h>
>>  #include <linux/scatterlist.h>
>>  #include <linux/sched.h>
>> @@ -33,6 +34,9 @@ struct vb2_dc_buf {
>>
>>  	/* USERPTR related */
>>  	struct vm_area_struct		*vma;
>> +
>> +	/* DMABUF related */
>> +	struct dma_buf_attachment	*db_attach;
>>  };
>>
>>  /*********************************************/
>> @@ -425,6 +429,115 @@ fail_buf:
>>  }
>>
>>  /*********************************************/
>> +/*       callbacks for DMABUF buffers        */
>> +/*********************************************/
>> +
>> +static int vb2_dc_map_dmabuf(void *mem_priv)
>> +{
>> +	struct vb2_dc_buf *buf = mem_priv;
>> +	struct sg_table *sgt;
>> +	unsigned long contig_size;
>> +	int ret = 0;
>> +
>> +	if (WARN_ON(!buf->db_attach)) {
>> +		printk(KERN_ERR "trying to pin a non attached buffer\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (WARN_ON(buf->dma_sgt)) {
>> +		printk(KERN_ERR "dmabuf buffer is already pinned\n");
>> +		return 0;
>> +	}
>> +
>> +	/* get the associated scatterlist for this buffer */
>> +	sgt = dma_buf_map_attachment(buf->db_attach, buf->dma_dir);
>> +	if (IS_ERR_OR_NULL(sgt)) {
>> +		printk(KERN_ERR "Error getting dmabuf scatterlist\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* checking if dmabuf is big enough to store contiguous chunk */
>> +	contig_size = vb2_dc_get_contiguous_size(sgt);
>> +	if (contig_size < buf->size) {
>> +		printk(KERN_ERR "contiguous chunk of dmabuf is too small\n");
>> +		ret = -EFAULT;
>> +		goto fail_map;
> 
> The fail_map label is only used here, you can move the 
> dma_buf_unmap_attachment() call here and return -EFAULT directly.
> 

Patch "[RFC 07/13] v4l: vb2-dma-contig: change map/unmap behaviour for importers"
introduces other cleanup labels. Anyway I will remove this redundant label as
you proposed.

>> +	}
>> +
>> +	buf->dma_addr = sg_dma_address(sgt->sgl);
>> +	buf->dma_sgt = sgt;
>> +
>> +	return 0;
>> +
>> +fail_map:
>> +	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
>> +
>> +	return ret;
>> +}
>> +
>> +static void vb2_dc_unmap_dmabuf(void *mem_priv)
>> +{
>> +	struct vb2_dc_buf *buf = mem_priv;
>> +	struct sg_table *sgt = buf->dma_sgt;
>> +
>> +	if (WARN_ON(!buf->db_attach)) {
>> +		printk(KERN_ERR "trying to unpin a not attached buffer\n");
>> +		return;
>> +	}
>> +
>> +	if (WARN_ON(!sgt)) {
>> +		printk(KERN_ERR "dmabuf buffer is already unpinned\n");
>> +		return;
>> +	}
>> +
>> +	dma_buf_unmap_attachment(buf->db_attach, sgt, buf->dma_dir);
>> +
>> +	buf->dma_addr = 0;
>> +	buf->dma_sgt = NULL;
>> +}
>> +
>> +static void vb2_dc_detach_dmabuf(void *mem_priv)
>> +{
>> +	struct vb2_dc_buf *buf = mem_priv;
>> +
>> +	if (buf->dma_addr)
>> +		vb2_dc_unmap_dmabuf(buf);
> 
> What would you think about calling vb2_dc_unmap_dmabuf() from vb2 core 
> instead, to keep the map/unmap calls symmetrical (the second WARN_ON and the 
> related printk in vb2_dc_unmap_dmabuf() might need to go then) ?
> 

Detach without unmap may happen in a case of closing a video fd
without prior dequeuing of all buffers.

A call map_dmabuf should be moved to __enqueue_in_driver and add calling
unmap_dmabuf to vb2_buffer_done in order to keep map/unmap calls
symmetrical. I'll check if this could work.

Regards,
Tomasz Stanislawski

