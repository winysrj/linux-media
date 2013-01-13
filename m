Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f179.google.com ([209.85.215.179]:48550 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3AMOUg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Jan 2013 09:20:36 -0500
Received: by mail-ea0-f179.google.com with SMTP id i12so1314372eaa.38
        for <linux-media@vger.kernel.org>; Sun, 13 Jan 2013 06:20:35 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 7/7] em28xx: input: use common work_struct callback function for IR RC key polling
Date: Sun, 13 Jan 2013 15:20:45 +0100
Message-Id: <1358086845-6989-7-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358086845-6989-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove em28xx_i2c_ir_work() and check the device type in the common callback
function em28xx_ir_work() instead. Simplifies em28xx_ir_start().
Reduces the code size with a minor performance drawback.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-input.c |   18 +++++-------------
 1 Datei geändert, 5 Zeilen hinzugefügt(+), 13 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 2a49cc1..6ff6775 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -338,19 +338,14 @@ static void em28xx_ir_handle_key(struct em28xx_IR *ir)
 	}
 }
 
-static void em28xx_i2c_ir_work(struct work_struct *work)
-{
-	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
-
-	em28xx_i2c_ir_handle_key(ir);
-	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
-}
-
 static void em28xx_ir_work(struct work_struct *work)
 {
 	struct em28xx_IR *ir = container_of(work, struct em28xx_IR, work.work);
 
-	em28xx_ir_handle_key(ir);
+	if (ir->i2c_dev_addr) /* external i2c device */
+		em28xx_i2c_ir_handle_key(ir);
+	else /* internal device */
+		em28xx_ir_handle_key(ir);
 	schedule_delayed_work(&ir->work, msecs_to_jiffies(ir->polling));
 }
 
@@ -358,10 +353,7 @@ static int em28xx_ir_start(struct rc_dev *rc)
 {
 	struct em28xx_IR *ir = rc->priv;
 
-	if (ir->i2c_dev_addr) /* external i2c device */
-		INIT_DELAYED_WORK(&ir->work, em28xx_i2c_ir_work);
-	else /* internal device */
-		INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
+	INIT_DELAYED_WORK(&ir->work, em28xx_ir_work);
 	schedule_delayed_work(&ir->work, 0);
 
 	return 0;
-- 
1.7.10.4

