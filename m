Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3528 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755574Ab3FCJh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:28 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>
Subject: [RFC PATCH 09/13] cx23885: remove use of deprecated current_norm
Date: Mon,  3 Jun 2013 11:36:46 +0200
Message-Id: <1370252210-4994-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The use of current_norm can be dropped. The g_std ioctl was already
implemented, so current_norm didn't do anything useful anyway.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   |    5 +----
 drivers/media/pci/cx23885/cx23885-video.c |    7 ++-----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 6dea11a..87c07e5 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1217,8 +1217,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 	struct cx23885_fh  *fh  = file->private_data;
 	struct cx23885_dev *dev = fh->dev;
 
-	call_all(dev, core, g_std, id);
-
+	*id = dev->tvnorm;
 	return 0;
 }
 
@@ -1661,7 +1660,6 @@ static struct v4l2_file_operations mpeg_fops = {
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
-	.vidioc_querystd	 = vidioc_g_std,
 	.vidioc_g_std		 = vidioc_g_std,
 	.vidioc_s_std		 = vidioc_s_std,
 	.vidioc_enum_input	 = vidioc_enum_input,
@@ -1702,7 +1700,6 @@ static struct video_device cx23885_mpeg_template = {
 	.fops          = &mpeg_fops,
 	.ioctl_ops     = &mpeg_ioctl_ops,
 	.tvnorms       = CX23885_NORMS,
-	.current_norm  = V4L2_STD_NTSC_M,
 };
 
 void cx23885_417_unregister(struct cx23885_dev *dev)
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ed08c89..34512cb 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1254,8 +1254,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 	dprintk(1, "%s()\n", __func__);
 
-	call_all(dev, core, g_std, id);
-
+	*id = dev->tvnorm;
 	return 0;
 }
 
@@ -1743,7 +1742,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf         = vidioc_dqbuf,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_g_std         = vidioc_g_std,
-	.vidioc_querystd      = vidioc_g_std,
 	.vidioc_enum_input    = vidioc_enum_input,
 	.vidioc_g_input       = vidioc_g_input,
 	.vidioc_s_input       = vidioc_s_input,
@@ -1773,7 +1771,6 @@ static struct video_device cx23885_video_template = {
 	.fops                 = &video_fops,
 	.ioctl_ops 	      = &video_ioctl_ops,
 	.tvnorms              = CX23885_NORMS,
-	.current_norm         = V4L2_STD_NTSC_M,
 };
 
 static const struct v4l2_file_operations radio_fops = {
@@ -1822,7 +1819,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	cx23885_vbi_template = cx23885_video_template;
 	strcpy(cx23885_vbi_template.name, "cx23885-vbi");
 
-	dev->tvnorm = cx23885_video_template.current_norm;
+	dev->tvnorm = V4L2_STD_NTSC_M;
 
 	/* init video dma queues */
 	INIT_LIST_HEAD(&dev->vidq.active);
-- 
1.7.10.4

