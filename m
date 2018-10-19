Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:60623 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbeJSUVg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 16:21:36 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tim Harvey <tharvey@gateworks.com>, kernel@pengutronix.de
Subject: [PATCH v4 20/22] gpu: ipu-v3: image-convert: add some ASCII art to the exposition
Date: Fri, 19 Oct 2018 14:15:37 +0200
Message-Id: <20181019121539.12778-21-p.zabel@pengutronix.de>
In-Reply-To: <20181019121539.12778-1-p.zabel@pengutronix.de>
References: <20181019121539.12778-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Visualize the scaling and rotation pipeline with some ASCII art
diagrams. Remove the FIXME comment about missing seam prevention.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
No changes since v3.
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 39 +++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index b735065fe288..91fe8f1672b4 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -37,17 +37,36 @@
  * when double_buffering boolean is set).
  *
  * Note that the input frame must be split up into the same number
- * of tiles as the output frame.
+ * of tiles as the output frame:
  *
- * FIXME: at this point there is no attempt to deal with visible seams
- * at the tile boundaries when upscaling. The seams are caused by a reset
- * of the bilinear upscale interpolation when starting a new tile. The
- * seams are barely visible for small upscale factors, but become
- * increasingly visible as the upscale factor gets larger, since more
- * interpolated pixels get thrown out at the tile boundaries. A possilble
- * fix might be to overlap tiles of different sizes, but this must be done
- * while also maintaining the IDMAC dma buffer address alignment and 8x8 IRT
- * alignment restrictions of each tile.
+ *                       +---------+-----+
+ *   +-----+---+         |  A      | B   |
+ *   | A   | B |         |         |     |
+ *   +-----+---+   -->   +---------+-----+
+ *   | C   | D |         |  C      | D   |
+ *   +-----+---+         |         |     |
+ *                       +---------+-----+
+ *
+ * Clockwise 90° rotations are handled by first rescaling into a
+ * reusable temporary tile buffer and then rotating with the 8x8
+ * block rotator, writing to the correct destination:
+ *
+ *                                         +-----+-----+
+ *                                         |     |     |
+ *   +-----+---+         +---------+       | C   | A   |
+ *   | A   | B |         | A,B, |  |       |     |     |
+ *   +-----+---+   -->   | C,D  |  |  -->  |     |     |
+ *   | C   | D |         +---------+       +-----+-----+
+ *   +-----+---+                           | D   | B   |
+ *                                         |     |     |
+ *                                         +-----+-----+
+ *
+ * If the 8x8 block rotator is used, horizontal or vertical flipping
+ * is done during the rotation step, otherwise flipping is done
+ * during the scaling step.
+ * With rotation or flipping, tile order changes between input and
+ * output image. Tiles are numbered row major from top left to bottom
+ * right for both input and output image.
  */
 
 #define MAX_STRIPES_W    4
-- 
2.19.0
