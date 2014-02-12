Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaBLJCo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 04:02:44 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Daniel Jeong <gshark.jeong@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 2/3] lm3560: keep style for the comments
Date: Wed, 12 Feb 2014 11:02:06 +0200
Message-Id: <1392195727-1494-2-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1392195727-1494-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1392195727-1494-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Let's keep the style for all comments in the code, namely using small letters
whenever it's possible.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/lm3560.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index fea37a3..93e5227 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -36,7 +36,7 @@
 #define REG_FLAG		0xd0
 #define REG_CONFIG1		0xe0
 
-/* Fault Mask */
+/* fault mask */
 #define FAULT_TIMEOUT	(1<<0)
 #define FAULT_OVERTEMP	(1<<1)
 #define FAULT_SHORT_CIRCUIT	(1<<2)
@@ -47,7 +47,8 @@ enum led_enable {
 	MODE_FLASH = 0x3,
 };
 
-/* struct lm3560_flash
+/**
+ * struct lm3560_flash
  *
  * @pdata: platform data
  * @regmap: reg. map for i2c
@@ -92,7 +93,7 @@ static int lm3560_mode_ctrl(struct lm3560_flash *flash)
 	return rval;
 }
 
-/* led1/2  enable/disable */
+/* led1/2 enable/disable */
 static int lm3560_enable_ctrl(struct lm3560_flash *flash,
 			      enum lm3560_led_id led_no, bool on)
 {
@@ -162,7 +163,7 @@ static int lm3560_flash_brt_ctrl(struct lm3560_flash *flash,
 	return rval;
 }
 
-/* V4L2 controls  */
+/* v4l2 controls  */
 static int lm3560_get_ctrl(struct v4l2_ctrl *ctrl, enum lm3560_led_id led_no)
 {
 	struct lm3560_flash *flash = to_lm3560_flash(ctrl, led_no);
@@ -291,6 +292,7 @@ static int lm3560_init_controls(struct lm3560_flash *flash,
 	const struct v4l2_ctrl_ops *ops = &lm3560_led_ctrl_ops[led_no];
 
 	v4l2_ctrl_handler_init(hdl, 8);
+
 	/* flash mode */
 	v4l2_ctrl_new_std_menu(hdl, ops, V4L2_CID_FLASH_LED_MODE,
 			       V4L2_FLASH_LED_MODE_TORCH, ~0x7,
@@ -303,6 +305,7 @@ static int lm3560_init_controls(struct lm3560_flash *flash,
 
 	/* flash strobe */
 	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
+
 	/* flash strobe stop */
 	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
 
@@ -389,7 +392,7 @@ static int lm3560_init_device(struct lm3560_flash *flash)
 	rval = lm3560_mode_ctrl(flash);
 	if (rval < 0)
 		return rval;
-	/* Reset faults */
+	/* reset faults */
 	rval = regmap_read(flash->regmap, REG_FLAG, &reg_val);
 	return rval;
 }
-- 
1.9.0.rc3

