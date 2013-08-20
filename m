Return-path: <linux-media-owner@vger.kernel.org>
Received: from outgoing.email.vodafone.de ([139.7.28.128]:64617 "EHLO
	outgoing.email.vodafone.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934Ab3HTOQw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 10:16:52 -0400
Message-ID: <52137A42.6090503@vodafone.de>
Date: Tue, 20 Aug 2013 16:16:34 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: dri-devel@lists.freedesktop.org, linux-arch@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	Alex Deucher <alexander.deucher@amd.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] drm/radeon: rework to new fence interface
References: <20130815124308.14812.58197.stgit@patser> <5211F0C5.2040705@canonical.com> <5212112C.70808@vodafone.de> <52127411.2010106@canonical.com> <52132AE0.4010702@vodafone.de> <521338A9.4040206@canonical.com> <52133C2A.2090200@vodafone.de> <52136D6F.6090408@canonical.com>
In-Reply-To: <52136D6F.6090408@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.08.2013 15:21, schrieb Maarten Lankhorst:
> Op 20-08-13 11:51, Christian K�nig schreef:
>> Am 20.08.2013 11:36, schrieb Maarten Lankhorst:
>> [SNIP]
>>
>>>>>>> [SNIP]
>>>>>>> +/**
>>>>>>> + * radeon_fence_enable_signaling - enable signalling on fence
>>>>>>> + * @fence: fence
>>>>>>> + *
>>>>>>> + * This function is called with fence_queue lock held, and adds a callback
>>>>>>> + * to fence_queue that checks if this fence is signaled, and if so it
>>>>>>> + * signals the fence and removes itself.
>>>>>>> + */
>>>>>>> +static bool radeon_fence_enable_signaling(struct fence *f)
>>>>>>> +{
>>>>>>> +    struct radeon_fence *fence = to_radeon_fence(f);
>>>>>>> +
>>>>>>> +    if (atomic64_read(&fence->rdev->fence_drv[fence->ring].last_seq) >= fence->seq ||
>>>>>>> +        !fence->rdev->ddev->irq_enabled)
>>>>>>> +        return false;
>>>>>>> +
>>>>>> Do I get that right that you rely on IRQs to be enabled and working here? Cause that would be a quite bad idea from the conceptual side.
>>>>> For cross-device synchronization it would be nice to have working irqs, it allows signalling fences faster,
>>>>> and it allows for callbacks on completion to be called. For internal usage it's no more required than it was before.
>>>> That's a big NAK.
>>>>
>>>> The fence processing is actually very fine tuned to avoid IRQs and as far as I can see you just leave them enabled by decrementing the atomic from IRQ context. Additional to that we need allot of special handling in case of a hardware lockup here, which isn't done if you abuse the fence interface like this.
>>> I think it's not needed to leave the irq enabled, it's a leftover from when I was debugging the mac and no interrupt occurred at all.
>>>
>>>> Also your approach of leaking the IRQ context outside of the driver is a very bad idea from the conceptual side. Please don't modify the fence interface at all and instead use the wait functions already exposed by radeon_fence.c. If you need some kind of signaling mechanism then wait inside a workqueue instead.
>>> The fence takes up the role of a single shot workqueue here. Manually resetting the counter and calling wake_up_all would end up waking all active fences, there's no special handling needed inside radeon for this.
>> Yeah that's actually the point here, you NEED to activate ALL fences, otherwise the fence handling inside the driver won't work.
> It's done in a lazy fashion. If there's no need for an activated fence the interrupt will not be enabled.
>>> The fence api does provide a synchronous wait function, but this causes a stall of whomever waits on it.
>> Which is perfectly fine. What actually is the use case of not stalling a process who wants to wait for something?
> Does radeon call ttm_bo_wait on all bo's before doing a command submission? No? Why should other drivers do that..

Sure it does if hardware synchronization isn't supported.

>>> When I was testing this with intel I used the fence callback to poke a register in i915, this allowed it to not block until it hits the wait op in the command stream, and even then only if the callback was not called first.
>>>
>>> It's documented that the callbacks can be called from any context and will be called with irqs disabled, so nothing scary should be done. The kernel provides enough debug mechanisms to find any violators.
>>> PROVE_LOCKING and DEBUG_ATOMIC_SLEEP for example.
>> No thanks, we even abandoned that concept internal in the driver. Please use the blocking wait functions instead.
> No, this just stalls all gpu's that share a bo.
>
> The idea is to provide a standardized api so bo's can be synchronized without stalling. The first step to this is ww_mutex.
> If this lock is shared between multiple gpu's the same object can be reserved between multiple devices without causing
> a deadlock with circular dependencies. With some small patches it's possible to do this already between multiple drivers
> that use ttm. ttm_bo_reserve, ttm_bo_unreserve and all the other code dealing with ttm reservations have been converted
> to use ww_mutex locking.
>
> Fencing is the next step. When all buffers are locked a callback should be added to any previous fence, and a single new fence
> signaling completion of the command submission should be placed on all locked objects. Because the common path is that no
> objects are shared, the callback and FIFO stalling will only be needed for dma-bufs. When all callbacks have fired the FIFO can be
> unblocked. This prevents having to sync the gpu to the cpu. If a bo is submitted to 1 gpu, and then immediately to another it will not
> stall unless needed. For example in a optimus configuration an application could copy a rendered frame from VRAM to a shared
> dma-buf (xorg's buffer), then have Xorg copying it again (on intel's gpu) from the dma-buf to a framebuffer .

Yeah, that's the same concept we used to have for multiple rings, to 
avoid stalling if a buffer is currently used in a different part of the 
GPU than the current command submission wants it to. After allot of 
internal discussion we came to the conclusion that it just doesn't worth 
the effort.

Have you thought over all the consequences that are implied by having a 
serialized stream of command submissions?

When a buffer is in use by another device you basically have only two 
options: Either block for the buffer to become unused or use a hardware 
method (semaphores) to sync up your operations. Of course you can 
optimize by using a multiple reader / single writers model, but for this 
you basically just have to teach ttm that there might be more than one 
fence for each bo.

Anyway those things are only optimizations, and in the end it always 
comes down to blocking the command submission if there is no other way 
of hardware synchronization and I absolutely don't see any reason why we 
shouldn't do this with just a normal blocking call to a waitqueue.

Christian.
