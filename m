Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2320 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3FCJhZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [RFC PATCH 05/13] soc_camera: replace vdev->parent by vdev->v4l2_dev.
Date: Mon,  3 Jun 2013 11:36:42 +0200
Message-Id: <1370252210-4994-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The parent field will eventually disappear to be replaced by v4l2_dev.
soc_camera does provide a v4l2_device struct but did not point to it in
struct video_device. This is now fixed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 96645e9..ea951ec 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -524,7 +524,7 @@ static int soc_camera_open(struct file *file)
 		return -ENODEV;
 	}
 
-	icd = dev_get_drvdata(vdev->parent);
+	icd = dev_get_drvdata(vdev->v4l2_dev->dev);
 	ici = to_soc_camera_host(icd->parent);
 
 	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
@@ -1511,7 +1511,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
-	vdev->parent		= icd->pdev;
+	vdev->v4l2_dev		= &ici->v4l2_dev;
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
-- 
1.7.10.4

