Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65181 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3FXJWh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Jun 2013 05:22:37 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id AA61A40BB3
	for <linux-media@vger.kernel.org>; Mon, 24 Jun 2013 11:22:35 +0200 (CEST)
Date: Mon, 24 Jun 2013 11:22:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L2: fix compilation if CONFIG_I2C is undefined
Message-ID: <Pine.LNX.4.64.1306241121230.19735@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_verify_client() is only available, if I2C is enabled. Fix v4l2-async.c
compilation if I2C is disabled.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/v4l2-core/v4l2-async.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index c80ffb4..aae2417 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -24,11 +24,15 @@
 
 static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 {
+#if IS_ENABLED(CONFIG_I2C)
 	struct i2c_client *client = i2c_verify_client(dev);
 	return client &&
 		asd->bus_type == V4L2_ASYNC_BUS_I2C &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
+#else
+	return false;
+#endif
 }
 
 static bool match_platform(struct device *dev, struct v4l2_async_subdev *asd)
-- 
1.7.2.5

