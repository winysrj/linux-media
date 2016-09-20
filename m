Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52555 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754765AbcITOeX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 10:34:23 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 7/9] [media] st-delta: EOS (End Of Stream) support
Date: Tue, 20 Sep 2016 16:33:38 +0200
Message-ID: <1474382020-17588-8-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
References: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/sti/delta/delta-v4l2.c | 143 +++++++++++++++++++++++++-
 drivers/media/platform/sti/delta/delta.h      |  24 ++++-
 2 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index a8fcdbd..7ae5df7 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -167,7 +167,8 @@ static void delta_frame_done(struct delta_ctx *ctx, struct delta_frame *frame,
 	vbuf->sequence = ctx->frame_num++;
 	v4l2_m2m_buf_done(vbuf, err ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
 
-	ctx->output_frames++;
+	if (frame->info.size)/* ignore EOS */
+		ctx->output_frames++;
 }
 
 static void requeue_free_frames(struct delta_ctx *ctx)
@@ -910,6 +911,132 @@ static int delta_s_selection(struct file *file, void *fh,
 	return 0;
 }
 
+static void delta_complete_eos(struct delta_ctx *ctx,
+			       struct delta_frame *frame)
+{
+	struct delta_dev *delta = ctx->dev;
+	const struct v4l2_event ev = {.type = V4L2_EVENT_EOS};
+
+	/* Send EOS to user:
+	 * - by returning an empty frame flagged to V4L2_BUF_FLAG_LAST
+	 * - and then send EOS event
+	 */
+
+	/* empty frame */
+	frame->info.size = 0;
+
+	/* set the last buffer flag */
+	frame->flags |= V4L2_BUF_FLAG_LAST;
+
+	/* release frame to user */
+	delta_frame_done(ctx, frame, 0);
+
+	/* send EOS event */
+	v4l2_event_queue_fh(&ctx->fh, &ev);
+
+	dev_dbg(delta->dev, "%s EOS completed\n", ctx->name);
+}
+
+static int delta_try_decoder_cmd(struct file *file, void *fh,
+				 struct v4l2_decoder_cmd *cmd)
+{
+	if (cmd->cmd != V4L2_DEC_CMD_STOP)
+		return -EINVAL;
+
+	if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
+		return -EINVAL;
+
+	if (!(cmd->flags & V4L2_DEC_CMD_STOP_IMMEDIATELY) &&
+	    (cmd->stop.pts != 0))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int delta_decoder_stop_cmd(struct delta_ctx *ctx, void *fh)
+{
+	const struct delta_dec *dec = ctx->dec;
+	struct delta_dev *delta = ctx->dev;
+	struct delta_frame *frame = NULL;
+	int ret = 0;
+
+	dev_dbg(delta->dev, "%s EOS received\n", ctx->name);
+
+	if (ctx->state != DELTA_STATE_READY)
+		return 0;
+
+	/* drain the decoder */
+	call_dec_op(dec, drain, ctx);
+
+	/* release to user drained frames */
+	while (1) {
+		frame = NULL;
+		ret = call_dec_op(dec, get_frame, ctx, &frame);
+		if (ret == -ENODATA) {
+			/* no more decoded frames */
+			break;
+		}
+		if (frame) {
+			dev_dbg(delta->dev, "%s drain frame[%d]\n",
+				ctx->name, frame->index);
+
+			/* pop timestamp and mark frame with it */
+			delta_pop_dts(ctx, &frame->dts);
+
+			/* release decoded frame to user */
+			delta_frame_done(ctx, frame, 0);
+		}
+	}
+
+	/* try to complete EOS */
+	ret = delta_get_free_frame(ctx, &frame);
+	if (ret)
+		goto delay_eos;
+
+	/* new frame available, EOS can now be completed */
+	delta_complete_eos(ctx, frame);
+
+	ctx->state = DELTA_STATE_EOS;
+
+	return 0;
+
+delay_eos:
+	/* EOS completion from driver is delayed because
+	 * we don't have a free empty frame available.
+	 * EOS completion is so delayed till next frame_queue() call
+	 * to be sure to have a free empty frame available.
+	 */
+	ctx->state = DELTA_STATE_WF_EOS;
+	dev_dbg(delta->dev, "%s EOS delayed\n", ctx->name);
+
+	return 0;
+}
+
+int delta_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
+{
+	struct delta_ctx *ctx = to_ctx(fh);
+	int ret = 0;
+
+	ret = delta_try_decoder_cmd(file, fh, cmd);
+	if (ret)
+		return ret;
+
+	return delta_decoder_stop_cmd(ctx, fh);
+}
+
+static int delta_subscribe_event(struct v4l2_fh *fh,
+				 const struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_EOS:
+		return v4l2_event_subscribe(fh, sub, 2, NULL);
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* v4l2 ioctl ops */
 static const struct v4l2_ioctl_ops delta_ioctl_ops = {
 	.vidioc_querycap = delta_querycap,
@@ -931,6 +1058,10 @@ static const struct v4l2_ioctl_ops delta_ioctl_ops = {
 	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
 	.vidioc_g_selection = delta_g_selection,
 	.vidioc_s_selection = delta_s_selection,
+	.vidioc_try_decoder_cmd = delta_try_decoder_cmd,
+	.vidioc_decoder_cmd = delta_decoder_cmd,
+	.vidioc_subscribe_event = delta_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 /*
@@ -1508,6 +1639,16 @@ static void delta_vb2_frame_queue(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct delta_frame *frame = to_frame(vbuf);
 
+	if (ctx->state == DELTA_STATE_WF_EOS) {
+		/* new frame available, EOS can now be completed */
+		delta_complete_eos(ctx, frame);
+
+		ctx->state = DELTA_STATE_EOS;
+
+		/* return, no need to recycle this buffer to decoder */
+		return;
+	}
+
 	/* recycle this frame */
 	delta_recycle(ctx, frame);
 }
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
index 6f73cb9..648e64a 100644
--- a/drivers/media/platform/sti/delta/delta.h
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -27,11 +27,19 @@
  *@DELTA_STATE_READY:
  *	Decoding instance is ready to decode compressed access unit.
  *
+ *@DELTA_STATE_WF_EOS:
+ *	Decoding instance is waiting for EOS (End Of Stream) completion.
+ *
+ *@DELTA_STATE_EOS:
+ *	EOS (End Of Stream) is completed (signaled to user). Decoding instance
+ *	should then be closed.
  */
 enum delta_state {
 	DELTA_STATE_WF_FORMAT,
 	DELTA_STATE_WF_STREAMINFO,
 	DELTA_STATE_READY,
+	DELTA_STATE_WF_EOS,
+	DELTA_STATE_EOS
 };
 
 /*
@@ -237,7 +245,7 @@ struct delta_ctx;
  * @get_frame:		get the next decoded frame available, see below
  * @recycle:		recycle the given frame, see below
  * @flush:		(optional) flush decoder, see below
- * @drain:		drain decoder, see below
+ * @drain:		(optional) drain decoder, see below
 */
 struct delta_dec {
 	const char *name;
@@ -372,6 +380,18 @@ struct delta_dec {
 	 * decoding logic.
 	 */
 	void (*flush)(struct delta_ctx *ctx);
+
+	/*
+	 * drain() - drain decoder
+	 * @ctx:	(in) instance
+	 *
+	 * Optional.
+	 * Mark decoder pending frames (decoded but not yet output) as ready
+	 * so that they can be output to client at EOS (End Of Stream).
+	 * get_frame() is to be called in a loop right after drain() to
+	 * get all those pending frames.
+	*/
+	void (*drain)(struct delta_ctx *ctx);
 };
 
 struct delta_dev;
@@ -499,6 +519,8 @@ static inline char *frame_type_str(__u32 flags)
 		return "P";
 	if (flags & V4L2_BUF_FLAG_BFRAME)
 		return "B";
+	if (flags & V4L2_BUF_FLAG_LAST)
+		return "EOS";
 	return "?";
 }
 
-- 
1.9.1

