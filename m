Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:50339 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753269AbeCTOIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 10:08:16 -0400
Received: by mail-wm0-f45.google.com with SMTP id f19so3752431wmc.0
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2018 07:08:15 -0700 (PDT)
Date: Tue, 20 Mar 2018 15:08:10 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180320140810.GU14155@phenom.ffwll.local>
References: <20180316132049.1748-1-christian.koenig@amd.com>
 <20180316132049.1748-2-christian.koenig@amd.com>
 <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2018 at 11:54:18AM +0100, Christian König wrote:
> Am 20.03.2018 um 08:44 schrieb Daniel Vetter:
> > On Mon, Mar 19, 2018 at 5:23 PM, Christian König
> > <ckoenig.leichtzumerken@gmail.com> wrote:
> > > Am 19.03.2018 um 16:53 schrieb Chris Wilson:
> > > > Quoting Christian König (2018-03-16 14:22:32)
> > > > [snip, probably lost too must context]
> > > > > This allows for full grown pipelining, e.g. the exporter can say I need
> > > > > to move the buffer for some operation. Then let the move operation wait
> > > > > for all existing fences in the reservation object and install the fence
> > > > > of the move operation as exclusive fence.
> > > > Ok, the situation I have in mind is the non-pipelined case: revoking
> > > > dma-buf for mmu_invalidate_range or shrink_slab. I would need a
> > > > completion event that can be waited on the cpu for all the invalidate
> > > > callbacks. (Essentially an atomic_t counter plus struct completion; a
> > > > lighter version of dma_fence, I wonder where I've seen that before ;)
> > > 
> > > Actually that is harmless.
> > > 
> > > When you need to unmap a DMA-buf because of mmu_invalidate_range or
> > > shrink_slab you need to wait for it's reservation object anyway.
> > reservation_object only prevents adding new fences, you still have to
> > wait for all the current ones to signal. Also, we have dma-access
> > without fences in i915. "I hold the reservation_object" does not imply
> > you can just go and nuke the backing storage.
> 
> I was not talking about taking the lock, but rather using
> reservation_object_wait_timeout_rcu().
> 
> To be more precise you actually can't take the reservation object lock in an
> mmu_invalidate_range callback and you can only trylock it in a shrink_slab
> callback.

Ah ok, and yes agreed. Kinda. See below.

> > > This needs to be done to make sure that the backing memory is now idle, it
> > > doesn't matter if the jobs where submitted by DMA-buf importers or your own
> > > driver.
> > > 
> > > The sg tables pointing to the now released memory might live a bit longer,
> > > but that is unproblematic and actually intended.
> > I think that's very problematic. One reason for an IOMMU is that you
> > have device access isolation, and a broken device can't access memory
> > it shouldn't be able to access. From that security-in-depth point of
> > view it's not cool that there's some sg tables hanging around still
> > that a broken GPU could use. And let's not pretend hw is perfect,
> > especially GPUs :-)
> 
> I completely agree on that, but there is unfortunately no other way.
> 
> See you simply can't take a reservation object lock in an mmu or slab
> callback, you can only trylock them.
> 
> For example it would require changing all allocations done while holding any
> reservation lock to GFP_NOIO.

Yeah mmu and slab can only trylock, and they need to skip to the next
object when the trylock fails. But once you have the lock you imo should
be able to clean up the entire mess still. We definitely do that for the
i915 shrinkers, and I don't see how going to importers through the
->invalidate_mapping callback changes anything with that.

For the in-driver reservation path (CS) having a slow-path that grabs a
temporary reference, drops the vram lock and then locks the reservation
normally (using the acquire context used already for the entire CS) is a
bit tricky, but totally feasible. Ttm doesn't do that though.

So there's completely feasible ways to make sure the sg list is all
properly released, all DMA gone and the IOMMU mappings torn down. Anything
else is just a bit shoddy device driver programming imo.

> > > When we would try to destroy the sg tables in an mmu_invalidate_range or
> > > shrink_slab callback we would run into a lockdep horror.
> > So I'm no expert on this, but I think this is exactly what we're doing
> > in i915. Kinda no other way to actually free the memory without
> > throwing all the nice isolation aspects of an IOMMU into the wind. Can
> > you please paste the lockdeps you've seen with amdgpu when trying to
> > do that?
> 
> Taking a quick look at i915 I can definitely say that this is actually quite
> buggy what you guys do here.

Note that there are 2 paths for i915 userptr. One is the mmu notifier, the
other one is the root-only hack we have for dubious reasons (or that I
really don't see the point in myself).

> For coherent usage you need to install some lock to prevent concurrent
> get_user_pages(), command submission and
> invalidate_range_start/invalidate_range_end from the MMU notifier.
> 
> Otherwise you can't guarantee that you are actually accessing the right page
> in the case of a fork() or mprotect().

Yeah doing that with a full lock will create endless amounts of issues,
but I don't see why we need that. Userspace racing stuff with itself gets
to keep all the pieces. This is like racing DIRECT_IO against mprotect and
fork.

Leaking the IOMMU mappings otoh means rogue userspace could do a bunch of
stray writes (I don't see anywhere code in amdgpu_mn.c to unmap at least
the gpu side PTEs to make stuff inaccessible) and wreak the core kernel's
book-keeping.

In i915 we guarantee that we call set_page_dirty/mark_page_accessed only
after all the mappings are really gone (both GPU PTEs and sg mapping),
guaranteeing that any stray writes from either the GPU or IOMMU will
result in faults (except bugs in the IOMMU, but can't have it all, "IOMMU
actually works" is an assumption behind device isolation).

> Felix and I hammered for quite some time on amdgpu until all of this was
> handled correctly, see drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c.

Maybe we should have more shared code in this, it seems to be a source of
endless amounts of fun ...

> I can try to gather the lockdep splat from my mail history, but it
> essentially took us multiple years to get rid of all of them.

I'm very much interested in specifically the splat that makes it
impossible for you folks to remove the sg mappings. That one sounds bad.
And would essentially make mmu_notifiers useless for their primary use
case, which is handling virtual machines where you really have to make
sure the IOMMU mapping is gone before you claim it's gone, because there's
no 2nd level of device checks (like GPU PTEs, or command checker) catching
stray writes.

Cheers, Daniel

> 
> Regards,
> Christian.
> 
> > -Daniel
> > 
> > > Regards,
> > > Christian.
> > > 
> > > > Even so, it basically means passing a fence object down to the async
> > > > callbacks for them to signal when they are complete. Just to handle the
> > > > non-pipelined version. :|
> > > > -Chris
> > > > _______________________________________________
> > > > dri-devel mailing list
> > > > dri-devel@lists.freedesktop.org
> > > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> > > 
> > > _______________________________________________
> > > Linaro-mm-sig mailing list
> > > Linaro-mm-sig@lists.linaro.org
> > > https://lists.linaro.org/mailman/listinfo/linaro-mm-sig
> > 
> > 
> 

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
