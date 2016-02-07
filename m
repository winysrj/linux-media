Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:34281 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcBGE2F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Feb 2016 23:28:05 -0500
From: Anton Protopopov <a.s.protopopov@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Anton Protopopov <a.s.protopopov@gmail.com>
Subject: [PATCH] media: i2c/adp1653: probe: fix erroneous return value
Date: Sat,  6 Feb 2016 23:27:32 -0500
Message-Id: <1454819252-6773-1-git-send-email-a.s.protopopov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The adp1653_probe() function may return positive value EINVAL
which is obviously wrong.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
---
 drivers/media/i2c/adp1653.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index 7e9cbf7..fb7ed73 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -497,7 +497,7 @@ static int adp1653_probe(struct i2c_client *client,
 		if (!client->dev.platform_data) {
 			dev_err(&client->dev,
 				"Neither DT not platform data provided\n");
-			return EINVAL;
+			return -EINVAL;
 		}
 		flash->platform_data = client->dev.platform_data;
 	}
-- 
2.1.4

