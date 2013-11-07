Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47598 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3KGMon (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Nov 2013 07:44:43 -0500
Received: by mail-bk0-f51.google.com with SMTP id my12so207146bkb.24
        for <linux-media@vger.kernel.org>; Thu, 07 Nov 2013 04:44:42 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 7 Nov 2013 20:44:42 +0800
Message-ID: <CAPgLHd8g-oO_jcdX8VjzBdO4qe0pwxKvHkMd4+39V=WhcXyHFg@mail.gmail.com>
Subject: [PATCH -next] [media] media: i2c: lm3560: fix missing unlock on error
 in lm3560_set_ctrl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: m.chehab@samsung.com, gshark.jeong@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function lm3560_set_ctrl()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/i2c/lm3560.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 3317a9a..33a6d2a 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -219,15 +219,19 @@ static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 		break;
 
 	case V4L2_CID_FLASH_STROBE:
-		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
-			return -EBUSY;
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH) {
+			rval = -EBUSY;
+			goto err_out;
+		}
 		flash->led_mode = V4L2_FLASH_LED_MODE_FLASH;
 		rval = lm3560_mode_ctrl(flash);
 		break;
 
 	case V4L2_CID_FLASH_STROBE_STOP:
-		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
-			return -EBUSY;
+		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH) {
+			rval = -EBUSY;
+			goto err_out;
+		}
 		flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
 		rval = lm3560_mode_ctrl(flash);
 		break;
@@ -247,8 +251,8 @@ static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 		break;
 	}
 
-	mutex_unlock(&flash->lock);
 err_out:
+	mutex_unlock(&flash->lock);
 	return rval;
 }
 

