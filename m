Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:41499 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbeJSX5X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 19:57:23 -0400
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com
Cc: akinobu.mita@gmail.com, enrico.scholz@sigma-chemnitz.de,
        linux-media@vger.kernel.org, kernel@pengutronix.de
Subject: [PATCH 1/4] media: mt9m111: add s_stream callback
Date: Fri, 19 Oct 2018 17:50:24 +0200
Message-Id: <20181019155027.28682-2-m.felsch@pengutronix.de>
In-Reply-To: <20181019155027.28682-1-m.felsch@pengutronix.de>
References: <20181019155027.28682-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add callback to check if we are already streaming. Now other callbacks
can check the state and return -EBUSY if we already streaming.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/media/i2c/mt9m111.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index efda1aa95ca0..78d08a81e0e2 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -217,6 +217,7 @@ struct mt9m111 {
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
+	bool is_streaming;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -880,6 +881,14 @@ static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int mt9m111_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct mt9m111 *mt9m111 = container_of(sd, struct mt9m111, subdev);
+
+	mt9m111->is_streaming = !!enable;
+	return 0;
+}
+
 static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 				struct v4l2_mbus_config *cfg)
 {
@@ -893,6 +902,7 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_mbus_config	= mt9m111_g_mbus_config,
+	.s_stream	= mt9m111_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
-- 
2.19.0
