Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:52256 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbeCTRsB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 13:48:01 -0400
Received: by mail-wm0-f43.google.com with SMTP id l9so5138943wmh.2
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 10:48:00 -0700 (PDT)
Reply-To: christian.koenig@amd.com
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
To: Daniel Vetter <daniel@ffwll.ch>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
Cc: "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
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
From: =?UTF-8?Q?Christian_K=c3=b6nig?= <ckoenig.leichtzumerken@gmail.com>
Message-ID: <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
Date: Tue, 20 Mar 2018 18:47:57 +0100
MIME-Version: 1.0
In-Reply-To: <20180320140810.GU14155@phenom.ffwll.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
> [SNIP]
> For the in-driver reservation path (CS) having a slow-path that grabs a
> temporary reference, drops the vram lock and then locks the reservation
> normally (using the acquire context used already for the entire CS) is a
> bit tricky, but totally feasible. Ttm doesn't do that though.

That is exactly what we do in amdgpu as well, it's just not very 
efficient nor reliable to retry getting the right pages for a submission 
over and over again.

> [SNIP]
> Note that there are 2 paths for i915 userptr. One is the mmu notifier, the
> other one is the root-only hack we have for dubious reasons (or that I
> really don't see the point in myself).

Well I'm referring to i915_gem_userptr.c, if that isn't what you are 
exposing then just feel free to ignore this whole discussion.

>> For coherent usage you need to install some lock to prevent concurrent
>> get_user_pages(), command submission and
>> invalidate_range_start/invalidate_range_end from the MMU notifier.
>>
>> Otherwise you can't guarantee that you are actually accessing the right page
>> in the case of a fork() or mprotect().
> Yeah doing that with a full lock will create endless amounts of issues,
> but I don't see why we need that. Userspace racing stuff with itself gets
> to keep all the pieces. This is like racing DIRECT_IO against mprotect and
> fork.

First of all I strongly disagree on that. A thread calling fork() 
because it wants to run a command is not something we can forbid just 
because we have a gfx stack loaded. That the video driver is not capable 
of handling that correct is certainly not the problem of userspace.

Second it's not only userspace racing here, you can get into this kind 
of issues just because of transparent huge page support where the 
background daemon tries to reallocate the page tables into bigger chunks.

And if I'm not completely mistaken you can also open up quite a bunch of 
security problems if you suddenly access the wrong page.

> Leaking the IOMMU mappings otoh means rogue userspace could do a bunch of
> stray writes (I don't see anywhere code in amdgpu_mn.c to unmap at least
> the gpu side PTEs to make stuff inaccessible) and wreak the core kernel's
> book-keeping.
>
> In i915 we guarantee that we call set_page_dirty/mark_page_accessed only
> after all the mappings are really gone (both GPU PTEs and sg mapping),
> guaranteeing that any stray writes from either the GPU or IOMMU will
> result in faults (except bugs in the IOMMU, but can't have it all, "IOMMU
> actually works" is an assumption behind device isolation).
Well exactly that's the point, the handling in i915 looks incorrect to 
me. You need to call set_page_dirty/mark_page_accessed way before the 
mapping is destroyed.

To be more precise for userptrs it must be called from the 
invalidate_range_start, but i915 seems to delegate everything into a 
background worker to avoid the locking problems.

>> Felix and I hammered for quite some time on amdgpu until all of this was
>> handled correctly, see drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c.
> Maybe we should have more shared code in this, it seems to be a source of
> endless amounts of fun ...
>
>> I can try to gather the lockdep splat from my mail history, but it
>> essentially took us multiple years to get rid of all of them.
> I'm very much interested in specifically the splat that makes it
> impossible for you folks to remove the sg mappings. That one sounds bad.
> And would essentially make mmu_notifiers useless for their primary use
> case, which is handling virtual machines where you really have to make
> sure the IOMMU mapping is gone before you claim it's gone, because there's
> no 2nd level of device checks (like GPU PTEs, or command checker) catching
> stray writes.

Well to be more precise the problem is not that we can't destroy the sg 
table, but rather that we can't grab the locks to do so.

See when you need to destroy the sg table you usually need to grab the 
same lock you grabbed when you created it.

And all locks taken while in an MMU notifier can only depend on memory 
allocation with GFP_NOIO, which is not really feasible for gfx drivers.

Regards,
Christian.
