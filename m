Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:33028 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3ASXnC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Jan 2013 18:43:02 -0500
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: mchehab@redhat.com
Cc: peter.senna@gmail.com, david@hardeman.nu, elezegarcia@gmail.com,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH V2 23/24] usb/hdpvr/hdpvr-i2c.c: use IS_ENABLED() macro
Date: Sat, 19 Jan 2013 21:41:30 -0200
Message-Id: <1358638891-4775-24-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
References: <1358638891-4775-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

replace:
 #if defined(CONFIG_I2C) || \
     defined(CONFIG_I2C_MODULE)
with:
 #if IS_ENABLED(CONFIG_I2C)

This change was made for: CONFIG_I2C

Reported-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V1:
   Updated subject

 drivers/media/usb/hdpvr/hdpvr-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
index 6c5054f..a38f58c 100644
--- a/drivers/media/usb/hdpvr/hdpvr-i2c.c
+++ b/drivers/media/usb/hdpvr/hdpvr-i2c.c
@@ -13,7 +13,7 @@
  *
  */
 
-#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
+#if IS_ENABLED(CONFIG_I2C)
 
 #include <linux/i2c.h>
 #include <linux/slab.h>
-- 
1.7.11.7

