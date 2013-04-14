Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3814 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3DNP17 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 16/30] cx25821: remove unnecessary debug messages.
Date: Sun, 14 Apr 2013 17:27:12 +0200
Message-Id: <1365953246-8972-17-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The v4l2 core already has support for debugging ioctls/file operations.

No need to do that again.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 0c11f31..6088ee9 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -633,9 +633,6 @@ static int video_open(struct file *file)
 	u32 pix_format;
 	int ch_id;
 
-	dprintk(1, "open dev=%s type=%s\n", video_device_node_name(vdev),
-			v4l2_type_names[type]);
-
 	for (ch_id = 0; ch_id < MAX_VID_CHANNEL_NUM - 1; ch_id++)
 		if (&dev->channels[ch_id].vdev == vdev)
 			break;
@@ -922,7 +919,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			return err;
 	}
 
-	dprintk(2, "%s()\n", __func__);
 	err = cx25821_vidioc_try_fmt_vid_cap(file, priv, f);
 
 	if (0 != err)
@@ -956,8 +952,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	dev->channels[fh->channel_id].cif_width = fh->width;
 	medusa_set_resolution(dev, fh->width, SRAM_CH00);
 
-	dprintk(2, "%s(): width=%d height=%d field=%d\n", __func__, fh->width,
-		fh->height, fh->vidq.field);
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	cx25821_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 
@@ -1079,8 +1073,6 @@ int cx25821_vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	int err;
 
-	dprintk(1, "%s()\n", __func__);
-
 	if (fh) {
 		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
 				      fh->prio);
@@ -1110,7 +1102,6 @@ static int cx25821_vidioc_enum_input(struct file *file, void *priv,
 	};
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	unsigned int n;
-	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
 	if (n >= CX25821_NR_INPUT)
@@ -1131,7 +1122,6 @@ static int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
 	*i = dev->input;
-	dprintk(1, "%s(): returns %d\n", __func__, *i);
 	return 0;
 }
 
@@ -1141,8 +1131,6 @@ static int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 	int err;
 
-	dprintk(1, "%s(%d)\n", __func__, i);
-
 	if (fh) {
 		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
 				      fh->prio);
-- 
1.7.10.4

