Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54675 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbeEUR2B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:28:01 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 4/4] ARM: dts: rcar-gen2: Remove unused VIN properties
Date: Mon, 21 May 2018 19:27:43 +0200
Message-Id: <1526923663-8179-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
driver and only confuse users. Remove them in all Gen2 SoC that use
them.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/arm/boot/dts/r8a7790-lager.dts   | 3 ---
 arch/arm/boot/dts/r8a7791-koelsch.dts | 3 ---
 arch/arm/boot/dts/r8a7791-porter.dts  | 1 -
 arch/arm/boot/dts/r8a7793-gose.dts    | 3 ---
 arch/arm/boot/dts/r8a7794-alt.dts     | 1 -
 arch/arm/boot/dts/r8a7794-silk.dts    | 1 -
 6 files changed, 12 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 092610e..9cdabfcf 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -885,10 +885,8 @@
 	port {
 		vin0ep2: endpoint {
 			remote-endpoint = <&adv7612_out>;
-			bus-width = <24>;
 			hsync-active = <0>;
 			vsync-active = <0>;
-			pclk-sample = <1>;
 			data-active = <1>;
 		};
 	};
@@ -904,7 +902,6 @@
 	port {
 		vin1ep0: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 8ab793d..033c9e3 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -857,10 +857,8 @@
 	port {
 		vin0ep2: endpoint {
 			remote-endpoint = <&adv7612_out>;
-			bus-width = <24>;
 			hsync-active = <0>;
 			vsync-active = <0>;
-			pclk-sample = <1>;
 			data-active = <1>;
 		};
 	};
@@ -875,7 +873,6 @@
 	port {
 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index a01101b..c16e870 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -388,7 +388,6 @@
 	port {
 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index aa209f6..60aaddb 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -765,10 +765,8 @@
 	port {
 		vin0ep2: endpoint {
 			remote-endpoint = <&adv7612_out>;
-			bus-width = <24>;
 			hsync-active = <0>;
 			vsync-active = <0>;
-			pclk-sample = <1>;
 			data-active = <1>;
 		};
 	};
@@ -784,7 +782,6 @@
 	port {
 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180_out>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
index e170275..8ed7a71 100644
--- a/arch/arm/boot/dts/r8a7794-alt.dts
+++ b/arch/arm/boot/dts/r8a7794-alt.dts
@@ -388,7 +388,6 @@
 	port {
 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
index 7808aae..6adfcd6 100644
--- a/arch/arm/boot/dts/r8a7794-silk.dts
+++ b/arch/arm/boot/dts/r8a7794-silk.dts
@@ -477,7 +477,6 @@
 	port {
 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
-- 
2.7.4
