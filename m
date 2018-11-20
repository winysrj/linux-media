Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46018 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeKUB5k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 20:57:40 -0500
Received: by mail-pf1-f195.google.com with SMTP id g62so1142833pfd.12
        for <linux-media@vger.kernel.org>; Tue, 20 Nov 2018 07:28:00 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: video-i2c: don't use msleep for 1ms - 20ms
Date: Wed, 21 Nov 2018 00:27:40 +0900
Message-Id: <1542727660-14117-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation/timers/timers-howto.txt says:

"msleep(1~20) may not do what the caller intends, and will often sleep
longer (~20 ms actual sleep for any value given in the 1~20ms range)."

So replace msleep(2) by usleep_range(2000, 3000).

Reported-by: Hans Verkuil <hansverk@cisco.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hans Verkuil <hansverk@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
This fixes "[PATCH v4 6/6] media: video-i2c: support runtime PM" in the
patchset "[PATCH v4 0/6] media: video-i2c: support changing frame interval
and runtime PM".

 drivers/media/i2c/video-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 0c82131..77080d7 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -155,7 +155,7 @@ static int amg88xx_set_power_on(struct video_i2c_data *data)
 	if (ret)
 		return ret;
 
-	msleep(2);
+	usleep_range(2000, 3000);
 
 	ret = regmap_write(data->regmap, AMG88XX_REG_RST, AMG88XX_RST_FLAG);
 	if (ret)
-- 
2.7.4
