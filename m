Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45568 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbbBCPy2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 10:54:28 -0500
Date: Tue, 3 Feb 2015 15:54:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org,
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
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing
 attacher constraints with dma-parms
Message-ID: <20150203155404.GV8656@n2100.arm.linux.org.uk>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
 <4830208.H6zxrGlT1D@wuerfel>
 <20150203152204.GU8656@n2100.arm.linux.org.uk>
 <3783167.LiVXgA35gN@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3783167.LiVXgA35gN@wuerfel>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 03, 2015 at 04:31:13PM +0100, Arnd Bergmann wrote:
> On Tuesday 03 February 2015 15:22:05 Russell King - ARM Linux wrote:
> > Don't we already have those in the DMA API?  dma_sync_*() ?
> >
> > dma_map_sg() - sets up the system MMU and deals with initial cache
> > coherency handling.  Device IOMMU being the responsibility of the
> > GPU driver.
> 
> dma_sync_*() works with whatever comes out of dma_map_*(), true,
> but this is not what they want to do here.
>  
> > The GPU can then do dma_sync_*() on the scatterlist as is necessary
> > to synchronise the cache coherency (while respecting the ownership
> > rules - which are very important on ARM to follow as some sync()s are
> > destructive to any dirty data in the CPU cache.)
> > 
> > dma_unmap_sg() tears down the system MMU and deals with the final cache
> > handling.
> > 
> > Why do we need more DMA API interfaces?
> 
> The dma_map_* interfaces assign the virtual addresses internally,
> using typically either a global address space for all devices, or one
> address space per device.

We shouldn't be doing one address space per device for precisely this
reason.  We should be doing one address space per *bus*.  I did have
a nice diagram to illustrate the point in my previous email, but I
deleted it, I wish I hadn't... briefly:

Fig. 1.
                                                 +------------------+
                                                 |+-----+  device   |
CPU--L1cache--L2cache--Memory--SysMMU---<iobus>----IOMMU-->         |
                                                 |+-----+           |
                                                 +------------------+

Fig.1 represents what I'd call the "GPU" issue that we're talking about
in this thread.

Fig. 2.
CPU--L1cache--L2cache--Memory--SysMMU---<iobus>--IOMMU--device

The DMA API should be responsible (at the very least) for everything on
the left of "<iobus>" in and should be providing a dma_addr_t which is
representative of what the device (in Fig.1) as a whole sees.  That's
the "system" part.  

I believe this is the approach which is taken by x86 and similar platforms,
simply because they tend not to have an IOMMU on individual devices (and
if they did, eg, on a PCI card, it's clearly the responsibility of the
device driver.)

Whether the DMA API also handles the IOMMU in Fig.1 or 2 is questionable.
For fig.2, it is entirely possible that the same device could appear
without an IOMMU, and in that scenario, you would want the IOMMU to be
handled transparently.

However, by doing so for everything, you run into exactly the problem
which is being discussed here - the need to separate out the cache
coherency from the IOMMU aspects.  You probably also have a setup very
similar to fig.1 (which is certainly true of Vivante GPUs.)

If you have the need to separately control both, then using the DMA API
to encapsulate both does not make sense - at which point, the DMA API
should be responsible for the minimum only - in other words, everything
to the left of <iobus> (so including the system MMU.)  The control of
the device IOMMU should be the responsibility of device driver in this
case.

So, dma_map_sg() would be responsible for dealing with the CPU cache
coherency issues, and setting up the system MMU.  dma_sync_*() would
be responsible for the CPU cache coherency issues, and dma_unmap_sg()
would (again) deal with the CPU cache and tear down the system MMU
mappings.

Meanwhile, the device driver has ultimate control over its IOMMU, the
creation and destruction of mappings and context switches at the
appropriate times.

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
