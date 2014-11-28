Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:15456 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaK1NKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 08:10:32 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFR00FB139H9D80@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 28 Nov 2014 22:10:29 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] s5p-jpeg: Fix possible NULL pointer dereference in s_fmt
Date: Fri, 28 Nov 2014 14:10:18 +0100
Message-id: <1417180218-4421-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some formats are not supported in encoding or decoding
mode for given type of buffer (e.g. V4L2_PIX_FMT_JPEG
is supported on output buffer only while in decoding
mode). Make S_FMT failing if not suitable format
is found.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d7571cd..dfab848 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1345,6 +1345,14 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 			FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
 
 	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
+
+	if (!q_data->fmt) {
+		v4l2_err(&ct->jpeg->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
 	q_data->w = pix->width;
 	q_data->h = pix->height;
 	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
-- 
1.7.9.5

