Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2530 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbaBQLo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 06:44:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 3/3] soc_camera: disable STD ioctls if no tvnorms are set.
Date: Mon, 17 Feb 2014 12:44:14 +0100
Message-Id: <1392637454-29179-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If the sub-device did not report any tvnorms, then disable the STD
ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4b8c024..c8549bf 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1277,6 +1277,8 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
 	sd->grp_id = soc_camera_grp_id(icd);
 	v4l2_set_subdev_hostdata(sd, icd);
 
+	v4l2_subdev_call(sd, video, g_tvnorms, &icd->vdev->tvnorms);
+
 	ret = v4l2_ctrl_add_handler(&icd->ctrl_handler, sd->ctrl_handler, NULL);
 	if (ret < 0)
 		return ret;
@@ -1997,6 +1999,12 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 		return -ENODEV;
 
 	video_set_drvdata(icd->vdev, icd);
+	if (icd->vdev->tvnorms == 0) {
+		/* disable the STD API if there are no tvnorms defined */
+		v4l2_disable_ioctl(icd->vdev, VIDIOC_G_STD);
+		v4l2_disable_ioctl(icd->vdev, VIDIOC_S_STD);
+		v4l2_disable_ioctl(icd->vdev, VIDIOC_ENUMSTD);
+	}
 	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		dev_err(icd->pdev, "video_register_device failed: %d\n", ret);
-- 
1.8.5.2

