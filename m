Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46030 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdJWRao (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 13:30:44 -0400
Received: by mail-pg0-f67.google.com with SMTP id b192so12308113pga.2
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 10:30:44 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] media: ov9650: remove unnecessary terminated entry in menu items array
Date: Tue, 24 Oct 2017 02:30:26 +0900
Message-Id: <1508779826-12499-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The test_pattern_menu[] array has two valid items and a null terminated
item.  So the control's maximum value which is passed to
v4l2_ctrl_new_std_menu_items() should be one.  However,
'ARRAY_SIZE(test_pattern_menu) - 1' is actually passed and it's not
correct.

Fix it by removing unnecessary terminated entry and let the correct
control's maximum value be passed to v4l2_ctrl_new_std_menu_items().

Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov9650.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 6ffb460..69433e1 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -985,7 +985,6 @@ static const struct v4l2_ctrl_ops ov965x_ctrl_ops = {
 static const char * const test_pattern_menu[] = {
 	"Disabled",
 	"Color bars",
-	NULL
 };
 
 static int ov965x_initialize_controls(struct ov965x *ov965x)
-- 
2.7.4
