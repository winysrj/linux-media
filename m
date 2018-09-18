Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44445 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729583AbeIRPGZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:06:25 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Subject: [PATCH v3 16/16] gpu: ipu-v3: image-convert: allow three rows or columns
Date: Tue, 18 Sep 2018 11:34:21 +0200
Message-Id: <20180918093421.12930-17-p.zabel@pengutronix.de>
In-Reply-To: <20180918093421.12930-1-p.zabel@pengutronix.de>
References: <20180918093421.12930-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If width or height are in the [2049, 3072] range, allow to
use just three tiles in this dimension, instead of four.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
New since v2.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 6ab880416919..5bce03b73502 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -379,12 +379,7 @@ static int alloc_dma_buf(struct ipu_image_convert_priv *priv,
 
 static inline int num_stripes(int dim)
 {
-	if (dim <= 1024)
-		return 1;
-	else if (dim <= 2048)
-		return 2;
-	else
-		return 4;
+	return (dim - 1) / 1024 + 1;
 }
 
 /*
-- 
2.19.0
