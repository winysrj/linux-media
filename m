Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33003 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbeAKKyz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 05:54:55 -0500
Received: by mail-wm0-f66.google.com with SMTP id x4so2160785wmc.0
        for <linux-media@vger.kernel.org>; Thu, 11 Jan 2018 02:54:55 -0800 (PST)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add some lockdep asserts to the
 reservation object implementation
To: Lucas Stach <l.stach@pengutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
References: <20171201111216.7050-1-l.stach@pengutronix.de>
 <1515667384.12538.51.camel@pengutronix.de>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <7a1961d2-2701-e3e9-ae24-08b8fcfb9dd4@gmail.com>
Date: Thu, 11 Jan 2018 11:54:52 +0100
MIME-Version: 1.0
In-Reply-To: <1515667384.12538.51.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yeah, somehow missed that one.

The patch looks mostly good, except for reservation_object_get_excl().

For that one an RCU protection is usually sufficient, so annotating it 
with reservation_object_assert_held() sounds incorrect to me.

Regards,
Christian.

Am 11.01.2018 um 11:43 schrieb Lucas Stach:
> Did this fall through the cracks over the holidays? It really has made
> my work much easier while reworking some of the reservation object
> handling in etnaviv and I think it might benefit others.
>
> Regards,
> Lucas
>
> Am Freitag, den 01.12.2017, 12:12 +0100 schrieb Lucas Stach:
>> This adds lockdep asserts to the reservation functions which state in their
>> documentation that obj->lock must be held. Allows builds with PROVE_LOCKING
>> enabled to check that the locking requirements are met.
>>
>>> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
>> ---
>>   drivers/dma-buf/reservation.c | 8 ++++++++
>>   include/linux/reservation.h   | 2 ++
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
>> index b44d9d7db347..accd398e2ea6 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -71,6 +71,8 @@ int reservation_object_reserve_shared(struct reservation_object *obj)
>>>   	struct reservation_object_list *fobj, *old;
>>>   	u32 max;
>>   
>>> +	reservation_object_assert_held(obj);
>> +
>>>   	old = reservation_object_get_list(obj);
>>   
>>>   	if (old && old->shared_max) {
>> @@ -211,6 +213,8 @@ void reservation_object_add_shared_fence(struct reservation_object *obj,
>>   {
>>>   	struct reservation_object_list *old, *fobj = obj->staged;
>>   
>>> +	reservation_object_assert_held(obj);
>> +
>>>   	old = reservation_object_get_list(obj);
>>>   	obj->staged = NULL;
>>   
>> @@ -236,6 +240,8 @@ void reservation_object_add_excl_fence(struct reservation_object *obj,
>>>   	struct reservation_object_list *old;
>>>   	u32 i = 0;
>>   
>>> +	reservation_object_assert_held(obj);
>> +
>>>   	old = reservation_object_get_list(obj);
>>>   	if (old)
>>>   		i = old->shared_count;
>> @@ -276,6 +282,8 @@ int reservation_object_copy_fences(struct reservation_object *dst,
>>>   	size_t size;
>>>   	unsigned i;
>>   
>>> +	reservation_object_assert_held(dst);
>> +
>>>   	rcu_read_lock();
>>>   	src_list = rcu_dereference(src->fence);
>>   
>> diff --git a/include/linux/reservation.h b/include/linux/reservation.h
>> index 21fc84d82d41..55e7318800fd 100644
>> --- a/include/linux/reservation.h
>> +++ b/include/linux/reservation.h
>> @@ -212,6 +212,8 @@ reservation_object_unlock(struct reservation_object *obj)
>>   static inline struct dma_fence *
>>   reservation_object_get_excl(struct reservation_object *obj)
>>   {
>>> +	reservation_object_assert_held(obj);
>> +
>>>   	return rcu_dereference_protected(obj->fence_excl,
>>>   					 reservation_object_held(obj));
>>   }
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
