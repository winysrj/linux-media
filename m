Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38247C43387
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C95542070C
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 16:40:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rcQM1lAW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbeLNQkt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 11:40:49 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33656 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbeLNQks (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 11:40:48 -0500
Received: by mail-wm1-f68.google.com with SMTP id r24so16633088wmh.0
        for <linux-media@vger.kernel.org>; Fri, 14 Dec 2018 08:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iLohm9ftKuz8UtcP4m2Wxmj/Qv7F8u2X9gOinGzMN4c=;
        b=rcQM1lAWXbGJHZ/nQWg0A80cWYJcnsqV0fPEZbAwX2E9rBbkKLOiIX9MZROQCM40xd
         d+vzpBLuRz8099RPejHYFfARKhsr9T2c9mwkS2fX5sGFuPcbuYv73gG0xdFdeIrteEbl
         r6jh+9QOt2nm6O66vvjyH9AKXSmq2aES3lk7aSgcgU68QuFDEUeuSr2FgeZc2fVVwRCP
         +gRqnPCObLkI6bHCQ8zL5Z0p1zDMmLQCbz5leoyNdKprFXgY3SuDr+tEaqqKXL6z1vh7
         +u2quU5tcNnbOcVtSWZW63Kp57ZA1tdwDm+vJXndthqDV63YcdbPFpFcT/t5O3p8Y/EV
         Csww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iLohm9ftKuz8UtcP4m2Wxmj/Qv7F8u2X9gOinGzMN4c=;
        b=Am+AZ7Kcx1qy7q+NV0Xrf/HCYTsJ+rMkVjG6fSJopM1iY7LdzNmEQ6KqC2jdnlHUdy
         faV+MJJwCLw7hem0Ya8inNjWQ88XHPJLRcfe+e9ymOSGzE+lvNb8VwVz9sx2JFK73l8O
         4G8nvpscXWkST/Y8IKlc7Ke/ICVZNjlDqVTLR7ZoFEeGZs9zGZYL3c8MUq/YsDFvJxlS
         S0lnGgOZkqgaoobw/6ZHNHNLz16sHYFucLE2MrfRHnGyYYkPrXmwJyDNnP1AKCmdyuk+
         GRPRDyKf7dkC7yWK5SvYb16TbzuMWB5P0x/ihl+k7cYpMGeFsIuwmmmY8O0CjQzK3imj
         Cz/Q==
X-Gm-Message-State: AA+aEWZVrH0Q1A+J2nIycQPRNEUCELfF31/+VjdHwSa6eaf6QMcnGMiY
        PzFh6tLeYE0XBWCbR5CvCLSod21r
X-Google-Smtp-Source: AFSGD/WMyXQ/H8cgvZwI/Gt+degFmJ3e/7lfim56aT3Y50UJaKBYewjqdd3AD3m0p/7RKYcWggSofA==
X-Received: by 2002:a1c:1112:: with SMTP id 18mr4140395wmr.30.1544805646156;
        Fri, 14 Dec 2018 08:40:46 -0800 (PST)
Received: from ped.lan (ip5f5abcae.dynamic.kabel-deutschland.de. [95.90.188.174])
        by smtp.googlemail.com with ESMTPSA id c13sm7680392wrb.38.2018.12.14.08.40.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Dec 2018 08:40:45 -0800 (PST)
From:   Philipp Zabel <philipp.zabel@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 5/8] media: gspca: ov534-ov772x: add SGBRG8 bayer mode support
Date:   Fri, 14 Dec 2018 17:40:28 +0100
Message-Id: <20181214164031.16757-6-philipp.zabel@gmail.com>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20181214164031.16757-1-philipp.zabel@gmail.com>
References: <20181214164031.16757-1-philipp.zabel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add support to pass through the sensor's native SGBRG8 bayer pattern,
allowing to cut the required USB bandwidth in half.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/gspca/ov534.c | 115 +++++++++++++++++++++++++++-----
 1 file changed, 98 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
index 077c49a74709..5b73f7f58ae6 100644
--- a/drivers/media/usb/gspca/ov534.c
+++ b/drivers/media/usb/gspca/ov534.c
@@ -103,6 +103,16 @@ static const struct v4l2_pix_format ov772x_mode[] = {
 	 .sizeimage = 640 * 480 * 2,
 	 .colorspace = V4L2_COLORSPACE_SRGB,
 	 .priv = 0},
