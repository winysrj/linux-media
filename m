Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:40294 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751004AbdAaKjJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 05:39:09 -0500
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v4 2/2] st-hva: add debug file system
Date: Tue, 31 Jan 2017 11:37:57 +0100
Message-ID: <1485859077-348-3-git-send-email-jean-christophe.trotin@st.com>
In-Reply-To: <1485859077-348-1-git-send-email-jean-christophe.trotin@st.com>
References: <1485859077-348-1-git-send-email-jean-christophe.trotin@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch creates 4 static debugfs entries to dump:
- the device-related information ("st-hva/device")
- the list of registered encoders ("st-hva/encoders")
- the current values of the hva registers ("st-hva/regs")
- the information about the last closed instance ("st-hva/last")

It also creates dynamically a debugfs entry for each opened instance,
("st-hva/<instance identifier>") to dump:
- the information about the frame (format, resolution)
- the information about the stream (format, profile, level,
  resolution)
- the control parameters (bitrate mode, framerate, GOP size...)
- the potential (system, encoding...) errors
- the performance information about the encoding (HW processing
  duration, average bitrate, average framerate...)
Each time a running instance is closed, its context (including the
debug information) is saved to feed, on demand, the last closed
instance debugfs entry.

Signed-off-by: Yannick Fertre <yannick.fertre@st.com>
Signed-off-by: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
---
 drivers/media/platform/Kconfig               |  11 +
 drivers/media/platform/sti/hva/Makefile      |   1 +
 drivers/media/platform/sti/hva/hva-debugfs.c | 422 +++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva-hw.c      |  43 +++
 drivers/media/platform/sti/hva/hva-hw.h      |   3 +
 drivers/media/platform/sti/hva/hva-v4l2.c    |  29 +-
 drivers/media/platform/sti/hva/hva.h         |  88 +++++-
 7 files changed, 594 insertions(+), 3 deletions(-)
 create mode 100644 drivers/media/platform/sti/hva/hva-debugfs.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index d944421..af72641 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -298,6 +298,17 @@ config VIDEO_STI_HVA
 	  To compile this driver as a module, choose M here:
 	  the module will be called st-hva.
 
+config VIDEO_STI_HVA_DEBUGFS
+	bool "Export STMicroelectronics HVA internals in debugfs"
+	depends on VIDEO_STI_HVA
+	depends on DEBUG_FS
+	help
+	  Select this to see information about the internal state and the last
+          operation of STMicroelectronics HVA multi-format video encoder in
+          debugfs.
+
+          Choose N unless you know you need this.
+
 config VIDEO_SH_VEU
 	tristate "SuperH VEU mem2mem video processing driver"
 	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
diff --git a/drivers/media/platform/sti/hva/Makefile b/drivers/media/platform/sti/hva/Makefile
index ffb69ce..e3ebe968 100644
--- a/drivers/media/platform/sti/hva/Makefile
+++ b/drivers/media/platform/sti/hva/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_VIDEO_STI_HVA) := st-hva.o
 st-hva-y := hva-v4l2.o hva-hw.o hva-mem.o hva-h264.o
