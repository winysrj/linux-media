Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1IGQaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 12:30:52 -0400
Date: Wed, 7 Sep 2011 15:48:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Bastian Hecht <hechtb@googlemail.com>
Subject: [PATCH] V4L: sh-mobile-ceu-camera: fix mixed CSI2 & parallel camera
 case
Message-ID: <Pine.LNX.4.64.1109071546370.14818@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current sh_mobile_ceu_camera driver can cause an Oops, if a CSI2 and a
parallel camera are registered on the same CEU. Fix it by making CSI2
association with a camera more targeted.

Reported-by: Bastian Hecht <hechtb@googlemail.com>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index dedc981..8b344d4 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -717,10 +717,13 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
 					   struct soc_camera_device *icd)
 {
-	if (!pcdev->csi2_pdev)
-		return soc_camera_to_subdev(icd);
+	if (pcdev->csi2_pdev) {
+		struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
+		if (csi2_sd && csi2_sd->grp_id == (u32)icd)
+			return csi2_sd;
+	}
 
-	return find_csi2(pcdev);
+	return soc_camera_to_subdev(icd);
 }
 
 #define CEU_BUS_FLAGS (V4L2_MBUS_MASTER |	\
-- 
1.7.2.5

