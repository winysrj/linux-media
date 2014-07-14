Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:12269 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaGNHWp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 03:22:45 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8O00BIXXTVCJ50@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 14 Jul 2014 16:22:44 +0900 (KST)
From: panpan liu <panpan1.liu@samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] s5p-mfc: limit the size of the CPB
Date: Mon, 14 Jul 2014 15:22:27 +0800
Message-id: <1405322547-3216-1-git-send-email-panpan1.liu@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register of the CPB limits the size. The max size is 4M, so it
is more reasonable.

Signed-off-by: panpan liu <panpan1.liu@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
 mode change 100644 => 100755 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
old mode 100644
new mode 100755
index 0bae907..889cb06
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -466,7 +466,8 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
 	pix_mp->height = 0;
 	pix_mp->width = 0;
-	if (pix_mp->plane_fmt[0].sizeimage)
+	if (pix_mp->plane_fmt[0].sizeimage &&
+			pix_mp->plane_fmt[0].sizeimage <= MAX_CPB_SIZE)
 		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
 	else
 		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =
--
1.7.9.5

