Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45813 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab3LROuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Dec 2013 09:50:09 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MY0001SABVKNY70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Dec 2013 23:50:08 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v3 6/8] s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING
 control value
Date: Wed, 18 Dec 2013 15:49:33 +0100
Message-id: <1387378175-23399-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
References: <1387378175-23399-1-git-send-email-j.anaszewski@samsung.com>
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
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 9195252..fc14bbc 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1094,6 +1094,7 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	struct vb2_queue *vq;
 	struct s5p_jpeg_q_data *q_data = NULL;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
+	struct v4l2_ctrl *ctrl_subs;
 	unsigned int f_type;
 
 	vq = v4l2_m2m_get_vq(ct->fh.m2m_ctx, f->type);
@@ -1119,6 +1120,13 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 	else
 		q_data->size = pix->sizeimage;
 
+	if (f_type == FMT_TYPE_OUTPUT) {
+		ctrl_subs = v4l2_ctrl_find(&ct->ctrl_handler,
+					V4L2_CID_JPEG_CHROMA_SUBSAMPLING);
+		if (ctrl_subs)
+			v4l2_ctrl_s_ctrl(ctrl_subs, q_data->fmt->subsampling);
+	}
+
 	return 0;
 }
 
-- 
1.7.9.5

