Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:35754 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752013AbeAERtz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 5 Jan 2018 12:49:55 -0500
Received: by mail-pl0-f67.google.com with SMTP id b96so3440478pli.2
        for <linux-media@vger.kernel.org>; Fri, 05 Jan 2018 09:49:55 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] media: xilinx-video: support pipeline power management
Date: Sat,  6 Jan 2018 02:49:43 +0900
Message-Id: <1515174583-31183-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This enables pipeline power management for Xilinx Video IP driver.

Some V4L2 subdevices are put their power status into power down mode
after their probe function, and require to be powered up by calling
s_power() operation when the pipeline is in use.

So this change is necessary if the video pipeline contains such a V4L2
subdevice.

Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c  | 35 +++++++++++++++++++++++++++--
 drivers/media/platform/xilinx/xilinx-vipp.c |  7 +++++-
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index 522cdfd..cd0b846 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-mc.h>
 #include <media/videobuf2-v4l2.h>
 #include <media/videobuf2-dma-contig.h>
 
@@ -644,11 +645,41 @@ static const struct v4l2_ioctl_ops xvip_dma_ioctl_ops = {
  * V4L2 file operations
  */
 
+static int xvip_dma_open(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	int ret;
+
+	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
+	if (ret)
+		return ret;
+
+	ret = v4l2_fh_open(file);
+	if (ret)
+		v4l2_pipeline_pm_use(&vdev->entity, 0);
+
+	return ret;
+}
+
+static int xvip_dma_release(struct file *file)
+{
+	struct video_device *vdev = video_devdata(file);
+	int ret;
+
+	ret = vb2_fop_release(file);
+	if (ret)
+		return ret;
+
+	v4l2_pipeline_pm_use(&vdev->entity, 0);
+
+	return 0;
+}
+
 static const struct v4l2_file_operations xvip_dma_fops = {
 	.owner		= THIS_MODULE,
 	.unlocked_ioctl	= video_ioctl2,
-	.open		= v4l2_fh_open,
-	.release	= vb2_fop_release,
+	.open		= xvip_dma_open,
+	.release	= xvip_dma_release,
 	.poll		= vb2_fop_poll,
 	.mmap		= vb2_fop_mmap,
 };
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index f4c3e48..6d098e3 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -23,6 +23,7 @@
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-fwnode.h>
+#include <media/v4l2-mc.h>
 
 #include "xilinx-dma.h"
 #include "xilinx-vipp.h"
@@ -573,6 +574,10 @@ static void xvip_composite_v4l2_cleanup(struct xvip_composite_device *xdev)
 	media_device_cleanup(&xdev->media_dev);
 }
 
+static const struct media_device_ops xvip_media_ops = {
+	.link_notify = v4l2_pipeline_link_notify,
+};
+
 static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 {
 	int ret;
@@ -581,7 +586,7 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 	strlcpy(xdev->media_dev.model, "Xilinx Video Composite Device",
 		sizeof(xdev->media_dev.model));
 	xdev->media_dev.hw_revision = 0;
-
+	xdev->media_dev.ops = &xvip_media_ops;
 	media_device_init(&xdev->media_dev);
 
 	xdev->v4l2_dev.mdev = &xdev->media_dev;
-- 
2.7.4
