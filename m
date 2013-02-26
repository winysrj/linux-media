Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1154 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3BZRgD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/11] s2255: fix field handling
Date: Tue, 26 Feb 2013 18:35:42 +0100
Message-Id: <b3b1afb84847cb335451886d20788aefae97b69c.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Just set the field value based on the chosen format. It's either INTERLACED
or TOP.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |   61 +++++++++---------------------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index a16bc6c..9693eb9 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -852,10 +852,15 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct s2255_fh *fh = priv;
 	struct s2255_channel *channel = fh->channel;
+	int is_ntsc = channel->std & V4L2_STD_525_60;
 
 	f->fmt.pix.width = channel->width;
 	f->fmt.pix.height = channel->height;
-	f->fmt.pix.field = fh->vb_vidq.field;
+	if (f->fmt.pix.height >=
+	    (is_ntsc ? NUM_LINES_1CIFS_NTSC : NUM_LINES_1CIFS_PAL) * 2)
+		f->fmt.pix.field = V4L2_FIELD_INTERLACED;
+	else
+		f->fmt.pix.field = V4L2_FIELD_TOP;
 	f->fmt.pix.pixelformat = channel->fmt->fourcc;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * (channel->fmt->depth >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
@@ -869,11 +874,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	const struct s2255_fmt *fmt;
 	enum v4l2_field field;
-	int  b_any_field = 0;
 	struct s2255_fh *fh = priv;
 	struct s2255_channel *channel = fh->channel;
-	int is_ntsc;
-	is_ntsc = (channel->std & V4L2_STD_525_60) ? 1 : 0;
+	int is_ntsc = channel->std & V4L2_STD_525_60;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
@@ -881,8 +884,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	field = f->fmt.pix.field;
-	if (field == V4L2_FIELD_ANY)
-		b_any_field = 1;
 
 	dprintk(50, "%s NTSC: %d suggested width: %d, height: %d\n",
 		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
@@ -890,24 +891,10 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		/* NTSC */
 		if (f->fmt.pix.height >= NUM_LINES_1CIFS_NTSC * 2) {
 			f->fmt.pix.height = NUM_LINES_1CIFS_NTSC * 2;
-			if (b_any_field) {
-				field = V4L2_FIELD_SEQ_TB;
-			} else if (!((field == V4L2_FIELD_INTERLACED) ||
-				      (field == V4L2_FIELD_SEQ_TB) ||
-				      (field == V4L2_FIELD_INTERLACED_TB))) {
-				dprintk(1, "unsupported field setting\n");
-				return -EINVAL;
-			}
+			field = V4L2_FIELD_INTERLACED;
 		} else {
 			f->fmt.pix.height = NUM_LINES_1CIFS_NTSC;
-			if (b_any_field) {
-				field = V4L2_FIELD_TOP;
-			} else if (!((field == V4L2_FIELD_TOP) ||
-				      (field == V4L2_FIELD_BOTTOM))) {
-				dprintk(1, "unsupported field setting\n");
-				return -EINVAL;
-			}
-
+			field = V4L2_FIELD_TOP;
 		}
 		if (f->fmt.pix.width >= LINE_SZ_4CIFS_NTSC)
 			f->fmt.pix.width = LINE_SZ_4CIFS_NTSC;
@@ -921,37 +908,19 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		/* PAL */
 		if (f->fmt.pix.height >= NUM_LINES_1CIFS_PAL * 2) {
 			f->fmt.pix.height = NUM_LINES_1CIFS_PAL * 2;
-			if (b_any_field) {
-				field = V4L2_FIELD_SEQ_TB;
-			} else if (!((field == V4L2_FIELD_INTERLACED) ||
-				      (field == V4L2_FIELD_SEQ_TB) ||
-				      (field == V4L2_FIELD_INTERLACED_TB))) {
-				dprintk(1, "unsupported field setting\n");
-				return -EINVAL;
-			}
+			field = V4L2_FIELD_INTERLACED;
 		} else {
 			f->fmt.pix.height = NUM_LINES_1CIFS_PAL;
-			if (b_any_field) {
-				field = V4L2_FIELD_TOP;
-			} else if (!((field == V4L2_FIELD_TOP) ||
-				     (field == V4L2_FIELD_BOTTOM))) {
-				dprintk(1, "unsupported field setting\n");
-				return -EINVAL;
-			}
+			field = V4L2_FIELD_TOP;
 		}
-		if (f->fmt.pix.width >= LINE_SZ_4CIFS_PAL) {
+		if (f->fmt.pix.width >= LINE_SZ_4CIFS_PAL)
 			f->fmt.pix.width = LINE_SZ_4CIFS_PAL;
-			field = V4L2_FIELD_SEQ_TB;
-		} else if (f->fmt.pix.width >= LINE_SZ_2CIFS_PAL) {
+		else if (f->fmt.pix.width >= LINE_SZ_2CIFS_PAL)
 			f->fmt.pix.width = LINE_SZ_2CIFS_PAL;
-			field = V4L2_FIELD_TOP;
-		} else if (f->fmt.pix.width >= LINE_SZ_1CIFS_PAL) {
+		else if (f->fmt.pix.width >= LINE_SZ_1CIFS_PAL)
 			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
-			field = V4L2_FIELD_TOP;
-		} else {
+		else
 			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
-			field = V4L2_FIELD_TOP;
-		}
 	}
 	f->fmt.pix.field = field;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
-- 
1.7.10.4

