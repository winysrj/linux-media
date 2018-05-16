Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:36009 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751879AbeEPQcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:55 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 6/6] ARM: dts: rcar-gen2: Add 'data-active' property
Date: Wed, 16 May 2018 18:32:32 +0200
Message-Id: <1526488352-898-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The 'data-active' property needs to be specified when using embedded
synchronization. Add it to the Gen-2 boards using composite video input.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/arm/boot/dts/r8a7790-lager.dts   | 1 +
 arch/arm/boot/dts/r8a7791-koelsch.dts | 1 +
 arch/arm/boot/dts/r8a7791-porter.dts  | 1 +
 arch/arm/boot/dts/r8a7793-gose.dts    | 1 +
 arch/arm/boot/dts/r8a7794-alt.dts     | 1 +
 arch/arm/boot/dts/r8a7794-silk.dts    | 1 +
 6 files changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index b56b309..48fcb44 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -893,6 +893,7 @@

 		vin1ep0: endpoint {
 			remote-endpoint = <&adv7180>;
+			data-active = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-koelsch.dts b/arch/arm/boot/dts/r8a7791-koelsch.dts
index 9967666..fa0b25f 100644
--- a/arch/arm/boot/dts/r8a7791-koelsch.dts
+++ b/arch/arm/boot/dts/r8a7791-koelsch.dts
@@ -868,6 +868,7 @@

 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180>;
+			data-active = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7791-porter.dts b/arch/arm/boot/dts/r8a7791-porter.dts
index 055a7f1..96b9605 100644
--- a/arch/arm/boot/dts/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/r8a7791-porter.dts
@@ -391,6 +391,7 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
+			data-active = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7793-gose.dts b/arch/arm/boot/dts/r8a7793-gose.dts
index 9d3fba2..80b4fa8 100644
--- a/arch/arm/boot/dts/r8a7793-gose.dts
+++ b/arch/arm/boot/dts/r8a7793-gose.dts
@@ -779,6 +779,7 @@

 		vin1ep: endpoint {
 			remote-endpoint = <&adv7180_out>;
+			data-active = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-alt.dts b/arch/arm/boot/dts/r8a7794-alt.dts
index 4bbb9cc..00df605d 100644
--- a/arch/arm/boot/dts/r8a7794-alt.dts
+++ b/arch/arm/boot/dts/r8a7794-alt.dts
@@ -380,6 +380,7 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
+			data-active = <1>;
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/r8a7794-silk.dts b/arch/arm/boot/dts/r8a7794-silk.dts
index c0c5d31..ed17376 100644
--- a/arch/arm/boot/dts/r8a7794-silk.dts
+++ b/arch/arm/boot/dts/r8a7794-silk.dts
@@ -480,6 +480,7 @@

 		vin0ep: endpoint {
 			remote-endpoint = <&adv7180>;
+			data-active = <1>;
 		};
 	};
 };
--
2.7.4
