Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab1J0Uuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Oct 2011 16:50:40 -0400
Received: by bkbzt19 with SMTP id zt19so2343421bkb.19
        for <linux-media@vger.kernel.org>; Thu, 27 Oct 2011 13:50:38 -0700 (PDT)
From: Christian Gmeiner <christian.gmeiner@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] Make use of media bus pixel codes in adv7170 driver
Date: Thu, 27 Oct 2011 22:50:21 +0000
Message-ID: <2798541.448Qvf8D65@localhost>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV7170/ADV7171 can operate in either 8-bit or 16-bit YCrCb Mode.

* 8-Bit YCrCb Mode
This default mode accepts multiplexed YCrCb inputs through
the P7-P0 pixel inputs. The inputs follow the sequence Cb0, Y0
Cr0, Y1 Cb1, Y2, etc. The Y, Cb and Cr data are input on a
rising clock edge.

* 16-Bit YCrCb Mode
This mode accepts Y inputs through the P7–P0 pixel inputs and
multiplexed CrCb inputs through the P15–P8 pixel inputs. The
data is loaded on every second rising edge of CLOCK. The inputs
follow the sequence Cb0, Y0 Cr0, Y1 Cb1, Y2, etc.

Signed-off-by: Christian Gmeiner <christian.gmeiner@gmail.com>
---
diff --git a/drivers/media/video/adv7170.c b/drivers/media/video/adv7170.c
index 23ba5c3..29c253b 100644
--- a/drivers/media/video/adv7170.c
+++ b/drivers/media/video/adv7170.c
@@ -64,6 +64,11 @@ static inline struct adv7170 *to_adv7170(struct v4l2_subdev *sd)
 
 static char *inputs[] = { "pass_through", "play_back" };
 
+static enum v4l2_mbus_pixelcode adv7170_codes[] = {
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_UYVY8_1X16,
+};
+
 /* ----------------------------------------------------------------------- */
 
 static inline int adv7170_write(struct v4l2_subdev *sd, u8 reg, u8 value)
@@ -258,6 +263,60 @@ static int adv7170_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int adv7170_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index >= ARRAY_SIZE(adv7170_codes))
+		return -EINVAL;
+
+	*code = adv7170_codes[index];
+	return 0;
+}
+
+static int adv7170_g_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	u8 val = adv7170_read(sd, 0x7);
+
+	if ((val & 0x40) == (1 << 6))
+		mf->code = V4L2_MBUS_FMT_UYVY8_1X16;
+	else
+		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+
+	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
+	mf->width       = 0;
+	mf->height      = 0;
+	mf->field       = V4L2_FIELD_ANY;
+
+	return 0;
+}
+
+static int adv7170_s_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	u8 val = adv7170_read(sd, 0x7);
+	int ret;
+
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+		val &= ~0x40;
+		break;
+
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+		val |= 0x40;
+		break;
+
+	default:
+		v4l2_dbg(1, debug, sd,
+			"illegal v4l2_mbus_framefmt code: %d\n", mf->code);
+		return -EINVAL;
+	}
+
+	ret = adv7170_write(sd, 0x7, val);
+
+	return ret;
+}
+
 static int adv7170_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -274,6 +333,9 @@ static const struct v4l2_subdev_core_ops adv7170_core_ops = {
 static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 	.s_std_output = adv7170_s_std_output,
 	.s_routing = adv7170_s_routing,
+	.s_mbus_fmt = adv7170_s_fmt,
+	.g_mbus_fmt = adv7170_g_fmt,
+	.enum_mbus_fmt  = adv7170_enum_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7170_ops = {
--
1.7.6
