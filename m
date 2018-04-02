Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753013AbeDBRUc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 13:20:32 -0400
Date: Mon, 2 Apr 2018 13:20:27 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180402172027.GA18231@redhat.com>
References: <73578b4e-664b-141c-3e1f-e1fae1e4db07@amd.com>
 <1b08c13e-b4a2-08f2-6194-93e6c21b7965@deltatee.com>
 <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
 <20180330194519.GC3198@redhat.com>
 <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 02, 2018 at 11:02:10AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 30/03/18 01:45 PM, Jerome Glisse wrote:
> > Looking at upstream code it seems that the x86 bits never made it upstream
> > and thus what is now upstream is only for ARM. See [1] for x86 code. Dunno
> > what happen, i was convince it got merge. So yes current code is broken on
> > x86. ccing Joerg maybe he remembers what happened there.
> > 
> > [1] https://lwn.net/Articles/646605/
> 
> That looks like a significant improvement over what's upstream. But it's
> three years old and looks to have been abandoned. I think I agree with
> Bjorn's comments in that if it's going to be a general P2P API it will
> need the device the resource belongs to in addition to the device that's
> initiating the DMA request.

The point i have been trying to get accross is that you do have this
information with dma_map_resource() you know the device to which you
are trying to map (dev argument to dma_map_resource()) and you can
easily get the device to which the memory belongs because you have the
CPU physical address of the memory hence you can lookup the resource
and get the device from that.


> > Given it is currently only used by ARM folks it appear to at least work
> > for them (tm) :) Note that Christian is doing this in PCIE only context
> > and again dma_map_resource can easily figure that out if the address is
> > a PCIE or something else. Note that the exporter export the CPU bus
> > address. So again dma_map_resource has all the informations it will ever
> > need, if the peer to peer is fundamentaly un-doable it can return dma
> > error and it is up to the caller to handle this, just like GPU code do.
> > 
> > Do you claim that dma_map_resource is missing any information ?
> 
> Yes, that's what I said. All the existing ARM code appears to use it for
> platform devices only. I suspect platform P2P is relatively trivial to
> support on ARM. I think it's a big difference from using it for PCI P2P
> or general P2P on any bus.
> 

It does have all we need for PCIE when using dma_api and not the SG one.
SG issue IIRC is that it assume struct page ... See above for device
lookup.

> > I agree and understand that but for platform where such feature make sense
> > this will work. For me it is PowerPC and x86 and given PowerPC has CAPI
> > which has far more advance feature when it comes to peer to peer, i don't
> > see something more basic not working. On x86, Intel is a bit of lone wolf,
> > dunno if they gonna support this usecase pro-actively. AMD definitly will.
> 
> Well PowerPC doesn't even support P2P between root ports. And I fail to
> see how CAPI applies unless/until we get this memory mapped into
> userspace and the mappings need to be dynamically managed. Seems like
> that's a long way away.

IIRC CAPI make P2P mandatory but maybe this is with NVLink. We can ask
the PowerPC folks to confirm. Note CAPI is Power8 and newer AFAICT.

Mapping to userspace have nothing to do here. I am talking at hardware
level. How thing are expose to userspace is a completely different
problems that do not have one solution fit all. For GPU you want this
to be under total control of GPU drivers. For storage like persistent
memory, you might want to expose it userspace more directly ...

Cheers,
Jérôme
