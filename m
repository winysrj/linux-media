Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38306 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751985AbdIHPLQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 11:11:16 -0400
From: Srishti Sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: slongerbeam@gmail.com, p.zabel@pengutronix.de, mchehab@kernel.org,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, outreachy-kernel@googlegroups.com,
        Srishti Sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: media: imx: Prefer using BIT macro
Date: Fri,  8 Sep 2017 20:41:09 +0530
Message-Id: <1504883469-8127-1-git-send-email-srishtishar@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use BIT(x) instead of (1<<x).

Signed-off-by: Srishti Sharma <srishtishar@gmail.com>
---
 drivers/staging/media/imx/imx-media.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media.h b/drivers/staging/media/imx/imx-media.h
index d409170..e5b8d29 100644
--- a/drivers/staging/media/imx/imx-media.h
+++ b/drivers/staging/media/imx/imx-media.h
@@ -310,16 +310,16 @@ void imx_media_capture_device_set_format(struct imx_media_video_dev *vdev,
 void imx_media_capture_device_error(struct imx_media_video_dev *vdev);

 /* subdev group ids */
-#define IMX_MEDIA_GRP_ID_SENSOR    (1 << 8)
-#define IMX_MEDIA_GRP_ID_VIDMUX    (1 << 9)
-#define IMX_MEDIA_GRP_ID_CSI2      (1 << 10)
+#define IMX_MEDIA_GRP_ID_SENSOR    BIT(8)
+#define IMX_MEDIA_GRP_ID_VIDMUX    BIT(9)
+#define IMX_MEDIA_GRP_ID_CSI2      BIT(10)
 #define IMX_MEDIA_GRP_ID_CSI_BIT   11
 #define IMX_MEDIA_GRP_ID_CSI       (0x3 << IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_CSI0      (1 << IMX_MEDIA_GRP_ID_CSI_BIT)
+#define IMX_MEDIA_GRP_ID_CSI0      BIT(IMX_MEDIA_GRP_ID_CSI_BIT)
 #define IMX_MEDIA_GRP_ID_CSI1      (2 << IMX_MEDIA_GRP_ID_CSI_BIT)
-#define IMX_MEDIA_GRP_ID_VDIC      (1 << 13)
-#define IMX_MEDIA_GRP_ID_IC_PRP    (1 << 14)
-#define IMX_MEDIA_GRP_ID_IC_PRPENC (1 << 15)
-#define IMX_MEDIA_GRP_ID_IC_PRPVF  (1 << 16)
+#define IMX_MEDIA_GRP_ID_VDIC      BIT(13)
+#define IMX_MEDIA_GRP_ID_IC_PRP    BIT(14)
+#define IMX_MEDIA_GRP_ID_IC_PRPENC BIT(15)
+#define IMX_MEDIA_GRP_ID_IC_PRPVF  BIT(16)

 #endif
--
2.7.4
