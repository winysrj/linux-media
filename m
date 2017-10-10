Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42182 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754585AbdJJIBl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 04:01:41 -0400
Subject: Re: [PATCH] media: vb2: unify calling of set_page_dirty_lock
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <8c775a5d-e42a-761b-e5ef-6dee93d7f476@samsung.com>
Date: Tue, 10 Oct 2017 10:01:36 +0200
MIME-version: 1.0
In-reply-to: <dd1e2f3e-18f1-ed77-2520-aac1bea0c1a9@linaro.org>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <20170829112603.32732-1-stanimir.varbanov@linaro.org>
        <CGME20171010074231epcas5p3c2f9109c62b9e84af7f6905bb34a6ef4@epcas5p3.samsung.com>
        <dd1e2f3e-18f1-ed77-2520-aac1bea0c1a9@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stanimir,

On 2017-10-10 09:42, Stanimir Varbanov wrote:
> Marek,
>
> Any comments?

Oh, I thought that this one has been already merged. If not (yet),
here is my ack.

> On 08/29/2017 02:26 PM, Stanimir Varbanov wrote:
>> Currently videobuf2-dma-sg checks for dma direction for
>> every single page and videobuf2-dc lacks any dma direction
>> checks and calls set_page_dirty_lock unconditionally.
>>
>> Thus unify and align the invocations of set_page_dirty_lock
>> for videobuf2-dc, videobuf2-sg  memory allocators with
>> videobuf2-vmalloc, i.e. the pattern used in vmalloc has been
>> copied to dc and dma-sg.
>>
>> Suggested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

>> ---
>>   drivers/media/v4l2-core/videobuf2-dma-contig.c | 6 ++++--
>>   drivers/media/v4l2-core/videobuf2-dma-sg.c     | 7 +++----
>>   2 files changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index 9f389f36566d..696e24f9128d 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -434,8 +434,10 @@ static void vb2_dc_put_userptr(void *buf_priv)
>>   		pages = frame_vector_pages(buf->vec);
>>   		/* sgt should exist only if vector contains pages... */
>>   		BUG_ON(IS_ERR(pages));
>> -		for (i = 0; i < frame_vector_count(buf->vec); i++)
>> -			set_page_dirty_lock(pages[i]);
>> +		if (buf->dma_dir == DMA_FROM_DEVICE ||
>> +		    buf->dma_dir == DMA_BIDIRECTIONAL)
>> +			for (i = 0; i < frame_vector_count(buf->vec); i++)
>> +				set_page_dirty_lock(pages[i]);
>>   		sg_free_table(sgt);
>>   		kfree(sgt);
>>   	}
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> index 6808231a6bdc..753ed3138dcc 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
>> @@ -292,11 +292,10 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>>   	if (buf->vaddr)
>>   		vm_unmap_ram(buf->vaddr, buf->num_pages);
>>   	sg_free_table(buf->dma_sgt);
>> -	while (--i >= 0) {
>> -		if (buf->dma_dir == DMA_FROM_DEVICE ||
>> -		    buf->dma_dir == DMA_BIDIRECTIONAL)
>> +	if (buf->dma_dir == DMA_FROM_DEVICE ||
>> +	    buf->dma_dir == DMA_BIDIRECTIONAL)
>> +		while (--i >= 0)
>>   			set_page_dirty_lock(buf->pages[i]);
>> -	}
>>   	vb2_destroy_framevec(buf->vec);
>>   	kfree(buf);
>>   }
>>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
