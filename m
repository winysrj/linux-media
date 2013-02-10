Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1703 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201Ab3BJRxJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 12:53:09 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 08/12] stk-webcam: zero the priv field of v4l2_pix_format.
Date: Sun, 10 Feb 2013 18:52:49 +0100
Message-Id: <13d5570e9ad90f25bb2bc50e957f3692a6788888.1360518391.git.hans.verkuil@cisco.com>
In-Reply-To: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
References: <1360518773-1065-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
References: <21a2f157a80755483630be6aab26f67dc9f041c6.1360518390.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The priv field should be set to 0. In this case the driver abused the priv
field for internal housekeeping. Modify the code so priv is no longer used
for that purpose.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Arvydas Sidorenko <asido4@gmail.com>
---
 drivers/media/usb/stkwebcam/stk-webcam.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index c72a1c4..ce802f7 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -859,11 +859,12 @@ static int stk_vidioc_g_fmt_vid_cap(struct file *filp,
 		pix_format->bytesperline = 2 * pix_format->width;
 	pix_format->sizeimage = pix_format->bytesperline
 				* pix_format->height;
+	pix_format->priv = 0;
 	return 0;
 }
 
-static int stk_vidioc_try_fmt_vid_cap(struct file *filp,
-		void *priv, struct v4l2_format *fmtd)
+static int stk_try_fmt_vid_cap(struct file *filp,
+		struct v4l2_format *fmtd, int *idx)
 {
 	int i;
 	switch (fmtd->fmt.pix.pixelformat) {
@@ -885,11 +886,13 @@ static int stk_vidioc_try_fmt_vid_cap(struct file *filp,
 			< abs(fmtd->fmt.pix.width - stk_sizes[i].w))) {
 		fmtd->fmt.pix.height = stk_sizes[i-1].h;
 		fmtd->fmt.pix.width = stk_sizes[i-1].w;
-		fmtd->fmt.pix.priv = i - 1;
+		if (idx)
+			*idx = i - 1;
 	} else {
 		fmtd->fmt.pix.height = stk_sizes[i].h;
 		fmtd->fmt.pix.width = stk_sizes[i].w;
-		fmtd->fmt.pix.priv = i;
+		if (idx)
+			*idx = i;
 	}
 
 	fmtd->fmt.pix.field = V4L2_FIELD_NONE;
@@ -900,9 +903,16 @@ static int stk_vidioc_try_fmt_vid_cap(struct file *filp,
 		fmtd->fmt.pix.bytesperline = 2 * fmtd->fmt.pix.width;
 	fmtd->fmt.pix.sizeimage = fmtd->fmt.pix.bytesperline
 		* fmtd->fmt.pix.height;
+	fmtd->fmt.pix.priv = 0;
 	return 0;
 }
 
+static int stk_vidioc_try_fmt_vid_cap(struct file *filp,
+		void *priv, struct v4l2_format *fmtd)
+{
+	return stk_try_fmt_vid_cap(filp, fmtd, NULL);
+}
+
 static int stk_setup_format(struct stk_camera *dev)
 {
 	int i = 0;
@@ -943,6 +953,7 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 		void *priv, struct v4l2_format *fmtd)
 {
 	int ret;
+	int idx;
 	struct stk_camera *dev = video_drvdata(filp);
 
 	if (dev == NULL)
@@ -953,7 +964,7 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 		return -EBUSY;
 	if (dev->owner && dev->owner != filp)
 		return -EBUSY;
-	ret = stk_vidioc_try_fmt_vid_cap(filp, priv, fmtd);
+	ret = stk_try_fmt_vid_cap(filp, fmtd, &idx);
 	if (ret)
 		return ret;
 	dev->owner = filp;
@@ -961,7 +972,7 @@ static int stk_vidioc_s_fmt_vid_cap(struct file *filp,
 	dev->vsettings.palette = fmtd->fmt.pix.pixelformat;
 	stk_free_buffers(dev);
 	dev->frame_size = fmtd->fmt.pix.sizeimage;
-	dev->vsettings.mode = stk_sizes[fmtd->fmt.pix.priv].m;
+	dev->vsettings.mode = stk_sizes[idx].m;
 
 	stk_initialise(dev);
 	return stk_setup_format(dev);
-- 
1.7.10.4

