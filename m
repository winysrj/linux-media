Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsmx009.vodafonemail.xion.oxcs.net ([153.92.174.87]:63331 "EHLO
        vsmx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751328AbdGXJvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 05:51:47 -0400
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
To: Daniel Vetter <daniel@ffwll.ch>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
 <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <b3cb04f6-07c8-f5dd-3d7b-7f41f1d0dd81@vodafone.de>
Date: Mon, 24 Jul 2017 11:51:34 +0200
MIME-Version: 1.0
In-Reply-To: <20170724083359.j6wo5icln3faajn6@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.07.2017 um 10:33 schrieb Daniel Vetter:
> On Fri, Jul 21, 2017 at 06:20:01PM +0200, Christian König wrote:
>> From: Christian König <christian.koenig@amd.com>
>>
>> With hardware resets in mind it is possible that all shared fences are
>> signaled, but the exlusive isn't. Fix waiting for everything in this situation.
> How did you end up with both shared and exclusive fences on the same
> reservation object? At least I thought the point of exclusive was that
> it's exclusive (and has an implicit barrier on all previous shared
> fences). Same for shared fences, they need to wait for the exclusive one
> (and replace it).
>
> Is this fallout from the amdgpu trickery where by default you do all
> shared fences? I thought we've aligned semantics a while back ...

No, that is perfectly normal even for other drivers. Take a look at the 
reservation code.

The exclusive fence replaces all shared fences, but adding a shared 
fence doesn't replace the exclusive fence. That actually makes sense, 
cause when you want to add move shared fences those need to wait for the 
last exclusive fence as well.

Now normally I would agree that when you have shared fences it is 
sufficient to wait for all of them cause those operations can't start 
before the exclusive one finishes. But with GPU reset and/or the ability 
to abort already submitted operations it is perfectly possible that you 
end up with an exclusive fence which isn't signaled and a shared fence 
which is signaled in the same reservation object.

Christian.

> -Daniel
>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> ---
>>   drivers/dma-buf/reservation.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
>> index e2eff86..ce3f9c1 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -461,7 +461,7 @@ long reservation_object_wait_timeout_rcu(struct reservation_object *obj,
>>   		}
>>   	}
>>   
>> -	if (!shared_count) {
>> +	if (!fence) {
>>   		struct dma_fence *fence_excl = rcu_dereference(obj->fence_excl);
>>   
>>   		if (fence_excl &&
>> -- 
>> 2.7.4
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
