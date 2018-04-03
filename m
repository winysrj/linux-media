Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38082 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752171AbeDCSIg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Apr 2018 14:08:36 -0400
Received: by mail-wm0-f50.google.com with SMTP id i3so13134504wmf.3
        for <linux-media@vger.kernel.org>; Tue, 03 Apr 2018 11:08:35 -0700 (PDT)
Date: Tue, 3 Apr 2018 20:08:32 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jerome Glisse <jglisse@redhat.com>
Cc: christian.koenig@amd.com, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180403180832.GZ3881@phenom.ffwll.local>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local>
 <20180403170645.GB5935@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180403170645.GB5935@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 03, 2018 at 01:06:45PM -0400, Jerome Glisse wrote:
> On Tue, Apr 03, 2018 at 11:09:09AM +0200, Daniel Vetter wrote:
> > On Thu, Mar 29, 2018 at 01:34:24PM +0200, Christian König wrote:
> > > Am 29.03.2018 um 08:57 schrieb Daniel Vetter:
> > > > On Sun, Mar 25, 2018 at 12:59:56PM +0200, Christian König wrote:
> > > > > Add a peer2peer flag noting that the importer can deal with device
> > > > > resources which are not backed by pages.
> > > > > 
> > > > > Signed-off-by: Christian König <christian.koenig@amd.com>
> > > > Um strictly speaking they all should, but ttm never bothered to use the
> > > > real interfaces but just hacked around the provided sg list, grabbing the
> > > > underlying struct pages, then rebuilding&remapping the sg list again.
> > > 
> > > Actually that isn't correct. TTM converts them to a dma address array
> > > because drivers need it like this (at least nouveau, radeon and amdgpu).
> > > 
> > > I've fixed radeon and amdgpu to be able to deal without it and mailed with
> > > Ben about nouveau, but the outcome is they don't really know.
> > > 
> > > TTM itself doesn't have any need for the pages on imported BOs (you can't
> > > mmap them anyway), the real underlying problem is that sg tables doesn't
> > > provide what drivers need.
> > > 
> > > I think we could rather easily fix sg tables, but that is a totally separate
> > > task.
> > 
> > Looking at patch 8, the sg table seems perfectly sufficient to convey the
> > right dma addresses to the importer. Ofcourse the exporter has to set up
> > the right kind of iommu mappings to make this work.
> > 
> > > > The entire point of using sg lists was exactly to allow this use case of
> > > > peer2peer dma (or well in general have special exporters which managed
> > > > memory/IO ranges not backed by struct page). So essentially you're having
> > > > a "I'm totally not broken flag" here.
> > > 
> > > No, independent of needed struct page pointers we need to note if the
> > > exporter can handle peer2peer stuff from the hardware side in general.
> > > 
> > > So what I've did is just to set peer2peer allowed on the importer because of
> > > the driver needs and clear it in the exporter if the hardware can't handle
> > > that.
> > 
> > The only thing the importer seems to do is call the
> > pci_peer_traffic_supported, which the exporter could call too. What am I
> > missing (since the sturct_page stuff sounds like it's fixed already by
> > you)?
> > -Daniel
> 
> AFAIK Logan patchset require to register and initialize struct page
> for the device memory you want to map (export from exporter point of
> view).
> 
> With GPU this isn't something we want, struct page is >~= 2^6 so for
> 4GB GPU = 2^6*2^32/2^12 = 2^26 = 64MB of RAM
> 8GB GPU = 2^6*2^33/2^12 = 2^27 = 128MB of RAM
> 16GB GPU = 2^6*2^34/2^12 = 2^28 = 256MB of RAM
> 32GB GPU = 2^6*2^34/2^12 = 2^29 = 512MB of RAM
> 
> All this is mostly wasted as only a small sub-set (that can not be
> constraint to specific range) will ever be exported at any point in
> time. For GPU work load this is hardly justifiable, even for HMM i
> do not plan to register all those pages.
> 
> Hence why i argue that dma_map_resource() like use by Christian is
> good enough for us. People that care about SG can fix that but i
> rather not have to depend on that and waste system memory.

I did not mean you should dma_map_sg/page. I just meant that using
dma_map_resource to fill only the dma address part of the sg table seems
perfectly sufficient. And that's exactly why the importer gets an already
mapped sg table, so that it doesn't have to call dma_map_sg on something
that dma_map_sg can't handle.

Assuming you get an sg table that's been mapping by calling dma_map_sg was
always a bit a case of bending the abstraction to avoid typing code. The
only thing an importer ever should have done is look at the dma addresses
in that sg table, nothing else.

And p2p seems to perfectly fit into this (surprise, it was meant to).
That's why I suggested we annotate the broken importers who assume the sg
table is mapped using dma_map_sg or has a struct_page backing the memory
(but there doesn't seem to be any left it seems) instead of annotating the
ones that aren't broken with a flag that's confusing - you could also have
a dma-buf sgt that points at some other memory that doesn't have struct
pages backing it.

Aside: At least internally in i915 we've been using this forever for our
own private/stolen memory. Unfortunately no other device can access that
range of memory, which is why we don't allow it to be imported to anything
but i915 itself. But if that hw restriction doesn't exist, it'd would
work.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
