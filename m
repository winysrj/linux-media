Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3464 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1AHNhC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 08:37:02 -0500
Received: from localhost.localdomain (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr8.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08Daljx015112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 14:37:00 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv3 PATCH 02/16] v4l2: add v4l2_prio_state to v4l2_device and video_device
Date: Sat,  8 Jan 2011 14:36:27 +0100
Message-Id: <054803dc0cc7e5037edafd16065c7f7cc8b3dc66.1294493427.git.hverkuil@xs4all.nl>
In-Reply-To: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
References: <1d57787db3bd1a76d292bd80d91ba9e10c07af68.1294493427.git.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Integrate the v4l2_prio_state into the core, ready for use.

One struct v4l2_prio_state is added to v4l2_device and a pointer
to a prio state is added to video_device.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-dev.c    |    6 ++++++
 drivers/media/video/v4l2-device.c |    1 +
 include/media/v4l2-dev.h          |    3 +++
 include/media/v4l2-device.h       |    3 +++
 4 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 8698fe4..c8f6ae1 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -543,6 +543,12 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
 			vdev->parent = vdev->v4l2_dev->dev;
 		if (vdev->ctrl_handler == NULL)
 			vdev->ctrl_handler = vdev->v4l2_dev->ctrl_handler;
+		/* If the prio state pointer is NULL, and if the driver doesn't
+		   handle priorities itself, then use the v4l2_device prio
+		   state. */
+		if (vdev->prio == NULL && vdev->ioctl_ops &&
+				vdev->ioctl_ops->vidioc_s_priority == NULL)
+			vdev->prio = &vdev->v4l2_dev->prio;
 	}
 
 	/* Part 2: find a free minor, device node number and device index. */
diff --git a/drivers/media/video/v4l2-device.c b/drivers/media/video/v4l2-device.c
index 7fe6f92..e12844c 100644
--- a/drivers/media/video/v4l2-device.c
+++ b/drivers/media/video/v4l2-device.c
@@ -36,6 +36,7 @@ int v4l2_device_register(struct device *dev, struct v4l2_device *v4l2_dev)
 	INIT_LIST_HEAD(&v4l2_dev->subdevs);
 	spin_lock_init(&v4l2_dev->lock);
 	mutex_init(&v4l2_dev->ioctl_lock);
+	v4l2_prio_init(&v4l2_dev->prio);
 	v4l2_dev->dev = dev;
 	if (dev == NULL) {
 		/* If dev == NULL, then name must be filled in by the caller */
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index 861f323..15dd756 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -83,6 +83,9 @@ struct video_device
 	/* Control handler associated with this device node. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
 
+	/* Priority state. If NULL, then v4l2_dev->prio will be used. */
+	struct v4l2_prio_state *prio;
+
 	/* device info */
 	char name[32];
 	int vfl_type;
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index b16f307..fd5d450 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -22,6 +22,7 @@
 #define _V4L2_DEVICE_H
 
 #include <media/v4l2-subdev.h>
+#include <media/v4l2-dev.h>
 
 /* Each instance of a V4L2 device should create the v4l2_device struct,
    either stand-alone or embedded in a larger struct.
@@ -51,6 +52,8 @@ struct v4l2_device {
 			unsigned int notification, void *arg);
 	/* The control handler. May be NULL. */
 	struct v4l2_ctrl_handler *ctrl_handler;
+	/* Device's priority state */
+	struct v4l2_prio_state prio;
 	/* BKL replacement mutex. Temporary solution only. */
 	struct mutex ioctl_lock;
 };
-- 
1.7.0.4

