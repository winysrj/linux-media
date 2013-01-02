Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42855 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3ABOWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 09:22:42 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Message-id: <50E442A7.3010002@samsung.com>
Date: Wed, 02 Jan 2013 15:22:31 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH/RFC 4/4] common: dma-mapping: Move dma_common_*() to
 <linux/dma-mapping.h>
References: <CAMuHMdVPBUzN8fsNHFzrEqev9BsvVCVR2fWySCOecjVA-J1qjg@mail.gmail.com>
 <1356722614-18224-5-git-send-email-geert@linux-m68k.org>
In-reply-to: <1356722614-18224-5-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 12/28/2012 8:23 PM, Geert Uytterhoeven wrote:
> dma_common_mmap() and dma_common_get_sgtable() are defined in
> drivers/base/dma-mapping.c, and always compiled if CONFIG_HAS_DMA=y.
>
> However, their forward declarations and the inline functions defined on top
> of them (dma_mmap_attrs(), dma_mmap_coherent(), dma_mmap_writecombine(),
> dma_get_sgtable_attrs()), dma_get_sgtable()) are in
> <asm-generic/dma-mapping-common.h>, which is not included by all
> architectures supporting CONFIG_HAS_DMA=y.  There exist no alternative
> implementations.
>
> Hence for e.g. m68k allmodconfig, I get:
>
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_mmap’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:204: error: implicit declaration of function ‘dma_mmap_coherent’
> drivers/media/v4l2-core/videobuf2-dma-contig.c: In function ‘vb2_dc_get_base_sgt’:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:387: error: implicit declaration of function ‘dma_get_sgtable’
>
> To fix this
>    - Move the forward declarations and inline definitions to
>      <linux/dma-mapping.h>, so all CONFIG_HAS_DMA=y architectures can use
>      them,
>    - Replace the hard "BUG_ON(!ops)" checks for dma_map_ops by soft checks,
>      so architectures can fall back to the common code by returning NULL
>      from their get_dma_ops(). Note that there are no "BUG_ON(!ops)" checks
>      in other functions in <asm-generic/dma-mapping-common.h>,
>    - Make "struct dma_map_ops *ops" const while we're at it.

I think that more appropriate way of handling it is to avoid dma_map_ops 
based
calls (those archs probably have some reasons why they don't use it at 
all) and
provide static inline stubs which call dma_common_mmap and 
dma_common_get_sgtable.

It is definitely my fault that I missed the case of non-dma-map-ops 
based archs
while I was adding support for dma_mmap_coherent and dma_get_sgt calls...

 > (snipped)

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


