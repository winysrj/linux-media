Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39512 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655Ab1DMSdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2011 14:33:10 -0400
Date: Wed, 13 Apr 2011 19:32:31 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper
	broken on ARM
Message-ID: <20110413183231.GA23631@n2100.arm.linux.org.uk>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <20110412214011.GG7806@n2100.arm.linux.org.uk> <201104131252.32011.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104131252.32011.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Apr 13, 2011 at 12:52:31PM +0200, Janusz Krzysztofik wrote:
> Taking into account that I'm just trying to fix a regression, and not 
> invent a new, long term solution: are you able to name an ARM based 
> board which a) is already supported in 2.6.39, b) is (or can be) 
> equipped with a device supported by a V4L driver which uses videobuf-
> dma-config susbsystem, c) has a bus structure with which 
> virt_to_phys(bus_to_virt(dma_handle)) is not equal dma_handle?

I have no idea - and why should whether someone can name something that
may break be a justification to allow something which is technically
wrong?

Surely it should be the other way around - if its technically wrong and
_may_ break something then it shouldn't be allowed.

> I thought so too, but missed the fact that PowerPC implements it 
> actually, even defining the ARCH_HAS_DMA_MMAP_COHERENT symbol, which ARM 
> doesn't so far.

So, there's no problem adding that symbol to ARM.

> > Maybe the video drivers should try to resurect the idea, maybe only
> > allowing this support for architectures which provide
> > dma_mmap_coherent().
> 
> AFAICT, ARM implementation of dma_mmap_coherent() is not compatible with 
> dma_declare_coherent_memory(), is it? If I'm wrong, please correct me, 
> I'll get back to the idea presented in v1 of the fix.

1. dma_declare_coherent_memory() doesn't work on ARM for memory which
already exists (its not permitted to ioremap() the kernel direct-mapped
memory due to attribute aliasing issues.)

2. dma_declare_coherent_memory() totally bypasses the DMA allocator, and
so dma_mmap_coherent() has no knowledge of how to map the memory.

If we had a proper way to map DMA memory into userspace, then we wouldn't
have these issues as the dma_declare_coherent_memory() would already
support that.

And actually, talking about dma_declare_coherent_memory(), you've just
provided a reason why virt_to_phys(bus_to_virt(dma_handle)) won't work -
dma_declare_coherent_memory() can be used to provide on-device memory
where the virt/handle may not be mappable with bus_to_virt().

> Otherwise, I think that switching to dma_mmap_coherent() is not an 
> option for the videobuf-dma-contig subsystem as long as there is no good 
> solution to the problem of dma_alloc_coherent() not guaranteed to 
> succeed with high-order allocations at any time.

Let me repeat: there is no official API or way to map DMA memory into
userspace.  Every way people try is a half-hacked up bodge which may or
may not work for a limited subset of systems.

Until someone (like you) puts some serious effort into persuading
*everyone* that this feature is needed, things are just going to
continue being bodged and fragile.

All that's happening here is that you're changing one broken way which
works for one subset with another broken way which works for a different
subset of systems and architectures.  What actually needs to happen is
a _proper_ fix for this.
