Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34013 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaGKPUE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 11:20:04 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8J00CHJZXFTOB0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 12 Jul 2014 00:20:03 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, andrzej.p@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 5/9] s5p-jpeg: Assure proper crop rectangle initialization
Date: Fri, 11 Jul 2014 17:19:46 +0200
Message-id: <1405091990-28567-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
References: <1405091990-28567-1-git-send-email-j.anaszewski@samsung.com>
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

