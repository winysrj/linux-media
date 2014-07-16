Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:39623 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908AbaGPBvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 21:51:51 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8S0004C7UEWA70@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Jul 2014 10:51:50 +0900 (KST)
From: panpan liu <panpan1.liu@samsung.com>
To: kyungmin.park@samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, mchehab@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH] s5p-mfc: limit the size of the CPB
Date: Wed, 16 Jul 2014 09:51:33 +0800
Message-id: <1405475493-3200-1-git-send-email-panpan1.liu@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CPB size is limited by the hardware. Add this limit to the s_fmt.

Signed-off-by: panpan liu <panpan1.liu@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 0bae907..0621ed8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -413,6 +413,7 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	int ret = 0;
 	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_mp;
+	struct s5p_mfc_buf_size *buf_size = dev->variant->buf_size;

 	mfc_debug_enter();
 	ret = vidioc_try_fmt(file, priv, f);
@@ -466,11 +467,13 @@ static int vidioc_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	mfc_debug(2, "The codec number is: %d\n", ctx->codec_mode);
 	pix_mp->height = 0;
 	pix_mp->width = 0;
-	if (pix_mp->plane_fmt[0].sizeimage)
-		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
-	else
+	if (pix_mp->plane_fmt[0].sizeimage == 0)
 		pix_mp->plane_fmt[0].sizeimage = ctx->dec_src_buf_size =
 								DEF_CPB_SIZE;
+	else if (pix_mp->plane_fmt[0].sizeimage > buf_size->cpb)
+		ctx->dec_src_buf_size = buf_size->cpb;
+	else
+		ctx->dec_src_buf_size = pix_mp->plane_fmt[0].sizeimage;
 	pix_mp->plane_fmt[0].bytesperline = 0;
 	ctx->state = MFCINST_INIT;
 out:
--
1.7.9.5

