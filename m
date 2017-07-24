Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx009.vodafonemail.xion.oxcs.net ([153.92.174.39]:61337 "EHLO
        mx009.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752679AbdGXJ62 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Jul 2017 05:58:28 -0400
Subject: Re: [PATCH] dma-buf: fix reservation_object_wait_timeout_rcu to wait
 correctly
To: zhoucm1 <david1.zhou@amd.com>, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <1500654001-20899-1-git-send-email-deathsimple@vodafone.de>
 <5975B0FD.5070908@amd.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <deathsimple@vodafone.de>
Message-ID: <f1d556b2-6f16-e289-a9c0-3eb728f4eaa8@vodafone.de>
Date: Mon, 24 Jul 2017 11:58:15 +0200
MIME-Version: 1.0
In-Reply-To: <5975B0FD.5070908@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 24.07.2017 um 10:34 schrieb zhoucm1:
>
>
> On 2017年07月22日 00:20, Christian König wrote:
>> From: Christian König <christian.koenig@amd.com>
>>
>> With hardware resets in mind it is possible that all shared fences are
>> signaled, but the exlusive isn't. Fix waiting for everything in this 
>> situation.
>>
>> Signed-off-by: Christian König <christian.koenig@amd.com>
>> ---
>>   drivers/dma-buf/reservation.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/dma-buf/reservation.c 
>> b/drivers/dma-buf/reservation.c
>> index e2eff86..ce3f9c1 100644
>> --- a/drivers/dma-buf/reservation.c
>> +++ b/drivers/dma-buf/reservation.c
>> @@ -461,7 +461,7 @@ long reservation_object_wait_timeout_rcu(struct 
>> reservation_object *obj,
>>           }
>>       }
>>   -    if (!shared_count) {
>> +    if (!fence) {
> previous code seems be a bug, the exclusive fence isn't be waited at 
> all if shared_count != 0.
>
> With your fix, there still is a case the exclusive fence could be 
> skipped, that when fobj->shared[shared_count-1] isn't signalled.

Yeah, indeed that looks like it needs to be fixed as well.

I'm still completely jet lagged and need to work through tons of stuff 
from last week. Do you have time to take care of fixing up this patch 
and send a v2?

Thanks in advance,
Christian.

>
> Regards,
> David Zhou
>>           struct dma_fence *fence_excl = 
>> rcu_dereference(obj->fence_excl);
>>             if (fence_excl &&
>
