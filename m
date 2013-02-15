Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3098 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964Ab3BOJTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:19:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 9/9] s2255: Add ENUM_FRAMESIZES support.
Date: Fri, 15 Feb 2013 10:18:54 +0100
Message-Id: <7ea5b3a22e8bf4e6b61a7567293792c80b2404cc.1360919695.git.hans.verkuil@cisco.com>
In-Reply-To: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
References: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
References: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   73 +++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 22 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index eaae9d1..59d40e6 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1545,36 +1545,64 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	return 0;
 }
 
+#define NUM_SIZE_ENUMS 3
+static const struct v4l2_frmsize_discrete ntsc_sizes[] = {
+	{ 640, 480 },
+	{ 640, 240 },
+	{ 320, 240 },
+};
+static const struct v4l2_frmsize_discrete pal_sizes[] = {
+	{ 704, 576 },
+	{ 704, 288 },
+	{ 352, 288 },
+};
+
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+			    struct v4l2_frmsizeenum *fe)
+{
+	struct s2255_fh *fh = priv;
+	struct s2255_channel *channel = fh->channel;
+	int is_ntsc = channel->std & V4L2_STD_525_60;
+	const struct s2255_fmt *fmt;
+
+	if (fe->index >= NUM_SIZE_ENUMS)
+		return -EINVAL;
+
+	fmt = format_by_fourcc(fe->pixel_format);
+	if (fmt == NULL)
+		return -EINVAL;
+	fe->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fe->discrete = is_ntsc ?  ntsc_sizes[fe->index] : pal_sizes[fe->index];
+	return 0;
+}
+
 static int vidioc_enum_frameintervals(struct file *file, void *priv,
 			    struct v4l2_frmivalenum *fe)
 {
-	int is_ntsc = 0;
+	struct s2255_fh *fh = priv;
+	struct s2255_channel *channel = fh->channel;
+	const struct s2255_fmt *fmt;
+	const struct v4l2_frmsize_discrete *sizes;
+	int is_ntsc = channel->std & V4L2_STD_525_60;
 #define NUM_FRAME_ENUMS 4
 	int frm_dec[NUM_FRAME_ENUMS] = {1, 2, 3, 5};
+	int i;
+
 	if (fe->index >= NUM_FRAME_ENUMS)
 		return -EINVAL;
-	switch (fe->width) {
-	case 640:
-		if (fe->height != 240 && fe->height != 480)
-			return -EINVAL;
-		is_ntsc = 1;
-		break;
-	case 320:
-		if (fe->height != 240)
-			return -EINVAL;
-		is_ntsc = 1;
-		break;
-	case 704:
-		if (fe->height != 288 && fe->height != 576)
-			return -EINVAL;
-		break;
-	case 352:
-		if (fe->height != 288)
-			return -EINVAL;
-		break;
-	default:
+
+	fmt = format_by_fourcc(fe->pixel_format);
+	if (fmt == NULL)
 		return -EINVAL;
-	}
+
+	sizes = is_ntsc ? ntsc_sizes : pal_sizes;
+	for (i = 0; i < NUM_SIZE_ENUMS; i++, sizes++)
+		if (fe->width == sizes->width &&
+		    fe->height == sizes->height)
+			break;
+	if (i == NUM_SIZE_ENUMS)
+		return -EINVAL;
+
 	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
 	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
 	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * frm_dec[fe->index];
@@ -1813,6 +1841,7 @@ static const struct v4l2_ioctl_ops s2255_ioctl_ops = {
 	.vidioc_g_jpegcomp = vidioc_g_jpegcomp,
 	.vidioc_s_parm = vidioc_s_parm,
 	.vidioc_g_parm = vidioc_g_parm,
+	.vidioc_enum_framesizes = vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = vidioc_enum_frameintervals,
 	.vidioc_log_status  = v4l2_ctrl_log_status,
 	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
-- 
1.7.10.4

