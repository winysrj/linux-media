Return-path: <mchehab@pedra>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52509 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab1FHWOQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 18:14:16 -0400
Date: Wed, 8 Jun 2011 23:13:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Message-ID: <20110608221330.GA13246@n2100.arm.linux.org.uk>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <20101210170356.GA28472@n2100.arm.linux.org.uk> <201012102203.54413.jkrzyszt@tis.icnet.pl> <201106082354.10985.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201106082354.10985.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 08, 2011 at 11:53:49PM +0200, Janusz Krzysztofik wrote:
> On Fri 10 Dec 2010 at 22:03:52 Janusz Krzysztofik wrote:
> > Friday 10 December 2010 18:03:56 Russell King - ARM Linux napisał(a):
> > > On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
> > > >  void __init omap1_camera_init(void *info)
> > > >  {
> > > >  
> > > >  	struct platform_device *dev = &omap1_camera_device;
> > > > 
> > > > +	dma_addr_t paddr = omap1_camera_phys_mempool_base;
> > > > +	dma_addr_t size = omap1_camera_phys_mempool_size;
> > > > 
> > > >  	int ret;
> > > >  	
> > > >  	dev->dev.platform_data = info;
> > > > 
> > > > +	if (paddr) {
> > > > +		if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
> > > > +				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
> > > 
> > > Although this works, you're ending up with SDRAM being mapped via
> > > ioremap, which uses MT_DEVICE - so what is SDRAM ends up being
> > > mapped as if it were a device.
> > > 
> > > For OMAP1, which is ARMv5 or lower, device memory becomes
> > > 'uncacheable, unbufferable' which is luckily what is used for the
> > > DMA coherent memory on those platforms - so no technical problem
> > > here.
> > > 
> > > However, on ARMv6 and later, ioremapped memory is device memory,
> > > which has different ordering wrt normal memory mappings, and may
> > > appear on different busses on the CPU's interface.  So, this is
> > > something I don't encourage as it's unclear that the hardware will
> > > work.
> > > 
> > > Essentially, dma_declare_coherent_memory() on ARM with main SDRAM
> > > should be viewed as a 'it might work, it might not, and it might
> > > stop working in the future' kind of interface.  In other words,
> > > there is no guarantee that this kind of thing will be supported in
> > > the future.
> > 
> > I was affraid of an unswer of this kind. I'm not capable of comming
> > out with any better, alternative solutions. Any hints other than
> > giving up with that old videobuf-contig, coherent memory based
> > interface? Or can we agree on that 'luckily uncacheable,
> > unbufferable, SDRAM based DMA coherent memory' solution for now?
> 
> Russell, Tony,
> 
> Sorry for getting back to this old thread, but since my previous 
> attempts to provide[1] or support[2] a possibly better solution to the 
> problem all failed on one hand, and I can see patches not very different 
> from mine[3] being accepted for arch/arm/mach-{mx3,imx} during this and 
> previous merge windows[4][5][6] on the other, is there any chance for the 
> 'dma_declare_coherent_memory() over a memblock_alloc()->free()->remove() 
> obtained area' based solution being accepted for omap1_camera as well if 
> I resend it refreshed?

I stand by my answer to your patches quoted above from a technical point
of view; we should not be mapping SDRAM using device mappings.

That ioremap() inside dma_declare_coherent_memory() needs to die, but
it seems that those who now look after the DMA API really aren't
interested in the technical details of this being wrong for some
architecture - just like they're not really interested in the details
of devices using dma-engines for their DMA support.

I'm afraid that the DMA support in Linux sucks because of this, and I
have no real desire to participate in discussions with brick walls over
this.

Certainly the memblock_alloc()+free()+remove() is the right way to
reserve the memory, but as it stands dma_declare_coherent_memory()
should not be used on ARMv6 or higher CPUs to pass that memory to the
device driver.
