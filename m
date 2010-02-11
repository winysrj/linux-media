Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:35261 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755882Ab0BKQXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2010 11:23:01 -0500
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH] tm6000: add i2c bus id for tm6000
Date: Thu, 11 Feb 2010 17:22:07 +0100
Message-Id: <1265905327-6172-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |    2 --
 include/linux/i2c-id.h              |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index 05df06b..6b17d0b 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -32,8 +32,6 @@
 #include "tuner-xc2028.h"
 
 
-/*FIXME: Hack to avoid needing to patch i2c-id.h */
-#define I2C_HW_B_TM6000 I2C_HW_B_EM28XX
 /* ----------------------------------------------------------- */
 
 static unsigned int i2c_debug = 0;
diff --git a/include/linux/i2c-id.h b/include/linux/i2c-id.h
index e844a0b..09e3a4e 100644
--- a/include/linux/i2c-id.h
+++ b/include/linux/i2c-id.h
@@ -42,6 +42,7 @@
 #define I2C_HW_B_AU0828		0x010023 /* auvitek au0828 usb bridge */
 #define I2C_HW_B_CX231XX	0x010024 /* Conexant CX231XX USB based cards */
 #define I2C_HW_B_HDPVR		0x010025 /* Hauppauge HD PVR */
+#define I2C_HW_B_TM6000		0x010026 /* TM5600/TM6000/TM6010 media bridge */
 
 /* --- SGI adapters							*/
 #define I2C_HW_SGI_VINO		0x160000
-- 
1.6.6.1