+st-hva-$(CONFIG_VIDEO_STI_HVA_DEBUGFS) += hva-debugfs.o
diff --git a/drivers/media/platform/sti/hva/hva-debugfs.c b/drivers/media/platform/sti/hva/hva-debugfs.c
new file mode 100644
index 0000000..83a6258
--- /dev/null
+++ b/drivers/media/platform/sti/hva/hva-debugfs.c
@@ -0,0 +1,422 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Authors: Yannick Fertre <yannick.fertre@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/debugfs.h>
+
+#include "hva.h"
+#include "hva-hw.h"
+
+static void format_ctx(struct seq_file *s, struct hva_ctx *ctx)
+{
+	struct hva_streaminfo *stream = &ctx->streaminfo;
+	struct hva_frameinfo *frame = &ctx->frameinfo;
+	struct hva_controls *ctrls = &ctx->ctrls;
+	struct hva_ctx_dbg *dbg = &ctx->dbg;
+	u32 bitrate_mode, aspect, entropy, vui_sar, sei_fp;
+
+	seq_printf(s, "|-%s\n  |\n", ctx->name);
+
+	seq_printf(s, "  |-[%sframe info]\n",
+		   ctx->flags & HVA_FLAG_FRAMEINFO ? "" : "default ");
+	seq_printf(s, "  | |- pixel format=%4.4s\n"
+		      "  | |- wxh=%dx%d\n"
+		      "  | |- wxh (w/ encoder alignment constraint)=%dx%d\n"
+		      "  |\n",
+		      (char *)&frame->pixelformat,
+		      frame->width, frame->height,
+		      frame->aligned_width, frame->aligned_height);
+
+	seq_printf(s, "  |-[%sstream info]\n",
+		   ctx->flags & HVA_FLAG_STREAMINFO ? "" : "default ");
+	seq_printf(s, "  | |- stream format=%4.4s\n"
+		      "  | |- wxh=%dx%d\n"
+		      "  | |- %s\n"
+		      "  | |- %s\n"
+		      "  |\n",
+		      (char *)&stream->streamformat,
+		      stream->width, stream->height,
+		      stream->profile, stream->level);
+
+	bitrate_mode = V4L2_CID_MPEG_VIDEO_BITRATE_MODE;
+	aspect = V4L2_CID_MPEG_VIDEO_ASPECT;
+	seq_puts(s, "  |-[parameters]\n");
+	seq_printf(s, "  | |- %s\n"
+		      "  | |- bitrate=%d bps\n"
+		      "  | |- GOP size=%d\n"
+		      "  | |- video aspect=%s\n"
+		      "  | |- framerate=%d/%d\n",
+		      v4l2_ctrl_get_menu(bitrate_mode)[ctrls->bitrate_mode],
+		      ctrls->bitrate,
+		      ctrls->gop_size,
+		      v4l2_ctrl_get_menu(aspect)[ctrls->aspect],
+		      ctrls->time_per_frame.denominator,
+		      ctrls->time_per_frame.numerator);
+
+	entropy = V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE;
+	vui_sar = V4L2_CID_MPEG_VIDEO_H264_VUI_SAR_IDC;
+	sei_fp =  V4L2_CID_MPEG_VIDEO_H264_SEI_FP_ARRANGEMENT_TYPE;
+	if (stream->streamformat == V4L2_PIX_FMT_H264) {
+		seq_printf(s, "  | |- %s entropy mode\n"
+			      "  | |- CPB size=%d kB\n"
+			      "  | |- DCT8x8 enable=%s\n"
+			      "  | |- qpmin=%d\n"
+			      "  | |- qpmax=%d\n"
+			      "  | |- PAR enable=%s\n"
+			      "  | |- PAR id=%s\n"
+			      "  | |- SEI frame packing enable=%s\n"
+			      "  | |- SEI frame packing type=%s\n",
+			      v4l2_ctrl_get_menu(entropy)[ctrls->entropy_mode],
+			      ctrls->cpb_size,
+			      ctrls->dct8x8 ? "true" : "false",
+			      ctrls->qpmin,
+			      ctrls->qpmax,
+			      ctrls->vui_sar ? "true" : "false",
+			      v4l2_ctrl_get_menu(vui_sar)[ctrls->vui_sar_idc],
+			      ctrls->sei_fp ? "true" : "false",
+			      v4l2_ctrl_get_menu(sei_fp)[ctrls->sei_fp_type]);
+	}
+
+	if (ctx->sys_errors || ctx->encode_errors || ctx->frame_errors) {
+		seq_puts(s, "  |\n  |-[errors]\n");
+		seq_printf(s, "  | |- system=%d\n"
+			      "  | |- encoding=%d\n"
+			      "  | |- frame=%d\n",
+			      ctx->sys_errors,
+			      ctx->encode_errors,
+			      ctx->frame_errors);
+	}
+
+	seq_puts(s, "  |\n  |-[performances]\n");
+	seq_printf(s, "  | |- frames encoded=%d\n"
+		      "  | |- avg HW processing duration (0.1ms)=%d [min=%d, max=%d]\n"
+		      "  | |- avg encoding period (0.1ms)=%d [min=%d, max=%d]\n"
+		      "  | |- avg fps (0.1Hz)=%d\n"
+		      "  | |- max reachable fps (0.1Hz)=%d\n"
+		      "  | |- avg bitrate (kbps)=%d [min=%d, max=%d]\n"
+		      "  | |- last bitrate (kbps)=%d\n",
+		      dbg->cnt_duration,
+		      dbg->avg_duration,
+		      dbg->min_duration,
+		      dbg->max_duration,
+		      dbg->avg_period,
+		      dbg->min_period,
+		      dbg->max_period,
+		      dbg->avg_fps,
+		      dbg->max_fps,
+		      dbg->avg_bitrate,
+		      dbg->min_bitrate,
+		      dbg->max_bitrate,
+		      dbg->last_bitrate);
+}
+
+/*
+ * performance debug info
+ */
+void hva_dbg_perf_begin(struct hva_ctx *ctx)
+{
+	u64 div;
+	u32 period;
+	u32 bitrate;
+	struct hva_ctx_dbg *dbg = &ctx->dbg;
+	ktime_t prev = dbg->begin;
+
+	dbg->begin = ktime_get();
+
+	if (dbg->is_valid_period) {
+		/* encoding period */
+		div = (u64)ktime_us_delta(dbg->begin, prev);
+		do_div(div, 100);
+		period = (u32)div;
+		dbg->min_period = min(period, dbg->min_period);
+		dbg->max_period = max(period, dbg->max_period);
+		dbg->total_period += period;
+		dbg->cnt_period++;
+
+		/*
+		 * minimum and maximum bitrates are based on the
+		 * encoding period values upon a window of 32 samples
+		 */
+		dbg->window_duration += period;
+		dbg->cnt_window++;
+		if (dbg->cnt_window >= 32) {
+			/*
+			 * bitrate in kbps = (size * 8 / 1000) /
+			 *                   (duration / 10000)
+			 *                 = size * 80 / duration
+			 */
+			if (dbg->window_duration > 0) {
+				div = (u64)dbg->window_stream_size * 80;
+				do_div(div, dbg->window_duration);
+				bitrate = (u32)div;
+				dbg->last_bitrate = bitrate;
+				dbg->min_bitrate = min(bitrate,
+						       dbg->min_bitrate);
+				dbg->max_bitrate = max(bitrate,
+						       dbg->max_bitrate);
+			}
+			dbg->window_stream_size = 0;
+			dbg->window_duration = 0;
+			dbg->cnt_window = 0;
+		}
+	}
+
+	/*
+	 * filter sequences valid for performance:
+	 * - begin/begin (no stream available) is an invalid sequence
+	 * - begin/end is a valid sequence
+	 */
+	dbg->is_valid_period = false;
+}
+
+void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream)
+{
+	struct device *dev = ctx_to_dev(ctx);
+	u64 div;
+	u32 duration;
+	u32 bytesused;
+	u32 timestamp;
+	struct hva_ctx_dbg *dbg = &ctx->dbg;
+	ktime_t end = ktime_get();
+
+	/* stream bytesused and timestamp in us */
+	bytesused = vb2_get_plane_payload(&stream->vbuf.vb2_buf, 0);
+	div = stream->vbuf.vb2_buf.timestamp;
+	do_div(div, 1000);
+	timestamp = (u32)div;
+
+	/* encoding duration */
+	div = (u64)ktime_us_delta(end, dbg->begin);
+
+	dev_dbg(dev,
+		"%s perf stream[%d] dts=%d encoded using %d bytes in %d us",
+		ctx->name,
+		stream->vbuf.sequence,
+		timestamp,
+		bytesused, (u32)div);
+
+	do_div(div, 100);
+	duration = (u32)div;
+
+	dbg->min_duration = min(duration, dbg->min_duration);
+	dbg->max_duration = max(duration, dbg->max_duration);
+	dbg->total_duration += duration;
+	dbg->cnt_duration++;
+
+	/*
+	 * the average bitrate is based on the total stream size
+	 * and the total encoding periods
+	 */
+	dbg->total_stream_size += bytesused;
+	dbg->window_stream_size += bytesused;
+
+	dbg->is_valid_period = true;
+}
+
+static void hva_dbg_perf_compute(struct hva_ctx *ctx)
+{
+	u64 div;
+	struct hva_ctx_dbg *dbg = &ctx->dbg;
+
+	if (dbg->cnt_duration > 0) {
+		div = (u64)dbg->total_duration;
+		do_div(div, dbg->cnt_duration);
+		dbg->avg_duration = (u32)div;
+	} else {
+		dbg->avg_duration = 0;
+	}
+
+	if (dbg->total_duration > 0) {
+		div = (u64)dbg->cnt_duration * 100000;
+		do_div(div, dbg->total_duration);
+		dbg->max_fps = (u32)div;
+	} else {
+		dbg->max_fps = 0;
+	}
+
+	if (dbg->cnt_period > 0) {
+		div = (u64)dbg->total_period;
+		do_div(div, dbg->cnt_period);
+		dbg->avg_period = (u32)div;
+	} else {
+		dbg->avg_period = 0;
+	}
+
+	if (dbg->total_period > 0) {
+		div = (u64)dbg->cnt_period * 100000;
+		do_div(div, dbg->total_period);
+		dbg->avg_fps = (u32)div;
+	} else {
+		dbg->avg_fps = 0;
+	}
+
+	if (dbg->total_period > 0) {
+		/*
+		 * bitrate in kbps = (video size * 8 / 1000) /
+		 *                   (video duration / 10000)
+		 *                 = video size * 80 / video duration
+		 */
+		div = (u64)dbg->total_stream_size * 80;
+		do_div(div, dbg->total_period);
+		dbg->avg_bitrate = (u32)div;
+	} else {
+		dbg->avg_bitrate = 0;
+	}
+}
+
+/*
+ * device debug info
+ */
+
+static int hva_dbg_device(struct seq_file *s, void *data)
+{
+	struct hva_dev *hva = s->private;
+
+	seq_printf(s, "[%s]\n", hva->v4l2_dev.name);
+	seq_printf(s, "registered as /dev/video%d\n", hva->vdev->num);
+
+	return 0;
+}
+
+static int hva_dbg_encoders(struct seq_file *s, void *data)
+{
+	struct hva_dev *hva = s->private;
+	unsigned int i = 0;
+
+	seq_printf(s, "[encoders]\n|- %d registered encoders:\n",
+		   hva->nb_of_encoders);
+
+	while (hva->encoders[i]) {
+		seq_printf(s, "|- %s: %4.4s => %4.4s\n", hva->encoders[i]->name,
+			   (char *)&hva->encoders[i]->pixelformat,
+			   (char *)&hva->encoders[i]->streamformat);
+		i++;
+	}
+
+	return 0;
+}
+
+static int hva_dbg_last(struct seq_file *s, void *data)
+{
+	struct hva_dev *hva = s->private;
+	struct hva_ctx *last_ctx = &hva->dbg.last_ctx;
+
+	if (last_ctx->flags & HVA_FLAG_STREAMINFO) {
+		seq_puts(s, "[last encoding]\n");
+
+		hva_dbg_perf_compute(last_ctx);
+		format_ctx(s, last_ctx);
+	} else {
+		seq_puts(s, "[no information recorded about last encoding]\n");
+	}
+
+	return 0;
+}
+
+static int hva_dbg_regs(struct seq_file *s, void *data)
+{
+	struct hva_dev *hva = s->private;
+
+	hva_hw_dump_regs(hva, s);
+
+	return 0;
+}
+
+#define hva_dbg_declare(name)						  \
+	static int hva_dbg_##name##_open(struct inode *i, struct file *f) \
+	{								  \
+		return single_open(f, hva_dbg_##name, i->i_private);	  \
+	}								  \
+	static const struct file_operations hva_dbg_##name##_fops = {	  \
+		.open		= hva_dbg_##name##_open,		  \
+		.read		= seq_read,				  \
+		.llseek		= seq_lseek,				  \
+		.release	= single_release,			  \
+	}
+
+#define hva_dbg_create_entry(name)					 \
+	debugfs_create_file(#name, 0444, hva->dbg.debugfs_entry, hva, \
+			    &hva_dbg_##name##_fops)
+
+hva_dbg_declare(device);
+hva_dbg_declare(encoders);
+hva_dbg_declare(last);
+hva_dbg_declare(regs);
+
+void hva_debugfs_create(struct hva_dev *hva)
+{
+	hva->dbg.debugfs_entry = debugfs_create_dir(HVA_NAME, NULL);
+	if (!hva->dbg.debugfs_entry)
+		goto err;
+
+	if (!hva_dbg_create_entry(device))
+		goto err;
+
+	if (!hva_dbg_create_entry(encoders))
+		goto err;
+
+	if (!hva_dbg_create_entry(last))
+		goto err;
+
+	if (!hva_dbg_create_entry(regs))
+		goto err;
+
+	return;
+
+err:
+	hva_debugfs_remove(hva);
+}
+
+void hva_debugfs_remove(struct hva_dev *hva)
+{
+	debugfs_remove_recursive(hva->dbg.debugfs_entry);
+	hva->dbg.debugfs_entry = NULL;
+}
+
+/*
+ * context (instance) debug info
+ */
+
+static int hva_dbg_ctx(struct seq_file *s, void *data)
+{
+	struct hva_ctx *ctx = s->private;
+
+	seq_printf(s, "[running encoding %d]\n", ctx->id);
+
+	hva_dbg_perf_compute(ctx);
+	format_ctx(s, ctx);
+
+	return 0;
+}
+
+hva_dbg_declare(ctx);
+
+void hva_dbg_ctx_create(struct hva_ctx *ctx)
+{
+	struct hva_dev *hva = ctx->hva_dev;
+	char name[4] = "";
+
+	ctx->dbg.min_duration = UINT_MAX;
+	ctx->dbg.min_period = UINT_MAX;
+	ctx->dbg.min_bitrate = UINT_MAX;
+
+	snprintf(name, sizeof(name), "%d", hva->instance_id);
+
+	ctx->dbg.debugfs_entry = debugfs_create_file(name, 0444,
+						     hva->dbg.debugfs_entry,
+						     ctx, &hva_dbg_ctx_fops);
+}
+
+void hva_dbg_ctx_remove(struct hva_ctx *ctx)
+{
+	struct hva_dev *hva = ctx->hva_dev;
+
+	if (ctx->flags & HVA_FLAG_STREAMINFO)
+		/* save context before removing */
+		memcpy(&hva->dbg.last_ctx, ctx, sizeof(*ctx));
+
+	debugfs_remove(ctx->dbg.debugfs_entry);
+}
diff --git a/drivers/media/platform/sti/hva/hva-hw.c b/drivers/media/platform/sti/hva/hva-hw.c
index 5104068..ec25bdc 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -9,6 +9,9 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+#include <linux/seq_file.h>
+#endif
 
 #include "hva.h"
 #include "hva-hw.h"
@@ -541,3 +544,43 @@ int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
 
 	return ret;
 }
