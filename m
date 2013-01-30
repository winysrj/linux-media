Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3468 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3A3IB3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 03:01:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFCv2 PATCH] em28xx: fix bytesperline calculation in G/TRY_FMT
Date: Wed, 30 Jan 2013 09:01:22 +0100
Cc: Frank =?iso-8859-1?q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301300901.22486.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was part of my original em28xx patch series. That particular patch
combined two things: this fix and the change where TRY_FMT would no
longer return -EINVAL for unsupported pixelformats. The latter change was
rejected (correctly), but we all forgot about the second part of the patch
which fixed a real bug. I'm reposting just that fix.

Changes since v1:

- v1 still miscalculated the bytesperline and imagesize values (they were
  too large).
- G_FMT had the same calculation bug.

Tested with my em28xx.

Regards,

        Hans

The bytesperline calculation was incorrect: it used the old width instead of
the provided width in the case of TRY_FMT, and it miscalculated the bytesperline
value for the depth == 12 (planar YUV 4:1:1) case. For planar formats the
bytesperline value should be the bytesperline of the widest plane, which is
the Y plane which has 8 bits per pixel, not 12.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2eabf2a..6ced426 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -837,8 +837,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = dev->width;
 	f->fmt.pix.height = dev->height;
 	f->fmt.pix.pixelformat = dev->format->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * dev->format->depth + 7) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline  * dev->height;
+	f->fmt.pix.bytesperline = dev->width * (dev->format->depth >> 3);
+	f->fmt.pix.sizeimage = (dev->width * dev->height * dev->format->depth + 7) >> 3;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	/* FIXME: TOP? NONE? BOTTOM? ALTENATE? */
@@ -906,8 +906,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
 	f->fmt.pix.pixelformat = fmt->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
-	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
+	f->fmt.pix.bytesperline = width * (fmt->depth >> 3);
+	f->fmt.pix.sizeimage = (width * height * fmt->depth + 7) >> 3;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	if (dev->progressive)
 		f->fmt.pix.field = V4L2_FIELD_NONE;
-- 
1.7.10.4

