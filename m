Return-Path: <SRS0=iic/=PR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D82DC43612
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16EF620883
	for <linux-media@archiver.kernel.org>; Wed,  9 Jan 2019 09:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbfAIJdq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 04:33:46 -0500
Received: from mail.bootlin.com ([62.4.15.54]:37296 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729826AbfAIJdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Jan 2019 04:33:45 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 0605420A2D; Wed,  9 Jan 2019 10:33:44 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id C51DB20A32;
        Wed,  9 Jan 2019 10:33:31 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4 7/9] dt-bindings: phy: Move the Cadence D-PHY bindings
Date:   Wed,  9 Jan 2019 10:33:24 +0100
Message-Id: <0c38b838f08b741b5b24a65886134104c5bdc69a.1547026369.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Cadence D-PHY bindings was defined as part of the DSI block so far.
However, since it's now going to be a separate driver, we need to move the
binding to a file of its own.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt | 21 +-------
 Documentation/devicetree/bindings/phy/cdns,dphy.txt           | 20 +++++++-
 2 files changed, 20 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/phy/cdns,dphy.txt

diff --git a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
index f5725bb6c61c..525a4bfd8634 100644
--- a/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
+++ b/Documentation/devicetree/bindings/display/bridge/cdns,dsi.txt
@@ -31,28 +31,7 @@ Required subnodes:
 - one subnode per DSI device connected on the DSI bus. Each DSI device should
   contain a reg property encoding its virtual channel.
 
-Cadence DPHY
-============
-
-Cadence DPHY block.
-
-Required properties:
-- compatible: should be set to "cdns,dphy".
-- reg: physical base address and length of the DPHY registers.
-- clocks: DPHY reference clocks.
-- clock-names: must contain "psm" and "pll_ref".
-- #phy-cells: must be set to 0.
-
-
 Example:
-	dphy0: dphy@fd0e0000{
-		compatible = "cdns,dphy";
-		reg = <0x0 0xfd0e0000 0x0 0x1000>;
-		clocks = <&psm_clk>, <&pll_ref_clk>;
-		clock-names = "psm", "pll_ref";
-		#phy-cells = <0>;
-	};
-
 	dsi0: dsi@fd0c0000 {
 		compatible = "cdns,dsi";
 		reg = <0x0 0xfd0c0000 0x0 0x1000>;
diff --git a/Documentation/devicetree/bindings/phy/cdns,dphy.txt b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
new file mode 100644
index 000000000000..1095bc4e72d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/cdns,dphy.txt
@@ -0,0 +1,20 @@
+Cadence DPHY
+============
+
+Cadence DPHY block.
+
+Required properties:
+- compatible: should be set to "cdns,dphy".
+- reg: physical base address and length of the DPHY registers.
+- clocks: DPHY reference clocks.
+- clock-names: must contain "psm" and "pll_ref".
+- #phy-cells: must be set to 0.
+
+Example:
+	dphy0: dphy@fd0e0000{
+		compatible = "cdns,dphy";
+		reg = <0x0 0xfd0e0000 0x0 0x1000>;
+		clocks = <&psm_clk>, <&pll_ref_clk>;
+		clock-names = "psm", "pll_ref";
+		#phy-cells = <0>;
+	};
-- 
git-series 0.9.1
