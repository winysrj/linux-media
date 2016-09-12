Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:44554 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751971AbcILQB3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 12:01:29 -0400
From: Jean-Christophe Trotin <jean-christophe.trotin@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/2] st-hva: add debug file system
Date: Mon, 12 Sep 2016 18:01:15 +0200
Message-ID: <1473696075-9190-3-git-send-email-jean-christophe.trotin@st.com>
In-Reply-To: <1473696075-9190-1-git-send-email-jean-christophe.trotin@st.com>
References: <1473696075-9190-1-git-send-email-jean-christophe.trotin@st.com>
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
- the information about the stream (profile, level, resolution,
  alignment...)
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
 drivers/media/platform/sti/hva/hva-debug.c | 362 +++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva-hw.c    |  39 ++++
 drivers/media/platform/sti/hva/hva-hw.h    |   1 +
 drivers/media/platform/sti/hva/hva-v4l2.c  |  11 +-
 drivers/media/platform/sti/hva/hva.h       |  86 +++++--
 5 files changed, 482 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/sti/hva/hva-debug.c b/drivers/media/platform/sti/hva/hva-debug.c
index 71bbf32..433b1d4 100644
--- a/drivers/media/platform/sti/hva/hva-debug.c
+++ b/drivers/media/platform/sti/hva/hva-debug.c
@@ -5,7 +5,113 @@
  * License terms:  GNU General Public License (GPL), version 2
  */
 
+#include <linux/debugfs.h>
+
 #include "hva.h"
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
+	if (dbg->sys_errors || dbg->encode_errors || dbg->frame_errors) {
+		seq_puts(s, "  |\n  |-[errors]\n");
+		seq_printf(s, "  | |- system=%d\n"
+			      "  | |- encoding=%d\n"
+			      "  | |- frame=%d\n",
+			      dbg->sys_errors,
+			      dbg->encode_errors,
+			      dbg->frame_errors);
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
 
 /*
  * encoding summary
@@ -77,10 +183,52 @@ char *hva_dbg_summary(struct hva_ctx *ctx)
 
 void hva_dbg_perf_begin(struct hva_ctx *ctx)
 {
+	u64 div;
+	u32 period;
+	u32 bitrate;
 	struct hva_ctx_dbg *dbg = &ctx->dbg;
+	ktime_t prev = dbg->begin;
 
 	dbg->begin = ktime_get();
 
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
 	/*
 	 * filter sequences valid for performance:
 	 * - begin/begin (no stream available) is an invalid sequence
@@ -118,8 +266,222 @@ void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream)
 	do_div(div, 100);
 	duration = (u32)div;
 
+	dbg->min_duration = min(duration, dbg->min_duration);
+	dbg->max_duration = max(duration, dbg->max_duration);
 	dbg->total_duration += duration;
 	dbg->cnt_duration++;
 
+	/*
+	 * the average bitrate is based on the total stream size
+	 * and the total encoding periods
+	 */
+	dbg->total_stream_size += bytesused;
+	dbg->window_stream_size += bytesused;
+
 	dbg->is_valid_period = true;
 }
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
+	debugfs_create_file(#name, S_IRUGO, hva->dbg.debugfs_entry, hva, \
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
+	ctx->dbg.debugfs_entry = debugfs_create_file(name, S_IRUGO,
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
index c84b860..d395204 100644
--- a/drivers/media/platform/sti/hva/hva-hw.c
+++ b/drivers/media/platform/sti/hva/hva-hw.c
@@ -9,6 +9,7 @@
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/seq_file.h>
 
 #include "hva.h"
 #include "hva-hw.h"
@@ -541,3 +542,41 @@ out:
 
 	return ret;
 }
+
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
diff --git a/drivers/media/platform/sti/hva/hva-hw.h b/drivers/media/platform/sti/hva/hva-hw.h
index efb45b9..f8df405 100644
--- a/drivers/media/platform/sti/hva/hva-hw.h
+++ b/drivers/media/platform/sti/hva/hva-hw.h
@@ -38,5 +38,6 @@ int hva_hw_runtime_suspend(struct device *dev);
 int hva_hw_runtime_resume(struct device *dev);
 int hva_hw_execute_task(struct hva_ctx *ctx, enum hva_hw_cmd_type cmd,
 			struct hva_buffer *task);
+void hva_hw_dump_regs(struct hva_dev *hva, struct seq_file *s);
 
 #endif /* HVA_HW_H */
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index fb65816..71bb7b3 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -15,8 +15,6 @@
 #include "hva.h"
 #include "hva-hw.h"
 
-#define HVA_NAME "st-hva"
-
 #define MIN_FRAMES	1
 #define MIN_STREAMS	1
 
@@ -1181,6 +1179,8 @@ static int hva_open(struct file *file)
 	/* default parameters for frame and stream */
 	set_default_params(ctx);
 
+	hva_dbg_ctx_create(ctx);
+
 	dev_info(dev, "%s encoder instance created\n", ctx->name);
 
 	return 0;
@@ -1223,6 +1223,8 @@ static int hva_release(struct file *file)
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 
+	hva_dbg_ctx_remove(ctx);
+
 	dev_info(dev, "%s encoder instance released\n", ctx->name);
 
 	kfree(ctx);
@@ -1347,6 +1349,8 @@ static int hva_probe(struct platform_device *pdev)
 		goto err_hw;
 	}
 
