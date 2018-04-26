Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:56223 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753629AbeDZJp1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:45:27 -0400
Received: by mail-it0-f46.google.com with SMTP id 144-v6so8928926iti.5
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 02:45:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180426090942.GA18811@infradead.org>
References: <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org> <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org> <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org> <CAKMK7uH14qupTYDa1pr8UC434Vs+97eUXj+fYi=+2uijCLayMA@mail.gmail.com>
 <20180426090942.GA18811@infradead.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 26 Apr 2018 11:45:26 +0200
Message-ID: <CAKMK7uF9UpFe=nuV29as54mvO7s-kJV4nLa-Uju3jqZU9Ebw6w@mail.gmail.com>
Subject: Re: noveau vs arm dma ops
To: Christoph Hellwig <hch@infradead.org>
Cc: Thierry Reding <treding@nvidia.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>, iommu@lists.linux-foundation.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 11:09 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 25, 2018 at 11:35:13PM +0200, Daniel Vetter wrote:
>> > get_required_mask() is supposed to tell you if you are safe.  However
>> > we are missing lots of implementations of it for iommus so you might get
>> > some false negatives, improvements welcome.  It's been on my list of
>> > things to fix in the DMA API, but it is nowhere near the top.
>>
>> I hasn't come up in a while in some fireworks, so I honestly don't
>> remember exactly what the issues have been. But
>>
>> commit d766ef53006c2c38a7fe2bef0904105a793383f2
>> Author: Chris Wilson <chris@chris-wilson.co.uk>
>> Date:   Mon Dec 19 12:43:45 2016 +0000
>>
>>     drm/i915: Fallback to single PAGE_SIZE segments for DMA remapping
>>
>> and the various bits of code that a
>>
>> $ git grep SWIOTLB -- drivers/gpu
>>
>> turns up is what we're doing to hack around that stuff. And in general
>> (there's some exceptions) gpus should be able to address everything,
>> so I never fully understood where that's even coming from.
>
> I'm pretty sure I've seen some oddly low dma masks in GPU drivers.  E.g.
> duplicated in various AMD files:
>
>         adev->need_dma32 = false;
>         dma_bits = adev->need_dma32 ? 32 : 40;
>         r = pci_set_dma_mask(adev->pdev, DMA_BIT_MASK(dma_bits));
>         if (r) {
>                 adev->need_dma32 = true;
>                 dma_bits = 32;
>                 dev_warn(adev->dev, "amdgpu: No suitable DMA available.\n");
>         }
>
> synopsis:
>
> drivers/gpu/drm/bridge/synopsys/dw-hdmi-i2s-audio.c:    pdevinfo.dma_mask       = DMA_BIT_MASK(32);
> drivers/gpu/drm/bridge/synopsys/dw-hdmi.c:              pdevinfo.dma_mask = DMA_BIT_MASK(32);
> drivers/gpu/drm/bridge/synopsys/dw-hdmi.c:              pdevinfo.dma_mask = DMA_BIT_MASK(32);
>
> etnaviv gets it right:
>
> drivers/gpu/drm/etnaviv/etnaviv_gpu.c:          u32 dma_mask = (u32)dma_get_required_mask(gpu->dev);
>
>
> But yes, the swiotlb hackery really irks me.  I just have some more
> important and bigger fires to fight first, but I plan to get back to the
> root cause of that eventually.
>
>>
>> >> - dma api hides the cache flushing requirements from us. GPUs love
>> >>   non-snooped access, and worse give userspace control over that. We want
>> >>   a strict separation between mapping stuff and flushing stuff. With the
>> >>   IOMMU api we mostly have the former, but for the later arch maintainers
>> >>   regularly tells they won't allow that. So we have drm_clflush.c.
>> >
>> > The problem is that a cache flushing API entirely separate is hard. That
>> > being said if you look at my generic dma-noncoherent API series it tries
>> > to move that way.  So far it is in early stages and apparently rather
>> > buggy unfortunately.
>>
>> I'm assuming this stuff here?
>>
>> https://lkml.org/lkml/2018/4/20/146
>>
>> Anyway got lost in all that work a bit, looks really nice.
>
> That url doesn't seem to work currently.  But I am talking about the
> thread titled '[RFC] common non-cache coherent direct dma mapping ops'
>
>> Yeah the above is pretty much what we do on x86. dma-api believes
>> everything is coherent, so dma_map_sg does the mapping we want and
>> nothing else (minus swiotlb fun). Cache flushing, allocations, all
>> done by the driver.
>
> Which sounds like the right thing to do to me.
>
>> On arm that doesn't work. The iommu api seems like a good fit, except
>> the dma-api tends to get in the way a bit (drm/msm apparently has
>> similar problems like tegra), and if you need contiguous memory
>> dma_alloc_coherent is the only way to get at contiguous memory. There
>> was a huge discussion years ago about that, and direct cma access was
>> shot down because it would have exposed too much of the caching
>> attribute mangling required (most arm platforms need wc-pages to not
>> be in the kernel's linear map apparently).
>
> Simple cma_alloc() doesn't do anything about cache handling, it
> just is a very dumb allocator for large contiguous regions inside
> a big pool.
>
> I'm not the CMA maintainer, but in general I'd love to see an
> EXPORT_SYMBOL_GPL slapped onto cma_alloc/release and drivers use
> that were needed.  Using that plus dma_map*/dma_unmap* sounds like
> a much saner interface than dma_alloc_attrs + DMA_ATTR_NON_CONSISTENT
> or DMA_ATTR_NO_KERNEL_MAPPING.
>
> You don't happen to have a pointer to that previous discussion?

I'll try to dig them up, I tried to stay as far away from that
discussion as possible (since I have the luxury to not care for intel
gpus).

>> Anything that separate these 3 things more (allocation pools, mapping
>> through IOMMUs and flushing cpu caches) sounds like the right
>> direction to me. Even if that throws some portability across platforms
>> away - drivers who want to control things in this much detail aren't
>> really portable (without some serious work) anyway.
>
> As long as we stay away from the dma coherent allocations separating
> them is fine, and I'm working towards it.  dma coherent allocations on
> the other hand are very hairy beasts, and provide by very different
> implementations depending on the architecture, or often even depending
> on the specifics of individual implementations inside the architecture.
>
> So for your GPU/media case it seems like you'd better stay away from
> them as much as you can.

Hm, at least on x86 we do set up write-combine mappings ourselves (by
calling relevant functions, which also changes the kernel mapping to
avoid aliasing fun). Of course that means the gpu drivers are less
portable, but then they're not really all that portable anyway - the
buffer handling code always needs to be tuned for the platform you're
running on. GPUs really love write-combining everything (we do the
same for our mmio mappings to kernel/userspace, see stuff like
io-mapping.h.

But in many other cases dma_alloc_coherent is only used because it's
the convenient/only way to allocate the memory we need.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
