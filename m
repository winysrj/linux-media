Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:42716 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab1DLWNB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Apr 2011 18:13:01 -0400
Date: Tue, 12 Apr 2011 17:12:43 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jiri Slaby <jslaby@suse.cz>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2.6.39 v2] V4L: videobuf-dma-contig: fix mmap_mapper
 broken on ARM
In-Reply-To: <20110412214011.GG7806@n2100.arm.linux.org.uk>
Message-ID: <alpine.LNX.2.00.1104121651250.4240@banach.math.auburn.edu>
References: <201104122306.34909.jkrzyszt@tis.icnet.pl> <20110412214011.GG7806@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Tue, 12 Apr 2011, Russell King - ARM Linux wrote:

> On Tue, Apr 12, 2011 at 11:06:34PM +0200, Janusz Krzysztofik wrote:
> > The patch tries to solve this regression by using 
> > virt_to_phys(bus_to_virt(mem->dma_handle)) instead of problematic 
> > virt_to_phys(mem->vaddr).
> 
> Who says that DMA handles are bus addresses in the strictest sense?
> 
> DMA handles on ARM are the bus address to program 'dev' with in order
> for it to access the memory mapped by dma_alloc_coherent().  On some
> ARM platforms, this bus address is dependent on 'dev' - such as platforms
> with more than one root PCI bus, and so bus_to_virt() just doesn't
> hack it.
> 
> What is really needed is for this problem - the mapping of DMA coherent
> memory into userspace - to be solved with a proper arch API rather than
> all these horrible hacks which subsystems instead invent.  That's
> something I tried to do with the dma_mmap_coherent() stuff but it was
> shot down by linux-arch as (iirc) PA-RISC objected to it.
> 
> Hence why ARM only implements it.
> 
> Maybe the video drivers should try to resurect the idea, maybe only
> allowing this support for architectures which provide dma_mmap_coherent().


I do not know how this fits into the present discussion. Perhaps everyone 
who reads the above message is well aware of what is below. If so my 
comment below is superfluous. But just in case things are otherwise it 
might save someone a bit of trouble in trying to write something which 
will work "everywhere":

If one is speaking here of architecture problems, there is the additional 
problem that some ARM systems might have not two PCI buses, but instead 
no PCI bus at all.

Theodore Kilgore
