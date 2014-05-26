Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42729 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaEZN51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 May 2014 09:57:27 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] mt9v032: register v4l2 asynchronous subdevice
Date: Mon, 26 May 2014 15:57:25 +0200
Message-Id: <1401112645-14884-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/mt9v032.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 29d8d8f..ded97c2 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -985,6 +985,11 @@ static int mt9v032_probe(struct i2c_client *client,
 
 	mt9v032->pad.flags = MEDIA_PAD_FL_SOURCE;
 	ret = media_entity_init(&mt9v032->subdev.entity, 1, &mt9v032->pad, 0);
+	if (ret < 0)
+		return ret;
+
+	mt9v032->subdev.dev = &client->dev;
+	ret = v4l2_async_register_subdev(&mt9v032->subdev);
 
 	if (ret < 0)
 		v4l2_ctrl_handler_free(&mt9v032->ctrls);
-- 
2.0.0.rc2

