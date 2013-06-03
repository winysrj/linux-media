Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1337 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab3FCJhT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:19 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [RFC PATCH 04/13] soc_camera: remove use of current_norm.
Date: Mon,  3 Jun 2013 11:36:41 +0200
Message-Id: <1370252210-4994-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The current_norm field is deprecated, so don't set it. Since it is set to
V4L2_STD_UNKNOWN which is 0 it didn't do anything anyway.

Also remove a few other unnecessary uses of V4L2_STD_UNKNOWN.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index eea832c..96645e9 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -235,7 +235,6 @@ static int soc_camera_enum_input(struct file *file, void *priv,
 
 	/* default is camera */
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
-	inp->std  = V4L2_STD_UNKNOWN;
 	strcpy(inp->name, "Camera");
 
 	return 0;
@@ -1513,11 +1512,9 @@ static int video_dev_create(struct soc_camera_device *icd)
 	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
 	vdev->parent		= icd->pdev;
-	vdev->current_norm	= V4L2_STD_UNKNOWN;
 	vdev->fops		= &soc_camera_fops;
 	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
 	vdev->release		= video_device_release;
-	vdev->tvnorms		= V4L2_STD_UNKNOWN;
 	vdev->ctrl_handler	= &icd->ctrl_handler;
 	vdev->lock		= &ici->host_lock;
 
-- 
1.7.10.4

