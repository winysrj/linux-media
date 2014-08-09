Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:61825 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIF6p (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Aug 2014 01:58:45 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so2151865pde.38
        for <linux-media@vger.kernel.org>; Fri, 08 Aug 2014 22:58:44 -0700 (PDT)
Message-ID: <1407563920.5172.0.camel@phoenix>
Subject: [PATCH 1/4] [media] ov7670: Include media/v4l2-image-sizes.h
From: Axel Lin <axel.lin@ingics.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org
Date: Sat, 09 Aug 2014 13:58:40 +0800
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So we can remove the same defines in the driver code.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/media/i2c/ov7670.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index cdd7c1b..dd3db24 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -19,6 +19,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-mediabus.h>
+#include <media/v4l2-image-sizes.h>
 #include <media/ov7670.h>
 
 MODULE_AUTHOR("Jonathan Corbet <corbet@lwn.net>");
@@ -30,19 +31,6 @@ module_param(debug, bool, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
 /*
- * Basic window sizes.  These probably belong somewhere more globally
- * useful.
- */
-#define VGA_WIDTH	640
-#define VGA_HEIGHT	480
-#define QVGA_WIDTH	320
-#define QVGA_HEIGHT	240
-#define CIF_WIDTH	352
-#define CIF_HEIGHT	288
-#define QCIF_WIDTH	176
-#define	QCIF_HEIGHT	144
-
-/*
  * The 7670 sits on i2c with ID 0x42
  */
 #define OV7670_I2C_ADDR 0x42
-- 
1.9.1



