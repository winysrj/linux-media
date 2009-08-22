Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:36980 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166AbZHVGsu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Aug 2009 02:48:50 -0400
Received: by bwz19 with SMTP id 19so755856bwz.37
        for <linux-media@vger.kernel.org>; Fri, 21 Aug 2009 23:48:50 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 1/3] Add RGB555X and RGB565X formats to pxa-camera
Date: Sat, 22 Aug 2009 08:48:26 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <200908220848.26702.marek.vasut@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 287b146839e3f96b34336f40e1ab7b154cd58a64 Mon Sep 17 00:00:00 2001
From: Marek Vasut <marek.vasut@gmail.com>
Date: Sat, 22 Aug 2009 05:13:22 +0200
Subject: [PATCH 1/3] Add RGB555X and RGB565X formats to pxa-camera

Those formats are requiered on widely used OmniVision OV96xx cameras.
Those formats are nothing more then endian-swapped RGB555 and RGB565.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/media/video/pxa_camera.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c 
b/drivers/media/video/pxa_camera.c
index 7c86ef9..ef5d293 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1110,10 +1110,12 @@ static void pxa_camera_setup_cicr(struct 
soc_camera_device *icd,
 		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	case V4L2_PIX_FMT_RGB555:
+	case V4L2_PIX_FMT_RGB555X:
 		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
 			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
 		break;
 	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_RGB565X:
 		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
 		break;
 	}
@@ -1240,6 +1242,8 @@ static int required_buswidth(const struct 
soc_camera_data_format *fmt)
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB555:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB555X:
 		return 8;
 	default:
 		return fmt->depth;
@@ -1289,6 +1293,8 @@ static int pxa_camera_get_formats(struct 
soc_camera_device *icd, int idx,
 	case V4L2_PIX_FMT_YVYU:
 	case V4L2_PIX_FMT_RGB565:
 	case V4L2_PIX_FMT_RGB555:
+	case V4L2_PIX_FMT_RGB565X:
+	case V4L2_PIX_FMT_RGB555X:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt = icd->formats + idx;
-- 
1.6.3.3
