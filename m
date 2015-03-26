Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45230 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbbCZUsJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 16:48:09 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Eduardo Valentin <edubezval@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH] media: radio-si4713: improve usage of gpiod API
Date: Thu, 26 Mar 2015 21:47:53 +0100
Message-Id: <1427402873-2007-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
which appeared in v3.17-rc1, the gpiod_get* functions take an additional
parameter that allows to specify direction and initial value for output.
Simplify accordingly.

Moreover use the _optional variant which has tighter error checking, but
is simpler to use which allows further simplification.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/radio/si4713/si4713.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index c90004dac170..e9d03ac69a27 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -383,7 +383,7 @@ static int si4713_powerup(struct si4713_device *sdev)
 		}
 	}
 
-	if (!IS_ERR(sdev->gpio_reset)) {
+	if (sdev->gpio_reset) {
 		udelay(50);
 		gpiod_set_value(sdev->gpio_reset, 1);
 	}
@@ -407,8 +407,7 @@ static int si4713_powerup(struct si4713_device *sdev)
 						SI4713_STC_INT | SI4713_CTS);
 		return err;
 	}
-	if (!IS_ERR(sdev->gpio_reset))
-		gpiod_set_value(sdev->gpio_reset, 0);
+	gpiod_set_value(sdev->gpio_reset, 0);
 
 
 	if (sdev->vdd) {
@@ -447,7 +446,7 @@ static int si4713_powerdown(struct si4713_device *sdev)
 		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
 				resp[0]);
 		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
-		if (!IS_ERR(sdev->gpio_reset))
+		if (sdev->gpio_reset)
 			gpiod_set_value(sdev->gpio_reset, 0);
 
 		if (sdev->vdd) {
@@ -1460,14 +1459,9 @@ static int si4713_probe(struct i2c_client *client,
 		goto exit;
 	}
 
-	sdev->gpio_reset = devm_gpiod_get(&client->dev, "reset");
-	if (!IS_ERR(sdev->gpio_reset)) {
-		gpiod_direction_output(sdev->gpio_reset, 0);
-	} else if (PTR_ERR(sdev->gpio_reset) == -ENOENT) {
-		dev_dbg(&client->dev, "No reset GPIO assigned\n");
-	} else if (PTR_ERR(sdev->gpio_reset) == -ENOSYS) {
-		dev_dbg(&client->dev, "No reset GPIO support\n");
-	} else {
+	sdev->gpio_reset = devm_gpiod_get_optional(&client->dev, "reset",
+						   GPIOD_OUT_LOW);
+	if (IS_ERR(sdev->gpio_reset)) {
 		rval = PTR_ERR(sdev->gpio_reset);
 		dev_err(&client->dev, "Failed to request gpio: %d\n", rval);
 		goto exit;
-- 
2.1.4

