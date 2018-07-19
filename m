Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37431 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732167AbeGSQOf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jul 2018 12:14:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v2 10/16] gpu: ipu-v3: image-convert: relax tile width alignment for NV12 and NV16
Date: Thu, 19 Jul 2018 17:30:36 +0200
Message-Id: <20180719153042.533-11-p.zabel@pengutronix.de>
In-Reply-To: <20180719153042.533-1-p.zabel@pengutronix.de>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the planar but U/V-packed formats NV12 and NV16, 8 pixel width
alignment is good enough to fulfill the 8 byte stride requirement.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 69cc307f932d..1a8fc29e278f 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -544,7 +544,7 @@ static inline u32 tile_top_align(const struct ipu_image_pixfmt *fmt)
  */
 static inline u32 tile_width_align(const struct ipu_image_pixfmt *fmt)
 {
-	return fmt->planar ? 8 * fmt->uv_width_dec : 8;
+	return (fmt->planar && !fmt->uv_packed) ? 8 * fmt->uv_width_dec : 8;
 }
 
 /*
-- 
2.18.0
