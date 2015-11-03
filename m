Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:57389 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbKCSko (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2015 13:40:44 -0500
Date: Tue, 3 Nov 2015 18:40:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Tomasz Figa <tfiga@chromium.org>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Lin PoChun <pochun.lin@mediatek.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	Will Deacon <will.deacon@arm.com>, linux-media@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>,
	"open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
	"Bobby Batacharia (via Google Docs)" <Bobby.Batacharia@arm.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Joerg Roedel <joro@8bytes.org>, thunder.leizhen@huawei.com,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
Message-ID: <20151103184019.GD8644@n2100.arm.linux.org.uk>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03>
 <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5638F1C4.3000900@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 03, 2015 at 05:41:24PM +0000, Robin Murphy wrote:
> Hi Tomasz,
> 
> On 02/11/15 13:43, Tomasz Figa wrote:
> >Agreed. The dma_map_*() API is not guaranteed to return a single
> >contiguous part of virtual address space for any given SG list.
> >However it was understood to be able to map buffers contiguously
> >mappable by the CPU into a single segment and users,
> >videobuf2-dma-contig in particular, relied on this.
> 
> I don't follow that - _any_ buffer made of page-sized chunks is going to be
> mappable contiguously by the CPU; it's clearly impossible for the streaming
> DMA API itself to offer such a guarantee, because it's entirely orthogonal
> to the presence or otherwise of an IOMMU.

Tomasz's use of "virtual address space" above in combination with the
DMA API is really confusing.

dma_map_sg() does *not* construct a CPU view of the passed scatterlist.
The only thing dma_map_sg() might do with virtual addresses is to use
them as a way to achieve cache coherence for one particular view of
that memory, that being the kernel's own lowmem mapping and any kmaps.
It doesn't extend to vmalloc() or userspace mappings of the memory.

If the scatterlist is converted to an array of struct page pointers,
it's possible to map it with vmap(), but it's implementation defined
whether such a mapping will receive cache maintanence as part of the
DMA API or not.  (If you have PIPT caches, it will, if they're VIPT
caches, maybe not.)

There is a separate set of calls to deal with the flushing issues for
vmap()'d memory in this case - see flush_kernel_vmap_range() and
invalidate_kernel_vmap_range().

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
