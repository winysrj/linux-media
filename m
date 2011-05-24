Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:42718 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1EXAe5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 20:34:57 -0400
From: Jeongtae Park <jtp.park@samsung.com>
To: Jeongtae Park <jtp.park@samsung.com>, linux-media@vger.kernel.org
Cc: jaeryul.oh@samsung.com, jonghun.han@samsung.com,
	june.bae@samsung.com, janghyuck.kim@samsung.com,
	younglak1004.kim@samsung.com, m.szyprowski@samsung.com,
	Jeongtae Park <jtp.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 4/4] media: MFC: Add support control framework in decoder
Date: Tue, 24 May 2011 09:28:40 +0900
Message-Id: <1306196920-15467-5-git-send-email-jtp.park@samsung.com>
In-Reply-To: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
References: <1306196920-15467-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch migrate to v4l2 control framework for MFC decoder.
It utilize per-filehandle & per-buffer control handling facilities.

Signed-off-by: Jeongtae Park <jtp.park@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/video/s5p-mfc/regs-mfc.h       |    1 +
 drivers/media/video/s5p-mfc/s5p_mfc.c        |  184 ++++-----
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |   31 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    |  597 +++++++++++---------------
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    |   84 +++--
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |    4 +-
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    |   33 ++-
 8 files changed, 429 insertions(+), 509 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/regs-mfc.h b/drivers/media/video/s5p-mfc/regs-mfc.h
index 8c67fe1..396381e 100644
--- a/drivers/media/video/s5p-mfc/regs-mfc.h
+++ b/drivers/media/video/s5p-mfc/regs-mfc.h
@@ -285,6 +285,7 @@
 #define S5P_FIMV_SI_CH0_DPB_CONF_CTRL   0x2068 /* DPB Config Control Register */
 #define S5P_FIMV_SLICE_INT_MASK		1
 #define S5P_FIMV_SLICE_INT_SHIFT	31
+#define S5P_FIMV_DDELAY_ENA_MASK	1
 #define S5P_FIMV_DDELAY_ENA_SHIFT	30
 #define S5P_FIMV_DDELAY_VAL_MASK	0xff
 #define S5P_FIMV_DDELAY_VAL_SHIFT	16
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c b/drivers/media/video/s5p-mfc/s5p_mfc.c
index c9c5d1e..0f86928 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
@@ -673,27 +673,38 @@ static int s5p_mfc_open(struct file *file)
 {
 	struct s5p_mfc_ctx *ctx = NULL;
 	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct vb2_queue *q;
 	unsigned long flags;
 	int ret = 0;
+	enum s5p_mfc_node_type node;
 
 	mfc_debug_enter();
 
+	node = s5p_mfc_get_node_type(file);
+	if (node == MFCNODE_INVALID) {
+		mfc_err("cannot specify node type\n");
+		ret = -ENOENT;
+		goto err_node_type;
+	}
+
 	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
 
 	/* Allocate memory for context */
-	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx) {
 		mfc_err("Not enough memory.\n");
 		ret = -ENOMEM;
-		goto out_open;
+		goto err_ctx_alloc;
 	}
-	file->private_data = ctx;
+
+	ret = v4l2_fh_init(&ctx->fh, (node == MFCNODE_DECODER) ?
+			   dev->vfd_dec : dev->vfd_enc);
+	if (ret)
+		goto err_v4l2_fh;
+	file->private_data = &ctx->fh;
+	v4l2_fh_add(&ctx->fh);
+
 	ctx->dev = dev;
-	INIT_LIST_HEAD(&ctx->src_queue);
-	INIT_LIST_HEAD(&ctx->dst_queue);
-	ctx->src_queue_cnt = 0;
-	ctx->dst_queue_cnt = 0;
+
 	/* Get context number */
 	ctx->num = 0;
 	while (dev->ctx[ctx->num]) {
@@ -701,35 +712,31 @@ static int s5p_mfc_open(struct file *file)
 		if (ctx->num >= MFC_NUM_CONTEXTS) {
 			mfc_err("Too many open contexts.\n");
 			ret = -EBUSY;
-			goto out_open;
+			goto err_ctx_num;
 		}
 	}
+
 	/* Mark context as idle */
 	spin_lock_irqsave(&dev->condlock, flags);
 	clear_bit(ctx->num, &dev->ctx_work_bits);
 	spin_unlock_irqrestore(&dev->condlock, flags);
 	dev->ctx[ctx->num] = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
-		ctx->type = MFCINST_DECODER;
-		ctx->c_ops = get_dec_codec_ops();
-		/* Default format */
-		ctx->src_fmt = get_dec_def_fmt(1);
-		ctx->dst_fmt = get_dec_def_fmt(0);
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
-		ctx->type = MFCINST_ENCODER;
-		ctx->c_ops = get_enc_codec_ops();
-		/* Default format */
-		ctx->src_fmt = get_enc_def_fmt(1);
-		ctx->dst_fmt = get_enc_def_fmt(0);
-
-		/* only for encoder */
-		INIT_LIST_HEAD(&ctx->ref_queue);
-		ctx->ref_queue_cnt = 0;
-	} else {
-		ret = -ENOENT;
-		goto out_open;
+
+	init_waitqueue_head(&ctx->queue);
+
+	if (node == MFCNODE_DECODER)
+		ret = s5p_mfc_init_dec_ctx(ctx);
+	else
+		ret = s5p_mfc_init_enc_ctx(ctx);
+	if (ret)
+		goto err_ctx_init;
+
+	ret = call_cop(ctx, init_ctx_ctrls, ctx);
+	if (ret) {
+		mfc_err("failed in init_buf_ctrls\n");
+		goto err_ctx_ctrls;
 	}
-	ctx->inst_no = -1;
+
 	/* Load firmware if this is the first instance */
 	if (dev->num_inst == 1) {
 		dev->watchdog_timer.expires = jiffies +
@@ -738,106 +745,70 @@ static int s5p_mfc_open(struct file *file)
 
 		mfc_debug(2, "power on\n");
 		ret = s5p_mfc_power_on();
-		if (ret < 0) {
+		if (ret) {
 			mfc_err("power on failed\n");
 			goto err_pwr_enable;
 		}
 
-		s5p_mfc_clock_on();
-
 		ret = s5p_mfc_mem_enable(dev->alloc_ctx);
-		if (ret != 0)
-			goto out_open_2b;
+		if (ret)
+			goto err_mem_enable;
 
 		/* Load the FW */
 		ret = s5p_mfc_alloc_firmware(dev);
-		if (ret != 0)
-			goto out_open_2a;
+		if (ret)
+			goto err_fw_alloc;
+
 		ret = s5p_mfc_load_firmware(dev);
-		if (ret != 0)
-			goto out_open_2;
+		if (ret)
+			goto err_fw_load;
 
 #ifndef CONFIG_PM_RUNTIME
 		s5p_mfc_mem_resume(dev->alloc_ctx);
 #endif
 		/* Init the FW */
 		ret = s5p_mfc_init_hw(dev);
-		if (ret != 0)
-			goto out_open_3;
-
-		s5p_mfc_clock_off();
+		if (ret)
+			goto err_hw_init;
 	}
 
-	/* Init videobuf2 queue for CAPTURE */
-	q = &ctx->vq_dst;
-	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
-	q->drv_priv = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
-		q->io_modes = VB2_MMAP;
-		q->ops = get_dec_queue_ops();
-	} else {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
-		q->ops = get_enc_queue_ops();
-	}
-
-	q->mem_ops = s5p_mfc_mem_ops();
-	ret = vb2_queue_init(q);
-	if (ret) {
-		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
-		goto out_open_3;
-	}
-
-	/* Init videobuf2 queue for OUTPUT */
-	q = &ctx->vq_src;
-	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
-	q->io_modes = VB2_MMAP;
-	q->drv_priv = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
-		q->io_modes = VB2_MMAP;
-		q->ops = get_dec_queue_ops();
-	} else {
-		q->io_modes = VB2_MMAP | VB2_USERPTR;
-		q->ops = get_enc_queue_ops();
-	}
-
-	q->mem_ops = s5p_mfc_mem_ops();
-	ret = vb2_queue_init(q);
-	if (ret) {
-		mfc_err("Failed to initialize videobuf2 queue(output)\n");
-		goto out_open_3;
-	}
-
-	if (call_cop(ctx, init_ctx_ctrls, ctx) < 0)
-		mfc_err("failed in init_buf_ctrls\n");
-
-	init_waitqueue_head(&ctx->queue);
-	mfc_debug(2, "%s-- (via irq_cleanup_hw)\n", __func__);
 	return ret;
 
 	/* Deinit when failure occured */