+	hva_debugfs_create(hva);
+
 	hva->work_queue = create_workqueue(HVA_NAME);
 	if (!hva->work_queue) {
 		dev_err(dev, "%s %s failed to allocate work queue\n",
@@ -1368,6 +1372,7 @@ static int hva_probe(struct platform_device *pdev)
 err_work_queue:
 	destroy_workqueue(hva->work_queue);
 err_v4l2:
+	hva_debugfs_remove(hva);
 	v4l2_device_unregister(&hva->v4l2_dev);
 err_hw:
 	hva_hw_remove(hva);
@@ -1386,6 +1391,8 @@ static int hva_remove(struct platform_device *pdev)
 
 	hva_hw_remove(hva);
 
+	hva_debugfs_remove(hva);
+
 	v4l2_device_unregister(&hva->v4l2_dev);
 
 	dev_info(dev, "%s %s removed\n", HVA_PREFIX, pdev->name);
diff --git a/drivers/media/platform/sti/hva/hva.h b/drivers/media/platform/sti/hva/hva.h
index badc5f4..eef9769 100644
--- a/drivers/media/platform/sti/hva/hva.h
+++ b/drivers/media/platform/sti/hva/hva.h
@@ -21,7 +21,8 @@
 
 #define ctx_to_hdev(c)  (c->hva_dev)
 
-#define HVA_PREFIX "[---:----]"
+#define HVA_NAME	"st-hva"
+#define HVA_PREFIX	"[---:----]"
 
 extern const struct hva_enc nv12h264enc;
 extern const struct hva_enc nv21h264enc;
@@ -156,22 +157,60 @@ struct hva_stream {
 /**
  * struct hva_ctx_dbg - instance context debug info
  *
- * @is_valid_period: true if the sequence is valid for performance
- * @begin:           start time of last HW task
- * @total_duration:  total HW processing durations in 0.1ms
- * @cnt_duration:    number of HW processings
- * @sys_errors:      number of system errors (memory, resource, pm..)
- * @encode_errors:   number of encoding errors (hw/driver errors)
- * @frame_errors:    number of frame errors (format, size, header...)
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
+ * @sys_errors:         number of system errors (memory, resource, pm..)
+ * @encode_errors:      number of encoding errors (hw/driver errors)
+ * @frame_errors:       number of frame errors (format, size, header...)
  */
 struct hva_ctx_dbg {
-	bool	is_valid_period;
-	ktime_t	begin;
-	u32	total_duration;
-	u32	cnt_duration;
-	u32	sys_errors;
-	u32	encode_errors;
-	u32	frame_errors;
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
+	u32		sys_errors;
+	u32		encode_errors;
+	u32		frame_errors;
 };
 
 struct hva_dev;
@@ -235,6 +274,17 @@ struct hva_ctx {
 #define HVA_FLAG_STREAMINFO	0x0001
 #define HVA_FLAG_FRAMEINFO	0x0002
 
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
+
 #define HVA_MAX_INSTANCES	16
 #define HVA_MAX_ENCODERS	10
 #define HVA_MAX_FORMATS		HVA_MAX_ENCODERS
@@ -273,6 +323,7 @@ struct hva_ctx {
  * @lmi_err_reg:         local memory interface error register value
  * @emi_err_reg:         external memory interface error register value
  * @hec_mif_err_reg:     HEC memory interface error register value
+ * @dbg:             device debug info
  */
 struct hva_dev {
 	struct v4l2_device	v4l2_dev;
@@ -307,6 +358,7 @@ struct hva_dev {
 	u32			lmi_err_reg;
 	u32			emi_err_reg;
 	u32			hec_mif_err_reg;
+	struct hva_dev_dbg	dbg;
 };
 
 /**
@@ -335,6 +387,10 @@ struct hva_enc {
 				  struct hva_stream *stream);
 };
 
+void hva_debugfs_create(struct hva_dev *hva);
+void hva_debugfs_remove(struct hva_dev *hva);
+void hva_dbg_ctx_create(struct hva_ctx *ctx);
+void hva_dbg_ctx_remove(struct hva_ctx *ctx);
 char *hva_dbg_summary(struct hva_ctx *ctx);
 void hva_dbg_perf_begin(struct hva_ctx *ctx);
 void hva_dbg_perf_end(struct hva_ctx *ctx, struct hva_stream *stream);
-- 
1.9.1

