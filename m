Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51643 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaAYWuN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 17:50:13 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] msi3101: use standard V4L gain controls
Date: Sun, 26 Jan 2014 00:49:50 +0200
Message-Id: <1390690190-30295-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use LNA, Mixer and IF gain controls offered by V4L API.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 433 ++++------------------------
 1 file changed, 56 insertions(+), 377 deletions(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index e6b7cba..e8dfcac 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -34,317 +34,6 @@
 #include <linux/usb.h>
 #include <media/videobuf2-vmalloc.h>
 
-struct msi3101_gain {
-	u8 tot:7;
-	u8 baseband:6;
-	bool lna:1;
-	bool mixer:1;
-};
-
-/* 60 – 120 MHz band, lna 24dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_120[] = {
-	{  0,  0,  0,  0},
-	{  1,  1,  0,  0},
-	{  2,  2,  0,  0},
-	{  3,  3,  0,  0},
-	{  4,  4,  0,  0},
-	{  5,  5,  0,  0},
-	{  6,  6,  0,  0},
-	{  7,  7,  0,  0},
-	{  8,  8,  0,  0},
-	{  9,  9,  0,  0},
-	{ 10, 10,  0,  0},
-	{ 11, 11,  0,  0},
-	{ 12, 12,  0,  0},
-	{ 13, 13,  0,  0},
-	{ 14, 14,  0,  0},
-	{ 15, 15,  0,  0},
-	{ 16, 16,  0,  0},
-	{ 17, 17,  0,  0},
-	{ 18, 18,  0,  0},
-	{ 19, 19,  0,  0},
-	{ 20, 20,  0,  0},
-	{ 21, 21,  0,  0},
-	{ 22, 22,  0,  0},
-	{ 23, 23,  0,  0},
-	{ 24, 24,  0,  0},
-	{ 25, 25,  0,  0},
-	{ 26, 26,  0,  0},
-	{ 27, 27,  0,  0},
-	{ 28, 28,  0,  0},
-	{ 29,  5,  1,  0},
-	{ 30,  6,  1,  0},
-	{ 31,  7,  1,  0},
-	{ 32,  8,  1,  0},
-	{ 33,  9,  1,  0},
-	{ 34, 10,  1,  0},
-	{ 35, 11,  1,  0},
-	{ 36, 12,  1,  0},
-	{ 37, 13,  1,  0},
-	{ 38, 14,  1,  0},
-	{ 39, 15,  1,  0},
-	{ 40, 16,  1,  0},
-	{ 41, 17,  1,  0},
-	{ 42, 18,  1,  0},
-	{ 43, 19,  1,  0},
-	{ 44, 20,  1,  0},
-	{ 45, 21,  1,  0},
-	{ 46, 22,  1,  0},
-	{ 47, 23,  1,  0},
-	{ 48, 24,  1,  0},
-	{ 49, 25,  1,  0},
-	{ 50, 26,  1,  0},
-	{ 51, 27,  1,  0},
-	{ 52, 28,  1,  0},
-	{ 53, 29,  1,  0},
-	{ 54, 30,  1,  0},
-	{ 55, 31,  1,  0},
-	{ 56, 32,  1,  0},
-	{ 57, 33,  1,  0},
-	{ 58, 34,  1,  0},
-	{ 59, 35,  1,  0},
-	{ 60, 36,  1,  0},
-	{ 61, 37,  1,  0},
-	{ 62, 38,  1,  0},
-	{ 63, 39,  1,  0},
-	{ 64, 40,  1,  0},
-	{ 65, 41,  1,  0},
-	{ 66, 42,  1,  0},
-	{ 67, 43,  1,  0},
-	{ 68, 44,  1,  0},
-	{ 69, 45,  1,  0},
-	{ 70, 46,  1,  0},
-	{ 71, 47,  1,  0},
-	{ 72, 48,  1,  0},
-	{ 73, 49,  1,  0},
-	{ 74, 50,  1,  0},
-	{ 75, 51,  1,  0},
-	{ 76, 52,  1,  0},
-	{ 77, 53,  1,  0},
-	{ 78, 54,  1,  0},
-	{ 79, 55,  1,  0},
-	{ 80, 56,  1,  0},
-	{ 81, 57,  1,  0},
-	{ 82, 58,  1,  0},
-	{ 83, 40,  1,  1},
-	{ 84, 41,  1,  1},
-	{ 85, 42,  1,  1},
-	{ 86, 43,  1,  1},
-	{ 87, 44,  1,  1},
-	{ 88, 45,  1,  1},
-	{ 89, 46,  1,  1},
-	{ 90, 47,  1,  1},
-	{ 91, 48,  1,  1},
-	{ 92, 49,  1,  1},
-	{ 93, 50,  1,  1},
-	{ 94, 51,  1,  1},
-	{ 95, 52,  1,  1},
-	{ 96, 53,  1,  1},
-	{ 97, 54,  1,  1},
-	{ 98, 55,  1,  1},
-	{ 99, 56,  1,  1},
-	{100, 57,  1,  1},
-	{101, 58,  1,  1},
-	{102, 59,  1,  1},
-};
-
-/* 120 – 245 MHz band, lna 24dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_245[] = {
-	{  0,  0,  0,  0},
-	{  1,  1,  0,  0},
-	{  2,  2,  0,  0},
-	{  3,  3,  0,  0},
-	{  4,  4,  0,  0},
-	{  5,  5,  0,  0},
-	{  6,  6,  0,  0},
-	{  7,  7,  0,  0},
-	{  8,  8,  0,  0},
-	{  9,  9,  0,  0},
-	{ 10, 10,  0,  0},
-	{ 11, 11,  0,  0},
-	{ 12, 12,  0,  0},
-	{ 13, 13,  0,  0},
-	{ 14, 14,  0,  0},
-	{ 15, 15,  0,  0},
-	{ 16, 16,  0,  0},
-	{ 17, 17,  0,  0},
-	{ 18, 18,  0,  0},
-	{ 19, 19,  0,  0},
-	{ 20, 20,  0,  0},
-	{ 21, 21,  0,  0},
-	{ 22, 22,  0,  0},
-	{ 23, 23,  0,  0},
-	{ 24, 24,  0,  0},
-	{ 25, 25,  0,  0},
-	{ 26, 26,  0,  0},
-	{ 27, 27,  0,  0},
-	{ 28, 28,  0,  0},
-	{ 29,  5,  1,  0},
-	{ 30,  6,  1,  0},
-	{ 31,  7,  1,  0},
-	{ 32,  8,  1,  0},
-	{ 33,  9,  1,  0},
-	{ 34, 10,  1,  0},
-	{ 35, 11,  1,  0},
-	{ 36, 12,  1,  0},
-	{ 37, 13,  1,  0},
-	{ 38, 14,  1,  0},
-	{ 39, 15,  1,  0},
-	{ 40, 16,  1,  0},
-	{ 41, 17,  1,  0},
-	{ 42, 18,  1,  0},
-	{ 43, 19,  1,  0},
-	{ 44, 20,  1,  0},
-	{ 45, 21,  1,  0},
-	{ 46, 22,  1,  0},
-	{ 47, 23,  1,  0},
-	{ 48, 24,  1,  0},
-	{ 49, 25,  1,  0},
-	{ 50, 26,  1,  0},
-	{ 51, 27,  1,  0},
-	{ 52, 28,  1,  0},
-	{ 53, 29,  1,  0},
-	{ 54, 30,  1,  0},
-	{ 55, 31,  1,  0},
-	{ 56, 32,  1,  0},
-	{ 57, 33,  1,  0},
-	{ 58, 34,  1,  0},
-	{ 59, 35,  1,  0},
-	{ 60, 36,  1,  0},
-	{ 61, 37,  1,  0},
-	{ 62, 38,  1,  0},
-	{ 63, 39,  1,  0},
-	{ 64, 40,  1,  0},
-	{ 65, 41,  1,  0},
-	{ 66, 42,  1,  0},
-	{ 67, 43,  1,  0},
-	{ 68, 44,  1,  0},
-	{ 69, 45,  1,  0},
-	{ 70, 46,  1,  0},
-	{ 71, 47,  1,  0},
-	{ 72, 48,  1,  0},
-	{ 73, 49,  1,  0},
-	{ 74, 50,  1,  0},
-	{ 75, 51,  1,  0},
-	{ 76, 52,  1,  0},
-	{ 77, 53,  1,  0},
-	{ 78, 54,  1,  0},
-	{ 79, 55,  1,  0},
-	{ 80, 56,  1,  0},
-	{ 81, 57,  1,  0},
-	{ 82, 58,  1,  0},
-	{ 83, 40,  1,  1},
-	{ 84, 41,  1,  1},
-	{ 85, 42,  1,  1},
-	{ 86, 43,  1,  1},
-	{ 87, 44,  1,  1},
-	{ 88, 45,  1,  1},
-	{ 89, 46,  1,  1},
-	{ 90, 47,  1,  1},
-	{ 91, 48,  1,  1},
-	{ 92, 49,  1,  1},
-	{ 93, 50,  1,  1},
-	{ 94, 51,  1,  1},
-	{ 95, 52,  1,  1},
-	{ 96, 53,  1,  1},
-	{ 97, 54,  1,  1},
-	{ 98, 55,  1,  1},
-	{ 99, 56,  1,  1},
-	{100, 57,  1,  1},
-	{101, 58,  1,  1},
-	{102, 59,  1,  1},
-};
-
-/* 420 – 1000 MHz band, lna 7dB, mixer 19dB */
-static const struct msi3101_gain msi3101_gain_lut_1000[] = {
-	{  0,  0, 0,  0},
-	{  1,  1, 0,  0},
-	{  2,  2, 0,  0},
-	{  3,  3, 0,  0},
-	{  4,  4, 0,  0},
-	{  5,  5, 0,  0},
-	{  6,  6, 0,  0},
-	{  7,  7, 0,  0},
-	{  8,  8, 0,  0},
-	{  9,  9, 0,  0},
-	{ 10, 10, 0,  0},
-	{ 11, 11, 0,  0},
-	{ 12,  5, 1,  0},
-	{ 13,  6, 1,  0},
-	{ 14,  7, 1,  0},
-	{ 15,  8, 1,  0},
-	{ 16,  9, 1,  0},
-	{ 17, 10, 1,  0},
-	{ 18, 11, 1,  0},
-	{ 19, 12, 1,  0},
-	{ 20, 13, 1,  0},
-	{ 21, 14, 1,  0},
-	{ 22, 15, 1,  0},
-	{ 23, 16, 1,  0},
-	{ 24, 17, 1,  0},
-	{ 25, 18, 1,  0},
-	{ 26, 19, 1,  0},
-	{ 27, 20, 1,  0},
-	{ 28, 21, 1,  0},
-	{ 29, 22, 1,  0},
-	{ 30, 23, 1,  0},
-	{ 31, 24, 1,  0},
-	{ 32, 25, 1,  0},
-	{ 33, 26, 1,  0},
-	{ 34, 27, 1,  0},
-	{ 35, 28, 1,  0},
-	{ 36, 29, 1,  0},
-	{ 37, 30, 1,  0},
-	{ 38, 31, 1,  0},
-	{ 39, 32, 1,  0},
-	{ 40, 33, 1,  0},
-	{ 41, 34, 1,  0},
-	{ 42, 35, 1,  0},
-	{ 43, 36, 1,  0},
-	{ 44, 37, 1,  0},
-	{ 45, 38, 1,  0},
-	{ 46, 39, 1,  0},
-	{ 47, 40, 1,  0},
-	{ 48, 41, 1,  0},
-	{ 49, 42, 1,  0},
-	{ 50, 43, 1,  0},
-	{ 51, 44, 1,  0},
-	{ 52, 45, 1,  0},
-	{ 53, 46, 1,  0},
-	{ 54, 47, 1,  0},
-	{ 55, 48, 1,  0},
-	{ 56, 49, 1,  0},
-	{ 57, 50, 1,  0},
-	{ 58, 51, 1,  0},
-	{ 59, 52, 1,  0},
-	{ 60, 53, 1,  0},
-	{ 61, 54, 1,  0},
-	{ 62, 55, 1,  0},
-	{ 63, 56, 1,  0},
-	{ 64, 57, 1,  0},
-	{ 65, 58, 1,  0},
-	{ 66, 40, 1,  1},
-	{ 67, 41, 1,  1},
-	{ 68, 42, 1,  1},
-	{ 69, 43, 1,  1},
-	{ 70, 44, 1,  1},
-	{ 71, 45, 1,  1},
-	{ 72, 46, 1,  1},
-	{ 73, 47, 1,  1},
-	{ 74, 48, 1,  1},
-	{ 75, 49, 1,  1},
-	{ 76, 50, 1,  1},
-	{ 77, 51, 1,  1},
-	{ 78, 52, 1,  1},
-	{ 79, 53, 1,  1},
-	{ 80, 54, 1,  1},
-	{ 81, 55, 1,  1},
-	{ 82, 56, 1,  1},
-	{ 83, 57, 1,  1},
-	{ 84, 58, 1,  1},
-	{ 85, 59, 1,  1},
-};
-
 /*
  *   iConfiguration          0
  *     bInterfaceNumber        0
@@ -364,7 +53,6 @@ static const struct msi3101_gain msi3101_gain_lut_1000[] = {
 
 /* TODO: These should be moved to V4L2 API */
 #define MSI3101_CID_TUNER_BW              ((V4L2_CID_USER_BASE | 0xf000) + 11)
-#define MSI3101_CID_TUNER_GAIN            ((V4L2_CID_USER_BASE | 0xf000) + 13)
 
 #define V4L2_PIX_FMT_SDR_U8     v4l2_fourcc('D', 'U', '0', '8') /* unsigned 8-bit */
 #define V4L2_PIX_FMT_SDR_U16LE  v4l2_fourcc('D', 'U', '1', '6') /* unsigned 16-bit LE */
@@ -468,9 +156,14 @@ struct msi3101_state {
 			unsigned int src_len);
 
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
 
 	u32 next_sample; /* for track lost packets */
 	u32 sample; /* for sample rate calc */
@@ -1376,14 +1069,37 @@ err:
 	return ret;
 };
 
