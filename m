Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:52082 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab1DKML1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 08:11:27 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Mon, 11 Apr 2011 14:10:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>
References: <201104110048.08764.jkrzyszt@tis.icnet.pl> <4DA24E65.4060505@infradead.org>
In-Reply-To: <4DA24E65.4060505@infradead.org>
MIME-Version: 1.0
Message-Id: <201104111410.37145.jkrzyszt@tis.icnet.pl>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Mon 11 Apr 2011 at 02:42:13 Mauro Carvalho Chehab wrote:
> Em 10-04-2011 19:47, Janusz Krzysztofik escreveu:
> > After switching from mem->dma_handle to virt_to_phys(mem->vaddr)
> > used for obtaining page frame number passed to remap_pfn_range()
> > (commit 35d9f510b67b10338161aba6229d4f55b4000f5b),
> > videobuf-dma-contig stopped working on my ARM based board. The ARM
> > architecture maintainer, Russell King, confirmed that using
> > something like
> > virt_to_phys(dma_alloc_coherent()) is not supported on ARM, and can
> > be broken on other architectures as well. The author of the
> > change, Jiri Slaby, also confirmed that his code may not work on
> > all architectures.
> > 
> > The patch takes two different countermeasures against this
> > regression:
> > 
> > 1. On architectures which provide dma_mmap_coherent() function (ARM for
> >    now), use it instead of just remap_pfn_range(). The code is
> >    stollen from sound/core/pcm_native.c:snd_pcm_default_mmap().
> >    Set vma->vm_pgoff to 0 before calling dma_mmap_coherent(), or it
> >    fails.
> > 
> > 2. On other architectures, use virt_to_phys(bus_to_virt(mem-dma_handle))
> >    instead of problematic virt_to_phys(mem->vaddr). This should
> >    work even if those translations would occure inaccurate for DMA
> >    addresses, since possible errors introduced by both
> >    calculations, performed in opposite directions, should
> >    compensate.
...
> > +#ifndef ARCH_HAS_DMA_MMAP_COHERENT
> > +/* This should be defined / handled globally! */
> > +#ifdef CONFIG_ARM
> > +#define ARCH_HAS_DMA_MMAP_COHERENT
> > +#endif
> > +#endif
> > +
> > +#ifdef ARCH_HAS_DMA_MMAP_COHERENT
> 
> Hmm... IMHO, this seems too confusing. Why not use just something
> like:
> 
> #if defined(CONFIG_ARM) || defined(ARCH_HAS_DMA_MMAP_COHERENT)
> 
> Better yet: why should CONFIG_ARM should explicitly be checked here?
> Is it the only architecture where this would fail?dma_mmap_coherent
> 
> Hmm...
> 
> $ git grep ARCH_HAS_DMA_MMAP_COHERENT arch
> arch/powerpc/include/asm/dma-mapping.h:#define ARCH_HAS_DMA_MMAP_COHERENT

My fault, I've just missed the fact that PPC also provides 
dma_mmap_coherent() AND, unlike ARM, defines ARCH_HAS_DMA_MMAP_COHERENT 
as well. Then, I would drop all above ifdefery except the last '#ifdef 
ARCH_HAS_DMA_MMAP_COHERENT', and also submit a separate patch against 
arch/arm/include/asm/dma-mapping.h for it to define 
ARCH_HAS_DMA_MMAP_COHERENT, OK?

> The code is saying that dma_mmap_coherent should be used only on ARM
> and PPC architectures, and remap_pfn_range should be used otherwise.

Yes, because only these two architectures provide this function:

$ grep -r "EXPORT_SYMBOL.*(dma_mmap_coherent)" arch
arch/powerpc/kernel/dma.c:EXPORT_SYMBOL_GPL(dma_mmap_coherent);
arch/arm/mm/dma-mapping.c:EXPORT_SYMBOL(dma_mmap_coherent);

Other must keep using remap_pfn_range(), as they used to before.

> Are you sure that this will work on the other architectures? 

If you mean using virt_to_phys(bus_to_virt(mem->dma_handle)) instead of 
that problematic virt_to_phys(mem->vaddr) - yes, I think this should 
work not any worth than before, and shouldn't break anything on any 
architecture, including those not suffering from the problem.

What I'm not sure about is if this really helps on all those affected 
architectures (if still any) which don't provide their 
dma_mmap_coherent() implementation yet. I can only confirm this helps on 
my ARM.

I've already asked for testing to get an idea which architectures those 
could be 
(http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/047701.html),
but haven't received any response yet.

> I really prefer to have one standard way for doing it, that would 
> be architecture-independent. Media drivers or core should not have
> arch-dependent code inside.

Sure, but here we have a choice between the still working but 
depreciated usage of bus_to_virt() for tranlating a DMA bus address, and 
a new way of doing things with dma_mmap_coherent(), which is not (yet) 
widely supported. If you think we should limit our choice to the 
depreciated way, please tell me, I'll modify the patch the way you like 
it.

Thanks,
Janusz

> > +	vma->vm_pgoff = 0;
> > +	retval = dma_mmap_coherent(q->dev, vma, mem->vaddr, mem->dma_handle, 
> > +			mem->size);
> > +#else
> >  	size = vma->vm_end - vma->vm_start;
> >  	size = (size < mem->size) ? size : mem->size;
> >  	
> >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> >  	retval = remap_pfn_range(vma, vma->vm_start,
> > -				 PFN_DOWN(virt_to_phys(mem->vaddr)),
> > -				 size, vma->vm_page_prot);
> > +			PFN_DOWN(virt_to_phys(bus_to_virt(mem->dma_handle))),
> > +			size, vma->vm_page_prot);
> > +#endif
> >  	if (retval) {
> >  		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
> >  		dma_free_coherent(q->dev, mem->size,
