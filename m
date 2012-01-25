Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43859 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2AYPMc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:12:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 5/8] soc-camera: Add soc_mbus_image_size
Date: Wed, 25 Jan 2012 16:12:28 +0100
Message-Id: <1327504351-24413-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function returns the minimum size of an image for a given number of
bytes per line (as per the V4L2 specification), width and format.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/soc_mediabus.c |   18 ++++++++++++++++++
 include/media/soc_mediabus.h       |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index a707314..3f47774 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -397,6 +397,24 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 }
 EXPORT_SYMBOL(soc_mbus_bytes_per_line);
 
+s32 soc_mbus_image_size(u32 bytes_per_line, u32 height,
+			const struct soc_mbus_pixelfmt *mf)
+{
+	if (mf->layout == SOC_MBUS_LAYOUT_PACKED)
+		return bytes_per_line * height;
+
+	switch (mf->packing) {
+	case SOC_MBUS_PACKING_2X8_PADHI:
+	case SOC_MBUS_PACKING_2X8_PADLO:
+		return bytes_per_line * height * 2;
+	case SOC_MBUS_PACKING_1_5X8:
+		return bytes_per_line * height * 3 / 2;
+	default:
+		return -EINVAL;
+	}
+}
+EXPORT_SYMBOL(soc_mbus_image_size);
+
 const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
 	enum v4l2_mbus_pixelcode code,
 	const struct soc_mbus_lookup *lookup,
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index 18b0864..eeac234 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -99,6 +99,8 @@ const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
 const struct soc_mbus_pixelfmt *soc_mbus_get_fmtdesc(
 	enum v4l2_mbus_pixelcode code);
 s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf);
+s32 soc_mbus_image_size(u32 bytes_per_line, u32 height,
+			const struct soc_mbus_pixelfmt *mf);
 int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
 			unsigned int *numerator, unsigned int *denominator);
 unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
-- 
1.7.3.4

