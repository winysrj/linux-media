Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38287 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932165AbbIULXh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 07:23:37 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Boris BREZILLON <boris.brezillon@free-electrons.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] tvp5150: add support for asynchronous probing
Date: Mon, 21 Sep 2015 13:23:09 +0200
Message-Id: <1442834589-1194-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow the subdevice to be probed asynchronously.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/tvp5150.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 522a865c5c60..3c5fb2509c47 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -10,6 +10,7 @@
 #include <linux/videodev2.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-device.h>
 #include <media/tvp5150.h>
 #include <media/v4l2-ctrls.h>
@@ -1172,8 +1173,7 @@ static int tvp5150_probe(struct i2c_client *c,
 	sd->ctrl_handler = &core->hdl;
 	if (core->hdl.error) {
 		res = core->hdl.error;
-		v4l2_ctrl_handler_free(&core->hdl);
-		return res;
+		goto err;
 	}
 	v4l2_ctrl_handler_setup(&core->hdl);
 
@@ -1186,9 +1186,17 @@ static int tvp5150_probe(struct i2c_client *c,
 	core->rect.left = 0;
 	core->rect.width = TVP5150_H_MAX;
 
+	res = v4l2_async_register_subdev(sd);
+	if (res < 0)
+		goto err;
+
 	if (debug > 1)
 		tvp5150_log_status(sd);
 	return 0;
+
+err:
+	v4l2_ctrl_handler_free(&core->hdl);
+	return res;
 }
 
 static int tvp5150_remove(struct i2c_client *c)
@@ -1200,7 +1208,7 @@ static int tvp5150_remove(struct i2c_client *c)
 		"tvp5150.c: removing tvp5150 adapter on address 0x%x\n",
 		c->addr << 1);
 
-	v4l2_device_unregister_subdev(sd);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(&decoder->hdl);
 	return 0;
 }
-- 
2.4.3

