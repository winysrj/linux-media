Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:27538 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757044Ab0GTBQT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 21:16:19 -0400
Subject: [PATCH 06/17] cx23885: Add a VIDIOC_LOG_STATUS ioctl function for
 analog video devices
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Kenney Phillisjr <kphillisjr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <cover.1279586511.git.awalls@md.metrocast.net>
References: <cover.1279586511.git.awalls@md.metrocast.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 21:12:51 -0400
Message-ID: <1279588371.28153.8.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a simple log_status function for raw analog video capture device nodes,
to provide insight into the state of the CX2388[578] A/V decoder core.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/video/cx23885/cx23885-video.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 4e44dcd..2519455 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1205,6 +1205,21 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
 }
 
+static int vidioc_log_status(struct file *file, void *priv)
+{
+	struct cx23885_fh  *fh  = priv;
+	struct cx23885_dev *dev = fh->dev;
+
+	printk(KERN_INFO
+		"%s/0: ============  START LOG STATUS  ============\n",
+	       dev->name);
+	call_all(dev, core, log_status);
+	printk(KERN_INFO
+		"%s/0: =============  END LOG STATUS  =============\n",
+	       dev->name);
+	return 0;
+}
+
 static int vidioc_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qctrl)
 {
@@ -1410,6 +1425,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
+	.vidioc_log_status    = vidioc_log_status,
 	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
-- 
1.7.1.1


