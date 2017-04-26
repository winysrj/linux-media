Return-path: <linux-media-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:41758 "EHLO
        pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950603AbdDZHUm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 03:20:42 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by pegasos-out.vodafone.de (Rohrpostix2  Daemon) with ESMTP id 8A55756461A
        for <linux-media@vger.kernel.org>; Wed, 26 Apr 2017 09:20:40 +0200 (CEST)
Received: from pegasos-out.vodafone.de ([127.0.0.1])
        by localhost (rohrpostix2.prod.vfnet.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W5-e+OqgFt9Z for <linux-media@vger.kernel.org>;
        Wed, 26 Apr 2017 09:20:34 +0200 (CEST)
Subject: Re: [PATCH] dma-buf: avoid scheduling on fence status query
To: Andres Rodriguez <andresx7@gmail.com>,
        dri-devel@lists.freedesktop.org
References: <20170426013632.4716-1-andresx7@gmail.com>
 <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
Cc: linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        linux-media@vger.kernel.org
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <6a3b44f0-bc9f-462c-9b0f-96ae15712b8b@vodafone.de>
Date: Wed, 26 Apr 2017 09:20:31 +0200
MIME-Version: 1.0
In-Reply-To: <d555eb6a-e975-b025-6ed0-c458b1c71f34@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

NAK, I'm wondering how often I have to reject that change. We should 
probably add a comment here.

Even with a zero timeout we still need to enable signaling, otherwise 
some fence will never signal if userspace just polls on them.

If a caller is only interested in the fence status without enabling the 
signaling it should call dma_fence_is_signaled() instead.

Regards,
Christian.

Am 26.04.2017 um 04:50 schrieb Andres Rodriguez:
> CC a few extra lists I missed.
>
> Regards,
> Andres
>
> On 2017-04-25 09:36 PM, Andres Rodriguez wrote:
>> When a timeout of zero is specified, the caller is only interested in
>> the fence status.
>>
>> In the current implementation, dma_fence_default_wait will always call
>> schedule_timeout() at least once for an unsignaled fence. This adds a
>> significant overhead to a fence status query.
>>
>> Avoid this overhead by returning early if a zero timeout is specified.
>>
>> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
>> ---
>>
>> This heavily affects the performance of the Source2 engine running on
>> radv.
>>
>> This patch improves dota2(radv) perf on a i7-6700k+RX480 system from
>> 72fps->81fps.
>>
>>  drivers/dma-buf/dma-fence.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
>> index 0918d3f..348e9e2 100644
>> --- a/drivers/dma-buf/dma-fence.c
>> +++ b/drivers/dma-buf/dma-fence.c
>> @@ -380,6 +380,9 @@ dma_fence_default_wait(struct dma_fence *fence, 
>> bool intr, signed long timeout)
>>      if (test_bit(DMA_FENCE_FLAG_SIGNALED_BIT, &fence->flags))
>>          return ret;
>>
>> +    if (!timeout)
>> +        return 0;
>> +
>>      spin_lock_irqsave(fence->lock, flags);
>>
>>      if (intr && signal_pending(current)) {
>>
