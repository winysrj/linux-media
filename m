Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:54844 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752439AbeDZJRr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:17:47 -0400
Received: by mail-it0-f48.google.com with SMTP id h143-v6so23548377ita.4
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 02:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180425232646.GR16141@n2100.armlinux.org.uk>
References: <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org> <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org> <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org> <CAKMK7uH14qupTYDa1pr8UC434Vs+97eUXj+fYi=+2uijCLayMA@mail.gmail.com>
 <20180425232646.GR16141@n2100.armlinux.org.uk>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 26 Apr 2018 11:17:46 +0200
Message-ID: <CAKMK7uGF9HAkBPK1+p9fPqP-fdSUOE+i=RGdUPfUiJh8uSnKRg@mail.gmail.com>
Subject: Re: noveau vs arm dma ops
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Jerome Glisse <jglisse@redhat.com>,
        iommu@lists.linux-foundation.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Thierry Reding <treding@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 26, 2018 at 1:26 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Apr 25, 2018 at 11:35:13PM +0200, Daniel Vetter wrote:
>> On arm that doesn't work. The iommu api seems like a good fit, except
>> the dma-api tends to get in the way a bit (drm/msm apparently has
>> similar problems like tegra), and if you need contiguous memory
>> dma_alloc_coherent is the only way to get at contiguous memory. There
>> was a huge discussion years ago about that, and direct cma access was
>> shot down because it would have exposed too much of the caching
>> attribute mangling required (most arm platforms need wc-pages to not
>> be in the kernel's linear map apparently).
>
> I think you completely misunderstand ARM from what you've written above,
> and this worries me greatly about giving DRM the level of control that
> is being asked for.
>
> Modern ARMs have a PIPT cache or a non-aliasing VIPT cache, and cache
> attributes are stored in the page tables.  These caches are inherently
> non-aliasing when there are multiple mappings (which is a great step
> forward compared to the previous aliasing caches.)
>
> As the cache attributes are stored in the page tables, this in theory
> allows different virtual mappings of the same physical memory to have
> different cache attributes.  However, there's a problem, and that's
> called speculative prefetching.
>
> Let's say you have one mapping which is cacheable, and another that is
> marked as write combining.  If a cache line is speculatively prefetched
> through the cacheable mapping of this memory, and then you read the
> same physical location through the write combining mapping, it is
> possible that you could read cached data.
>
> So, it is generally accepted that all mappings of any particular
> physical bit of memory should have the same cache attributes to avoid
> unpredictable behaviour.
>
> This presents a problem with what is generally called "lowmem" where
> the memory is mapped in kernel virtual space with cacheable
> attributes.  It can also happen with highmem if the memory is
> kmapped.
>
> This is why, on ARM, you can't use something like get_free_pages() to
> grab some pages from the system, pass it to the GPU, map it into
> userspace as write-combining, etc.  It _might_ work for some CPUs,
> but ARM CPUs vary in how much prefetching they do, and what may work
> for one particular CPU is in no way guaranteed to work for another
> ARM CPU.
>
> The official line from architecture folk is to assume that the caches
> infinitely speculate, are of infinite size, and can writeback *dirty*
> data at any moment.
>
> The way to stop things like speculative prefetches to particular
> physical memory is to, quite "simply", not have any cacheable
> mappings of that physical memory anywhere in the system.
>
> Now, cache flushes on ARM tend to be fairly expensive for GPU buffers.
> If you have, say, an 8MB buffer (for a 1080p frame) and you need to
> do a cache operation on that buffer, you'll be iterating over it
> 32 or maybe 64 bytes at a time "just in case" there's a cache line
> present.  Referring to my previous email, where I detailed the
> potential need for _two_ flushes, one before the GPU operation and
> one after, and this becomes _really_ expensive.  At that point, you're
> probably way better off using write-combine memory where you don't
> need to spend CPU cycles performing cache flushing - potentially
> across all CPUs in the system if cache operations aren't broadcasted.
>
> This isn't a simple matter of "just provide some APIs for cache
> operations" - there's much more that needs to be understood by
> all parties here, especially when we have GPU drivers that can be
> used with quite different CPUs.
>
> It may well be that for some combinations of CPUs and workloads, it's
> better to use write-combine memory without cache flushing, but for
> other CPUs that tradeoff (for the same workload) could well be
> different.
>
> Older ARMs get more interesting, because they have aliasing caches.
> That means the CPU cache aliases across different virtual space
> mappings in some way, which complicates (a) the mapping of memory
> and (b) handling the cache operations on it.
>
> It's too late for me to go into that tonight, and I probably won't
> be reading mail for the next week and a half, sorry.

I didn't know all the details well enough (and neither had the time to
write a few paragraphs like you did), but the above is what I had in
mind and meant. Sorry if my sloppy reply sounded like I'm mixing stuff
up.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
