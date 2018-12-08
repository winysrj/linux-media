Return-Path: <SRS0=LTSq=OR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ED18C6783C
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55FCF208E7
	for <linux-media@archiver.kernel.org>; Sat,  8 Dec 2018 17:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="iDIE0XNL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55FCF208E7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbeLHRl3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 8 Dec 2018 12:41:29 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbeLHRl2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 8 Dec 2018 12:41:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LeHVcCPe1tBdnY4eh3FwSo9lQX0oX2hTPrP1Ho6djDw=; b=iDIE0XNLPEPM7Sh6NQFZXnfV7W
        wqqZbRkTJewyZxA5uolflVZFce3TsojWKgqHsgkPmq2QPwA0ZcTFM60Ozz/6nwO5RGBPROzEovCOf
        dFknTHSziWsu3v8LPoIItxnqNNoCncERHgi5O3Zd98aH7lkGsjHLEQToEc4e0IhAPTLof59wwgR0E
        oZv4CVXBc6cvwUOEFJLxwa2k6bIdRMFGZwBTOFw58qymzf1nGUqcH4LmEZqqg7RoGWpCz6j6Wv9b6
        EMb+WVMZ39yayTdrBxXq+SDsK8VLyR7Sya+NQSbEOf9D+bTQzBDvv1wv+kU4nccVOJefQywXEk8Uu
        F6nRuaUA==;
Received: from [184.48.100.57] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gVgbP-0000bv-Lf; Sat, 08 Dec 2018 17:41:19 +0000
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
Subject: [PATCH 6/6] sparc: merge 32-bit and 64-bit version of pci.h
Date:   Sat,  8 Dec 2018 09:41:15 -0800
Message-Id: <20181208174115.16237-7-hch@lst.de>
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

There are enough common defintions that a single header seems nicer.

Also drop the pointless <linux/dma-mapping.h> include.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/sparc/include/asm/pci.h    | 53 ++++++++++++++++++++++++++++++---
 arch/sparc/include/asm/pci_32.h | 32 --------------------
 arch/sparc/include/asm/pci_64.h | 52 --------------------------------
 3 files changed, 49 insertions(+), 88 deletions(-)
 delete mode 100644 arch/sparc/include/asm/pci_32.h
 delete mode 100644 arch/sparc/include/asm/pci_64.h

diff --git a/arch/sparc/include/asm/pci.h b/arch/sparc/include/asm/pci.h
index cad79a6ce0e4..cfec79bb1831 100644
--- a/arch/sparc/include/asm/pci.h
+++ b/arch/sparc/include/asm/pci.h
@@ -1,9 +1,54 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef ___ASM_SPARC_PCI_H
 #define ___ASM_SPARC_PCI_H
-#if defined(__sparc__) && defined(__arch64__)
-#include <asm/pci_64.h>
+
+
+/* Can be used to override the logic in pci_scan_bus for skipping
+ * already-configured bus numbers - to be used for buggy BIOSes
+ * or architectures with incomplete PCI setup by the loader.
+ */
+#define pcibios_assign_all_busses()	0
+
+#define PCIBIOS_MIN_IO		0UL
+#define PCIBIOS_MIN_MEM		0UL
+
+#define PCI_IRQ_NONE		0xffffffff
+
+
+#ifdef CONFIG_SPARC64
+
+/* PCI IOMMU mapping bypass support. */
+
+/* PCI 64-bit addressing works for all slots on all controller
+ * types on sparc64.  However, it requires that the device
+ * can drive enough of the 64 bits.
+ */
+#define PCI64_REQUIRED_MASK	(~(u64)0)
+#define PCI64_ADDR_BASE		0xfffc000000000000UL
+
+/* Return the index of the PCI controller for device PDEV. */
+int pci_domain_nr(struct pci_bus *bus);
+static inline int pci_proc_domain(struct pci_bus *bus)
+{
+	return 1;
+}
+
+/* Platform support for /proc/bus/pci/X/Y mmap()s. */
+#define HAVE_PCI_MMAP
+#define arch_can_pci_mmap_io()	1
+#define HAVE_ARCH_PCI_GET_UNMAPPED_AREA
+#define get_pci_unmapped_area get_fb_unmapped_area
+
+#define HAVE_ARCH_PCI_RESOURCE_TO_USER
+#endif /* CONFIG_SPARC64 */
+
+#if defined(CONFIG_SPARC64) || defined(CONFIG_LEON_PCI)
+static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
+{
+	return PCI_IRQ_NONE;
+}
 #else
