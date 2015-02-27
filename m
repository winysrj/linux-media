Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44638 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbbB0QKo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Feb 2015 11:10:44 -0500
Received: by wggx12 with SMTP id x12so21310000wgg.11
        for <linux-media@vger.kernel.org>; Fri, 27 Feb 2015 08:10:43 -0800 (PST)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: mt9p031: add support for asynchronous probing
Date: Fri, 27 Feb 2015 16:10:19 +0000
Message-Id: <1425053419-30042-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Both synchronous and asynchronous mt9p031 subdevice probing
is supported by this patch.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/mt9p031.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index af5a09d..9df4e2f 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -28,6 +28,7 @@
 #include <linux/videodev2.h>
 
 #include <media/mt9p031.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
@@ -1145,6 +1146,10 @@ static int mt9p031_probe(struct i2c_client *client,
 	}
 
 	ret = mt9p031_clk_setup(mt9p031);
+	if (ret)
+		goto done;
+
+	ret = v4l2_async_register_subdev(&mt9p031->subdev);
 
 done:
 	if (ret < 0) {
@@ -1162,7 +1167,7 @@ static int mt9p031_remove(struct i2c_client *client)
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 
 	v4l2_ctrl_handler_free(&mt9p031->ctrls);
-	v4l2_device_unregister_subdev(subdev);
+	v4l2_async_unregister_subdev(subdev);
 	media_entity_cleanup(&subdev->entity);
 	mutex_destroy(&mt9p031->power_lock);
 
-- 
1.9.1

