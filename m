Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:35420 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbeCVJiA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 05:38:00 -0400
Received: by mail-wr0-f178.google.com with SMTP id 80so6868539wrb.2
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 02:38:00 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>, christian.koenig@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
References: <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321081800.GW14155@phenom.ffwll.local>
 <c9070eb2-9b4e-9ac2-ecbc-74dcf5069858@gmail.com>
 <20180322071425.GG14155@phenom.ffwll.local>
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <d965b3b0-9696-9714-f001-672c3b0b9820@gmail.com>
Date: Thu, 22 Mar 2018 10:37:55 +0100
MIME-Version: 1.0
In-Reply-To: <20180322071425.GG14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 22.03.2018 um 08:14 schrieb Daniel Vetter:
> On Wed, Mar 21, 2018 at 10:34:05AM +0100, Christian König wrote:
>> Am 21.03.2018 um 09:18 schrieb Daniel Vetter:
>>> [SNIP]
>> For correct operation you always need to implement invalidate_range_end as
>> well and add some lock/completion work Otherwise get_user_pages() can again
>> grab the reference to the wrong page.
> Is this really a problem?

Yes, and quite a big one.

> I figured that if a mmu_notifier invalidation is
> going on, a get_user_pages on that mm from anywhere else (whether i915 or
> anyone really) will serialize with the ongoing invalidate?

No, that isn't correct. Jerome can probably better explain that than I do.

> If that's not the case, then really any get_user_pages is racy, including all the
> DIRECT_IO ones.

The key point here is that get_user_pages() grabs a reference to the 
page. So what you get is a bunch of pages which where mapped at that 
location at a specific point in time.

There is no guarantee that after get_user_pages() return you still have 
the same pages mapped at that point, you only guarantee that the pages 
are not reused for something else.

That is perfectly sufficient for a task like DIRECT_IO where you can 
only have block or network I/O, but unfortunately not really for GPUs 
where you crunch of results, write them back to pages and actually count 
on that the CPU sees the result in the right place.

>> [SNIP]
>> So no matter how you put it i915 is clearly doing something wrong here :)
> tbh I'm not entirely clear on the reasons why this works, but
> cross-release lockdep catches these things, and it did not complain.
> On a high-level we make sure that mm locks needed by get_user_pages do
> _not_ nest within dev->struct_mutex. We have massive back-off slowpaths to
> do anything that could fault outside of our own main gem locking.

I'm pretty sure that this doesn't work as intended and just hides the 
real problem.

> That was (at least in the past) a major difference with amdgpu, which
> essentially has none of these paths. That would trivially deadlock with
> your own gem mmap fault handler, so you had (maybe that changed) a dumb
> retry loop, which did shut up lockdep but didn't fix any of the locking
> inversions.

Any lock you grab in an MMU callback can't be even held when you call 
kmalloc() or get_free_page() (without GFP_NOIO).

Even simple things like drm_vm_open() violate that by using GFP_KERNEL. 
So I can 100% ensure you that what you do here is not correct.

> So yeah, grabbing dev->struct_mutex is in principle totally fine while
> holding all kinds of struct mm/vma locks. I'm not entirely clear why we
> punt the actual unmapping to the worker though, maybe simply to not have a
> constrained stack.

I strongly disagree on that. As far as I can see what TTM does looks 
actually like the right approach to the problem.

> This is re: your statement that you can't unamp sg tables from the
> shrinker. We can, because we've actually untangled the locking depencies
> so that you can fully operate on gem objects from within mm/vma locks.
> Maybe code has changed, but last time I looked at radeon/ttm a while back
> that was totally not the case, and if you don't do all this work then yes
> you'll deadlock.
>
> Doen't mean it's not impossible, because we've done it :-)

And I'm pretty sure you didn't do it correctly :D

> Well, it actually gets the job done. We'd need to at least get to
> per-object locking, and probably even then we'd need to rewrite the code a
> lot. But please note that this here is only to avoid the GFP_NOIO
> constraint, all the other bits I clarified around why we don't actually
> have circular locking (because the entire hierarchy is inverted for us)
> still hold even if you would only trylock here.

Well you reversed your allocation and mmap_sem lock which avoids the 
lock inversion during page faults, but it doesn't help you at all with 
the MMU notifier and shrinker because then there are a lot more locks 
involved.

Regards,
Christian.

> Aside: Given that yesterday a bunch of folks complained on #dri-devel that
> amdgpu prematurely OOMs compared to i915, and that we've switched from a
> simple trylock to this nastiness to be able to recover from more low
> memory situation it's maybe not such a silly idea. Horrible, but not silly
> because actually necessary.
> -Daniel
