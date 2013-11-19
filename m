Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55579 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3KSO1d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:33 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00M2HLHQNH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:32 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 03/16] s5p-jpeg: Fix erroneous condition while validating
 bytesperline value
Date: Tue, 19 Nov 2013 15:26:55 +0100
Message-id: <1384871228-6648-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The aim of the condition is ensuring that the bytesperline
value set by the user space application is proper for the
given format and adjusting it if isn't. As the depth value
of the format description entry is expressed in bits then
the bytesperline value needs to be divided, not multiplied,
by that value to get the number of bytes required to store
single line of image samples.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 0f567c5..a1366f0 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -670,7 +670,7 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
 			bpl = pix->width; /* planar */
 
 		if (fmt->colplanes == 1 && /* packed */
-		    (bpl << 3) * fmt->depth < pix->width)
+		    (bpl << 3) / fmt->depth < pix->width)
 			bpl = (pix->width * fmt->depth) >> 3;
 
 		pix->bytesperline = bpl;
-- 
1.7.9.5

