Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33822 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbeFRMnO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 08:43:14 -0400
Received: by mail-wr0-f193.google.com with SMTP id a12-v6so16705362wro.1
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2018 05:43:13 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [PATCH 3/5] dma-buf: lock the reservation object during
 (un)map_dma_buf
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
References: <20180601120020.11520-1-christian.koenig@amd.com>
 <20180601120020.11520-3-christian.koenig@amd.com>
 <20180618082224.GW3438@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <832d4f04-ced2-ce9f-723d-d611e8241e07@gmail.com>
Date: Mon, 18 Jun 2018 14:43:11 +0200
MIME-Version: 1.0
In-Reply-To: <20180618082224.GW3438@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 18.06.2018 um 10:22 schrieb Daniel Vetter:
> On Fri, Jun 01, 2018 at 02:00:18PM +0200, Christian König wrote:
>> First step towards unpinned DMA buf operation.
>>
>> I've checked the DRM drivers to potential locking of the reservation
>> object, but essentially we need to audit all implementations of the
>> dma_buf _ops for this to work.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
> Agreed in principle, but I expect a fireworks show with just this patch
> applied. It's not just that we need to audit all the implementations of
> dma-buf-ops, we also need to audit all the callers.

Ah, yeah of course a good point.

> No idea yet how to go about merging this, but for a start might be good to
> throw this at the intel-gfx CI (just Cc: the intel-gfx mailing lists, but
> make sure your series applies without amd-staging-next stuff which isn't
> in drm.git yet).

Ok, going to incorporate all your other comments as well and then send 
the next round of this with CCing intel-gfx as well.

Thanks for the review,
Christian.

> -Daniel
>
>> ---
>>   drivers/dma-buf/dma-buf.c | 4 ++++
>>   include/linux/dma-buf.h   | 4 ++++
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
>> index e4c657d9fad7..4f0708cb58a7 100644
>> --- a/drivers/dma-buf/dma-buf.c
>> +++ b/drivers/dma-buf/dma-buf.c
>> @@ -631,7 +631,9 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
>>   	if (WARN_ON(!attach || !attach->dmabuf))
>>   		return ERR_PTR(-EINVAL);
>>   
>> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>>   	sg_table = attach->dmabuf->ops->map_dma_buf(attach, direction);
>> +	reservation_object_unlock(attach->dmabuf->resv);
>>   	if (!sg_table)
>>   		sg_table = ERR_PTR(-ENOMEM);
>>   
>> @@ -658,8 +660,10 @@ void dma_buf_unmap_attachment(struct dma_buf_attachment *attach,
>>   	if (WARN_ON(!attach || !attach->dmabuf || !sg_table))
>>   		return;
>>   
>> +	reservation_object_lock(attach->dmabuf->resv, NULL);
>>   	attach->dmabuf->ops->unmap_dma_buf(attach, sg_table,
>>   						direction);
>> +	reservation_object_unlock(attach->dmabuf->resv);
>>   }
>>   EXPORT_SYMBOL_GPL(dma_buf_unmap_attachment);
>>   
>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> index d17cadd76802..d2ba7a027a78 100644
>> --- a/include/linux/dma-buf.h
>> +++ b/include/linux/dma-buf.h
>> @@ -118,6 +118,8 @@ struct dma_buf_ops {
>>   	 * any other kind of sharing that the exporter might wish to make
>>   	 * available to buffer-users.
>>   	 *
>> +	 * This is called with the dmabuf->resv object locked.
>> +	 *
>>   	 * Returns:
>>   	 *
>>   	 * A &sg_table scatter list of or the backing storage of the DMA buffer,
>> @@ -138,6 +140,8 @@ struct dma_buf_ops {
>>   	 * It should also unpin the backing storage if this is the last mapping
>>   	 * of the DMA buffer, it the exporter supports backing storage
>>   	 * migration.
>> +	 *
>> +	 * This is called with the dmabuf->resv object locked.
>>   	 */
>>   	void (*unmap_dma_buf)(struct dma_buf_attachment *,
>>   			      struct sg_table *,
>> -- 
>> 2.14.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
