Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54200 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932231AbcKVKUw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 05:20:52 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] vpdma: remove vpdma_enable_list_notify_irq()
Date: Tue, 22 Nov 2016 08:20:19 -0200
Message-Id: <239fc19d9a462b02d2b4f3a84cb83b637ad88513.1479810016.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Despite being exported, there's no prototype for it at the
headers, as warned by sparse:

Fixes this sparse warning:
	drivers/media/platform/ti-vpe/vpdma.c:1000:6: warning: no previous prototype for 'vpdma_enable_list_notify_irq' [-Wmissing-prototypes]
	 void vpdma_enable_list_notify_irq(struct vpdma_data *vpdma, int irq_num,
	      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Worse than that, it is not even used, as making it static it
would produce:

	drivers/media/platform/ti-vpe/vpdma.c:1000:13: warning: 'vpdma_enable_list_notify_irq' defined but not used [-Wunused-function]
	 static void vpdma_enable_list_notify_irq(struct vpdma_data *vpdma, int irq_num,
	             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

So, let's just get rid of the dead code. If needed in the future,
someone could re-add it.

Cc: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index c8f842fd7f75..13bfd7184160 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -996,22 +996,6 @@ void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
 }
 EXPORT_SYMBOL(vpdma_enable_list_complete_irq);
 
-/* set or clear the mask for list complete interrupt */
-void vpdma_enable_list_notify_irq(struct vpdma_data *vpdma, int irq_num,
-		int list_num, bool enable)
-{
-	u32 reg_addr = VPDMA_INT_LIST0_MASK + VPDMA_INTX_OFFSET * irq_num;
-	u32 val;
-
-	val = read_reg(vpdma, reg_addr);
-	if (enable)
-		val |= (1 << ((list_num * 2) + 1));
-	else
-		val &= ~(1 << ((list_num * 2) + 1));
-	write_reg(vpdma, reg_addr, val);
-}
-EXPORT_SYMBOL(vpdma_enable_list_notify_irq);
-
 /* get the LIST_STAT register */
 unsigned int vpdma_get_list_stat(struct vpdma_data *vpdma, int irq_num)
 {
-- 
2.9.3

