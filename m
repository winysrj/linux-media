Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29067 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab2JLHoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 03:44:09 -0400
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBR00A7YS6HWK60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 08:44:41 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBR002LCS5IUE10@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 08:44:07 +0100 (BST)
Message-id: <5077CA45.2040908@samsung.com>
Date: Fri, 12 Oct 2012 09:44:05 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 22/26] v4l: vb2-dma-contig: fail if user ptr buffer is
 not correctly aligned
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1349880405-26049-23-git-send-email-t.stanislaws@samsung.com>
 <2222801.pVl6O4rxaf@avalon>
In-reply-to: <2222801.pVl6O4rxaf@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thank you for the review.
Please refer to the comments below.

On 10/11/2012 11:36 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Wednesday 10 October 2012 16:46:41 Tomasz Stanislawski wrote:
>> From: Marek Szyprowski <m.szyprowski@samsung.com>
>>
>> The DMA transfer must be aligned to a specific value. If userptr is not
>> aligned to DMA requirements then unexpected corruptions of the memory may
>> occur before or after a buffer.  To prevent such situations, all unligned
>> userptr buffers are rejected at VIDIOC_QBUF.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c |   12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 2d661fd..571a919
>> 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -493,6 +493,18 @@ static void *vb2_dc_get_userptr(void *alloc_ctx,
>> unsigned long vaddr, struct vm_area_struct *vma;
>>  	struct sg_table *sgt;
>>  	unsigned long contig_size;
>> +	unsigned long dma_align = dma_get_cache_alignment();
>> +
>> +	/* Only cache aligned DMA transfers are reliable */
>> +	if (!IS_ALIGNED(vaddr | size, dma_align)) {
>> +		pr_debug("user data must be aligned to %lu bytes\n", dma_align);
>> +		return ERR_PTR(-EINVAL);
>> +	}
> 
> Looks good to me.
> 
>> +	if (!size) {
>> +		pr_debug("size is zero\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
> 
> Can this happen ? The vb2 core already has
> 
>                 /* Check if the provided plane buffer is large enough */
>                 if (planes[plane].length < q->plane_sizes[plane]) {
>                         ret = -EINVAL;
>                         goto err;
>                 }
> 
> Unless queue_setup sets plane_sizes to 0 we can't reach vb2_dc_get_userptr.
> 

Yes.. unfortunately, some drivers set plane_size to 0 at queue_setup.
Especially, if REQBUFS is called before any S_FMT.
Maybe it is just a driver bug.

However, VB2 makes no sanity check if plane_sizes[] is zero.
I was not able to find in Documentation nor code comments
any explicit statement that plane_size cannot be zero.

Therefore I have to reject reject a 0-bytes-long user pointer
at vb2_dc_get_userptr before creating an empty scatterlist
and passing it to the DMA layer.

Regards,
Tomasz Stanislawski

>>  	buf = kzalloc(sizeof *buf, GFP_KERNEL);
>>  	if (!buf)
> 

