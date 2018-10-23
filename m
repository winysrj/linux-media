Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37432 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeJWUnX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 16:43:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id g9-v6so1464587wrq.4
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2018 05:20:06 -0700 (PDT)
Subject: Re: [PATCH 1/8] dma-buf: remove shared fence staging in reservation
 object
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
To: amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Huang Rui <ray.huang@amd.com>,
        "Daenzer, Michel" <Michel.Daenzer@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "Zhang, Jerry" <Jerry.Zhang@amd.com>
References: <20181004131250.2373-1-christian.koenig@amd.com>
 <30ba1fc8-58d5-1c75-406e-d10e68ec4b18@gmail.com>
Message-ID: <42ee3d74-9dac-6573-448c-c70ea28cb9ff@gmail.com>
Date: Tue, 23 Oct 2018 14:20:02 +0200
MIME-Version: 1.0
In-Reply-To: <30ba1fc8-58d5-1c75-406e-d10e68ec4b18@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ping once more! Adding a few more AMD people.

Any comments on this?

Thanks,
Christian.

Am 12.10.18 um 10:22 schrieb Christian König:
> Ping! Adding a few people directly and more mailing lists.
>
> Can I get an acked-by/rb for this? It's only a cleanup and not much 
> functional change.
>
> Regards,
> Christian.
>
> Am 04.10.2018 um 15:12 schrieb Christian König:
>> No need for that any more. Just replace the list when there isn't enough
>> room any more for the additional fence.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> ---
>>   drivers/dma-buf/reservation.c | 178 
>> ++++++++++++++----------------------------
>>   include/linux/reservation.h   |   4 -
>>   2 files changed, 58 insertions(+), 124 deletions(-)
>>
>> diff --git a/drivers/dma-buf/reservation.c 
>> b/drivers/dma-buf/reservation.c
>> index 6c95f61a32e7..5825fc336a13 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -68,105 +68,23 @@ EXPORT_SYMBOL(reservation_seqcount_string);
>>    */
>>   int reservation_object_reserve_shared(struct reservation_object *obj)
>>   {
>> -    struct reservation_object_list *fobj, *old;
>> -    u32 max;
>> +    struct reservation_object_list *old, *new;
>> +    unsigned int i, j, k, max;
>>         old = reservation_object_get_list(obj);
>>         if (old && old->shared_max) {
>> -        if (old->shared_count < old->shared_max) {
>> -            /* perform an in-place update */
>> -            kfree(obj->staged);
>> -            obj->staged = NULL;
>> +        if (old->shared_count < old->shared_max)
>>               return 0;
>> -        } else
>> +        else
>>               max = old->shared_max * 2;
>> -    } else
>> -        max = 4;
>> -
>> -    /*
>> -     * resize obj->staged or allocate if it doesn't exist,
>> -     * noop if already correct size
>> -     */
>> -    fobj = krealloc(obj->staged, offsetof(typeof(*fobj), shared[max]),
>> -            GFP_KERNEL);
>> -    if (!fobj)
>> -        return -ENOMEM;
>> -
>> -    obj->staged = fobj;
>> -    fobj->shared_max = max;
>> -    return 0;
>> -}
>> -EXPORT_SYMBOL(reservation_object_reserve_shared);
>> -
>> -static void
>> -reservation_object_add_shared_inplace(struct reservation_object *obj,
>> -                      struct reservation_object_list *fobj,
>> -                      struct dma_fence *fence)
>> -{
>> -    struct dma_fence *signaled = NULL;
>> -    u32 i, signaled_idx;
>> -
>> -    dma_fence_get(fence);
>> -
>> -    preempt_disable();
>> -    write_seqcount_begin(&obj->seq);
>> -
>> -    for (i = 0; i < fobj->shared_count; ++i) {
>> -        struct dma_fence *old_fence;
>> -
>> -        old_fence = rcu_dereference_protected(fobj->shared[i],
>> -                        reservation_object_held(obj));
>> -
>> -        if (old_fence->context == fence->context) {
>> -            /* memory barrier is added by write_seqcount_begin */
>> -            RCU_INIT_POINTER(fobj->shared[i], fence);
>> -            write_seqcount_end(&obj->seq);
>> -            preempt_enable();
>> -
>> -            dma_fence_put(old_fence);
>> -            return;
>> -        }
>> -
>> -        if (!signaled && dma_fence_is_signaled(old_fence)) {
>> -            signaled = old_fence;
>> -            signaled_idx = i;
>> -        }
>> -    }
>> -
>> -    /*
>> -     * memory barrier is added by write_seqcount_begin,
>> -     * fobj->shared_count is protected by this lock too
>> -     */
>> -    if (signaled) {
>> -        RCU_INIT_POINTER(fobj->shared[signaled_idx], fence);
>>       } else {
>> -        BUG_ON(fobj->shared_count >= fobj->shared_max);
>> - RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
>> -        fobj->shared_count++;
>> +        max = 4;
>>       }
>>   -    write_seqcount_end(&obj->seq);
>> -    preempt_enable();
>> -
>> -    dma_fence_put(signaled);
>> -}
>> -
>> -static void
>> -reservation_object_add_shared_replace(struct reservation_object *obj,
>> -                      struct reservation_object_list *old,
>> -                      struct reservation_object_list *fobj,
>> -                      struct dma_fence *fence)
>> -{
>> -    unsigned i, j, k;
>> -
>> -    dma_fence_get(fence);
>> -
>> -    if (!old) {
>> -        RCU_INIT_POINTER(fobj->shared[0], fence);
>> -        fobj->shared_count = 1;
>> -        goto done;
>> -    }
>> +    new = kmalloc(offsetof(typeof(*new), shared[max]), GFP_KERNEL);
>> +    if (!new)
>> +        return -ENOMEM;
>>         /*
>>        * no need to bump fence refcounts, rcu_read access
>> @@ -174,46 +92,45 @@ reservation_object_add_shared_replace(struct 
>> reservation_object *obj,
>>        * references from the old struct are carried over to
>>        * the new.
>>        */
>> -    for (i = 0, j = 0, k = fobj->shared_max; i < old->shared_count; 
>> ++i) {
>> -        struct dma_fence *check;
>> +    for (i = 0, j = 0, k = max; i < (old ? old->shared_count : 0); 
>> ++i) {
>> +        struct dma_fence *fence;
>>   -        check = rcu_dereference_protected(old->shared[i],
>> -                        reservation_object_held(obj));
>> -
>> -        if (check->context == fence->context ||
>> -            dma_fence_is_signaled(check))
>> -            RCU_INIT_POINTER(fobj->shared[--k], check);
>> +        fence = rcu_dereference_protected(old->shared[i],
>> +                          reservation_object_held(obj));
>> +        if (dma_fence_is_signaled(fence))
>> +            RCU_INIT_POINTER(new->shared[--k], fence);
>>           else
>> -            RCU_INIT_POINTER(fobj->shared[j++], check);
>> +            RCU_INIT_POINTER(new->shared[j++], fence);
>>       }
>> -    fobj->shared_count = j;
>> -    RCU_INIT_POINTER(fobj->shared[fobj->shared_count], fence);
>> -    fobj->shared_count++;
>> +    new->shared_count = j;
>> +    new->shared_max = max;
>>   -done:
>>       preempt_disable();
>>       write_seqcount_begin(&obj->seq);
>>       /*
>>        * RCU_INIT_POINTER can be used here,
>>        * seqcount provides the necessary barriers
>>        */
>> -    RCU_INIT_POINTER(obj->fence, fobj);
>> +    RCU_INIT_POINTER(obj->fence, new);
>>       write_seqcount_end(&obj->seq);
>>       preempt_enable();
>>         if (!old)
>> -        return;
>> +        return 0;
>>         /* Drop the references to the signaled fences */
>> -    for (i = k; i < fobj->shared_max; ++i) {
>> -        struct dma_fence *f;
>> +    for (i = k; i < new->shared_max; ++i) {
>> +        struct dma_fence *fence;
>>   -        f = rcu_dereference_protected(fobj->shared[i],
>> -                          reservation_object_held(obj));
>> -        dma_fence_put(f);
>> +        fence = rcu_dereference_protected(new->shared[i],
>> +                          reservation_object_held(obj));
>> +        dma_fence_put(fence);
>>       }
>>       kfree_rcu(old, rcu);
>> +
>> +    return 0;
>>   }
>> +EXPORT_SYMBOL(reservation_object_reserve_shared);
>>     /**
>>    * reservation_object_add_shared_fence - Add a fence to a shared slot
>> @@ -226,15 +143,39 @@ reservation_object_add_shared_replace(struct 
>> reservation_object *obj,
>>   void reservation_object_add_shared_fence(struct reservation_object 
>> *obj,
>>                        struct dma_fence *fence)
>>   {
>> -    struct reservation_object_list *old, *fobj = obj->staged;
>> +    struct reservation_object_list *fobj;
>> +    unsigned int i;
>>   -    old = reservation_object_get_list(obj);
>> -    obj->staged = NULL;
>> +    dma_fence_get(fence);
>> +
>> +    fobj = reservation_object_get_list(obj);
>>   -    if (!fobj)
>> -        reservation_object_add_shared_inplace(obj, old, fence);
>> -    else
>> -        reservation_object_add_shared_replace(obj, old, fobj, fence);
>> +    preempt_disable();
>> +    write_seqcount_begin(&obj->seq);
>> +
>> +    for (i = 0; i < fobj->shared_count; ++i) {
>> +        struct dma_fence *old_fence;
>> +
>> +        old_fence = rcu_dereference_protected(fobj->shared[i],
>> +                              reservation_object_held(obj));
>> +        if (old_fence->context == fence->context ||
>> +            dma_fence_is_signaled(old_fence)) {
>> +            dma_fence_put(old_fence);
>> +            goto replace;
>> +        }
>> +    }
>> +
>> +    BUG_ON(fobj->shared_count >= fobj->shared_max);
>> +    fobj->shared_count++;
>> +
>> +replace:
>> +    /*
>> +     * memory barrier is added by write_seqcount_begin,
>> +     * fobj->shared_count is protected by this lock too
>> +     */
>> +    RCU_INIT_POINTER(fobj->shared[i], fence);
>> +    write_seqcount_end(&obj->seq);
>> +    preempt_enable();
>>   }
>>   EXPORT_SYMBOL(reservation_object_add_shared_fence);
>>   @@ -343,9 +284,6 @@ int reservation_object_copy_fences(struct 
>> reservation_object *dst,
>>       new = dma_fence_get_rcu_safe(&src->fence_excl);
>>       rcu_read_unlock();
>>   -    kfree(dst->staged);
>> -    dst->staged = NULL;
>> -
>>       src_list = reservation_object_get_list(dst);
>>       old = reservation_object_get_excl(dst);
>>   diff --git a/include/linux/reservation.h b/include/linux/reservation.h
>> index 02166e815afb..54cf6773a14c 100644
>> --- a/include/linux/reservation.h
>> +++ b/include/linux/reservation.h
>> @@ -68,7 +68,6 @@ struct reservation_object_list {
>>    * @seq: sequence count for managing RCU read-side synchronization
>>    * @fence_excl: the exclusive fence, if there is one currently
>>    * @fence: list of current shared fences
>> - * @staged: staged copy of shared fences for RCU updates
>>    */
>>   struct reservation_object {
>>       struct ww_mutex lock;
>> @@ -76,7 +75,6 @@ struct reservation_object {
>>         struct dma_fence __rcu *fence_excl;
>>       struct reservation_object_list __rcu *fence;
>> -    struct reservation_object_list *staged;
>>   };
>>     #define reservation_object_held(obj) 
>> lockdep_is_held(&(obj)->lock.base)
>> @@ -95,7 +93,6 @@ reservation_object_init(struct reservation_object 
>> *obj)
>>       __seqcount_init(&obj->seq, reservation_seqcount_string, 
>> &reservation_seqcount_class);
>>       RCU_INIT_POINTER(obj->fence, NULL);
>>       RCU_INIT_POINTER(obj->fence_excl, NULL);
>> -    obj->staged = NULL;
>>   }
>>     /**
>> @@ -124,7 +121,6 @@ reservation_object_fini(struct reservation_object 
>> *obj)
>>             kfree(fobj);
>>       }
>> -    kfree(obj->staged);
>>         ww_mutex_destroy(&obj->lock);
>>   }
>
