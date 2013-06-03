Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2587 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3FCJh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 05:37:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFC PATCH 07/13] tm6000: remove deprecated current_norm
Date: Mon,  3 Jun 2013 11:36:44 +0200
Message-Id: <1370252210-4994-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Replace current_norm by g_std. Also initialize the standard to the more
common NTSC-M format (which is also what current_norm used).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/tm6000/tm6000-cards.c |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c |   13 +++++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 307d8c5..1ccaadd 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1114,7 +1114,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 	/* Default values for STD and resolutions */
 	dev->width = 720;
 	dev->height = 480;
-	dev->norm = V4L2_STD_PAL_M;
+	dev->norm = V4L2_STD_NTSC_M;
 
 	/* Configure tuner */
 	tm6000_config_tuner(dev);
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index a78de1d..cc1aa14 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1076,6 +1076,15 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 	return 0;
 }
 
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *norm)
+{
+	struct tm6000_fh *fh = priv;
+	struct tm6000_core *dev = fh->dev;
+
+	*norm = dev->norm;
+	return 0;
+}
+
 static const char *iname[] = {
 	[TM6000_INPUT_TV] = "Television",
 	[TM6000_INPUT_COMPOSITE1] = "Composite 1",
@@ -1134,7 +1143,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	dev->input = i;
 
-	rc = vidioc_s_std(file, priv, dev->vfd->current_norm);
+	rc = vidioc_s_std(file, priv, dev->norm);
 
 	return rc;
 }
@@ -1547,6 +1556,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap   = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap     = vidioc_s_fmt_vid_cap,
 	.vidioc_s_std             = vidioc_s_std,
+	.vidioc_g_std             = vidioc_g_std,
 	.vidioc_enum_input        = vidioc_enum_input,
 	.vidioc_g_input           = vidioc_g_input,
 	.vidioc_s_input           = vidioc_s_input,
@@ -1570,7 +1580,6 @@ static struct video_device tm6000_template = {
 	.ioctl_ops      = &video_ioctl_ops,
 	.release	= video_device_release,
 	.tvnorms        = TM6000_STD,
-	.current_norm   = V4L2_STD_NTSC_M,
 };
 
 static const struct v4l2_file_operations radio_fops = {
-- 
1.7.10.4

