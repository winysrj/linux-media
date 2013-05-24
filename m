Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37393 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3EXLi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 May 2013 07:38:58 -0400
Received: by mail-pa0-f49.google.com with SMTP id bi5so4211236pad.36
        for <linux-media@vger.kernel.org>; Fri, 24 May 2013 04:38:58 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sachin.kamat@linaro.org,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>
Subject: [PATCH 2/2] [media] soc_camera: tw9910: Remove empty function
Date: Fri, 24 May 2013 16:55:07 +0530
Message-Id: <1369394707-13049-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
References: <1369394707-13049-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After the switch to devm_* functions, the 'remove' function does
not do anything. Delete it.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
---
 drivers/media/i2c/soc_camera/tw9910.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/tw9910.c b/drivers/media/i2c/soc_camera/tw9910.c
index bad90b1..6b9cc2a 100644
--- a/drivers/media/i2c/soc_camera/tw9910.c
+++ b/drivers/media/i2c/soc_camera/tw9910.c
@@ -938,11 +938,6 @@ static int tw9910_probe(struct i2c_client *client,
 	return tw9910_video_probe(client);
 }
 
-static int tw9910_remove(struct i2c_client *client)
-{
-	return 0;
-}
-
 static const struct i2c_device_id tw9910_id[] = {
 	{ "tw9910", 0 },
 	{ }
@@ -954,7 +949,6 @@ static struct i2c_driver tw9910_i2c_driver = {
 		.name = "tw9910",
 	},
 	.probe    = tw9910_probe,
-	.remove   = tw9910_remove,
 	.id_table = tw9910_id,
 };
 
-- 
1.7.9.5

