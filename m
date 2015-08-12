Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbbHLHIz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 03:08:55 -0400
From: Christoph Hellwig <hch@lst.de>
To: torvalds@linux-foundation.org, axboe@kernel.dk
Cc: dan.j.williams@intel.com, vgupta@synopsys.com,
	hskinnemoen@gmail.com, egtvedt@samfundet.no, realmz6@gmail.com,
	dhowells@redhat.com, monstr@monstr.eu, x86@kernel.org,
	dwmw2@infradead.org, alex.williamson@redhat.com,
	grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-alpha@vger.kernel.org,
	linux-ia64@vger.kernel.org, linux-metag@vger.kernel.org,
	linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-xtensa@linux-xtensa.org,
	linux-nvdimm@ml01.01.org, linux-media@vger.kernel.org
Subject: [PATCH 01/31] scatterlist: add sg_pfn and sg_has_page helpers
Date: Wed, 12 Aug 2015 09:05:20 +0200
Message-Id: <1439363150-8661-2-git-send-email-hch@lst.de>
In-Reply-To: <1439363150-8661-1-git-send-email-hch@lst.de>
References: <1439363150-8661-1-git-send-email-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/scatterlist.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 9b1ef0c..b1056bf 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -230,6 +230,16 @@ static inline dma_addr_t sg_phys(struct scatterlist *sg)
 	return page_to_phys(sg_page(sg)) + sg->offset;
 }
 
+static inline unsigned long sg_pfn(struct scatterlist *sg)
+{
+	return page_to_pfn(sg_page(sg));
+}
+
+static inline bool sg_has_page(struct scatterlist *sg)
+{
+	return true;
+}
+
 /**
  * sg_virt - Return virtual address of an sg entry
  * @sg:      SG entry
-- 
1.9.1

