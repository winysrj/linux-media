Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2442 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab3A3SF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 13:05:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/2] c-qcam: add enum_framesizes support.
Date: Wed, 30 Jan 2013 19:05:18 +0100
Message-Id: <8cfa5c3bb7b52fa29608bc6372a7015dcc6eadf6.1359568912.git.hans.verkuil@cisco.com>
In-Reply-To: <1359569118-28009-1-git-send-email-hverkuil@xs4all.nl>
References: <1359569118-28009-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <98dd6be98fa8df515dfbe41b0d4dcdfaa24655e9.1359568912.git.hans.verkuil@cisco.com>
References: <98dd6be98fa8df515dfbe41b0d4dcdfaa24655e9.1359568912.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/c-qcam.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/media/parport/c-qcam.c b/drivers/media/parport/c-qcam.c
index 8de8a20..41f5d23 100644
--- a/drivers/media/parport/c-qcam.c
+++ b/drivers/media/parport/c-qcam.c
@@ -569,10 +569,10 @@ static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format
 {
 	struct v4l2_pix_format *pix = &fmt->fmt.pix;
 
-	if (pix->height < 60 || pix->width < 80) {
+	if (pix->height <= 60 || pix->width <= 80) {
 		pix->height = 60;
 		pix->width = 80;
-	} else if (pix->height < 120 || pix->width < 160) {
+	} else if (pix->height <= 120 || pix->width <= 160) {
 		pix->height = 120;
 		pix->width = 160;
 	} else {
@@ -638,6 +638,24 @@ static int qcam_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdes
 	return 0;
 }
 
+static int qcam_enum_framesizes(struct file *file, void *fh,
+					 struct v4l2_frmsizeenum *fsize)
+{
+	static const struct v4l2_frmsize_discrete sizes[] = {
+		{  80,  60 },
+		{ 160, 120 },
+		{ 320, 240 },
+	};
+
+	if (fsize->index > 2)
+		return -EINVAL;
+	if (fsize->pixel_format != V4L2_PIX_FMT_RGB24)
+		return -EINVAL;
+	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete = sizes[fsize->index];
+	return 0;
+}
+
 static ssize_t qcam_read(struct file *file, char __user *buf,
 			 size_t count, loff_t *ppos)
 {
@@ -702,6 +720,7 @@ static const struct v4l2_ioctl_ops qcam_ioctl_ops = {
 	.vidioc_g_input      		    = qcam_g_input,
 	.vidioc_s_input      		    = qcam_s_input,
 	.vidioc_enum_input   		    = qcam_enum_input,
+	.vidioc_enum_framesizes		    = qcam_enum_framesizes,
 	.vidioc_enum_fmt_vid_cap	    = qcam_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap 		    = qcam_g_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap  		    = qcam_s_fmt_vid_cap,
-- 
1.7.10.4

