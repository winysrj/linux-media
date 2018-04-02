Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47708 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752321AbeDBTQx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Apr 2018 15:16:53 -0400
Date: Mon, 2 Apr 2018 15:16:50 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Christoph Hellwig <hch@infradead.org>,
        Will Davis <wdavis@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 2/8] PCI: Add pci_find_common_upstream_dev()
Message-ID: <20180402191649.GB18231@redhat.com>
References: <70adc2cc-f7aa-d4b9-7d7a-71f3ae99f16c@gmail.com>
 <98ce6cfd-bcf3-811e-a0f1-757b60da467a@deltatee.com>
 <8d050848-8970-b8c4-a657-429fefd31769@amd.com>
 <d2de0c2e-4c2d-9e46-1c26-bfa40ca662ff@deltatee.com>
 <20180330015854.GA3572@redhat.com>
 <0234bc5e-495e-0f68-fb0a-debb17a35761@deltatee.com>
 <20180330194519.GC3198@redhat.com>
 <31266710-f6bb-99ee-c73d-6e58afe5c38c@deltatee.com>
 <20180402172027.GA18231@redhat.com>
 <6f796779-0ba3-d056-de33-341ee55d6b38@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6f796779-0ba3-d056-de33-341ee55d6b38@deltatee.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 02, 2018 at 11:37:07AM -0600, Logan Gunthorpe wrote:
> 
> 
> On 02/04/18 11:20 AM, Jerome Glisse wrote:
> > The point i have been trying to get accross is that you do have this
> > information with dma_map_resource() you know the device to which you
> > are trying to map (dev argument to dma_map_resource()) and you can
> > easily get the device to which the memory belongs because you have the
> > CPU physical address of the memory hence you can lookup the resource
> > and get the device from that.
> 
> How do you go from a physical address to a struct device generally and
> in a performant manner?

There isn't good API at the moment AFAIK, closest thing would either be
lookup_resource() or region_intersects(), but a more appropriate one can
easily be added, code to walk down the tree is readily available. More-
over this can be optimize like vma lookup are, even more as resource are
seldomly added so read side (finding a resource) can be heavily favor
over write side (adding|registering a new resource).

> 
> > IIRC CAPI make P2P mandatory but maybe this is with NVLink. We can ask
> > the PowerPC folks to confirm. Note CAPI is Power8 and newer AFAICT.
> 
> PowerPC folks recently told us specifically that Power9 does not support
> P2P between PCI root ports. I've said this many times. CAPI has nothing
> to do with it.

I need to check CAPI, i must have confuse that with NVLink which is also
on some powerpc arch.

> 
> > Mapping to userspace have nothing to do here. I am talking at hardware
> > level. How thing are expose to userspace is a completely different
> > problems that do not have one solution fit all. For GPU you want this
> > to be under total control of GPU drivers. For storage like persistent
> > memory, you might want to expose it userspace more directly ...
> 
> My understanding (and I worked on this a while ago) is that CAPI
> hardware manages memory maps typically for userspace memory. When a
> userspace program changes it's mapping, the CAPI hardware is updated so
> that hardware is coherent with the user address space and it is safe to
> DMA to any address without having to pin memory. (This is very similar
> to ODP in RNICs.) This is *really* nice but doesn't solve *any* of the
> problems we've been discussing. Moreover, many developers want to keep
> P2P in-kernel, for the time being, where the problem of pinning memory
> does not exist.

What you describe is the ATS(Address Translation Service)/PASID(Process
Address Space IDentifier) part of CAPI. Which have also been available
for years on AMD x86 platform (AMD IOMMU-v2), thought it is barely ever
use. Interesting aspect of CAPI is its cache coherency protocol between
devices and CPUs. This in both direction, the usual device access to
system memory can be cache coherent with CPU access and participate in
cache coherency protocol (bit further than PCIE snoop). But also the
other direction the CPU access to device memory can also be cache coherent,
which is not the case in PCIE.

This cache coherency between CPU and device is what made me assume that
CAPI must have Peer To Peer support as peer must be able to talk to each
other for cache coherency purpose. But maybe all cache coherency
arbritration goes through central directory allievating Peer to Peer
requirement.

Anyway, like you said, this does not matter for the discussion. The
dma_map_resource() can be just stub out on platform that do not support
this and they would not allow it. If it get use on other platform and
shows enough advantages that users start asking for it then maybe those
platform will attention to the hardware requirement.

Note that with mmu_notifier there isn't any need to pin stuff (even
without any special hardware capabilities), as long as you can preempt
what is happening on your hardware to update its page table.

Cheers,
Jérôme
