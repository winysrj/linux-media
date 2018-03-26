Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:44747 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbeCZPme (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 11:42:34 -0400
Received: by mail-qt0-f178.google.com with SMTP id j26so20005369qtl.11
        for <linux-media@vger.kernel.org>; Mon, 26 Mar 2018 08:42:33 -0700 (PDT)
Date: Mon, 26 Mar 2018 11:42:24 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: christian.koenig@amd.com, Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180326154224.GA11930@gmail.com>
References: <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
 <20180322071804.GH14155@phenom.ffwll.local>
 <ef9fa9a2-c368-1fca-a8ac-8ee8d522b6ab@gmail.com>
 <20180326080121.GO14155@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180326080121.GO14155@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 26, 2018 at 10:01:21AM +0200, Daniel Vetter wrote:
> On Thu, Mar 22, 2018 at 10:58:55AM +0100, Christian König wrote:
> > Am 22.03.2018 um 08:18 schrieb Daniel Vetter:
> > > On Wed, Mar 21, 2018 at 12:54:20PM +0100, Christian König wrote:
> > > > Am 21.03.2018 um 09:28 schrieb Daniel Vetter:
> > > > > On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
> > > > > > Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
> > > > > > > [SNIP]
> > > > > > > For the in-driver reservation path (CS) having a slow-path that grabs a
> > > > > > > temporary reference, drops the vram lock and then locks the reservation
> > > > > > > normally (using the acquire context used already for the entire CS) is a
> > > > > > > bit tricky, but totally feasible. Ttm doesn't do that though.
> > > > > > That is exactly what we do in amdgpu as well, it's just not very efficient
> > > > > > nor reliable to retry getting the right pages for a submission over and over
> > > > > > again.
> > > > > Out of curiosity, where's that code? I did read the ttm eviction code way
> > > > > back, and that one definitely didn't do that. Would be interesting to
> > > > > update my understanding.
> > > > That is in amdgpu_cs.c. amdgpu_cs_parser_bos() does a horrible dance with
> > > > grabbing, releasing and regrabbing locks in a loop.
> > > > 
> > > > Then in amdgpu_cs_submit() we grab an lock preventing page table updates and
> > > > check if all pages are still the one we want to have:
> > > > >          amdgpu_mn_lock(p->mn);
> > > > >          if (p->bo_list) {
> > > > >                  for (i = p->bo_list->first_userptr;
> > > > >                       i < p->bo_list->num_entries; ++i) {
> > > > >                          struct amdgpu_bo *bo = p->bo_list->array[i].robj;
> > > > > 
> > > > >                          if
> > > > > (amdgpu_ttm_tt_userptr_needs_pages(bo->tbo.ttm)) {
> > > > >                                  amdgpu_mn_unlock(p->mn);
> > > > >                                  return -ERESTARTSYS;
> > > > >                          }
> > > > >                  }
> > > > >          }
> > > > If anything changed on the page tables we restart the whole IOCTL using
> > > > -ERESTARTSYS and try again.
> > > I'm not talking about userptr here, but general bo eviction. Sorry for the
> > > confusion.
> > > 
> > > The reason I'm dragging all the general bo management into this
> > > discussions is because we do seem to have fairly fundamental difference in
> > > how that's done, with resulting consequences for the locking hierarchy.
> > > 
> > > And if this invalidate_mapping stuff should work, together with userptr
> > > and everything else, I think we're required to agree on how this is all
> > > supposed to nest, and how exactly we should back off for the other side
> > > that needs to break the locking circle.
> > > 
> > > That aside, I don't entirely understand why you need to restart so much. I
> > > figured that get_user_pages is ordered correctly against mmu
> > > invalidations, but I get the impression you think that's not the case. How
> > > does that happen?
> > 
> > Correct. I've had the same assumption, but both Jerome as well as our
> > internal tests proved me wrong on that.
> > 
> > Key take away from that was that you can't take any locks from neither the
> > MMU notifier nor the shrinker you also take while calling kmalloc (or
> > simpler speaking get_user_pages()).
> > 
> > Additional to that in the MMU or shrinker callback all different kinds of
> > locks might be held, so you basically can't assume that you do thinks like
> > recursive page table walks or call dma_unmap_anything.
> 
> That sounds like a design bug in mmu_notifiers, since it would render them
> useless for KVM. And they were developed for that originally. I think I'll
> chat with Jerome to understand this, since it's all rather confusing.

Doing dma_unmap() during mmu_notifier callback should be fine, it was last
time i check. However there is no formal contract that it is ok to do so.
But i want to revisit DMA API to something where device driver get control
rather than delegate. High level ideas are:
  - device driver allocate DMA space ie range of physical bus address
  - device driver completely manage the range in whichever ways it wants
    under its own locking.
  - DMA provide API to flush tlb/cache of a range of physical bus address
    with the explicit contract that it can only take short lived spinlock
    to do so and not allocate or free memory while doing so (ie it should
    only be a bunch of registers writes)

I haven't had time to prototype this but i floated the idea a while back
and i am hoping to discuss it some more sooner rather than latter (LSF/MM
is coming soon).


So from a safety point of view i would argue that you must be doing dma_unmap()
from invalidate_range_start() callback. But it all depends on how confident
you are in your hardware mmu and the IOMMU (IOMMU usualy have small cache so
unless there is no PCIE traffic all pending PCIE transaction should post
quicker than it takes the CPU to finish your invalidate_range_start() function.

So for now i would say it is ok to not dma_unmap().


> > Thinking a moment about that it actually seems to make perfect sense.
> > So it doesn't matter what order you got between the mmap_sem and your buffer
> > or allocation lock, it will simply be incorrect with other locks in the
> > system anyway.
> 
> Hm, doesn't make sense to me, at least from a locking  inversion pov. I
> thought the only locks that are definitely part of the mmu_nofitier
> callback contexts are the mm locks. We're definitely fine with those, and
> kmalloc didn't bite us yet. Direct reclaim is really limited in what it
> can accomplish for good reasons.
> 
> So the only thing I'm worried here is that we have a race between the
> invalidate and the gup calls, and I think fixing that race will make the
> locking more fun. But again, if that means you can'd dma_unmap stuff then
> that feels like mmu notifiers are broken by design.
> -Daniel
> 
> > The only solution to that problem we have found is the dance we have in
> > amdgpu now:
> > 
> > 1. Inside invalidate_range_start you grab a recursive read side lock.
> > 2. Wait for all GPU operation on that pages to finish.
> > 3. Then mark all pages as dirty and accessed.
> > 4. Inside invalidate_range_end you release your recursive read side lock
> > again.
> > 
> > Then during command submission you do the following:
> > 
> > 1. Take the locks Figure out all the userptr BOs which needs new pages.
> > 2. Drop the locks again call get_user_pages().
> > 3. Install the new page arrays and reiterate with #1
> > 4. As soon as everybody has pages update your page tables and prepare all
> > command submission.
> > 5. Take the write side of our recursive lock.
> > 6. Check if all pages are still valid, if not restart the whole IOCTL.
> > 7. Submit the job to the hardware.
> > 8. Drop the write side of our recursive lock.

A slightly better solution is using atomic counter:
  driver_range_start() {
    atomic_inc(&mydev->notifier_count);
    lock(mydev->bo_uptr); // protecting bo list/tree
    for_each_uptr_bo() {
       invalidate_bo(bo, start, end);
    }
    unlock(mydev->bo_uptr);
  }

  driver_range_end() {
    atomic_inc(&mydev->notifier_seq);
    atomic_dec(&mydev->notifier_count);
  }

  driver_bo_gup_pages(bo, mydev) {
    unsigned curseq;
    do {
      wait_on_mmu_notifier_count_to_zero();
      curseq = atomic_read(&mydev->notifier_seq);
      for (i = 0; i < npages; i++) {
        pages[i] = gup(addr + (i << PAGE_SHIFT));
      }
      lock(mydev->bo_uptr); // protecting bo list/tree
      if (curseq == atomic_read(&mydev->notifier_seq) &&
          !atomic_read(mydev->notifier_count)) {
         add_uptr_bo(bo, pages);
         bo->seq = curseq;
         unlock(mydev->bo_uptr);
         return 0;
      }
      unlock(mydev->bo_uptr);
      put_all_pages(pages);
    } while (1);
  }

Maybe use KVM as a real example of how to do this (see virt/kvm/kvm_main.c)

Note that however my endgame is bit more simpler. Convert amd, intel to use
HMM CPU page table snapshot tool (and no you do not need page fault for that
you can use that feature independently).

So it would be:
  driver_bo_hmm_invalidate() {
    lock(mydev->bo_uptr); // protecting bo list/tree
    for_each_uptr_bo() {
       invalidate_bo(bo, start, end);
    }
    unlock(mydev->bo_uptr);
  }

  driver_bo_gup_pages(bo, mydev) {
    do {
      hmm_vma_fault(range, bo->start, bo->end, bo->pfns);
      lock(mydev->bo_uptr);
      if (hmm_vma_range_done(range)) {
         add_uptr_bo(bo, pfns);
      }
      unlock(mydev->bo_uptr);
    } while (1);
  }

I would like to see driver using same code, as it means one place to fix
issues. I had for a long time on my TODO list doing the above conversion
to amd or radeon kernel driver. I am pushing up my todo list hopefully in
next few weeks i can send an rfc so people can have a real sense of how
it can look.


Cheers,
Jérôme
