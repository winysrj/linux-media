Return-path: <linux-media-owner@vger.kernel.org>
Received: from 8bytes.org ([81.169.241.247]:41694 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966004AbbJ3OJ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2015 10:09:26 -0400
Date: Fri, 30 Oct 2015 15:09:24 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Pawel Osciak <pawel@osciak.com>,
	Yong Wu <yong.wu@mediatek.com>,
	Will Deacon <will.deacon@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, thunder.leizhen@huawei.com,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	laurent.pinchart+renesas@ideasonboard.com,
	Thierry Reding <treding@nvidia.com>,
	Lin PoChun <pochun.lin@mediatek.com>,
	"Bobby Batacharia (via Google Docs)" <Bobby.Batacharia@arm.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
Message-ID: <20151030140923.GJ27420@8bytes.org>
References: <cover.1443718557.git.robin.murphy@arm.com>
 <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03>
 <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 30, 2015 at 09:17:52AM +0800, Daniel Kurtz wrote:
> Hmm, I thought the DMA API maps a (possibly) non-contiguous set of
> memory pages into a contiguous block in device memory address space.
> This would allow passing a dma mapped buffer to device dma using just
> a device address and length.

If you are speaking of the dma_map_sg interface, than there is absolutly
no guarantee from the API side that the buffers you pass in will end up
mapped contiguously.
IOMMU drivers handle this differently, and when there is no IOMMU at all
there is also no way to map these buffers together.

> So, is the videobuf2-dma-contig.c based on an incorrect assumption
> about how the DMA API is supposed to work?

If it makes the above assumption, then yes.



	Joerg

