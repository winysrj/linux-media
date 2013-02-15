Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4863 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOJTK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 04:19:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/9] s2255: zero priv and set colorspace.
Date: Fri, 15 Feb 2013 10:18:51 +0100
Message-Id: <8c9359a1be796cb55a5f3c54f63cb27352cdf2b6.1360919695.git.hans.verkuil@cisco.com>
In-Reply-To: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
References: <1360919934-25552-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
References: <fa483ff8ca5aae815cd227f47fe797c1c5a8a73d.1360919695.git.hans.verkuil@cisco.com>
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

