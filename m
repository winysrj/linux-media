Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55838 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754469AbeDTKR6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 06:17:58 -0400
Date: Fri, 20 Apr 2018 03:17:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: christian.koenig@amd.com
Cc: Christoph Hellwig <hch@infradead.org>,
        Jerome Glisse <jglisse@redhat.com>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180420101755.GA11400@infradead.org>
References: <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org>
 <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 10:58:50AM +0200, Christian K�nig wrote:
> > Yes there's a bit a layering violation insofar that drivers really
> > shouldn't each have their own copy of "how do I convert a piece of dma
> > memory into  dma-buf", but that doesn't render the interface a bad idea.
> 
> Completely agree on that.
> 
> What we need is an sg_alloc_table_from_resources(dev, resources,
> num_resources) which does the handling common to all drivers.

A structure that contains

{page,offset,len} + {dma_addr+dma_len}

is not a good container for storing

{virt addr, dma_addr, len}

no matter what interface you build arond it.  And that is discounting
all the problems around mapping coherent allocations for other devices,
or the iommu merging problem we are having another thread on.

So let's come up with a better high level interface first, and then
worrty about how to implement it in the low-level dma-mapping interface
second.  Especially given that my consolidation of the dma_map_ops
implementation is in full stream and there shoudn't be all that many
to bother with.

So first question:  Do you actually care about having multiple
pairs of the above, or instead of all chunks just deal with a single
of the above?  In that case we really should not need that many
new interfaces as dma_map_resource will be all you need anyway.

> 
> Christian.
> 
> > -Daniel
> 
---end quoted text---
