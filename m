Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:34550 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751517AbeDXTcV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 15:32:21 -0400
Received: by mail-io0-f182.google.com with SMTP id d6-v6so24109979iog.1
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 12:32:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180424184847.GA3247@infradead.org>
References: <20180403180832.GZ3881@phenom.ffwll.local> <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org> <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com> <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com> <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local> <20180424184847.GA3247@infradead.org>
From: Daniel Vetter <daniel@ffwll.ch>
Date: Tue, 24 Apr 2018 21:32:20 +0200
Message-ID: <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
To: Christoph Hellwig <hch@infradead.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Jerome Glisse <jglisse@redhat.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 24, 2018 at 8:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Apr 20, 2018 at 05:21:11PM +0200, Daniel Vetter wrote:
>> > At the very lowest level they will need to be handled differently for
>> > many architectures, the questions is at what point we'll do the
>> > branching out.
>>
>> Having at least struct page also in that list with (dma_addr_t, lenght)
>> pairs has a bunch of benefits for drivers in unifying buffer handling
>> code. You just pass that one single list around, use the dma_addr_t side
>> for gpu access (generally bashing it into gpu ptes). And the struct page
>> (if present) for cpu access, using kmap or vm_insert_*. We generally
>> ignore virt, if we do need a full mapping then we construct a vmap for
>> that buffer of our own.
>
> Well, for mapping a resource (which gets back to the start of the
> discussion) you will need an explicit virt pointer.  You also need
> an explicit virt pointer and not just page_address/kmap for users of
> dma_get_sgtable, because for many architectures you will need to flush
> the virtual address used to access the data, which might be a
> vmap/ioremap style mapping retourned from dma_alloc_address, and not
> the directly mapped kernel address.

Out of curiosity, how much virtual flushing stuff is there still out
there? At least in drm we've pretty much ignore this, and seem to be
getting away without a huge uproar (at least from driver developers
and users, core folks are less amused about that).

And at least for gpus that seems to have been the case since forever,
or at least since AGP was a thing 20 years ago: AGP isn't coherent, so
needs explicit cache flushing, and we have our own implementations of
that in drivers/char/agp. Luckily AGP died 10 years ago, so no one yet
proposed to port it all over to the iommu framework and hide it behind
the dma api (which really would be the "clean" way to do this, AGP is
simply an IOMMU + special socket dedicated for the add-on gpu).

> Here is another idea at the low-level dma API level:
>
>  - dma_get_sgtable goes away.  The replacement is a new
>    dma_alloc_remap helper that takes the virtual address returned
>    from dma_alloc_attrs/coherent and creates a dma_addr_t for the
>    given new device.  If the original allocation was a coherent
>    one no cache flushing is required either (because the arch
>    made sure it is coherent), if the original allocation used
>    DMA_ATTR_NON_CONSISTENT the new allocation will need
>    dma_cache_sync calls as well.

Yeah I think that should work. dma_get_sgtable is a pretty nasty
layering violation.

>  - you never even try to share a mapping retourned from
>    dma_map_resource - instead each device using it creates a new
>    mapping, which makes sense as no virtual addresses are involved
>    at all.

Yeah the dma-buf exporter always knows what kind of backing storage it
is dealing with, and for which struct device it should set up a new
view. Hence can make sure that it calls the right functions to
establish a new mapping, whether that's dma_map_sg, dma_map_resource
or the new dma_alloc_remap (instead of the dma_get_sgtable layering
mixup). The importer doesn't know.

>> So maybe a list of (struct page *, dma_addr_t, num_pages) would suit best,
>> with struct page * being optional (if it's a resource, or something else
>> that the kernel core mm isn't aware of). But that only has benefits if we
>> really roll it out everywhere, in all the subsystems and drivers, since if
>> we don't we've made the struct pages ** <-> sgt conversion fun only worse
>> by adding a 3 representation of gpu buffer object backing storage.
>
> I think the most important thing about such a buffer object is that
> it can distinguish the underlying mapping types.  While
> dma_alloc_coherent, dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT,
> dma_map_page/dma_map_single/dma_map_sg and dma_map_resource all give
> back a dma_addr_t they are in now way interchangable.  And trying to
> stuff them all into a structure like struct scatterlist that has
> no indication what kind of mapping you are dealing with is just
> asking for trouble.

Well the idea was to have 1 interface to allow all drivers to share
buffers with anything else, no matter how exactly they're allocated.
dma-buf has all the functions for flushing, so you can have coherent
mappings, non-coherent mappings and pretty much anything else. Or well
could, because in practice people hack up layering violations until it
works for the 2-3 drivers they care about. On top of that there's the
small issue that x86 insists that dma is coherent (and that's true for
most devices, including v4l drivers you might want to share stuff
with), and gpus really, really really do want to make almost
everything incoherent.

The end result is pretty epic :-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
