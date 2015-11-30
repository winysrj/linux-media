Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53577 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbbK3U1b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 02/11] cx231xx: fix NTSC cropcap, add missing cropcap for 417
Date: Mon, 30 Nov 2015 21:27:12 +0100
Message-Id: <1448915241-415-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The pixelaspect ratio was set incorrectly for 60Hz formats.
And since cropcap wasn't implemented at all for the -417 (compressed
video) the pixelaspect was unknown for compressed video.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-417.c   | 22 ++++++++++++++++++++++
 drivers/media/usb/cx231xx/cx231xx-video.c |  5 +++--
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index f59a6f1..1564ade 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1492,6 +1492,27 @@ static struct videobuf_queue_ops cx231xx_qops = {
 
 /* ------------------------------------------------------------------ */
 
+static int vidioc_cropcap(struct file *file, void *priv,
+			  struct v4l2_cropcap *cc)
+{
+	struct cx231xx_fh *fh = priv;
+	struct cx231xx *dev = fh->dev;
+	bool is_50hz = dev->encodernorm.id & V4L2_STD_625_50;
+
+	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	cc->bounds.left = 0;
+	cc->bounds.top = 0;
+	cc->bounds.width = dev->ts1.width;
+	cc->bounds.height = dev->ts1.height;
+	cc->defrect = cc->bounds;
+	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
+	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
+
+	return 0;
+}
+
 static int vidioc_g_std(struct file *file, void *fh0, v4l2_std_id *norm)
 {
 	struct cx231xx_fh  *fh  = file->private_data;
@@ -1834,6 +1855,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_input		 = cx231xx_g_input,
 	.vidioc_s_input		 = cx231xx_s_input,
 	.vidioc_s_ctrl		 = vidioc_s_ctrl,
+	.vidioc_cropcap		 = vidioc_cropcap,
 	.vidioc_querycap	 = cx231xx_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 246fb2b..a70850f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1444,6 +1444,7 @@ static int vidioc_cropcap(struct file *file, void *priv,
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
+	bool is_50hz = dev->norm & V4L2_STD_625_50;
 
 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1453,8 +1454,8 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	cc->bounds.width = dev->width;
 	cc->bounds.height = dev->height;
 	cc->defrect = cc->bounds;
-	cc->pixelaspect.numerator = 54;	/* 4:3 FIXME: remove magic numbers */
-	cc->pixelaspect.denominator = 59;
+	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
+	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
 
 	return 0;
 }
-- 
2.6.2

