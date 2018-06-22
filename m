Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52415 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934048AbeFVPwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Jun 2018 11:52:22 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH 14/16] gpu: ipu-v3: image-convert: add some ASCII art to the exposition
Date: Fri, 22 Jun 2018 17:52:15 +0200
Message-Id: <20180622155217.29302-15-p.zabel@pengutronix.de>
In-Reply-To: <20180622155217.29302-1-p.zabel@pengutronix.de>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Visualize the scaling and rotation pipeline with some ASCII art
diagrams. Remove the FIXME comment about missing seam prevention.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/gpu/ipu-v3/ipu-image-convert.c | 39 +++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 43eaa512e8c2..c6050cf12885 100644
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
2.17.1
