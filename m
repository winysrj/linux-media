Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:51872 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab1DIBeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Apr 2011 21:34:37 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: V4L/ARM: videobuf-dma-contig no longer works on my ARM machine (was: [PATCH v3] SoC Camera: add driver for OMAP1 camera interface)
Date: Sat, 9 Apr 2011 03:33:39 +0200
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <201009301335.51643.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1103231056360.6836@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1103231056360.6836@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104090333.52312.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wendesday, 23 March 2011, at 11:00:06, Guennadi Liakhovetski wrote:
> 
> You might want to retest ams-delta with the camera on the current
> (next or git://linuxtv.org/media_tree.git staging/for_v2.6.39) kernel
> ...

Hi Guennadi,
With the patch I've just submitted to the linux-media list 
(http://www.spinics.net/lists/linux-media/msg31255.html), the 2.6.39-rc2 
OMAP1 camera driver still works for me as before, but only in SG mode. 
I'm no longer able to use it in CONTIG mode after videobuf-dma-contig.c 
has been changed with commit 35d9f510b67b10338161aba6229d4f55b4000f5b, 
"V4L: videobuf, don't use dma addr as physical", supposed to correct 
potential issues on IOMMU euqipped machines.

Since there were no actual problems reported before, I suppose the old 
code, which was passing to remap_pfn_range() a physical page number 
calculated from dma_alloc_coherent() privided dma_handle, worked 
correctly on all platforms actually using videobud-dma-config. Now, on 
my ARM machine, a completely different, then completely wrong physical 
address, calculated as virt_to_phys(dma_alloc_coherent()), is used 
instead of the dma_handle, which causes the machine to hang.

AFAICS, incompatibility of the new code with the ARM architecture has 
been already pointed out as a potential issue by Lauent Pinchart 
(http://www.spinics.net/lists/linux-media/msg29544.html), but the patch 
has been accepted regardless.

I suspect the problem may affect other ARM subarchitectures, not only 
OMAP1, but have no way to verify this. Anyone with a suitable hardware, 
can you please verify and report if your machine is affected or not?

I've tried to resolve the problem by conditionally (#ifdef CONFIG_ARM) 
replacing remap_pfn_range() with ARM specific dma_mmap_coherent(), but 
with not much success so far. While this still seems a possibly correct 
solution to me (see sound/core/pcm_native.c for an example, architecture 
independent driver code which already implements a similiar method), I 
found that the dma_mmap_coherent() does its job for me only with the 
first buffer, failing with the second one because of negative buffer 
size vs. available vma space comparison. It seems to me that there may 
be something wrong with vma->vm_pgoff handling, but I'm not sure if in 
the V4L videobuf, or in the ARM DMA, or in a yet another piece of code.

Not being able to work out a solution myself, other than reverting back 
to the old code for ARM, I hope someone can come out with a better idea.

Thanks,
Janusz
