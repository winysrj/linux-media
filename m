Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.netline.ch ([148.251.143.178]:57198 "EHLO
        netline-mail3.netline.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934246AbeF0QEK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 12:04:10 -0400
Subject: Re: [PATCH] dma-buf: Move BUG_ON from _add_shared_fence to
 _add_shared_inplace
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org
References: <20180626143147.14296-1-michel@daenzer.net>
 <153010024207.8693.14587899562244751472@mail.alporthouse.com>
From: =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
Message-ID: <d38ba7df-d3b4-2c90-3482-21f40ea18a00@daenzer.net>
Date: Wed, 27 Jun 2018 18:04:05 +0200
MIME-Version: 1.0
In-Reply-To: <153010024207.8693.14587899562244751472@mail.alporthouse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-06-27 01:50 PM, Chris Wilson wrote:
> Quoting Michel Dänzer (2018-06-26 15:31:47)
>> From: Michel Dänzer <michel.daenzer@amd.com>
>>
>> Fixes the BUG_ON spuriously triggering under the following
>> circumstances:
>>
>> * ttm_eu_reserve_buffers processes a list containing multiple BOs using
>>   the same reservation object, so it calls
>>   reservation_object_reserve_shared with that reservation object once
>>   for each such BO.
>> * In reservation_object_reserve_shared, old->shared_count ==
>>   old->shared_max - 1, so obj->staged is freed in preparation of an
>>   in-place update.
>> * ttm_eu_fence_buffer_objects calls reservation_object_add_shared_fence
>>   once for each of the BOs above, always with the same fence.
>> * The first call adds the fence in the remaining free slot, after which
>>   old->shared_count == old->shared_max.
>>
>> In the next call to reservation_object_add_shared_fence, the BUG_ON
>> triggers. However, nothing bad would happen in
>> reservation_object_add_shared_inplace, since the fence is already in the
>> reservation object.
>>
>> Prevent this by moving the BUG_ON to where an overflow would actually
>> happen (e.g. if a buggy caller didn't call
>> reservation_object_reserve_shared before).
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
> 
> I've convinced myself (or rather have not found a valid argument
> against) that being able to call reserve_shared + add_shared multiple
> times for the same fence is an intended part of reservation_object API 
> 
> I'd double check with Christian though.

Right, I'm interested in Christian's feedback.


> Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>

Thanks!


>>  drivers/dma-buf/reservation.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
>> index 314eb1071cce..532545b9488e 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -141,6 +141,7 @@ reservation_object_add_shared_inplace(struct reservation_object *obj,
>>         if (signaled) {
>>                 RCU_INIT_POINTER(fobj->shared[signaled_idx], fence);
>>         } else {
>> +               BUG_ON(fobj->shared_count >= fobj->shared_max);
> 
> Personally I would just let kasan detect this and throw away the BUG_ON
> or at least move it behind some DMABUF_BUG_ON().

Hmm. Normally, I'm not a fan of BUG(_ON) either. But in this case, it's
clear that the caller is buggy, and proceeding to write beyond the end
of the array could have far-reaching consequences. I'm leaving that to
somebody else.


-- 
Earthling Michel Dänzer               |               http://www.amd.com
Libre software enthusiast             |             Mesa and X developer
