Return-path: <mchehab@localhost>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55673 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1GLNrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2011 09:47:00 -0400
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev
Date: Tue, 12 Jul 2011 15:46:44 +0200
Message-Id: <1310478404-9279-1-git-send-email-m.olbrich@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

These are necessary to prevent dead-locks e.g. if one thread waits
in dqbuf at one end and another tries to queue a buffer at the
other end.

Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/mem2mem_testdev.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mem2mem_testdev.c b/drivers/media/video/mem2mem_testdev.c
index b03d74e..effefa0 100644
--- a/drivers/media/video/mem2mem_testdev.c
+++ b/drivers/media/video/mem2mem_testdev.c
@@ -795,10 +795,24 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
 }
 
+static void m2mtest_wait_prepare(struct vb2_queue *q)
+{
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
+	m2mtest_unlock(ctx);
+}
+
+static void m2mtest_wait_finish(struct vb2_queue *q)
+{
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
+	m2mtest_lock(ctx);
+}
+
 static struct vb2_ops m2mtest_qops = {
 	.queue_setup	 = m2mtest_queue_setup,
 	.buf_prepare	 = m2mtest_buf_prepare,
 	.buf_queue	 = m2mtest_buf_queue,
+	.wait_prepare	 = m2mtest_wait_prepare,
+	.wait_finish	 = m2mtest_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
-- 
1.7.5.4

