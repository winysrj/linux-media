Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2562 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbaBYKQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/13] mem2mem_testdev: fix field, sequence and time copying
Date: Tue, 25 Feb 2014 11:16:02 +0100
Message-Id: <1393323363-30058-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- Set the sequence counters correctly.
- Copy timestamps, timecode, relevant buffer flags and field from
  the received buffer to the outgoing buffer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 2ea27cc..4a25940 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -112,6 +112,7 @@ struct m2mtest_q_data {
 	unsigned int		width;
 	unsigned int		height;
 	unsigned int		sizeimage;
+	unsigned int		sequence;
 	struct m2mtest_fmt	*fmt;
 };
 
@@ -234,9 +235,20 @@ static int device_process(struct m2mtest_ctx *ctx,
 	bytes_left = bytesperline - tile_w * MEM2MEM_NUM_TILES;
 	w = 0;
 
+	out_vb->v4l2_buf.sequence = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
+	in_vb->v4l2_buf.sequence = q_data->sequence++;
 	memcpy(&out_vb->v4l2_buf.timestamp,
 			&in_vb->v4l2_buf.timestamp,
 			sizeof(struct timeval));
+	if (in_vb->v4l2_buf.flags & V4L2_BUF_FLAG_TIMECODE)
+		memcpy(&out_vb->v4l2_buf.timecode, &in_vb->v4l2_buf.timecode,
+			sizeof(struct v4l2_timecode));
+	out_vb->v4l2_buf.field = in_vb->v4l2_buf.field;
+	out_vb->v4l2_buf.flags = in_vb->v4l2_buf.flags &
+		(V4L2_BUF_FLAG_TIMECODE |
+		 V4L2_BUF_FLAG_KEYFRAME |
+		 V4L2_BUF_FLAG_PFRAME |
+		 V4L2_BUF_FLAG_BFRAME);
 
 	switch (ctx->mode) {
 	case MEM2MEM_HFLIP | MEM2MEM_VFLIP:
@@ -762,9 +774,19 @@ static int m2mtest_buf_prepare(struct vb2_buffer *vb)
 static void m2mtest_buf_queue(struct vb2_buffer *vb)
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
+static int m2mtest_start_streaming(struct vb2_queue *q, unsigned count)
+{
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
+	struct m2mtest_q_data *q_data = get_q_data(ctx, q->type);
+
+	q_data->sequence = 0;
+	return 0;
+}
+
 static void m2mtest_stop_streaming(struct vb2_queue *q)
 {
 	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
@@ -788,6 +810,7 @@ static struct vb2_ops m2mtest_qops = {
 	.queue_setup	 = m2mtest_queue_setup,
 	.buf_prepare	 = m2mtest_buf_prepare,
 	.buf_queue	 = m2mtest_buf_queue,
+	.start_streaming = m2mtest_start_streaming,
 	.stop_streaming  = m2mtest_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
-- 
1.9.0

