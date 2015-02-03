Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:45729 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966208AbbBCPTd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 10:19:33 -0500
MIME-Version: 1.0
In-Reply-To: <20150203144109.GR8656@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<20150203074856.GF14009@phenom.ffwll.local>
	<CAF6AEGu0-TgyE4BjiaSWXQCSk31VU7dogq=6xDRUhi79rGgbxg@mail.gmail.com>
	<4689826.8DDCrX2ZhK@wuerfel>
	<20150203144109.GR8656@n2100.arm.linux.org.uk>
Date: Tue, 3 Feb 2015 10:19:32 -0500
Message-ID: <CAF6AEGusWPPDJtHA3A7rfMrBROB0pMSZUi55B7vo+ybL4W1LXQ@mail.gmail.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints
 with dma-parms
From: Rob Clark <robdclark@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 3, 2015 at 9:41 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Feb 03, 2015 at 03:17:27PM +0100, Arnd Bergmann wrote:
>> On Tuesday 03 February 2015 09:04:03 Rob Clark wrote:
>> > Since I'm stuck w/ an iommu, instead of built in mmu, my plan was to
>> > drop use of dma-mapping entirely (incl the current call to dma_map_sg,
>> > which I just need until we can use drm_cflush on arm), and
>> > attach/detach iommu domains directly to implement context switches.
>> > At that point, dma_addr_t really has no sensible meaning for me.
>>
>> I think what you see here is a quite common hardware setup and we really
>> lack the right abstraction for it at the moment. Everybody seems to
>> work around it with a mix of the dma-mapping API and the iommu API.
>> These are doing different things, and even though the dma-mapping API
>> can be implemented on top of the iommu API, they are not really compatible.
>
> I'd go as far as saying that the "DMA API on top of IOMMU" is more
> intended to be for a system IOMMU for the bus in question, rather
> than a device-level IOMMU.
>
> If an IOMMU is part of a device, then the device should handle it
> (maybe via an abstraction) and not via the DMA API.  The DMA API should
> be handing the bus addresses to the device driver which the device's
> IOMMU would need to generate.  (In other words, in this circumstance,
> the DMA API shouldn't give you the device internal address.)

if the dma_addr_t becomes the address upstream of the iommu (in
practice, the phys addr), that would, I think, address my concerns
about dma_addr_t

BR,
-R

> --
> FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
> according to speedtest.net.