-#include <asm/pci_32.h>
-#endif
+#include <asm-generic/pci.h>
 #endif
+
+#endif /* ___ASM_SPARC_PCI_H */
diff --git a/arch/sparc/include/asm/pci_32.h b/arch/sparc/include/asm/pci_32.h
deleted file mode 100644
index a475380ea108..000000000000
--- a/arch/sparc/include/asm/pci_32.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __SPARC_PCI_H
-#define __SPARC_PCI_H
-
-#ifdef __KERNEL__
-
-#include <linux/dma-mapping.h>
-
-/* Can be used to override the logic in pci_scan_bus for skipping
- * already-configured bus numbers - to be used for buggy BIOSes
- * or architectures with incomplete PCI setup by the loader.
- */
-#define pcibios_assign_all_busses()	0
-
-#define PCIBIOS_MIN_IO		0UL
-#define PCIBIOS_MIN_MEM		0UL
-
-#define PCI_IRQ_NONE		0xffffffff
-
-#endif /* __KERNEL__ */
-
-#ifndef CONFIG_LEON_PCI
-/* generic pci stuff */
-#include <asm-generic/pci.h>
-#else
-static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
-{
-	return PCI_IRQ_NONE;
-}
-#endif
-
-#endif /* __SPARC_PCI_H */
diff --git a/arch/sparc/include/asm/pci_64.h b/arch/sparc/include/asm/pci_64.h
deleted file mode 100644
index fac77813402c..000000000000
--- a/arch/sparc/include/asm/pci_64.h
+++ /dev/null
@@ -1,52 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __SPARC64_PCI_H
-#define __SPARC64_PCI_H
-
-#ifdef __KERNEL__
-
-#include <linux/dma-mapping.h>
-
-/* Can be used to override the logic in pci_scan_bus for skipping
- * already-configured bus numbers - to be used for buggy BIOSes
- * or architectures with incomplete PCI setup by the loader.
- */
-#define pcibios_assign_all_busses()	0
-
-#define PCIBIOS_MIN_IO		0UL
-#define PCIBIOS_MIN_MEM		0UL
-
-#define PCI_IRQ_NONE		0xffffffff
-
-/* PCI IOMMU mapping bypass support. */
-
-/* PCI 64-bit addressing works for all slots on all controller
- * types on sparc64.  However, it requires that the device
- * can drive enough of the 64 bits.
- */
-#define PCI64_REQUIRED_MASK	(~(u64)0)
-#define PCI64_ADDR_BASE		0xfffc000000000000UL
-
-/* Return the index of the PCI controller for device PDEV. */
-
-int pci_domain_nr(struct pci_bus *bus);
-static inline int pci_proc_domain(struct pci_bus *bus)
-{
-	return 1;
-}
-
-/* Platform support for /proc/bus/pci/X/Y mmap()s. */
-
-#define HAVE_PCI_MMAP
-#define arch_can_pci_mmap_io()	1
-#define HAVE_ARCH_PCI_GET_UNMAPPED_AREA
-#define get_pci_unmapped_area get_fb_unmapped_area
-
-static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
-{
-	return PCI_IRQ_NONE;
-}
-
-#define HAVE_ARCH_PCI_RESOURCE_TO_USER
-#endif /* __KERNEL__ */
-
-#endif /* __SPARC64_PCI_H */
-- 
2.19.2

