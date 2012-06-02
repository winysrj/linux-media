Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3325 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023Ab2FBL6d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 07:58:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 4/6] zr364xx: fix querycap and fill in colorspace.
Date: Sat,  2 Jun 2012 13:58:18 +0200
Message-Id: <dd81ce2b20dc6c7d8f0a0d2b935be98bc5693610.1338638167.git.hans.verkuil@cisco.com>
In-Reply-To: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
References: <1338638300-9769-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
References: <dd538e942bd8b7a7fb4e02ea9b4b6df72b32f9f1.1338638167.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/zr364xx.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/zr364xx.c b/drivers/media/video/zr364xx.c
index 974515d..a1729b3 100644
--- a/drivers/media/video/zr364xx.c
+++ b/drivers/media/video/zr364xx.c
@@ -731,9 +731,10 @@ static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
 	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
-	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_READWRITE |
 			    V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
@@ -828,7 +829,7 @@ static int zr364xx_vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.field = V4L2_FIELD_NONE;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
 	f->fmt.pix.priv = 0;
 	DBG("%s: V4L2_PIX_FMT_%s (%d) ok!\n", __func__,
 	    decode_fourcc(f->fmt.pix.pixelformat, pixelformat_name),
@@ -851,7 +852,7 @@ static int zr364xx_vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.height = cam->height;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
 	f->fmt.pix.priv = 0;
 	return 0;
 }
@@ -888,7 +889,7 @@ static int zr364xx_vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 		 cam->width, cam->height);
 	f->fmt.pix.bytesperline = f->fmt.pix.width * 2;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
-	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
 	f->fmt.pix.priv = 0;
 	cam->vb_vidq.field = f->fmt.pix.field;
 
-- 
1.7.10

