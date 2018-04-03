Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36334 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752397AbeDCRGs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Apr 2018 13:06:48 -0400
Date: Tue, 3 Apr 2018 13:06:45 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: christian.koenig@amd.com, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] dma-buf: add peer2peer flag
Message-ID: <20180403170645.GB5935@redhat.com>
References: <20180325110000.2238-1-christian.koenig@amd.com>
 <20180325110000.2238-4-christian.koenig@amd.com>
 <20180329065753.GD3881@phenom.ffwll.local>
 <8b823458-8bdc-3217-572b-509a28aae742@gmail.com>
 <20180403090909.GN3881@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180403090909.GN3881@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 03, 2018 at 11:09:09AM +0200, Daniel Vetter wrote:
> On Thu, Mar 29, 2018 at 01:34:24PM +0200, Christian König wrote:
> > Am 29.03.2018 um 08:57 schrieb Daniel Vetter:
> > > On Sun, Mar 25, 2018 at 12:59:56PM +0200, Christian König wrote:
> > > > Add a peer2peer flag noting that the importer can deal with device
> > > > resources which are not backed by pages.
> > > > 
> > > > Signed-off-by: Christian König <christian.koenig@amd.com>
> > > Um strictly speaking they all should, but ttm never bothered to use the
> > > real interfaces but just hacked around the provided sg list, grabbing the
> > > underlying struct pages, then rebuilding&remapping the sg list again.
> > 
> > Actually that isn't correct. TTM converts them to a dma address array
> > because drivers need it like this (at least nouveau, radeon and amdgpu).
> > 
> > I've fixed radeon and amdgpu to be able to deal without it and mailed with
> > Ben about nouveau, but the outcome is they don't really know.
> > 
> > TTM itself doesn't have any need for the pages on imported BOs (you can't
> > mmap them anyway), the real underlying problem is that sg tables doesn't
> > provide what drivers need.
> > 
> > I think we could rather easily fix sg tables, but that is a totally separate
> > task.
> 
> Looking at patch 8, the sg table seems perfectly sufficient to convey the
> right dma addresses to the importer. Ofcourse the exporter has to set up
> the right kind of iommu mappings to make this work.
> 
> > > The entire point of using sg lists was exactly to allow this use case of
> > > peer2peer dma (or well in general have special exporters which managed
> > > memory/IO ranges not backed by struct page). So essentially you're having
> > > a "I'm totally not broken flag" here.
> > 
> > No, independent of needed struct page pointers we need to note if the
> > exporter can handle peer2peer stuff from the hardware side in general.
> > 
> > So what I've did is just to set peer2peer allowed on the importer because of
> > the driver needs and clear it in the exporter if the hardware can't handle
> > that.
> 
> The only thing the importer seems to do is call the
> pci_peer_traffic_supported, which the exporter could call too. What am I
> missing (since the sturct_page stuff sounds like it's fixed already by
> you)?
> -Daniel

AFAIK Logan patchset require to register and initialize struct page
for the device memory you want to map (export from exporter point of
view).

With GPU this isn't something we want, struct page is >~= 2^6 so for
4GB GPU = 2^6*2^32/2^12 = 2^26 = 64MB of RAM
8GB GPU = 2^6*2^33/2^12 = 2^27 = 128MB of RAM
16GB GPU = 2^6*2^34/2^12 = 2^28 = 256MB of RAM
32GB GPU = 2^6*2^34/2^12 = 2^29 = 512MB of RAM

All this is mostly wasted as only a small sub-set (that can not be
constraint to specific range) will ever be exported at any point in
time. For GPU work load this is hardly justifiable, even for HMM i
do not plan to register all those pages.

Hence why i argue that dma_map_resource() like use by Christian is
good enough for us. People that care about SG can fix that but i
rather not have to depend on that and waste system memory.

Cheers,
Jérôme
