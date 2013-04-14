Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2041 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3DNP1v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/30] cx25821: remove cropping ioctls.
Date: Sun, 14 Apr 2013 17:27:07 +0200
Message-Id: <1365953246-8972-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver does not implement cropping, so remove the cropping ioctls.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/cx25821-video.c |   44 -----------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 9e948ef..9919a0e 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -1396,47 +1396,6 @@ static void cx25821_init_controls(struct cx25821_dev *dev, int chan_num)
 	}
 }
 
-static int cx25821_vidioc_cropcap(struct file *file, void *priv,
-			   struct v4l2_cropcap *cropcap)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-
-	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	cropcap->bounds.top = 0;
-	cropcap->bounds.left = 0;
-	cropcap->bounds.width = 720;
-	cropcap->bounds.height = dev->tvnorm == V4L2_STD_PAL_BG ? 576 : 480;
-	cropcap->pixelaspect.numerator =
-		dev->tvnorm == V4L2_STD_PAL_BG ? 59 : 10;
-	cropcap->pixelaspect.denominator =
-		dev->tvnorm == V4L2_STD_PAL_BG ? 54 : 11;
-	cropcap->defrect = cropcap->bounds;
-	return 0;
-}
-
-static int cx25821_vidioc_s_crop(struct file *file, void *priv, const struct v4l2_crop *crop)
-{
-	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
-	struct cx25821_fh *fh = priv;
-	int err;
-
-	if (fh) {
-		err = v4l2_prio_check(&dev->channels[fh->channel_id].prio,
-				      fh->prio);
-		if (0 != err)
-			return err;
-	}
-	/* cx25821_vidioc_s_crop not supported */
-	return -EINVAL;
-}
-
-static int cx25821_vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
-{
-	/* cx25821_vidioc_g_crop not supported */
-	return -EINVAL;
-}
-
 static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 				 unsigned long arg)
 {
@@ -1713,9 +1672,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf = vidioc_dqbuf,
 	.vidioc_g_std = cx25821_vidioc_g_std,
 	.vidioc_s_std = cx25821_vidioc_s_std,
-	.vidioc_cropcap = cx25821_vidioc_cropcap,
-	.vidioc_s_crop = cx25821_vidioc_s_crop,
-	.vidioc_g_crop = cx25821_vidioc_g_crop,
 	.vidioc_enum_input = cx25821_vidioc_enum_input,
 	.vidioc_g_input = cx25821_vidioc_g_input,
 	.vidioc_s_input = cx25821_vidioc_s_input,
-- 
1.7.10.4

