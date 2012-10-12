Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45532 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587Ab2JLIYi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 04:24:38 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBR00L1TU1KSA50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 09:24:56 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBR00FEJU0ZP970@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 09:24:36 +0100 (BST)
Message-id: <5077D3C2.7010207@samsung.com>
Date: Fri, 12 Oct 2012 10:24:34 +0200
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
Subject: Re: [PATCHv10 23/26] v4l: vb2-dma-contig: align buffer size to
 PAGE_SIZE
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1349880405-26049-24-git-send-email-t.stanislaws@samsung.com>
 <11844448.MZrezqZD1L@avalon>
In-reply-to: <11844448.MZrezqZD1L@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 10/11/2012 11:31 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> On Wednesday 10 October 2012 16:46:42 Tomasz Stanislawski wrote:
>> Most operations on DMA and DMABUF framework need page
>> aligned buffers.
> 
> The comment is a bit misleading, the buffer is already page-aligned (unless 
> I'm mistaken dma_alloc_coherent() returns a page-aligned buffer) but its size 
> isn't a multiple of the page size.

Ok. I will update the commit message that only buffer size is going to be page aligned.

> 
> Do we really need a page size multiple ? Isn't it enough to make the size a 
> multiple of the cache line size ?
> 

Frankly, I strongly oppose forcing a size of a DMA buffer to be rounded up.

However, I discovered a problem while testing mmap() interface in dma-buf.
The test in dma_buf_mmap() will fail if the size is not a multiple of 4k.

Maybe the value from dma-buf.c:456 should be changed from:

dmabuf->size >> PAGE_SHIFT

to

PAGE_ALIGN(dmabuf->size) >> PAGE_SHIFT

However, I preferred to avoid any changes outside of the media tree
hoping that the patchset gets merged. Rounding the buffer size to
a page size was quick workaround for the issue with DMABUF mmap().

Regards,
Tomasz Stanislawski

>> This fix guarantees this requirement
>> for vb2-dma-contig buffers.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index 571a919..002ee50
>> 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -162,6 +162,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
>> size) if (!buf)
>>  		return ERR_PTR(-ENOMEM);
>>
>> +	/* align image size to PAGE_SIZE */
>> +	size = PAGE_ALIGN(size);
>> +
>>  	buf->vaddr = dma_alloc_coherent(dev, size, &buf->dma_addr, GFP_KERNEL);
>>  	if (!buf->vaddr) {
>>  		dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);

