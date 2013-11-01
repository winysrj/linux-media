Return-path: <linux-media-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:23696
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755917Ab3KALsl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Nov 2013 07:48:41 -0400
From: Nicolin Chen <b42378@freescale.com>
To: <akpm@linux-foundation.org>, <joe@perches.com>, <nsekhar@ti.com>,
	<khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
	<dan.j.williams@intel.com>, <vinod.koul@intel.com>,
	<m.chehab@samsung.com>, <hjk@hansjkoch.de>,
	<gregkh@linuxfoundation.org>, <perex@perex.cz>, <tiwai@suse.de>,
	<lgirdwood@gmail.com>, <broonie@kernel.org>,
	<rmk+kernel@arm.linux.org.uk>, <eric.y.miao@gmail.com>,
	<haojian.zhuang@gmail.com>
CC: <linux-kernel@vger.kernel.org>,
	<davinci-linux-open-source@linux.davincidsp.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<dmaengine@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<alsa-devel@alsa-project.org>
Subject: [PATCH][RESEND 2/8] ARM: davinci: use gen_pool_dma_alloc() to sram.c
Date: Fri, 1 Nov 2013 19:48:15 +0800
Message-ID: <9536ee2bbb1a8463ebb21068a750b61fa59900df.1383306365.git.b42378@freescale.com>
In-Reply-To: <cover.1383306365.git.b42378@freescale.com>
References: <cover.1383306365.git.b42378@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since gen_pool_dma_alloc() is introduced, we implement it to simplify code.

Signed-off-by: Nicolin Chen <b42378@freescale.com>
---
 arch/arm/mach-davinci/sram.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/arm/mach-davinci/sram.c b/arch/arm/mach-davinci/sram.c
index f18928b..8540ddd 100644
--- a/arch/arm/mach-davinci/sram.c
+++ b/arch/arm/mach-davinci/sram.c
@@ -25,7 +25,6 @@ struct gen_pool *sram_get_gen_pool(void)
 
 void *sram_alloc(size_t len, dma_addr_t *dma)
 {
-	unsigned long vaddr;
 	dma_addr_t dma_base = davinci_soc_info.sram_dma;
 
 	if (dma)
@@ -33,13 +32,7 @@ void *sram_alloc(size_t len, dma_addr_t *dma)
 	if (!sram_pool || (dma && !dma_base))
 		return NULL;
 
-	vaddr = gen_pool_alloc(sram_pool, len);
-	if (!vaddr)
-		return NULL;
-
-	if (dma)
-		*dma = gen_pool_virt_to_phys(sram_pool, vaddr);
-	return (void *)vaddr;
+	return gen_pool_dma_alloc(sram_pool, len, dma);
 
 }
 EXPORT_SYMBOL(sram_alloc);
-- 
1.8.4