-out_open_3:
-out_open_2:
+err_hw_init:
+#ifndef CONFIG_PM_RUNTIME
+	s5p_mfc_mem_suspend(dev->alloc_ctx);
+#endif
+
+err_fw_load:
 	s5p_mfc_release_firmware(dev);
 
-out_open_2a:
+err_fw_alloc:
 	s5p_mfc_mem_disable(dev->alloc_ctx);
-out_open_2b:
-	dev->ctx[ctx->num] = 0;
-	kfree(ctx);
-	del_timer_sync(&dev->watchdog_timer);
 
-	s5p_mfc_clock_off();
+err_mem_enable:
+	if (s5p_mfc_power_off() < 0)
+		mfc_err("power off failed\n");
+
 err_pwr_enable:
-	if (dev->num_inst == 1) {
-		if (s5p_mfc_power_off() < 0)
-			mfc_err("power off failed\n");
+	del_timer_sync(&dev->watchdog_timer);
+	call_cop(ctx, cleanup_ctx_ctrls, ctx);
 
-		s5p_mfc_release_firmware(dev);
-	}
+err_ctx_ctrls:
+err_ctx_init:
+	dev->ctx[ctx->num] = 0;
+
+err_ctx_num:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+err_v4l2_fh:
+	kfree(ctx);
 
-out_open:
+err_ctx_alloc:
 	dev->num_inst--;
 
+err_node_type:
 	mfc_debug_leave();
 
 	return ret;
