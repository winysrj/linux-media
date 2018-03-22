Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:52705 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbeCVHSJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 03:18:09 -0400
Received: by mail-wm0-f67.google.com with SMTP id l9so13969978wmh.2
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 00:18:08 -0700 (PDT)
Date: Thu, 22 Mar 2018 08:18:04 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180322071804.GH14155@phenom.ffwll.local>
References: <152120831102.25315.4326885184264378830@mail.alporthouse.com>
 <21879456-db47-589c-b5e2-dfe8333d9e4c@gmail.com>
 <152147480241.18954.4556582215766884582@mail.alporthouse.com>
 <0bd85f69-c64c-70d1-a4a0-10ae0ed8b4e8@gmail.com>
 <CAKMK7uH3xNkx3UFBMdcJ415F2WsC7s_D+CDAjLAh1p-xo5RfSA@mail.gmail.com>
 <19ed21a5-805d-271f-9120-49e0c00f510f@amd.com>
 <20180320140810.GU14155@phenom.ffwll.local>
 <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 21, 2018 at 12:54:20PM +0100, Christian König wrote:
> Am 21.03.2018 um 09:28 schrieb Daniel Vetter:
> > On Tue, Mar 20, 2018 at 06:47:57PM +0100, Christian König wrote:
> > > Am 20.03.2018 um 15:08 schrieb Daniel Vetter:
> > > > [SNIP]
> > > > For the in-driver reservation path (CS) having a slow-path that grabs a
> > > > temporary reference, drops the vram lock and then locks the reservation
> > > > normally (using the acquire context used already for the entire CS) is a
> > > > bit tricky, but totally feasible. Ttm doesn't do that though.
> > > That is exactly what we do in amdgpu as well, it's just not very efficient
> > > nor reliable to retry getting the right pages for a submission over and over
> > > again.
> > Out of curiosity, where's that code? I did read the ttm eviction code way
> > back, and that one definitely didn't do that. Would be interesting to
> > update my understanding.
> 
> That is in amdgpu_cs.c. amdgpu_cs_parser_bos() does a horrible dance with
> grabbing, releasing and regrabbing locks in a loop.
> 
> Then in amdgpu_cs_submit() we grab an lock preventing page table updates and
> check if all pages are still the one we want to have:
> >         amdgpu_mn_lock(p->mn);
> >         if (p->bo_list) {
> >                 for (i = p->bo_list->first_userptr;
> >                      i < p->bo_list->num_entries; ++i) {
> >                         struct amdgpu_bo *bo = p->bo_list->array[i].robj;
> > 
> >                         if
> > (amdgpu_ttm_tt_userptr_needs_pages(bo->tbo.ttm)) {
> >                                 amdgpu_mn_unlock(p->mn);
> >                                 return -ERESTARTSYS;
> >                         }
> >                 }
> >         }
> 
> If anything changed on the page tables we restart the whole IOCTL using
> -ERESTARTSYS and try again.

I'm not talking about userptr here, but general bo eviction. Sorry for the
confusion.

The reason I'm dragging all the general bo management into this
discussions is because we do seem to have fairly fundamental difference in
how that's done, with resulting consequences for the locking hierarchy.

And if this invalidate_mapping stuff should work, together with userptr
and everything else, I think we're required to agree on how this is all
supposed to nest, and how exactly we should back off for the other side
that needs to break the locking circle.

That aside, I don't entirely understand why you need to restart so much. I
figured that get_user_pages is ordered correctly against mmu
invalidations, but I get the impression you think that's not the case. How
does that happen?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
