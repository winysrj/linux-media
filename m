Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:37535 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbcBVTJb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2016 14:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH 4/9] [media] ivtv: steal could be NULL
Date: Mon, 22 Feb 2016 16:09:18 -0300
Message-Id: <69f2119e511302ff5a344f595c49271ef31b11e7.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
In-Reply-To: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
References: <4340d9c3cc750cc30918b5de6bf16de2722f7d1b.1456167652.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ivtv_flush_queues() calls ivtv_queue_move() with steal == NULL.
However, part of the code assumes that steal could be not null, as
pointed by smatch:
	drivers/media/pci/ivtv/ivtv-queue.c:145 ivtv_queue_move() error: we previously assumed 'steal' could be null (see line 138)

This has the potential of causing an OOPS when the queue is
flushed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/pci/ivtv/ivtv-queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/ivtv/ivtv-queue.c b/drivers/media/pci/ivtv/ivtv-queue.c
index 7fde36e6d227..2128c2a8d7fd 100644
--- a/drivers/media/pci/ivtv/ivtv-queue.c
+++ b/drivers/media/pci/ivtv/ivtv-queue.c
@@ -141,7 +141,7 @@ int ivtv_queue_move(struct ivtv_stream *s, struct ivtv_queue *from, struct ivtv_
 		spin_unlock_irqrestore(&s->qlock, flags);
 		return -ENOMEM;
 	}
-	while (bytes_available < needed_bytes) {
+	while (steal && bytes_available < needed_bytes) {
 		struct ivtv_buffer *buf = list_entry(steal->list.prev, struct ivtv_buffer, list);
 		u16 dma_xfer_cnt = buf->dma_xfer_cnt;
 
-- 
2.5.0

