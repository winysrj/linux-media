Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42603 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbaBIIuA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:50:00 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 41/86] rtl2832_sdr: expose E4000 gain controls to user space
Date: Sun,  9 Feb 2014 10:48:46 +0200
Message-Id: <1391935771-18670-42-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide E4000 gain controls to userspace via V4L2 API. LNA, Mixer
and IF gain controls are offered, each one both manual and automode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/Makefile      |   1 +
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 115 +++++++++++++++++------
 2 files changed, 88 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/Makefile b/drivers/staging/media/rtl2832u_sdr/Makefile
index 1009276..7e00a0d 100644
--- a/drivers/staging/media/rtl2832u_sdr/Makefile
+++ b/drivers/staging/media/rtl2832u_sdr/Makefile
@@ -2,4 +2,5 @@ obj-$(CONFIG_DVB_RTL2832_SDR) += rtl2832_sdr.o
 
 ccflags-y += -Idrivers/media/dvb-core
 ccflags-y += -Idrivers/media/dvb-frontends
+ccflags-y += -Idrivers/media/tuners
 ccflags-y += -Idrivers/media/usb/dvb-usb-v2
diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index fccb16f..ee72233 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -25,6 +25,7 @@
 #include "dvb_frontend.h"
 #include "rtl2832_sdr.h"
 #include "dvb_usb.h"
+#include "e4000.h"
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -147,9 +148,14 @@ struct rtl2832_sdr_state {
 	u32 pixelformat;
 
 	/* Controls */
-	struct v4l2_ctrl_handler ctrl_handler;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *lna_gain_auto;
+	struct v4l2_ctrl *lna_gain;
+	struct v4l2_ctrl *mixer_gain_auto;
+	struct v4l2_ctrl *mixer_gain;
+	struct v4l2_ctrl *if_gain_auto;
+	struct v4l2_ctrl *if_gain;
 	struct v4l2_ctrl *ctrl_tuner_bw;
-	struct v4l2_ctrl *ctrl_tuner_gain;
 
 	/* for sample rate calc */
 	unsigned int sample;
@@ -917,10 +923,49 @@ err:
 	return;
 };
 
+static int rtl2832_sdr_set_gain_e4000(struct rtl2832_sdr_state *s)
+{
+	int ret;
+	struct dvb_frontend *fe = s->fe;
+	struct e4000_ctrl ctrl;
+	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
+			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
+
+	ctrl.lna_gain = s->lna_gain_auto->val ? INT_MIN : s->lna_gain->val;
+	ctrl.mixer_gain = s->mixer_gain_auto->val ? INT_MIN : s->mixer_gain->val;
+	ctrl.if_gain = s->if_gain_auto->val ? INT_MIN : s->if_gain->val;
+
+	if (fe->ops.tuner_ops.set_config) {
+		ret = fe->ops.tuner_ops.set_config(fe, &ctrl);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
+	return ret;
+};
+
+static int rtl2832_sdr_set_gain(struct rtl2832_sdr_state *s)
+{
+	int ret;
+
+	switch (s->cfg->tuner) {
+	case RTL2832_TUNER_E4000:
+		ret = rtl2832_sdr_set_gain_e4000(s);
+		break;
+	default:
+		ret = 0;
+	}
+	return ret;
+}
+
 static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret;
 
 	/*
 	 * tuner RF (Hz)
@@ -932,14 +977,9 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	 */
 	unsigned int bandwidth = s->ctrl_tuner_bw->val;
 
-	/*
-	 * gain (dB)
-	 */
-	int gain = s->ctrl_tuner_gain->val;
-
 	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%u bandwidth=%d gain=%d\n",
-			__func__, f_rf, bandwidth, gain);
+			"%s: f_rf=%u bandwidth=%d\n",
+			__func__, f_rf, bandwidth);
 
 	if (f_rf == 0)
 		return 0;
@@ -961,6 +1001,8 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
 
+	ret = rtl2832_sdr_set_gain(s);
+
 	return 0;
 };
 
@@ -1290,7 +1332,7 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct rtl2832_sdr_state *s =
 			container_of(ctrl->handler, struct rtl2832_sdr_state,
-					ctrl_handler);
+					hdl);
 	int ret;
 	dev_dbg(&s->udev->dev,
 			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
@@ -1302,6 +1344,15 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	case RTL2832_SDR_CID_TUNER_GAIN:
 		ret = rtl2832_sdr_set_tuner(s);
 		break;
+	case  V4L2_CID_LNA_GAIN_AUTO:
+	case  V4L2_CID_LNA_GAIN:
+	case  V4L2_CID_MIXER_GAIN_AUTO:
+	case  V4L2_CID_MIXER_GAIN:
+	case  V4L2_CID_IF_GAIN_AUTO:
+	case  V4L2_CID_IF_GAIN:
+		dev_dbg(&s->udev->dev, "%s: GAIN IOCTL\n", __func__);
+		ret = rtl2832_sdr_set_gain(s);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1318,7 +1369,7 @@ static void rtl2832_sdr_video_release(struct v4l2_device *v)
 	struct rtl2832_sdr_state *s =
 			container_of(v, struct rtl2832_sdr_state, v4l2_dev);
 
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
 	kfree(s);
 }
@@ -1328,6 +1379,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 {
 	int ret;
 	struct rtl2832_sdr_state *s;
+	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
 	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
 		.ops    = &rtl2832_sdr_ctrl_ops,
@@ -1339,16 +1391,6 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		.def    = 0,
 		.step   = 1,
 	};
-	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-		.ops    = &rtl2832_sdr_ctrl_ops,
-		.id     = RTL2832_SDR_CID_TUNER_GAIN,
-		.type   = V4L2_CTRL_TYPE_INTEGER,
-		.name   = "Tuner Gain",
-		.min    = 0,
-		.max    = 102,
-		.def    = 0,
-		.step   = 1,
-	};
 
 	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1386,11 +1428,28 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	}
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->ctrl_handler, 2);
-	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
-	s->ctrl_tuner_gain = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_gain, NULL);
-	if (s->ctrl_handler.error) {
-		ret = s->ctrl_handler.error;
+	switch (s->cfg->tuner) {
+	case RTL2832_TUNER_E4000:
+		v4l2_ctrl_handler_init(&s->hdl, 7);
+		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
+		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 10);
+		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
+		s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
+		s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
+		v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
+		s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
+		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 54, 1, 0);
+		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+		break;
+	default:
+		v4l2_ctrl_handler_init(&s->hdl, 1);
+		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+		break;
+	}
+
+	if (s->hdl.error) {
+		ret = s->hdl.error;
 		dev_err(&s->udev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
@@ -1411,7 +1470,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		goto err_free_controls;
 	}
 
-	s->v4l2_dev.ctrl_handler = &s->ctrl_handler;
+	s->v4l2_dev.ctrl_handler = &s->hdl;
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
 	s->vdev.vfl_dir = VFL_DIR_RX;
@@ -1436,7 +1495,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 err_unregister_v4l2_dev:
 	v4l2_device_unregister(&s->v4l2_dev);
 err_free_controls:
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 err_free_mem:
 	kfree(s);
 	return NULL;
-- 
1.8.5.3

