Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 07/35] [media] ti-vpe: use %pad for dma address
Date: Tue, 26 Aug 2014 18:54:43 -0300
Message-Id: <1409090111-8290-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   drivers/media/platform/ti-vpe/vpdma.c: In function 'dump_dtd':
   include/linux/dynamic_debug.h:64:16: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t' [-Wformat=]
     static struct _ddebug  __aligned(8)   \
                   ^
   include/linux/dynamic_debug.h:76:2: note: in expansion of macro 'DEFINE_DYNAMIC_DEBUG_METADATA'
     DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);  \
     ^
   include/linux/printk.h:263:2: note: in expansion of macro 'dynamic_pr_debug'
     dynamic_pr_debug(fmt, ##__VA_ARGS__)
     ^
>> drivers/media/platform/ti-vpe/vpdma.c:587:2: note: in expansion of macro 'pr_debug'
     pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
     ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index a51a01359805..6121a0b3c754 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -584,7 +584,7 @@ static void dump_dtd(struct vpdma_dtd *dtd)
 		pr_debug("word1: line_length = %d, xfer_height = %d\n",
 			dtd_get_line_length(dtd), dtd_get_xfer_height(dtd));
 
-	pr_debug("word2: start_addr = 0x%08x\n", dtd->start_addr);
+	pr_debug("word2: start_addr = %pad\n", &dtd->start_addr);
 
 	pr_debug("word3: pkt_type = %d, mode = %d, dir = %d, chan = %d, "
 		"pri = %d, next_chan = %d\n", dtd_get_pkt_type(dtd),
-- 
1.9.3

