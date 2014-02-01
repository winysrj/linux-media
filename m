Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36844 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbaBAOYu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 17/17] rtl2832_sdr: implement tuner bandwidth control
Date: Sat,  1 Feb 2014 16:24:34 +0200
Message-Id: <1391264674-4395-18-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement control that user could adjust tuner filters manually,
if he wish.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 71 ++++++++++++------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 15c562e3..1dfe653 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -38,9 +38,6 @@
 #include <linux/math64.h>
 
 /* TODO: These should be moved to V4L2 API */
-#define RTL2832_SDR_CID_TUNER_BW            ((V4L2_CID_USER_BASE | 0xf000) + 11)
-#define RTL2832_SDR_CID_TUNER_GAIN          ((V4L2_CID_USER_BASE | 0xf000) + 13)
-
 #define V4L2_PIX_FMT_SDR_U8    v4l2_fourcc('D', 'U', '0', '8')
 #define V4L2_PIX_FMT_SDR_U16LE v4l2_fourcc('D', 'U', '1', '6')
 
@@ -150,13 +147,14 @@ struct rtl2832_sdr_state {
 
 	/* Controls */
 	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
 	struct v4l2_ctrl *lna_gain_auto;
 	struct v4l2_ctrl *lna_gain;
 	struct v4l2_ctrl *mixer_gain_auto;
 	struct v4l2_ctrl *mixer_gain;
 	struct v4l2_ctrl *if_gain_auto;
 	struct v4l2_ctrl *if_gain;
-	struct v4l2_ctrl *ctrl_tuner_bw;
 
 	/* for sample rate calc */
 	unsigned int sample;
@@ -1003,12 +1001,23 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	/*
 	 * bandwidth (Hz)
 	 */
-	unsigned int bandwidth = s->ctrl_tuner_bw->val;
+	unsigned int bandwidth;
 
-	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%u bandwidth=%d\n",
+	/* filters */
+	if (s->bandwidth_auto->val)
+		bandwidth = s->f_adc;
+	else
+		bandwidth = s->bandwidth->val;
+
+	s->bandwidth->val = bandwidth;
+
+	dev_dbg(&s->udev->dev, "%s: f_rf=%u bandwidth=%d\n",
 			__func__, f_rf, bandwidth);
 
+	c->bandwidth_hz = bandwidth;
+	c->frequency = f_rf;
+	c->delivery_system = SYS_DVBT;
+
 	if (f_rf == 0)
 		return 0;
 
@@ -1018,14 +1027,6 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	if (fe->ops.tuner_ops.init)
 		fe->ops.tuner_ops.init(fe);
 
-	/* user has not requested bandwidth so calculate automatically */
-	if (bandwidth == 0)
-		bandwidth = s->f_adc;
-
-	c->bandwidth_hz = bandwidth;
-	c->frequency = f_rf;
-	c->delivery_system = SYS_DVBT;
-
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
@@ -1368,8 +1369,8 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-	case RTL2832_SDR_CID_TUNER_BW:
-	case RTL2832_SDR_CID_TUNER_GAIN:
+	case V4L2_CID_BANDWIDTH_AUTO:
+	case V4L2_CID_BANDWIDTH:
 		ret = rtl2832_sdr_set_tuner(s);
 		break;
 	case  V4L2_CID_LNA_GAIN_AUTO:
@@ -1409,16 +1410,6 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	struct rtl2832_sdr_state *s;
 	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
-	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
-		.ops    = &rtl2832_sdr_ctrl_ops,
-		.id     = RTL2832_SDR_CID_TUNER_BW,
-		.type   = V4L2_CTRL_TYPE_INTEGER,
-		.name   = "Tuner BW",
-		.min    = 0,
-		.max    = INT_MAX,
-		.def    = 0,
-		.step   = 1,
-	};
 
 	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1458,8 +1449,10 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	/* Register controls */
 	switch (s->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		v4l2_ctrl_handler_init(&s->hdl, 7);
-		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+		v4l2_ctrl_handler_init(&s->hdl, 8);
+		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
+		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
 		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 10);
 		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
@@ -1471,7 +1464,10 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
 		break;
 	case RTL2832_TUNER_R820T:
-		v4l2_ctrl_handler_init(&s->hdl, 7);
+		v4l2_ctrl_handler_init(&s->hdl, 8);
+		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 0, 8000000, 100000, 0);
+		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
 		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 6);
 		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
@@ -1481,12 +1477,19 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
 		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 15, 1, 4);
 		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
-		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
 		break;
-	default:
-		v4l2_ctrl_handler_init(&s->hdl, 1);
-		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+	case RTL2832_TUNER_FC0012:
+	case RTL2832_TUNER_FC0013:
+		v4l2_ctrl_handler_init(&s->hdl, 2);
+		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 6000000, 8000000, 1000000, 6000000);
+		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 		break;
+	default:
+		v4l2_ctrl_handler_init(&s->hdl, 0);
+		dev_notice(&s->udev->dev, "%s: Unsupported tuner\n",
+				KBUILD_MODNAME);
+		goto err_free_controls;
 	}
 
 	if (s->hdl.error) {
-- 
1.8.5.3

