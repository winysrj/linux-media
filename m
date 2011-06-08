Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:52816 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269Ab1FHV4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2011 17:56:42 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Date: Wed, 8 Jun 2011 23:53:49 +0200
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <20101210170356.GA28472@n2100.arm.linux.org.uk> <201012102203.54413.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201012102203.54413.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Message-Id: <201106082354.10985.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri 10 Dec 2010 at 22:03:52 Janusz Krzysztofik wrote:
> Friday 10 December 2010 18:03:56 Russell King - ARM Linux napisał(a):
> > On Fri, Dec 10, 2010 at 12:03:07PM +0100, Janusz Krzysztofik wrote:
> > >  void __init omap1_camera_init(void *info)
> > >  {
> > >  
> > >  	struct platform_device *dev = &omap1_camera_device;
> > > 
> > > +	dma_addr_t paddr = omap1_camera_phys_mempool_base;
> > > +	dma_addr_t size = omap1_camera_phys_mempool_size;
> > > 
> > >  	int ret;
> > >  	
> > >  	dev->dev.platform_data = info;
> > > 
> > > +	if (paddr) {
> > > +		if (dma_declare_coherent_memory(&dev->dev, paddr, paddr, size,
> > > +				DMA_MEMORY_MAP | DMA_MEMORY_EXCLUSIVE))
> > 
> > Although this works, you're ending up with SDRAM being mapped via
> > ioremap, which uses MT_DEVICE - so what is SDRAM ends up being
> > mapped as if it were a device.
> > 
> > For OMAP1, which is ARMv5 or lower, device memory becomes
> > 'uncacheable, unbufferable' which is luckily what is used for the
> > DMA coherent memory on those platforms - so no technical problem
> > here.
> > 
> > However, on ARMv6 and later, ioremapped memory is device memory,
> > which has different ordering wrt normal memory mappings, and may
> > appear on different busses on the CPU's interface.  So, this is
> > something I don't encourage as it's unclear that the hardware will
> > work.
> > 
> > Essentially, dma_declare_coherent_memory() on ARM with main SDRAM
> > should be viewed as a 'it might work, it might not, and it might
> > stop working in the future' kind of interface.  In other words,
> > there is no guarantee that this kind of thing will be supported in
> > the future.
> 
> I was affraid of an unswer of this kind. I'm not capable of comming
> out with any better, alternative solutions. Any hints other than
> giving up with that old videobuf-contig, coherent memory based
> interface? Or can we agree on that 'luckily uncacheable,
> unbufferable, SDRAM based DMA coherent memory' solution for now?

Russell, Tony,

Sorry for getting back to this old thread, but since my previous 
attempts to provide[1] or support[2] a possibly better solution to the 
problem all failed on one hand, and I can see patches not very different 
from mine[3] being accepted for arch/arm/mach-{mx3,imx} during this and 
previous merge windows[4][5][6] on the other, is there any chance for the 
'dma_declare_coherent_memory() over a memblock_alloc()->free()->remove() 
obtained area' based solution being accepted for omap1_camera as well if 
I resend it refreshed?

BTW, commit 6d3163ce86dd386b4f7bda80241d7fea2bc0bb1d, "mm: check if any 
page in a pageblock is reserved before marking it MIGRATE_RESERVE", 
almost corrected the problem for me, allowing for very stable device 
operation in videobuf_dma_contig mode once all resident programs get 
settled up and no unusual activity happens, but this is still not 100% 
reliable, so I think that only using a kind of memory area reservered 
during boot for the purpose can be considered as free of transient 
-ENOMEM issues.

Thanks,
Janusz

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036419.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/036551.html
[3] http://lists.infradead.org/pipermail/linux-arm-kernel/2010-December/034643.html
[4] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;h=164f7b5237cca2701dd2943928ec8d078877a28d
[5] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;h=031e912741746e4350204bb0436590ca0e993a7d
[6] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;h=dca7c0b4293a06d1ed9387e729a4882896abccc2
