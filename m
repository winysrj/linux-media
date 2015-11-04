Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36123 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbbKDFQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Nov 2015 00:16:03 -0500
Received: by obdgf3 with SMTP id gf3so31135678obd.3
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2015 21:16:02 -0800 (PST)
Received: from mail-ob0-f172.google.com (mail-ob0-f172.google.com. [209.85.214.172])
        by smtp.gmail.com with ESMTPSA id r205sm7676137oih.6.2015.11.03.21.16.01
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2015 21:16:01 -0800 (PST)
Received: by obbww6 with SMTP id ww6so4966327obb.0
        for <linux-media@vger.kernel.org>; Tue, 03 Nov 2015 21:16:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151103184019.GD8644@n2100.arm.linux.org.uk>
References: <cover.1443718557.git.robin.murphy@arm.com> <ab8e1caa40d6da1afa4a49f30242ef4e6e1f17df.1443718557.git.robin.murphy@arm.com>
 <1445867094.30736.14.camel@mhfsdcap03> <562E5AE4.9070001@arm.com>
 <CAGS+omAWCQsqk56iv0PW2ZhTJ1342GufUsJCP=VYSgCxZNLJpA@mail.gmail.com>
 <56337E4D.1010304@arm.com> <CAGS+omAmxbb4uVzaQh1xPmkFtcF6KP-HSV-40=sm1BRTdh+=OQ@mail.gmail.com>
 <CAAFQd5C_dkWBZrQXtyO59ARw7q-0fg-Wk98yApC5VHdQ8-AmNw@mail.gmail.com>
 <5638F1C4.3000900@arm.com> <20151103184019.GD8644@n2100.arm.linux.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 4 Nov 2015 14:15:41 +0900
Message-ID: <CAAFQd5COY-dvBE73R=sUWoGfXR9CvgurGchYgXB6y9eqQ=BBUQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] iommu: Implement common IOMMU ops for DMA mapping
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 4, 2015 at 3:40 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 03, 2015 at 05:41:24PM +0000, Robin Murphy wrote:
>> Hi Tomasz,
>>
>> On 02/11/15 13:43, Tomasz Figa wrote:
>> >Agreed. The dma_map_*() API is not guaranteed to return a single
>> >contiguous part of virtual address space for any given SG list.
>> >However it was understood to be able to map buffers contiguously
>> >mappable by the CPU into a single segment and users,
>> >videobuf2-dma-contig in particular, relied on this.
>>
>> I don't follow that - _any_ buffer made of page-sized chunks is going to be
>> mappable contiguously by the CPU; it's clearly impossible for the streaming
>> DMA API itself to offer such a guarantee, because it's entirely orthogonal
>> to the presence or otherwise of an IOMMU.
>
> Tomasz's use of "virtual address space" above in combination with the
> DMA API is really confusing.

I suppose I must have mistakenly use "virtual address space" somewhere
instead of "IO virtual address space". I'm sorry for causing
confusion.

The thing being discussed here is mapping of buffers described by
scatterlists into IO virtual address space, i.e. the operation
happening when dma_map_sg() is called for an IOMMU-enabled device.

Best regards,
Tomasz
