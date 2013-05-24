Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58708 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3EXLiz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 07:38:55 -0400
Received: by mail-pa0-f47.google.com with SMTP id kl12so749288pab.20
        for <linux-media@vger.kernel.org>; Fri, 24 May 2013 04:38:55 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH 1/2] [media] soc_camera: mt9t112: Remove empty function
Date: Fri, 24 May 2013 16:55:06 +0530
Message-Id: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the switch to devm_* functions, the 'remove' function does
not do anything. Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/i2c/soc_camera/mt9t112.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/mt9t112.c b/drivers/media/i2c/soc_camera/mt9t112.c
index a7256b7..0af29a4 100644
--- a/drivers/media/i2c/soc_camera/mt9t112.c
+++ b/drivers/media/i2c/soc_camera/mt9t112.c
@@ -1118,11 +1118,6 @@ static int mt9t112_probe(struct i2c_client *client,
 	return ret;
 }
 
-static int mt9t112_remove(struct i2c_client *client)
-{
-	return 0;
-}
-
 static const struct i2c_device_id mt9t112_id[] = {
 	{ "mt9t112", 0 },
 	{ }
@@ -1134,7 +1129,6 @@ static struct i2c_driver mt9t112_i2c_driver = {
 		.name = "mt9t112",
 	},
 	.probe    = mt9t112_probe,
-	.remove   = mt9t112_remove,
 	.id_table = mt9t112_id,
 };
 
-- 
1.7.9.5

