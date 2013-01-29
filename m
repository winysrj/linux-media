Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2834 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3A2Qdb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 11:33:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Palash.Bandyopadhyay@conexant.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 08/20] cx231xx: fix vbi compliance issues.
Date: Tue, 29 Jan 2013 17:33:01 +0100
Message-Id: <9278ca88d39f644ad9c17ff7c23ad01b9a7caf26.1359476777.git.hans.verkuil@cisco.com>
In-Reply-To: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
References: <1359477193-9768-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
References: <8a9d877c6be8a336a44c69a21b3fca449294139d.1359476776.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Various v4l2-compliance fixes: remove unused sliced VBI functions, zero the
reserved fields of struct v4l2_vbi_format and implement the missing s_fmt_vbi_cap.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/cx231xx/cx231xx-video.c |   45 ++---------------------------
 1 file changed, 2 insertions(+), 43 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index ee9c9a5..18789c1 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1866,47 +1866,6 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
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
@@ -1926,6 +1885,7 @@ static int vidioc_g_fmt_vbi_cap(struct file *file, void *priv,
 	f->fmt.vbi.start[1] = (dev->norm & V4L2_STD_625_50) ?
 	    PAL_VBI_START_LINE + 312 : NTSC_VBI_START_LINE + 263;
 	f->fmt.vbi.count[1] = f->fmt.vbi.count[0];
+	memset(f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 
 	return 0;
 
@@ -1949,6 +1909,7 @@ static int vidioc_try_fmt_vbi_cap(struct file *file, void *priv,
 	f->fmt.vbi.start[1] = (dev->norm & V4L2_STD_625_50) ?
 	    PAL_VBI_START_LINE + 312 : NTSC_VBI_START_LINE + 263;
 	f->fmt.vbi.count[1] = f->fmt.vbi.count[0];
+	memset(f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
 
 	return 0;
 
@@ -2430,8 +2391,6 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap          = vidioc_s_fmt_vbi_cap,
 	.vidioc_cropcap                = vidioc_cropcap,
-	.vidioc_g_fmt_sliced_vbi_cap   = vidioc_g_fmt_sliced_vbi_cap,
-	.vidioc_try_fmt_sliced_vbi_cap = vidioc_try_set_sliced_vbi_cap,
 	.vidioc_reqbufs                = vidioc_reqbufs,
 	.vidioc_querybuf               = vidioc_querybuf,
 	.vidioc_qbuf                   = vidioc_qbuf,
-- 
1.7.10.4

