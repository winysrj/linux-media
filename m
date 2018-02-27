Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:47067 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753616AbeB0PlD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:41:03 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: mchehab@s-opensource.com, laurent.pinchart@ideasonboard.com,
        hans.verkuil@cisco.com, g.liakhovetski@gmx.de, bhumirks@gmail.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 10/13] media: ov772x: Re-organize in-code comments
Date: Tue, 27 Feb 2018 16:40:27 +0100
Message-Id: <1519746030-15407-11-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519746030-15407-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A lot of comments that would fit a single line were spread on two or
more lines. Also fix capitalization and punctuation where appropriate.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index a418455..8849da1 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -910,17 +910,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	int ret;
 	u8  val;
 
-	/*
-	 * reset hardware
-	 */
+	/* Reset hardware. */
 	ov772x_reset(client);
 
-	/*
-	 * Edge Ctrl
-	 */
+	/* Edge Ctrl. */
 	if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
 		/*
-		 * Manual Edge Control Mode
+		 * Manual Edge Control Mode.
 		 *
 		 * Edge auto strength bit is set by default.
 		 * Remove it when manual mode.
@@ -944,9 +940,9 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 
 	} else if (priv->info->edgectrl.upper > priv->info->edgectrl.lower) {
 		/*
-		 * Auto Edge Control Mode
+		 * Auto Edge Control Mode.
 		 *
-		 * set upper and lower limit
+		 * Set upper and lower limit.
 		 */
 		ret = ov772x_mask_set(client,
 				      EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
@@ -961,7 +957,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			goto ov772x_set_fmt_error;
 	}
 
-	/* Format and window size */
+	/* Format and window size. */
 	ret = ov772x_write(client, HSTART, win->rect.left >> 2);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
@@ -993,9 +989,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
-	/*
-	 * set DSP_CTRL3
-	 */
+	/* Set DSP_CTRL3. */
 	val = cfmt->dsp3;
 	if (val) {
 		ret = ov772x_mask_set(client,
@@ -1011,9 +1005,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			goto ov772x_set_fmt_error;
 	}
 
-	/*
-	 * set COM3
-	 */
+	/* Set COM3. */
 	val = cfmt->com3;
 	if (priv->info->flags & OV772X_FLAG_VFLIP)
 		val |= VFLIP_IMG;
@@ -1041,9 +1033,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
-	/*
-	 * set COM8
-	 */
+	/* Set COM8. */
 	if (priv->band_filter) {
 		ret = ov772x_mask_set(client, COM8, BNDF_ON_OFF, 1);
 		if (!ret)
@@ -1153,9 +1143,7 @@ static int ov772x_video_probe(struct ov772x_priv *priv)
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * check and show product ID and manufacturer ID
-	 */
+	/* Check and show product ID and manufacturer ID. */
 	pid = ov772x_read(client, PID);
 	ver = ov772x_read(client, VER);
 
-- 
2.7.4
