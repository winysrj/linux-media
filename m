Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbaHZVzS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 17:55:18 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 08/35] [media] ti-vpe: shut up a casting warning message
Date: Tue, 26 Aug 2014 18:54:44 -0300
Message-Id: <1409090111-8290-9-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
References: <1409090111-8290-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

   drivers/media/platform/ti-vpe/vpdma.c: In function 'vpdma_alloc_desc_buf':
>> drivers/media/platform/ti-vpe/vpdma.c:332:10: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
             ^

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 6121a0b3c754..684ba19bbedd 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -329,7 +329,7 @@ int vpdma_alloc_desc_buf(struct vpdma_buf *buf, size_t size)
 	if (!buf->addr)
 		return -ENOMEM;
 
-	WARN_ON((u32) buf->addr & VPDMA_DESC_ALIGN);
+	WARN_ON(((u32) buf->addr & VPDMA_DESC_ALIGN) != 0);
 
 	return 0;
 }
-- 
1.9.3

