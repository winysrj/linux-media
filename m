Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2471 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3BIKBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 05:01:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/26] cx231xx: fix vbi compliance issues.
Date: Sat,  9 Feb 2013 11:00:38 +0100
Message-Id: <23510a308011b5f442bae312c815bea97b6c01cf.1360403310.git.hans.verkuil@cisco.com>
In-Reply-To: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
References: <1360404056-9614-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
References: <9e42c08a9181147e28836646a93756f0077df9fc.1360403309.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various v4l2-compliance fixes: remove unused sliced VBI functions, zero the
reserved fields of struct v4l2_vbi_format and implement the missing s_fmt_vbi_cap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   67 ++++++++---------------------
 1 file changed, 17 insertions(+), 50 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 36ec4bc..f96fbd6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1867,47 +1867,6 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-/* Sliced VBI ioctls */
-static int vidioc_g_fmt_sliced_vbi_cap(struct file *file, void *priv,
-				       struct v4l2_format *f)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	f->fmt.sliced.service_set = 0;
-
-	call_all(dev, vbi, g_sliced_fmt, &f->fmt.sliced);
-
-	if (f->fmt.sliced.service_set == 0)
-		rc = -EINVAL;
-
-	return rc;
-}
-
-static int vidioc_try_set_sliced_vbi_cap(struct file *file, void *priv,
-					 struct v4l2_format *f)
-{
-	struct cx231xx_fh *fh = priv;
-	struct cx231xx *dev = fh->dev;
-	int rc;
-
-	rc = check_dev(dev);
-	if (rc < 0)
-		return rc;
-
-	call_all(dev, vbi, g_sliced_fmt, &f->fmt.sliced);
-
-	if (f->fmt.sliced.service_set == 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 /* RAW VBI ioctls */
 
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
@@ -1915,6 +1874,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 {
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
+
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -1926,6 +1886,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	f->fmt.vbi.start[1] = (dev->norm & V4L2_STD_625_50) ?
 	    PAL_VBI_START_LINE + 312 : NTSC_VBI_START_LINE + 263;
 	f->fmt.vbi.count[1] = f->fmt.vbi.count[0];
+	memset(f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 
 	return 0;
 
@@ -1937,12 +1898,6 @@ static int vidioc_try_fmt_vbi_cap(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
-	if (dev->vbi_stream_on && !fh->stream_on) {
-		cx231xx_errdev("%s device in use by another fh\n", __func__);
-		return -EBUSY;
-	}
-
-	f->type = V4L2_BUF_TYPE_VBI_CAPTURE;
 	f->fmt.vbi.sampling_rate = 6750000 * 4;
 	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
 	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
@@ -1955,11 +1910,25 @@ static int vidioc_try_fmt_vbi_cap(struct file *file, void *priv,
 	f->fmt.vbi.start[1] = (dev->norm & V4L2_STD_625_50) ?
 	    PAL_VBI_START_LINE + 312 : NTSC_VBI_START_LINE + 263;
 	f->fmt.vbi.count[1] = f->fmt.vbi.count[0];
+	memset(f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 
 	return 0;
 
 }
 
+static int vidioc_s_fmt_vbi_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct cx231xx_fh *fh = priv;
+	struct cx231xx *dev = fh->dev;
+
+	if (dev->vbi_stream_on && !fh->stream_on) {
+		cx231xx_errdev("%s device in use by another fh\n", __func__);
+		return -EBUSY;
+	}
+	return vidioc_try_fmt_vbi_cap(file, priv, f);
+}
+
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *rb)
 {
@@ -2421,10 +2390,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_fmt_vid_cap          = vidioc_s_fmt_vid_cap,
 	.vidioc_g_fmt_vbi_cap          = vidioc_g_fmt_vbi_cap,
 	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
-	.vidioc_s_fmt_vbi_cap          = vidioc_try_fmt_vbi_cap,
+	.vidioc_s_fmt_vbi_cap          = vidioc_s_fmt_vbi_cap,
 	.vidioc_cropcap                = vidioc_cropcap,
-	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
-	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
 	.vidioc_reqbufs                = vidioc_reqbufs,
 	.vidioc_querybuf               = vidioc_querybuf,
 	.vidioc_qbuf                   = vidioc_qbuf,
-- 
1.7.10.4

