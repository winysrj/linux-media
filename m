Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61742 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab3ADVAD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:03 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so16727205vby.5
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:02 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 10/15] em28xx: fix broken TRY_FMT.
Date: Fri,  4 Jan 2013 15:59:40 -0500
Message-Id: <1357333186-8466-11-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

TRY_FMT should not return an error if a pixelformat is unsupported. Instead just
pick a common pixelformat.

Also the bytesperline calculation was incorrect: it used the old width instead of
the provided with, and it miscalculated the bytesperline value for the depth == 12
case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a91a248..7c09b55 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -821,7 +821,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	if (!fmt) {
 		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
 				f->fmt.pix.pixelformat);
-		return -EINVAL;
+		fmt = format_by_fourcc(V4L2_PIX_FMT_YUYV);
 	}
 
 	if (dev->board.is_em2800) {
@@ -847,7 +847,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.width = width;
 	f->fmt.pix.height = height;
 	f->fmt.pix.pixelformat = fmt->fourcc;
-	f->fmt.pix.bytesperline = (dev->width * fmt->depth + 7) >> 3;
+	f->fmt.pix.bytesperline = width * ((fmt->depth + 7) >> 3);
 	f->fmt.pix.sizeimage = f->fmt.pix.bytesperline * height;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	if (dev->progressive)
-- 
1.7.9.5

