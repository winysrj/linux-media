Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:36882 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdHROmS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:42:18 -0400
Received: by mail-wr0-f170.google.com with SMTP id z91so63158207wrc.4
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:42:17 -0700 (PDT)
Subject: Re: [PATCH 1/7] media: vb2: add bidirectional flag in vb2_queue
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
 <20170818141606.4835-2-stanimir.varbanov@linaro.org>
 <89f1a78b-f136-7783-620d-25b92a7e5218@xs4all.nl>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <6a14fac3-1fd0-15b7-a6bb-ad29032da504@linaro.org>
Date: Fri, 18 Aug 2017 17:42:13 +0300
MIME-Version: 1.0
In-Reply-To: <89f1a78b-f136-7783-620d-25b92a7e5218@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 08/18/2017 05:30 PM, Hans Verkuil wrote:
> On 08/18/17 16:16, Stanimir Varbanov wrote:
>> This change is intended to give to the v4l2 drivers a choice to
>> change the default behavior of the v4l2-core DMA mapping direction
>> from DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or
>> OUTPUT) to DMA_BIDIRECTIONAL during queue_init time.
>>
>> Initially the issue with DMA mapping direction has been found in
>> Venus encoder driver where the hardware (firmware side) adds few
>> lines padding on bottom of the image buffer, and the consequence
>> is triggering of IOMMU protection faults.
>>
>> This will help supporting venus encoder (and probably other drivers
>> in the future) which wants to map output type of buffers as
>> read/write.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 17 ++++++++---------
>>  include/media/videobuf2-core.h           | 13 +++++++++++++
>>  2 files changed, 21 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 0924594989b4..cb115ba6a1d2 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -194,8 +194,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>  {
>>  	struct vb2_queue *q = vb->vb2_queue;
>> -	enum dma_data_direction dma_dir =
>> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>>  	void *mem_priv;
>>  	int plane;
>>  	int ret = -ENOMEM;
>> @@ -209,7 +207,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>>  
>>  		mem_priv = call_ptr_memop(vb, alloc,
>>  				q->alloc_devs[plane] ? : q->dev,
>> -				q->dma_attrs, size, dma_dir, q->gfp_flags);
>> +				q->dma_attrs, size, q->dma_dir, q->gfp_flags);
>>  		if (IS_ERR_OR_NULL(mem_priv)) {
>>  			if (mem_priv)
>>  				ret = PTR_ERR(mem_priv);
>> @@ -978,8 +976,6 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>>  	void *mem_priv;
>>  	unsigned int plane;
>>  	int ret = 0;
>> -	enum dma_data_direction dma_dir =
>> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>>  
>>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>> @@ -1030,7 +1026,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>>  		mem_priv = call_ptr_memop(vb, get_userptr,
>>  				q->alloc_devs[plane] ? : q->dev,
>>  				planes[plane].m.userptr,
>> -				planes[plane].length, dma_dir);
>> +				planes[plane].length, q->dma_dir);
>>  		if (IS_ERR(mem_priv)) {
>>  			dprintk(1, "failed acquiring userspace memory for plane %d\n",
>>  				plane);
>> @@ -1096,8 +1092,6 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>>  	void *mem_priv;
>>  	unsigned int plane;
>>  	int ret = 0;
>> -	enum dma_data_direction dma_dir =
>> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>>  
>>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>> @@ -1156,7 +1150,7 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>>  		/* Acquire each plane's memory */
>>  		mem_priv = call_ptr_memop(vb, attach_dmabuf,
>>  				q->alloc_devs[plane] ? : q->dev,
>> -				dbuf, planes[plane].length, dma_dir);
>> +				dbuf, planes[plane].length, q->dma_dir);
>>  		if (IS_ERR(mem_priv)) {
>>  			dprintk(1, "failed to attach dmabuf\n");
>>  			ret = PTR_ERR(mem_priv);
>> @@ -2003,6 +1997,11 @@ int vb2_core_queue_init(struct vb2_queue *q)
>>  	if (q->buf_struct_size == 0)
>>  		q->buf_struct_size = sizeof(struct vb2_buffer);
>>  
>> +	if (q->bidirectional)
>> +		q->dma_dir = DMA_BIDIRECTIONAL;
>> +	else
>> +		q->dma_dir = q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
>> +
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(vb2_core_queue_init);
>> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
>> index cb97c224be73..ede09fff1de8 100644
>> --- a/include/media/videobuf2-core.h
>> +++ b/include/media/videobuf2-core.h
>> @@ -427,6 +427,17 @@ struct vb2_buf_ops {
>>   * @dev:	device to use for the default allocation context if the driver
>>   *		doesn't fill in the @alloc_devs array.
>>   * @dma_attrs:	DMA attributes to use for the DMA.
>> + * @dma_dir:	DMA mapping direction.
> 
> This one should be moved to the 'Private elements' section. This is set and used
> by the vb2 core, drivers won't set this.
> 
> Looks good otherwise.
> 

Ah, correct, will fix that. Thanks!

-- 
regards,
Stan