+static int msi3101_set_gain(struct msi3101_state *s)
+{
+	int ret;
+	u32 reg;
+	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,
+			s->lna_gain->val, s->mixer_gain->val, s->if_gain->val);
+
+	reg = 1 << 0;
+	reg |= (59 - s->if_gain->val) << 4;
+	reg |= 0 << 10;
+	reg |= (1 - s->mixer_gain->val) << 12;
+	reg |= (1 - s->lna_gain->val) << 13;
+	reg |= 4 << 14;
+	reg |= 0 << 17;
+	ret = msi3101_tuner_write(s, reg);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	dev_dbg(&s->udev->dev, "%s: failed %d\n", __func__, ret);
+	return ret;
+};
+
 static int msi3101_set_tuner(struct msi3101_state *s)
 {
-	int ret, i, len;
+	int ret, i;
 	unsigned int n, m, thresh, frac, vco_step, tmp, f_if1;
 	u32 reg;
 	u64 f_vco, tmp64;
 	u8 mode, filter_mode, lo_div;
-	const struct msi3101_gain *gain_lut;
 	static const struct {
 		u32 rf;
 		u8 mode;
@@ -1432,16 +1148,9 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	 */
 	unsigned int f_if = 0;
 
-	/*
-	 * gain reduction (dB)
-	 * 0 - 102 below 420 MHz
-	 * 0 - 85 above 420 MHz
-	 */
-	int gain = s->ctrl_tuner_gain->val;
-
 	dev_dbg(&s->udev->dev,
-			"%s: f_rf=%d bandwidth=%d f_if=%d gain=%d\n",
-			__func__, f_rf, bandwidth, f_if, gain);
+			"%s: f_rf=%d bandwidth=%d f_if=%d\n",
+			__func__, f_rf, bandwidth, f_if);
 
 	ret = -EINVAL;
 
@@ -1553,38 +1262,7 @@ static int msi3101_set_tuner(struct msi3101_state *s)
 	if (ret)
 		goto err;
 
-	if (f_rf < 120000000) {
-		gain_lut = msi3101_gain_lut_120;
-		len = ARRAY_SIZE(msi3101_gain_lut_120);
-	} else if (f_rf < 245000000) {
-		gain_lut = msi3101_gain_lut_245;
-		len = ARRAY_SIZE(msi3101_gain_lut_120);
-	} else {
-		gain_lut = msi3101_gain_lut_1000;
-		len = ARRAY_SIZE(msi3101_gain_lut_1000);
-	}
-
-	for (i = 0; i < len; i++) {
-		if (gain_lut[i].tot >= gain)
-			break;
-	}
-
-	if (i == len)
-		goto err;
-
-	dev_dbg(&s->udev->dev,
-			"%s: gain tot=%d baseband=%d lna=%d mixer=%d\n",
-			__func__, gain_lut[i].tot, gain_lut[i].baseband,
-			gain_lut[i].lna, gain_lut[i].mixer);
-
-	reg = 1 << 0;
-	reg |= gain_lut[i].baseband << 4;
-	reg |= 0 << 10;
-	reg |= gain_lut[i].mixer << 12;
-	reg |= gain_lut[i].lna << 13;
-	reg |= 4 << 14;
-	reg |= 0 << 17;
-	ret = msi3101_tuner_write(s, reg);
+	ret = msi3101_set_gain(s);
 	if (ret)
 		goto err;
 
@@ -1887,7 +1565,7 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct msi3101_state *s =
 			container_of(ctrl->handler, struct msi3101_state,
-					ctrl_handler);
+					hdl);
 	int ret;
 	dev_dbg(&s->udev->dev,
 			"%s: id=%d name=%s val=%d min=%d max=%d step=%d\n",
@@ -1896,10 +1574,15 @@ static int msi3101_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	switch (ctrl->id) {
 	case MSI3101_CID_TUNER_BW:
-	case MSI3101_CID_TUNER_GAIN:
 		ret = msi3101_set_tuner(s);
 		break;
+	case  V4L2_CID_LNA_GAIN:
+	case  V4L2_CID_MIXER_GAIN:
+	case  V4L2_CID_IF_GAIN:
+		ret = msi3101_set_gain(s);
+		break;
 	default:
+		dev_dbg(&s->udev->dev, "%s: EINVAL\n", __func__);
 		ret = -EINVAL;
 	}
 
@@ -1915,7 +1598,7 @@ static void msi3101_video_release(struct v4l2_device *v)
 	struct msi3101_state *s =
 			container_of(v, struct msi3101_state, v4l2_dev);
 
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 	v4l2_device_unregister(&s->v4l2_dev);
 	kfree(s);
 }
