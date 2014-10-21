Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59260 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbaJUQZ4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 12:25:56 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: re-queue buffers if start_streaming fails
Date: Tue, 21 Oct 2014 18:25:52 +0200
Message-Id: <1413908752-11041-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch b906352c2338 ([media] coda: dequeue buffers if start_streaming fails)
incorrectly marked buffers as DEQUEUED in case of start_streaming failure, when
in fact they should be set to QUEUED. The videobuf2 core warns about this.

Reported-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index ced4760..23ace447 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1093,10 +1093,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 err:
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
 		while ((buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx)))
-			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
 	} else {
 		while ((buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx)))
-			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_DEQUEUED);
+			v4l2_m2m_buf_done(buf, VB2_BUF_STATE_QUEUED);
 	}
 	return ret;
 }
-- 
2.1.1

