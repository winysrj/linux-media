Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44849 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbcCAO5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 09:57:24 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 5/8] v4l2: add device_caps to struct video_device
Date: Tue,  1 Mar 2016 16:57:23 +0200
Message-Id: <1456844246-18778-6-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1456844246-18778-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of letting drivers fill in device_caps at querycap time,
let them fill it in when the video device is registered.

This has the advantage that in the future the v4l2 core can access
the video device's capabilities and take decisions based on that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
 include/media/v4l2-dev.h             | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 86c4c19b5d7b..706bb4251462 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1020,9 +1020,12 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 				struct file *file, void *fh, void *arg)
 {
 	struct v4l2_capability *cap = (struct v4l2_capability *)arg;
+	struct video_device *vfd = video_devdata(file);
 	int ret;
 
 	cap->version = LINUX_VERSION_CODE;
+	cap->device_caps = vfd->device_caps;
+	cap->capabilities = vfd->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	ret = ops->vidioc_querycap(file, fh, cap);
 
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 76056ab5c5bd..25a3190308fb 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -92,6 +92,9 @@ struct video_device
 	/* device ops */
 	const struct v4l2_file_operations *fops;
 
+	/* device capabilities as used in v4l2_capabilities */
+	u32 device_caps;
+
 	/* sysfs */
 	struct device dev;		/* v4l device */
 	struct cdev *cdev;		/* character device */
-- 
2.4.10

