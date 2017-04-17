Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34544 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbdDQKX6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Apr 2017 06:23:58 -0400
Date: Mon, 17 Apr 2017 11:22:53 +0100
From: Russell King - ARM Linux <linux@armlinux.org.uk>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        gregkh@linuxfoundation.org, pawel@osciak.com,
        kyungmin.park@samsung.com, mchehab@kernel.org, will.deacon@arm.com,
        Robin.Murphy@arm.com, jroedel@suse.de, bart.vanassche@sandisk.com,
        gregory.clement@free-electrons.com, acourbot@nvidia.com,
        festevam@gmail.com, krzk@kernel.org,
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
Message-ID: <20170417102253.GJ17774@n2100.armlinux.org.uk>
References: <CGME20170405160251epcas4p14cc5d5f6064c84b133b9e280ac987a93@epcas4p1.samsung.com>
 <20170405160242.14195-1-shuahkh@osg.samsung.com>
 <e49715a3-b925-79ad-7d1d-ce2cb5673a97@samsung.com>
 <3afd77e5-2a98-42fd-b5c9-cbf4c32baa4f@osg.samsung.com>
 <6d0c3e3c-8d1b-89bb-1392-6ffc7d8073c1@samsung.com>
 <20170414094643.GG17774@n2100.armlinux.org.uk>
 <4c51bf1a-00cb-84bb-f661-6bb6c83d8134@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4c51bf1a-00cb-84bb-f661-6bb6c83d8134@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Apr 16, 2017 at 07:10:21PM -0600, Shuah Khan wrote:
> On 04/14/2017 03:46 AM, Russell King - ARM Linux wrote:
> > On Fri, Apr 14, 2017 at 09:56:07AM +0200, Marek Szyprowski wrote:
> >>>> This would be however quite large task, especially taking into account
> >>>> all current users of DMA-buf framework...
> >>> Yeah it will be a large task.
> >>
> >> Maybe once scatterlist are switched to pfns, changing dmabuf internal
> >> memory representation to pfn array might be much easier.
> > 
> > Switching to a PFN array won't work either as we have no cross-arch
> > way to translate PFNs to a DMA address and vice versa.  Yes, we have
> > them in ARM, but they are an _implementation detail_ of ARM's
> > DMA API support, they are not for use by drivers.
> > 
> > So, the very first problem that needs solving is this:
> > 
> >   How do we go from a coherent DMA allocation for device X to a set
> >   of DMA addresses for device Y.
> > 
> > Essentially, we need a way of remapping the DMA buffer for use with
> > another device, and returning a DMA address suitable for that device.
> > This could well mean that we need to deal with setting up an IOMMU
> > mapping.  My guess is that this needs to happen at the DMA coherent
> > API level - the DMA coherent API needs to be augmented with support
> > for this.  I'll call this "DMA coherent remap".
> > 
> > We then need to think about how to pass this through the dma-buf API.
> > dma_map_sg() is done by the exporter, who should know what kind of
> > memory is being exported.  The exporter can avoid calling dma_map_sg()
> > if it knows in advance that it is exporting DMA coherent memory.
> > Instead, the exporter can simply create a scatterlist with the DMA
> > address and DMA length prepopulated with the results of the DMA
> > coherent remap operation above.
> 
> The only way to conclusively say that it is coming from coherent area
> is at the time it is getting allocated in dma_alloc_from_coherent().
> Since dma_alloc_attrs() will go on to find memory from other areas if
> dma_alloc_from_coherent() doesn't allocate memory.

Sorry, I disagree.

The only thing that matters is "did this memory come from
dma_alloc_coherent()".  It doesn't matter where dma_alloc_coherent()
ultimately got the memory from, it's memory from the coherent allocator
interface, and it should not be passed back into the streaming APIs.
It is, after all, DMA _coherent_ memory, passing it into the streaming
APIs which is for DMA _noncoherent_ memory is insane - the streaming APIs
can bring extra expensive cache flushes, which are not required for
DMA _coherent_ memory.

The exporter should know where it got the memory from.  It's really not
sane for anyone except the _original_ allocator to be exporting memory
through a DMA buffer - only the original allocator knows the properties
of that memory, and how to map it, whether that be for DMA, kmap or
mmap.

If a dmabuf is imported into a driver and then re-exported, the original
dmabuf should be what is re-exported, not some creation of the driver -
the re-exporting driver can't know what the properties of the memory
backing the dmabuf are, so anything else is just insane.

> How about adding get_sgtable, map_sg, unmap_sg to dma_buf_ops. The right
> ops need to be installed based on buffer type. As I mentioned before, we
> don't know which memory we got until dma_alloc_from_coherent() finds
> memory in dev->mem area. So how about using the dma_check_dev_coherent()
> to determine which ops we need. These could be set based on buffer type.
> vb2_dc_get_dmabuf() can do that.

Given my statement above, I don't believe any of that is necessary.  All
memory allocated from dma_alloc_coherent() is DMA coherent.  So, if
memory was obtained from dma_alloc_coherent() or similar, then it must
not be passed to the streaming DMA API.  It doesn't matter where it
ultimately came from.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
