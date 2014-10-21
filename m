Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:51078 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbaJUFJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 01:09:15 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support
Date: Tue, 21 Oct 2014 14:08:49 +0900
Message-Id: <1413868129-22121-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
---

This patch is against master branch of linuxtv.org/media_tree.git.

v2 [Yoshihiro Kaneko]
* remove unused/useless definition as suggested by Sergei Shtylyov

 drivers/media/platform/soc_camera/rcar_vin.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 20defcb..cb5e682 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -74,6 +74,7 @@
 #define VNMC_INF_YUV10_BT656	(2 << 16)
 #define VNMC_INF_YUV10_BT601	(3 << 16)
 #define VNMC_INF_YUV16		(5 << 16)
+#define VNMC_INF_RGB888		(6 << 16)
 #define VNMC_VUP		(1 << 10)
 #define VNMC_IM_ODD		(0 << 3)
 #define VNMC_IM_ODD_EVEN	(1 << 3)
@@ -272,6 +273,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 
 	/* input interface */
 	switch (icd->current_fmt->code) {
+	case V4L2_MBUS_FMT_RGB888_1X24:
+		/* BT.601/BT.709 24-bit RGB-888 */
+		vnmc |= VNMC_INF_RGB888;
+		break;
 	case V4L2_MBUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -331,6 +336,9 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	if (output_is_yuv)
 		vnmc |= VNMC_BPS;
 
+	if (vnmc & VNMC_INF_RGB888)
+		vnmc ^= VNMC_BPS;
+
 	/* progressive or interlaced mode */
 	interrupts = progressive ? VNIE_FIE | VNIE_EFE : VNIE_EFE;
 
@@ -1013,6 +1021,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	case V4L2_MBUS_FMT_YUYV8_1X16:
 	case V4L2_MBUS_FMT_YUYV8_2X8:
 	case V4L2_MBUS_FMT_YUYV10_2X10:
+	case V4L2_MBUS_FMT_RGB888_1X24:
 		if (cam->extra_fmt)
 			break;
 
-- 
1.9.1

