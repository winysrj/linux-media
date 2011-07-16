Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56539 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPANw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:13:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by axis700.grange (Postfix) with ESMTP id 86B15189B6D
	for <linux-media@vger.kernel.org>; Sat, 16 Jul 2011 02:13:50 +0200 (CEST)
Date: Sat, 16 Jul 2011 02:13:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/6] V4L: soc-camera: group struct field initialisations
 together
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160203090.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/soc_camera.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 5084e72..96bed29 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -1118,8 +1118,6 @@ static int soc_camera_probe(struct device *dev)
 
 	icd->field = V4L2_FIELD_ANY;
 
-	icd->vdev->lock = &icd->video_lock;
-
 	/*
 	 * ..._video_start() will create a device node, video_register_device()
 	 * itself is protected against concurrent open() calls, but we also have
@@ -1468,6 +1466,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
 	vdev->tvnorms		= V4L2_STD_UNKNOWN;
+	vdev->lock		= &icd->video_lock;
 
 	icd->vdev = vdev;
 
-- 
1.7.2.5

