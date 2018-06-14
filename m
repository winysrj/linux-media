Return-path: <linux-media-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:35220 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755084AbeFNPSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 11:18:32 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH/RFC 2/2] arm64: dts: renesas: salvator-common: Fix adv7482 decimal unit addresses
Date: Thu, 14 Jun 2018 15:48:08 +0200
Message-Id: <1528984088-24801-3-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
References: <1528984088-24801-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With recent dtc and W=1:

    ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@10: graph node unit address error, expected "a"
    ...salvator-x.dtb: Warning (graph_port): /soc/i2c@e66d8000/video-receiver@70/port@11: graph node unit address error, expected "b"

Unit addresses are always hexadecimal (without prefix), while the bases
of reg property values depend on their prefixes.

Fixes: 908001d778eba06e ("arm64: dts: renesas: salvator-common: Add ADV7482 support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/arm64/boot/dts/renesas/salvator-common.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/salvator-common.dtsi b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
index 320250d708c3bbab..47088206cc052a15 100644
--- a/arch/arm64/boot/dts/renesas/salvator-common.dtsi
+++ b/arch/arm64/boot/dts/renesas/salvator-common.dtsi
@@ -437,7 +437,7 @@
 			};
 		};
 
-		port@10 {
+		port@a {
 			reg = <10>;
 
 			adv7482_txa: endpoint {
@@ -447,7 +447,7 @@
 			};
 		};
 
-		port@11 {
+		port@b {
 			reg = <11>;
 
 			adv7482_txb: endpoint {
-- 
2.7.4
