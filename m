Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:42631 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeEPQcx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:53 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 5/6] ARM: dts: rcar-gen2: Remove unused VIN properties
Date: Wed, 16 May 2018 18:32:31 +0200
Message-Id: <1526488352-898-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
driver and only confuse users. Remove them in all Gen2 SoC that used
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
index 063fdb6..b56b309 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -873,10 +873,8 @@
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
@@ -895,7 +893,6 @@

 		vin1ep0: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index f40321a..9967666 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -849,10 +849,8 @@

 		vin0ep2: endpoint {
 			remote-endpoint = <&adv7612_out>;
-			bus-width = <24>;
 			hsync-active = <0>;
 			vsync-active = <0>;
-			pclk-sample = <1>;
 			data-active = <1>;
 		};
 	};
@@ -870,7 +868,6 @@

 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index c14e6fe..055a7f1 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -391,7 +391,6 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 9ed6961..9d3fba2 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -759,10 +759,8 @@

 		vin0ep2: endpoint {
 			remote-endpoint = <&adv7612_out>;
-			bus-width = <24>;
 			hsync-active = <0>;
 			vsync-active = <0>;
-			pclk-sample = <1>;
 			data-active = <1>;
 		};
 	};
@@ -781,7 +779,6 @@

 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180_out>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
index 26a8834..4bbb9cc 100644
--- a/arch/arm/boot/dts/r8a7794-alt.dts
+++ b/arch/arm/boot/dts/r8a7794-alt.dts
@@ -380,7 +380,6 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
index 351cb3b..c0c5d31 100644
--- a/arch/arm/boot/dts/r8a7794-silk.dts
+++ b/arch/arm/boot/dts/r8a7794-silk.dts
@@ -480,7 +480,6 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
-			bus-width = <8>;
 		};
 	};
 };
--
2.7.4
