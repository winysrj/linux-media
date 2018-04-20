Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50082 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754686AbeDTMq3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:46:29 -0400
Date: Fri, 20 Apr 2018 05:46:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
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
Message-ID: <20180420124625.GA31078@infradead.org>
References: <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com>
 <20180403180832.GZ3881@phenom.ffwll.local>
 <20180416123937.GA9073@infradead.org>
 <CAKMK7uEFVOh-R2_4vs1M22_wDau0oNTgmCcTWDE+ScxL=92+2g@mail.gmail.com>
 <20180419081657.GA16735@infradead.org>
 <20180420071312.GF31310@phenom.ffwll.local>
 <3e17afc5-7d6c-5795-07bd-f23e34cf8d4b@gmail.com>
 <20180420101755.GA11400@infradead.org>
 <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f1100bd6-dd98-55a9-a92f-1cad919f235f@amd.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 20, 2018 at 12:44:01PM +0200, Christian König wrote:
> > > What we need is an sg_alloc_table_from_resources(dev, resources,
> > > num_resources) which does the handling common to all drivers.
> > A structure that contains
> > 
> > {page,offset,len} + {dma_addr+dma_len}
> > 
> > is not a good container for storing
> > 
> > {virt addr, dma_addr, len}
> > 
> > no matter what interface you build arond it.
> 
> Why not? I mean at least for my use case we actually don't need the virtual
> address.

If you don't need the virtual address you need scatterlist even list.

> What we need is {dma_addr+dma_len} in a consistent interface which can come
> from both {page,offset,len} as well as {resource, len}.

Ok.

> What I actually don't need is separate handling for system memory and
> resources, but that would we get exactly when we don't use sg_table.

At the very lowest level they will need to be handled differently for
many architectures, the questions is at what point we'll do the
branching out.
