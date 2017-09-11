Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0044.outbound.protection.outlook.com ([104.47.36.44]:47419
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750994AbdIKIu4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 04:50:56 -0400
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
To: Chris Wilson <chris@chris-wilson.co.uk>, daniel.vetter@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
 <150453243791.23157.6907537389223890207@mail.alporthouse.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <67fe7e05-7743-40c8-558b-41b08eb986e9@amd.com>
Date: Mon, 11 Sep 2017 10:50:40 +0200
MIME-Version: 1.0
In-Reply-To: <150453243791.23157.6907537389223890207@mail.alporthouse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the delayed response, but your mail somehow ended up in the 
Spam folder.

Am 04.09.2017 um 15:40 schrieb Chris Wilson:
> Quoting Christian König (2017-09-04 14:27:33)
>> From: Christian König <christian.koenig@amd.com>
>>
>> The logic is buggy and unnecessary complex. When dma_fence_get_rcu() fails to
>> acquire a reference it doesn't necessary mean that there is no fence at all.
>>
>> It usually mean that the fence was replaced by a new one and in this situation
>> we certainly want to have the new one as result and *NOT* NULL.
> Which is not guaranteed by the code you wrote either.
>
> The point of the comment is that the mb is only inside the successful
> kref_atomic_inc_unless_zero, and that only after that mb do you know
> whether or not you have the current fence.
>
> You can argue that you want to replace the
> 	if (!dma_fence_get_rcu())
> 		return NULL
> with
> 	if (!dma_fence_get_rcu()
> 		continue;
> but it would be incorrect to say that by simply ignoring the
> post-condition check that you do have the right fence.

You are completely missing the point here.

It is irrelevant if you have the current fence or not when you return. 
You can only guarantee that it is the current fence when you take a look 
and that is exactly what we want to avoid.

So the existing code is complete nonsense. Instead what we need to 
guarantee is that we return *ANY* fence which we can grab a reference for.

See the usual life of a fence* variable looks like this:
1. assigning pointer to fence A;
2. assigning pointer to fence B;
3. assigning pointer to fence C;
....

When dma_fence_get_rcu_safe() is called between step #1 and step #2 for 
example it is perfectly valid to just return either fence A or fence B.

But it is invalid to return NULL because that suggests that we don't 
need to sync at all.

Regards,
Christian.
