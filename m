Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04649C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA64120837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 13:56:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CA64120837
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeLGN4G (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 08:56:06 -0500
Received: from mail.bootlin.com ([62.4.15.54]:58766 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbeLGN4F (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Dec 2018 08:56:05 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 829B220E2E; Fri,  7 Dec 2018 14:56:02 +0100 (CET)
Received: from localhost (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 6AF4120CEC;
        Fri,  7 Dec 2018 14:55:44 +0100 (CET)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>
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
Subject: [PATCH v3 08/10] dt-bindings: phy: Move the Cadence D-PHY bindings
Date:   Fri,  7 Dec 2018 14:55:35 +0100
Message-Id: <d548e7929e0efe73fe797202b98b7e554b4a4adc.1544190837.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
References: <cover.ad7c4feb3905658f10b022df4756a5ade280011f.1544190837.git-series.maxime.ripard@bootlin.com>
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
