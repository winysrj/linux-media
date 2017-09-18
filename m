Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.246]:33060 "EHLO
        DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751377AbdIRBcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 21:32:09 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v3 3/3] media: ov7670: Add the s_power operation
Date: Mon, 18 Sep 2017 09:29:27 +0800
Message-ID: <20170918012928.13278-4-wenyou.yang@microchip.com>
In-Reply-To: <20170918012928.13278-1-wenyou.yang@microchip.com>
References: <20170918012928.13278-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the s_power operation which is responsible for manipulating the
power dowm mode through the PWDN pin and the reset operation through
the RESET pin.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v3: None
Changes in v2:
 - Add the patch to support the get_fmt ops.
 - Remove the redundant invoking ov7670_init_gpio().

 drivers/media/i2c/ov7670.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 5d6f1859a39b..66b9bf2111f7 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1529,6 +1529,22 @@ static int ov7670_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regis
 }
 #endif
 
+static int ov7670_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct ov7670_info *info = to_state(sd);
+
+	if (info->pwdn_gpio)
+		gpiod_direction_output(info->pwdn_gpio, !on);
+	if (on && info->resetb_gpio) {
+		gpiod_set_value(info->resetb_gpio, 1);
+		usleep_range(500, 1000);
+		gpiod_set_value(info->resetb_gpio, 0);
+		usleep_range(3000, 5000);
+	}
+
+	return 0;
+}
+
 static void ov7670_get_default_format(struct v4l2_subdev *sd,
 				      struct v4l2_mbus_framefmt *format)
 {
@@ -1560,6 +1576,7 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 	.g_register = ov7670_g_register,
 	.s_register = ov7670_s_register,
 #endif
+	.s_power = ov7670_s_power,
 };
 
 static const struct v4l2_subdev_video_ops ov7670_video_ops = {
@@ -1673,23 +1690,25 @@ static int ov7670_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	ret = ov7670_init_gpio(client, info);
-	if (ret)
-		goto clk_disable;
-
 	info->clock_speed = clk_get_rate(info->clk) / 1000000;
 	if (info->clock_speed < 10 || info->clock_speed > 48) {
 		ret = -EINVAL;
 		goto clk_disable;
 	}
 
+	ret = ov7670_init_gpio(client, info);
+	if (ret)
+		goto clk_disable;
+
+	ov7670_s_power(sd, 1);
+
 	/* Make sure it's an ov7670 */
 	ret = ov7670_detect(sd);
 	if (ret) {
 		v4l_dbg(1, debug, client,
 			"chip found @ 0x%x (%s) is not an ov7670 chip.\n",
 			client->addr << 1, client->adapter->name);
-		goto clk_disable;
+		goto power_off;
 	}
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
@@ -1764,6 +1783,8 @@ static int ov7670_probe(struct i2c_client *client,
 	media_entity_cleanup(&info->sd.entity);
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
+power_off:
+	ov7670_s_power(sd, 0);
 clk_disable:
 	clk_disable_unprepare(info->clk);
 	return ret;
@@ -1779,6 +1800,7 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
 	media_entity_cleanup(&info->sd.entity);
+	ov7670_s_power(sd, 0);
 	return 0;
 }
 
-- 
2.13.0
