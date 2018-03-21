Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:41767 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeCUJeI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 05:34:08 -0400
Received: by mail-wr0-f170.google.com with SMTP id f14so4452280wre.8
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 02:34:07 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321081800.GW14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <c9070eb2-9b4e-9ac2-ecbc-74dcf5069858@gmail.com>
Date: Wed, 21 Mar 2018 10:34:05 +0100
MIME-Version: 1.0
In-Reply-To: <20180321081800.GW14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 21.03.2018 um 09:18 schrieb Daniel Vetter:
> [SNIP]
> They're both in i915_gem_userptr.c, somewhat interleaved. Would be
> interesting if you could show what you think is going wrong in there
> compared to amdgpu_mn.c.

i915 implements only one callback:
> static const struct mmu_notifier_ops i915_gem_userptr_notifier = {
>         .invalidate_range_start = 
> i915_gem_userptr_mn_invalidate_range_start,
> };
For correct operation you always need to implement invalidate_range_end 
as well and add some lock/completion work Otherwise get_user_pages() can 
again grab the reference to the wrong page.

The next problem seems to be that cancel_userptr() doesn't prevent any 
new command submission. E.g.
> i915_gem_object_wait(obj, I915_WAIT_ALL, MAX_SCHEDULE_TIMEOUT, NULL);
What prevents new command submissions to use the GEM object directly 
after you finished waiting here?

> I get a feeling we're talking past each another here.
Yeah, agree. Additional to that I don't know the i915 code very well.

> Can you perhaps explain what exactly the race is you're seeing? The i915 userptr code is
> fairly convoluted and pushes a lot of stuff to workers (but then syncs
> with those workers again later on), so easily possible you've overlooked
> one of these lines that might guarantee already what you think needs to be
> guaranteed. We're definitely not aiming to allow userspace to allow
> writing to random pages all over.

You not read/write to random pages, there still is a reference to the 
page. So that the page can't be reused until you are done.

The problem is rather that you can't guarantee that you write to the 
page which is mapped into the process at that location. E.g. the CPU and 
the GPU might see two different things.

>>> Leaking the IOMMU mappings otoh means rogue userspace could do a bunch of
>>> stray writes (I don't see anywhere code in amdgpu_mn.c to unmap at least
>>> the gpu side PTEs to make stuff inaccessible) and wreak the core kernel's
>>> book-keeping.
>>>
>>> In i915 we guarantee that we call set_page_dirty/mark_page_accessed only
>>> after all the mappings are really gone (both GPU PTEs and sg mapping),
>>> guaranteeing that any stray writes from either the GPU or IOMMU will
>>> result in faults (except bugs in the IOMMU, but can't have it all, "IOMMU
>>> actually works" is an assumption behind device isolation).
>> Well exactly that's the point, the handling in i915 looks incorrect to me.
>> You need to call set_page_dirty/mark_page_accessed way before the mapping is
>> destroyed.
>>
>> To be more precise for userptrs it must be called from the
>> invalidate_range_start, but i915 seems to delegate everything into a
>> background worker to avoid the locking problems.
> Yeah, and at the end of the function there's a flush_work to make sure the
> worker has caught up.
Ah, yes haven't seen that.

But then grabbing the obj->base.dev->struct_mutex lock in 
cancel_userptr() is rather evil. You just silenced lockdep because you 
offloaded that into a work item.

So no matter how you put it i915 is clearly doing something wrong here :)

> I know. i915 gem has tons of fallbacks and retry loops (we restart the
> entire CS if needed), and i915 userptr pushes the entire get_user_pages
> dance off into a worker if the fastpath doesn't succeed and we run out of
> memory or hit contended locks. We also have obscene amounts of
> __GFP_NORETRY and __GFP_NOWARN all over the place to make sure the core mm
> code doesn't do something we don't want it do to do in the fastpaths
> (because there's really no point in spending lots of time trying to make
> memory available if we have a slowpath fallback with much less
> constraints).
Well I haven't audited the code, but I'm pretty sure that just mitigates 
the problem and silenced lockdep instead of really fixing the issue.

> We're also not limiting ourselves to GFP_NOIO, but instead have a
> recursion detection&handling in our own shrinker callback to avoid these
> deadlocks.

Which if you ask me is absolutely horrible. I mean the comment in 
linux/mutex.h sums it up pretty well:
>  * This function should not be used, _ever_. It is purely for 
> hysterical GEM
>  * raisins, and once those are gone this will be removed.

Regards,
Christian.
