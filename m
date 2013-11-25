Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58478 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3KYJ6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Nov 2013 04:58:44 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWT00JF0D1V3440@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 25 Nov 2013 18:58:43 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sw0312.kim@samsung.com, andrzej.p@samsung.com,
	s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 03/16] s5p-jpeg: Fix erroneous condition while validating
 bytesperline value
Date: Mon, 25 Nov 2013 10:58:10 +0100
Message-id: <1385373503-1657-4-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
References: <1385373503-1657-1-git-send-email-j.anaszewski@samsung.com>
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

