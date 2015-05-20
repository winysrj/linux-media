Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56490 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932162AbbEUJDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:03:05 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 07/20] media: soc_camera: rcar_vin: Add BT.709 24-bit RGB888 input support
Date: Wed, 20 May 2015 17:39:27 +0100
Message-Id: <1432139980-12619-8-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>

Modified to use MEDIA_BUS_FMT_* constants

Signed-off-by: William Towle <william.towle@codethink.co.uk>
Reviewed-by: Rob Taylor <rob.taylor@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index db7700b..0f67646 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -98,6 +98,7 @@
 #define VNMC_INF_YUV10_BT656	(2 << 16)
 #define VNMC_INF_YUV10_BT601	(3 << 16)
 #define VNMC_INF_YUV16		(5 << 16)
+#define VNMC_INF_RGB888		(6 << 16)
 #define VNMC_VUP		(1 << 10)
 #define VNMC_IM_ODD		(0 << 3)
 #define VNMC_IM_ODD_EVEN	(1 << 3)
@@ -620,6 +621,10 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 
 	/* input interface */
 	switch (icd->current_fmt->code) {
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		/* BT.601/BT.709 24-bit RGB-888 */
+		vnmc |= VNMC_INF_RGB888;
+		break;
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* BT.601/BT.1358 16bit YCbCr422 */
 		vnmc |= VNMC_INF_YUV16;
@@ -679,6 +684,15 @@ static int rcar_vin_setup(struct rcar_vin_priv *priv)
 	if (output_is_yuv)
 		vnmc |= VNMC_BPS;
 
+	/*
+	 * The above assumes YUV input, toggle BPS for RGB input.
+	 * RGB inputs can be detected by checking that the most-significant
+	 * two bits of INF are set. This corresponds to the bits
+	 * set in VNMC_INF_RGB888.
+	 */
+	if ((vnmc & VNMC_INF_RGB888) == VNMC_INF_RGB888)
+		vnmc ^= VNMC_BPS;
+
 	/* progressive or interlaced mode */
 	interrupts = progressive ? VNIE_FIE : VNIE_EFE;
 
@@ -1423,6 +1437,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
 	case MEDIA_BUS_FMT_YUYV8_1X16:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_YUYV10_2X10:
+	case MEDIA_BUS_FMT_RGB888_1X24:
 		if (cam->extra_fmt)
 			break;
 
-- 
1.7.10.4

