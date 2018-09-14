Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:57126 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728218AbeINH0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 03:26:36 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/3] rcar-vin: align format width with hardware limits
Date: Fri, 14 Sep 2018 04:13:43 +0200
Message-Id: <20180914021345.9277-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180914021345.9277-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Gen3 datasheets lists specific alignment restrictions compared to
Gen2. This was overlooked when adding Gen3 support as no problematic
configuration was encountered. However when adding support for Gen3 Up
Down Scaler (UDS) strange issues could be observed for odd widths
without taking this limit into consideration.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index dc77682b47857c97..2fc2a05eaeacb134 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -673,6 +673,21 @@ static void rvin_mc_try_format(struct rvin_dev *vin,
 	pix->quantization = V4L2_MAP_QUANTIZATION_DEFAULT(true, pix->colorspace,
 							  pix->ycbcr_enc);
 
+	switch (vin->format.pixelformat) {
+	case V4L2_PIX_FMT_NV16:
+		pix->width = ALIGN(pix->width, 0x80);
+		break;
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
+	case V4L2_PIX_FMT_RGB565:
+	case V4L2_PIX_FMT_XRGB555:
+		pix->width = ALIGN(pix->width, 0x40);
+		break;
+	default:
+		pix->width = ALIGN(pix->width, 0x20);
+		break;
+	}
+
 	rvin_format_align(vin, pix);
 }
 
-- 
2.18.0
