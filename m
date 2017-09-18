Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:35051 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751913AbdIRBbZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Sep 2017 21:31:25 -0400
From: Wenyou Yang <wenyou.yang@microchip.com>
To: Jonathan Corbet <corbet@lwn.net>
CC: Nicolas Ferre <nicolas.ferre@microchip.com>,
        <linux-kernel@vger.kernel.org>, Sakari Ailus <sakari.ailus@iki.fi>,
        <linux-arm-kernel@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Wenyou Yang <wenyou.yang@microchip.com>
Subject: [PATCH v3 1/3] media: ov7670: Add entity pads initialization
Date: Mon, 18 Sep 2017 09:29:25 +0800
Message-ID: <20170918012928.13278-2-wenyou.yang@microchip.com>
In-Reply-To: <20170918012928.13278-1-wenyou.yang@microchip.com>
References: <20170918012928.13278-1-wenyou.yang@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the media entity pads initialization.

Signed-off-by: Wenyou Yang <wenyou.yang@microchip.com>
---

Changes in v3: None
Changes in v2: None

 drivers/media/i2c/ov7670.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e88549f0e704..5c8460ee65c3 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -213,6 +213,7 @@ struct ov7670_devtype {
 struct ov7670_format_struct;  /* coming later */
 struct ov7670_info {
 	struct v4l2_subdev sd;
+	struct media_pad pad;
 	struct v4l2_ctrl_handler hdl;
 	struct {
 		/* gain cluster */
@@ -1688,14 +1689,23 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l2_ctrl_auto_cluster(2, &info->auto_exposure,
 			       V4L2_EXPOSURE_MANUAL, false);
 	v4l2_ctrl_cluster(2, &info->saturation);
+
+	info->pad.flags = MEDIA_PAD_FL_SOURCE;
+	info->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
+	ret = media_entity_pads_init(&info->sd.entity, 1, &info->pad);
+	if (ret < 0)
+		goto hdl_free;
+
 	v4l2_ctrl_handler_setup(&info->hdl);
 
 	ret = v4l2_async_register_subdev(&info->sd);
 	if (ret < 0)
-		goto hdl_free;
+		goto entity_cleanup;
 
 	return 0;
 
+entity_cleanup:
+	media_entity_cleanup(&info->sd.entity);
 hdl_free:
 	v4l2_ctrl_handler_free(&info->hdl);
 clk_disable:
@@ -1712,6 +1722,7 @@ static int ov7670_remove(struct i2c_client *client)
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&info->hdl);
 	clk_disable_unprepare(info->clk);
+	media_entity_cleanup(&info->sd.entity);
 	return 0;
 }
 
-- 
2.13.0
