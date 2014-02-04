Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59745 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbaBDBkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Feb 2014 20:40:17 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/4] rtl2832_sdr: use E4000 tuner controls via V4L framework
Date: Tue,  4 Feb 2014 03:39:59 +0200
Message-Id: <1391478000-24239-4-git-send-email-crope@iki.fi>
In-Reply-To: <1391478000-24239-1-git-send-email-crope@iki.fi>
References: <1391478000-24239-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use V4L2 control framework for E4000 tuner as it provides controls
that way now.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c | 92 +++++++++---------------
 1 file changed, 34 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
index 1dfe653..c26c084 100644
--- a/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
+++ b/drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c
@@ -922,30 +922,6 @@ err:
 	return;
 };
 
-static int rtl2832_sdr_set_gain_e4000(struct rtl2832_sdr_state *s)
-{
-	int ret;
-	struct dvb_frontend *fe = s->fe;
-	struct e4000_ctrl ctrl;
-	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
-			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
-
-	ctrl.lna_gain = s->lna_gain_auto->val ? INT_MIN : s->lna_gain->val;
-	ctrl.mixer_gain = s->mixer_gain_auto->val ? INT_MIN : s->mixer_gain->val;
-	ctrl.if_gain = s->if_gain_auto->val ? INT_MIN : s->if_gain->val;
-
-	if (fe->ops.tuner_ops.set_config) {
-		ret = fe->ops.tuner_ops.set_config(fe, &ctrl);
-		if (ret)
-			goto err;
-	}
-
-	return 0;
-err:
-	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
-	return ret;
-};
-
 static int rtl2832_sdr_set_gain_r820t(struct rtl2832_sdr_state *s)
 {
 	int ret;
@@ -975,9 +951,6 @@ static int rtl2832_sdr_set_gain(struct rtl2832_sdr_state *s)
 	int ret;
 
 	switch (s->cfg->tuner) {
-	case RTL2832_TUNER_E4000:
-		ret = rtl2832_sdr_set_gain_e4000(s);
-		break;
 	case RTL2832_TUNER_R820T:
 		ret = rtl2832_sdr_set_gain_r820t(s);
 		break;
@@ -991,35 +964,33 @@ static int rtl2832_sdr_set_tuner(struct rtl2832_sdr_state *s)
 {
 	struct dvb_frontend *fe = s->fe;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct v4l2_ctrl *bandwidth_auto;
+	struct v4l2_ctrl *bandwidth;
 	int ret;
 
 	/*
 	 * tuner RF (Hz)
 	 */
-	unsigned int f_rf = s->f_tuner;
+	if (s->f_tuner == 0)
+		return 0;
 
 	/*
 	 * bandwidth (Hz)
 	 */
-	unsigned int bandwidth;
-
-	/* filters */
-	if (s->bandwidth_auto->val)
-		bandwidth = s->f_adc;
-	else
-		bandwidth = s->bandwidth->val;
-
-	s->bandwidth->val = bandwidth;
-
-	dev_dbg(&s->udev->dev, "%s: f_rf=%u bandwidth=%d\n",
-			__func__, f_rf, bandwidth);
+	bandwidth_auto = v4l2_ctrl_find(&s->hdl, V4L2_CID_BANDWIDTH_AUTO);
+	bandwidth = v4l2_ctrl_find(&s->hdl, V4L2_CID_BANDWIDTH);
+	if (v4l2_ctrl_g_ctrl(bandwidth_auto)) {
+		c->bandwidth_hz = s->f_adc;
+		v4l2_ctrl_s_ctrl(bandwidth, s->f_adc);
+	} else {
+		c->bandwidth_hz = v4l2_ctrl_g_ctrl(bandwidth);
+	}
 
-	c->bandwidth_hz = bandwidth;
-	c->frequency = f_rf;
+	c->frequency = s->f_tuner;
 	c->delivery_system = SYS_DVBT;
 
-	if (f_rf == 0)
-		return 0;
+	dev_dbg(&s->udev->dev, "%s: frequency=%u bandwidth=%d\n",
+			__func__, c->frequency, c->bandwidth_hz);
 
 	if (!test_bit(POWER_ON, &s->flags))
 		return 0;
@@ -1362,6 +1333,8 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	struct rtl2832_sdr_state *s =
 			container_of(ctrl->handler, struct rtl2832_sdr_state,
 					hdl);
+	struct dvb_frontend *fe = s->fe;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	dev_dbg(&s->udev->dev,
 			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
@@ -1371,7 +1344,18 @@ static int rtl2832_sdr_s_ctrl(struct v4l2_ctrl *ctrl)
 	switch (ctrl->id) {
 	case V4L2_CID_BANDWIDTH_AUTO:
 	case V4L2_CID_BANDWIDTH:
-		ret = rtl2832_sdr_set_tuner(s);
+		if (s->bandwidth_auto->val)
+			s->bandwidth->val = s->f_adc;
+
+		c->bandwidth_hz = s->bandwidth->val;
+
+		if (!test_bit(POWER_ON, &s->flags))
+			return 0;
+
+		if (fe->ops.tuner_ops.set_params)
+			ret = fe->ops.tuner_ops.set_params(fe);
+		else
+			ret = 0;
 		break;
 	case  V4L2_CID_LNA_GAIN_AUTO:
 	case  V4L2_CID_LNA_GAIN:
@@ -1410,6 +1394,7 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	struct rtl2832_sdr_state *s;
 	const struct v4l2_ctrl_ops *ops = &rtl2832_sdr_ctrl_ops;
 	struct dvb_usb_device *d = i2c_get_adapdata(i2c);
+	struct v4l2_ctrl_handler *hdl;
 
 	s = kzalloc(sizeof(struct rtl2832_sdr_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1449,19 +1434,10 @@ struct dvb_frontend *rtl2832_sdr_attach(struct dvb_frontend *fe,
 	/* Register controls */
 	switch (s->cfg->tuner) {
 	case RTL2832_TUNER_E4000:
-		v4l2_ctrl_handler_init(&s->hdl, 8);
-		s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
-		s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_BANDWIDTH, 4300000, 11000000, 100000, 4300000);
-		v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
-		s->lna_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN_AUTO, 0, 1, 1, 1);
-		s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_LNA_GAIN, 0, 15, 1, 10);
-		v4l2_ctrl_auto_cluster(2, &s->lna_gain_auto, 0, false);
-		s->mixer_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN_AUTO, 0, 1, 1, 1);
-		s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
-		v4l2_ctrl_auto_cluster(2, &s->mixer_gain_auto, 0, false);
-		s->if_gain_auto = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN_AUTO, 0, 1, 1, 1);
-		s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops, V4L2_CID_IF_GAIN, 0, 54, 1, 0);
-		v4l2_ctrl_auto_cluster(2, &s->if_gain_auto, 0, false);
+		hdl = e4000_get_ctrl_handler(fe);
+		v4l2_ctrl_handler_init(&s->hdl, 0);
+		if (hdl)
+			v4l2_ctrl_add_handler(&s->hdl, hdl, NULL);
 		break;
 	case RTL2832_TUNER_R820T:
 		v4l2_ctrl_handler_init(&s->hdl, 8);
-- 
1.8.5.3

