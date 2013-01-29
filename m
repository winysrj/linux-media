Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1388 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3A2Qdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:38 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 12/20] cx231xx: replace ioctl by unlocked_ioctl.
Date: Tue, 29 Jan 2013 17:33:05 +0100
Message-Id: <42a82a61515e6db6e450dea54d37542dc3332454.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

There was already a core lock, so why wasn't ioctl already replaced by
unlock_ioctl?

This patch switches to unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   |   15 ++++++---------
 drivers/media/usb/cx231xx/cx231xx-video.c |    2 +-
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index a4091dd..15dd334 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1633,12 +1633,8 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 	dprintk(3, "enter vidioc_s_input() i=%d\n", i);
 
-	mutex_lock(&dev->lock);
-
 	video_mux(dev, i);
 
-	mutex_unlock(&dev->lock);
-
 	if (i >= 4)
 		return -EINVAL;
 	dev->input = i;
@@ -1932,7 +1928,8 @@ static int mpeg_open(struct file *file)
 	if (dev == NULL)
 		return -ENODEV;
 
-	mutex_lock(&dev->lock);
+	if (mutex_lock_interruptible(&dev->lock))
+		return -ERESTARTSYS;
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
@@ -1948,14 +1945,14 @@ static int mpeg_open(struct file *file)
 	videobuf_queue_vmalloc_init(&fh->vidq, &cx231xx_qops,
 			    NULL, &dev->video_mode.slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_INTERLACED,
-			    sizeof(struct cx231xx_buffer), fh, NULL);
+			    sizeof(struct cx231xx_buffer), fh, &dev->lock);
 /*
 	videobuf_queue_sg_init(&fh->vidq, &cx231xx_qops,
 			    &dev->udev->dev, &dev->ts1.slock,
 			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			    V4L2_FIELD_INTERLACED,
 			    sizeof(struct cx231xx_buffer),
-			    fh, NULL);
+			    fh, &dev->lock);
 */
 
 
@@ -2069,7 +2066,7 @@ static struct v4l2_file_operations mpeg_fops = {
 	.read	       = mpeg_read,
 	.poll          = mpeg_poll,
 	.mmap	       = mpeg_mmap,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
@@ -2144,11 +2141,11 @@ static struct video_device *cx231xx_video_dev_alloc(
 	if (NULL == vfd)
 		return NULL;
 	*vfd = *template;
-	vfd->minor = -1;
 	snprintf(vfd->name, sizeof(vfd->name), "%s %s (%s)", dev->name,
 		type, cx231xx_boards[dev->model].name);
 
 	vfd->v4l2_dev = &dev->v4l2_dev;
+	vfd->lock = &dev->lock;
 	vfd->release = video_device_release;
 
 	return vfd;
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index da54b9b..1f0e00a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -2235,7 +2235,7 @@ static const struct v4l2_file_operations radio_fops = {
 	.open   = cx231xx_v4l2_open,
 	.release = cx231xx_v4l2_close,
 	.poll = v4l2_ctrl_poll,
-	.ioctl   = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
-- 
1.7.10.4

