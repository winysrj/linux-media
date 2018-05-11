Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:36603 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbeEKJ7z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 05:59:55 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 5/5] media: rcar-vin: Use FTEV for digital input
Date: Fri, 11 May 2018 11:59:41 +0200
Message-Id: <1526032781-14319-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since commit (015060cb "media: rcar-vin: enable field toggle after a set
number of lines for Gen3) the VIN generates an internal field signal
toggle after a fixed number of received lines, and uses the internal
field signal to drive capture operations. When capturing from digital
input, using FTEH driven field signal toggling messes up the received
image sizes. Fall back to use FTEV driven signal toggling when capturing
from digital input.

As explained in the comment, this disables buffer overflow protection
for digital input capture, for which the FOE overflow might be used in
future.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ea7a120..8dc3455 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -685,11 +685,27 @@ static int rvin_setup(struct rvin_dev *vin)
 		break;
 	}
 
-	if (vin->info->model == RCAR_GEN3) {
+	if (vin->info->model == RCAR_GEN3 &&
+	    vin->mbus_cfg.type == V4L2_MBUS_CSI2) {
 		/* Enable HSYNC Field Toggle mode after height HSYNC inputs. */
 		lines = vin->format.height / (halfsize ? 2 : 1);
 		dmr2 = VNDMR2_FTEH | VNDMR2_HLV(lines);
 		vin_dbg(vin, "Field Toogle after %u lines\n", lines);
+	} else if (vin->info->model == RCAR_GEN3 &&
+		   vin->mbus_cfg.type == V4L2_MBUS_PARALLEL) {
+		/*
+		 * FIXME
+		 * Section 26.3.17 specifies that for digital input there's no
+		 * need to program FTEH or FTEV to generate internal
+		 * field toggle signal to driver capture. Although when
+		 * running on GEN3 with digital input no EFE interrupt is ever
+		 * generated, and we need to rely on FTEV driven field signal
+		 * toggling, as using FTEH as in the CSI-2 case, messes up
+		 * the output image size. This implies no protection
+		 * against buffer overflow is in place for Gen3 digital input
+		 * capture.
+		 */
+		dmr2 = VNDMR2_FTEV;
 	} else {
 		/* Enable VSYNC Field Toogle mode after one VSYNC input. */
 		dmr2 = VNDMR2_FTEV | VNDMR2_VLV(1);
-- 
2.7.4
