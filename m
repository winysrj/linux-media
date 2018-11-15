Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42950 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388571AbeKPA66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 19:58:58 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 08/15] ARM/arm64: sunxi: Move H3/H5 syscon label over to soc-specific nodes
Date: Thu, 15 Nov 2018 15:50:06 +0100
Message-Id: <20181115145013.3378-9-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that we have specific nodes for the H3 and H5 system-controller
that allow proper access to the EMAC clock configuration register,
we no longer need a common dummy syscon node.

Switch the syscon label over to each platform's dtsi file.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi              | 2 +-
 arch/arm/boot/dts/sunxi-h3-h5.dtsi           | 6 ------
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index 7157d954fb8c..b337a9282783 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -134,7 +134,7 @@
 	};
 
 	soc {
-		system-control@1c00000 {
+		syscon: system-control@1c00000 {
 			compatible = "allwinner,sun8i-h3-system-control";
 			reg = <0x01c00000 0x1000>;
 			#address-cells = <1>;
diff --git a/arch/arm/boot/dts/sunxi-h3-h5.dtsi b/arch/arm/boot/dts/sunxi-h3-h5.dtsi
index 4b1530ebe427..9175ff0fb59a 100644
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
index c2d14b22b8c1..4f0e2df875ba 100644
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
2.19.1
