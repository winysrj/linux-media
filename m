Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4606 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008Ab3FJMte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 08:49:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/9] soc_camera: replace vdev->parent by vdev->v4l2_dev.
Date: Mon, 10 Jun 2013 14:48:30 +0200
Message-Id: <1370868518-19831-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
References: <1370868518-19831-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The parent field will eventually disappear to be replaced by v4l2_dev.
soc_camera does provide a v4l2_device struct but did not point to it in
struct video_device. This is now fixed.

Now the video nodes can be found under the correct platform bus, and
the advanced debug ioctls work correctly as well (the core implementation
of those ioctls requires that v4l2_dev is set correctly).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c |    5 +++--
 include/media/soc_camera.h                     |    4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 0252fbb..9a43560 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -524,7 +524,7 @@ static int soc_camera_open(struct file *file)
 		return -ENODEV;
 	}
 
-	icd = dev_get_drvdata(vdev->parent);
+	icd = video_get_drvdata(vdev);
 	ici = to_soc_camera_host(icd->parent);
 
 	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
@@ -1477,7 +1477,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
-	vdev->parent		= icd->pdev;
+	vdev->v4l2_dev		= &ici->v4l2_dev;
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
@@ -1500,6 +1500,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 	if (!icd->parent)
 		return -ENODEV;
 
+	video_set_drvdata(icd->vdev, icd);
 	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		dev_err(icd->pdev, "video_register_device failed: %d\n", ret);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index ff77d08..31a4bfe 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -346,9 +346,9 @@ static inline struct soc_camera_subdev_desc *soc_camera_i2c_to_desc(const struct
 	return client->dev.platform_data;
 }
 
-static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(const struct video_device *vdev)
+static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(struct video_device *vdev)
 {
-	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
+	struct soc_camera_device *icd = video_get_drvdata(vdev);
 	return soc_camera_to_subdev(icd);
 }
 
-- 
1.7.10.4

