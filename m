Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:43253 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab1DMKxq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 06:53:46 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Wed, 13 Apr 2011 12:52:31 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <20110412214011.GG7806@n2100.arm.linux.org.uk>
In-Reply-To: <20110412214011.GG7806@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104131252.32011.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue 12 Apr 2011 at 23:40:11 Russell King - ARM Linux wrote:
> On Tue, Apr 12, 2011 at 11:06:34PM +0200, Janusz Krzysztofik wrote:
> > The patch tries to solve this regression by using
> > virt_to_phys(bus_to_virt(mem->dma_handle)) instead of problematic
> > virt_to_phys(mem->vaddr).
> 
> Who says that DMA handles are bus addresses in the strictest sense?
> 
> DMA handles on ARM are the bus address to program 'dev' with in order
> for it to access the memory mapped by dma_alloc_coherent().  On some
> ARM platforms, this bus address is dependent on 'dev' - such as
> platforms with more than one root PCI bus, and so bus_to_virt() just
> doesn't hack it.

Taking into account that I'm just trying to fix a regression, and not 
invent a new, long term solution: are you able to name an ARM based 
board which a) is already supported in 2.6.39, b) is (or can be) 
equipped with a device supported by a V4L driver which uses videobuf-
dma-config susbsystem, c) has a bus structure with which 
virt_to_phys(bus_to_virt(dma_handle)) is not equal dma_handle?

If there is one, then I agree that my short-term fix is wrong.

> What is really needed is for this problem - the mapping of DMA
> coherent memory into userspace - to be solved with a proper arch API
> rather than all these horrible hacks which subsystems instead
> invent.  That's something I tried to do with the dma_mmap_coherent()
> stuff but it was shot down by linux-arch as (iirc) PA-RISC objected
> to it.
> 
> Hence why ARM only implements it.

I thought so too, but missed the fact that PowerPC implements it 
actually, even defining the ARCH_HAS_DMA_MMAP_COHERENT symbol, which ARM 
doesn't so far.

> Maybe the video drivers should try to resurect the idea, maybe only
> allowing this support for architectures which provide
> dma_mmap_coherent().

AFAICT, ARM implementation of dma_mmap_coherent() is not compatible with 
dma_declare_coherent_memory(), is it? If I'm wrong, please correct me, 
I'll get back to the idea presented in v1 of the fix.

Otherwise, I think that switching to dma_mmap_coherent() is not an 
option for the videobuf-dma-contig subsystem as long as there is no good 
solution to the problem of dma_alloc_coherent() not guaranteed to 
succeed with high-order allocations at any time. Any chance for your 
already proposed 
(http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036463.html, 
http://lists.infradead.org/pipermail/linux-arm-kernel/2011-January/036809.html), 
or perhaps a new, better solution ever finding its way to the mainline 
tree?

Thanks,
Janusz
