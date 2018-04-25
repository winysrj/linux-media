Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38765 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbeDYKEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 06:04:34 -0400
Received: by mail-wm0-f50.google.com with SMTP id i3so5743297wmf.3
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 03:04:33 -0700 (PDT)
Date: Wed, 25 Apr 2018 12:04:29 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christoph Hellwig <hch@infradead.org>
Cc: Thierry Reding <treding@nvidia.com>,
        Daniel Vetter <daniel@ffwll.ch>,
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
Message-ID: <20180425100429.GR25142@phenom.ffwll.local>
References: <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <20180425074151.GA2271@ulmo>
 <20180425085439.GA29996@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425085439.GA29996@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 01:54:39AM -0700, Christoph Hellwig wrote:
> [discussion about this patch, which should have been cced to the iommu
>  and linux-arm-kernel lists, but wasn't:
>  https://www.spinics.net/lists/dri-devel/msg173630.html]
> 
> On Wed, Apr 25, 2018 at 09:41:51AM +0200, Thierry Reding wrote:
> > > API from the iommu/dma-mapping code.  Drivers have no business poking
> > > into these details.
> > 
> > The interfaces that the above patch uses are all EXPORT_SYMBOL_GPL,
> > which is rather misleading if they are not meant to be used by drivers
> > directly.
> 
> The only reason the DMA ops are exported is because get_arch_dma_ops
> references (or in case of the coherent ones used to reference).  We
> don't let drivers assign random dma ops.
> 
> > 
> > > Thierry, please resend this with at least the iommu list and
> > > linux-arm-kernel in Cc to have a proper discussion on the right API.
> > 
> > I'm certainly open to help with finding a correct solution, but the
> > patch above was purposefully terse because this is something that I
> > hope we can get backported to v4.16 to unbreak Nouveau. Coordinating
> > such a backport between ARM and DRM trees does not sound like something
> > that would help getting this fixed in v4.16.
> 
> Coordinating the backport of a trivial helper in the arm tree is not
> the end of the world.  Really, this cowboy attitude is a good reason
> why graphics folks have such a bad rep.  You keep poking into random
> kernel internals, don't talk to anoyone and then complain if people
> are upset.  This shouldn't be surprising.

Not really agreeing on the cowboy thing. The fundamental problem is that
the dma api provides abstraction that seriously gets in the way of writing
a gpu driver. Some examples:

- We never want bounce buffers, ever. dma_map_sg gives us that, so there's
  hacks to fall back to a cache of pages allocated using
  dma_alloc_coherent if you build a kernel with bounce buffers.

- dma api hides the cache flushing requirements from us. GPUs love
  non-snooped access, and worse give userspace control over that. We want
  a strict separation between mapping stuff and flushing stuff. With the
  IOMMU api we mostly have the former, but for the later arch maintainers
  regularly tells they won't allow that. So we have drm_clflush.c.

- dma api hides how/where memory is allocated. Kinda similar problem,
  except now for CMA or address limits. So either we roll our own
  allocators and then dma_map_sg (and pray it doesn't bounce buffer), or
  we use dma_alloc_coherent and then grab the sgt to get at the CMA
  allocations because that's the only way. Which sucks, because we can't
  directly tell CMA how to back off if there's some way to make CMA memory
  available through other means (gpus love to hog all of memory, so we
  have shrinkers and everything).

For display drivers the dma api mostly works, until you start sharing
buffers with other devices.

So from our perspective it looks fairly often that core folks just don't
want to support gpu use-cases, so we play a bit more cowboy and get things
done some other way. Since this has been going on for years now we often
don't even bother to start a discussion first, since it tended to go
nowhere useful.
-Daniel

> > Granted, this issue could've been caught with a little more testing, but
> > in retrospect I think it would've been a lot better if ARM_DMA_USE_IOMMU
> > was just enabled unconditionally if it has side-effects that platforms
> > don't opt in to but have to explicitly opt out of.
> 
> Agreed on that count.  Please send a patch.

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
