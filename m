Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:65495 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752359AbeCCUvT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 15:51:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/11] media: em28xx-reg.h: Fix coding style issues
Date: Sat,  3 Mar 2018 17:51:04 -0300
Message-Id: <271e1072ce311ae2d2b30f9cf9afb68940a9697c.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520110127.git.mchehab@s-opensource.com>
References: <cover.1520110127.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use BIT() macros and fix one comment that is not following
the Kernel coding style.

It should be noticed that the registers bit masks should be
casted to unsigned char, as, otherwise, it would produce
warnings like:

	drivers/media/usb/em28xx/em28xx-cards.c:81:33: warning: large integer implicitly truncated to unsigned type [-Woverflow]
	  {EM2820_R08_GPIO_CTRL, 0x6d,   ~EM_GPIO_4, 10},
	                                 ^

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-reg.h | 45 ++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
index 26a06b1b1077..f53afe18e92d 100644
--- a/drivers/media/usb/em28xx/em28xx-reg.h
+++ b/drivers/media/usb/em28xx/em28xx-reg.h
@@ -4,19 +4,19 @@
  * em28xx-reg.h - Register definitions for em28xx driver
  */
 
-#define EM_GPIO_0  (1 << 0)
-#define EM_GPIO_1  (1 << 1)
-#define EM_GPIO_2  (1 << 2)
-#define EM_GPIO_3  (1 << 3)
-#define EM_GPIO_4  (1 << 4)
-#define EM_GPIO_5  (1 << 5)
-#define EM_GPIO_6  (1 << 6)
-#define EM_GPIO_7  (1 << 7)
+#define EM_GPIO_0  ((unsigned char)BIT(0))
+#define EM_GPIO_1  ((unsigned char)BIT(1))
+#define EM_GPIO_2  ((unsigned char)BIT(2))
+#define EM_GPIO_3  ((unsigned char)BIT(3))
+#define EM_GPIO_4  ((unsigned char)BIT(4))
+#define EM_GPIO_5  ((unsigned char)BIT(5))
+#define EM_GPIO_6  ((unsigned char)BIT(6))
+#define EM_GPIO_7  ((unsigned char)BIT(7))
 
-#define EM_GPO_0   (1 << 0)
-#define EM_GPO_1   (1 << 1)
-#define EM_GPO_2   (1 << 2)
-#define EM_GPO_3   (1 << 3)
+#define EM_GPO_0   ((unsigned char)BIT(0))
+#define EM_GPO_1   ((unsigned char)BIT(1))
+#define EM_GPO_2   ((unsigned char)BIT(2))
+#define EM_GPO_3   ((unsigned char)BIT(3))
 
 /* em28xx endpoints */
 /* 0x82:   (always ?) analog */
@@ -208,10 +208,11 @@
 #define EM28XX_R43_AC97BUSY	0x43
 
 #define EM28XX_R45_IR		0x45
-	/* 0x45  bit 7    - parity bit
-		 bits 6-0 - count
-	   0x46  IR brand
-	   0x47  IR data
+	/*
+	 * 0x45  bit 7    - parity bit
+	 *	 bits 6-0 - count
+	 * 0x46  IR brand
+	 *  0x47  IR data
 	 */
 
 /* em2874 registers */
@@ -254,12 +255,12 @@
 #define EM2874_IR_RC6_MODE_6A   0x0b
 
 /* em2874 Transport Stream Enable Register (0x5f) */
-#define EM2874_TS1_CAPTURE_ENABLE (1 << 0)
-#define EM2874_TS1_FILTER_ENABLE  (1 << 1)
-#define EM2874_TS1_NULL_DISCARD   (1 << 2)
-#define EM2874_TS2_CAPTURE_ENABLE (1 << 4)
-#define EM2874_TS2_FILTER_ENABLE  (1 << 5)
-#define EM2874_TS2_NULL_DISCARD   (1 << 6)
+#define EM2874_TS1_CAPTURE_ENABLE ((unsigned char)BIT(0))
+#define EM2874_TS1_FILTER_ENABLE  ((unsigned char)BIT(1))
+#define EM2874_TS1_NULL_DISCARD   ((unsigned char)BIT(2))
+#define EM2874_TS2_CAPTURE_ENABLE ((unsigned char)BIT(4))
+#define EM2874_TS2_FILTER_ENABLE  ((unsigned char)BIT(5))
+#define EM2874_TS2_NULL_DISCARD   ((unsigned char)BIT(6))
 
 /* register settings */
 #define EM2800_AUDIO_SRC_TUNER  0x0d
-- 
2.14.3