@@ -1925,6 +1608,7 @@ static int msi3101_probe(struct usb_interface *intf,
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct msi3101_state *s = NULL;
+	const struct v4l2_ctrl_ops *ops = &msi3101_ctrl_ops;
 	int ret;
 	static const struct v4l2_ctrl_config ctrl_tuner_bw = {
 		.ops	= &msi3101_ctrl_ops,
@@ -1936,16 +1620,6 @@ static int msi3101_probe(struct usb_interface *intf,
 		.def    = 0,
 		.step	= 1,
 	};
-	static const struct v4l2_ctrl_config ctrl_tuner_gain = {
-		.ops	= &msi3101_ctrl_ops,
-		.id	= MSI3101_CID_TUNER_GAIN,
-		.type	= V4L2_CTRL_TYPE_INTEGER,
-		.name	= "Tuner Gain",
-		.min	= 0,
-		.max	= 102,
-		.def    = 50,
-		.step	= 1,
-	};
 
 	s = kzalloc(sizeof(struct msi3101_state), GFP_KERNEL);
 	if (s == NULL) {
@@ -1982,11 +1656,16 @@ static int msi3101_probe(struct usb_interface *intf,
 	video_set_drvdata(&s->vdev, s);
 
 	/* Register controls */
-	v4l2_ctrl_handler_init(&s->ctrl_handler, 2);
-	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_bw, NULL);
-	s->ctrl_tuner_gain = v4l2_ctrl_new_custom(&s->ctrl_handler, &ctrl_tuner_gain, NULL);
-	if (s->ctrl_handler.error) {
-		ret = s->ctrl_handler.error;
+	v4l2_ctrl_handler_init(&s->hdl, 4);
+	s->ctrl_tuner_bw = v4l2_ctrl_new_custom(&s->hdl, &ctrl_tuner_bw, NULL);
+	s->lna_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_LNA_GAIN, 0, 1, 1, 1);
+	s->mixer_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_MIXER_GAIN, 0, 1, 1, 1);
+	s->if_gain = v4l2_ctrl_new_std(&s->hdl, ops,
+			V4L2_CID_IF_GAIN, 0, 59, 1, 0);
+	if (s->hdl.error) {
+		ret = s->hdl.error;
 		dev_err(&s->udev->dev, "Could not initialize controls\n");
 		goto err_free_controls;
 	}
@@ -2000,7 +1679,7 @@ static int msi3101_probe(struct usb_interface *intf,
 		goto err_free_controls;
 	}
 
-	s->v4l2_dev.ctrl_handler = &s->ctrl_handler;
+	s->v4l2_dev.ctrl_handler = &s->hdl;
 	s->vdev.v4l2_dev = &s->v4l2_dev;
 	s->vdev.lock = &s->v4l2_lock;
 
@@ -2019,7 +1698,7 @@ static int msi3101_probe(struct usb_interface *intf,
 err_unregister_v4l2_dev:
 	v4l2_device_unregister(&s->v4l2_dev);
 err_free_controls:
-	v4l2_ctrl_handler_free(&s->ctrl_handler);
+	v4l2_ctrl_handler_free(&s->hdl);
 err_free_mem:
 	kfree(s);
 	return ret;
-- 
1.8.5.3

