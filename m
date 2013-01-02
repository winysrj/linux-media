Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31142 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3ABOkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 09:40:00 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Message-id: <50E446BB.7090609@samsung.com>
Date: Wed, 02 Jan 2013 15:39:55 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH/RFC 0/4] Re: dma_mmap_coherent / ARCH_HAS_DMA_MMAP_COHERENT
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
 <1356722614-18224-1-git-send-email-geert@linux-m68k.org>
In-reply-to: <1356722614-18224-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 12/28/2012 8:23 PM, Geert Uytterhoeven wrote:
> On Sun, Dec 16, 2012 at 5:03 PM, Geert Uytterhoeven <geert@linux-m68k.org>
> wrote:
> > drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> > drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> > drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> > drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
> > make[6]: *** [drivers/media/v4l2-core/videobuf2-dma-contig.o] Error 1
> > make[6]: Target `__build' not remade because of errors.
> > make[5]: *** [drivers/media/v4l2-core] Error 2
> >
> > Both dma_mmap_coherent() and dma_get_sgtable() are defined in
> > include/asm-generic/dma-mapping-common.h only, which is included by
> > <asm/dma-mapping.h> on alpha, arm, arm64, hexagon, ia64, microblaze, mips,
> > openrisc, powerpc, s390, sh, sparc, tile, unicore32, x86.
> > Should the remaining architectures include this, too?
> > Should it be moved to <linux/dma-mapping.h>?
>
> I came up with an RFC-solution for this in [PATCH/RFC 3/4]
> ("avr32/bfin/c6x/cris/frv/m68k/mn10300/parisc/xtensa: Add dummy get_dma_ops()")
> and [PATCH/RFC 4/4] ("common: dma-mapping: Move dma_common_*() to
> <linux/dma-mapping.h>") of this series.
>
> > Furthermore, there's ARCH_HAS_DMA_MMAP_COHERENT, which is defined
> > by powerpc only:
> > arch/powerpc/include/asm/dma-mapping.h:#define ARCH_HAS_DMA_MMAP_COHERENT
> >
> > and handled in some fishy way in sound/core/pcm_native.c:
> >
> > #ifndef ARCH_HAS_DMA_MMAP_COHERENT
> > /* This should be defined / handled globally! */
> > #ifdef CONFIG_ARM
> > #define ARCH_HAS_DMA_MMAP_COHERENT
> > #endif
> > #endif
> >
> > /*
> >  * mmap the DMA buffer on RAM
> >  */
> > int snd_pcm_lib_default_mmap(struct snd_pcm_substream *substream,
> >                              struct vm_area_struct *area)
> > {
> >         area->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
> > #ifdef ARCH_HAS_DMA_MMAP_COHERENT
> >         if (!substream->ops->page &&
> >             substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
> >                 return dma_mmap_coherent(substream->dma_buffer.dev.dev,
> >                                          area,
> >                                          substream->runtime->dma_area,
> >                                          substream->runtime->dma_addr,
> >                                          area->vm_end - area->vm_start);
> > #elif defined(CONFIG_MIPS) && defined(CONFIG_DMA_NONCOHERENT)
> >         if (substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV &&
> >             !plat_device_is_coherent(substream->dma_buffer.dev.dev))
> >                 area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
> > #endif /* ARCH_HAS_DMA_MMAP_COHERENT */
> >         /* mmap with fault handler */
> >         area->vm_ops = &snd_pcm_vm_ops_data_fault;
> >         return 0;
> > }
> > EXPORT_SYMBOL_GPL(snd_pcm_lib_default_mmap);
> >
> > What's up here?
>
> Probably an easy solution here is to kill ARCH_HAS_DMA_MMAP_COHERENT and
> change the code to
>
>      #if defined(CONFIG_MIPS) && defined(CONFIG_DMA_NONCOHERENT)
> 	    if (substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV &&
> 		!plat_device_is_coherent(substream->dma_buffer.dev.dev))
> 		    area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
>      #else
> 	    if (!substream->ops->page &&
> 		substream->dma_buffer.dev.type == SNDRV_DMA_TYPE_DEV)
> 		    return dma_mmap_coherent(substream->dma_buffer.dev.dev,
> 					     area,
> 					     substream->runtime->dma_area,
> 					     substream->runtime->dma_addr,
> 					     area->vm_end - area->vm_start);
>      #endif
>
> but obviously I don't like the test for CONFIG_MIPS in generic code...

I think that the best way of handling it would be to move this code to MIPS
specific dma_mmap_coherent() implementation.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


