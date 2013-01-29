Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:26630 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3A2Jue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Jan 2013 04:50:34 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC PATCH] em28xx: fix bytesperline calculation in TRY_FMT
Date: Tue, 29 Jan 2013 10:49:58 +0100
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301291049.58085.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was part of my original em28xx patch series. That particular patch
combined two things: this fix and the change where TRY_FMT would no
longer return -EINVAL for unsupported pixelformats. The latter change was
rejected (correctly), but we all forgot about the second part of the patch
which fixed a real bug. I'm reposting just that fix.

Regards,

	Hans

The bytesperline calculation was incorrect: it used the old width instead
of the provided width, and it miscalculated the bytesperline value for the
depth == 12 case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 2eabf2a..070506d 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -906,7 +906,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
 	f->fmt.pix.pixelformat = fmt->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
+	f->fmt.pix.bytesperline = width * ((fmt->depth + 7) >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	if (dev->progressive)
-- 
1.7.10.4

