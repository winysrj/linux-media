Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:51528 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbeIYQV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Sep 2018 12:21:59 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, tfiga@chromium.org, bingbu.cao@intel.com,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        tian.shu.qiu@intel.com, ricardo.ribalda@gmail.com,
        grundler@chromium.org, ping-chung.chen@intel.com,
        andy.yeh@intel.com, jim.lai@intel.com, helmut.grohne@intenta.de,
        laurent.pinchart@ideasonboard.com, snawrocki@kernel.org
Subject: [PATCH 5/5] smiapp: Set control units
Date: Tue, 25 Sep 2018 13:14:34 +0300
Message-Id: <20180925101434.20327-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
References: <20180925101434.20327-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assign units for the controls exposed by the smiapp driver.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 99f3b295ae3c7..289313c232430 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -562,17 +562,10 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 	sensor->vblank = v4l2_ctrl_new_std(
 		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_VBLANK, 0, 1, 1, 0);
-
-	if (sensor->vblank)
-		sensor->vblank->flags |= V4L2_CTRL_FLAG_UPDATE;
-
 	sensor->hblank = v4l2_ctrl_new_std(
 		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_HBLANK, 0, 1, 1, 0);
 
-	if (sensor->hblank)
-		sensor->hblank->flags |= V4L2_CTRL_FLAG_UPDATE;
-
 	sensor->pixel_rate_parray = v4l2_ctrl_new_std(
 		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
 		V4L2_CID_PIXEL_RATE, 1, INT_MAX, 1, 1);
@@ -589,6 +582,13 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		return sensor->pixel_array->ctrl_handler.error;
 	}
 
+	sensor->exposure->unit = V4L2_CTRL_UNIT_LINE;
+	sensor->vblank->flags |= V4L2_CTRL_FLAG_UPDATE;
+	sensor->vblank->unit = V4L2_CTRL_UNIT_LINE;
+	sensor->hblank->flags |= V4L2_CTRL_FLAG_UPDATE;
+	sensor->hblank->unit = V4L2_CTRL_UNIT_PIXEL;
+	sensor->pixel_rate_parray->unit = V4L2_CTRL_UNIT_PIXELS_PER_SEC;
+
 	sensor->pixel_array->sd.ctrl_handler =
 		&sensor->pixel_array->ctrl_handler;
 
@@ -611,6 +611,8 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		return sensor->src->ctrl_handler.error;
 	}
 
+	sensor->pixel_rate_csi->unit = V4L2_CTRL_UNIT_PIXELS_PER_SEC;
+
 	sensor->src->sd.ctrl_handler = &sensor->src->ctrl_handler;
 
 	return 0;
-- 
2.11.0
