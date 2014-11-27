Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:50537 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173AbaK0ItG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:06 -0500
Message-ID: <5476E57A.9090504@xs4all.nl>
Date: Thu, 27 Nov 2014 09:48:58 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv7 PATCH 06/12] vb2-dma-sg: move dma_(un)map_sg here
References: <1416315068-22936-1-git-send-email-hverkuil@xs4all.nl> <1416315068-22936-7-git-send-email-hverkuil@xs4all.nl> <1932278.iP6q74Eg9b@avalon>
In-Reply-To: <1932278.iP6q74Eg9b@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/26/2014 09:43 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Tuesday 18 November 2014 13:51:02 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This moves dma_(un)map_sg to the get_userptr/put_userptr and alloc/put
>> memops of videobuf2-dma-sg.c and adds dma_sync_sg_for_device/cpu to the
>> prepare/finish memops.
>>
>> Now that vb2-dma-sg will sync the buffers for you in the prepare/finish
>> memops we can drop that from the drivers that use dma-sg.
>>
>> For the solo6x10 driver that was a bit more involved because it needs to
>> copy JPEG or MPEG headers to the buffer before returning it to userspace,
>> and that cannot be done in the old place since the buffer there is still
>> setup for DMA access, not for CPU access. However, the buf_finish
>> op is the ideal place to do this. By the time buf_finish is called
>> the buffer is available for CPU access, so copying to the buffer is fine.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: Pawel Osciak <pawel@osciak.com>
>> ---
>>  drivers/media/pci/cx23885/cx23885-417.c         |  3 --
>>  drivers/media/pci/cx23885/cx23885-core.c        |  5 ---
>>  drivers/media/pci/cx23885/cx23885-dvb.c         |  3 --
>>  drivers/media/pci/cx23885/cx23885-vbi.c         |  9 -----
>>  drivers/media/pci/cx23885/cx23885-video.c       |  9 -----
>>  drivers/media/pci/saa7134/saa7134-empress.c     |  1 -
>>  drivers/media/pci/saa7134/saa7134-ts.c          | 16 --------
>>  drivers/media/pci/saa7134/saa7134-vbi.c         | 15 --------
>>  drivers/media/pci/saa7134/saa7134-video.c       | 15 --------
>>  drivers/media/pci/saa7134/saa7134.h             |  1 -
>>  drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  | 50 ++++++++++------------
>>  drivers/media/pci/tw68/tw68-video.c             |  8 ----
>>  drivers/media/platform/marvell-ccic/mcam-core.c | 18 +--------
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c      | 39 +++++++++++++++++++
>>  14 files changed, 62 insertions(+), 130 deletions(-)
> 
> [snip]
> 
> 
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> b/drivers/media/v4l2-core/videobuf2-dma-sg.c index 2bf13dc..f671fab 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -96,6 +96,7 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>> long size, {
>>  	struct vb2_dma_sg_conf *conf = alloc_ctx;
>>  	struct vb2_dma_sg_buf *buf;
>> +	struct sg_table *sgt;
>>  	int ret;
>>  	int num_pages;
>>
>> @@ -128,6 +129,12 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>> long size,
>>
>>  	/* Prevent the device from being released while the buffer is used */
>>  	buf->dev = get_device(conf->dev);
>> +
>> +	sgt = &buf->sg_table;
>> +	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
>> +		goto fail_map;
>> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> 
> I can't help feeling there's a problem here if we need to sync the buffer for 
> the CPU right before mapping it. I wonder whether we could just remove the 
> dma_sync_sg_for_cpu() call. It depends on whether the cpu to dev sync 
> implicitly performed by dma_map_sg is defined as only making the memory 
> consistent for the device without making it inconsistent for the CPU, or as 
> passing the memory ownership from the CPU to the device completely.

dma_map_sg does effectively do a sync_sg_for_device. Note that patch 12/12
switched to dma_map_sg_attrs to avoid the sync_sg_for_device+sync_sg_for_cpu
combo.

Also note that this might very well disappear in the near future. The way the
CPU syncing is handled today is not really compatible with dmabuf. I have
fixes for this which make it explicit in the driver whenever the driver needs
to have CPU buffer access. See patches 12-16 of my RFCv6 patch series:

http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/84399

I did not include those yet since those patches need more work (two drivers
have not yet been converted for this). Once that is in place there shouldn't
be any need anymore to map buffers for cpu access unless requested explicitly.

In the meantime buffers need to be mapped initially for CPU access since that
is what some drivers expect today.

Regards,

	Hans

> 
> Some comment for the similar implementation in put_userptr.
> 
>>  	buf->handler.refcount = &buf->refcount;
>>  	buf->handler.put = vb2_dma_sg_put;
>>  	buf->handler.arg = buf;
>> @@ -138,6 +145,9 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
>> long size, __func__, buf->num_pages);
>>  	return buf;
>>
>> +fail_map:
>> +	put_device(buf->dev);
>> +	sg_free_table(buf->dma_sgt);
> 
> That's an unrelated bug fix, it should be split to a separate patch.
> 
>>  fail_table_alloc:
>>  	num_pages = buf->num_pages;
>>  	while (num_pages--)
>> @@ -152,11 +162,13 @@ fail_pages_array_alloc:
>>  static void vb2_dma_sg_put(void *buf_priv)
>>  {
>>  	struct vb2_dma_sg_buf *buf = buf_priv;
>> +	struct sg_table *sgt = &buf->sg_table;
>>  	int i = buf->num_pages;
>>
>>  	if (atomic_dec_and_test(&buf->refcount)) {
>>  		dprintk(1, "%s: Freeing buffer of %d pages\n", __func__,
>>  			buf->num_pages);
>> +		dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>>  		if (buf->vaddr)
>>  			vm_unmap_ram(buf->vaddr, buf->num_pages);
>>  		sg_free_table(&buf->sg_table);
>> @@ -168,6 +180,22 @@ static void vb2_dma_sg_put(void *buf_priv)
>>  	}
>>  }
>>
>> +static void vb2_dma_sg_prepare(void *buf_priv)
>> +{
>> +	struct vb2_dma_sg_buf *buf = buf_priv;
>> +	struct sg_table *sgt = &buf->sg_table;
>> +
>> +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>> +}
>> +
>> +static void vb2_dma_sg_finish(void *buf_priv)
>> +{
>> +	struct vb2_dma_sg_buf *buf = buf_priv;
>> +	struct sg_table *sgt = &buf->sg_table;
>> +
>> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>> +}
>> +
>>  static inline int vma_is_io(struct vm_area_struct *vma)
>>  {
>>  	return !!(vma->vm_flags & (VM_IO | VM_PFNMAP));
>> @@ -181,6 +209,7 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
>> unsigned long vaddr, unsigned long first, last;
>>  	int num_pages_from_user;
>>  	struct vm_area_struct *vma;
>> +	struct sg_table *sgt;
>>
>>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>  	if (!buf)
>> @@ -246,8 +275,14 @@ static void *vb2_dma_sg_get_userptr(void *alloc_ctx,
>> unsigned long vaddr, buf->num_pages, buf->offset, size, 0))
>>  		goto userptr_fail_alloc_table_from_pages;
>>
>> +	sgt = &buf->sg_table;
>> +	if (dma_map_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir) == 0)
>> +		goto userptr_fail_map;
>> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>> +
>>  	return buf;
>>
>> +userptr_fail_map:
>> +	sg_free_table(&buf->sg_table);
>>  userptr_fail_alloc_table_from_pages:
>>  userptr_fail_get_user_pages:
>>  	dprintk(1, "get_user_pages requested/got: %d/%d]\n",
>> @@ -270,10 +305,12 @@ userptr_fail_alloc_pages:
>>  static void vb2_dma_sg_put_userptr(void *buf_priv)
>>  {
>>  	struct vb2_dma_sg_buf *buf = buf_priv;
>> +	struct sg_table *sgt = &buf->sg_table;
>>  	int i = buf->num_pages;
>>
>>  	dprintk(1, "%s: Releasing userspace buffer of %d pages\n",
>>  	       __func__, buf->num_pages);
>> +	dma_unmap_sg(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
>>  	if (buf->vaddr)
>>  		vm_unmap_ram(buf->vaddr, buf->num_pages);
>>  	sg_free_table(&buf->sg_table);
>> @@ -360,6 +397,8 @@ const struct vb2_mem_ops vb2_dma_sg_memops = {
>>  	.put		= vb2_dma_sg_put,
>>  	.get_userptr	= vb2_dma_sg_get_userptr,
>>  	.put_userptr	= vb2_dma_sg_put_userptr,
>> +	.prepare	= vb2_dma_sg_prepare,
>> +	.finish		= vb2_dma_sg_finish,
>>  	.vaddr		= vb2_dma_sg_vaddr,
>>  	.mmap		= vb2_dma_sg_mmap,
>>  	.num_users	= vb2_dma_sg_num_users,
> 
