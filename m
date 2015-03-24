Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60126 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbbCXRbD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 13:31:03 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Peter Seiderer <ps.report@gmx.net>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 10/11] [media] coda: call SEQ_END when the first queue is stopped
Date: Tue, 24 Mar 2015 18:30:56 +0100
Message-Id: <1427218257-1507-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
References: <1427218257-1507-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This allows to stop and restart the output queue to start a new sequence
while keeping the capture queue running. Before, sequence end would only
be issued if both output and capture queue were stopped and the sequence
start issued when reenabling the output queue would fail.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 4441179..54c972f 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1339,6 +1339,9 @@ static void coda_stop_streaming(struct vb2_queue *q)
 	struct coda_ctx *ctx = vb2_get_drv_priv(q);
 	struct coda_dev *dev = ctx->dev;
 	struct vb2_buffer *buf;
+	bool stop;
+
+	stop = ctx->streamon_out && ctx->streamon_cap;
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
@@ -1363,7 +1366,7 @@ static void coda_stop_streaming(struct vb2_queue *q)
 			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
 	}
 
-	if (!ctx->streamon_out && !ctx->streamon_cap) {
+	if (stop) {
 		struct coda_buffer_meta *meta;
 
 		if (ctx->ops->seq_end_work) {
-- 
2.1.4

