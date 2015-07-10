Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48650 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbGJNhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2015 09:37:32 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: Use S_PARM to set nominal framerate for h.264 encoder
Date: Fri, 10 Jul 2015 15:37:24 +0200
Message-Id: <1436535444-29560-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The encoder needs to know the nominal framerate for the constant bitrate
control mechanism to work. Currently the only way to set the framerate is
by using VIDIOC_S_PARM on the output queue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 102 ++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda_regs.h   |   4 ++
 2 files changed, 106 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 367b6ba..351b4124 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -15,6 +15,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
+#include <linux/gcd.h>
 #include <linux/genalloc.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -770,6 +771,104 @@ static int coda_decoder_cmd(struct file *file, void *fh,
 	return 0;
 }
 
+static int coda_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_fract *tpf;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL,
+
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+	tpf = &a->parm.output.timeperframe;
+	tpf->denominator = ctx->params.framerate & CODA_FRATE_RES_MASK;
+	tpf->numerator = 1 + (ctx->params.framerate >>
+			      CODA_FRATE_DIV_OFFSET);
+
+	return 0;
+}
+
+/*
+ * Approximate timeperframe v4l2_fract with values that can be written
+ * into the 16-bit CODA_FRATE_DIV and CODA_FRATE_RES fields.
+ */
+static void coda_approximate_timeperframe(struct v4l2_fract *timeperframe)
+{
+	struct v4l2_fract s = *timeperframe;
+	struct v4l2_fract f0;
+	struct v4l2_fract f1 = { 1, 0 };
+	struct v4l2_fract f2 = { 0, 1 };
+	unsigned int i, div, s_denominator;
+
+	/* Lower bound is 1/65535 */
+	if (s.numerator == 0 || s.denominator / s.numerator > 65535) {
+		timeperframe->numerator = 1;
+		timeperframe->denominator = 65535;
+		return;
+	}
+
+	/* Upper bound is 65536/1, map everything above to infinity */
+	if (s.denominator == 0 || s.numerator / s.denominator > 65536) {
+		timeperframe->numerator = 1;
+		timeperframe->denominator = 0;
+		return;
+	}
+
+	/* Reduce fraction to lowest terms */
+	div = gcd(s.numerator, s.denominator);
+	if (div > 1) {
+		s.numerator /= div;
+		s.denominator /= div;
+	}
+
+	if (s.numerator <= 65536 && s.denominator < 65536) {
+		*timeperframe = s;
+		return;
+	}
+
+	/* Find successive convergents from continued fraction expansion */
+	while (f2.numerator <= 65536 && f2.denominator < 65536) {
+		f0 = f1;
+		f1 = f2;
+
+		/* Stop when f2 exactly equals timeperframe */
+		if (s.numerator == 0)
+			break;
+
+		i = s.denominator / s.numerator;
+
+		f2.numerator = f0.numerator + i * f1.numerator;
+		f2.denominator = f0.denominator + i * f2.denominator;
+
+		s_denominator = s.numerator;
+		s.numerator = s.denominator % s.numerator;
+		s.denominator = s_denominator;
+	}
+
+	*timeperframe = f1;
+}
+
+static uint32_t coda_timeperframe_to_frate(struct v4l2_fract *timeperframe)
+{
+	return ((timeperframe->numerator - 1) << CODA_FRATE_DIV_OFFSET) |
+		timeperframe->denominator;
+}
+
+static int coda_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct coda_ctx *ctx = fh_to_ctx(fh);
+	struct v4l2_fract *tpf;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		return -EINVAL;
+
+	tpf = &a->parm.output.timeperframe;
+	coda_approximate_timeperframe(tpf);
+	ctx->params.framerate = coda_timeperframe_to_frate(tpf);
+
+	return 0;
+}
+
 static int coda_subscribe_event(struct v4l2_fh *fh,
 				const struct v4l2_event_subscription *sub)
 {
@@ -810,6 +909,9 @@ static const struct v4l2_ioctl_ops coda_ioctl_ops = {
 	.vidioc_try_decoder_cmd	= coda_try_decoder_cmd,
 	.vidioc_decoder_cmd	= coda_decoder_cmd,
 
+	.vidioc_g_parm		= coda_g_parm,
+	.vidioc_s_parm		= coda_s_parm,
+
 	.vidioc_subscribe_event = coda_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 7d02624..00e4f51 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -263,6 +263,10 @@
 #define		CODADX6_PICHEIGHT_MASK				0x3ff
 #define		CODA7_PICHEIGHT_MASK				0xffff
 #define CODA_CMD_ENC_SEQ_SRC_F_RATE				0x194
+#define		CODA_FRATE_RES_OFFSET				0
+#define		CODA_FRATE_RES_MASK				0xffff
+#define		CODA_FRATE_DIV_OFFSET				16
+#define		CODA_FRATE_DIV_MASK				0xffff
 #define CODA_CMD_ENC_SEQ_MP4_PARA				0x198
 #define		CODA_MP4PARAM_VERID_OFFSET			6
 #define		CODA_MP4PARAM_VERID_MASK			0x01
-- 
2.1.4

