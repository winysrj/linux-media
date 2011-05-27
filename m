Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:50045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab1E0O5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2011 10:57:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 351D3189B6B
	for <linux-media@vger.kernel.org>; Fri, 27 May 2011 16:57:04 +0200 (CEST)
Date: Fri, 27 May 2011 16:57:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] V4L: soc-camera: fix compiler warning
Message-ID: <Pine.LNX.4.64.1105271656120.29270@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix a compiler warning, introduced by the commit aed65af1

Author: Stephen Hemminger <shemminger@vyatta.com>
    drivers: make device_type const

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 3988643..4e4d412 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1512,7 +1512,7 @@ static int video_dev_create(struct soc_camera_device *icd)
  */
 static int soc_camera_video_start(struct soc_camera_device *icd)
 {
-	struct device_type *type = icd->vdev->dev.type;
+	const struct device_type *type = icd->vdev->dev.type;
 	int ret;
 
 	if (!icd->dev.parent)
-- 
1.7.2.5

