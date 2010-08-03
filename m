Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:41340 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932151Ab0HCPZ0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 11:25:26 -0400
Subject: [PATCH 3/3 v2] mfd: Add timberdale video-in driver to timberdale
From: Richard =?ISO-8859-1?Q?R=F6jfors?=
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 17:19:32 +0200
Message-ID: <1280848772.19898.165.camel@debian>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch defines platform data for the video-in driver
and adds it to all configurations of timberdale.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index ac59950..d4a95bd 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -40,6 +40,7 @@
 #include <linux/spi/mc33880.h>
 
 #include <media/timb_radio.h>
+#include <media/timb_video.h>
 
 #include <linux/timb_dma.h>
 
@@ -238,6 +239,22 @@ static const __devinitconst struct resource timberdale_uartlite_resources[] = {
 	},
 };
 
+static __devinitdata struct i2c_board_info timberdale_adv7180_i2c_board_info = {
+	/* Requires jumper JP9 to be off */
+	I2C_BOARD_INFO("adv7180", 0x42 >> 1),
+	.irq = IRQ_TIMBERDALE_ADV7180
+};
+
+static __devinitdata struct timb_video_platform_data
+	timberdale_video_platform_data = {
+	.dma_channel = DMA_VIDEO_RX,
+	.i2c_adapter = 0,
+	.encoder = {
+		.module_name = "adv7180",
+		.info = &timberdale_adv7180_i2c_board_info
+	}
+};
+
 static const __devinitconst struct resource timberdale_radio_resources[] = {
 	{
 		.start	= RDSOFFSET,
@@ -272,6 +289,18 @@ static __devinitdata struct timb_radio_platform_data
 	}
 };
 
+static const __devinitconst struct resource timberdale_video_resources[] = {
+	{
+		.start	= LOGIWOFFSET,
+		.end	= LOGIWEND,
+		.flags	= IORESOURCE_MEM,
+	},
+	/*
+	note that the "frame buffer" is located in DMA area
+	starting at 0x1200000
+	*/
+};
+
 static __devinitdata struct timb_dma_platform_data timb_dma_platform_data = {
 	.nr_channels = 10,
 	.channels = {
@@ -372,6 +401,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -430,6 +466,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.resources = timberdale_mlogicore_resources,
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -478,6 +521,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
@@ -521,6 +571,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.data_size = sizeof(timberdale_gpio_platform_data),
 	},
 	{
+		.name = "timb-video",
+		.num_resources = ARRAY_SIZE(timberdale_video_resources),
+		.resources = timberdale_video_resources,
+		.platform_data = &timberdale_video_platform_data,
+		.data_size = sizeof(timberdale_video_platform_data),
+	},
+	{
 		.name = "timb-radio",
 		.num_resources = ARRAY_SIZE(timberdale_radio_resources),
 		.resources = timberdale_radio_resources,
diff --git a/drivers/mfd/timberdale.h b/drivers/mfd/timberdale.h
index c11bf6e..4412acd 100644
--- a/drivers/mfd/timberdale.h
+++ b/drivers/mfd/timberdale.h
@@ -23,7 +23,7 @@
 #ifndef MFD_TIMBERDALE_H
 #define MFD_TIMBERDALE_H
 
-#define DRV_VERSION		"0.2"
+#define DRV_VERSION		"0.3"
 
 /* This driver only support versions >= 3.8 and < 4.0  */
 #define TIMB_SUPPORTED_MAJOR	3

