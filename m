Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58437 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3ABLpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 06:45:14 -0500
Received: from avalon.ideasonboard.com (unknown [91.178.66.146])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 049E8359DC
	for <linux-media@vger.kernel.org>; Wed,  2 Jan 2013 12:45:12 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] mt9p031: Add support for regulators
Date: Wed,  2 Jan 2013 12:46:40 +0100
Message-Id: <1357127200-7672-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the regulators when powering the sensor up, and disable them when
powering it down.

The regulators are mandatory. Boards that don't allow controlling the
sensor power lines must provide dummy regulators.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/mt9p031.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e0bad59..ecf4492 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
@@ -121,6 +122,10 @@ struct mt9p031 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 
+	struct regulator *vaa;
+	struct regulator *vdd;
+	struct regulator *vdd_io;
+
 	enum mt9p031_model model;
 	struct aptina_pll pll;
 	int reset;
@@ -264,6 +269,11 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
+	/* Bring up the supplies */
+	regulator_enable(mt9p031->vdd);
+	regulator_enable(mt9p031->vdd_io);
+	regulator_enable(mt9p031->vaa);
+
 	/* Emable clock */
 	if (mt9p031->pdata->set_xclk)
 		mt9p031->pdata->set_xclk(&mt9p031->subdev,
@@ -285,6 +295,10 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
+	regulator_disable(mt9p031->vaa);
+	regulator_disable(mt9p031->vdd_io);
+	regulator_disable(mt9p031->vdd);
+
 	if (mt9p031->pdata->set_xclk)
 		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
 }
@@ -937,6 +951,16 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->model = did->driver_data;
 	mt9p031->reset = -1;
 
+	mt9p031->vaa = devm_regulator_get(&client->dev, "vaa");
+	mt9p031->vdd = devm_regulator_get(&client->dev, "vdd");
+	mt9p031->vdd_io = devm_regulator_get(&client->dev, "vdd_io");
+
+	if (IS_ERR(mt9p031->vaa) || IS_ERR(mt9p031->vdd) ||
+	    IS_ERR(mt9p031->vdd_io)) {
+		dev_err(&client->dev, "Unable to get regulators\n");
+		return -ENODEV;
+	}
+
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 6);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
-- 
1.7.8.6

