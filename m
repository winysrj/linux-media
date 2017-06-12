Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752476AbdFLKaV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 06:30:21 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: geert@glider.be, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2] media: fdp1: Support ES2 platforms
Date: Mon, 12 Jun 2017 11:30:16 +0100
Message-Id: <1497263416-17930-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The new Renesas R-Car H3 ES2.0 platforms have a new hw version register.
Update the driver accordingly, defaulting to the new hw revision, and
differentiating the older revision as ES1

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 42f25d241edd..159786b052f3 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -258,8 +258,9 @@ MODULE_PARM_DESC(debug, "activate debug info");
 
 /* Internal Data (HW Version) */
 #define FD1_IP_INTDATA			0x0800
-#define FD1_IP_H3			0x02010101
+#define FD1_IP_H3_ES1			0x02010101
 #define FD1_IP_M3W			0x02010202
+#define FD1_IP_H3			0x02010203
 
 /* LUTs */
 #define FD1_LUT_DIF_ADJ			0x1000
@@ -2359,12 +2360,15 @@ static int fdp1_probe(struct platform_device *pdev)
 
 	hw_version = fdp1_read(fdp1, FD1_IP_INTDATA);
 	switch (hw_version) {
-	case FD1_IP_H3:
-		dprintk(fdp1, "FDP1 Version R-Car H3\n");
+	case FD1_IP_H3_ES1:
+		dprintk(fdp1, "FDP1 Version R-Car H3 ES1\n");
 		break;
 	case FD1_IP_M3W:
 		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
 		break;
+	case FD1_IP_H3:
+		dprintk(fdp1, "FDP1 Version R-Car H3\n");
+		break;
 	default:
 		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
 				hw_version);
-- 
2.7.4
