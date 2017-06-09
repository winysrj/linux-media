Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751545AbdFIRPx (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 13:15:53 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: geert@glider.be, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH] media: fdp1: Support ES2 platforms
Date: Fri,  9 Jun 2017 18:15:48 +0100
Message-Id: <1497028548-24443-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The new Renesas R-Car H3 ES2.0 platforms have an updated hw version register.
Update the driver accordingly.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar_fdp1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 42f25d241edd..50b59995b817 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -260,6 +260,7 @@ MODULE_PARM_DESC(debug, "activate debug info");
 #define FD1_IP_INTDATA			0x0800
 #define FD1_IP_H3			0x02010101
 #define FD1_IP_M3W			0x02010202
+#define FD1_IP_H3_ES2			0x02010203
 
 /* LUTs */
 #define FD1_LUT_DIF_ADJ			0x1000
@@ -2365,6 +2366,9 @@ static int fdp1_probe(struct platform_device *pdev)
 	case FD1_IP_M3W:
 		dprintk(fdp1, "FDP1 Version R-Car M3-W\n");
 		break;
+	case FD1_IP_H3_ES2:
+		dprintk(fdp1, "FDP1 Version R-Car H3-ES2\n");
+		break;
 	default:
 		dev_err(fdp1->dev, "FDP1 Unidentifiable (0x%08x)\n",
 				hw_version);
-- 
2.7.4
