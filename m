Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55668 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbbIAXFC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Sep 2015 19:05:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] vivid: SDR cap: add control for FM deviation
Date: Wed,  2 Sep 2015 02:04:50 +0300
Message-Id: <1441148691-8799-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add user control to adjust generated FM deviation.
Default it to 75kHz like public FM radio broadcast.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c   | 37 +++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-sdr-cap.c |  6 ++++-
 3 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index c72349c..289640c 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -451,6 +451,7 @@ struct vivid_dev {
 	unsigned			sdr_buffersize;
 	unsigned			sdr_adc_freq;
 	unsigned			sdr_fm_freq;
+	unsigned			sdr_fm_deviation;
 	int				sdr_fixp_src_phase;
 	int				sdr_fixp_mod_phase;
 
diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 339c8b7..29834fa 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -99,6 +99,7 @@
 
 #define VIVID_CID_RADIO_TX_RDS_BLOCKIO	(VIVID_CID_VIVID_BASE + 94)
 
+#define VIVID_CID_SDR_CAP_FM_DEVIATION	(VIVID_CID_VIVID_BASE + 110)
 
 /* General User Controls */
 
@@ -1257,6 +1258,36 @@ static const struct v4l2_ctrl_config vivid_ctrl_radio_tx_rds_blockio = {
 };
 
 
+/* SDR Capture Controls */
+
+static int vivid_sdr_cap_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vivid_dev *dev = container_of(ctrl->handler, struct vivid_dev, ctrl_hdl_sdr_cap);
+
+	switch (ctrl->id) {
+	case VIVID_CID_SDR_CAP_FM_DEVIATION:
+		dev->sdr_fm_deviation = ctrl->val;
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vivid_sdr_cap_ctrl_ops = {
+	.s_ctrl = vivid_sdr_cap_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config vivid_ctrl_sdr_cap_fm_deviation = {
+	.ops = &vivid_sdr_cap_ctrl_ops,
+	.id = VIVID_CID_SDR_CAP_FM_DEVIATION,
+	.name = "FM Deviation",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min =    100,
+	.max = 200000,
+	.def =  75000,
+	.step =     1,
+};
+
+
 static const struct v4l2_ctrl_config vivid_ctrl_class = {
 	.ops = &vivid_user_gen_ctrl_ops,
 	.flags = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_WRITE_ONLY,
@@ -1314,7 +1345,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	v4l2_ctrl_new_custom(hdl_radio_rx, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_radio_tx, 17);
 	v4l2_ctrl_new_custom(hdl_radio_tx, &vivid_ctrl_class, NULL);
-	v4l2_ctrl_handler_init(hdl_sdr_cap, 18);
+	v4l2_ctrl_handler_init(hdl_sdr_cap, 19);
 	v4l2_ctrl_new_custom(hdl_sdr_cap, &vivid_ctrl_class, NULL);
 
 	/* User Controls */
@@ -1545,6 +1576,10 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 			&vivid_radio_tx_ctrl_ops,
 			V4L2_CID_RDS_TX_MUSIC_SPEECH, 0, 1, 1, 1);
 	}
+	if (dev->has_sdr_cap) {
+		v4l2_ctrl_new_custom(hdl_sdr_cap,
+			&vivid_ctrl_sdr_cap_fm_deviation, NULL);
+	}
 	if (hdl_user_gen->error)
 		return hdl_user_gen->error;
 	if (hdl_user_vid->error)
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index d2f2188..c36b3f5 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/math64.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/v4l2-common.h>
@@ -488,12 +489,14 @@ int vidioc_try_fmt_sdr_cap(struct file *file, void *fh, struct v4l2_format *f)
 #define FIXP_N    (15)
 #define FIXP_FRAC (1 << FIXP_N)
 #define FIXP_2PI  ((int)(2 * 3.141592653589 * FIXP_FRAC))
+#define M_100000PI (3.14159 * 100000)
 
 void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 {
 	u8 *vbuf = vb2_plane_vaddr(&buf->vb, 0);
 	unsigned long i;
 	unsigned long plane_size = vb2_plane_size(&buf->vb, 0);
+	s64 s64tmp;
 	s32 src_phase_step;
 	s32 mod_phase_step;
 	s32 fixp_i;
@@ -515,7 +518,8 @@ void vivid_sdr_cap_process(struct vivid_dev *dev, struct vivid_buffer *buf)
 						FIXP_2PI) >> (31 - FIXP_N);
 
 		dev->sdr_fixp_src_phase += src_phase_step;
-		dev->sdr_fixp_mod_phase += mod_phase_step / 4;
+		s64tmp = (s64) mod_phase_step * dev->sdr_fm_deviation;
+		dev->sdr_fixp_mod_phase += div_s64(s64tmp, M_100000PI);
 
 		/*
 		 * Transfer phases to [0 / 2xPI] in order to avoid variable
-- 
http://palosaari.fi/

