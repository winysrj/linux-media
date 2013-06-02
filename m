Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4423 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3FBK4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/16] saa7134: fix empress format compliance bugs.
Date: Sun,  2 Jun 2013 12:56:01 +0200
Message-Id: <1370170567-7004-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Missing fields and a missing TRY_FMT implementation in saa6752hs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa6752hs.c       |   58 ++++++++++++++++-----------
 drivers/media/pci/saa7134/saa7134-empress.c |   13 +++++-
 2 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa6752hs.c b/drivers/media/pci/saa7134/saa6752hs.c
index 5813ce8..f29812e 100644
--- a/drivers/media/pci/saa7134/saa6752hs.c
+++ b/drivers/media/pci/saa7134/saa6752hs.c
@@ -570,10 +570,36 @@ static int saa6752hs_g_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 	return 0;
 }
 
+static int saa6752hs_try_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
+{
+	int dist_352, dist_480, dist_720;
+
+	f->code = V4L2_MBUS_FMT_FIXED;
+
+	dist_352 = abs(f->width - 352);
+	dist_480 = abs(f->width - 480);
+	dist_720 = abs(f->width - 720);
+	if (dist_720 < dist_480) {
+		f->width = 720;
+		f->height = 576;
+	} else if (dist_480 < dist_352) {
+		f->width = 480;
+		f->height = 576;
+	} else {
+		f->width = 352;
+		if (abs(f->height - 576) < abs(f->height - 288))
+			f->height = 576;
+		else
+			f->height = 288;
+	}
+	f->field = V4L2_FIELD_INTERLACED;
+	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	return 0;
+}
+
 static int saa6752hs_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *f)
 {
 	struct saa6752hs_state *h = to_state(sd);
-	int dist_352, dist_480, dist_720;
 
 	if (f->code != V4L2_MBUS_FMT_FIXED)
 		return -EINVAL;
@@ -590,30 +616,15 @@ static int saa6752hs_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefm
 	  D1     | 720x576 | 720x480
 	*/
 
-	dist_352 = abs(f->width - 352);
-	dist_480 = abs(f->width - 480);
-	dist_720 = abs(f->width - 720);
-	if (dist_720 < dist_480) {
-		f->width = 720;
-		f->height = 576;
+	saa6752hs_try_mbus_fmt(sd, f);
+	if (f->width == 720)
 		h->video_format = SAA6752HS_VF_D1;
-	} else if (dist_480 < dist_352) {
-		f->width = 480;
-		f->height = 576;
+	else if (f->width == 480)
 		h->video_format = SAA6752HS_VF_2_3_D1;
-	} else {
-		f->width = 352;
-		if (abs(f->height - 576) <
-		    abs(f->height - 288)) {
-			f->height = 576;
-			h->video_format = SAA6752HS_VF_1_2_D1;
-		} else {
-			f->height = 288;
-			h->video_format = SAA6752HS_VF_SIF;
-		}
-	}
-	f->field = V4L2_FIELD_INTERLACED;
-	f->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	else if (f->height == 576)
+		h->video_format = SAA6752HS_VF_1_2_D1;
+	else
+		h->video_format = SAA6752HS_VF_SIF;
 	return 0;
 }
 
@@ -656,6 +667,7 @@ static const struct v4l2_subdev_core_ops saa6752hs_core_ops = {
 
 static const struct v4l2_subdev_video_ops saa6752hs_video_ops = {
 	.s_mbus_fmt = saa6752hs_s_mbus_fmt,
+	.try_mbus_fmt = saa6752hs_try_mbus_fmt,
 	.g_mbus_fmt = saa6752hs_g_mbus_fmt,
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 0bc1eec..62e03f2 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -165,7 +165,7 @@ static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	strlcpy(f->description, "MPEG TS", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
-
+	f->flags = V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
 }
 
@@ -180,6 +180,8 @@ static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
+	f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -196,6 +198,8 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
+	f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -204,9 +208,16 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_dev *dev = file->private_data;
+	struct v4l2_mbus_framefmt mbus_fmt;
+
+	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
+	saa_call_all(dev, video, try_mbus_fmt, &mbus_fmt);
+	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.sizeimage    = TS_PACKET_SIZE * dev->ts.nr_packets;
+	f->fmt.pix.bytesperline = 0;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
-- 
1.7.10.4

