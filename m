Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:26558 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753216AbZESPKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 11:10:35 -0400
Message-ID: <969753.76402.qm@web110810.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 08:10:36 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_44] Siano: smscore - fix some new GPIO definitions names
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch
# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242746121 -10800
# Node ID 2b865fa7f195524bc9e8557dac472140755058dd
# Parent  749c11a362a9fad1992809007247d5c76c35bfc9
[09051_44] Siano: smscore - fix some new GPIO definitions names

From: Uri Shkolnik <uris@siano-ms.com>

Fix some definitions' names, in order to emphasize the names
differences between the old and new GPIO implementations.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r 749c11a362a9 -r 2b865fa7f195 linux/drivers/media/dvb/siano/smscoreapi.h
--- a/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 17:49:30 2009 +0300
+++ b/linux/drivers/media/dvb/siano/smscoreapi.h	Tue May 19 18:15:21 2009 +0300
@@ -581,10 +581,10 @@ struct smscore_gpio_config {
 #define SMS_GPIO_DIRECTION_OUTPUT 1
 	u8 Direction;
 
-#define SMS_GPIO_PULLUPDOWN_NONE     0
-#define SMS_GPIO_PULLUPDOWN_PULLDOWN 1
-#define SMS_GPIO_PULLUPDOWN_PULLUP   2
-#define SMS_GPIO_PULLUPDOWN_KEEPER   3
+#define SMS_GPIO_PULL_UP_DOWN_NONE     0
+#define SMS_GPIO_PULL_UP_DOWN_PULLDOWN 1
+#define SMS_GPIO_PULL_UP_DOWN_PULLUP   2
+#define SMS_GPIO_PULL_UP_DOWN_KEEPER   3
 	u8 PullUpDown;
 
 #define SMS_GPIO_INPUT_CHARACTERISTICS_NORMAL  0
@@ -608,13 +608,12 @@ struct smscore_gpio_config {
 
 #define SMS_GPIO_OUTPUT_DRIVING_1_5mA		0 /* 11xx */
 #define SMS_GPIO_OUTPUT_DRIVING_2_8mA		1 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_4mA			2 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_7mA			3 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_10mA			4 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_11mA			5 /* 11xx */
-#define SMS_GPIO_OUTPUT_DRIVING_14mA			6 /* 11xx */
-#undef SMS_GPIO_OUTPUT_DRIVING_16mA
-#define SMS_GPIO_OUTPUT_DRIVING_16mA			7 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_4mA		2 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_7mA		3 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_10mA		4 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_11mA		5 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_14mA		6 /* 11xx */
+#define SMS_GPIO_OUTPUT_DRIVING_16mA		7 /* 11xx */
 	u8 OutputDriving;
 };
 



      
