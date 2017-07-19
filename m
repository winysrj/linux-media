Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35590 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752887AbdGSIVp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 04:21:45 -0400
Received: by mail-wm0-f65.google.com with SMTP id n64so1388750wmg.2
        for <linux-media@vger.kernel.org>; Wed, 19 Jul 2017 01:21:45 -0700 (PDT)
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Sekhar Nori <nsekhar@ti.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 1/2] media: platform: davinci: prepare for removal of VPFE_CMD_S_CCDC_RAW_PARAMS ioctl
Date: Wed, 19 Jul 2017 09:21:33 +0100
Message-Id: <1500452494-15879-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1500452494-15879-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1500452494-15879-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

preparing for removal of VPFE_CMD_S_CCDC_RAW_PARAMS ioctl having
minimalistic code changes so as it can be applied for backports.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index e3fe3e0..1831bf5 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1719,27 +1719,9 @@ static long vpfe_param_handler(struct file *file, void *priv,
 
 	switch (cmd) {
 	case VPFE_CMD_S_CCDC_RAW_PARAMS:
+		ret = -EINVAL;
 		v4l2_warn(&vpfe_dev->v4l2_dev,
-			  "VPFE_CMD_S_CCDC_RAW_PARAMS: experimental ioctl\n");
-		if (ccdc_dev->hw_ops.set_params) {
-			ret = ccdc_dev->hw_ops.set_params(param);
-			if (ret) {
-				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-					"Error setting parameters in CCDC\n");
-				goto unlock_out;
-			}
-			ret = vpfe_get_ccdc_image_format(vpfe_dev,
-							 &vpfe_dev->fmt);
-			if (ret < 0) {
-				v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-					"Invalid image format at CCDC\n");
-				goto unlock_out;
-			}
-		} else {
-			ret = -EINVAL;
-			v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
-				"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
-		}
+			"VPFE_CMD_S_CCDC_RAW_PARAMS not supported\n");
 		break;
 	default:
 		ret = -ENOTTY;
-- 
2.7.4
