Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34153 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730371AbeK0VBh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 16:01:37 -0500
From: Marco Felsch <m.felsch@pengutronix.de>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc: enrico.scholz@sigma-chemnitz.de, devicetree@vger.kernel.org,
        akinobu.mita@gmail.com, linux-media@vger.kernel.org,
        graphics@pengutronix.de
Subject: [PATCH v3 1/6] media: mt9m111: add s_stream callback
Date: Tue, 27 Nov 2018 11:02:48 +0100
Message-Id: <20181127100253.30845-2-m.felsch@pengutronix.de>
In-Reply-To: <20181127100253.30845-1-m.felsch@pengutronix.de>
References: <20181127100253.30845-1-m.felsch@pengutronix.de>
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
index 58d134dcdf44..03559669de9f 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -220,6 +220,7 @@ struct mt9m111 {
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
+	bool is_streaming;
 #ifdef CONFIG_MEDIA_CONTROLLER
 	struct media_pad pad;
 #endif
@@ -910,6 +911,14 @@ static int mt9m111_enum_mbus_code(struct v4l2_subdev *sd,
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
@@ -923,6 +932,7 @@ static int mt9m111_g_mbus_config(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops mt9m111_subdev_video_ops = {
 	.g_mbus_config	= mt9m111_g_mbus_config,
+	.s_stream	= mt9m111_s_stream,
 };
 
 static const struct v4l2_subdev_pad_ops mt9m111_subdev_pad_ops = {
-- 
2.19.1
