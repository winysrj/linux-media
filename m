Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56545 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab3AKP3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 10:29:50 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGG00CUNWDOO910@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:48 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MGG00G15WDC1520@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jan 2013 00:29:48 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	a.hajda@samsung.com, Kamil Debski <k.debski@samsung.com>,
	Kyngmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/3] s5p-mfc: Add support for EOS command and EOS event in
 video decoder
Date: Fri, 11 Jan 2013 16:29:33 +0100
Message-id: <1357918174-4651-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1357918174-4651-1-git-send-email-k.debski@samsung.com>
References: <1357918174-4651-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for V4L2_DEC_CMD_STOP command which will instruct MFC device
to finish decoding and release all remaining frames kept for reference to
the user. After dequeueing last decoded frame the driver will generate an
V4L2_EVENT_EOS event.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyngmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |   76 +++++++++++++++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    9 +++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   10 ++-
 4 files changed, 92 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index f4cfa6d..a527f85 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -386,6 +386,8 @@ static void s5p_mfc_handle_frame(struct s5p_mfc_ctx *ctx,
 		} else {
 			mfc_debug(2, "MFC needs next buffer\n");
 			ctx->consumed_stream = 0;
+			if (src_buf->flags & MFC_BUF_FLAG_EOS)
+				ctx->state = MFCINST_FINISHING;
 			list_del(&src_buf->list);
 			ctx->src_queue_cnt--;
 			if (s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) > 0)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 4582473..4af53bd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -22,6 +22,7 @@
 #include <linux/videodev2.h>
 #include <linux/workqueue.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf2-core.h>
 #include "s5p_mfc_common.h"
 #include "s5p_mfc_debug.h"
@@ -623,17 +624,27 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 /* Dequeue a buffer */
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
+	const struct v4l2_event ev = {
+		.type = V4L2_EVENT_EOS
+	};
 	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	int ret;
 
 	if (ctx->state == MFCINST_ERROR) {
 		mfc_err("Call on DQBUF after unrecoverable error\n");
 		return -EIO;
 	}
 	if (buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
-	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
-	return -EINVAL;
+		ret = vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
+	else if (buf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
+		if (ret == 0 && ctx->state == MFCINST_FINISHED &&
+				list_empty(&ctx->vq_dst.done_list))
+			v4l2_event_queue_fh(&ctx->fh, &ev);
+	} else {
+		ret = -EINVAL;
+	}
+	return ret;
 }
 
 /* Export DMA buffer */
@@ -809,6 +820,59 @@ static int vidioc_g_crop(struct file *file, void *priv,
 	return 0;
 }
 
+int vidioc_decoder_cmd(struct file *file, void *priv,
+						struct v4l2_decoder_cmd *cmd)
+{
+	struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
+	struct s5p_mfc_dev *dev = ctx->dev;
+	struct s5p_mfc_buf *buf;
+	unsigned long flags;
+
+	switch (cmd->cmd) {
+	case V4L2_ENC_CMD_STOP:
+		if (cmd->flags != 0)
+			return -EINVAL;
+
+		if (!ctx->vq_src.streaming)
+			return -EINVAL;
+
+		spin_lock_irqsave(&dev->irqlock, flags);
+		if (list_empty(&ctx->src_queue)) {
+			mfc_err("EOS: empty src queue, entering finishing state");
+			ctx->state = MFCINST_FINISHING;
+			if (s5p_mfc_ctx_ready(ctx))
+				set_work_bit_irqsave(ctx);
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+			s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
+		} else {
+			mfc_err("EOS: marking last buffer of stream");
+			buf = list_entry(ctx->src_queue.prev,
+						struct s5p_mfc_buf, list);
+			if (buf->flags & MFC_BUF_FLAG_USED)
+				ctx->state = MFCINST_FINISHING;
+			else
+				buf->flags |= MFC_BUF_FLAG_EOS;
+			spin_unlock_irqrestore(&dev->irqlock, flags);
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int vidioc_subscribe_event(struct v4l2_fh *fh,
+				const struct  v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+	default:
+		return -EINVAL;
+	}
+}
+
+
 /* v4l2_ioctl_ops */
 static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_querycap = vidioc_querycap,
@@ -830,6 +894,9 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
 	.vidioc_g_crop = vidioc_g_crop,
+	.vidioc_decoder_cmd = vidioc_decoder_cmd,
+	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static int s5p_mfc_queue_setup(struct vb2_queue *vq,
@@ -1147,3 +1214,4 @@ void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
 	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
 			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
 }
+
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index f61dba8..2d2d6ef 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -1187,6 +1187,15 @@ static int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx, int last_frame)
 	unsigned long flags;
 	unsigned int index;
 
+	if (ctx->state == MFCINST_FINISHING) {
+		last_frame = MFC_DEC_LAST_FRAME;
+		s5p_mfc_set_dec_stream_buffer_v5(ctx, 0, 0, 0);
+		dev->curr_ctx = ctx->num;
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_decode_one_frame_v5(ctx, last_frame);
+		return 0;
+	}
+
 	spin_lock_irqsave(&dev->irqlock, flags);
 	/* Frames are being decoded */
 	if (list_empty(&ctx->src_queue)) {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index beb6dba..c5575dc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1362,8 +1362,16 @@ static inline int s5p_mfc_run_dec_frame(struct s5p_mfc_ctx *ctx)
 	unsigned long flags;
 	int last_frame = 0;
 
-	spin_lock_irqsave(&dev->irqlock, flags);
+	if (ctx->state == MFCINST_FINISHING) {
+		last_frame = MFC_DEC_LAST_FRAME;
+		s5p_mfc_set_dec_stream_buffer_v6(ctx, 0, 0, 0);
+		dev->curr_ctx = ctx->num;
+		s5p_mfc_clean_ctx_int_flags(ctx);
+		s5p_mfc_decode_one_frame_v6(ctx, last_frame);
+		return 0;
+	}
 
+	spin_lock_irqsave(&dev->irqlock, flags);
 	/* Frames are being decoded */
 	if (list_empty(&ctx->src_queue)) {
 		mfc_debug(2, "No src buffers.\n");
-- 
1.7.9.5

