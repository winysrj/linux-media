Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:47704 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755279AbdJQGM2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Oct 2017 02:12:28 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH][MEDIA] i.MX6: Fix MIPI CSI-2 LP-11 check
Date: Tue, 17 Oct 2017 08:12:25 +0200
Message-ID: <m3k1zul2uu.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bitmask for the MIPI CSI-2 data PHY status doesn't seem to be correct.
Fix it.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -252,8 +252,8 @@ static int csi2_dphy_wait_stopstate(struct csi2_dev *csi2)
 	u32 mask, reg;
 	int ret;
 
-	mask = PHY_STOPSTATECLK |
-		((csi2->bus.num_data_lanes - 1) << PHY_STOPSTATEDATA_BIT);
+	mask = PHY_STOPSTATECLK | (((1 << csi2->bus.num_data_lanes) - 1) <<
+				   PHY_STOPSTATEDATA_BIT);
 
 	ret = readl_poll_timeout(csi2->base + CSI2_PHY_STATE, reg,
 				 (reg & mask) == mask, 0, 500000);

-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
