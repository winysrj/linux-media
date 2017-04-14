Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44688 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751528AbdDNJrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Apr 2017 05:47:45 -0400
Date: Fri, 14 Apr 2017 10:46:44 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Shuah Khan <shuahkh@osg.samsung.com>, gregkh@linuxfoundation.org,
        pawel@osciak.com, kyungmin.park@samsung.com, mchehab@kernel.org,
        will.deacon@arm.com, Robin.Murphy@arm.com, jroedel@suse.de,
        bart.vanassche@sandisk.com, gregory.clement@free-electrons.com,
        acourbot@nvidia.com, festevam@gmail.com, krzk@kernel.org,
        niklas.soderlund+renesas@ragnatech.se, sricharan@codeaurora.org,
        dledford@redhat.com, vinod.koul@intel.com,
        andrew.smirnov@gmail.com, mauricfo@linux.vnet.ibm.com,
        alexander.h.duyck@intel.com, sagi@grimberg.me,
        ming.l@ssi.samsung.com, martin.petersen@oracle.com,
        javier@dowhile0.org, javier@osg.samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] arm: dma: fix sharing of coherent DMA memory without
 struct page
Message-ID: <20170414094643.GG17774@n2100.armlinux.org.uk>
References: <CGME20170405160251epcas4p14cc5d5f6064c84b133b9e280ac987a93@epcas4p1.samsung.com>
 <20170405160242.14195-1-shuahkh@osg.samsung.com>
 <e49715a3-b925-79ad-7d1d-ce2cb5673a97@samsung.com>
 <3afd77e5-2a98-42fd-b5c9-cbf4c32baa4f@osg.samsung.com>
 <6d0c3e3c-8d1b-89bb-1392-6ffc7d8073c1@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d0c3e3c-8d1b-89bb-1392-6ffc7d8073c1@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 14, 2017 at 09:56:07AM +0200, Marek Szyprowski wrote:
> >>This would be however quite large task, especially taking into account
> >>all current users of DMA-buf framework...
> >Yeah it will be a large task.
> 
> Maybe once scatterlist are switched to pfns, changing dmabuf internal
> memory representation to pfn array might be much easier.

Switching to a PFN array won't work either as we have no cross-arch
way to translate PFNs to a DMA address and vice versa.  Yes, we have
them in ARM, but they are an _implementation detail_ of ARM's
DMA API support, they are not for use by drivers.

So, the very first problem that needs solving is this:

  How do we go from a coherent DMA allocation for device X to a set
  of DMA addresses for device Y.

Essentially, we need a way of remapping the DMA buffer for use with
another device, and returning a DMA address suitable for that device.
This could well mean that we need to deal with setting up an IOMMU
mapping.  My guess is that this needs to happen at the DMA coherent
API level - the DMA coherent API needs to be augmented with support
for this.  I'll call this "DMA coherent remap".

We then need to think about how to pass this through the dma-buf API.
dma_map_sg() is done by the exporter, who should know what kind of
memory is being exported.  The exporter can avoid calling dma_map_sg()
if it knows in advance that it is exporting DMA coherent memory.
Instead, the exporter can simply create a scatterlist with the DMA
address and DMA length prepopulated with the results of the DMA
coherent remap operation above.

What the scatterlist can't carry in this case is a set of valid
struct page pointers, and an importer must not walk the scatterlist
expecting to get at the virtual address parameters or struct page
pointers.

On the mmap() side of things, remember that DMA coherent allocations
may require special mapping into userspace, and which can only be
mapped by the DMA coherent mmap support.  kmap etc will also need to
be different.  So it probably makes sense for DMA coherent dma-buf
exports to use a completely separate set of dma_buf_ops from the
streaming version.

I think this is the easiest approach to solving the problem without
needing massive driver changes all over the kernel.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
