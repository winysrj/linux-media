Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1324 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab3BZRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Feb 2013 12:36:01 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/11] s2255: zero priv and set colorspace.
Date: Tue, 26 Feb 2013 18:35:41 +0100
Message-Id: <648749fd56294beff4857e5cec0517613a27633d.1361900043.git.hans.verkuil@cisco.com>
In-Reply-To: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
References: <1361900146-32759-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
References: <f11ed501c392d8891c3eefeb4959a117e5ddf94e.1361900043.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Set priv field of struct v4l2_pix_format to 0 and fill in colorspace.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/s2255/s2255drv.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 88f728d..a16bc6c 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -859,6 +859,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.pixelformat = channel->fmt->fourcc;
 	f->fmt.pix.bytesperline = f->fmt.pix.width * (channel->fmt->depth >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 	return 0;
 }
 
@@ -954,6 +956,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.field = field;
 	f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 	dprintk(50, "%s: set width %d height %d field %d\n", __func__,
 		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	return 0;
-- 
1.7.10.4

