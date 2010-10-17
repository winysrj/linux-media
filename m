Return-path: <mchehab@pedra>
Received: from relay02.digicable.hu ([92.249.128.188]:56117 "EHLO
	relay02.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0JQLoN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 07:44:13 -0400
Message-ID: <4CBAD911.9070800@freemail.hu>
Date: Sun, 17 Oct 2010 13:08:01 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] gspca_sonixj: add hardware vertical flip support for
 hama AC-150
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Márton Németh <nm127@freemail.hu>

The PO2030N sensor chip found in hama AC-150 webcam supports vertical flipping
the image by hardware. Add support for this in the gspca_sonixj driver also.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr b/drivers/media/video/gspca/sonixj.c c/drivers/media/video/gspca/sonixj.c
--- b/drivers/media/video/gspca/sonixj.c	2010-10-17 11:22:33.000000000 +0200
+++ c/drivers/media/video/gspca/sonixj.c	2010-10-17 12:08:12.000000000 +0200
@@ -45,7 +45,7 @@ struct sd {
 	u8 blue;
 	u8 red;
 	u8 gamma;
-	u8 vflip;			/* ov7630/ov7648 only */
+	u8 vflip;			/* ov7630/ov7648/po2030n only */
 	u8 sharpness;
 	u8 infrared;			/* mt9v111 only */
 	u8 freq;			/* ov76xx only */
@@ -219,7 +219,7 @@ static const struct ctrl sd_ctrls[] = {
 	    .set = sd_setautogain,
 	    .get = sd_getautogain,
 	},
-/* ov7630/ov7648 only */
+/* ov7630/ov7648/po2030n only */
 #define VFLIP_IDX 7
 	{
 	    {
@@ -328,7 +328,6 @@ static const __u32 ctrl_dis[] = {

 [SENSOR_PO2030N] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
-			(1 << VFLIP_IDX) |
 			(1 << FREQ_IDX),
 [SENSOR_SOI768] =	(1 << AUTOGAIN_IDX) |
 			(1 << INFRARED_IDX) |
@@ -2136,7 +2135,7 @@ static void setautogain(struct gspca_dev
 		sd->ag_cnt = -1;
 }

-/* hv7131r/ov7630/ov7648 only */
+/* hv7131r/ov7630/ov7648/po2030n only */
 static void setvflip(struct sd *sd)
 {
 	u8 comn;
@@ -2156,6 +2155,20 @@ static void setvflip(struct sd *sd)
 			comn |= 0x80;
 		i2c_w1(&sd->gspca_dev, 0x75, comn);
 		break;
+	case SENSOR_PO2030N:
+		/* Reg. 0x1E: Timing Generator Control Register 2 (Tgcontrol2)
+		 * (reset value: 0x0A)
+		 * bit7: HM: Horizontal Mirror: 0: disable, 1: enable
+		 * bit6: VM: Vertical Mirror: 0: disable, 1: enable
+		 * bit5: ST: Shutter Selection: 0: electrical, 1: mechanical
+		 * bit4: FT: Single Frame Transfer: 0: disable, 1: enable
+		 * bit3-0: X
+		 */
+		comn = 0x0A;
+		if (sd->vflip)
+			comn |= 0x40;
+		i2c_w1(&sd->gspca_dev, 0x1E, comn);
+		break;
 	default:
 /*	case SENSOR_OV7648: */
 		comn = 0x06;
