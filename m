Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:33431 "EHLO
	relmlor3.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076Ab3DQMoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 08:44:01 -0400
Received: from relmlir4.idc.renesas.com ([10.200.68.154])
 by relmlor3.idc.renesas.com ( SJSMS)
 with ESMTP id <0MLE00D4AGPB8B60@relmlor3.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 17 Apr 2013 21:43:59 +0900 (JST)
Received: from relmlac2.idc.renesas.com ([10.200.69.22])
 by relmlir4.idc.renesas.com ( SJSMS)
 with ESMTP id <0MLE00J0KGPBRCB0@relmlir4.idc.renesas.com> for
 linux-media@vger.kernel.org; Wed, 17 Apr 2013 21:43:59 +0900 (JST)
From: Phil Edworthy <phil.edworthy@renesas.com>
To: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Phil Edworthy <phil.edworthy@renesas.com>
Subject: [PATCH] soc_camera: Add V4L2_MBUS_FMT_YUYV10_2X10 format
Message-id: <1366202619-4511-1-git-send-email-phil.edworthy@renesas.com>
Date: Wed, 17 Apr 2013 13:43:39 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_MBUS_FMT_YUYV10_2X10 format has already been added to mediabus, so
this patch just adds SoC camera support.

Signed-off-by: Phil Edworthy <phil.edworthy@renesas.com>
---
 drivers/media/platform/soc_camera/soc_mediabus.c |   15 +++++++++++++++
 include/media/soc_mediabus.h                     |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
index 7569e77..be47d41 100644
--- a/drivers/media/platform/soc_camera/soc_mediabus.c
+++ b/drivers/media/platform/soc_camera/soc_mediabus.c
@@ -57,6 +57,15 @@ static const struct soc_mbus_lookup mbus_fmt[] = {
 		.layout			= SOC_MBUS_LAYOUT_PACKED,
 	},
 }, {
+	.code = V4L2_MBUS_FMT_YUYV10_2X10,
+	.fmt = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.name			= "YUYV",
+		.bits_per_sample	= 10,
+		.packing		= SOC_MBUS_PACKING_2X10_PADHI,
+		.order			= SOC_MBUS_ORDER_LE,
+	},
+}, {
 	.code = V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
 	.fmt = {
 		.fourcc			= V4L2_PIX_FMT_RGB555,
@@ -403,6 +412,10 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
 		*numerator = 2;
 		*denominator = 1;
 		return 0;
+	case SOC_MBUS_PACKING_2X10_PADHI:
+		*numerator = 3;
+		*denominator = 1;
+		return 0;
 	case SOC_MBUS_PACKING_1_5X8:
 		*numerator = 3;
 		*denominator = 2;
@@ -428,6 +441,8 @@ s32 soc_mbus_bytes_per_line(u32 width, const struct soc_mbus_pixelfmt *mf)
 	case SOC_MBUS_PACKING_2X8_PADLO:
 	case SOC_MBUS_PACKING_EXTEND16:
 		return width * 2;
+	case SOC_MBUS_PACKING_2X10_PADHI:
+		return width * 3;
 	case SOC_MBUS_PACKING_1_5X8:
 		return width * 3 / 2;
 	case SOC_MBUS_PACKING_VARIABLE:
diff --git a/include/media/soc_mediabus.h b/include/media/soc_mediabus.h
index d33f6d0..b131a47 100644
--- a/include/media/soc_mediabus.h
+++ b/include/media/soc_mediabus.h
@@ -21,6 +21,8 @@
  * @SOC_MBUS_PACKING_2X8_PADHI:	16 bits transferred in 2 8-bit samples, in the
  *				possibly incomplete byte high bits are padding
  * @SOC_MBUS_PACKING_2X8_PADLO:	as above, but low bits are padding
+ * @SOC_MBUS_PACKING_2X10_PADHI:20 bits transferred in 2 10-bit samples. The
+ *				high bits are padding
  * @SOC_MBUS_PACKING_EXTEND16:	sample width (e.g., 10 bits) has to be extended
  *				to 16 bits
  * @SOC_MBUS_PACKING_VARIABLE:	compressed formats with variable packing
@@ -33,6 +35,7 @@ enum soc_mbus_packing {
 	SOC_MBUS_PACKING_NONE,
 	SOC_MBUS_PACKING_2X8_PADHI,
 	SOC_MBUS_PACKING_2X8_PADLO,
+	SOC_MBUS_PACKING_2X10_PADHI,
 	SOC_MBUS_PACKING_EXTEND16,
 	SOC_MBUS_PACKING_VARIABLE,
 	SOC_MBUS_PACKING_1_5X8,
-- 
1.7.5.4

