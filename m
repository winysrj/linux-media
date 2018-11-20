Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:50085 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725950AbeKTUcT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 15:32:19 -0500
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
Subject: [PATCH v3 04/14] media: ov7670: control clock along with power
Date: Tue, 20 Nov 2018 11:03:09 +0100
Message-Id: <20181120100318.367987-5-lkundrak@v3.sk>
In-Reply-To: <20181120100318.367987-1-lkundrak@v3.sk>
References: <20181120100318.367987-1-lkundrak@v3.sk>
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
 drivers/media/i2c/ov7670.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index cbaab60aaaac..d7635fb2d713 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1623,14 +1623,17 @@ static void ov7670_power_on(struct v4l2_subdev *s=
d)
 	if (info->on)
 		return;
=20
+	clk_prepare_enable(info->clk);
+
 	if (info->pwdn_gpio)
 		gpiod_set_value(info->pwdn_gpio, 0);
 	if (info->resetb_gpio) {
 		gpiod_set_value(info->resetb_gpio, 1);
 		usleep_range(500, 1000);
 		gpiod_set_value(info->resetb_gpio, 0);
-		usleep_range(3000, 5000);
 	}
+	if (info->pwdn_gpio || info->resetb_gpio || info->clk)
+		usleep_range(3000, 5000);
=20
 	info->on =3D true;
 }
@@ -1642,6 +1645,8 @@ static void ov7670_power_off(struct v4l2_subdev *sd=
)
 	if (!info->on)
 		return;
=20
+	clk_disable_unprepare(info->clk);
+
 	if (info->pwdn_gpio)
 		gpiod_set_value(info->pwdn_gpio, 1);
=20
@@ -1863,24 +1868,20 @@ static int ov7670_probe(struct i2c_client *client=
,
 			return ret;
 	}
=20
-	if (info->clk) {
-		ret =3D clk_prepare_enable(info->clk);
-		if (ret)
-			return ret;
+	ret =3D ov7670_init_gpio(client, info);
+	if (ret)
+		return ret;
=20
+	ov7670_power_on(sd);
+
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
-	ov7670_power_on(sd);
-
 	/* Make sure it's an ov7670 */
 	ret =3D ov7670_detect(sd);
 	if (ret) {
@@ -1960,6 +1961,7 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret < 0)
 		goto entity_cleanup;
=20
+	ov7670_power_off(sd);
 	return 0;
=20
 entity_cleanup:
@@ -1968,12 +1970,9 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_handler_free(&info->hdl);
 power_off:
 	ov7670_power_off(sd);
-clk_disable:
-	clk_disable_unprepare(info->clk);
 	return ret;
 }
=20
-
 static int ov7670_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd =3D i2c_get_clientdata(client);
@@ -1981,7 +1980,6 @@ static int ov7670_remove(struct i2c_client *client)
=20
 	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
-	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
 	ov7670_power_off(sd);
 	return 0;
--=20
2.19.1
