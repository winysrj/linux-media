Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62222 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab2INIt2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 04:49:28 -0400
Received: by wgbdr13 with SMTP id dr13so3335682wgb.1
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 01:49:27 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:49:27 +0200
Message-ID: <CACKLOr1_KqsKovcpV06_nAzVKRGAf3z17S-XfNBw8d3BbTshZg@mail.gmail.com>
Subject: Alignment problems: arm_memblock_steal() + dma_declare_coherent_memory()
From: javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
we use arm_memblock_steal() + dma_declare_coherent_memory() in order
to reserve son contiguous video memory in our platform:
http://git.linuxtv.org/media_tree.git/blob/refs/heads/staging/for_v3.7:/arch/arm/mach-imx/mach-imx27_visstrim_m10.c

We've noticed that some restrictive alignment constraints are being
applied. For example, for coda driver, the following allocations are
made:

coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 557056
bytes, out of 8388608 (vaddr = 0xc6000000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 65536
bytes, out of 8388608 (vaddr = 0xc6100000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 10240
bytes, out of 8388608 (vaddr = 0xc6110000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 622080
bytes, out of 8388608 (vaddr = 0xc6200000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 622080
bytes, out of 8388608 (vaddr = 0xc6300000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 622080
bytes, out of 8388608 (vaddr = 0xc6400000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 589824
bytes, out of 8388608 (vaddr = 0xc6500000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 589824
bytes, out of 8388608 (vaddr = 0xc6600000) PAGE_SHIFT = 0xc
coda coda-imx27.0: dma_alloc_from_coherent: try to allocate 622080
bytes, out of 8388608 (vaddr = 0xc6700000) PAGE_SHIFT = 0xc

If we take a look at the size of each allocation and the different
vaddr values we find that the alignment is 0x100000 = 1MB for values
like 622080 byte size. Why is that?
A lot of memory is being wasted this way and our HW does not have such
1MB alignment requirements.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