+	{320, 240, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
+	 .bytesperline = 320,
+	 .sizeimage = 320 * 240,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 1},
+	{640, 480, V4L2_PIX_FMT_SGRBG8, V4L2_FIELD_NONE,
+	 .bytesperline = 640,
+	 .sizeimage = 640 * 480,
+	 .colorspace = V4L2_COLORSPACE_SRGB,
+	 .priv = 0},
 };
 static const struct v4l2_pix_format ov767x_mode[] = {
 	{320, 240, V4L2_PIX_FMT_JPEG, V4L2_FIELD_NONE,
@@ -127,6 +137,14 @@ static const struct framerates ov772x_framerates[] = {
 		.rates = vga_rates,
 		.nrates = ARRAY_SIZE(vga_rates),
 	},
+	{ /* 320x240 SGBRG8 */
+		.rates = qvga_rates,
+		.nrates = ARRAY_SIZE(qvga_rates),
+	},
+	{ /* 640x480 SGBRG8 */
+		.rates = vga_rates,
+		.nrates = ARRAY_SIZE(vga_rates),
+	},
 };
 
 struct reg_array {
@@ -552,7 +570,7 @@ static const u8 sensor_init_772x[][2] = {
 	{ 0x8e, 0x00 },		/* De-noise threshold */
 	{ 0x0c, 0xd0 }
 };
-static const u8 bridge_start_vga_772x[][2] = {
+static const u8 bridge_start_vga_yuyv_772x[][2] = {
 	{0x88, 0x00},
 	{0x1c, 0x00},
 	{0x1d, 0x40},
@@ -568,7 +586,7 @@ static const u8 bridge_start_vga_772x[][2] = {
 	{0xc2, 0x0c},
 	{0xc3, 0x69},
 };
-static const u8 sensor_start_vga_772x[][2] = {
+static const u8 sensor_start_vga_yuyv_772x[][2] = {
 	{0x12, 0x00},
 	{0x17, 0x26},
 	{0x18, 0xa0},
@@ -577,8 +595,9 @@ static const u8 sensor_start_vga_772x[][2] = {
 	{0x29, 0xa0},
 	{0x2c, 0xf0},
 	{0x65, 0x20},
+	{0x67, 0x00},
 };
-static const u8 bridge_start_qvga_772x[][2] = {
+static const u8 bridge_start_qvga_yuyv_772x[][2] = {
 	{0x88, 0x00},
 	{0x1c, 0x00},
 	{0x1d, 0x40},
@@ -594,7 +613,7 @@ static const u8 bridge_start_qvga_772x[][2] = {
 	{0xc2, 0x0c},
 	{0xc3, 0x69},
 };
-static const u8 sensor_start_qvga_772x[][2] = {
+static const u8 sensor_start_qvga_yuyv_772x[][2] = {
 	{0x12, 0x40},
 	{0x17, 0x3f},
 	{0x18, 0x50},
@@ -603,6 +622,61 @@ static const u8 sensor_start_qvga_772x[][2] = {
 	{0x29, 0x50},
 	{0x2c, 0x78},
 	{0x65, 0x2f},
+	{0x67, 0x00},
+};
+static const u8 bridge_start_vga_gbrg_772x[][2] = {
+	{0x88, 0x08},
+	{0x1c, 0x00},
+	{0x1d, 0x00},
+	{0x1d, 0x02},
+	{0x1d, 0x00},
+	{0x1d, 0x01},
+	{0x1d, 0x2c},
+	{0x1d, 0x00},
+	{0x8d, 0x00},
+	{0x8e, 0x00},
+	{0xc0, 0x50},
+	{0xc1, 0x3c},
+	{0xc2, 0x01},
+	{0xc3, 0x01},
+};
+static const u8 sensor_start_vga_gbrg_772x[][2] = {
+	{0x12, 0x01},
+	{0x17, 0x26},
+	{0x18, 0xa0},
+	{0x19, 0x07},
+	{0x1a, 0xf0},
+	{0x29, 0xa0},
+	{0x2c, 0xf0},
+	{0x65, 0x20},
+	{0x67, 0x02},
+};
+static const u8 bridge_start_qvga_gbrg_772x[][2] = {
+	{0x88, 0x08},
+	{0x1c, 0x00},
+	{0x1d, 0x00},
+	{0x1d, 0x02},
+	{0x1d, 0x00},
+	{0x1d, 0x00},
+	{0x1d, 0x4b},
+	{0x1d, 0x00},
+	{0x8d, 0x00},
+	{0x8e, 0x00},
+	{0xc0, 0x28},
+	{0xc1, 0x1e},
+	{0xc2, 0x01},
+	{0xc3, 0x01},
+};
+static const u8 sensor_start_qvga_gbrg_772x[][2] = {
+	{0x12, 0x41},
+	{0x17, 0x3f},
+	{0x18, 0x50},
+	{0x19, 0x03},
+	{0x1a, 0x78},
+	{0x29, 0x50},
+	{0x2c, 0x78},
+	{0x65, 0x2f},
+	{0x67, 0x02},
 };
 
 static void ov534_reg_write(struct gspca_dev *gspca_dev, u16 reg, u8 val)
@@ -1316,25 +1390,33 @@ static int sd_start(struct gspca_dev *gspca_dev)
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	int mode;
-	static const struct reg_array bridge_start[NSENSORS][2] = {
+	static const struct reg_array bridge_start[NSENSORS][4] = {
 	[SENSOR_OV767x] = {{bridge_start_qvga_767x,
 					ARRAY_SIZE(bridge_start_qvga_767x)},
 			{bridge_start_vga_767x,
 					ARRAY_SIZE(bridge_start_vga_767x)}},
-	[SENSOR_OV772x] = {{bridge_start_qvga_772x,
-					ARRAY_SIZE(bridge_start_qvga_772x)},
-			{bridge_start_vga_772x,
-					ARRAY_SIZE(bridge_start_vga_772x)}},
+	[SENSOR_OV772x] = {{bridge_start_qvga_yuyv_772x,
+				ARRAY_SIZE(bridge_start_qvga_yuyv_772x)},
+			{bridge_start_vga_yuyv_772x,
+				ARRAY_SIZE(bridge_start_vga_yuyv_772x)},
+			{bridge_start_qvga_gbrg_772x,
+				ARRAY_SIZE(bridge_start_qvga_gbrg_772x)},
+			{bridge_start_vga_gbrg_772x,
+				ARRAY_SIZE(bridge_start_vga_gbrg_772x)} },
 	};
-	static const struct reg_array sensor_start[NSENSORS][2] = {
+	static const struct reg_array sensor_start[NSENSORS][4] = {
 	[SENSOR_OV767x] = {{sensor_start_qvga_767x,
 					ARRAY_SIZE(sensor_start_qvga_767x)},
 			{sensor_start_vga_767x,
 					ARRAY_SIZE(sensor_start_vga_767x)}},
-	[SENSOR_OV772x] = {{sensor_start_qvga_772x,
-					ARRAY_SIZE(sensor_start_qvga_772x)},
-			{sensor_start_vga_772x,
-					ARRAY_SIZE(sensor_start_vga_772x)}},
+	[SENSOR_OV772x] = {{sensor_start_qvga_yuyv_772x,
+				ARRAY_SIZE(sensor_start_qvga_yuyv_772x)},
+			{sensor_start_vga_yuyv_772x,
+				ARRAY_SIZE(sensor_start_vga_yuyv_772x)},
+			{sensor_start_qvga_gbrg_772x,
+				ARRAY_SIZE(sensor_start_qvga_gbrg_772x)},
+			{sensor_start_vga_gbrg_772x,
+				ARRAY_SIZE(sensor_start_vga_gbrg_772x)} },
 	};
 
 	/* (from ms-win trace) */
@@ -1440,10 +1522,9 @@ static void sd_pkt_scan(struct gspca_dev *gspca_dev,
 		/* If this packet is marked as EOF, end the frame */
 		} else if (data[1] & UVC_STREAM_EOF) {
 			sd->last_pts = 0;
-			if (gspca_dev->pixfmt.pixelformat == V4L2_PIX_FMT_YUYV
+			if (gspca_dev->pixfmt.pixelformat != V4L2_PIX_FMT_JPEG
 			 && gspca_dev->image_len + len - 12 !=
-				   gspca_dev->pixfmt.width *
-					gspca_dev->pixfmt.height * 2) {
+			    gspca_dev->pixfmt.sizeimage) {
 				gspca_dbg(gspca_dev, D_PACK, "wrong sized frame\n");
 				goto discard;
 			}
-- 
2.20.0