@@ -846,14 +817,17 @@ out_open:
 /* Release MFC context */
 static int s5p_mfc_release(struct file *file)
 {
-	struct s5p_mfc_ctx *ctx = file->private_data;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(file->private_data);
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned long flags;
 
 	mfc_debug_enter();
 
 	if (call_cop(ctx, cleanup_ctx_ctrls, ctx) < 0)
-		mfc_err("failed in init_buf_ctrls\n");
+		mfc_err("failed in cleanup_ctx_ctrls\n");
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
 
 	s5p_mfc_clock_on();
 	vb2_queue_release(&ctx->vq_src);
@@ -915,7 +889,7 @@ static int s5p_mfc_release(struct file *file)
 static unsigned int s5p_mfc_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
-	struct s5p_mfc_ctx *ctx = file->private_data;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(file->private_data);
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct vb2_queue *src_q, *dst_q;
 	struct vb2_buffer *src_vb = NULL, *dst_vb = NULL;
@@ -971,7 +945,7 @@ end:
 /* Mmap */
 static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct s5p_mfc_ctx *ctx = file->private_data;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(file->private_data);
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	int ret;
 
@@ -1022,8 +996,6 @@ static int __devinit s5p_mfc_probe(struct platform_device *pdev)
 	int ret = -ENOENT;
 	size_t size;
 
-	//int i;
-
 	pr_debug("%s++\n", __func__);
 	dev = kzalloc(sizeof *dev, GFP_KERNEL);
 	if (!dev) {
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_common.h b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
index 5d16e51..8230074 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_common.h
@@ -348,11 +348,20 @@ struct s5p_mfc_codec_ops {
 	(((c)->c_ops->op) ?					\
 		((c)->c_ops->op(args)) : 0)
 
+struct s5p_mfc_dec_ctrls {
+	struct v4l2_ctrl *loop_filter_mpeg4;
+	struct v4l2_ctrl *display_delay;
+	struct v4l2_ctrl *display_delay_enable;
+	struct v4l2_ctrl *min_of_dpb;
+	struct v4l2_ctrl *slice_interface;
+};
+
 /**
  * struct s5p_mfc_ctx - This struct contains the instance context
  */
 struct s5p_mfc_ctx {
 	struct s5p_mfc_dev *dev;
+	struct v4l2_fh fh;
 	int num;
 
 	int int_cond;
@@ -418,24 +427,13 @@ struct s5p_mfc_ctx {
 	int codec_mode;
 	__u32 pix_format;
 
-	int slice_interface;
-	int loop_filter_mpeg4;
-	int display_delay;
-	int display_delay_enable;
 	int after_packed_pb;
 
 	int dpb_count;
 	int total_dpb_count;
 
-	struct list_head ctrls;
-
-	struct s5p_mfc_ctx_ctrl src_frame_tag;
-	struct s5p_mfc_ctx_ctrl dst_frmae_tag;
-
-	int disp_status;
-	int decode_status;
-	int disp_frame;		/* SHM */
-	int decode_frame;	/* SFR */
+	struct s5p_mfc_dec_ctrls dec_ctrls;
+	struct v4l2_ctrl_handler ctrl_hdlr;
 
 	/* Buffers */
 	void *context_buf;
@@ -456,7 +454,6 @@ struct s5p_mfc_ctx {
 	size_t enc_dst_buf_size;
 
 	int frame_count;
-//	enum v4l2__frame_type frame_type;
 	enum v4l2_mpeg_mfc51_force_frame_type force_frame_type;
 
 	struct list_head ref_queue;
@@ -465,6 +462,12 @@ struct s5p_mfc_ctx {
 	struct s5p_mfc_codec_ops *c_ops;
 };
 
+#define fh_to_mfc_ctx(x)	\
+	container_of(x, struct s5p_mfc_ctx, fh)
+
+#define ch_to_mfc_ctx(x)	\
+	container_of(x, struct s5p_mfc_ctx, ctrl_hdlr)
+
 struct s5p_mfc_fmt {
 	char *name;
 	u32 fourcc;
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
index 4c1546f..bd96e53 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.c
@@ -154,86 +154,7 @@ static struct s5p_mfc_fmt *find_format(struct v4l2_format *f, unsigned int t)
 	return NULL;
 }
 
-static struct v4l2_queryctrl controls[] = {
-	{
-		.id = V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "H264 Display Delay",
-		.minimum = 0,
-		.maximum = 16383,
-		.step = 1,
-		.default_value = 0,
-	},
-	{
-		.id = V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE,
-		.type = V4L2_CTRL_TYPE_BOOLEAN,
-		.name = "H264 Display Delay Enable",
-		.minimum = 0,
-		.maximum = 1,
-		.step = 1,
-		.default_value = 0,
-	},
-	{
-		.id = V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER,
-		.type = V4L2_CTRL_TYPE_BOOLEAN,
-		.name = "Mpeg4 Loop Filter Enable",
-		.minimum = 0,
-		.maximum = 1,
-		.step = 1,
-		.default_value = 0,
-	},
-	{
-		.id = V4L2_CID_MPEG_DECODER_SLICE_INTERFACE,
-		.type = V4L2_CTRL_TYPE_BOOLEAN,
-		.name = "Slice Interface Enable",
-		.minimum = 0,
-		.maximum = 1,
-		.step = 1,
-		.default_value = 0,
-	},
-	{
-		.id = V4L2_CID_MPEG_MFC51_FRAME_TAG,
-		.type = V4L2_CTRL_TYPE_INTEGER,
-		.name = "Frame Tag",
-		.minimum = 0,
-		.maximum = INT_MAX,
-		.step = 1,
-		.default_value = 0,
-	},
-};
-
-#define NUM_CTRLS ARRAY_SIZE(controls)
-
-static struct v4l2_queryctrl *get_ctrl(int id)
-{
-	int i;
-
-	for (i = 0; i < NUM_CTRLS; ++i)
-		if (id == controls[i].id)
-			return &controls[i];
-	return NULL;
-}
-
-/* Check whether a ctrl value if correct */
-static int check_ctrl_val(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
-{
-	struct s5p_mfc_dev *dev = ctx->dev;
-	struct v4l2_queryctrl *c;
-
-	c = get_ctrl(ctrl->id);
-	if (!c)
-		return -EINVAL;
-
-	if (ctrl->value < c->minimum || ctrl->value > c->maximum
-	    || (c->step != 0 && ctrl->value % c->step != 0)) {
-		v4l2_err(&dev->v4l2_dev, "invalid control value\n");
-		return -ERANGE;
-	}
-
-	return 0;
-}
-
-static struct s5p_mfc_ctrl_cfg mfc_ctrl_list[] = {
+static struct s5p_mfc_ctrl_cfg mfc_buf_ctrl_cfgs[] = {
 	{
 		.type = MFC_CTRL_TYPE_SET,
 		.id = V4L2_CID_MPEG_MFC51_FRAME_TAG,
@@ -260,7 +181,144 @@ static struct s5p_mfc_ctrl_cfg mfc_ctrl_list[] = {
 	},
 };
 
-#define NUM_CTRL_CFGS ARRAY_SIZE(mfc_ctrl_list)
+#define NUM_BUF_CTRL_CFGS	ARRAY_SIZE(mfc_buf_ctrl_cfgs)
+
+static int s5p_mfc_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct s5p_mfc_ctx *ctx = ch_to_mfc_ctx(ctrl->handler);
+	struct s5p_mfc_dev *dev = ctx->dev;
+
+	mfc_debug(2, "ID: 0x%08x\n", ctrl->id);
+
+	switch (ctrl->id) {
+		case V4L2_CID_MIN_REQ_BUFS_CAP:
+			if (ctx->state >= MFCINST_HEAD_PARSED &&
+			    ctx->state < MFCINST_ABORT) {
+				ctrl->cur.val = ctx->dpb_count;
+				break;
+			} else if (ctx->state != MFCINST_INIT) {
+				v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
+				return -EINVAL;
+			}
+
+			/* Should wait for the header to be parsed */
+			s5p_mfc_clean_ctx_int_flags(ctx);
+			s5p_mfc_wait_for_done_ctx(ctx,
+					S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
+			if (ctx->state >= MFCINST_HEAD_PARSED &&
+			    ctx->state < MFCINST_ABORT) {
+				ctrl->cur.val = ctx->dpb_count;
+			} else {
+				v4l2_err(&dev->v4l2_dev,
+						 "Decoding not initialised.\n");
+				return -EINVAL;
+			}
+			break;
+	}
+
+	return 0;
+}
+
+static int s5p_mfc_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	mfc_debug(2, "ID: 0x%08x, val: %d\n", ctrl->id, ctrl->val);
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops s5p_mfc_ctrl_ops = {
+	.g_volatile_ctrl	= s5p_mfc_g_volatile_ctrl,
+	.s_ctrl 		= s5p_mfc_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config mfc_ctx_ctrl_cfgs[] = {
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MIN_REQ_BUFS_CAP,
+		.name	= "Required Number of DPBs for capture",
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.min	= 1,
+		.max	= 32,
+		.step	= 1,
+		.def	= 1,
+		.flags	= V4L2_CTRL_FLAG_READ_ONLY,
+		.is_private	= 0,
+		.is_volatile	= 1,
+		.is_bufferable	= 0,
+	},
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER,
+		.name	= "Mpeg4 Loop Filter Enable",
+		.type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.min	= 0,
+		.max	= 1,
+		.step	= 1,
+		.def	= 0,
+		.flags	= 0,
+		.is_private	= 0,
+		.is_volatile	= 0,
+		.is_bufferable	= 0,
+	},
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY,
+		.name	= "H264 Display Delay",
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.min	= 0,
+		.max	= 16383,
+		.step	= 1,
+		.def	= 0,
+		.flags	= 0,
+		.is_private	= 0,
+		.is_volatile	= 0,
+		.is_bufferable	= 0,
+	},
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE,
+		.name	= "H264 Display Delay Enable",
+		.type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.min	= 0,
+		.max	= 1,
+		.step	= 1,
+		.def	= 0,
+		.flags	= 0,
+		.is_private	= 0,
+		.is_volatile	= 0,
+		.is_bufferable	= 0,
+	},
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MPEG_DECODER_SLICE_INTERFACE,
+		.name	= "Slice Interface Enable",
+		.type	= V4L2_CTRL_TYPE_BOOLEAN,
+		.min	= 0,
+		.max	= 1,
+		.step	= 1,
+		.def	= 0,
+		.flags	= 0,
+		.is_private	= 0,
+		.is_volatile	= 0,
+		.is_bufferable	= 0,
+	},
+	{
+		.ops	= &s5p_mfc_ctrl_ops,
+		.id	= V4L2_CID_MPEG_MFC51_FRAME_TAG,
+		.name	= "Frame Tag",
+		.type	= V4L2_CTRL_TYPE_INTEGER,
+		.min	= 0,
+		.max	= INT_MAX,
+		.step	= 1,
+		.def	= 0,
+		.flags	= 0,
+		.is_private	= 0,
+		.is_volatile	= 0,
+		.is_bufferable	= 1,
+	},
+};
+
+#define NUM_CTX_CTRL_CFGS	ARRAY_SIZE(mfc_ctx_ctrl_cfgs)
 
 /* Check whether a context should be run on hardware */
 static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
@@ -303,47 +361,39 @@ static int s5p_mfc_ctx_ready(struct s5p_mfc_ctx *ctx)
 static int dec_init_ctx_ctrls(struct s5p_mfc_ctx *ctx)
 {
 	int i;
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
-
-	INIT_LIST_HEAD(&ctx->ctrls);
+	struct v4l2_ctrl *ctrl;
 
-	for (i = 0; i < NUM_CTRL_CFGS; i++) {
-		ctx_ctrl = kzalloc(sizeof(struct s5p_mfc_ctx_ctrl), GFP_KERNEL);
-		if (ctx_ctrl == NULL) {
-			mfc_err("failed to allocate ctx_ctrl type: %d, id: 0x%08x\n",
-				mfc_ctrl_list[i].type, mfc_ctrl_list[i].id);
+	v4l2_ctrl_handler_init(&ctx->ctrl_hdlr, 1);
 
-			return -ENOMEM;
+	for (i = 0; i < NUM_CTX_CTRL_CFGS; i++) {
+		ctrl = v4l2_ctrl_new_custom(&ctx->ctrl_hdlr, &mfc_ctx_ctrl_cfgs[i], ctx);
+		if (ctx->ctrl_hdlr.error) {
+			mfc_debug(2, "control handler error: %d\n", ctx->ctrl_hdlr.error);
+			v4l2_ctrl_handler_free(&ctx->ctrl_hdlr);
+			return ctx->ctrl_hdlr.error;
 		}
+	}
 
-		ctx_ctrl->type = mfc_ctrl_list[i].type;
-		ctx_ctrl->id = mfc_ctrl_list[i].id;
-		ctx_ctrl->has_new = 0;
-		ctx_ctrl->val = 0;
+	ctx->fh.ctrl_handler = &ctx->ctrl_hdlr;
 
-		list_add_tail(&ctx_ctrl->list, &ctx->ctrls);
-
-		mfc_debug(5, "add ctx ctrl id: 0x%08x\n", ctx_ctrl->id);
-	}
+	ctx->dec_ctrls.min_of_dpb = v4l2_ctrl_find(&ctx->ctrl_hdlr,
+				V4L2_CID_MIN_REQ_BUFS_CAP);
+	ctx->dec_ctrls.loop_filter_mpeg4 = v4l2_ctrl_find(&ctx->ctrl_hdlr,
+				V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER);
+	ctx->dec_ctrls.display_delay = v4l2_ctrl_find(&ctx->ctrl_hdlr,
+				V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY);
+	ctx->dec_ctrls.display_delay_enable = v4l2_ctrl_find(&ctx->ctrl_hdlr,
+				V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE);
+	ctx->dec_ctrls.slice_interface = v4l2_ctrl_find(&ctx->ctrl_hdlr,
+				V4L2_CID_MPEG_DECODER_SLICE_INTERFACE);
 
 	return 0;
 }
 
 static int dec_cleanup_ctx_ctrls(struct s5p_mfc_ctx *ctx)
 {
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
-
-	while (!list_empty(&ctx->ctrls)) {
-		ctx_ctrl = list_entry((&ctx->ctrls)->next,
-				      struct s5p_mfc_ctx_ctrl, list);
 
-		mfc_debug(5, "del ctx ctrl id: 0x%08x\n", ctx_ctrl->id);
-
-		list_del(&ctx_ctrl->list);
-		kfree(ctx_ctrl);
-	}
-
-	INIT_LIST_HEAD(&ctx->ctrls);
+	v4l2_ctrl_handler_free(&ctx->ctrl_hdlr);
 
 	return 0;
 }
@@ -364,30 +414,39 @@ static int dec_init_buf_ctrls(struct s5p_mfc_ctx *ctx,
 
 	INIT_LIST_HEAD(head);
 
-	for (i = 0; i < NUM_CTRL_CFGS; i++) {
-		if (type != mfc_ctrl_list[i].type)
+	for (i = 0; i < NUM_BUF_CTRL_CFGS; i++) {
+		if (type != mfc_buf_ctrl_cfgs[i].type)
 			continue;
 
 		buf_ctrl = kzalloc(sizeof(struct s5p_mfc_buf_ctrl), GFP_KERNEL);
 		if (buf_ctrl == NULL) {
 			mfc_err("failed to allocate buf_ctrl type: %d, id: 0x%08x\n",
-				mfc_ctrl_list[i].type, mfc_ctrl_list[i].id);
+				mfc_buf_ctrl_cfgs[i].type, mfc_buf_ctrl_cfgs[i].id);
+
+			while (!list_empty(head)) {
+				buf_ctrl = list_entry(head->next,
+						      struct s5p_mfc_buf_ctrl, list);
+				list_del(&buf_ctrl->list);
+				kfree(buf_ctrl);
+			}
+
+			INIT_LIST_HEAD(head);
 
 			return -ENOMEM;
 		}
 
-		buf_ctrl->id = mfc_ctrl_list[i].id;
+		buf_ctrl->id = mfc_buf_ctrl_cfgs[i].id;
 		buf_ctrl->has_new = 0;
 		buf_ctrl->val = 0;
 		buf_ctrl->old_val = 0;
-		buf_ctrl->is_volatile = mfc_ctrl_list[i].is_volatile;
-		buf_ctrl->mode = mfc_ctrl_list[i].mode;
-		buf_ctrl->addr = mfc_ctrl_list[i].addr;
-		buf_ctrl->mask = mfc_ctrl_list[i].mask;
-		buf_ctrl->shft = mfc_ctrl_list[i].shft;
-		buf_ctrl->flag_mode = mfc_ctrl_list[i].flag_mode;
-		buf_ctrl->flag_addr = mfc_ctrl_list[i].flag_addr;
-		buf_ctrl->flag_shft = mfc_ctrl_list[i].flag_shft;
+		buf_ctrl->is_volatile = mfc_buf_ctrl_cfgs[i].is_volatile;
+		buf_ctrl->mode = mfc_buf_ctrl_cfgs[i].mode;
+		buf_ctrl->addr = mfc_buf_ctrl_cfgs[i].addr;
+		buf_ctrl->mask = mfc_buf_ctrl_cfgs[i].mask;
+		buf_ctrl->shft = mfc_buf_ctrl_cfgs[i].shft;
+		buf_ctrl->flag_mode = mfc_buf_ctrl_cfgs[i].flag_mode;
+		buf_ctrl->flag_addr = mfc_buf_ctrl_cfgs[i].flag_addr;
+		buf_ctrl->flag_shft = mfc_buf_ctrl_cfgs[i].flag_shft;
 
 		list_add_tail(&buf_ctrl->list, head);
 
@@ -418,33 +477,23 @@ static int dec_cleanup_buf_ctrls(struct s5p_mfc_ctx *ctx, struct list_head *head
 
 static int dec_to_buf_ctrls(struct s5p_mfc_ctx *ctx, struct list_head *head)
 {
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
+	struct v4l2_ctrl *ctx_ctrl;
 	struct s5p_mfc_buf_ctrl *buf_ctrl;
 
-	list_for_each_entry(ctx_ctrl, &ctx->ctrls, list) {
-		if ((ctx_ctrl->type != MFC_CTRL_TYPE_SET) || (!ctx_ctrl->has_new))
+	list_for_each_entry(buf_ctrl, head, list) {
+		ctx_ctrl = v4l2_ctrl_find(&ctx->ctrl_hdlr, buf_ctrl->id);
+		if (!ctx_ctrl)
 			continue;
 
-		list_for_each_entry(buf_ctrl, head, list) {
-			if (buf_ctrl->id == ctx_ctrl->id) {
-				buf_ctrl->has_new = 1;
-				buf_ctrl->val = ctx_ctrl->val;
-				if (buf_ctrl->is_volatile)
-					buf_ctrl->updated = 0;
-
-				/* for test */
-				if (buf_ctrl->val == 5301)
-					buf_ctrl->has_new = 0;
-
-				ctx_ctrl->has_new = 0;
-				break;
-			}
+		if (!v4l2_ctrl_p_ctrl(ctx_ctrl, &buf_ctrl->val)) {
+			buf_ctrl->has_new = 1;
+			if (buf_ctrl->is_volatile)
+				buf_ctrl->updated = 0;
+		} else {
+			mfc_err("failed to control value to buffer\n");
 		}
 	}
 
-	/*
-	mfc_debug(5, "buf ctrls list: %d\n", index);
-	*/
 	list_for_each_entry(buf_ctrl, head, list) {
 		if (buf_ctrl->has_new)
 			mfc_debug(5, "id: 0x%08x val: %d\n",
@@ -456,37 +505,23 @@ static int dec_to_buf_ctrls(struct s5p_mfc_ctx *ctx, struct list_head *head)
 
 static int dec_to_ctx_ctrls(struct s5p_mfc_ctx *ctx, struct list_head *head)
 {
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
+	struct v4l2_ctrl *ctx_ctrl;
 	struct s5p_mfc_buf_ctrl *buf_ctrl;
 
 	list_for_each_entry(buf_ctrl, head, list) {
+		mfc_debug(2, "buf_ctrl->has_new: %d", buf_ctrl->has_new);
+		mfc_debug(2, "buf_ctrl->val: %d", buf_ctrl->val);
+
 		if (!buf_ctrl->has_new)
 			continue;
 
-		list_for_each_entry(ctx_ctrl, &ctx->ctrls, list) {
-			if (ctx_ctrl->type != MFC_CTRL_TYPE_GET)
-				continue;
-
-			if (ctx_ctrl->id == buf_ctrl->id) {
-				/*
-				mfc_debug(!ctx_ctrl->has_new, "overwrite ctx ctrl value\n");
-				*/
-
-				ctx_ctrl->has_new = 1;
-				ctx_ctrl->val = buf_ctrl->val;
-
-				buf_ctrl->has_new = 0;
-			}
-		}
-	}
+		ctx_ctrl = v4l2_ctrl_find(&ctx->ctrl_hdlr, buf_ctrl->id);
+		if (!ctx_ctrl)
+			continue;
 
-	/*
-	mfc_debug(5, "ctx ctrls list: %d\n", index);
-	*/
-	list_for_each_entry(ctx_ctrl, &ctx->ctrls, list) {
-		if (ctx_ctrl->has_new)
-			mfc_debug(5, "id: 0x%08x val: %d\n",
-				  ctx_ctrl->id, ctx_ctrl->val);
+		if (v4l2_ctrl_s_ctrl(ctx_ctrl, buf_ctrl->val))
+			mfc_err("failed to control value to context\n");
+		buf_ctrl->has_new = 0;
 	}
 
 	return 0;
@@ -697,7 +732,7 @@ static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
 /* Get format */
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct v4l2_pix_format_mplane *pix_mp;
 
 	mfc_debug_enter();
@@ -780,7 +815,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	unsigned long flags;
 	int ret = 0;
 	struct s5p_mfc_fmt *fmt;
@@ -859,7 +894,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 					  struct v4l2_requestbuffers *reqbufs)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = 0;
 	unsigned long flags;
 
@@ -954,7 +989,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 static int vidioc_querybuf(struct file *file, void *priv,
 						   struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret;
 	int i;
 
@@ -983,7 +1018,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
 /* Queue a buffer */
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 
 	mfc_debug_enter();
 	mfc_debug(2, "Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
@@ -1002,7 +1037,7 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 /* Dequeue a buffer */
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret;
 
 	mfc_debug_enter();
@@ -1024,7 +1059,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = -EINVAL;
 
 	mfc_debug_enter();
@@ -1044,7 +1079,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 static int vidioc_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret;
 
 	mfc_debug_enter();
@@ -1057,165 +1092,11 @@ static int vidioc_streamoff(struct file *file, void *priv,
 	return ret;
 }
 
-/* Query a ctrl */
-static int vidioc_queryctrl(struct file *file, void *priv,
-			    struct v4l2_queryctrl *qc)
-{
-	struct v4l2_queryctrl *c;
-
-	c = get_ctrl(qc->id);
-	if (!c)
-		return -EINVAL;
-	*qc = *c;
-	return 0;
-}
-
-/* Get ctrl */
-static int vidioc_g_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = priv;
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
-	int ret = 0;
-
-	mfc_debug_enter();
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER:
-		ctrl->value = ctx->loop_filter_mpeg4;
-		break;
-	case V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY:
-		ctrl->value = ctx->display_delay;
-		break;
-	case V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE:
-		ctrl->value = ctx->display_delay_enable;
-		break;
-	case V4L2_CID_MIN_REQ_BUFS_CAP:
-		if (ctx->state >= MFCINST_HEAD_PARSED &&
-		    ctx->state < MFCINST_ABORT) {
-			ctrl->value = ctx->dpb_count;
-			break;
-		} else if (ctx->state != MFCINST_INIT) {
-			v4l2_err(&dev->v4l2_dev, "Decoding not initialised.\n");
-			return -EINVAL;
-		}
-
-		/* Should wait for the header to be parsed */
-		s5p_mfc_clean_ctx_int_flags(ctx);
-		s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_FIMV_R2H_CMD_SEQ_DONE_RET, 0);
-		if (ctx->state >= MFCINST_HEAD_PARSED &&
-		    ctx->state < MFCINST_ABORT) {
-			ctrl->value = ctx->dpb_count;
-		} else {
-			v4l2_err(&dev->v4l2_dev,
-					 "Decoding not initialised.\n");
-			return -EINVAL;
-		}
-		break;
-	case V4L2_CID_MPEG_DECODER_SLICE_INTERFACE:
-		ctrl->value = ctx->slice_interface;
-		break;
-	default:
-		list_for_each_entry(ctx_ctrl, &ctx->ctrls, list) {
-			if (ctx_ctrl->type != MFC_CTRL_TYPE_GET)
-				continue;
-
-			if (ctx_ctrl->id == ctrl->id) {
-				if (ctx_ctrl->has_new) {
-					ctx_ctrl->has_new = 0;
-					ctrl->value = ctx_ctrl->val;
-				} else {
-					ctrl->value = 0;
-				}
-
-				ret = 1;
-				break;
-			}
-		}
-		if (!ret) {
-			v4l2_err(&dev->v4l2_dev, "invalid control 0x%08x\n",
-								ctrl->id);
-			return -EINVAL;
-		}
-	}
-
-	mfc_debug_leave();
-
-	return 0;
-}
-
-/* Set a ctrl */
-static int vidioc_s_ctrl(struct file *file, void *priv,
-			 struct v4l2_control *ctrl)
-{
-	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = priv;
-	struct s5p_mfc_ctx_ctrl *ctx_ctrl;
-	int ret = 0;
-	int stream_on;
-
-	mfc_debug_enter();
-
-	stream_on = ctx->vq_src.streaming || ctx->vq_dst.streaming;
-
-	ret = check_ctrl_val(ctx, ctrl);
-	if (ret != 0)
-		return ret;
-
-	switch (ctrl->id) {
-	case V4L2_CID_MPEG_MFC51_DECODER_MPEG4_DEBLOCK_FILTER:
-		if (stream_on)
-			return -EBUSY;
-		ctx->loop_filter_mpeg4 = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY:
-		if (stream_on)
-			return -EBUSY;
-		ctx->display_delay = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_MFC51_DECODER_H264_DISPLAY_DELAY_ENABLE:
-		if (stream_on)
-			return -EBUSY;
-		ctx->display_delay_enable = ctrl->value;
-		break;
-	case V4L2_CID_MPEG_DECODER_SLICE_INTERFACE:
-		if (stream_on)
-			return -EBUSY;
-		ctx->slice_interface = ctrl->value;
-		break;
-	default:
-		list_for_each_entry(ctx_ctrl, &ctx->ctrls, list) {
-			if (ctx_ctrl->type != MFC_CTRL_TYPE_SET)
-				continue;
-
-			if (ctx_ctrl->id == ctrl->id) {
-				ctx_ctrl->has_new = 1;
-				ctx_ctrl->val = ctrl->value;
-
-				ret = 1;
-				break;
-			}
-		}
-
-		if (!ret) {
-			v4l2_err(&dev->v4l2_dev, "invalid control 0x%08x\n",
-								ctrl->id);
-			return -EINVAL;
-		}
-	}
-
-	mfc_debug_leave();
-
-	return 0;
-}
-
 /* Get cropping information */
 static int vidioc_g_crop(struct file *file, void *priv,
 		struct v4l2_crop *cr)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	u32 left, right, top, bottom;
 
 	mfc_debug_enter();
@@ -1272,9 +1153,6 @@ static const struct v4l2_ioctl_ops s5p_mfc_dec_ioctl_ops = {
 	.vidioc_dqbuf = vidioc_dqbuf,
 	.vidioc_streamon = vidioc_streamon,
 	.vidioc_streamoff = vidioc_streamoff,
-	.vidioc_queryctrl = vidioc_queryctrl,
-	.vidioc_g_ctrl = vidioc_g_ctrl,
-	.vidioc_s_ctrl = vidioc_s_ctrl,
 	.vidioc_g_crop = vidioc_g_crop,
 };
 
@@ -1601,26 +1479,51 @@ static struct vb2_ops s5p_mfc_dec_qops = {
 	.buf_queue	= s5p_mfc_buf_queue,
 };
 
-struct s5p_mfc_codec_ops *get_dec_codec_ops(void)
-{
-	return &decoder_codec_ops;
-}
-
-struct vb2_ops *get_dec_queue_ops(void)
-{
-	return &s5p_mfc_dec_qops;
-}
-
 const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void)
 {
 	return &s5p_mfc_dec_ioctl_ops;
 }
 
-struct s5p_mfc_fmt *get_dec_def_fmt(bool src)
+int s5p_mfc_init_dec_ctx(struct s5p_mfc_ctx *ctx)
 {
-	if (src)
-		return &formats[DEF_SRC_FMT];
-	else
-		return &formats[DEF_DST_FMT];
+	int ret = 0;
+
+	ctx->inst_no = MFC_NO_INSTANCE_SET;
+
+	INIT_LIST_HEAD(&ctx->src_queue);
+	INIT_LIST_HEAD(&ctx->dst_queue);
+	ctx->src_queue_cnt = 0;
+	ctx->dst_queue_cnt = 0;
+
+	ctx->type = MFCINST_DECODER;
+	ctx->c_ops = &decoder_codec_ops;
+	ctx->src_fmt = &formats[DEF_SRC_FMT];
+	ctx->dst_fmt = &formats[DEF_DST_FMT];
+
+	/* Init videobuf2 queue for OUTPUT */
+	ctx->vq_src.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	ctx->vq_src.drv_priv = ctx;
+	ctx->vq_src.io_modes = VB2_MMAP;
+	ctx->vq_src.ops = &s5p_mfc_dec_qops;
+	ctx->vq_src.mem_ops = s5p_mfc_mem_ops();
+	ret = vb2_queue_init(&ctx->vq_src);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(output)\n");
+		return ret;
+	}
+
+	/* Init videobuf2 queue for CAPTURE */
+	ctx->vq_dst.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	ctx->vq_dst.drv_priv = ctx;
+	ctx->vq_dst.io_modes = VB2_MMAP;
+	ctx->vq_dst.ops = &s5p_mfc_dec_qops;
+	ctx->vq_dst.mem_ops = s5p_mfc_mem_ops();
+	ret = vb2_queue_init(&ctx->vq_dst);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
+		return ret;
+	}
+
+	return ret;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
index 12ea5fd..dc1bc0e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_dec.h
@@ -13,9 +13,7 @@
 #ifndef __S5P_MFC_DEC_H_
 #define __S5P_MFC_DEC_H_
 
-struct s5p_mfc_codec_ops *get_dec_codec_ops(void);
-struct vb2_ops *get_dec_queue_ops(void);
 const struct v4l2_ioctl_ops *get_dec_v4l2_ioctl_ops(void);
-struct s5p_mfc_fmt *get_dec_def_fmt(bool src);
+int s5p_mfc_init_dec_ctx(struct s5p_mfc_ctx *ctx);
 
 #endif /* __S5P_MFC_DEC_H_ */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
index 530ff0b..5fe1b8f 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.c
@@ -883,7 +883,7 @@ static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
 
 static int vidioc_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 
 	mfc_debug_enter();
@@ -975,7 +975,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 	unsigned long flags;
@@ -1088,7 +1088,7 @@ out:
 static int vidioc_reqbufs(struct file *file, void *priv,
 					  struct v4l2_requestbuffers *reqbufs)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = 0;
 
 	mfc_debug_enter();
@@ -1153,7 +1153,7 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 static int vidioc_querybuf(struct file *file, void *priv,
 						   struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = 0;
 
 	mfc_debug_enter();
@@ -1221,7 +1221,7 @@ static int vidioc_querybuf(struct file *file, void *priv,
 /* Queue a buffer */
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 
 	mfc_debug_enter();
 	mfc_debug(2, "Enqueued buf: %d (type = %d)\n", buf->index, buf->type);
@@ -1240,7 +1240,7 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 /* Dequeue a buffer */
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret;
 
 	mfc_debug_enter();
@@ -1262,7 +1262,7 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = -EINVAL;
 
 	mfc_debug_enter();
@@ -1286,7 +1286,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 static int vidioc_streamoff(struct file *file, void *priv,
 			    enum v4l2_buf_type type)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret;
 
 	mfc_debug_enter();
@@ -1332,7 +1332,7 @@ static int get_ctrl_val(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
 static int vidioc_g_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = 0;
 
 	ret = get_ctrl_val(ctx, ctrl);
@@ -1596,7 +1596,7 @@ static int set_ctrl_val(struct s5p_mfc_ctx *ctx, struct v4l2_control *ctrl)
 static int vidioc_s_ctrl(struct file *file, void *priv,
 			 struct v4l2_control *ctrl)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	int ret = 0;
 	/*
 	int stream_on;
@@ -1625,7 +1625,7 @@ static int vidioc_s_ctrl(struct file *file, void *priv,
 static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 			      struct v4l2_ext_controls *f)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct v4l2_ext_control *ext_ctrl;
 	struct v4l2_control ctrl;
 	int i;
@@ -1653,7 +1653,7 @@ static int vidioc_g_ext_ctrls(struct file *file, void *priv,
 static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 				struct v4l2_ext_controls *f)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct v4l2_ext_control *ext_ctrl;
 	struct v4l2_control ctrl;
 	int i;
@@ -1693,7 +1693,7 @@ static int vidioc_s_ext_ctrls(struct file *file, void *priv,
 static int vidioc_try_ext_ctrls(struct file *file, void *priv,
 				struct v4l2_ext_controls *f)
 {
-	struct s5p_mfc_ctx *ctx = priv;
+	struct s5p_mfc_ctx *ctx = fh_to_mfc_ctx(priv);
 	struct v4l2_ext_control *ext_ctrl;
 	struct v4l2_control ctrl;
 	int i;
@@ -2058,26 +2058,54 @@ static struct vb2_ops s5p_mfc_enc_qops = {
 	.buf_queue	= s5p_mfc_buf_queue,
 };
 
-struct s5p_mfc_codec_ops *get_enc_codec_ops(void)
-{
-	return &encoder_codec_ops;
-}
-
-struct vb2_ops *get_enc_queue_ops(void)
-{
-	return &s5p_mfc_enc_qops;
-}
-
 const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void)
 {
 	return &s5p_mfc_enc_ioctl_ops;
 }
 
-struct s5p_mfc_fmt *get_enc_def_fmt(bool src)
+int s5p_mfc_init_enc_ctx(struct s5p_mfc_ctx *ctx)
 {
-	if (src)
-		return &formats[DEF_SRC_FMT];
-	else
-		return &formats[DEF_DST_FMT];
+	int ret = 0;
+
+	ctx->inst_no = MFC_NO_INSTANCE_SET;
+
+	INIT_LIST_HEAD(&ctx->src_queue);
+	INIT_LIST_HEAD(&ctx->dst_queue);
+	ctx->src_queue_cnt = 0;
+	ctx->dst_queue_cnt = 0;
+
+	ctx->type = MFCINST_ENCODER;
+	ctx->c_ops = &encoder_codec_ops;
+	ctx->src_fmt = &formats[DEF_SRC_FMT];
+	ctx->dst_fmt = &formats[DEF_DST_FMT];
+
+	INIT_LIST_HEAD(&ctx->ref_queue);
+	ctx->ref_queue_cnt = 0;
+
+	/* Init videobuf2 queue for OUTPUT */
+	ctx->vq_src.type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	ctx->vq_src.drv_priv = ctx;
+	ctx->vq_src.io_modes = VB2_MMAP | VB2_USERPTR;
+	ctx->vq_src.ops = &s5p_mfc_enc_qops;
+	ctx->vq_src.mem_ops = s5p_mfc_mem_ops();
+	ret = vb2_queue_init(&ctx->vq_src);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(output)\n");
+		return ret;
+	}
+
+	/* Init videobuf2 queue for CAPTURE */
+	ctx->vq_dst.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+	ctx->vq_dst.drv_priv = ctx;
+	ctx->vq_dst.io_modes = VB2_MMAP | VB2_USERPTR;
+	ctx->vq_dst.ops = &s5p_mfc_enc_qops;
+	ctx->vq_dst.mem_ops = s5p_mfc_mem_ops();
+	ret = vb2_queue_init(&ctx->vq_dst);
+	if (ret) {
+		mfc_err("Failed to initialize videobuf2 queue(capture)\n");
+		return ret;
+	}
+
+	return 0;
 }
 
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
index a2da457..36e9c0e 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_enc.h
@@ -13,9 +13,7 @@
 #ifndef __S5P_MFC_ENC_H_
 #define __S5P_MFC_ENC_H_
 
-struct s5p_mfc_codec_ops *get_enc_codec_ops(void);
-struct vb2_ops *get_enc_queue_ops(void);
 const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
-struct s5p_mfc_fmt *get_enc_def_fmt(bool src);
+int s5p_mfc_init_enc_ctx(struct s5p_mfc_ctx *ctx);
 
 #endif /* __S5P_MFC_ENC_H_  */
diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
index 24b2e11..5bce265 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_opr.c
@@ -386,7 +386,8 @@ int s5p_mfc_set_dec_frame_buffer(struct s5p_mfc_ctx *ctx)
 		  (void *)buf_addr1, buf_size1,
 		  (void *)buf_addr2, buf_size2);
 	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
-	mfc_debug(2, "Setting display delay to %d\n", ctx->display_delay);
+	mfc_debug(2, "Setting display delay to %d\n",
+		  v4l2_ctrl_g_ctrl(ctx->dec_ctrls.display_delay));
 
 	dpb = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL) & ~S5P_FIMV_DPB_COUNT_MASK;
 	WRITEL(ctx->total_dpb_count | dpb, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
@@ -1110,9 +1111,12 @@ static int s5p_mfc_set_enc_params_h263(struct s5p_mfc_ctx *ctx)
 int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
+	unsigned int reg;
 
 	mfc_debug_enter();
+
 	mfc_debug(2, "InstNo: %d/%d\n", ctx->inst_no, S5P_FIMV_CH_SEQ_HEADER);
+
 	s5p_mfc_set_shared_buffer(ctx);
 	mfc_debug(2, "BUFs: %08x %08x %08x %08x %08x\n",
 		  READL(S5P_FIMV_SI_CH0_DESC_ADR),
@@ -1120,27 +1124,40 @@ int s5p_mfc_init_decode(struct s5p_mfc_ctx *ctx)
 		  READL(S5P_FIMV_SI_CH0_DESC_SIZE),
 		  READL(S5P_FIMV_SI_CH0_SB_ST_ADR),
 		  READL(S5P_FIMV_SI_CH0_SB_FRM_SIZE));
+
 	/* Setup loop filter, for decoding this is only valid for MPEG4 */
 	if (ctx->codec_mode == S5P_FIMV_CODEC_MPEG4_DEC) {
-		mfc_debug(2, "Set loop filter to: %d\n", ctx->loop_filter_mpeg4);
-		WRITEL(ctx->loop_filter_mpeg4, S5P_FIMV_ENC_LF_CTRL);
+		mfc_debug(2, "Set loop filter to: %d\n",
+			  v4l2_ctrl_g_ctrl(ctx->dec_ctrls.loop_filter_mpeg4));
+		WRITEL(v4l2_ctrl_g_ctrl(ctx->dec_ctrls.loop_filter_mpeg4),
+		       S5P_FIMV_ENC_LF_CTRL);
 	} else {
 		WRITEL(0, S5P_FIMV_ENC_LF_CTRL);
 	}
-	WRITEL(((ctx->slice_interface & S5P_FIMV_SLICE_INT_MASK) <<
-		S5P_FIMV_SLICE_INT_SHIFT) | (ctx->display_delay_enable <<
-		S5P_FIMV_DDELAY_ENA_SHIFT) | ((ctx->display_delay &
-		S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT),
-		S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+
+	reg = READL(S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+	reg &= ~(S5P_FIMV_SLICE_INT_MASK << S5P_FIMV_SLICE_INT_SHIFT);
+	reg |= ((v4l2_ctrl_g_ctrl(ctx->dec_ctrls.slice_interface)
+		 & S5P_FIMV_SLICE_INT_MASK) << S5P_FIMV_SLICE_INT_SHIFT);
+	reg &= ~(S5P_FIMV_DDELAY_ENA_MASK << S5P_FIMV_DDELAY_ENA_SHIFT);
+	reg |= ((v4l2_ctrl_g_ctrl(ctx->dec_ctrls.display_delay_enable)
+		 & S5P_FIMV_DDELAY_ENA_MASK) << S5P_FIMV_DDELAY_ENA_SHIFT);
+	reg &= ~(S5P_FIMV_DDELAY_VAL_MASK << S5P_FIMV_DDELAY_VAL_SHIFT);
+	reg |= ((v4l2_ctrl_g_ctrl(ctx->dec_ctrls.display_delay)
+		 & S5P_FIMV_DDELAY_VAL_MASK) << S5P_FIMV_DDELAY_VAL_SHIFT);
+	WRITEL(reg, S5P_FIMV_SI_CH0_DPB_CONF_CTRL);
+
 	if (ctx->codec_mode == S5P_FIMV_CODEC_DIVX311_DEC) {
 		mfc_debug(2, "Setting DivX 3.11 resolution to %dx%d\n",
 					ctx->img_width, ctx->img_height);
 		WRITEL(ctx->img_width, S5P_FIMV_SI_DIVX311_HRESOL);
 		WRITEL(ctx->img_height, S5P_FIMV_SI_DIVX311_VRESOL);
 	}
+
 	WRITEL(
 	((S5P_FIMV_CH_SEQ_HEADER & S5P_FIMV_CH_MASK) << S5P_FIMV_CH_SHIFT)
 				| (ctx->inst_no), S5P_FIMV_SI_CH0_INST_ID);
+
 	mfc_debug_leave();
 	return 0;
 }
-- 
1.7.1

