Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab1I2QTD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Sep 2011 12:19:03 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Deepthy Ravi <deepthy.ravi@ti.com>
Subject: [PATCH 1/9] V4L: soc-camera: add a function to lookup xlate by mediabus code
Date: Thu, 29 Sep 2011 18:18:49 +0200
Message-Id: <1317313137-4403-2-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition to a helper function, performing a format translation table
lookup by a fourcc value, a similar function is now needed to lookup
translation table entries by mediabus codes.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   25 ++++++++++++++++++++++++-
 include/media/soc_camera.h       |    6 +++++-
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index b72580c..ba409ac 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -112,7 +112,7 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
 }
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc)
+	const struct soc_camera_device *icd, u32 fourcc)
 {
 	unsigned int i;
 
@@ -123,6 +123,29 @@ const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 }
 EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
 
+/*
+ * Warning: the mediabus code -> fourcc mapping is not unique, this is why we
+ * need a hint of a preferred fourcc value. Use 0 if unknown.
+ */
+const struct soc_camera_format_xlate *soc_camera_xlate_by_mcode(
+	const struct soc_camera_device *icd, enum v4l2_mbus_pixelcode code,
+	u32 fourcc)
+{
+	unsigned int i;
+	struct soc_camera_format_xlate *xlate = NULL;
+
+	for (i = 0; i < icd->num_user_formats; i++)
+		if (icd->user_formats[i].code == code) {
+			if (icd->user_formats[i].host_fmt->fourcc == fourcc)
+				return icd->user_formats + i;
+			/* Prefer the first one */
+			if (!xlate)
+				xlate = icd->user_formats + i;
+		}
+	return xlate;
+}
+EXPORT_SYMBOL(soc_camera_xlate_by_mcode);
+
 /**
  * soc_camera_apply_board_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
  * @icl:	camera platform parameters
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b1377b9..22e4bee 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -174,7 +174,11 @@ int soc_camera_host_register(struct soc_camera_host *ici);
 void soc_camera_host_unregister(struct soc_camera_host *ici);
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc);
+	const struct soc_camera_device *icd, u32 fourcc);
+
+const struct soc_camera_format_xlate *soc_camera_xlate_by_mcode(
+	const struct soc_camera_device *icd, enum v4l2_mbus_pixelcode code,
+	u32 fourcc);
 
 /**
  * struct soc_camera_format_xlate - match between host and sensor formats
-- 
1.7.2.5

