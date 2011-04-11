Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:40493 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1DKQMe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Apr 2011 12:12:34 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2.6.39] V4L: videobuf-dma-contig: fix mmap_mapper broken on ARM
Date: Mon, 11 Apr 2011 18:11:42 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, Jiri Slaby <jslaby@suse.cz>
References: <201104110048.08764.jkrzyszt@tis.icnet.pl> <4DA24E65.4060505@infradead.org>
In-Reply-To: <4DA24E65.4060505@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104111811.42563.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
> > 1. On architectures which provide dma_mmap_coherent() function (ARM
> > for
> > 
> >    now), use it instead of just remap_pfn_range(). The code is
> >    stollen from sound/core/pcm_native.c:snd_pcm_default_mmap().
> >    Set vma->vm_pgoff to 0 before calling dma_mmap_coherent(), or it
> >    fails.
> > 
> > 2. On other architectures, use
> > virt_to_phys(bus_to_virt(mem->dma_handle))
> > 
> >    instead of problematic virt_to_phys(mem->vaddr). This should
> >    work even if those translations would occure inaccurate for DMA
> >    addresses, since possible errors introduced by both
> >    calculations, performed in opposite directions, should
> >    compensate.
> > 
> > Both solutions tested on ARM OMAP1 based Amstrad Delta board.
...
> The code is saying that dma_mmap_coherent should be used only on ARM
> and PPC architectures, and remap_pfn_range should be used otherwise.
> Are you sure that this will work on the other architectures? I
> really prefer to have one standard way for doing it, that would be
> architecture-independent. Media drivers or core should not have
> arch-dependent code inside.

More looking at this and making more tests, I found that the 
dma_mmap_coherent() method, working correctly on OMAP1 which has no 
countermeasures against unpredictable dma_alloc_coherent() runtime 
behaviour implemented, may not be compatible with all those 
dma_declare_coherent_memory() and alike workarounds, still being used,  
more or less successfully, on other ARM platforms/machines/boards.

Under such circumstances, I'd opt for choosing the depreciated, but 
hopefully working, bi-directional translation method, ie. 
virt_to_phys(bus_to_virt(mem->dma_handle)), as the regression fix.

Thanks,
Janusz
