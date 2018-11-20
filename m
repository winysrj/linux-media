Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50097 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbeKTUcV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:32:21 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>,
        Libin Yang <lbyang@marvell.com>,
        Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 03/14] media: ov7670: hook s_power onto v4l2 core
Date: Tue, 20 Nov 2018 11:03:08 +0100
Message-Id: <20181120100318.367987-4-lkundrak@v3.sk>
In-Reply-To: <20181120100318.367987-1-lkundrak@v3.sk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The commit 71862f63f351 ("media: ov7670: Add the ov7670_s_power function"=
)
added a power control routing. However, it was not good enough to use as
a s_power() callback: it merely flipped on the power GPIOs without
restoring the register settings.

Fix this now and register an actual power callback.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

---
Changes since v2:
- Restore the controls, format and frame rate on power on

 drivers/media/i2c/ov7670.c | 50 +++++++++++++++++++++++++++++++++-----
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index ead0c360df33..cbaab60aaaac 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -242,6 +242,7 @@ struct ov7670_info {
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct ov7670_win_size *wsize;
 	struct clk *clk;
+	int on;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
 	unsigned int mbus_config;	/* Media bus configuration flags */
@@ -1615,19 +1616,54 @@ static int ov7670_s_register(struct v4l2_subdev *=
sd, const struct v4l2_dbg_regis
 }
 #endif
=20
-static int ov7670_s_power(struct v4l2_subdev *sd, int on)
+static void ov7670_power_on(struct v4l2_subdev *sd)
 {
 	struct ov7670_info *info =3D to_state(sd);
=20
+	if (info->on)
+		return;
+
 	if (info->pwdn_gpio)
-		gpiod_set_value(info->pwdn_gpio, !on);
-	if (on && info->resetb_gpio) {
+		gpiod_set_value(info->pwdn_gpio, 0);
+	if (info->resetb_gpio) {
 		gpiod_set_value(info->resetb_gpio, 1);
 		usleep_range(500, 1000);
 		gpiod_set_value(info->resetb_gpio, 0);
 		usleep_range(3000, 5000);
 	}
=20
+	info->on =3D true;
+}
+
+static void ov7670_power_off(struct v4l2_subdev *sd)
+{
+	struct ov7670_info *info =3D to_state(sd);
+
+	if (!info->on)
+		return;
+
+	if (info->pwdn_gpio)
+		gpiod_set_value(info->pwdn_gpio, 1);
+
+	info->on =3D false;
+}
+
+static int ov7670_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov7670_info *info =3D to_state(sd);
+
+	if (info->on =3D=3D on)
+		return 0;
+
+	if (on) {
+		ov7670_power_on (sd);
+		ov7670_apply_fmt(sd);
+		ov7675_apply_framerate(sd);
+		v4l2_ctrl_handler_setup(&info->hdl);
+	} else {
+		ov7670_power_off (sd);
+	}
+
 	return 0;
 }
=20
@@ -1660,6 +1696,7 @@ static int ov7670_open(struct v4l2_subdev *sd, stru=
ct v4l2_subdev_fh *fh)
 static const struct v4l2_subdev_core_ops ov7670_core_ops =3D {
 	.reset =3D ov7670_reset,
 	.init =3D ov7670_init,
+	.s_power =3D ov7670_s_power,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.g_register =3D ov7670_g_register,
 	.s_register =3D ov7670_s_register,
@@ -1825,6 +1862,7 @@ static int ov7670_probe(struct i2c_client *client,
 		else
 			return ret;
 	}
+
 	if (info->clk) {
 		ret =3D clk_prepare_enable(info->clk);
 		if (ret)
@@ -1841,7 +1879,7 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret)
 		goto clk_disable;
=20
-	ov7670_s_power(sd, 1);
+	ov7670_power_on(sd);
=20
 	/* Make sure it's an ov7670 */
 	ret =3D ov7670_detect(sd);
@@ -1929,7 +1967,7 @@ static int ov7670_probe(struct i2c_client *client,
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
-	ov7670_s_power(sd, 0);
+	ov7670_power_off(sd);
 clk_disable:
 	clk_disable_unprepare(info->clk);
 	return ret;
@@ -1945,7 +1983,7 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
-	ov7670_s_power(sd, 0);
+	ov7670_power_off(sd);
 	return 0;
 }
=20
--=20
2.19.1
