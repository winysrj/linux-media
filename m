Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:46588 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753256AbeDZJUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:20:45 -0400
Received: by mail-io0-f174.google.com with SMTP id f3-v6so30189247iob.13
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 02:20:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180425225443.GQ16141@n2100.armlinux.org.uk>
References: <20180424184847.GA3247@infradead.org> <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org> <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org> <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org> <20180425100429.GR25142@phenom.ffwll.local>
 <20180425153312.GD27076@infradead.org> <20180425225443.GQ16141@n2100.armlinux.org.uk>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Thu, 26 Apr 2018 11:20:44 +0200
Message-ID: <CAKMK7uG9R6paoP4BmvqDVUP_4Db4Dz8MSXeLwUBMYaORa5-kVw@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] noveau vs arm dma ops
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

On Thu, Apr 26, 2018 at 12:54 AM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Wed, Apr 25, 2018 at 08:33:12AM -0700, Christoph Hellwig wrote:
>> On Wed, Apr 25, 2018 at 12:04:29PM +0200, Daniel Vetter wrote:
>> > - dma api hides the cache flushing requirements from us. GPUs love
>> >   non-snooped access, and worse give userspace control over that. We want
>> >   a strict separation between mapping stuff and flushing stuff. With the
>> >   IOMMU api we mostly have the former, but for the later arch maintainers
>> >   regularly tells they won't allow that. So we have drm_clflush.c.
>>
>> The problem is that a cache flushing API entirely separate is hard. That
>> being said if you look at my generic dma-noncoherent API series it tries
>> to move that way.  So far it is in early stages and apparently rather
>> buggy unfortunately.
>
> And if folk want a cacheable mapping with explicit cache flushing, the
> cache flushing must not be defined in terms of "this is what CPU seems
> to need" but from the point of view of a CPU with infinite prefetching,
> infinite caching and infinite capacity to perform writebacks of dirty
> cache lines at unexpected moments when the memory is mapped in a
> cacheable mapping.
>
> (The reason for that is you're operating in a non-CPU specific space,
> so you can't make any guarantees as to how much caching or prefetching
> will occur by the CPU - different CPUs will do different amounts.)
>
> So, for example, the sequence:
>
> GPU writes to memory
>                         CPU reads from cacheable memory
>
> if the memory was previously dirty (iow, CPU has written), you need to
> flush the dirty cache lines _before_ the GPU writes happen, but you
> don't know whether the CPU has speculatively prefetched, so you need
> to flush any prefetched cache lines before reading from the cacheable
> memory _after_ the GPU has finished writing.
>
> Also note that "flush" there can be "clean the cache", "clean and
> invalidate the cache" or "invalidate the cache" as appropriate - some
> CPUs are able to perform those three operations, and the appropriate
> one depends on not only where in the above sequence it's being used,
> but also on what the operations are.
>
> So, the above sequence could be:
>
>                         CPU invalidates cache for memory
>                                 (due to possible dirty cache lines)
> GPU writes to memory
>                         CPU invalidates cache for memory
>                                 (to get rid of any speculatively prefetched
>                                  lines)
>                         CPU reads from cacheable memory
>
> Yes, in the above case, _two_ cache operations are required to ensure
> correct behaviour.  However, if you know for certain that the memory was
> previously clean, then the first cache operation can be skipped.
>
> What I'm pointing out is there's much more than just "I want to flush
> the cache" here, which is currently what DRM seems to assume at the
> moment with the code in drm_cache.c.
>
> If we can agree a set of interfaces that allows _proper_ use of these
> facilities, one which can be used appropriately, then there shouldn't
> be a problem.  The DMA API does that via it's ideas about who owns a
> particular buffer (because of the above problem) and that's something
> which would need to be carried over to such a cache flushing API (it
> should be pretty obvious that having a GPU read or write memory while
> the cache for that memory is being cleaned will lead to unexpected
> results.)
>
> Also note that things get even more interesting in a SMP environment
> if cache operations aren't broadcasted across the SMP cluster (which
> means cache operations have to be IPI'd to other CPUs.)
>
> The next issue, which I've brought up before, is that exposing cache
> flushing to userspace on architectures where it isn't already exposed
> comes.  As has been shown by Google Project Zero, this risks exposing
> those architectures to Spectre and Meltdown exploits where they weren't
> at such a risk before.  (I've pretty much shown here that you _do_
> need to control which cache lines get flushed to make these exploits
> work, and flushing the cache by reading lots of data in liu of having
> the ability to explicitly flush bits of cache makes it very difficult
> to impossible for them to work.)

The above is already what we're implementing in i915, at least
conceptually (it all boils down to clflush instructions because those
both invalidate and flush).

One architectural guarantee we're exploiting is that prefetched (and
hence non-dirty) cachelines will never get written back, but dropped
instead. But we kinda need that, otherwise the cpu could randomly
corrupt the data the gpu is writing and non-coherent would just not
work on those platforms. But aside from that, yes we do an invalidate
before reading, and flushing after every writing (or anything else
that could leave dirty cachelines behind). Plus a bit of tracking in
the driver (kernel/userspace both do this, together, with some
hilariously bad evolved semantics at least for i915, but oh well can't
fix uapi mistakes) to avoid redundant cacheline flushes/invalidates.

So ack.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