+
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+#define DUMP(reg) seq_printf(s, "%-30s: 0x%08X\n",\
+			     #reg, readl_relaxed(hva->regs + reg))
+
+void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s)
+{
+	struct device *dev = hva_to_dev(hva);
+
+	mutex_lock(&hva->protect_mutex);
+
+	if (pm_runtime_get_sync(dev) < 0) {
+		seq_puts(s, "Cannot wake up IP\n");
+		mutex_unlock(&hva->protect_mutex);
+		return;
+	}
+
+	seq_printf(s, "Registers:\nReg @ = 0x%p\n", hva->regs);
+
+	DUMP(HVA_HIF_REG_RST);
+	DUMP(HVA_HIF_REG_RST_ACK);
+	DUMP(HVA_HIF_REG_MIF_CFG);
+	DUMP(HVA_HIF_REG_HEC_MIF_CFG);
+	DUMP(HVA_HIF_REG_CFL);
+	DUMP(HVA_HIF_REG_SFL);
+	DUMP(HVA_HIF_REG_LMI_ERR);
+	DUMP(HVA_HIF_REG_EMI_ERR);
+	DUMP(HVA_HIF_REG_HEC_MIF_ERR);
+	DUMP(HVA_HIF_REG_HEC_STS);
+	DUMP(HVA_HIF_REG_HVC_STS);
+	DUMP(HVA_HIF_REG_HJE_STS);
+	DUMP(HVA_HIF_REG_CNT);
+	DUMP(HVA_HIF_REG_HEC_CHKSYN_DIS);
+	DUMP(HVA_HIF_REG_CLK_GATING);
+	DUMP(HVA_HIF_REG_VERSION);
+
+	pm_runtime_put_autosuspend(dev);
+	mutex_unlock(&hva->protect_mutex);
+}
+#endif
diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/platform/sti/hva/hva-hw.h
index efb45b9..b46017d 100644
--- a/drivers/media/platform/sti/hva/hva-hw.h
+++ b/drivers/media/platform/sti/hva/hva-hw.h
@@ -38,5 +38,8 @@ enum hva_hw_cmd_type {
 int hva_hw_runtime_resume(struct device *dev);
 int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
 			struct hva_buffer *task);
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s);
+#endif
 
 #endif /* HVA_HW_H */
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 65e94b3..052f2fe 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -15,8 +15,6 @@
 #include "hva.h"
 #include "hva-hw.h"
 
