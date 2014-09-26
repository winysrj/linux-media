Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:8553 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaIZFAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Sep 2014 01:00:34 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0NCH00K9FSKX7R60@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 26 Sep 2014 14:00:33 +0900 (KST)
From: Kiran AVND <avnd.kiran@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, wuchengli@chromium.org, posciak@chromium.org,
	arun.m@samsung.com, ihf@chromium.org, prathyush.k@samsung.com,
	arun.kk@samsung.com, kiran@chromium.org
Subject: [PATCH v2 14/14] [media] s5p-mfc: Don't change the image size to
 smaller than the request.
Date: Fri, 26 Sep 2014 10:22:22 +0530
Message-id: <1411707142-4881-15-git-send-email-avnd.kiran@samsung.com>
In-reply-to: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
References: <1411707142-4881-1-git-send-email-avnd.kiran@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@chromium.org>

Use the requested size as the minimum bound, unless it's less than the
required hardware minimum. The bound align function will align to the
closest value but we do not want to adjust below the requested size.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 407dc63..7b48180 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1056,6 +1056,7 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_fmt *fmt;
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
+	u32 min_w, min_h;
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		fmt = find_format(f, MFC_FMT_ENC);
@@ -1090,8 +1091,16 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			return -EINVAL;
 		}
 
-		v4l_bound_align_image(&pix_fmt_mp->width, 8, 1920, 1,
-			&pix_fmt_mp->height, 4, 1080, 1, 0);
+		/*
+		 * Use the requested size as the minimum bound, unless it's less
+		 * than the required hardware minimum. The bound align function
+		 * will align to the closest value but we do not want to adjust
+		 * below the requested size.
+		 */
+		min_w = min(max(16u, pix_fmt_mp->width), 1920u);
+		min_h = min(max(16u, pix_fmt_mp->height), 1088u);
+		v4l_bound_align_image(&pix_fmt_mp->width, min_w, 1920, 4,
+			&pix_fmt_mp->height, min_h, 1088, 4, 0);
 	} else {
 		mfc_err("invalid buf type\n");
 		return -EINVAL;
-- 
1.7.9.5

