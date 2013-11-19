Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:19234 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3KSO2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:28:10 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI006K9LIUBP10@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:28:09 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 14/16] s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING
 control value
Date: Tue, 19 Nov 2013 15:27:06 +0100
Message-id: <1384871228-6648-15-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When output queue fourcc is set to any flavour of YUV,
the V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value as
well as its in-driver cached counterpart have to be
updated with the subsampling property of the format
so as to be able to provide correct information to the
user space and preclude setting an illegal subsampling
mode for Exynos4x12 encoder.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 319be0c..d4db612 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1038,6 +1038,7 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
 {
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 	struct s5p_jpeg_fmt *fmt;
+	struct v4l2_control ctrl_subs;
 
 	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
 						FMT_TYPE_OUTPUT);
@@ -1048,6 +1049,10 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
+	ctrl_subs.id = V4L2_CID_JPEG_CHROMA_SUBSAMPLING;
+	ctrl_subs.value = fmt->subsampling;
+	v4l2_s_ctrl(priv, &ctx->ctrl_handler, &ctrl_subs);
+
 	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_OUTPUT);
 }
 
-- 
1.7.9.5

