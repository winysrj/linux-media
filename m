Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:58450 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbcEGFOt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 May 2016 01:14:49 -0400
From: ayaka <ayaka@soulik.info>
To: linux-kernel@vger.kernel.org
Cc: m.szyprowski@samsung.com, nicolas.dufresne@collabora.com,
	shuahkh@osg.samsung.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, k.debski@samsung.com,
	jtp.park@samsung.com, kyungmin.park@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	ayaka <ayaka@soulik.info>
Subject: [PATCH 2/3] [media] s5p-mfc: remove unnecessary check in try_fmt
Date: Sat,  7 May 2016 13:05:25 +0800
Message-Id: <1462597526-31559-3-git-send-email-ayaka@soulik.info>
In-Reply-To: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
References: <1462597526-31559-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We don't need to request the sizeimage or num_planes
in try_fmt.

Signed-off-by: ayaka <ayaka@soulik.info>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index a66a9f9..2f76aba 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1043,10 +1043,6 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to try output format\n");
 			return -EINVAL;
 		}
-		if (pix_fmt_mp->plane_fmt[0].sizeimage == 0) {
-			mfc_err("must be set encoding output size\n");
-			return -EINVAL;
-		}
 		if ((dev->variant->version_bit & fmt->versions) == 0) {
 			mfc_err("Unsupported format by this MFC version.\n");
 			return -EINVAL;
@@ -1060,11 +1056,6 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
 			mfc_err("failed to try output format\n");
 			return -EINVAL;
 		}
-
-		if (fmt->num_planes != pix_fmt_mp->num_planes) {
-			mfc_err("failed to try output format\n");
-			return -EINVAL;
-		}
 		if ((dev->variant->version_bit & fmt->versions) == 0) {
 			mfc_err("Unsupported format by this MFC version.\n");
 			return -EINVAL;
-- 
2.5.5

