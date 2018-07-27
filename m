Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:40244 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731933AbeG0DG7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 23:06:59 -0400
Received: by mail-pl0-f68.google.com with SMTP id s17-v6so1604899plp.7
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 18:47:31 -0700 (PDT)
From: Matt Ranostay <matt.ranostay@konsulko.com>
To: linux-media@vger.kernel.org
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Subject: [PATCH] media: video-i2c: hwmon: fix return value from amg88xx_hwmon_init()
Date: Thu, 26 Jul 2018 18:47:24 -0700
Message-Id: <20180727014724.5933-1-matt.ranostay@konsulko.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PTR_ERR was making any pointer passed an error pointer, and should be
replaced with PTR_ERR_OR_ZERO which checks if is an actual error condition.

Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
---
 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 7dc9338502e5..06d29d8f6be8 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -167,7 +167,7 @@ static int amg88xx_hwmon_init(struct video_i2c_data *data)
 	void *hwmon = devm_hwmon_device_register_with_info(&data->client->dev,
 				"amg88xx", data, &amg88xx_chip_info, NULL);
 
-	return PTR_ERR(hwmon);
+	return PTR_ERR_OR_ZERO(hwmon);
 }
 #else
 #define	amg88xx_hwmon_init	NULL
-- 
2.17.1
