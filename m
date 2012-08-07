Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53310 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab2HGPWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2012 11:22:19 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: 'Hideki EIRAKU' <hdk@igel.co.jp>,
	'Russell King' <linux@arm.linux.org.uk>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Florian Tobias Schandinat' <FlorianSchandinat@gmx.de>,
	'Jaroslav Kysela' <perex@perex.cz>,
	'Takashi Iwai' <tiwai@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
	alsa-devel@alsa-project.org, 'Katsuya MATSUBARA' <matsu@igel.co.jp>
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
 <1344246924-32620-2-git-send-email-hdk@igel.co.jp>
In-reply-to: <1344246924-32620-2-git-send-email-hdk@igel.co.jp>
Subject: RE: [PATCH v3 1/4] ARM: dma-mapping: define ARCH_HAS_DMA_MMAP_COHERENT
Date: Tue, 07 Aug 2012 17:22:02 +0200
Message-id: <013301cd74b0$691eba60$3b5c2f20$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hideki,

On Monday, August 06, 2012 11:55 AM Hideki EIRAKU wrote:

> ARCH_HAS_DMA_MMAP_COHERENT indicates that there is dma_mmap_coherent() API
> in this architecture.  The name is already defined in PowerPC.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>
> ---
>  arch/arm/include/asm/dma-mapping.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index bbef15d..f41cd30 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -187,6 +187,7 @@ extern int arm_dma_mmap(struct device *dev, struct vm_area_struct *vma,
>  			struct dma_attrs *attrs);
> 
>  #define dma_mmap_coherent(d, v, c, h, s) dma_mmap_attrs(d, v, c, h, s, NULL)
> +#define ARCH_HAS_DMA_MMAP_COHERENT
> 
>  static inline int dma_mmap_attrs(struct device *dev, struct vm_area_struct *vma,
>  				  void *cpu_addr, dma_addr_t dma_addr,
> --
> 1.7.0.4

I will take this patch to my dma-mapping kernel tree, to the fixes branch.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


