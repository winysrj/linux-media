Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:57799 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaGGQdR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 12:33:17 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 5/9] s5p-jpeg: Assure proper crop rectangle initialization
Date: Mon, 07 Jul 2014 18:32:06 +0200
Message-id: <1404750730-22996-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
References: <1404750730-22996-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Assure proper crop_rect initialization in case
the user space doesn't call S_SELECTION ioctl.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 09b59d3..2491ef8 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1367,6 +1367,21 @@ static int s5p_jpeg_s_fmt(struct s5p_jpeg_ctx *ct, struct v4l2_format *f)
 					V4L2_CID_JPEG_CHROMA_SUBSAMPLING);
 		if (ctrl_subs)
 			v4l2_ctrl_s_ctrl(ctrl_subs, q_data->fmt->subsampling);
+		ct->crop_altered = false;
+	}
+
+	/*
+	 * For decoding init crop_rect with capture buffer dimmensions which
+	 * contain aligned dimensions of the input JPEG image and do it only
+	 * if crop rectangle hasn't been altered by the user space e.g. with
+	 * S_SELECTION ioctl. For encoding assign output buffer dimensions.
+	 */
+	if (!ct->crop_altered &&
+	    ((ct->mode == S5P_JPEG_DECODE && f_type == FMT_TYPE_CAPTURE) ||
+	     (ct->mode == S5P_JPEG_ENCODE && f_type == FMT_TYPE_OUTPUT))) {
+		ct->crop_rect.width = pix->width;
+		ct->crop_rect.height = pix->height;
+	}
 	}
 
 	return 0;
-- 
1.7.9.5

