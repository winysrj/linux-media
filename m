Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57232 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726891AbeINXiT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 19:38:19 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/4] media: em28xx: use a default format if TRY_FMT fails
Date: Fri, 14 Sep 2018 15:22:32 -0300
Message-Id: <5188cbaae8c66070a36afa44417be3d97cb931de.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536949178.git.mchehab+samsung@kernel.org>
References: <cover.1536949178.git.mchehab+samsung@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Follow the V4L2 spec, as warned by v4l2-compliance:

	warn: v4l2-test-formats.cpp(732): TRY_FMT cannot handle an invalid pixelformat.
	warn: v4l2-test-formats.cpp(733): This may or may not be a problem. For more information see:

warn: v4l2-test-formats.cpp(734): http://www.mail-archive.com/linux-media@vger.kernel.org/msg56550.html

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index fcb5c1b25ab3..41ac47f1589c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1471,9 +1471,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 	if (!fmt) {
-		em28xx_videodbg("Fourcc format (%08x) invalid.\n",
-				f->fmt.pix.pixelformat);
-		return -EINVAL;
+		fmt = &format[0];
+		em28xx_videodbg("Fourcc format (%08x) invalid. Using default (%08x).\n",
+				f->fmt.pix.pixelformat, fmt->fourcc);
 	}
 
 	if (dev->board.is_em2800) {
-- 
2.17.1
