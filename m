Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C9AC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D95E420850
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D95E420850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbeLEJ0U (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:26:20 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39827 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbeLEJZ0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:26 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 20ACA207BF; Wed,  5 Dec 2018 10:25:24 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 9185D20828;
        Wed,  5 Dec 2018 10:25:05 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 08/15] ARM/arm64: sunxi: Move H3/H5 syscon label over to soc-specific nodes
Date:   Wed,  5 Dec 2018 10:24:37 +0100
Message-Id: <20181205092444.29497-9-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The EMAC driver requires a syscon node to access the EMAC clock
configuration register (that is part of the system-control register
range and controlled). For this purpose, a dummy syscon node was
introduced to let the driver access the register freely.

Recently, the EMAC driver was tuned to get access to the register when
the SRAM driver is registered (as used on the A64). As a result, it is
no longer necessary to have a dummy syscon node for that purpose.

Now that we have a proper system-control node for both the H3 and H5,
we can get rid of that dummy syscon node and have the EMAC driver use
the node corresponding to the proper SRAM driver (by switching the
syscon label over to each dtsi). This way, we no longer have two
separate nodes for the same register space.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi              | 2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi           | 6 ------
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e438e54580e1..a858d91dd4c6 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -120,7 +120,7 @@
 	};
 
 	soc {
-		system-control@1c00000 {
+		syscon: system-control@1c00000 {
 			compatible = "allwinner,sun8i-h3-system-control";
 			reg = <0x01c00000 0x1000>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index 0d9e9eac518c..ed5846982685 100644
--- a/arch/arm/boot/dts/sunxi-h3-h5.dtsi
+++ b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
@@ -152,12 +152,6 @@
 			};
 		};
 
-		syscon: syscon@1c00000 {
-			compatible = "allwinner,sun8i-h3-system-controller",
-				"syscon";
-			reg = <0x01c00000 0x1000>;
-		};
-
 		dma: dma-controller@1c02000 {
 			compatible = "allwinner,sun8i-h3-dma";
 			reg = <0x01c02000 0x1000>;
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index 42bfb560b367..4e9025431e9f 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -94,7 +94,7 @@
 	};
 
 	soc {
-		system-control@1c00000 {
+		syscon: system-control@1c00000 {
 			compatible = "allwinner,sun50i-h5-system-control";
 			reg = <0x01c00000 0x1000>;
 			#address-cells = <1>;
-- 
2.19.2

