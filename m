Return-path: <mchehab@localhost>
Received: from d1.icnet.pl ([212.160.220.21]:50562 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab1GLJ4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 05:56:00 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Date: Tue, 12 Jul 2011 11:53:26 +0200
Cc: Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <201106082354.10985.jkrzyszt@tis.icnet.pl> <20110608221330.GA13246@n2100.arm.linux.org.uk>
In-Reply-To: <20110608221330.GA13246@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107121153.27115.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Thu, 9 Jun 2011 at 00:13:30 Russell King - ARM Linux wrote:
> On Wed, Jun 08, 2011 at 11:53:49PM +0200, Janusz Krzysztofik wrote:
> > On Fri 10 Dec 2010 at 22:03:52 Janusz Krzysztofik wrote:
> > > Friday 10 December 2010 18:03:56 Russell King - ARM Linux napisał(a):
> > > > On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
> > > > >  void __init omap1_camera_init(void *info)
> > > > >  {
> > > > >  
> > > > >  	struct platform_device *dev = &omap1_camera_device;
> > > > > 
> > > > > +	dma_addr_t paddr = omap1_camera_phys_mempool_base;
> > > > > +	dma_addr_t size = omap1_camera_phys_mempool_size;
> > > > > 
> > > > >  	int ret;
> > > > >  	
> > > > >  	dev->dev.platform_data = info;
> > > > > 
> > > > > +	if (paddr) {
> > > > > +		if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
> > > > > +				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
> > > > 
> > > > Although this works, you're ending up with SDRAM being mapped
> > > > via ioremap, which uses MT_DEVICE - so what is SDRAM ends up
> > > > being mapped as if it were a device.
> > > > 
> > > > For OMAP1, which is ARMv5 or lower, device memory becomes
> > > > 'uncacheable, unbufferable' which is luckily what is used for
> > > > the DMA coherent memory on those platforms - so no technical
> > > > problem here.
> > > > 
> > > > However, on ARMv6 and later, ioremapped memory is device
> > > > memory, which has different ordering wrt normal memory
> > > > mappings, and may appear on different busses on the CPU's
> > > > interface.  So, this is something I don't encourage as it's
> > > > unclear that the hardware will work.
> > > > 
> > > > Essentially, dma_declare_coherent_memory() on ARM with main
> > > > SDRAM should be viewed as a 'it might work, it might not, and
> > > > it might stop working in the future' kind of interface.  In
> > > > other words, there is no guarantee that this kind of thing
> > > > will be supported in the future.
> > 
> > Russell, Tony,
> > 
> > Sorry for getting back to this old thread, but since my previous
> > attempts to provide[1] or support[2] a possibly better solution to
> > the problem all failed on one hand, and I can see patches not very
> > different from mine[3] being accepted for arch/arm/mach-{mx3,imx}
> > during this and previous merge windows[4][5][6] on the other, is
> > there any chance for the 'dma_declare_coherent_memory() over a
> > memblock_alloc()->free()->remove() obtained area' based solution
> > being accepted for omap1_camera as well if I resend it refreshed?
> 
> I stand by my answer to your patches quoted above from a technical
> point of view; we should not be mapping SDRAM using device mappings.

Russell,
Would it change anything here if we define ARCH_HAS_HOLES_MEMORYMODEL, 
as suggested by Marek Szyprowski recently[*], when configuring for 
ARCH_OMAP1 with VIDEO_OMAP1 (camera) selected?

[*] http://lists.infradead.org/pipermail/linux-arm-kernel/2011-July/057447.html

> Certainly the memblock_alloc()+free()+remove() is the right way to
> reserve the memory, but as it stands dma_declare_coherent_memory()
> should not be used on ARMv6 or higher CPUs to pass that memory to the
> device driver.

Tony,
With full respect to all Russell's reservations about incorrectness of 
ioremapping SDRAM in general, would you be willing to accept this 
solution in the OMAP1 camera case, taking into account that, quoting 
Russell, "there is no technical problem here", and similiar solutions 
had been accepted recently with other ARM platforms?

Thanks,
Janusz
