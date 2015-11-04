Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:58687 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932258AbbKDJK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 04:10:28 -0500
Date: Wed, 4 Nov 2015 09:10:00 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
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
Message-ID: <20151104091000.GH8644@n2100.arm.linux.org.uk>
References: <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03>
 <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com>
 <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com>
 <20151103184019.GD8644@n2100.arm.linux.org.uk>
 <CAAFQd5COY-dvBE73R=sUWoGfXR9CvgurGchYgXB6y9eqQ=BBUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5COY-dvBE73R=sUWoGfXR9CvgurGchYgXB6y9eqQ=BBUQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 04, 2015 at 02:15:41PM +0900, Tomasz Figa wrote:
> On Wed, Nov 4, 2015 at 3:40 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Tue, Nov 03, 2015 at 05:41:24PM +0000, Robin Murphy wrote:
> >> Hi Tomasz,
> >>
> >> On 02/11/15 13:43, Tomasz Figa wrote:
> >> >Agreed. The dma_map_*() API is not guaranteed to return a single
> >> >contiguous part of virtual address space for any given SG list.
> >> >However it was understood to be able to map buffers contiguously
> >> >mappable by the CPU into a single segment and users,
> >> >videobuf2-dma-contig in particular, relied on this.
> >>
> >> I don't follow that - _any_ buffer made of page-sized chunks is going to be
> >> mappable contiguously by the CPU; it's clearly impossible for the streaming
> >> DMA API itself to offer such a guarantee, because it's entirely orthogonal
> >> to the presence or otherwise of an IOMMU.
> >
> > Tomasz's use of "virtual address space" above in combination with the
> > DMA API is really confusing.
> 
> I suppose I must have mistakenly use "virtual address space" somewhere
> instead of "IO virtual address space". I'm sorry for causing
> confusion.
> 
> The thing being discussed here is mapping of buffers described by
> scatterlists into IO virtual address space, i.e. the operation
> happening when dma_map_sg() is called for an IOMMU-enabled device.

... and there, it's perfectly legal for an IOMMU to merge all entries
in a scatterlist into one mapping - so dma_map_sg() would return 1.

What that means is that the scatterlist contains the original number of
entries which describes the CPU view of the buffer list using the original
number of entries, and the DMA device view of the same but using just the
first entry.

In other words, if you're walking a scatterlist, and doing a mixture of
DMA and PIO, you can't assume that if you're at scatterlist entry N for
DMA, you can switch to PIO for entry N and you'll write to the same
memory.  (I know that there's badly written drivers in the kernel which
unfortunately do make this assumption, and if they're used in the
presence of an IOMMU, they _will_ be silently data corrupting.)

-- 
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
