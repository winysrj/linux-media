Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43216 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaBIIuA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 03:50:00 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 43/86] rtl2832_sdr: expose R820 gain controls to user space
Date: Sun,  9 Feb 2014 10:48:48 +0200
Message-Id: <1391935771-18670-44-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide R820 gain controls to userspace via V4L2 API. LNA, Mixer
and IF gain controls are offered, each one both manual and automode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 41 ++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index ee72233..69fc996 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -26,6 +26,7 @@
 #include "rtl2832_sdr.h"
 #include "dvb_usb.h"
 #include "e4000.h"
+#include "r820t.h"
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -947,6 +948,30 @@ err:
 	return ret;
 };
 
+static int rtl2832_sdr_set_gain_r820t(struct rtl2832_sdr_state *s)
+{
+	int ret;
+	struct dvb_frontend *fe = s->fe;
+	struct r820t_ctrl ctrl;
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
 static int rtl2832_sdr_set_gain(struct rtl2832_sdr_state *s)
 {
 	int ret;
@@ -955,6 +980,9 @@ static int rtl2832_sdr_set_gain(struct rtl2832_sdr_state *s)
 	case RTL2832_TUNER_E4000:
 		ret = rtl2832_sdr_set_gain_e4000(s);
 		break;
+	case RTL2832_TUNER_R820T:
+		ret = rtl2832_sdr_set_gain_r820t(s);
+		break;
 	default:
 		ret = 0;
 	}
@@ -1442,6 +1470,19 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 54, 1, 0);
 		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
 		break;
+	case RTL2832_TUNER_R820T:
+		v4l2_ctrl_handler_init(&s->hdl, 7);
+		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
+		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 6);
+		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
+		s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
+		s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN, 0, 15, 1, 5);
+		v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
+		s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
+		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 15, 1, 4);
+		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+		break;
 	default:
 		v4l2_ctrl_handler_init(&s->hdl, 1);
 		s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
-- 
1.8.5.3

