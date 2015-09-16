Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34439 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbIPPDl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2015 11:03:41 -0400
Date: Wed, 16 Sep 2015 23:00:03 +0800
From: Wang YanQing <udknight@gmail.com>
To: mchehab@osg.samsung.com
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [media] soc_camera: soc_camera_pdrv_probe: fix potential
 NULL pointer dereference
Message-ID: <20150916150003.GA2195@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move dereference of sdesc after NULL pointer checker.

Signed-off-by: Wang YanQing <udknight@gmail.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 9087fed..53b153d 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -2187,13 +2187,14 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 static int soc_camera_pdrv_probe(struct platform_device *pdev)
 {
 	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
-	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
+	struct soc_camera_subdev_desc *ssdd;
 	struct soc_camera_device *icd;
 	int ret;
 
 	if (!sdesc)
 		return -EINVAL;
 
+	ssdd = &sdesc->subdev_desc;
 	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
 	if (!icd)
 		return -ENOMEM;
-- 
1.8.5.6.2.g3d8a54e.dirty
