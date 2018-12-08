Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20483C67839
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBABE2146D
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qjNmqOWG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBABE2146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbeLHRl2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:41:28 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbeLHRl1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:41:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SjF2REwETDF6UoymaDbdiFMUDCSX6A/ZjIR2r7YToLU=; b=qjNmqOWGQOA4xce8nJZhyESMy1
        2LDsn9cvQY77oc+TyILtl9eV31cmCn9eY8jVBBpxnWOz/YITorrQ3vtd716z+QJBZ/bOYDJgyZLFH
        xzqNHXHreqqEIbr+mLW/46+Btsf5gLjH8XCKqScePipkb7jEbKLAXIx/K45cvaZBVlcFKUOv9iVa4
        yOcAXFPErpYfgwG6s/2X5ty7oracc9Hzw+DTaOu+Xa5ZjC5ouIreI6dgjWqUri6mcLw2CK3ruTHRS
        XIjAQi6nvaCLNBs31CLTMcvFNI16r38BQdc7aipFQ1mgKWXDxFzfH28D35QthSdlaPbvhD0+MI9LI
        MBCUrx1w==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgbP-0000bG-41; Sat, 08 Dec 2018 17:41:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     iommu@lists.linux-foundation.org
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-snps-arc@lists.infradead.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, sparclinux@vger.kernel.org,
        openrisc@lists.librecores.org, linux-parisc@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: [PATCH 5/6] sparc: move the leon PCI memory space comment to <asm/leon.h>
Date:   Sat,  8 Dec 2018 09:41:14 -0800
Message-Id: <20181208174115.16237-6-hch@lst.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181208174115.16237-1-hch@lst.de>
References: <20181208174115.16237-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

It has nothing to do with the content of the pci.h header.

Suggested by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/sparc/include/asm/leon.h   | 9 +++++++++
 arch/sparc/include/asm/pci_32.h | 9 ---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/leon.h b/arch/sparc/include/asm/leon.h
index c68bb5b76e3d..77ea406ff9df 100644
--- a/arch/sparc/include/asm/leon.h
+++ b/arch/sparc/include/asm/leon.h
@@ -255,4 +255,13 @@ extern int leon_ipi_irq;
 #define _pfn_valid(pfn)	 ((pfn < last_valid_pfn) && (pfn >= PFN(phys_base)))
 #define _SRMMU_PTE_PMASK_LEON 0xffffffff
 
+/*
+ * On LEON PCI Memory space is mapped 1:1 with physical address space.
+ *
+ * I/O space is located at low 64Kbytes in PCI I/O space. The I/O addresses
+ * are converted into CPU addresses to virtual addresses that are mapped with
+ * MMU to the PCI Host PCI I/O space window which are translated to the low
+ * 64Kbytes by the Host controller.
+ */
+
 #endif
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
index cfc0ee9476c6..a475380ea108 100644
--- a/arch/sparc/include/asm/pci_32.h
+++ b/arch/sparc/include/asm/pci_32.h
@@ -23,15 +23,6 @@
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 #else
-/*
- * On LEON PCI Memory space is mapped 1:1 with physical address space.
- *
- * I/O space is located at low 64Kbytes in PCI I/O space. The I/O addresses
- * are converted into CPU addresses to virtual addresses that are mapped with
- * MMU to the PCI Host PCI I/O space window which are translated to the low
- * 64Kbytes by the Host controller.
- */
-
 static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 {
 	return PCI_IRQ_NONE;
-- 
2.19.2

