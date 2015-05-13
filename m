Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60869 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466AbbEMMwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 May 2015 08:52:47 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH] dma-mapping: Use tab instead of spaces for indenting.
Date: Wed, 13 May 2015 09:52:37 -0300
Message-Id: <968e74b3b62561c249c8c628003e7043b98baece.1431521547.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I wouldn't mind about this, if it won't be caused lots of smatch
warnings (one for each file that includes this header)
when the media drivers are compiled:

./arch/x86/include/asm/dma-mapping.h:125 dma_alloc_coherent_gfp_flags() warn: inconsistent indenting

That makes harder to identify real troubles pointed by smatch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 808dae63eeea..d6e6da39d75c 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -122,7 +122,7 @@ static inline gfp_t dma_alloc_coherent_gfp_flags(struct device *dev, gfp_t gfp)
 	if (dma_mask <= DMA_BIT_MASK(32) && !(gfp & GFP_DMA))
 		gfp |= GFP_DMA32;
 #endif
-       return gfp;
+	return gfp;
 }
 
 #define dma_alloc_coherent(d,s,h,f)	dma_alloc_attrs(d,s,h,f,NULL)
-- 
2.1.0

