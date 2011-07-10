Return-path: <mchehab@localhost>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45435 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1GJSOp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 14:14:45 -0400
Received: by mail-iw0-f174.google.com with SMTP id 6so3056403iwn.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 11:14:45 -0700 (PDT)
MIME-Version: 1.0
From: Christian Gmeiner <christian.gmeiner@gmail.com>
Date: Sun, 10 Jul 2011 18:14:25 +0000
Message-ID: <CAH9NwWeiAtrGN-X9LeLabfLN6eBxhdfiUcwbBx1u0nyKvRU1sQ@mail.gmail.com>
Subject: [PATCH 3/3] Make use of 8-bit and 16-bit YCrCb media bus pixel codes
 in adv7175 driver
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The ADV7175A/ADV7176A can operate in either 8-bit or 16-bit YCrCb mode.

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

Signed-off-by: Christian Gmeiner
---
diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index d2327db..79ab5a3 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -51,6 +51,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 struct adv7175 {
 	struct v4l2_subdev sd;
 	v4l2_std_id norm;
+	enum v4l2_mbus_pixelcode pixelcode;
 	int input;
 };

@@ -61,6 +62,11 @@ static inline struct adv7175 *to_adv7175(struct
v4l2_subdev *sd)

 static char *inputs[] = { "pass_through", "play_back", "color_bar" };

+static enum v4l2_mbus_pixelcode adv7175_codes[] = {
+	V4L2_MBUS_FMT_YCRCB_1X8,
+	V4L2_MBUS_FMT_YCRCB_1X16,
+};
+
 /* ----------------------------------------------------------------------- */

 static inline int adv7175_write(struct v4l2_subdev *sd, u8 reg, u8 value)
@@ -296,6 +302,60 @@ static int adv7175_s_routing(struct v4l2_subdev *sd,
 	return 0;
 }

+static int adv7175_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
+				enum v4l2_mbus_pixelcode *code)
+{
+	if (index >= ARRAY_SIZE(adv7175_codes))
+		return -EINVAL;
+
+	*code = adv7175_codes[index];
+	return 0;
+}
+
+static int adv7175_g_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	struct adv7175 *encoder = to_adv7175(sd);
+
+	mf->code        = encoder->pixelcode;
+	mf->colorspace  = V4L2_COLORSPACE_SMPTE170M;
+	mf->width       = 0;
+	mf->height      = 0;
+	mf->field       = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int adv7175_s_fmt(struct v4l2_subdev *sd,
+				struct v4l2_mbus_framefmt *mf)
+{
+	struct adv7175 *encoder = to_adv7175(sd);
+	u8 val = adv7175_read(sd, 0x7);
+	int ret;
+
+	switch (mf->code) {
+	case V4L2_MBUS_FMT_YCRCB_1X8:
+		val &= ~0x40;
+		break;
+
+	case V4L2_MBUS_FMT_YCRCB_1X16:
+		val |= 0x40;
+		break;
+
+	default:
+		v4l2_dbg(1, debug, sd,
+			"illegal v4l2_mbus_framefmt code: %d\n", mf->code);
+		return -EINVAL;
+	}
+
+	ret = adv7175_write(sd, 0x7, val);
+
+	if (ret == 0)
+		encoder->pixelcode = mf->code;
+
+	return ret;
+}
+
 static int adv7175_g_chip_ident(struct v4l2_subdev *sd, struct
v4l2_dbg_chip_ident *chip)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -324,6 +384,9 @@ static const struct v4l2_subdev_core_ops
adv7175_core_ops = {
 static const struct v4l2_subdev_video_ops adv7175_video_ops = {
 	.s_std_output = adv7175_s_std_output,
 	.s_routing = adv7175_s_routing,
+	.s_mbus_fmt = adv7175_s_fmt,
+	.g_mbus_fmt = adv7175_g_fmt,
+	.enum_mbus_fmt  = adv7175_enum_fmt,
 };

 static const struct v4l2_subdev_ops adv7175_ops = {
--
1.7.6
