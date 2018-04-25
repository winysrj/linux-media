Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:60696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755071AbeDYPdP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 11:33:15 -0400
Date: Wed, 25 Apr 2018 08:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
        Thierry Reding <treding@nvidia.com>,
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
        <linux-media@vger.kernel.org>, iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: noveau vs arm dma ops
Message-ID: <20180425153312.GD27076@infradead.org>
References: <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org>
 <20180425100429.GR25142@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425100429.GR25142@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 12:04:29PM +0200, Daniel Vetter wrote:
> > Coordinating the backport of a trivial helper in the arm tree is not
> > the end of the world.  Really, this cowboy attitude is a good reason
> > why graphics folks have such a bad rep.  You keep poking into random
> > kernel internals, don't talk to anoyone and then complain if people
> > are upset.  This shouldn't be surprising.
> 
> Not really agreeing on the cowboy thing. The fundamental problem is that
> the dma api provides abstraction that seriously gets in the way of writing
> a gpu driver. Some examples:

So talk to other people.  Maybe people share your frustation.  Or maybe
other people have a way to help.

> - We never want bounce buffers, ever. dma_map_sg gives us that, so there's
>   hacks to fall back to a cache of pages allocated using
>   dma_alloc_coherent if you build a kernel with bounce buffers.

get_required_mask() is supposed to tell you if you are safe.  However
we are missing lots of implementations of it for iommus so you might get
some false negatives, improvements welcome.  It's been on my list of
things to fix in the DMA API, but it is nowhere near the top.

> - dma api hides the cache flushing requirements from us. GPUs love
>   non-snooped access, and worse give userspace control over that. We want
>   a strict separation between mapping stuff and flushing stuff. With the
>   IOMMU api we mostly have the former, but for the later arch maintainers
>   regularly tells they won't allow that. So we have drm_clflush.c.

The problem is that a cache flushing API entirely separate is hard. That
being said if you look at my generic dma-noncoherent API series it tries
to move that way.  So far it is in early stages and apparently rather
buggy unfortunately.

> - dma api hides how/where memory is allocated. Kinda similar problem,
>   except now for CMA or address limits. So either we roll our own
>   allocators and then dma_map_sg (and pray it doesn't bounce buffer), or
>   we use dma_alloc_coherent and then grab the sgt to get at the CMA
>   allocations because that's the only way. Which sucks, because we can't
>   directly tell CMA how to back off if there's some way to make CMA memory
>   available through other means (gpus love to hog all of memory, so we
>   have shrinkers and everything).

If you really care about doing explicitly cache flushing anyway (see
above) allocating your own memory and mapping it where needed is by
far the superior solution.  On cache coherent architectures
dma_alloc_coherent is nothing but allocate memory + dma_map_single.
On non coherent allocations the memory might come through a special
pool or must be used through a special virtual address mapping that
is set up either statically or dynamically.  For that case splitting
allocation and mapping is a good idea in many ways, and I plan to move
towards that once the number of dma mapping implementations is down
to a reasonable number so that it can actually be done.
