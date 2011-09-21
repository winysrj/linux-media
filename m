Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51273 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1IUQqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 12:46:12 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 2054618B063
	for <linux-media@vger.kernel.org>; Wed, 21 Sep 2011 18:46:11 +0200 (CEST)
Date: Wed, 21 Sep 2011 18:46:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/2] V4L: soc-camera: add a function to lookup xlate by
 mediabus code
In-Reply-To: <Pine.LNX.4.64.1109211816380.24024@axis700.grange>
Message-ID: <Pine.LNX.4.64.1109211844080.24024@axis700.grange>
References: <Pine.LNX.4.64.1109211816380.24024@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In addition to a helper function, performing a format translation table
lookup by a fourcc value, a similar function is now needed to lookup
translation table entries by mediabus codes.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |   14 +++++++++++++-
 include/media/soc_camera.h       |    5 ++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index d1ced8f..b62f2fe 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -112,7 +112,7 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
 }
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc)
+	const struct soc_camera_device *icd, unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -123,6 +123,18 @@ const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 }
 EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
 
+const struct soc_camera_format_xlate *soc_camera_xlate_by_mcode(
+	const struct soc_camera_device *icd, enum v4l2_mbus_pixelcode code)
+{
+	unsigned int i;
+
+	for (i = 0; i < icd->num_user_formats; i++)
+		if (icd->user_formats[i].code == code)
+			return icd->user_formats + i;
+	return NULL;
+}
+EXPORT_SYMBOL(soc_camera_xlate_by_mcode);
+
 /**
  * soc_camera_apply_board_flags() - apply platform SOCAM_SENSOR_INVERT_* flags
  * @icl:	camera platform parameters
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b1377b9..fe7e8ad 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -174,7 +174,10 @@ int soc_camera_host_register(struct soc_camera_host *ici);
 void soc_camera_host_unregister(struct soc_camera_host *ici);
 
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc);
+	const struct soc_camera_device *icd, unsigned int fourcc);
+
+const struct soc_camera_format_xlate *soc_camera_xlate_by_mcode(
+	const struct soc_camera_device *icd, enum v4l2_mbus_pixelcode code);
 
 /**
  * struct soc_camera_format_xlate - match between host and sensor formats
-- 
1.7.2.5

