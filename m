Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4925 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbaA3OwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 09:52:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 8/9] vivi: add support for reinit_streaming
Date: Thu, 30 Jan 2014 15:51:30 +0100
Message-Id: <1391093491-23077-9-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
References: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This ensures that the driver's buffer list is always initialized, also
if start_streaming returns an error.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/vivi.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 2d4e73b..c9bf8d3 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -793,20 +793,6 @@ static void vivi_stop_generating(struct vivi_dev *dev)
 		kthread_stop(dma_q->kthread);
 		dma_q->kthread = NULL;
 	}
-
-	/*
-	 * Typical driver might need to wait here until dma engine stops.
-	 * In this case we can abort imiedetly, so it's just a noop.
-	 */
-
-	/* Release all active buffers */
-	while (!list_empty(&dma_q->active)) {
-		struct vivi_buffer *buf;
-		buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
-		list_del(&buf->list);
-		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
-		dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
-	}
 }
 /* ------------------------------------------------------------------
 	Videobuf operations
@@ -914,6 +900,13 @@ static int stop_streaming(struct vb2_queue *vq)
 	return 0;
 }
 
+static void reinit_streaming(struct vb2_queue *vq)
+{
+	struct vivi_dev *dev = vb2_get_drv_priv(vq);
+
+	INIT_LIST_HEAD(&dev->vidq.active);
+}
+
 static void vivi_lock(struct vb2_queue *vq)
 {
 	struct vivi_dev *dev = vb2_get_drv_priv(vq);
@@ -933,6 +926,7 @@ static const struct vb2_ops vivi_video_qops = {
 	.buf_queue		= buffer_queue,
 	.start_streaming	= start_streaming,
 	.stop_streaming		= stop_streaming,
+	.reinit_streaming	= reinit_streaming,
 	.wait_prepare		= vivi_unlock,
 	.wait_finish		= vivi_lock,
 };
-- 
1.8.5.2

