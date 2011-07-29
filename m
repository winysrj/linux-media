Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:64477 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab1G2K5D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jul 2011 06:57:03 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 35E0A189B89
	for <linux-media@vger.kernel.org>; Fri, 29 Jul 2011 12:57:00 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1QmkkV-0007nE-UR
	for linux-media@vger.kernel.org; Fri, 29 Jul 2011 12:56:59 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 06/59] V4L: soc-camera: add helper functions for new bus configuration type
Date: Fri, 29 Jul 2011 12:56:06 +0200
Message-Id: <1311937019-29914-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
References: <1311937019-29914-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions to process the new media bus configuration type
similar to soc_camera_apply_sensor_flags() and
soc_camera_bus_param_compatible().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c   |   34 ++++++++++++++++++++++++++++++++++
 drivers/media/video/soc_mediabus.c |   33 +++++++++++++++++++++++++++++++++
 include/media/soc_camera.h         |    6 ++++--
 include/media/soc_mediabus.h       |    2 ++
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 5bdfe7e..8b16152 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -108,6 +108,40 @@ const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
 
 /**
+ * soc_camera_apply_board_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
+ * @icl:	camera platform parameters
+ * @cfg:	media bus configuration
+ * @return:	resulting flags
+ */
+unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
+					   const struct v4l2_mbus_config *cfg)
+{
+	unsigned long f, flags = cfg->flags;
+
+	/* If only one of the two polarities is supported, switch to the opposite */
+	if (icl->flags & SOCAM_SENSOR_INVERT_HSYNC) {
+		f = flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW);
+		if (f == V4L2_MBUS_HSYNC_ACTIVE_HIGH || f == V4L2_MBUS_HSYNC_ACTIVE_LOW)
+			flags ^= V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW;
+	}
+
+	if (icl->flags & SOCAM_SENSOR_INVERT_VSYNC) {
+		f = flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW);
+		if (f == V4L2_MBUS_VSYNC_ACTIVE_HIGH || f == V4L2_MBUS_VSYNC_ACTIVE_LOW)
+			flags ^= V4L2_MBUS_VSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_LOW;
+	}
+
+	if (icl->flags & SOCAM_SENSOR_INVERT_PCLK) {
+		f = flags & (V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING);
+		if (f == V4L2_MBUS_PCLK_SAMPLE_RISING || f == V4L2_MBUS_PCLK_SAMPLE_FALLING)
+			flags ^= V4L2_MBUS_PCLK_SAMPLE_RISING | V4L2_MBUS_PCLK_SAMPLE_FALLING;
+	}
+
+	return flags;
+}
+EXPORT_SYMBOL(soc_camera_apply_board_flags);
+
+/**
  * soc_camera_apply_sensor_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
  * @icl:	camera platform parameters
  * @flags:	flags to be inverted according to platform configuration
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index bea7c9c..cf7f219 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -383,6 +383,39 @@ const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 }
 EXPORT_SYMBOL(soc_mbus_get_fmtdesc);
 
+unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
+					unsigned int flags)
+{
+	unsigned long common_flags;
+	bool hsync = true, vsync = true, pclk, data, mode;
+	bool mipi_lanes, mipi_clock;
+
+	common_flags = cfg->flags & flags;
+
+	switch (cfg->type) {
+	case V4L2_MBUS_PARALLEL:
+		hsync = common_flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH |
+					V4L2_MBUS_HSYNC_ACTIVE_LOW);
+		vsync = common_flags & (V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+					V4L2_MBUS_VSYNC_ACTIVE_LOW);
+	case V4L2_MBUS_BT656:
+		pclk = common_flags & (V4L2_MBUS_PCLK_SAMPLE_RISING |
+				       V4L2_MBUS_PCLK_SAMPLE_FALLING);
+		data = common_flags & (V4L2_MBUS_DATA_ACTIVE_HIGH |
+				       V4L2_MBUS_DATA_ACTIVE_LOW);
+		mode = common_flags & (V4L2_MBUS_MASTER | V4L2_MBUS_SLAVE);
+		return (!hsync || !vsync || !pclk || !data || !mode) ?
+			0 : common_flags;
+	case V4L2_MBUS_CSI2:
+		mipi_lanes = common_flags & V4L2_MBUS_CSI2_LANES;
+		mipi_clock = common_flags & (V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK |
+					     V4L2_MBUS_CSI2_CONTINUOUS_CLOCK);
+		return (!mipi_lanes || !mipi_clock) ? 0 : common_flags;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(soc_mbus_config_compatible);
+
 static int __init soc_mbus_init(void)
 {
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 7582952..936a504 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -300,8 +300,10 @@ static inline void soc_camera_limit_side(int *start, int *length,
 		*start = start_min + length_max - *length;
 }
 
-extern unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
-						   unsigned long flags);
+unsigned long soc_camera_apply_sensor_flags(struct soc_camera_link *icl,
+					    unsigned long flags);
+unsigned long soc_camera_apply_board_flags(struct soc_camera_link *icl,
+					   const struct v4l2_mbus_config *cfg);
 
 /* This is only temporary here - until v4l2-subdev begins to link to video_device */
 #include <linux/i2c.h>
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index fae4325..73f1e7e 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -82,5 +82,7 @@ const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
 int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
 			unsigned int *numerator, unsigned int *denominator);
+unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
+					unsigned int flags);
 
 #endif
-- 
1.7.2.5

