Return-path: <linux-media-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:41290 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab0CSSWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 14:22:35 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-media@vger.kernel.org
Subject: [PATCH] Revert "V4L/DVB (11906): saa7134: Use v4l bounding/alignment function"
Date: Fri, 19 Mar 2010 14:58:23 -0300
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003191458.24121.herton@mandriva.com.br>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit bc52d6eb44de8f19934768d4d10d19fdbdc99950.

On newer kernels, a saa7134 board stopped to display TV video output
properly. After a bisect, I found it as the commit causing the issue.
Turns out that v4l_bound_align_image isn't doing the same bounding
calculation as manually done previously in saa7134_try_fmt_vid_cap.

What isn't equal is the calculation done in clamp align, while
previously it did "f->fmt.pix.width &= ~0x03", clamp_align function
does "Round to nearest aligned value" as stated in the comment, which
yields a different result. If I comment the round calculation in
clamp_align like this: "x = (x /*+ (1 << (align - 1))*/) & mask",
I get it fixed too, because this way the calculation is the same then.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 drivers/media/video/saa7134/saa7134-video.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

Probaly this should be sent to stable as well (>= 2.6.31)

diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index ba87128..e305c16 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1640,8 +1640,15 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 	}
 
 	f->fmt.pix.field = field;
-	v4l_bound_align_image(&f->fmt.pix.width, 48, maxw, 2,
-			      &f->fmt.pix.height, 32, maxh, 0, 0);
+	if (f->fmt.pix.width  < 48)
+		f->fmt.pix.width  = 48;
+	if (f->fmt.pix.height < 32)
+		f->fmt.pix.height = 32;
+	if (f->fmt.pix.width > maxw)
+		f->fmt.pix.width = maxw;
+	if (f->fmt.pix.height > maxh)
+		f->fmt.pix.height = maxh;
+	f->fmt.pix.width &= ~0x03;
 	f->fmt.pix.bytesperline =
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
-- 
1.6.6

