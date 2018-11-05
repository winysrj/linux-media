Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:49529 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727537AbeKEQtm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 11:49:42 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>,
        James Cameron <quozl@laptop.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 02/11] media: ov7670: control clock along with power
Date: Mon,  5 Nov 2018 08:30:45 +0100
Message-Id: <20181105073054.24407-3-lkundrak@v3.sk>
In-Reply-To: <20181105073054.24407-1-lkundrak@v3.sk>
References: <20181105073054.24407-1-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This provides more power saving when the sensor is off.

While at that, do the delay on power/clock enable even if the sensor driv=
er
itself doesn't control the GPIOs. This is required for the OLPC XO-1
platform, that lacks the proper power/reset properties in its DT, but
needs the delay after the sensor is clocked up.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/i2c/ov7670.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index d87f2362bf40..a3e72c62382c 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -241,6 +241,7 @@ struct ov7670_info {
 	struct v4l2_mbus_framefmt format;
 	struct ov7670_format_struct *fmt;  /* Current format */
 	struct clk *clk;
+	int on;
 	struct gpio_desc *resetb_gpio;
 	struct gpio_desc *pwdn_gpio;
 	unsigned int mbus_config;	/* Media bus configuration flags */
@@ -1610,15 +1611,26 @@ static int ov7670_s_power(struct v4l2_subdev *sd,=
 int on)
 {
 	struct ov7670_info *info =3D to_state(sd);
=20
+	if (info->on =3D=3D on)
+		return 0;
+
+	if (on)
+		clk_prepare_enable(info->clk);
+	else
+		clk_disable_unprepare(info->clk);
+
 	if (info->pwdn_gpio)
 		gpiod_set_value(info->pwdn_gpio, !on);
 	if (on && info->resetb_gpio) {
 		gpiod_set_value(info->resetb_gpio, 1);
 		usleep_range(500, 1000);
 		gpiod_set_value(info->resetb_gpio, 0);
-		usleep_range(3000, 5000);
 	}
=20
+	if (on && (info->pwdn_gpio || info->resetb_gpio || info->clk))
+		usleep_range(3000, 5000);
+
+	info->on =3D on;
 	return 0;
 }
=20
@@ -1817,24 +1829,20 @@ static int ov7670_probe(struct i2c_client *client=
,
 		else
 			return ret;
 	}
-	if (info->clk) {
-		ret =3D clk_prepare_enable(info->clk);
-		if (ret)
-			return ret;
+	ret =3D ov7670_init_gpio(client, info);
+	if (ret)
+		return ret;
+
+	ov7670_s_power(sd, 1);
=20
+	if (info->clk) {
 		info->clock_speed =3D clk_get_rate(info->clk) / 1000000;
 		if (info->clock_speed < 10 || info->clock_speed > 48) {
 			ret =3D -EINVAL;
-			goto clk_disable;
+			goto power_off;
 		}
 	}
=20
-	ret =3D ov7670_init_gpio(client, info);
-	if (ret)
-		goto clk_disable;
-
-	ov7670_s_power(sd, 1);
-
 	/* Make sure it's an ov7670 */
 	ret =3D ov7670_detect(sd);
 	if (ret) {
@@ -1913,6 +1921,7 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto entity_cleanup;
=20
+	ov7670_s_power(sd, 0);
 	return 0;
=20
 entity_cleanup:
@@ -1921,12 +1930,9 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
 	ov7670_s_power(sd, 0);
-clk_disable:
-	clk_disable_unprepare(info->clk);
 	return ret;
 }
=20
-
 static int ov7670_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
@@ -1934,7 +1940,6 @@ static int ov7670_remove(struct i2c_client *client)
=20
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
-	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
 	ov7670_s_power(sd, 0);
 	return 0;
--=20
2.19.1
