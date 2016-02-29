Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:34745 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbcB2M5p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 07:57:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] v4l2: collect the union of all device_caps in struct v4l2_device
Date: Mon, 29 Feb 2016 13:57:36 +0100
Message-Id: <1456750657-11108-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl>
References: <1456750657-11108-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The capabilities field of struct v4l2_capabilities should be the
union of the capabilities of all video devices. This has always been
annoying for drivers to calculate, but now that device_caps is part
of struct video_device we can easily OR that with a capabilities
field in struct v4l2_device and return that as the capabilities field
when QUERYCAP is called.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-dev.c   | 1 +
 drivers/media/v4l2-core/v4l2-ioctl.c | 2 +-
 include/media/v4l2-device.h          | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index 7e766a9..6ef9169 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1011,6 +1011,7 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 	ret = video_register_media_controller(vdev, type);
 
 	/* Part 6: Activate this minor. The char device can now be used. */
+	vdev->v4l2_dev->capabilities |= vdev->device_caps;
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
 
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 706bb42..013d58d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1025,7 +1025,7 @@ static int v4l_querycap(const struct v4l2_ioctl_ops *ops,
 
 	cap->version = LINUX_VERSION_CODE;
 	cap->device_caps = vfd->device_caps;
-	cap->capabilities = vfd->device_caps | V4L2_CAP_DEVICE_CAPS;
+	cap->capabilities = vfd->v4l2_dev->capabilities | V4L2_CAP_DEVICE_CAPS;
 
 	ret = ops->vidioc_querycap(file, fh, cap);
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9c58157..8964d60 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -44,6 +44,8 @@ struct v4l2_device {
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	struct media_device *mdev;
 #endif
+	/* union of the capabilities of all video devices */
+	u32 capabilities;
 	/* used to keep track of the registered subdevs */
 	struct list_head subdevs;
 	/* lock this struct; can be used by the driver as well if this
-- 
2.7.0

