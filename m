Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B397FC10F03
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:58:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B0F92064C
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfCSP4J (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:56:09 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:34529 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbfCSP4H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 11:56:07 -0400
Received: from localhost (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id CA59B100021;
        Tue, 19 Mar 2019 15:56:03 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v4 4/5] ARM: dts: sun7i: Add CSI0 controller
Date:   Tue, 19 Mar 2019 16:55:47 +0100
Message-Id: <b5ea807a2ebc218834133c392de0558137b43a75.1553010938.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.2aba8cbd95630d87f927465cc2beb881936c83d9.1553010938.git-series.maxime.ripard@bootlin.com>
References: <cover.2aba8cbd95630d87f927465cc2beb881936c83d9.1553010938.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The CSI controller embedded in the A20 can be supported by our new driver.
Let's add it to our DT.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 641a8fa6d428..0eade0805fb0 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -376,6 +376,17 @@
 			num-cs = <1>;
 		};
 
+		csi0: csi@1c09000 {
+			compatible = "allwinner,sun7i-a20-csi0",
+				     "allwinner,sun4i-a10-csi0";
+			reg = <0x01c09000 0x1000>;
+			interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_AHB_CSI0>, <&ccu CLK_CSI0>,
+				 <&ccu CLK_CSI_SCLK>, <&ccu CLK_DRAM_CSI0>;
+			clock-names = "bus", "mod", "isp", "ram";
+			resets = <&ccu RST_CSI0>;
+		};
+
 		emac: ethernet@1c0b000 {
 			compatible = "allwinner,sun4i-a10-emac";
 			reg = <0x01c0b000 0x1000>;
-- 
git-series 0.9.1
