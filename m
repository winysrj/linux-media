Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:40630 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751372AbeCUISF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Mar 2018 04:18:05 -0400
Received: by mail-wm0-f42.google.com with SMTP id t6so8129404wmt.5
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2018 01:18:04 -0700 (PDT)
Date: Wed, 21 Mar 2018 09:18:00 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180321081800.GW14155@phenom.ffwll.local>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
> Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
> > [SNIP]
> > For the in-driver reservation path (CS) having a slow-path that grabs a
> > temporary reference, drops the vram lock and then locks the reservation
> > normally (using the acquire context used already for the entire CS) is a
> > bit tricky, but totally feasible. Ttm doesn't do that though.
> 
> That is exactly what we do in amdgpu as well, it's just not very efficient
> nor reliable to retry getting the right pages for a submission over and over
> again.
> 
> > [SNIP]
> > Note that there are 2 paths for i915 userptr. One is the mmu notifier, the
> > other one is the root-only hack we have for dubious reasons (or that I
> > really don't see the point in myself).
> 
> Well I'm referring to i915_gem_userptr.c, if that isn't what you are
> exposing then just feel free to ignore this whole discussion.

They're both in i915_gem_userptr.c, somewhat interleaved. Would be
interesting if you could show what you think is going wrong in there
compared to amdgpu_mn.c.

> > > For coherent usage you need to install some lock to prevent concurrent
> > > get_user_pages(), command submission and
> > > invalidate_range_start/invalidate_range_end from the MMU notifier.
> > > 
> > > Otherwise you can't guarantee that you are actually accessing the right page
> > > in the case of a fork() or mprotect().
> > Yeah doing that with a full lock will create endless amounts of issues,
> > but I don't see why we need that. Userspace racing stuff with itself gets
> > to keep all the pieces. This is like racing DIRECT_IO against mprotect and
> > fork.
> 
> First of all I strongly disagree on that. A thread calling fork() because it
> wants to run a command is not something we can forbid just because we have a
> gfx stack loaded. That the video driver is not capable of handling that
> correct is certainly not the problem of userspace.
> 
> Second it's not only userspace racing here, you can get into this kind of
> issues just because of transparent huge page support where the background
> daemon tries to reallocate the page tables into bigger chunks.
> 
> And if I'm not completely mistaken you can also open up quite a bunch of
> security problems if you suddenly access the wrong page.

I get a feeling we're talking past each another here. Can you perhaps
explain what exactly the race is you're seeing? The i915 userptr code is
fairly convoluted and pushes a lot of stuff to workers (but then syncs
with those workers again later on), so easily possible you've overlooked
one of these lines that might guarantee already what you think needs to be
guaranteed. We're definitely not aiming to allow userspace to allow
writing to random pages all over.

> > Leaking the IOMMU mappings otoh means rogue userspace could do a bunch of
> > stray writes (I don't see anywhere code in amdgpu_mn.c to unmap at least
> > the gpu side PTEs to make stuff inaccessible) and wreak the core kernel's
> > book-keeping.
> > 
> > In i915 we guarantee that we call set_page_dirty/mark_page_accessed only
> > after all the mappings are really gone (both GPU PTEs and sg mapping),
> > guaranteeing that any stray writes from either the GPU or IOMMU will
> > result in faults (except bugs in the IOMMU, but can't have it all, "IOMMU
> > actually works" is an assumption behind device isolation).
> Well exactly that's the point, the handling in i915 looks incorrect to me.
> You need to call set_page_dirty/mark_page_accessed way before the mapping is
> destroyed.
> 
> To be more precise for userptrs it must be called from the
> invalidate_range_start, but i915 seems to delegate everything into a
> background worker to avoid the locking problems.

Yeah, and at the end of the function there's a flush_work to make sure the
worker has caught up.

The set_page_dirty is also there, but hidden very deep in the call chain
as part of the vma unmapping and backing storage unpinning. But I do think
we guarantee what you expect needs to happen.

> > > Felix and I hammered for quite some time on amdgpu until all of this was
> > > handled correctly, see drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c.
> > Maybe we should have more shared code in this, it seems to be a source of
> > endless amounts of fun ...
> > 
> > > I can try to gather the lockdep splat from my mail history, but it
> > > essentially took us multiple years to get rid of all of them.
> > I'm very much interested in specifically the splat that makes it
> > impossible for you folks to remove the sg mappings. That one sounds bad.
> > And would essentially make mmu_notifiers useless for their primary use
> > case, which is handling virtual machines where you really have to make
> > sure the IOMMU mapping is gone before you claim it's gone, because there's
> > no 2nd level of device checks (like GPU PTEs, or command checker) catching
> > stray writes.
> 
> Well to be more precise the problem is not that we can't destroy the sg
> table, but rather that we can't grab the locks to do so.
> 
> See when you need to destroy the sg table you usually need to grab the same
> lock you grabbed when you created it.
> 
> And all locks taken while in an MMU notifier can only depend on memory
> allocation with GFP_NOIO, which is not really feasible for gfx drivers.

I know. i915 gem has tons of fallbacks and retry loops (we restart the
entire CS if needed), and i915 userptr pushes the entire get_user_pages
dance off into a worker if the fastpath doesn't succeed and we run out of
memory or hit contended locks. We also have obscene amounts of
__GFP_NORETRY and __GFP_NOWARN all over the place to make sure the core mm
code doesn't do something we don't want it do to do in the fastpaths
(because there's really no point in spending lots of time trying to make
memory available if we have a slowpath fallback with much less
constraints).

We're also not limiting ourselves to GFP_NOIO, but instead have a
recursion detection&handling in our own shrinker callback to avoid these
deadlocks.

It's definitely not easy, and there's lots of horrible code, but it is
possible. Just not releasing the sg mappings while you no longer own the
memory isn't an option imo.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
