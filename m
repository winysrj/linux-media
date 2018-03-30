Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752259AbeC3TpY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Mar 2018 15:45:24 -0400
Date: Fri, 30 Mar 2018 15:45:19 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180330194519.GC3198@redhat.com>
References: <6a5c9a10-50fe-b03d-dfc1-791d62d79f8e@amd.com>
 <e751cd28-f115-569f-5248-d24f30dee3cb@deltatee.com>
 <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 30, 2018 at 12:46:42PM -0600, Logan Gunthorpe wrote:
> 
> 
> On 29/03/18 07:58 PM, Jerome Glisse wrote:
> > On Thu, Mar 29, 2018 at 10:25:52AM -0600, Logan Gunthorpe wrote:
> >>
> >>
> >> On 29/03/18 10:10 AM, Christian König wrote:
> >>> Why not? I mean the dma_map_resource() function is for P2P while other 
> >>> dma_map_* functions are only for system memory.
> >>
> >> Oh, hmm, I wasn't aware dma_map_resource was exclusively for mapping
> >> P2P. Though it's a bit odd seeing we've been working under the
> >> assumption that PCI P2P is different as it has to translate the PCI bus
> >> address. Where as P2P for devices on other buses is a big unknown.
> > 
> > dma_map_resource() is the right API (thought its current implementation
> > is fill with x86 assumptions). So i would argue that arch can decide to
> > implement it or simply return dma error address which trigger fallback
> > path into the caller (at least for GPU drivers). SG variant can be added
> > on top.
> > 
> > dma_map_resource() is the right API because it has all the necessary
> > informations. It use the CPU physical address as the common address
> > "language" with CPU physical address of PCIE bar to map to another
> > device you can find the corresponding bus address from the IOMMU code
> > (NOP on x86). So dma_map_resource() knows both the source device which
> > export its PCIE bar and the destination devices.
> 
> Well, as it is today, it doesn't look very sane to me. The default is to
> just return the physical address if the architecture doesn't support it.
> So if someone tries this on an arch that hasn't added itself to return
> an error they're very likely going to just end up DMAing to an invalid
> address and loosing the data or causing a machine check.

Looking at upstream code it seems that the x86 bits never made it upstream
and thus what is now upstream is only for ARM. See [1] for x86 code. Dunno
what happen, i was convince it got merge. So yes current code is broken on
x86. ccing Joerg maybe he remembers what happened there.

[1] https://lwn.net/Articles/646605/

> 
> Furthermore, the API does not have all the information it needs to do
> sane things. A phys_addr_t doesn't really tell you anything about the
> memory behind it or what needs to be done with it. For example, on some
> arm64 implementations if the physical address points to a PCI BAR and
> that BAR is behind a switch with the DMA device then the address must be
> converted to the PCI BUS address. On the other hand, if it's a physical
> address of a device in an SOC it might need to  be handled in a
> completely different way. And right now all the implementations I can
> find seem to just assume that phys_addr_t points to regular memory and
> can be treated as such.

Given it is currently only used by ARM folks it appear to at least work
for them (tm) :) Note that Christian is doing this in PCIE only context
and again dma_map_resource can easily figure that out if the address is
a PCIE or something else. Note that the exporter export the CPU bus
address. So again dma_map_resource has all the informations it will ever
need, if the peer to peer is fundamentaly un-doable it can return dma
error and it is up to the caller to handle this, just like GPU code do.

Do you claim that dma_map_resource is missing any information ?


> 
> This is one of the reasons that, based on feedback, our work went from
> being general P2P with any device to being restricted to only P2P with
> PCI devices. The dream that we can just grab the physical address of any
> device and use it in a DMA request is simply not realistic.

I agree and understand that but for platform where such feature make sense
this will work. For me it is PowerPC and x86 and given PowerPC has CAPI
which has far more advance feature when it comes to peer to peer, i don't
see something more basic not working. On x86, Intel is a bit of lone wolf,
dunno if they gonna support this usecase pro-actively. AMD definitly will.

If you feel like dma_map_resource() can be interpreted too broadly, more
strict phrasing/wording can be added to it so people better understand its
limitation and gotcha.

Cheers,
Jérôme
