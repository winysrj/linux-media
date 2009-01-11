Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50371 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751290AbZAKSQF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 13:16:05 -0500
Date: Sun, 11 Jan 2009 19:15:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <damm@igel.co.jp>
Subject: [PATCH 1/2] soc-camera: add data signal polarity flags to drivers
Message-ID: <Pine.LNX.4.64.0901111846220.16531@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All soc-camera camera and host drivers must specify supported data signal 
polarity, after all drivers are fixed, we'll add a suitable test to 
soc_camera_bus_param_compatible().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index 1c67cba..9aff415 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -286,7 +286,8 @@ static struct platform_device camera_device = {
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_HSYNC_ACTIVE_HIGH |
-	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_DATAWIDTH_8,
+	SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER |
+	SOCAM_DATAWIDTH_8,
 };
 
 static struct resource ceu_resources[] = {
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index cc14081..5f493e1 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -418,8 +418,9 @@ static struct platform_device migor_camera_device = {
 #endif /* CONFIG_I2C */
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
-	.flags = SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_PCLK_SAMPLE_RISING \
-	| SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH,
+	.flags = SOCAM_MASTER | SOCAM_DATAWIDTH_8 | SOCAM_PCLK_SAMPLE_RISING
+	| SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH
+	| SOCAM_DATA_ACTIVE_HIGH,
 };
 
 static struct resource migor_ceu_resources[] = {
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index c1bf75e..2d1034d 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -276,7 +276,7 @@ static unsigned long mt9m001_query_bus_param(struct soc_camera_device *icd)
 	/* MT9M001 has all capture_format parameters fixed */
 	unsigned long flags = SOCAM_DATAWIDTH_10 | SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_MASTER;
+		SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER;
 
 	if (bus_switch_possible(mt9m001))
 		flags |= SOCAM_DATAWIDTH_8;
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index 5b8e209..6c363af 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -420,7 +420,7 @@ static unsigned long mt9m111_query_bus_param(struct soc_camera_device *icd)
 	struct soc_camera_link *icl = mt9m111->client->dev.platform_data;
 	unsigned long flags = SOCAM_MASTER | SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_DATAWIDTH_8;
+		SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATAWIDTH_8;
 
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index b04c8cb..6eb4b3a 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -336,7 +336,7 @@ static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 	return SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
 		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_MASTER | SOCAM_SLAVE |
+		SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_SLAVE |
 		width_flag;
 }
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 3c9e0ba..4d8ac6f 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -718,7 +718,7 @@ static unsigned long ov772x_query_bus_param(struct soc_camera_device *icd)
 	struct soc_camera_link *icl = priv->client->dev.platform_data;
 	unsigned long flags = SOCAM_PCLK_SAMPLE_RISING | SOCAM_MASTER |
 		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_HIGH |
-		priv->info->buswidth;
+		SOCAM_DATA_ACTIVE_HIGH | priv->info->buswidth;
 
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 07c334f..7b71b9c 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -879,6 +879,7 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 		SOCAM_HSYNC_ACTIVE_LOW |
 		SOCAM_VSYNC_ACTIVE_HIGH |
 		SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_DATA_ACTIVE_HIGH |
 		SOCAM_PCLK_SAMPLE_RISING |
 		SOCAM_PCLK_SAMPLE_FALLING;
 
