Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33037 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 20/26] [media] imx-ipuv3-csi: Export sync lock event to userspace
Date: Thu, 12 Jun 2014 19:06:34 +0200
Message-Id: <1402592800-2925-21-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index ab22cad..86fadd0 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -43,12 +43,19 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-of.h>
 
 #define DRIVER_NAME "imx-ipuv3-camera"
 
+#define V4L2_EVENT_SYNC_LOCK	(V4L2_EVENT_PRIVATE_START | 0x200)
+
+struct v4l2_event_sync_lock {
+	__u8 lock;
+} __attribute__ ((packed));
+
 /* CMOS Sensor Interface Registers */
 #define CSI_SENS_CONF		0x0000
 #define CSI_SENS_FRM_SIZE	0x0004
@@ -579,6 +586,7 @@ static void ipucsi_v4l2_dev_notify(struct v4l2_subdev *sd,
 	if (notification == V4L2_SUBDEV_SYNC_LOCK_NOTIFY) {
 		struct media_entity_graph graph;
 		struct media_entity *entity;
+		struct v4l2_event event;
 		struct ipucsi *ipucsi;
 		bool lock = *(bool *)arg;
 
@@ -595,6 +603,11 @@ static void ipucsi_v4l2_dev_notify(struct v4l2_subdev *sd,
 			ipucsi_resume_stream(ipucsi);
 		else
 			ipucsi_pause_stream(ipucsi);
+
+		memset(&event, 0, sizeof(event));
+		event.type = V4L2_EVENT_SYNC_LOCK;
+		((struct v4l2_event_sync_lock *)event.u.data)->lock = lock;
+		v4l2_event_queue(&ipucsi->vdev, &event);
 	}
 }
 
@@ -1378,6 +1391,14 @@ static int ipucsi_enum_framesizes(struct file *file, void *fh,
 	return 0;
 }
 
+static int ipucsi_subscribe_event(struct v4l2_fh *fh,
+				  const struct v4l2_event_subscription *sub)
+{
+	if (sub->type == V4L2_EVENT_SYNC_LOCK)
+		return v4l2_event_subscribe(fh, sub, 0, NULL);
+	return -EINVAL;
+}
+
 static const struct v4l2_ioctl_ops ipucsi_capture_ioctl_ops = {
 	.vidioc_querycap		= ipucsi_querycap,
 
@@ -1397,6 +1418,9 @@ static const struct v4l2_ioctl_ops ipucsi_capture_ioctl_ops = {
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 
 	.vidioc_enum_framesizes		= ipucsi_enum_framesizes,
+
+	.vidioc_subscribe_event		= ipucsi_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static int ipucsi_subdev_s_ctrl(struct v4l2_ctrl *ctrl)
-- 
2.0.0.rc2

