Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16305 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2DTIw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Apr 2012 04:52:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M2R001HSSNJX970@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Apr 2012 09:52:31 +0100 (BST)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0M2R00ED4SO8MV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Apr 2012 09:52:57 +0100 (BST)
Date: Fri, 20 Apr 2012 10:52:53 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH v4 08/14] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
In-reply-to: <6297844.L9YCZPPyju@avalon>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: pawel@osciak.com, mchehab@redhat.com, daniel.vetter@ffwll.ch,
	dri-devel@lists.freedesktop.org, subashrp@gmail.com,
	linaro-mm-sig@lists.linaro.org, kyungmin.park@samsung.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	airlied@redhat.com, remi@remlab.net, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com
Message-id: <4F9123E5.6040602@samsung.com>
References: <1334332076-28489-1-git-send-email-t.stanislaws@samsung.com>
 <1334332076-28489-9-git-send-email-t.stanislaws@samsung.com>
 <6297844.L9YCZPPyju@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,


On 04/17/2012 02:43 AM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Friday 13 April 2012 17:47:50 Tomasz Stanislawski wrote:
>> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>>
>> This patch introduces usage of dma_map_sg to map memory behind
>> a userspace pointer to a device as dma-contiguous mapping.
>>
>> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> 	[bugfixing]
>> Signed-off-by: Kamil Debski <k.debski@samsung.com>
>> 	[bugfixing]
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> 	[add sglist subroutines/code refactoring]
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/video/videobuf2-dma-contig.c |  287 +++++++++++++++++++++++--
>>  1 files changed, 270 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-dma-contig.c
>> b/drivers/media/video/videobuf2-dma-contig.c index 476e536..3a1e314 100644
>> --- a/drivers/media/video/videobuf2-dma-contig.c
>> +++ b/drivers/media/video/videobuf2-dma-contig.c
> 
> [snip]
> 

I found out that the function below may be useful for DMABUF
exporters and importers. I found that its code in
'[PATCH 1/4] [RFC] drm/exynos: DMABUF: Added support for exporting non-contig buffers'
by Prathyush K.

Therefore I posted a patch on linux-media:
'[PATCH] scatterlist: add sg_alloc_table_by_pages function'.

For now I will keep the function below (with your fixes). If
the patch above gets merged then the function will be removed.

Regards,
Tomasz Stanislawski

>> +static struct sg_table *vb2_dc_pages_to_sgt(struct page **pages,
>> +	unsigned int n_pages, unsigned long offset, unsigned long size)
>> +{
>> +	struct sg_table *sgt;
>> +	unsigned int chunks;
>> +	unsigned int i;
>> +	unsigned int cur_page;
>> +	int ret;
>> +	struct scatterlist *s;
>> +	unsigned int offset_end = n_pages * PAGE_SIZE - size;
> 
> Shouldn't offset_end be equal to n_page * PAGE_SIZE - size - offset ?
> 
>> +	sgt = kzalloc(sizeof *sgt, GFP_KERNEL);
>> +	if (!sgt)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	/* compute number of chunks */
>> +	chunks = 1;
>> +	for (i = 1; i < n_pages; ++i)
>> +		if (pages[i] != pages[i - 1] + 1)
>> +			++chunks;
>> +
>> +	ret = sg_alloc_table(sgt, chunks, GFP_KERNEL);
>> +	if (ret) {
>> +		kfree(sgt);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +
>> +	/* merging chunks and putting them into the scatterlist */
>> +	cur_page = 0;
>> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
>> +		size_t size = PAGE_SIZE;
> 
> This will shadow the size parameter, it's a bit confusing. You could rename it 
> chunk_size.
> 
>> +		unsigned int j;
>> +
>> +		for (j = cur_page + 1; j < n_pages; ++j) {
>> +			if (pages[j] != pages[j - 1] + 1)
>> +				break;
>> +			size += PAGE_SIZE;
>> +		}
> 
>> +		/* cut offset if chunk starts at the first page */
>> +		if (cur_page == 0)
>> +			size -= offset;
>> +		/* cut offset_end if chunk ends at the last page */
>> +		if (j == n_pages)
>> +			size -= offset_end;
>> +
>> +		sg_set_page(s, pages[cur_page], size, offset);
>> +		offset = 0;
> 
> What about just
> 
> 		chunk_size -= offset;
> 		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
> 		size -= chunk_size;
> 		offset = 0;
> 
> You could then remove the offset_end calculation above.
> 
>> +		cur_page = j;
>> +	}
>> +
>> +	return sgt;
>> +}
> 

