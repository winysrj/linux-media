Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:54167 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:47 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 5/6] media: rcar-vin: Handle data-enable polarity
Date: Tue, 12 Jun 2018 16:26:05 +0200
Message-Id: <1528813566-17927-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Handle data-enable signal polarity. If the polarity is not specifically
requested to be active low, use the active high default.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index d2b7002..9145b56 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -123,6 +123,7 @@
 /* Video n Data Mode Register 2 bits */
 #define VNDMR2_VPS		(1 << 30)
 #define VNDMR2_HPS		(1 << 29)
+#define VNDMR2_CES		(1 << 28)
 #define VNDMR2_FTEV		(1 << 17)
 #define VNDMR2_VLV(n)		((n & 0xf) << 12)
 
@@ -698,6 +699,10 @@ static int rvin_setup(struct rvin_dev *vin)
 		/* Vsync Signal Polarity Select */
 		if (!(vin->parallel->mbus_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW))
 			dmr2 |= VNDMR2_VPS;
+
+		/* Data Enable Polarity Select */
+		if (vin->parallel->mbus_flags & V4L2_MBUS_DATA_ENABLE_LOW)
+			dmr2 |= VNDMR2_CES;
 	}
 
 	/*
-- 
2.7.4
