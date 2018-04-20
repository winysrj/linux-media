Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42666 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755547AbeDTPVQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 11:21:16 -0400
Received: by mail-wr0-f193.google.com with SMTP id s18-v6so23983343wrg.9
        for <linux-media@vger.kernel.org>; Fri, 20 Apr 2018 08:21:15 -0700 (PDT)
Date: Fri, 20 Apr 2018 17:21:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christoph Hellwig <hch@infradead.org>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
Message-ID: <20180420152111.GR31310@phenom.ffwll.local>
References: <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org>
 <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
 <20180420124625.GA31078@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180420124625.GA31078@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 05:46:25AM -0700, Christoph Hellwig wrote:
> On Fri, Apr 20, 2018 at 12:44:01PM +0200, Christian König wrote:
> > > > What we need is an sg_alloc_table_from_resources(dev, resources,
> > > > num_resources) which does the handling common to all drivers.
> > > A structure that contains
> > > 
> > > {page,offset,len} + {dma_addr+dma_len}
> > > 
> > > is not a good container for storing
> > > 
> > > {virt addr, dma_addr, len}
> > > 
> > > no matter what interface you build arond it.
> > 
> > Why not? I mean at least for my use case we actually don't need the virtual
> > address.
> 
> If you don't need the virtual address you need scatterlist even list.
> 
> > What we need is {dma_addr+dma_len} in a consistent interface which can come
> > from both {page,offset,len} as well as {resource, len}.
> 
> Ok.
> 
> > What I actually don't need is separate handling for system memory and
> > resources, but that would we get exactly when we don't use sg_table.
> 
> At the very lowest level they will need to be handled differently for
> many architectures, the questions is at what point we'll do the
> branching out.

Having at least struct page also in that list with (dma_addr_t, lenght)
pairs has a bunch of benefits for drivers in unifying buffer handling
code. You just pass that one single list around, use the dma_addr_t side
for gpu access (generally bashing it into gpu ptes). And the struct page
(if present) for cpu access, using kmap or vm_insert_*. We generally
ignore virt, if we do need a full mapping then we construct a vmap for
that buffer of our own.

If (and that would be serious amounts of work all over the tree, with lots
of drivers) we come up with a new struct for gpu buffers, then I'd also
add "force page alignement for everything" to the requirements list.
That's another mismatch we have, since gpu buffer objects (and dma-buf)
are always full pages. That mismatch motived the addition of the
page-oriented sg iterators.

So maybe a list of (struct page *, dma_addr_t, num_pages) would suit best,
with struct page * being optional (if it's a resource, or something else
that the kernel core mm isn't aware of). But that only has benefits if we
really roll it out everywhere, in all the subsystems and drivers, since if
we don't we've made the struct pages ** <-> sgt conversion fun only worse
by adding a 3 representation of gpu buffer object backing storage.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
