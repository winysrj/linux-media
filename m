Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50130 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbeDXSsu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 14:48:50 -0400
Date: Tue, 24 Apr 2018 11:48:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180424184847.GA3247@infradead.org>
References: <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org>
 <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180420152111.GR31310@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 05:21:11PM +0200, Daniel Vetter wrote:
> > At the very lowest level they will need to be handled differently for
> > many architectures, the questions is at what point we'll do the
> > branching out.
> 
> Having at least struct page also in that list with (dma_addr_t, lenght)
> pairs has a bunch of benefits for drivers in unifying buffer handling
> code. You just pass that one single list around, use the dma_addr_t side
> for gpu access (generally bashing it into gpu ptes). And the struct page
> (if present) for cpu access, using kmap or vm_insert_*. We generally
> ignore virt, if we do need a full mapping then we construct a vmap for
> that buffer of our own.

Well, for mapping a resource (which gets back to the start of the
discussion) you will need an explicit virt pointer.  You also need
an explicit virt pointer and not just page_address/kmap for users of
dma_get_sgtable, because for many architectures you will need to flush
the virtual address used to access the data, which might be a
vmap/ioremap style mapping retourned from dma_alloc_address, and not
the directly mapped kernel address.

Here is another idea at the low-level dma API level:

 - dma_get_sgtable goes away.  The replacement is a new
   dma_alloc_remap helper that takes the virtual address returned
   from dma_alloc_attrs/coherent and creates a dma_addr_t for the
   given new device.  If the original allocation was a coherent
   one no cache flushing is required either (because the arch
   made sure it is coherent), if the original allocation used
   DMA_ATTR_NON_CONSISTENT the new allocation will need
   dma_cache_sync calls as well.
 - you never even try to share a mapping retourned from
   dma_map_resource - instead each device using it creates a new
   mapping, which makes sense as no virtual addresses are involved
   at all.

> So maybe a list of (struct page *, dma_addr_t, num_pages) would suit best,
> with struct page * being optional (if it's a resource, or something else
> that the kernel core mm isn't aware of). But that only has benefits if we
> really roll it out everywhere, in all the subsystems and drivers, since if
> we don't we've made the struct pages ** <-> sgt conversion fun only worse
> by adding a 3 representation of gpu buffer object backing storage.

I think the most important thing about such a buffer object is that
it can distinguish the underlying mapping types.  While
dma_alloc_coherent, dma_alloc_attrs with DMA_ATTR_NON_CONSISTENT,
dma_map_page/dma_map_single/dma_map_sg and dma_map_resource all give
back a dma_addr_t they are in now way interchangable.  And trying to
stuff them all into a structure like struct scatterlist that has
no indication what kind of mapping you are dealing with is just
asking for trouble.
