Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58743 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbbKDJ2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 04:28:24 -0500
Date: Wed, 4 Nov 2015 09:27:48 +0000
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
Message-ID: <20151104092748.GI8644@n2100.arm.linux.org.uk>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03>
 <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com>
 <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 04, 2015 at 02:12:03PM +0900, Tomasz Figa wrote:
> My understanding of a scatterlist was that it represents a buffer as a
> whole, by joining together its physically discontinuous segments.

Correct, and it may also be scattered in CPU virtual space as well.

> I don't see how single segments (layout of which is completely up to
> the allocator; often just single pages) would be usable for hardware
> that needs to do some work more serious than just writing a byte
> stream continuously to subsequent buffers. In case of such simple
> devices you don't even need an IOMMU (for means other than protection
> and/or getting over address space limitations).

All that's required is that the addresses described in the scatterlist
are accessed as an apparently contiguous series of bytes.  They don't
have to be contiguous in any address view, provided the device access
appears to be contiguous.  How that is done is really neither here nor
there.

IOMMUs are normally there as an address translator - for example, the
underlying device may not have the capability to address a scatterlist
(eg, because it makes effectively random access) and in order to be
accessible to the device, it needs to be made contiguous in device
address space.

Another scenario is that you have more bits of physical address than
a device can generate itself for DMA purposes, and you need an IOMMU
to create a (possibly scattered) mapping in device address space
within the ability of the device to address.

The requirements here depend on the device behind the IOMMU.

> However, IMHO the most important use case of an IOMMU is to make
> buffers, which are contiguous in CPU virtual address space (VA),
> contiguous in device's address space (IOVA).

No - there is no requirement for CPU virtual contiguous buffers to also
be contiguous in the device address space.

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
