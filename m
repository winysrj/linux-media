Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:59752 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753521AbdBHPiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 10:38:13 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 2/3] [media] st-delta: add parsing metadata controls support
Date: Wed, 8 Feb 2017 16:37:19 +0100
Message-ID: <1486568240-7645-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486568240-7645-1-git-send-email-hugues.fruchet@st.com>
References: <1486568240-7645-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Install all metadata controls required by registered decoders.
Update the decoding context with the set of metadata received
from user through extended control.
Set the received metadata in access unit prior to call the
decoder decoding ops.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/sti/delta/delta-v4l2.c | 125 +++++++++++++++++++++++++-
 drivers/media/platform/sti/delta/delta.h      |  34 +++++++
 2 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index c6f2e24..1d4436e 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -339,6 +339,30 @@ static void register_decoders(struct delta_dev *delta)
 	}
 }
 
+static void register_ctrls(struct delta_dev *delta)
+{
+	const struct delta_dec *dec;
+	unsigned int i, j;
+	u32 meta_cid;
+
+	/* decoders optional meta controls */
+	for (i = 0; i < delta->nb_of_decoders; i++) {
+		dec = delta->decoders[i];
+		if (!dec->meta_cids)
+			continue;
+
+		for (j = 0; j < dec->nb_of_metas; j++) {
+			meta_cid = dec->meta_cids[j];
+			if (!meta_cid)
+				continue;
+
+			delta->cids[delta->nb_of_ctrls++] = meta_cid;
+		}
+	}
+
+	/* add here additional controls if needed */
+}
+
 static void delta_lock(void *priv)
 {
 	struct delta_ctx *ctx = priv;
@@ -355,6 +379,79 @@ static void delta_unlock(void *priv)
 	mutex_unlock(&delta->lock);
 }
 
