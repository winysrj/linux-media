Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:49690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307Ab1G2K5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:06 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 878D7189B6F
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:02 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkY-0007pq-EU
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:57:02 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 59/59] V4L: soc-camera: remove soc-camera client bus-param operations and supporting code
Date: Fri, 29 Jul 2011 12:56:59 +0200
Message-Id: <1311937019-29914-60-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

soc-camera has been completely ported over to V4L2 subdevice mbus-config
operations, soc-camera client bus-param operations and supporting code
can now be removed.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   34 ------------------------
 include/media/soc_camera.h       |   52 ++++++--------------------------------
 2 files changed, 8 insertions(+), 78 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index e05d1c7..ac23916 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -141,40 +141,6 @@ unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
 }
 EXPORT_SYMBOL(soc_camera_apply_board_flags);
 
-/**
- * soc_camera_apply_sensor_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
- * @icl:	camera platform parameters
- * @flags:	flags to be inverted according to platform configuration
- * @return:	resulting flags
- */
-unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
-					    unsigned long flags)
-{
-	unsigned long f;
-
-	/* If only one of the two polarities is supported, switch to the opposite */
-	if (icl->flags & SOCAM_SENSOR_INVERT_HSYNC) {
-		f = flags & (SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW);
-		if (f == SOCAM_HSYNC_ACTIVE_HIGH || f == SOCAM_HSYNC_ACTIVE_LOW)
-			flags ^= SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW;
-	}
-
-	if (icl->flags & SOCAM_SENSOR_INVERT_VSYNC) {
-		f = flags & (SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW);
-		if (f == SOCAM_VSYNC_ACTIVE_HIGH || f == SOCAM_VSYNC_ACTIVE_LOW)
-			flags ^= SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW;
-	}
-
-	if (icl->flags & SOCAM_SENSOR_INVERT_PCLK) {
-		f = flags & (SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING);
-		if (f == SOCAM_PCLK_SAMPLE_RISING || f == SOCAM_PCLK_SAMPLE_FALLING)
-			flags ^= SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING;
-	}
-
-	return flags;
-}
-EXPORT_SYMBOL(soc_camera_apply_sensor_flags);
-
 #define pixfmtstr(x) (x) & 0xff, ((x) >> 8) & 0xff, ((x) >> 16) & 0xff, \
 	((x) >> 24) & 0xff
 
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 73337cf..1864e22 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -12,6 +12,7 @@
 #ifndef SOC_CAMERA_H
 #define SOC_CAMERA_H
 
+#include <linux/bitops.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/pm.h>
@@ -194,8 +195,6 @@ struct soc_camera_format_xlate {
 };
 
 struct soc_camera_ops {
-	unsigned long (*query_bus_param)(struct soc_camera_device *);
-	int (*set_bus_param)(struct soc_camera_device *, unsigned long);
 	const struct v4l2_queryctrl *controls;
 	int num_controls;
 };
@@ -238,53 +237,18 @@ static inline struct v4l2_queryctrl const *soc_camera_find_qctrl(
 	return NULL;
 }
 
-#define SOCAM_MASTER			(1 << 0)
-#define SOCAM_SLAVE			(1 << 1)
-#define SOCAM_HSYNC_ACTIVE_HIGH		(1 << 2)
-#define SOCAM_HSYNC_ACTIVE_LOW		(1 << 6)
-#define SOCAM_VSYNC_ACTIVE_HIGH		(1 << 4)
-#define SOCAM_VSYNC_ACTIVE_LOW		(1 << 5)
-#define SOCAM_DATAWIDTH_4		(1 << 3)
-#define SOCAM_DATAWIDTH_8		(1 << 7)
-#define SOCAM_DATAWIDTH_9		(1 << 8)
-#define SOCAM_DATAWIDTH_10		(1 << 9)
-#define SOCAM_DATAWIDTH_15		(1 << 14)
-#define SOCAM_DATAWIDTH_16		(1 << 15)
-#define SOCAM_PCLK_SAMPLE_RISING	(1 << 12)
-#define SOCAM_PCLK_SAMPLE_FALLING	(1 << 13)
-#define SOCAM_DATA_ACTIVE_HIGH		(1 << 10)
-#define SOCAM_DATA_ACTIVE_LOW		(1 << 11)
-#define SOCAM_MIPI_1LANE		(1 << 16)
-#define SOCAM_MIPI_2LANE		(1 << 17)
-#define SOCAM_MIPI_3LANE		(1 << 18)
-#define SOCAM_MIPI_4LANE		(1 << 19)
-#define SOCAM_MIPI	(SOCAM_MIPI_1LANE | SOCAM_MIPI_2LANE | \
-			SOCAM_MIPI_3LANE | SOCAM_MIPI_4LANE)
+#define SOCAM_DATAWIDTH(x)	BIT((x) - 1)
+#define SOCAM_DATAWIDTH_4	SOCAM_DATAWIDTH(4)
+#define SOCAM_DATAWIDTH_8	SOCAM_DATAWIDTH(8)
+#define SOCAM_DATAWIDTH_9	SOCAM_DATAWIDTH(9)
+#define SOCAM_DATAWIDTH_10	SOCAM_DATAWIDTH(10)
+#define SOCAM_DATAWIDTH_15	SOCAM_DATAWIDTH(15)
+#define SOCAM_DATAWIDTH_16	SOCAM_DATAWIDTH(16)
 
 #define SOCAM_DATAWIDTH_MASK (SOCAM_DATAWIDTH_4 | SOCAM_DATAWIDTH_8 | \
 			      SOCAM_DATAWIDTH_9 | SOCAM_DATAWIDTH_10 | \
 			      SOCAM_DATAWIDTH_15 | SOCAM_DATAWIDTH_16)
 
-static inline unsigned long soc_camera_bus_param_compatible(
-			unsigned long camera_flags, unsigned long bus_flags)
-{
-	unsigned long common_flags, hsync, vsync, pclk, data, buswidth, mode;
-	unsigned long mipi;
-
-	common_flags = camera_flags & bus_flags;
-
-	hsync = common_flags & (SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW);
-	vsync = common_flags & (SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW);
-	pclk = common_flags & (SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING);
-	data = common_flags & (SOCAM_DATA_ACTIVE_HIGH | SOCAM_DATA_ACTIVE_LOW);
-	mode = common_flags & (SOCAM_MASTER | SOCAM_SLAVE);
-	buswidth = common_flags & SOCAM_DATAWIDTH_MASK;
-	mipi = common_flags & SOCAM_MIPI;
-
-	return ((!hsync || !vsync || !pclk || !data || !mode || !buswidth) && !mipi) ? 0 :
-		common_flags;
-}
-
 static inline void soc_camera_limit_side(int *start, int *length,
 		unsigned int start_min,
 		unsigned int length_min, unsigned int length_max)
-- 
1.7.2.5

