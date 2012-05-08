Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37729 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab2EHNsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 09:48:35 -0400
Received: from localhost.localdomain (unknown [91.178.164.92])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 67A637B0B
	for <linux-media@vger.kernel.org>; Tue,  8 May 2012 15:48:34 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH] mt9p031: Add support for core and I/O regulators
Date: Tue,  8 May 2012 15:48:34 +0200
Message-Id: <1336484914-12007-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The regulators are optional. If present, enable them when powering the
sensor up, and disable them when powering it down.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/mt9p031.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 8f061d9..d0b8e36 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -19,6 +19,7 @@
 #include <linux/i2c.h>
 #include <linux/log2.h>
 #include <linux/pm.h>
+#include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
@@ -121,6 +122,9 @@ struct mt9p031 {
 	struct mutex power_lock; /* lock to protect power_count */
 	int power_count;
 
+	struct regulator *vdd_core;
+	struct regulator *vdd_io;
+
 	enum mt9p031_model model;
 	struct aptina_pll pll;
 	int reset;
@@ -264,6 +268,12 @@ static int mt9p031_power_on(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
+	/* Bring up the supplies */
+	if (mt9p031->vdd_core)
+		regulator_enable(mt9p031->vdd_core);
+	if (mt9p031->vdd_io)
+		regulator_enable(mt9p031->vdd_io);
+
 	/* Emable clock */
 	if (mt9p031->pdata->set_xclk)
 		mt9p031->pdata->set_xclk(&mt9p031->subdev,
@@ -285,6 +295,11 @@ static void mt9p031_power_off(struct mt9p031 *mt9p031)
 		usleep_range(1000, 2000);
 	}
 
+	if (mt9p031->vdd_io)
+		regulator_disable(mt9p031->vdd_io);
+	if (mt9p031->vdd_core)
+		regulator_disable(mt9p031->vdd_core);
+
 	if (mt9p031->pdata->set_xclk)
 		mt9p031->pdata->set_xclk(&mt9p031->subdev, 0);
 }
@@ -950,6 +965,9 @@ static int mt9p031_probe(struct i2c_client *client,
 	mt9p031->model = did->driver_data;
 	mt9p031->reset = -1;
 
+	mt9p031->vdd_core = devm_regulator_get(&client->dev, "cam_core");
+	mt9p031->vdd_io = devm_regulator_get(&client->dev, "cam_io");
+
 	v4l2_ctrl_handler_init(&mt9p031->ctrls, ARRAY_SIZE(mt9p031_ctrls) + 4);
 
 	v4l2_ctrl_new_std(&mt9p031->ctrls, &mt9p031_ctrl_ops,
-- 
Regards,

Laurent Pinchart

