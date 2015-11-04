Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33032 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbbKDJtM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 04:49:12 -0500
Received: by obbww6 with SMTP id ww6so8929128obb.0
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2015 01:49:12 -0800 (PST)
Received: from mail-oi0-f54.google.com (mail-oi0-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id e3sm153699obv.12.2015.11.04.01.49.10
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2015 01:49:10 -0800 (PST)
Received: by oifu63 with SMTP id u63so25246425oif.2
        for <linux-media@vger.kernel.org>; Wed, 04 Nov 2015 01:49:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151104092748.GI8644@n2100.arm.linux.org.uk>
References: <cover.1443718557.git.robin.murphy@arm.com> <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com> <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com> <CAAFQd5A4TcvkDMFezqEpkfWL+7yO2v=Hm=twk=p-NpADPpvqEQ@mail.gmail.com>
 <20151104092748.GI8644@n2100.arm.linux.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 4 Nov 2015 18:48:50 +0900
Message-ID: <CAAFQd5ApSFC6Pm4tDhZbJOVZ7szCx=diKUtGXq=M9a5Y_4qzOQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 4, 2015 at 6:27 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Nov 04, 2015 at 02:12:03PM +0900, Tomasz Figa wrote:
>> My understanding of a scatterlist was that it represents a buffer as a
>> whole, by joining together its physically discontinuous segments.
>
> Correct, and it may also be scattered in CPU virtual space as well.
>
>> I don't see how single segments (layout of which is completely up to
>> the allocator; often just single pages) would be usable for hardware
>> that needs to do some work more serious than just writing a byte
>> stream continuously to subsequent buffers. In case of such simple
>> devices you don't even need an IOMMU (for means other than protection
>> and/or getting over address space limitations).
>
> All that's required is that the addresses described in the scatterlist
> are accessed as an apparently contiguous series of bytes.  They don't
> have to be contiguous in any address view, provided the device access
> appears to be contiguous.  How that is done is really neither here nor
> there.
>
> IOMMUs are normally there as an address translator - for example, the
> underlying device may not have the capability to address a scatterlist
> (eg, because it makes effectively random access) and in order to be
> accessible to the device, it needs to be made contiguous in device
> address space.
>
> Another scenario is that you have more bits of physical address than
> a device can generate itself for DMA purposes, and you need an IOMMU
> to create a (possibly scattered) mapping in device address space
> within the ability of the device to address.
>
> The requirements here depend on the device behind the IOMMU.

I fully agree with you.

The problem is that the code being discussed here breaks the case of
devices that don't have the capability of addressing a scatterlist,
supposedly for the sake of devices that have such capability (but as I
suggested, they both could be happily supported, by distinguishing
special values of DMA max segment size and boundary mask).

>> However, IMHO the most important use case of an IOMMU is to make
>> buffers, which are contiguous in CPU virtual address space (VA),
>> contiguous in device's address space (IOVA).
>
> No - there is no requirement for CPU virtual contiguous buffers to also
> be contiguous in the device address space.

There is no requirement, but shouldn't it be desired for the mapping
code to map them as such? Otherwise, how could the IOMMU use case you
described above (address translator for devices which don't have the
capability to address a scatterlist) be handled properly?

Is the general conclusion now that dma_map_sg() should not be used to
create IOMMU mappings and we should make a step backwards making all
drivers (or frameworks, such as videobuf2) do that manually? That
would be really backwards, because code not aware of IOMMU existence
at all would have to become aware of it.

Best regards,
Tomasz
