Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:55259 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbeC0I1Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Mar 2018 04:27:16 -0400
Received: by mail-wm0-f48.google.com with SMTP id h76so20005870wme.4
        for <linux-media@vger.kernel.org>; Tue, 27 Mar 2018 01:27:16 -0700 (PDT)
Date: Tue, 27 Mar 2018 10:27:12 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: christian.koenig@amd.com
Cc: Daniel Vetter <daniel@ffwll.ch>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Jerome Glisse <j.glisse@gmail.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [PATCH 1/5] dma-buf: add optional
 invalidate_mappings callback v2
Message-ID: <20180327082712.GR14155@phenom.ffwll.local>
References: <37ba7394-2a5c-a0bc-cc51-c8a0edc2991d@gmail.com>
 <20180321082839.GA14155@phenom.ffwll.local>
 <327c4bc1-5813-16e8-62fc-4301b19a1a22@gmail.com>
 <20180322071804.GH14155@phenom.ffwll.local>
 <ef9fa9a2-c368-1fca-a8ac-8ee8d522b6ab@gmail.com>
 <20180326080121.GO14155@phenom.ffwll.local>
 <20180326154224.GA11930@gmail.com>
 <f8ff3993-6605-4f8e-5ac2-c40f0450c1c6@gmail.com>
 <20180327075334.GK14155@phenom.ffwll.local>
 <71f3f0cc-263d-bf60-aff8-6f2277884aaf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71f3f0cc-263d-bf60-aff8-6f2277884aaf@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 27, 2018 at 10:06:04AM +0200, Christian König wrote:
> Am 27.03.2018 um 09:53 schrieb Daniel Vetter:
> > [SNIP]
> > > > [SNIP]
> > > > A slightly better solution is using atomic counter:
> > > >     driver_range_start() {
> > > >       atomic_inc(&mydev->notifier_count);
> > > ...
> > > 
> > > Yeah, that is exactly what amdgpu is doing now. Sorry if my description
> > > didn't made that clear.
> > > 
> > > > I would like to see driver using same code, as it means one place to fix
> > > > issues. I had for a long time on my TODO list doing the above conversion
> > > > to amd or radeon kernel driver. I am pushing up my todo list hopefully in
> > > > next few weeks i can send an rfc so people can have a real sense of how
> > > > it can look.
> > > Certainly a good idea, but I think we might have that separate to HMM.
> > > 
> > > TTM suffered really from feature overload, e.g. trying to do everything in a
> > > single subsystem. And it would be rather nice to have coherent userptr
> > > handling for GPUs as separate feature.
> > TTM suffered from being a midlayer imo, not from doing too much.
> 
> Yeah, completely agree.
> 
> midlayers work as long as you concentrate on doing exactly one things in
> your midlayer. E.g. in the case of TTM the callback for BO move handling is
> well justified.
> 
> Only all the stuff around it like address space handling etc... is really
> wrong designed and should be separated (which is exactly what DRM MM did,
> but TTM still uses this in the wrong way).

Yeah the addres space allocator part of ttm really is backwards and makes
adding quick driver hacks and heuristics for better allocations schemes
really hard to add. Same for tuning how/what exactly you evict.

> > HMM is apparently structured like a toolbox (despite its documentation claiming
> > otherwise), so you can pick&choose freely.
> 
> That sounds good, but I would still have a better feeling if userptr
> handling would be separated. That avoids mangling things together again.

Jerome said he wants to do at least one prototype conversion of one of the
"I can't fault" userptr implementation over to the suitable subset of HMM
helpers. I guess we'll see once he's submitting the patches, but it
sounded exactly like what the doctor ordered :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
