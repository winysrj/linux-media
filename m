Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936475Ab3DRVf6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 10/24] soc-camera: update soc-camera-platform & its users to a new platform data layout
Date: Thu, 18 Apr 2013 23:35:31 +0200
Message-Id: <1366320945-21591-11-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch completes removal of struct soc_camera_link by all platforms.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/board-mackerel.c |   23 ++++++++++------
 arch/sh/boards/mach-ap325rxa/setup.c    |   43 +++++++++++++++++++-----------
 include/media/soc_camera_platform.h     |    8 +----
 3 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-mackerel.c b/arch/arm/mach-shmobile/board-mackerel.c
index db968a5..d6a88f8 100644
--- a/arch/arm/mach-shmobile/board-mackerel.c
+++ b/arch/arm/mach-shmobile/board-mackerel.c
@@ -1181,12 +1181,17 @@ static struct soc_camera_platform_info camera_info = {
 	.set_capture = camera_set_capture,
 };
 
-static struct soc_camera_link camera_link = {
-	.bus_id		= 0,
-	.add_device	= mackerel_camera_add,
-	.del_device	= mackerel_camera_del,
-	.module_name	= "soc_camera_platform",
-	.priv		= &camera_info,
+static struct soc_camera_desc camera_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &camera_link,
+		.drv_priv	= &camera_info,
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.add_device	= mackerel_camera_add,
+		.del_device	= mackerel_camera_del,
+		.module_name	= "soc_camera_platform",
+	},
 };
 
 static struct platform_device *camera_device;
@@ -1198,13 +1203,13 @@ static void mackerel_camera_release(struct device *dev)
 
 static int mackerel_camera_add(struct soc_camera_device *icd)
 {
-	return soc_camera_platform_add(icd, &camera_device, &camera_link,
-				       mackerel_camera_release, 0);
+	return soc_camera_platform_add(icd, &camera_device,
+			&camera_link.subdev_desc, mackerel_camera_release, 0);
 }
 
 static void mackerel_camera_del(struct soc_camera_device *icd)
 {
-	soc_camera_platform_del(icd, camera_device, &camera_link);
+	soc_camera_platform_del(icd, camera_device, &camera_link.subdev_desc);
 }
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 5620e33..4a1be94 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -351,12 +351,17 @@ static struct soc_camera_platform_info camera_info = {
 	.set_capture = camera_set_capture,
 };
 
-static struct soc_camera_link camera_link = {
-	.bus_id		= 0,
-	.add_device	= ap325rxa_camera_add,
-	.del_device	= ap325rxa_camera_del,
-	.module_name	= "soc_camera_platform",
-	.priv		= &camera_info,
+static struct soc_camera_desc camera_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &camera_link,
+		.drv_priv	= &camera_info,
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.module_name	= "soc_camera_platform",
+		.add_device	= ap325rxa_camera_add,
+		.del_device	= ap325rxa_camera_del,
+	},
 };
 
 static struct platform_device *camera_device;
@@ -368,21 +373,22 @@ static void ap325rxa_camera_release(struct device *dev)
 
 static int ap325rxa_camera_add(struct soc_camera_device *icd)
 {
-	int ret = soc_camera_platform_add(icd, &camera_device, &camera_link,
-					  ap325rxa_camera_release, 0);
+	int ret = soc_camera_platform_add(icd, &camera_device,
+			&camera_link.subdev_desc, ap325rxa_camera_release, 0);
 	if (ret < 0)
 		return ret;
 
 	ret = camera_probe();
 	if (ret < 0)
-		soc_camera_platform_del(icd, camera_device, &camera_link);
+		soc_camera_platform_del(icd, camera_device,
+					&camera_link.subdev_desc);
 
 	return ret;
 }
 
 static void ap325rxa_camera_del(struct soc_camera_device *icd)
 {
-	soc_camera_platform_del(icd, camera_device, &camera_link);
+	soc_camera_platform_del(icd, camera_device, &camera_link.subdev_desc);
 }
 #endif /* CONFIG_I2C */
 
@@ -505,12 +511,17 @@ static struct ov772x_camera_info ov7725_info = {
 	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
 };
 
-static struct soc_camera_link ov7725_link = {
-	.bus_id		= 0,
-	.power		= ov7725_power,
-	.board_info	= &ap325rxa_i2c_camera[0],
-	.i2c_adapter_id	= 0,
-	.priv		= &ov7725_info,
+static struct soc_camera_desc ov7725_link = {
+	.subdev_desc	= {
+		.sd_pdata.host_priv = &ov7725_link,
+		.power		= ov7725_power,
+		.drv_priv	= &ov7725_info,
+	},
+	.host_desc	= {
+		.bus_id		= 0,
+		.board_info	= &ap325rxa_i2c_camera[0],
+		.i2c_adapter_id	= 0,
+	},
 };
 
 static struct platform_device ap325rxa_camera[] = {
diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
index 1e5065da..04aacb8 100644
--- a/include/media/soc_camera_platform.h
+++ b/include/media/soc_camera_platform.h
@@ -34,12 +34,10 @@ static inline void soc_camera_platform_release(struct platform_device **pdev)
 
 static inline int soc_camera_platform_add(struct soc_camera_device *icd,
 					  struct platform_device **pdev,
-					  struct soc_camera_link *plink,
+					  struct soc_camera_subdev_desc *ssdd,
 					  void (*release)(struct device *dev),
 					  int id)
 {
-	struct soc_camera_subdev_desc *ssdd =
-		(struct soc_camera_subdev_desc *)plink;
 	struct soc_camera_platform_info *info = ssdd->drv_priv;
 	int ret;
 
@@ -70,10 +68,8 @@ static inline int soc_camera_platform_add(struct soc_camera_device *icd,
 
 static inline void soc_camera_platform_del(const struct soc_camera_device *icd,
 					   struct platform_device *pdev,
-					   const struct soc_camera_link *plink)
+					   const struct soc_camera_subdev_desc *ssdd)
 {
-	const struct soc_camera_subdev_desc *ssdd =
-		(const struct soc_camera_subdev_desc *)plink;
 	if (&icd->sdesc->subdev_desc != ssdd || !pdev)
 		return;
 
-- 
1.7.2.5

