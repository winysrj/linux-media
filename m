Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:52739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936430Ab3DRVf5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:57 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 09/24] SH: update all soc-camera users to new platform data layout
Date: Thu, 18 Apr 2013 23:35:30 +0200
Message-Id: <1366320945-21591-10-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch moves almost all SH soc-camera users towards re-using subdevice
drivers. Only mach-ap325rxa/setup.c will be updated separately, together
with other soc-camera-platform users.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/sh/boards/mach-ecovec24/setup.c |   51 ++++++++++++++++++++++------------
 arch/sh/boards/mach-kfr2r09/setup.c  |   15 ++++++---
 arch/sh/boards/mach-migor/setup.c    |   30 +++++++++++++------
 3 files changed, 63 insertions(+), 33 deletions(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index aaff767..51e25e1 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -809,12 +809,17 @@ static struct tw9910_video_info tw9910_info = {
 	.mpout		= TW9910_MPO_FIELD,
 };
 
-static struct soc_camera_link tw9910_link = {
-	.i2c_adapter_id	= 0,
-	.bus_id		= 1,
-	.power		= tw9910_power,
-	.board_info	= &i2c_camera[0],
-	.priv		= &tw9910_info,
+static struct soc_camera_desc tw9910_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &tw9910_link,
+		.power		= tw9910_power,
+		.drv_priv	= &tw9910_info,
+	},
+	.host_desc	= {
+		.i2c_adapter_id	= 0,
+		.bus_id		= 1,
+		.board_info	= &i2c_camera[0],
+	},
 };
 
 /* mt9t112 */
@@ -832,12 +837,17 @@ static struct mt9t112_camera_info mt9t112_info1 = {
 	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
 };
 
-static struct soc_camera_link mt9t112_link1 = {
-	.i2c_adapter_id	= 0,
-	.power		= mt9t112_power1,
-	.bus_id		= 0,
-	.board_info	= &i2c_camera[1],
-	.priv		= &mt9t112_info1,
+static struct soc_camera_desc mt9t112_link1 = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &mt9t112_link1,
+		.power		= mt9t112_power1,
+		.drv_priv	= &mt9t112_info1,
+	},
+	.host_desc	= {
+		.i2c_adapter_id	= 0,
+		.bus_id		= 0,
+		.board_info	= &i2c_camera[1],
+	},
 };
 
 static int mt9t112_power2(struct device *dev, int mode)
@@ -854,12 +864,17 @@ static struct mt9t112_camera_info mt9t112_info2 = {
 	.divider = { 0x49, 0x6, 0, 6, 0, 9, 9, 6, 0 }, /* for 24MHz */
 };
 
-static struct soc_camera_link mt9t112_link2 = {
-	.i2c_adapter_id	= 1,
-	.power		= mt9t112_power2,
-	.bus_id		= 1,
-	.board_info	= &i2c_camera[2],
-	.priv		= &mt9t112_info2,
+static struct soc_camera_desc mt9t112_link2 = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &mt9t112_link2,
+		.power		= mt9t112_power2,
+		.drv_priv	= &mt9t112_info2,
+	},
+	.host_desc	= {
+		.i2c_adapter_id	= 1,
+		.bus_id		= 1,
+		.board_info	= &i2c_camera[2],
+	},
 };
 
 static struct platform_device camera_devices[] = {
diff --git a/arch/sh/boards/mach-kfr2r09/setup.c b/arch/sh/boards/mach-kfr2r09/setup.c
index ab502f12..5cb62c7 100644
--- a/arch/sh/boards/mach-kfr2r09/setup.c
+++ b/arch/sh/boards/mach-kfr2r09/setup.c
@@ -331,11 +331,16 @@ static struct rj54n1_pdata rj54n1_priv = {
 	.ioctl_high	= false,
 };
 
-static struct soc_camera_link rj54n1_link = {
-	.power		= camera_power,
-	.board_info	= &kfr2r09_i2c_camera,
-	.i2c_adapter_id	= 1,
-	.priv		= &rj54n1_priv,
+static struct soc_camera_desc rj54n1_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &rj54n1_link,
+		.power		= camera_power,
+		.drv_priv	= &rj54n1_priv,
+	},
+	.host_desc	= {
+		.board_info	= &kfr2r09_i2c_camera,
+		.i2c_adapter_id	= 1,
+	},
 };
 
 static struct platform_device kfr2r09_camera = {
diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 8b73194e..5df19d7 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -447,11 +447,16 @@ static struct i2c_board_info migor_i2c_camera[] = {
 
 static struct ov772x_camera_info ov7725_info;
 
-static struct soc_camera_link ov7725_link = {
-	.power		= ov7725_power,
-	.board_info	= &migor_i2c_camera[0],
-	.i2c_adapter_id	= 0,
-	.priv		= &ov7725_info,
+static struct soc_camera_desc ov7725_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &ov7725_link,
+		.power		= ov7725_power,
+		.drv_priv	= &ov7725_info,
+	},
+	.host_desc	= {
+		.board_info	= &migor_i2c_camera[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct tw9910_video_info tw9910_info = {
@@ -459,11 +464,16 @@ static struct tw9910_video_info tw9910_info = {
 	.mpout		= TW9910_MPO_FIELD,
 };
 
-static struct soc_camera_link tw9910_link = {
-	.power		= tw9910_power,
-	.board_info	= &migor_i2c_camera[1],
-	.i2c_adapter_id	= 0,
-	.priv		= &tw9910_info,
+static struct soc_camera_desc tw9910_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &tw9910_link,
+		.power		= tw9910_power,
+		.drv_priv	= &tw9910_info,
+	},
+	.host_desc	= {
+		.board_info	= &migor_i2c_camera[1],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device migor_camera[] = {
-- 
1.7.2.5

