Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:38559 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeEPQcv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:51 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 4/6] media: rcar-vin: Handle CLOCKENB pin polarity
Date: Wed, 16 May 2018 18:32:30 +0200
Message-Id: <1526488352-898-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle CLOCKENB pin polarity, or use HSYNC in its place if polarity is
not specified.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index ac07f99..7a84eae 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -123,6 +123,8 @@
 /* Video n Data Mode Register 2 bits */
 #define VNDMR2_VPS		(1 << 30)
 #define VNDMR2_HPS		(1 << 29)
+#define VNDMR2_CES		(1 << 28)
+#define VNDMR2_CHS		(1 << 23)
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
 
@@ -691,6 +693,15 @@ static int rvin_setup(struct rvin_dev *vin)
 		dmr2 |= VNDMR2_VPS;
 
 	/*
+	 * Clock-enable active level select.
+	 * Use HSYNC as enable if not specified
+	 */
+	if (vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_LOW)
+		dmr2 |= VNDMR2_CES;
+	else if (!(vin->mbus_cfg.flags & V4L2_MBUS_DATA_ACTIVE_HIGH))
+		dmr2 |= VNDMR2_CHS;
+
+	/*
 	 * Output format
 	 */
 	switch (vin->format.pixelformat) {
-- 
2.7.4
