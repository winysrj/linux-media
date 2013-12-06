Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36979 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3LFFnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 00:43:51 -0500
Received: by mail-pb0-f52.google.com with SMTP id uo5so426583pbc.25
        for <linux-media@vger.kernel.org>; Thu, 05 Dec 2013 21:43:51 -0800 (PST)
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Jeong <gshark.jeong@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	<linux-media@vger.kernel.org>
Subject: [PATCH V2 -next] [media] media: i2c: lm3560: fix missing unlock on error in lm3560_get_ctrl().
Date: Fri,  6 Dec 2013 14:43:27 +0900
Message-Id: <1386308607-6127-1-git-send-email-gshark.jeong@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry I should have checked below things before sending the first patch.
Correct reference of reading values. (rval -> reg_val)
Add the missing unlock before return from function lm3560_get_ctrl()
to avoid deadlock. 
Thank you Dan Carpenter & Sakari.


Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/media/i2c/lm3560.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index 3317a9a..ab5857d 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -172,28 +172,28 @@ static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
 static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 {
 	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
+	int rval = -EINVAL;
 
 	mutex_lock(&flash->lock);
 
 	if (ctrl->id == V4L2_CID_FLASH_FAULT) {
-		int rval;
 		s32 fault = 0;
 		unsigned int reg_val;
 		rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
 		if (rval < 0)
-			return rval;
-		if (rval & FAULT_SHORT_CIRCUIT)
+			goto out;
+		if (reg_val & FAULT_SHORT_CIRCUIT)
 			fault |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
-		if (rval & FAULT_OVERTEMP)
+		if (reg_val & FAULT_OVERTEMP)
 			fault |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
-		if (rval & FAULT_TIMEOUT)
+		if (reg_val & FAULT_TIMEOUT)
 			fault |= V4L2_FLASH_FAULT_TIMEOUT;
 		ctrl->cur.val = fault;
-		return 0;
 	}
 
+out:
 	mutex_unlock(&flash->lock);
-	return -EINVAL;
+	return rval;
 }
 
 static int lm3560_set_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
-- 
1.7.9.5

