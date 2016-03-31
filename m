Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:41946 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752504AbcCaM3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2016 08:29:50 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Richard Weinberger <richard@nod.at>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Vignesh R <vigneshr@ti.com>,
	linux-mm@kvack.org, Joerg Roedel <joro@8bytes.org>,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] mm: add is_highmem_addr() helper
Date: Thu, 31 Mar 2016 14:29:41 +0200
Message-Id: <1459427384-21374-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1459427384-21374-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an helper to check if a virtual address is in the highmem region.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/linux/highmem.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index bb3f329..13dff37 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -41,6 +41,14 @@ void kmap_flush_unused(void);
 
 struct page *kmap_to_page(void *addr);
 
+static inline bool is_highmem_addr(const void *x)
+{
+	unsigned long vaddr = (unsigned long)x;
+
+	return vaddr >=  PKMAP_BASE &&
+	       vaddr < ((PKMAP_BASE + LAST_PKMAP) * PAGE_SIZE);
+}
+
 #else /* CONFIG_HIGHMEM */
 
 static inline unsigned int nr_free_highpages(void) { return 0; }
@@ -50,6 +58,11 @@ static inline struct page *kmap_to_page(void *addr)
 	return virt_to_page(addr);
 }
 
+static inline bool is_highmem_addr(const void *x)
+{
+	return false;
+}
+
 #define totalhigh_pages 0UL
 
 #ifndef ARCH_HAS_KMAP
-- 
2.5.0

