Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2479 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2F1Gss (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jun 2012 02:48:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv3 PATCH 33/33] pwc: v4l2-compliance fixes.
Date: Thu, 28 Jun 2012 08:48:27 +0200
Message-Id: <7ad599cd969356f22be5b068424a622106e4e890.1340865818.git.hans.verkuil@cisco.com>
In-Reply-To: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
References: <1340866107-4188-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
References: <d97434d2319fb8dbea360404f9343c680b5b196e.1340865818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- add device_caps
- set colorspace
- s_parm should support a fps of 0 (== reset to nominal fps)

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/pwc/pwc-v4l.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
index 114ae41..545e9bb 100644
--- a/drivers/media/video/pwc/pwc-v4l.c
+++ b/drivers/media/video/pwc/pwc-v4l.c
@@ -405,6 +405,7 @@ static void pwc_vidioc_fill_fmt(struct v4l2_format *f,
 	f->fmt.pix.pixelformat  = pixfmt;
 	f->fmt.pix.bytesperline = f->fmt.pix.width;
 	f->fmt.pix.sizeimage	= f->fmt.pix.height * f->fmt.pix.width * 3 / 2;
+	f->fmt.pix.colorspace	= V4L2_COLORSPACE_SRGB;
 	PWC_DEBUG_IOCTL("pwc_vidioc_fill_fmt() "
 			"width=%d, height=%d, bytesperline=%d, sizeimage=%d, pixelformat=%c%c%c%c\n",
 			f->fmt.pix.width,
@@ -497,10 +498,9 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	strcpy(cap->driver, PWC_NAME);
 	strlcpy(cap->card, pdev->vdev.name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE	|
-		V4L2_CAP_STREAMING	|
-		V4L2_CAP_READWRITE;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
+					V4L2_CAP_READWRITE;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
 }
 
@@ -509,7 +509,8 @@ static int pwc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 	if (i->index)	/* Only one INPUT is supported */
 		return -EINVAL;
 
-	strcpy(i->name, "usb");
+	strlcpy(i->name, "Camera", sizeof(i->name));
+	i->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }
 
@@ -1003,12 +1004,18 @@ static int pwc_s_parm(struct file *file, void *fh,
 	int compression = 0;
 	int ret, fps;
 
-	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
-	    parm->parm.capture.timeperframe.numerator == 0)
+	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	fps = parm->parm.capture.timeperframe.denominator /
-	      parm->parm.capture.timeperframe.numerator;
+	/* If timeperframe == 0, then reset the framerate to the nominal value.
+	   We pick a high framerate here, and let pwc_set_video_mode() figure
+	   out the best match. */
+	if (parm->parm.capture.timeperframe.numerator == 0 ||
+	    parm->parm.capture.timeperframe.denominator == 0)
+		fps = 30;
+	else
+		fps = parm->parm.capture.timeperframe.denominator /
+		      parm->parm.capture.timeperframe.numerator;
 
 	if (vb2_is_busy(&pdev->vb_queue))
 		return -EBUSY;
-- 
1.7.10

