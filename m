Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49423 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751995AbdHKLuR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 07:50:17 -0400
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 2/2] media: s5p-jpeg: set w/h when encoding
Date: Fri, 11 Aug 2017 13:50:01 +0200
Message-id: <1502452201-17171-3-git-send-email-andrzej.p@samsung.com>
In-reply-to: <1502452201-17171-1-git-send-email-andrzej.p@samsung.com>
References: <1502191352-11595-1-git-send-email-andrzej.p@samsung.com>
 <1502452201-17171-1-git-send-email-andrzej.p@samsung.com>
 <CGME20170811115012eucas1p218b11e4b15ff2eb88910e58619d96a67@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

q_data w/h must be set when encoding.

Fixes: 1c84e7f9d5dc596be (media: s5p-jpeg: Add support for resolution change event)
Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index c00e3a1..e1babb8 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1634,6 +1634,12 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 			FMT_TYPE_OUTPUT : FMT_TYPE_CAPTURE;
 
 	q_data->fmt = s5p_jpeg_find_format(ct, pix->pixelformat, f_type);
+	if (ct->mode == S5P_JPEG_ENCODE ||
+		(ct->mode == S5P_JPEG_DECODE &&
+		q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG)) {
+		q_data->w = pix->width;
+		q_data->h = pix->height;
+	}
 	if (q_data->fmt->fourcc != V4L2_PIX_FMT_JPEG) {
 		/*
 		 * During encoding Exynos4x12 SoCs access wider memory area
@@ -1641,8 +1647,6 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 		 * the JPEG_IMAGE_SIZE register. In order to avoid sysmmu
 		 * page fault calculate proper buffer size in such a case.
 		 */
-		q_data->w = pix->width;
-		q_data->h = pix->height;
 		if (ct->jpeg->variant->hw_ex4_compat &&
 		    f_type == FMT_TYPE_OUTPUT && ct->mode == S5P_JPEG_ENCODE)
 			q_data->size = exynos4_jpeg_get_output_buffer_size(ct,
-- 
1.9.1
