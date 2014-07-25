Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:61852 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbaGYOV2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 10:21:28 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, j.anaszewski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 6/9] s5p-jpeg: Assure proper crop rectangle initialization
Date: Fri, 25 Jul 2014 16:20:50 +0200
Message-id: <1406298053-30184-7-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
References: <1406298053-30184-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacek Anaszewski <j.anaszewski@samsung.com>

Assure proper crop_rect initialization in case
the user space doesn't call S_SELECTION ioctl.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index d11357f..3e3d94d 100644
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

