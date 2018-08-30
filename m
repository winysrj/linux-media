Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38046 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbeH3VYO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 17:24:14 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [RFC 1/3] HACK: ARM: dma-mapping: Get writeback memory for non-consistent mappings
Date: Thu, 30 Aug 2018 14:20:28 -0300
Message-Id: <20180830172030.23344-2-ezequiel@collabora.com>
In-Reply-To: <20180830172030.23344-1-ezequiel@collabora.com>
References: <20180830172030.23344-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is obviously a hack.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 arch/arm/include/asm/pgtable.h | 3 +++
 arch/arm/mm/dma-mapping.c      | 9 ++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index a757401129f9..37ddd0d73434 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -122,6 +122,9 @@ extern pgprot_t		pgprot_s2_device;
 #define pgprot_writecombine(prot) \
 	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_BUFFERABLE)
 
+#define pgprot_writeback(prot) \
+	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_WRITEBACK)
+
 #define pgprot_stronglyordered(prot) \
 	__pgprot_modify(prot, L_PTE_MT_MASK, L_PTE_MT_UNCACHED)
 
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 66566472c153..11cca7bbb0a8 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -633,9 +633,12 @@ static void __free_from_contiguous(struct device *dev, struct page *page,
 
 static inline pgprot_t __get_dma_pgprot(unsigned long attrs, pgprot_t prot)
 {
-	prot = (attrs & DMA_ATTR_WRITE_COMBINE) ?
-			pgprot_writecombine(prot) :
-			pgprot_dmacoherent(prot);
+	if (attrs & DMA_ATTR_WRITE_COMBINE)
+		prot = pgprot_writecombine(prot);
+	else if (attrs & DMA_ATTR_NON_CONSISTENT)
+		prot = pgprot_writeback(prot);
+	else
+		prot = pgprot_dmacoherent(prot);
 	return prot;
 }
 
-- 
2.18.0
