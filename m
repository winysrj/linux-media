Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:34986 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932243AbdGTClb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 22:41:31 -0400
Received: by mail-qt0-f194.google.com with SMTP id p25so2040069qtp.2
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 19:41:31 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: hans.verkuil@cisco.com
Cc: slongerbeam@gmail.com, mchehab@s-opensource.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] [media] ov5640: Remove unneeded gpiod NULL check
Date: Wed, 19 Jul 2017 23:41:20 -0300
Message-Id: <1500518480-3568-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

The gpiod API checks for NULL descriptors, so there is no need to
duplicate the check in the driver.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov5640.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 1f5b483..39a2269 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1524,8 +1524,7 @@ static int ov5640_restore_mode(struct ov5640_dev *sensor)
 
 static void ov5640_power(struct ov5640_dev *sensor, bool enable)
 {
-	if (sensor->pwdn_gpio)
-		gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
+	gpiod_set_value(sensor->pwdn_gpio, enable ? 0 : 1);
 }
 
 static void ov5640_reset(struct ov5640_dev *sensor)
-- 
2.7.4
