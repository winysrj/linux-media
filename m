Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbbLWRv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2015 12:51:57 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [media] timblogiw: protect desc
Date: Wed, 23 Dec 2015 15:51:26 -0200
Message-Id: <acc4439ff9d57b4e233d70415e70e37a85c695a5.1450893079.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As sparse complains:
	drivers/media/platform/timblogiw.c:562:22: warning: context imbalance in 'buffer_queue' - unexpected unlock

there's something weird at the logic there. The semaphore seems
to be protecting changes at the desc struct, however, the
callback logic is not protected.

Compile-tested only.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/platform/timblogiw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 113c9f3c0b3e..a5d2607cc396 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -566,8 +566,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	desc = dmaengine_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
 		DMA_PREP_INTERRUPT);
+	spin_lock_irq(&fh->queue_lock);
 	if (!desc) {
-		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
 		vb->state = VIDEOBUF_PREPARED;
 		return;
@@ -576,8 +576,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	desc->callback_param = buf;
 	desc->callback = timblogiw_dma_cb;
 
+	spin_unlock_irq(&fh->queue_lock);
 	buf->cookie = desc->tx_submit(desc);
-
 	spin_lock_irq(&fh->queue_lock);
 }
 
-- 
2.5.0

