Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:63883 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965550AbbBCPZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 10:25:51 -0500
MIME-Version: 1.0
In-Reply-To: <4830208.H6zxrGlT1D@wuerfel>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<4689826.8DDCrX2ZhK@wuerfel>
	<20150203144109.GR8656@n2100.arm.linux.org.uk>
	<4830208.H6zxrGlT1D@wuerfel>
Date: Tue, 3 Feb 2015 10:25:50 -0500
Message-ID: <CAF6AEGt5TcpdTFv+2GJ1GMzyr52BEkSBffZTW5C1ytg9G6N7Qw@mail.gmail.com>
Subject: Re: [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints
 with dma-parms
From: Rob Clark <robdclark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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

On Tue, Feb 3, 2015 at 9:52 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 03 February 2015 14:41:09 Russell King - ARM Linux wrote:
>> On Tue, Feb 03, 2015 at 03:17:27PM +0100, Arnd Bergmann wrote:
>> > On Tuesday 03 February 2015 09:04:03 Rob Clark wrote:
>> > > Since I'm stuck w/ an iommu, instead of built in mmu, my plan was to
>> > > drop use of dma-mapping entirely (incl the current call to dma_map_sg,
>> > > which I just need until we can use drm_cflush on arm), and
>> > > attach/detach iommu domains directly to implement context switches.
>> > > At that point, dma_addr_t really has no sensible meaning for me.
>> >
>> > I think what you see here is a quite common hardware setup and we really
>> > lack the right abstraction for it at the moment. Everybody seems to
>> > work around it with a mix of the dma-mapping API and the iommu API.
>> > These are doing different things, and even though the dma-mapping API
>> > can be implemented on top of the iommu API, they are not really compatible.
>>
>> I'd go as far as saying that the "DMA API on top of IOMMU" is more
>> intended to be for a system IOMMU for the bus in question, rather
>> than a device-level IOMMU.
>>
>> If an IOMMU is part of a device, then the device should handle it
>> (maybe via an abstraction) and not via the DMA API.  The DMA API should
>> be handing the bus addresses to the device driver which the device's
>> IOMMU would need to generate.  (In other words, in this circumstance,
>> the DMA API shouldn't give you the device internal address.)
>
> Exactly. And the abstraction that people choose at the moment is the
> iommu API, for better or worse. It makes a lot of sense to use this
> API if the same iommu is used for other devices as well (which is
> the case on Tegra and probably a lot of others). Unfortunately the
> iommu API lacks support for cache management, and probably other things
> as well, because this was not an issue for the original use case
> (device assignment on KVM/x86).
>
> This could be done by adding explicit or implied cache management
> to the IOMMU mapping interfaces, or by extending the dma-mapping
> interfaces in a way that covers the use case of the device managing
> its own address space, in addition to the existing coherent and
> streaming interfaces.

I think for gpu's, we'd prefer explicit and less abstraction..  which
is probably opposite of what every other driver would want

In the end, my eventual goal is explicit control of tlb flush, and
control of my address space.  And in fact in some cases we are going
to want to use the gpu to bang on iommu registers to do context
switches and tlb flushes.  (Which is obviously not the first step..
and something that is fairly difficult to get right/secure.. but the
performance win seems significant so I'm not sure we can avoid it.)

BR,
-R

>
>         Arnd
