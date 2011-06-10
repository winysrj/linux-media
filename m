Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52515 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab1FJOsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 10:48:51 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so1913781wya.19
        for <linux-media@vger.kernel.org>; Fri, 10 Jun 2011 07:48:51 -0700 (PDT)
Subject: [PATCH 1/2] radio-timb: Simplified platform data
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 16:48:48 +0200
Message-ID: <1307717328.2420.29.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch simplifies the platform data slightly, by removing
unused elements.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index 69272e4..696879e 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -287,12 +287,8 @@ static __devinitdata struct i2c_board_info timberdale_saa7706_i2c_board_info = {
 static __devinitdata struct timb_radio_platform_data
 	timberdale_radio_platform_data = {
 	.i2c_adapter = 0,
-	.tuner = {
-		.info = &timberdale_tef6868_i2c_board_info
-	},
-	.dsp = {
-		.info = &timberdale_saa7706_i2c_board_info
-	}
+	.tuner = &timberdale_tef6868_i2c_board_info,
+	.dsp = &timberdale_saa7706_i2c_board_info
 };
 
 static const __devinitconst struct resource timberdale_video_resources[] = {
diff --git a/include/media/timb_radio.h b/include/media/timb_radio.h
index a59a848..a40a6a3 100644
--- a/include/media/timb_radio.h
+++ b/include/media/timb_radio.h
@@ -23,13 +23,8 @@
 
 struct timb_radio_platform_data {
 	int i2c_adapter; /* I2C adapter where the tuner and dsp are attached */
-	struct {
-		struct i2c_board_info *info;
-	} tuner;
-	struct {
-		const char *module_name;
-		struct i2c_board_info *info;
-	} dsp;
+	struct i2c_board_info *tuner;
+	struct i2c_board_info *dsp;
 };
 
 #endif

