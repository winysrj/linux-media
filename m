Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:62990 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbbBCPbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 10:31:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-mm-sig@lists.linaro.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Rob Clark <robdclark@gmail.com>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	linux-arm-kernel@lists.infradead.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints with dma-parms
Date: Tue, 03 Feb 2015 16:31:13 +0100
Message-ID: <3783167.LiVXgA35gN@wuerfel>
In-Reply-To: <20150203152204.GU8656@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org> <4830208.H6zxrGlT1D@wuerfel> <20150203152204.GU8656@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 February 2015 15:22:05 Russell King - ARM Linux wrote:
> On Tue, Feb 03, 2015 at 03:52:48PM +0100, Arnd Bergmann wrote:
> > On Tuesday 03 February 2015 14:41:09 Russell King - ARM Linux wrote:
> > > I'd go as far as saying that the "DMA API on top of IOMMU" is more
> > > intended to be for a system IOMMU for the bus in question, rather
> > > than a device-level IOMMU.
> > > 
> > > If an IOMMU is part of a device, then the device should handle it
> > > (maybe via an abstraction) and not via the DMA API.  The DMA API should
> > > be handing the bus addresses to the device driver which the device's
> > > IOMMU would need to generate.  (In other words, in this circumstance,
> > > the DMA API shouldn't give you the device internal address.)
> > 
> > Exactly. And the abstraction that people choose at the moment is the
> > iommu API, for better or worse. It makes a lot of sense to use this
> > API if the same iommu is used for other devices as well (which is
> > the case on Tegra and probably a lot of others). Unfortunately the
> > iommu API lacks support for cache management, and probably other things
> > as well, because this was not an issue for the original use case
> > (device assignment on KVM/x86).
> > 
> > This could be done by adding explicit or implied cache management
> > to the IOMMU mapping interfaces, or by extending the dma-mapping
> > interfaces in a way that covers the use case of the device managing
> > its own address space, in addition to the existing coherent and
> > streaming interfaces.
> 
> Don't we already have those in the DMA API?  dma_sync_*() ?
>
> dma_map_sg() - sets up the system MMU and deals with initial cache
> coherency handling.  Device IOMMU being the responsibility of the
> GPU driver.

dma_sync_*() works with whatever comes out of dma_map_*(), true,
but this is not what they want to do here.
 
> The GPU can then do dma_sync_*() on the scatterlist as is necessary
> to synchronise the cache coherency (while respecting the ownership
> rules - which are very important on ARM to follow as some sync()s are
> destructive to any dirty data in the CPU cache.)
> 
> dma_unmap_sg() tears down the system MMU and deals with the final cache
> handling.
> 
> Why do we need more DMA API interfaces?

The dma_map_* interfaces assign the virtual addresses internally,
using typically either a global address space for all devices, or one
address space per device.

There are multiple things that this cannot do, and that is why the
drivers use the iommu API directly:

- use one address space per 'struct mm'
- map user memory with bus_address == user_address
- map memory into the GPU without having a permanent kernel mapping
- map memory first, and do the initial cache flushes later

	Arnd
