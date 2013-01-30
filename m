Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1259 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab3A3SF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 13:05:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 1/2] c-qcam: fix v4l2-compliance issues.
Date: Wed, 30 Jan 2013 19:05:17 +0100
Message-Id: <98dd6be98fa8df515dfbe41b0d4dcdfaa24655e9.1359568912.git.hans.verkuil@cisco.com>
In-Reply-To: <1359569118-28009-1-git-send-email-hverkuil@xs4all.nl>
References: <1359569118-28009-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- zero priv field in pix_format
- fix poll return mask
- correctly fill in bus_info

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/parport/c-qcam.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/parport/c-qcam.c b/drivers/media/parport/c-qcam.c
index ec51e1f..8de8a20 100644
--- a/drivers/media/parport/c-qcam.c
+++ b/drivers/media/parport/c-qcam.c
@@ -518,7 +518,7 @@ static int qcam_querycap(struct file *file, void  *priv,
 
 	strlcpy(vcap->driver, qcam->v4l2_dev.name, sizeof(vcap->driver));
 	strlcpy(vcap->card, "Color Quickcam", sizeof(vcap->card));
-	strlcpy(vcap->bus_info, "parport", sizeof(vcap->bus_info));
+	strlcpy(vcap->bus_info, qcam->pport->name, sizeof(vcap->bus_info));
 	vcap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE;
 	vcap->capabilities = vcap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
@@ -561,6 +561,7 @@ static int qcam_g_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format *f
 	pix->sizeimage = 3 * qcam->width * qcam->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->priv = 0;
 	return 0;
 }
 
@@ -584,6 +585,7 @@ static int qcam_try_fmt_vid_cap(struct file *file, void *fh, struct v4l2_format
 	pix->sizeimage = 3 * pix->width * pix->height;
 	/* Just a guess */
 	pix->colorspace = V4L2_COLORSPACE_SRGB;
+	pix->priv = 0;
 	return 0;
 }
 
@@ -651,6 +653,11 @@ static ssize_t qcam_read(struct file *file, char __user *buf,
 	return len;
 }
 
+static unsigned int qcam_poll(struct file *filp, poll_table *wait)
+{
+	return v4l2_ctrl_poll(filp, wait) | POLLIN | POLLRDNORM;
+}
+
 static int qcam_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct qcam *qcam =
@@ -685,7 +692,7 @@ static const struct v4l2_file_operations qcam_fops = {
 	.owner		= THIS_MODULE,
 	.open		= v4l2_fh_open,
 	.release	= v4l2_fh_release,
-	.poll		= v4l2_ctrl_poll,
+	.poll		= qcam_poll,
 	.unlocked_ioctl	= video_ioctl2,
 	.read		= qcam_read,
 };
-- 
1.7.10.4

