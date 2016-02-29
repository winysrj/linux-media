Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:35410 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752011AbcB2Lpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 06:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 1/5] v4l2: add device_caps to struct video_device
Date: Mon, 29 Feb 2016 12:45:41 +0100
Message-Id: <1456746345-1431-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
References: <1456746345-1431-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Instead of letting drivers fill in device_caps at querycap time,
let them fill it in when the video device is registered.

This has the advantage that in the future the v4l2 core can access
the video device's capabilities and take decisions based on that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 3 +++
 include/media/v4l2-dev.h             | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 86c4c19..706bb42 100644
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
index 76056ab..25a3190 100644
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
2.7.0

