Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34133 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaBIJBv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Feb 2014 04:01:51 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 55/86] msi3101: implement tuner bandwidth control
Date: Sun,  9 Feb 2014 10:49:00 +0200
Message-Id: <1391935771-18670-56-git-send-email-crope@iki.fi>
In-Reply-To: <1391935771-18670-1-git-send-email-crope@iki.fi>
References: <1391935771-18670-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement control that user could adjust tuner filters manually,
if he wish.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 44 ++++++++++++++---------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 0606941..49e5bd1 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -52,8 +52,6 @@
 #define MAX_ISOC_ERRORS         20
 
 /* TODO: These should be moved to V4L2 API */
-#define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
-
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_U16LE  v4l2_fourcc('D', 'U', '1', '6') /* unsigned 16-bit LE */
 #define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */
@@ -157,13 +155,14 @@ struct msi3101_state {
 
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
 
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
@@ -1131,7 +1130,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 		{5000000, 0x04}, /* 5 MHz */
 		{6000000, 0x05}, /* 6 MHz */
 		{7000000, 0x06}, /* 7 MHz */
-		{    ~0U, 0x07}, /* 8 MHz */
+		{8000000, 0x07}, /* 8 MHz */
 	};
 
 	unsigned int f_rf = s->f_tuner;
@@ -1140,7 +1139,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	 * bandwidth (Hz)
 	 * 200000, 300000, 600000, 1536000, 5000000, 6000000, 7000000, 8000000
 	 */
-	unsigned int bandwidth = s->ctrl_tuner_bw->val;
+	unsigned int bandwidth;
 
 	/*
 	 * intermediate frequency (Hz)
@@ -1149,8 +1148,8 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	unsigned int f_if = 0;
 
 	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%d bandwidth=%d f_if=%d\n",
-			__func__, f_rf, bandwidth, f_if);
+			"%s: f_rf=%d f_if=%d\n",
+			__func__, f_rf, f_if);
 
 	ret = -EINVAL;
 
@@ -1181,9 +1180,13 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(if_freq_lut))
 		goto err;
 
-	/* user has not requested bandwidth, set some reasonable */
-	if (bandwidth == 0)
+	/* filters */
+	if (s->bandwidth_auto->val)
 		bandwidth = s->f_adc;
+	else
+		bandwidth = s->bandwidth->val;
+
+	bandwidth = clamp(bandwidth, 200000U, 8000000U);
 
 	for (i = 0; i < ARRAY_SIZE(bandwidth_lut); i++) {
 		if (bandwidth <= bandwidth_lut[i].freq) {
@@ -1195,6 +1198,8 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (i == ARRAY_SIZE(bandwidth_lut))
 		goto err;
 
+	s->bandwidth->val = bandwidth_lut[i].freq;
+
 	dev_dbg(&s->udev->dev, "%s: bandwidth selected=%d\n",
 			__func__, bandwidth_lut[i].freq);
 
@@ -1580,7 +1585,8 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 			ctrl->minimum, ctrl->maximum, ctrl->step);
 
 	switch (ctrl->id) {
-	case MSI3101_CID_TUNER_BW:
+	case V4L2_CID_BANDWIDTH_AUTO:
+	case V4L2_CID_BANDWIDTH:
 		ret = msi3101_set_tuner(s);
 		break;
 	case  V4L2_CID_LNA_GAIN:
@@ -1617,16 +1623,6 @@ static int msi3101_probe(struct usb_interface *intf,
 	struct msi3101_state *s = NULL;
 	const struct v4l2_ctrl_ops *ops = &msi3101_ctrl_ops;
 	int ret;
-	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_BW,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner Bandwidth",
-		.min	= 0,
-		.max	= 8000000,
-		.def    = 0,
-		.step	= 1,
-	};
 
 	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1664,8 +1660,12 @@ static int msi3101_probe(struct usb_interface *intf,
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->hdl, 4);
-	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+	v4l2_ctrl_handler_init(&s->hdl, 5);
+	s->bandwidth_auto = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_BANDWIDTH_AUTO, 0, 1, 1, 1);
+	s->bandwidth = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_BANDWIDTH, 0, 8000000, 1, 0);
+	v4l2_ctrl_auto_cluster(2, &s->bandwidth_auto, 0, false);
 	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops,
 			V4L2_CID_LNA_GAIN, 0, 1, 1, 1);
 	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops,
-- 
1.8.5.3