+static int delta_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct delta_ctx *ctx =
+		container_of(ctrl->handler, struct delta_ctx, ctrl_handler);
+	struct delta_dev *delta = ctx->dev;
+
+	if (ctx->nb_of_metas >= DELTA_MAX_METAS) {
+		dev_err(delta->dev, "%s not enough room to set meta control\n",
+			ctx->name);
+		return -EINVAL;
+	}
+
+	dev_dbg(delta->dev, "%s set metas[%d] from control id=%d (%s)\n",
+		ctx->name, ctx->nb_of_metas, ctrl->id, ctrl->name);
+
+	ctx->metas[ctx->nb_of_metas].cid = ctrl->id;
+	ctx->metas[ctx->nb_of_metas].p = ctrl->p_new.p;
+	ctx->nb_of_metas++;
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops delta_ctrl_ops = {
+	.s_ctrl = delta_s_ctrl,
+};
+
+static int delta_ctrls_setup(struct delta_ctx *ctx)
+{
+	struct delta_dev *delta = ctx->dev;
+	struct v4l2_ctrl_handler *hdl = &ctx->ctrl_handler;
+	unsigned int i;
+
+	v4l2_ctrl_handler_init(hdl, delta->nb_of_ctrls);
+
+	for (i = 0; i < delta->nb_of_ctrls; i++) {
+		struct v4l2_ctrl *ctrl;
+		u32 cid = delta->cids[i];
+		struct v4l2_ctrl_config cfg;
+
+		/* override static config to set delta_ctrl_ops */
+		memset(&cfg, 0, sizeof(cfg));
+		cfg.id = cid;
+		cfg.ops = &delta_ctrl_ops;
+
+		ctrl = v4l2_ctrl_new_custom(hdl, &cfg, NULL);
+		if (hdl->error) {
+			int err = hdl->error;
+
+			dev_err(delta->dev, "%s failed to setup control '%s' (id=%d, size=%d, err=%d)\n",
+				ctx->name, cfg.name, cfg.id,
+				cfg.elem_size, err);
+			v4l2_ctrl_handler_free(hdl);
+			return err;
+		}
+
+		/* force unconditional execution of s_ctrl() by
+		 * disabling control value evaluation in case of
+		 * meta control (passed by pointer)
+		 */
+		if (ctrl->is_ptr)
+			ctrl->flags |= V4L2_CTRL_FLAG_EXECUTE_ON_WRITE;
+	}
+
+	v4l2_ctrl_handler_setup(hdl);
+	ctx->fh.ctrl_handler = hdl;
+
+	ctx->nb_of_metas = 0;
+	memset(ctx->metas, 0, sizeof(ctx->metas));
+
+	dev_dbg(delta->dev, "%s controls setup done\n", ctx->name);
+	return 0;
+}
+
 static int delta_open_decoder(struct delta_ctx *ctx, u32 streamformat,
 			      u32 pixelformat, const struct delta_dec **pdec)
 {
@@ -964,6 +1061,12 @@ static void delta_run_work(struct work_struct *work)
 	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
 	au->dts = vbuf->vb2_buf.timestamp;
 
+	/* set access unit meta data in case of decoder requires it */
+	memcpy(au->metas, ctx->metas, ctx->nb_of_metas * sizeof(au->metas[0]));
+	au->nb_of_metas = ctx->nb_of_metas;
+	/* reset context metas for next decoding */
+	ctx->nb_of_metas = 0;
+
 	/* dump access unit */
 	dump_au(ctx, au);
 
@@ -1364,6 +1467,12 @@ static int delta_vb2_au_start_streaming(struct vb2_queue *q,
 	au->size = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
 	au->dts = vbuf->vb2_buf.timestamp;
 
+	/* set access unit meta data in case of decoder requires it */
+	memcpy(au->metas, ctx->metas, ctx->nb_of_metas * sizeof(au->metas[0]));
+	au->nb_of_metas = ctx->nb_of_metas;
+	/* reset context metas for next decoding */
+	ctx->nb_of_metas = 0;
+
 	delta_push_dts(ctx, au->dts);
 
 	/* dump access unit */
@@ -1659,6 +1768,13 @@ static int delta_open(struct file *file)
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 
+	ret = delta_ctrls_setup(ctx);
+	if (ret) {
+		dev_err(delta->dev, "%s failed to setup controls (%d)\n",
+			DELTA_PREFIX, ret);
+		goto err_fh_del;
+	}
+
 	INIT_WORK(&ctx->run_work, delta_run_work);
 	mutex_init(&ctx->lock);
 
@@ -1668,7 +1784,7 @@ static int delta_open(struct file *file)
 		ret = PTR_ERR(ctx->fh.m2m_ctx);
 		dev_err(delta->dev, "%s failed to initialize m2m context (%d)\n",
 			DELTA_PREFIX, ret);
-		goto err_fh_del;
+		goto err_ctrls;
 	}
 
 	/*
@@ -1703,6 +1819,8 @@ static int delta_open(struct file *file)
 
 	return 0;
 
+err_ctrls:
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 err_fh_del:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
@@ -1732,6 +1850,8 @@ static int delta_release(struct file *file)
 
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 
+	v4l2_ctrl_handler_free(&ctx->ctrl_handler);
+
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 
@@ -1887,6 +2007,9 @@ static int delta_probe(struct platform_device *pdev)
 	/* register all supported formats */
 	register_formats(delta);
 
+	/* register all supported controls */
+	register_ctrls(delta);
+
 	/* register on V4L2 */
 	ret = v4l2_device_register(dev, &delta->v4l2_dev);
 	if (ret) {
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
index 60c07324..0893948 100644
--- a/drivers/media/platform/sti/delta/delta.h
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -8,6 +8,7 @@
 #define DELTA_H
 
 #include <linux/rpmsg.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-mem2mem.h>
 
@@ -86,6 +87,19 @@ struct delta_streaminfo {
 #define DELTA_STREAMINFO_FLAG_OTHER		0x0004
 
 /*
+ * struct delta_meta - access unit metadata structure.
+ *
+ * @cid:	control identifier for this meta
+ * @p:		pointer to control data
+ */
+struct delta_meta {
+	u32 cid;
+	void *p;
+};
+
+#define DELTA_MAX_METAS 20
+
+/*
  * struct delta_au - access unit structure.
  *
  * @vbuf:	video buffer information for V4L2
@@ -106,6 +120,8 @@ struct delta_au {
 	dma_addr_t paddr;
 	u32 flags;
 	u64 dts;
+	struct delta_meta metas[DELTA_MAX_METAS];
+	unsigned int nb_of_metas;
 };
 
 /*
@@ -229,6 +245,9 @@ struct delta_ipc_param {
  * @name:		name of this decoder
  * @streamformat:	input stream format that this decoder support
  * @pixelformat:	pixel format of decoded frame that this decoder support
+ * @meta_cids:		(optional) meta control identifiers if decoder needs
+ *			additional parsing metadata to be able to decode
+ * @nb_of_metas:	(optional) nb of meta controls
  * @max_width:		(optional) maximum width that can decode this decoder
  *			if not set, maximum width is DELTA_MAX_WIDTH
  * @max_height:		(optional) maximum height that can decode this decoder
@@ -251,6 +270,8 @@ struct delta_dec {
 	const char *name;
 	u32 streamformat;
 	u32 pixelformat;
+	const u32 *meta_cids;
+	unsigned int nb_of_metas;
 	u32 max_width;
 	u32 max_height;
 	bool pm;
@@ -396,11 +417,17 @@ struct delta_dec {
 
 struct delta_dev;
 
+#define DELTA_MAX_CTRLS  (DELTA_MAX_DECODERS * DELTA_MAX_METAS)
+
 /*
  * struct delta_ctx - instance structure.
  *
  * @flags:		validity of fields (streaminfo)
  * @fh:			V4L2 file handle
+ * @ctrl_handler:	controls handler
+ * @metas:		set of parsing metadata required to
+ *			decode the current access unit
+ * @nb_of_metas:	number of metatada
  * @dev:		device context
  * @dec:		selected decoder context for this instance
  * @ipc_ctx:		context of IPC communication with firmware
@@ -433,6 +460,9 @@ struct delta_dec {
 struct delta_ctx {
 	u32 flags;
 	struct v4l2_fh fh;
+	struct v4l2_ctrl_handler ctrl_handler;
+	struct delta_meta metas[DELTA_MAX_METAS];
+	unsigned int nb_of_metas;
 	struct delta_dev *dev;
 	const struct delta_dec *dec;
 	struct delta_ipc_ctx ipc_ctx;
@@ -483,6 +513,8 @@ struct delta_ctx {
  * @nb_of_pixelformats:	number of supported umcompressed video formats
  * @streamformats:	supported compressed video formats
  * @nb_of_streamformats:number of supported compressed video formats
+ * @cids:		set of all control identifiers used by device
+ * @nb_of_ctrls:	overall number of controls used by device
  * @instance_id:	rolling counter identifying an instance (debug purpose)
  * @work_queue:		decoding job work queue
  * @rpmsg_driver:	rpmsg IPC driver
@@ -504,6 +536,8 @@ struct delta_dev {
 	u32 nb_of_pixelformats;
 	u32 streamformats[DELTA_MAX_FORMATS];
 	u32 nb_of_streamformats;
+	u32 cids[DELTA_MAX_CTRLS];
+	u32 nb_of_ctrls;
 	u8 instance_id;
 	struct workqueue_struct *work_queue;
 	struct rpmsg_driver rpmsg_driver;
-- 
1.9.1