-#define HVA_NAME "st-hva"
-
 #define MIN_FRAMES	1
 #define MIN_STREAMS	1
 
@@ -813,6 +811,10 @@ static void hva_run_work(struct work_struct *work)
 	/* protect instance against reentrancy */
 	mutex_lock(&ctx->lock);
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_dbg_perf_begin(ctx);
+#endif
+
 	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 
@@ -834,6 +836,10 @@ static void hva_run_work(struct work_struct *work)
 
 		ctx->encoded_frames++;
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+		hva_dbg_perf_end(ctx, stream);
+#endif
+
 		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 	}
@@ -1201,6 +1207,10 @@ static int hva_open(struct file *file)
 	/* default parameters for frame and stream */
 	set_default_params(ctx);
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_dbg_ctx_create(ctx);
+#endif
+
 	dev_info(dev, "%s encoder instance created\n", ctx->name);
 
 	return 0;
@@ -1242,6 +1252,10 @@ static int hva_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_dbg_ctx_remove(ctx);
+#endif
+
 	dev_info(dev, "%s encoder instance released\n", ctx->name);
 
 	kfree(ctx);
@@ -1366,6 +1380,10 @@ static int hva_probe(struct platform_device *pdev)
 		goto err_hw;
 	}
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_debugfs_create(hva);
+#endif
+
 	hva->work_queue = create_workqueue(HVA_NAME);
 	if (!hva->work_queue) {
 		dev_err(dev, "%s %s failed to allocate work queue\n",
@@ -1387,6 +1405,9 @@ static int hva_probe(struct platform_device *pdev)
 err_work_queue:
 	destroy_workqueue(hva->work_queue);
 err_v4l2:
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_debugfs_remove(hva);
+#endif
 	v4l2_device_unregister(&hva->v4l2_dev);
 err_hw:
 	hva_hw_remove(hva);
@@ -1405,6 +1426,10 @@ static int hva_remove(struct platform_device *pdev)
 
 	hva_hw_remove(hva);
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	hva_debugfs_remove(hva);
+#endif
+
 	v4l2_device_unregister(&hva->v4l2_dev);
 
 	dev_info(dev, "%s %s removed\n", HVA_PREFIX, pdev->name);
diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
index 1e30abe..0d749b2 100644
--- a/drivers/media/platform/sti/hva/hva.h
+++ b/drivers/media/platform/sti/hva/hva.h
@@ -21,7 +21,8 @@
 
 #define ctx_to_hdev(c)  (c->hva_dev)
 
-#define HVA_PREFIX "[---:----]"
+#define HVA_NAME	"st-hva"
+#define HVA_PREFIX	"[---:----]"
 
 extern const struct hva_enc nv12h264enc;
 extern const struct hva_enc nv21h264enc;
@@ -153,6 +154,61 @@ struct hva_stream {
 #define to_hva_stream(vb) \
 	container_of(vb, struct hva_stream, vbuf)
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+/**
+ * struct hva_ctx_dbg - instance context debug info
+ *
+ * @debugfs_entry:      debugfs entry
+ * @is_valid_period:    true if the sequence is valid for performance
+ * @begin:              start time of last HW task
+ * @total_duration:     total HW processing durations in 0.1ms
+ * @cnt_duration:       number of HW processings
+ * @min_duration:       minimum HW processing duration in 0.1ms
+ * @max_duration:       maximum HW processing duration in 0.1ms
+ * @avg_duration:       average HW processing duration in 0.1ms
+ * @max_fps:            maximum frames encoded per second (in 0.1Hz)
+ * @total_period:       total encoding periods in 0.1ms
+ * @cnt_period:         number of periods
+ * @min_period:         minimum encoding period in 0.1ms
+ * @max_period:         maximum encoding period in 0.1ms
+ * @avg_period:         average encoding period in 0.1ms
+ * @total_stream_size:  total number of encoded bytes
+ * @avg_fps:            average frames encoded per second (in 0.1Hz)
+ * @window_duration:    duration of the sampling window in 0.1ms
+ * @cnt_window:         number of samples in the window
+ * @window_stream_size: number of encoded bytes upon the sampling window
+ * @last_bitrate:       bitrate upon the last sampling window
+ * @min_bitrate:        minimum bitrate in kbps
+ * @max_bitrate:        maximum bitrate in kbps
+ * @avg_bitrate:        average bitrate in kbps
+ */
+struct hva_ctx_dbg {
+	struct dentry	*debugfs_entry;
+	bool		is_valid_period;
+	ktime_t		begin;
+	u32		total_duration;
+	u32		cnt_duration;
+	u32		min_duration;
+	u32		max_duration;
+	u32		avg_duration;
+	u32		max_fps;
+	u32		total_period;
+	u32		cnt_period;
+	u32		min_period;
+	u32		max_period;
+	u32		avg_period;
+	u32		total_stream_size;
+	u32		avg_fps;
+	u32		window_duration;
+	u32		cnt_window;
+	u32		window_stream_size;
+	u32		last_bitrate;
+	u32		min_bitrate;
+	u32		max_bitrate;
+	u32		avg_bitrate;
+};
+#endif
+
 struct hva_dev;
 struct hva_enc;
 
@@ -186,6 +242,7 @@ struct hva_stream {
  * @sys_errors:      number of system errors (memory, resource, pm...)
  * @encode_errors:   number of encoding errors (hw/driver errors)
  * @frame_errors:    number of frame errors (format, size, header...)
+ * @dbg:             context debug info
  */
 struct hva_ctx {
 	struct hva_dev		        *hva_dev;
@@ -215,11 +272,27 @@ struct hva_ctx {
 	u32				sys_errors;
 	u32				encode_errors;
 	u32				frame_errors;
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	struct hva_ctx_dbg		dbg;
+#endif
 };
 
 #define HVA_FLAG_STREAMINFO	0x0001
 #define HVA_FLAG_FRAMEINFO	0x0002
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+/**
+ * struct hva_dev_dbg - device debug info
+ *
+ * @debugfs_entry: debugfs entry
+ * @last_ctx:      debug information about last running instance context
+ */
+struct hva_dev_dbg {
+	struct dentry	*debugfs_entry;
+	struct hva_ctx	last_ctx;
+};
+#endif
+
 #define HVA_MAX_INSTANCES	16
 #define HVA_MAX_ENCODERS	10
 #define HVA_MAX_FORMATS		HVA_MAX_ENCODERS
@@ -258,6 +331,7 @@ struct hva_ctx {
  * @lmi_err_reg:         local memory interface error register value
  * @emi_err_reg:         external memory interface error register value
  * @hec_mif_err_reg:     HEC memory interface error register value
+ * @dbg:                 device debug info
  */
 struct hva_dev {
 	struct v4l2_device	v4l2_dev;
@@ -292,6 +366,9 @@ struct hva_dev {
 	u32			lmi_err_reg;
 	u32			emi_err_reg;
 	u32			hec_mif_err_reg;
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+	struct hva_dev_dbg	dbg;
+#endif
 };
 
 /**
@@ -320,4 +397,13 @@ struct hva_enc {
 				  struct hva_stream *stream);
 };
 
+#ifdef CONFIG_VIDEO_STI_HVA_DEBUGFS
+void hva_debugfs_create(struct hva_dev *hva);
+void hva_debugfs_remove(struct hva_dev *hva);
+void hva_dbg_ctx_create(struct hva_ctx *ctx);
+void hva_dbg_ctx_remove(struct hva_ctx *ctx);
+void hva_dbg_perf_begin(struct hva_ctx *ctx);
+void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream);
+#endif
+
 #endif /* HVA_H */
-- 
1.9.1

