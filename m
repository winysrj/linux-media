Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3LKQHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 6/7] v4l: atmel-isi: Fix color component ordering
Date: Wed, 11 Dec 2013 17:07:44 +0100
Message-Id: <1386778065-14135-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISI_CFG2.YCC_SWAP field controls color component ordering. The
datasheet lists the following orderings for the memory formats.

YCC_SWAP	Byte 0	Byte 1	Byte 2	Byte 3
00: Default	Cb(i)	Y(i)	Cr(i)	Y(i+1)
01: Mode1	Cr(i)	Y(i)	Cb(i)	Y(i+1)
10: Mode2	Y(i)	Cb(i)	Y(i+1)	Cr(i)
11: Mode3	Y(i)	Cr(i)	Y(i+1)	Cb(i)

This is based on a sensor format set to CbYCrY (UYVY). The driver
hardcodes the output memory format to YUYV, configure the ordering
accordingly.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Josh Wu <josh.wu@atmel.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 3e8d412..9c4cadc 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -112,16 +112,16 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 	case V4L2_MBUS_FMT_Y8_1X8:
 		cr = ISI_CFG2_GRAYSCALE;
 		break;
-	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_3;
 		break;
-	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_2;
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_MODE_1;
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 		cr = ISI_CFG2_YCC_SWAP_DEFAULT;
 		break;
 	/* RGB, TODO */
-- 
1.8.3.2

