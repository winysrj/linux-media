Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam02on0079.outbound.protection.outlook.com ([104.47.36.79]:36672
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751531AbdIUHAy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 03:00:54 -0400
Subject: Re: [PATCH] dma-fence: fix dma_fence_get_rcu_safe
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
References: <1504531653-13779-1-git-send-email-deathsimple@vodafone.de>
 <150453243791.23157.6907537389223890207@mail.alporthouse.com>
 <67fe7e05-7743-40c8-558b-41b08eb986e9@amd.com>
 <150512037119.16759.472484663447331384@mail.alporthouse.com>
 <3c412ee3-854a-292a-e036-7c5fd7888979@amd.com>
 <150512178199.16759.73667469529688@mail.alporthouse.com>
 <5ff4b100-b580-a93d-aa5e-c66173ac091d@amd.com>
 <150512410278.16759.10537429613477592631@mail.alporthouse.com>
 <79e447f8-f2e3-57e3-b5fe-503e5feb2f82@amd.com>
 <CAKMK7uGkEFzbrhAS1qWs-g3dC20jubXitR5ALkTg4PhMwoQ-Rg@mail.gmail.com>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Message-ID: <7f14fc7c-2d56-598b-5049-0155df8327e4@amd.com>
Date: Thu, 21 Sep 2017 09:00:34 +0200
MIME-Version: 1.0
In-Reply-To: <CAKMK7uGkEFzbrhAS1qWs-g3dC20jubXitR5ALkTg4PhMwoQ-Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.09.2017 um 20:20 schrieb Daniel Vetter:
> On Mon, Sep 11, 2017 at 01:06:32PM +0200, Christian König wrote:
>> Am 11.09.2017 um 12:01 schrieb Chris Wilson:
>>> [SNIP]
>>>> Yeah, but that is illegal with a fence objects.
>>>>
>>>> When anybody allocates fences this way it breaks at least
>>>> reservation_object_get_fences_rcu(),
>>>> reservation_object_wait_timeout_rcu() and
>>>> reservation_object_test_signaled_single().
>>> Many, many months ago I sent patches to fix them all.
>> Found those after a bit a searching. Yeah, those patches where proposed more
>> than a year ago, but never pushed upstream.
>>
>> Not sure if we really should go this way. dma_fence objects are shared
>> between drivers and since we can't judge if it's the correct fence based on
>> a criteria in the object (only the read counter which is outside) all
>> drivers need to be correct for this.
>>
>> I would rather go the way and change dma_fence_release() to wrap
>> fence->ops->release into call_rcu() to keep the whole RCU handling outside
>> of the individual drivers.
> Hm, I entirely dropped the ball on this, I kinda assumed that we managed
> to get some agreement on this between i915 and dma_fence. Adding a pile
> more people.

For the meantime I've send a v2 of this patch to fix at least the buggy 
return of NULL when we fail to grab the RCU reference but keeping the 
extra checking for now.

Can I get an rb on this please so that we fix at least the bug at hand?

Thanks,
Christian.

>
> Joonas, Tvrtko, I guess we need to fix this one way or the other.
> -Daniel
