Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58935 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964774AbbKDKvf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 05:51:35 -0500
Date: Wed, 4 Nov 2015 10:50:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will.deacon@arm.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Yong Wu <yong.wu@mediatek.com>,
	"open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
	"Bobby Batacharia (via Google Docs)" <Bobby.Batacharia@arm.com>,
	linux-mediatek@lists.infradead.org,
	Lin PoChun <pochun.lin@mediatek.com>,
	thunder.leizhen@huawei.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	Thierry Reding <treding@nvidia.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
Message-ID: <20151104105057.GK8644@n2100.arm.linux.org.uk>
References: <1445867094.30736.14.camel@mhfsdcap03>
 <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com>
 <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
 <20151104092748.GI8644@n2100.arm.linux.org.uk>
 <CAAFQd5ApSFC6Pm4tDhZbJOVZ7szCx=diKUtGXq=M9a5Y_4qzOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5ApSFC6Pm4tDhZbJOVZ7szCx=diKUtGXq=M9a5Y_4qzOQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 04, 2015 at 06:48:50PM +0900, Tomasz Figa wrote:
> There is no requirement, but shouldn't it be desired for the mapping
> code to map them as such? Otherwise, how could the IOMMU use case you
> described above (address translator for devices which don't have the
> capability to address a scatterlist) be handled properly?

It's up to the IOMMU code to respect the parameters that the device has
supplied to it via the device_dma_parameters.  This doesn't currently
allow a device to say "I want this scatterlist to be mapped as a
contiguous device address", so really if a device has such a requirement,
at the moment the device driver _must_ check the dma_map_sg() return
value and act accordingly.

While it's possible to say "an IOMMU should map as a single contiguous
address" what happens when the IOMMU's device address space becomes
fragmented?

> Is the general conclusion now that dma_map_sg() should not be used to
> create IOMMU mappings and we should make a step backwards making all
> drivers (or frameworks, such as videobuf2) do that manually? That
> would be really backwards, because code not aware of IOMMU existence
> at all would have to become aware of it.

No.  The DMA API has always had the responsibility for managing the
IOMMU device, which may well be shared between multiple different
devices.

However, if the IOMMU is part of a device IP block (such as a GPU)
then the decision on whether the DMA API should be used or not is up
to the driver author.  If it has special management requirements,
then it's probably appropriate for the device driver to manage it by
itself.

For example, a GPUs MMU may need something inserted into the GPUs
command stream to flush the MMU TLBs.  Such cases are inappropriate
to be using the DMA API for IOMMU management.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
