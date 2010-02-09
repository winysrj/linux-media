Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60982 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751940Ab0BIXhu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 18:37:50 -0500
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1NezfE-0002qU-47
	for linux-media@vger.kernel.org; Wed, 10 Feb 2010 00:38:40 +0100
Date: Wed, 10 Feb 2010 00:38:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] soc-camera: update mt9v022 to take into account board signal
 routing
Message-ID: <Pine.LNX.4.64.1002100037200.4585@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use soc_camera_apply_sensor_flags() in mt9v022 to account for any inverters in
video signal paths.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mt9v022.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 91df7ec..1a34d29 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -257,19 +257,18 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
 static unsigned long mt9v022_query_bus_param(struct soc_camera_device *icd)
 {
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
-	unsigned int width_flag;
+	unsigned int flags = SOCAM_MASTER | SOCAM_SLAVE |
+		SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
+		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
+		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
+		SOCAM_DATA_ACTIVE_HIGH;
 
 	if (icl->query_bus_param)
-		width_flag = icl->query_bus_param(icl) &
-			SOCAM_DATAWIDTH_MASK;
+		flags |= icl->query_bus_param(icl) & SOCAM_DATAWIDTH_MASK;
 	else
-		width_flag = SOCAM_DATAWIDTH_10;
+		flags |= SOCAM_DATAWIDTH_10;
 
-	return SOCAM_PCLK_SAMPLE_RISING | SOCAM_PCLK_SAMPLE_FALLING |
-		SOCAM_HSYNC_ACTIVE_HIGH | SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH | SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_DATA_ACTIVE_HIGH | SOCAM_MASTER | SOCAM_SLAVE |
-		width_flag;
+	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
 static int mt9v022_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
-- 
1.6.2.4

