Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:42411 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbeAJNqf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 08:46:35 -0500
Received: by mail-wm0-f68.google.com with SMTP id b141so27092704wme.1
        for <linux-media@vger.kernel.org>; Wed, 10 Jan 2018 05:46:34 -0800 (PST)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: make returning the exclusive
 fence optional
To: Daniel Vetter <daniel@ffwll.ch>
Cc: sumit.semwal@linaro.org, gustavo@padovan.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
References: <20180110125341.3618-1-christian.koenig@amd.com>
 <20180110132127.GT13066@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <7ec935dd-aa35-6793-de5e-67a0de790c90@gmail.com>
Date: Wed, 10 Jan 2018 14:46:32 +0100
MIME-Version: 1.0
In-Reply-To: <20180110132127.GT13066@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 10.01.2018 um 14:21 schrieb Daniel Vetter:
> On Wed, Jan 10, 2018 at 01:53:41PM +0100, Christian König wrote:
>> Change reservation_object_get_fences_rcu to make the exclusive fence
>> pointer optional.
>>
>> If not specified the exclusive fence is put into the fence array as
>> well.
>>
>> This is helpful for a couple of cases where we need all fences in a
>> single array.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
> Seeing the use-case for this would be a lot more interesting ...

Yeah, sorry the use case is a 20 patches set on amd-gfx.

Didn't wanted to post all those here as well.

Christian.

> -Daniel
>
>> ---
>>   drivers/dma-buf/reservation.c | 31 ++++++++++++++++++++++---------
>>   1 file changed, 22 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
>> index b759a569b7b8..461afa9febd4 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -374,8 +374,9 @@ EXPORT_SYMBOL(reservation_object_copy_fences);
>>    * @pshared: the array of shared fence ptrs returned (array is krealloc'd to
>>    * the required size, and must be freed by caller)
>>    *
>> - * RETURNS
>> - * Zero or -errno
>> + * Retrieve all fences from the reservation object. If the pointer for the
>> + * exclusive fence is not specified the fence is put into the array of the
>> + * shared fences as well. Returns either zero or -ENOMEM.
>>    */
>>   int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>   				      struct dma_fence **pfence_excl,
>> @@ -389,8 +390,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>   
>>   	do {
>>   		struct reservation_object_list *fobj;
>> -		unsigned seq;
>> -		unsigned int i;
>> +		unsigned int i, seq;
>> +		size_t sz = 0;
>>   
>>   		shared_count = i = 0;
>>   
>> @@ -402,9 +403,14 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>   			goto unlock;
>>   
>>   		fobj = rcu_dereference(obj->fence);
>> -		if (fobj) {
>> +		if (fobj)
>> +			sz += sizeof(*shared) * fobj->shared_max;
>> +
>> +		if (!pfence_excl && fence_excl)
>> +			sz += sizeof(*shared);
>> +
>> +		if (sz) {
>>   			struct dma_fence **nshared;
>> -			size_t sz = sizeof(*shared) * fobj->shared_max;
>>   
>>   			nshared = krealloc(shared, sz,
>>   					   GFP_NOWAIT | __GFP_NOWARN);
>> @@ -420,13 +426,19 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>   				break;
>>   			}
>>   			shared = nshared;
>> -			shared_count = fobj->shared_count;
>> -
>> +			shared_count = fobj ? fobj->shared_count : 0;
>>   			for (i = 0; i < shared_count; ++i) {
>>   				shared[i] = rcu_dereference(fobj->shared[i]);
>>   				if (!dma_fence_get_rcu(shared[i]))
>>   					break;
>>   			}
>> +
>> +			if (!pfence_excl && fence_excl) {
>> +				shared[i] = fence_excl;
>> +				fence_excl = NULL;
>> +				++i;
>> +				++shared_count;
>> +			}
>>   		}
>>   
>>   		if (i != shared_count || read_seqcount_retry(&obj->seq, seq)) {
>> @@ -448,7 +460,8 @@ int reservation_object_get_fences_rcu(struct reservation_object *obj,
>>   
>>   	*pshared_count = shared_count;
>>   	*pshared = shared;
>> -	*pfence_excl = fence_excl;
>> +	if (pfence_excl)
>> +		*pfence_excl = fence_excl;
>>   
>>   	return ret;
>>   }
>> -- 
>> 2.14.1
>>
>> _______________________________________________
>> Linaro-mm-sig mailing list
>> Linaro-mm-sig@lists.linaro.org
>> https://lists.linaro.org/mailman/listinfo/linaro-mm-sig
