Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54523 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934666AbcJGRAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:06 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 1/2] [media] st-delta: add parser meta controls
Date: Fri, 7 Oct 2016 18:59:54 +0200
Message-ID: <1475859595-732-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859595-732-1-git-send-email-hugues.fruchet@st.com>
References: <1475859595-732-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/platform/sti/delta/delta-v4l2.c | 92 ++++++++++++++++++++++++++-
 drivers/media/platform/sti/delta/delta.h      |  8 ++-
 2 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 1014d04..a0d2f3e 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -1051,6 +1051,38 @@ static int delta_subscribe_event(struct v4l2_fh *fh,
 	return 0;
 }
 
+
+static int delta_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct delta_ctx *ctx =
+		container_of(ctrl->handler, struct delta_ctx, ctrl_handler);
+	struct delta_dev *delta = ctx->dev;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
+		break;
+	default:
+		dev_err(delta->dev, "%s unsupported control (%d)\n",
+			ctx->name, ctrl->id);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops delta_ctrl_ops = {
+	.s_ctrl = delta_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config delta_ctrl_mpeg2_meta = {
+	.ops = &delta_ctrl_ops,
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR,
+	.type = V4L2_CTRL_TYPE_PRIVATE,
+	.name = "MPEG2 frame/slice metadata",
+	.max_reqs = VIDEO_MAX_FRAME,
+	.elem_size = sizeof(struct v4l2_ctrl_mpeg2_meta),
+};
+
 /* v4l2 ioctl ops */
 static const struct v4l2_ioctl_ops delta_ioctl_ops = {
 	.vidioc_querycap = delta_querycap,
@@ -1112,6 +1144,15 @@ static void delta_run_work(struct work_struct *work)
 	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
 	au->dts = vbuf->vb2_buf.timestamp;
 
+	/* get access unit meta data */
+	ret = v4l2_ctrl_apply_request(&ctx->ctrl_handler, vbuf->request);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to apply metadata control request (%d)\n",
+			ctx->name, ret);
+		goto out;
+	}
+	au->meta = ctx->meta_ctrl->p_new.p;
+
 	/* dump access unit */
 	dev_dbg(delta->dev, "%s dump %s", ctx->name,
 		dump_au(au, str, sizeof(str)));
@@ -1507,6 +1548,15 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
 	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
 	au->dts = vbuf->vb2_buf.timestamp;
 
+	/* get access unit meta data */
+	ret = v4l2_ctrl_apply_request(&ctx->ctrl_handler, vbuf->request);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to start streaming, cannot apply metadata control request (%d)\n",
+			ctx->name, ret);
+		goto err;
+	}
+	au->meta = ctx->meta_ctrl->p_new.p;
+
 	delta_push_dts(ctx, au->dts);
 
 	/* dump access unit */
@@ -1758,6 +1808,7 @@ static int queue_init(void *priv,
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	q->lock = &delta->lock;
+	q->v4l2_allow_requests = true;
 	ret = vb2_queue_init(q);
 	if (ret)
 		return ret;
@@ -1778,6 +1829,33 @@ static int queue_init(void *priv,
 	return vb2_queue_init(q);
 }
 
+static int delta_ctrls_setup(struct delta_ctx *ctx)
+{
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_ctrl_handler *hdl;
+
+	hdl = &ctx->ctrl_handler;
+	v4l2_ctrl_handler_init(hdl, 1);
+
+//FIXME, switch codec... so we can do this only when codec is known !
+	ctx->meta_ctrl = v4l2_ctrl_new_custom(hdl, &delta_ctrl_mpeg2_meta,
+					      NULL);
+	ctx->meta_ctrl->flags |= V4L2_CTRL_FLAG_REQ_KEEP;
+
+	if (hdl->error) {
+		int err = hdl->error;
+
+		dev_err(delta->dev, "%s controls setup failed (%d)\n",
+			ctx->name, err);
+		v4l2_ctrl_handler_free(hdl);
+		return err;
+	}
+
+	v4l2_ctrl_handler_setup(hdl);
+
+	return 0;
+}
+
 static int delta_open(struct file *file)
 {
 	struct delta_dev *delta = video_drvdata(file);
@@ -1797,6 +1875,14 @@ static int delta_open(struct file *file)
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
+	ret = delta_ctrls_setup(ctx);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to setup controls (%d)\n",
+			DELTA_PREFIX, ret);
+		goto err_fh_del;
+	}
+	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
+
 	INIT_WORK(&ctx->run_work, delta_run_work);
 	mutex_init(&ctx->lock);
 
@@ -1806,7 +1892,7 @@ static int delta_open(struct file *file)
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		dev_err(delta->dev, "%s failed to initialize m2m context (%d)\n",
 			DELTA_PREFIX, ret);
-		goto err_fh_del;
+		goto err_ctrls;
 	}
 
 	/* wait stream format to determine which
@@ -1840,6 +1926,8 @@ static int delta_open(struct file *file)
 
 	return 0;
 
+err_ctrls:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 err_fh_del:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -1871,6 +1959,8 @@ static int delta_release(struct file *file)
 
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
index df0783e..98ff385 100644
--- a/drivers/media/platform/sti/delta/delta.h
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -8,6 +8,7 @@
 #define DELTA_H
 
 #include <linux/rpmsg.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 
@@ -106,6 +107,7 @@ struct delta_au {
 	dma_addr_t paddr;
 	__u32 flags;
 	u64 dts;
+	void *meta;
 };
 
 /*
@@ -401,6 +403,8 @@ struct delta_dev;
  *
  * @flags:		validity of fields (streaminfo)
  * @fh:			V4L2 file handle
+ * @ctrl_handler:	V4L2 controls handler
+ * @meta_ctrl:		access unit meta data control
  * @dev:		device context
  * @dec:		selected decoder context for this instance
  * @ipc_ctx:		context of IPC communication with firmware
@@ -433,10 +437,11 @@ struct delta_dev;
 struct delta_ctx {
 	__u32 flags;
 	struct v4l2_fh fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl *meta_ctrl;
 	struct delta_dev *dev;
 	const struct delta_dec *dec;
 	struct delta_ipc_ctx ipc_ctx;
-
 	enum delta_state state;
 	u32 frame_num;
 	u32 au_num;
@@ -456,6 +461,7 @@ struct delta_ctx {
 	struct work_struct run_work;
 	struct mutex lock;
 	bool aborting;
+	struct v4l2_ctrl_handler hdl;
 	void *priv;
 };
 
-- 
1.9.1

