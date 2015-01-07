Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw01.mail.saunalahti.fi ([195.197.172.115]:55094 "EHLO
	gw01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbbAGC1W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Jan 2015 21:27:22 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH] [media] soc_camera: avoid potential null-dereference
Date: Wed,  7 Jan 2015 04:27:08 +0200
Message-Id: <1420597628-317-1-git-send-email-andy.shevchenko@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have to check the pointer before dereferencing it.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index b3db51c..8c665c4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -2166,7 +2166,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 static int soc_camera_pdrv_probe(struct platform_device *pdev)
 {
 	struct soc_camera_desc *sdesc = pdev->dev.platform_data;
-	struct soc_camera_subdev_desc *ssdd = &sdesc->subdev_desc;
+	struct soc_camera_subdev_desc *ssdd;
 	struct soc_camera_device *icd;
 	int ret;
 
@@ -2177,6 +2177,8 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
 	if (!icd)
 		return -ENOMEM;
 
+	ssdd = &sdesc->subdev_desc;
+
 	/*
 	 * In the asynchronous case ssdd->num_regulators == 0 yet, so, the below
 	 * regulator allocation is a dummy. They are actually requested by the
-- 
1.8.3.101.g727a46b

