Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:50341 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbeDYHan (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 03:30:43 -0400
Received: by mail-wm0-f45.google.com with SMTP id t67so5370304wmt.0
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 00:30:42 -0700 (PDT)
Date: Wed, 25 Apr 2018 09:30:39 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
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
        <linux-media@vger.kernel.org>, Thierry Reding <treding@nvidia.com>
Subject: Re: [Linaro-mm-sig] [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180425073039.GO25142@phenom.ffwll.local>
References: <20180420124625.GA31078@infradead.org>
 <20180420152111.GR31310@phenom.ffwll.local>
 <20180424184847.GA3247@infradead.org>
 <CAKMK7uFL68pu+-9LODTgz+GQYvxpnXOGhxfz9zorJ_JKsPVw2g@mail.gmail.com>
 <20180425054855.GA17038@infradead.org>
 <CAKMK7uEFitkNQrD6cLX5Txe11XhVO=LC4YKJXH=VNdq+CY=DjQ@mail.gmail.com>
 <CAKMK7uFx=KB1vup=WhPCyfUFairKQcRR4BEd7aXaX1Pj-vj3Cw@mail.gmail.com>
 <20180425064335.GB28100@infradead.org>
 <CAKMK7uGF7p5ko=i6zL4dn0qR-5TVRKMi6xaCGSao_vyfJU+dWQ@mail.gmail.com>
 <20180425070905.GA24827@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180425070905.GA24827@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 25, 2018 at 12:09:05AM -0700, Christoph Hellwig wrote:
> On Wed, Apr 25, 2018 at 09:02:17AM +0200, Daniel Vetter wrote:
> > Can we please not nack everything right away? Doesn't really motivate
> > me to show you all the various things we're doing in gpu to make the
> > dma layer work for us. That kind of noodling around in lower levels to
> > get them to do what we want is absolutely par-for-course for gpu
> > drivers. If you just nack everything I point you at for illustrative
> > purposes, then I can't show you stuff anymore.
> 
> No, it's not.  No driver (and that includes the magic GPUs) has
> any business messing with dma ops directly.
> 
> A GPU driver imght have a very valid reason to disable the IOMMU,
> but the code to do so needs to be at least in the arch code, maybe
> in the dma-mapping/iommu code, not in the driver.
> 
> As a first step to get the discussion started we'll simply need
> to move the code Thierry wrote into a helper in arch/arm and that
> alone would be a massive improvement.  I'm not even talking about
> minor details like actually using arm_get_dma_map_ops instead
> of duplicating it.
> 
> And doing this basic trivial work really helps to get this whole
> mess under control.

Ah ok. It did sound a bit like a much more cathegorical NAK than an "ack
in principle, but we need to shuffle the implementation into the right
place first". In the past we generally got a principled NAK on anything
funny we've been doing with the dma api, and the dma api maintainer
steaming off telling us we're incompetent idiots. I guess I've been
branded a bit on this topic :-/

Really great that this is changing now.

On the patch itself: It might not be the right thing in all cases, since
for certain compression formats the nv gpu wants larger pages (easy to
allocate from vram, not so easy from main memory), so might need the iommu
still. But currently that's not implemented:

https://www.spinics.net/lists/dri-devel/msg173932.html

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
