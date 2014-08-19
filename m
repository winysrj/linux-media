Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40745 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaHSMxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Aug 2014 08:53:08 -0400
Received: by mail-lb0-f179.google.com with SMTP id v6so5397396lbi.10
        for <linux-media@vger.kernel.org>; Tue, 19 Aug 2014 05:53:07 -0700 (PDT)
From: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
To: m.chehab@samsung.com, horms@verge.net.au, magnus.damm@gmail.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com
Cc: laurent.pinchart@ideasonboard.com, linux-sh@vger.kernel.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
Subject: [PATCH 4/6] ARM: shmobile: r8a7791: Add JPU clock dt and CPG define.
Date: Tue, 19 Aug 2014 16:50:51 +0400
Message-Id: <1408452653-14067-5-git-send-email-mikhail.ulyanov@cogentembedded.com>
In-Reply-To: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
References: <1408452653-14067-1-git-send-email-mikhail.ulyanov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>
---
 arch/arm/boot/dts/r8a7791.dtsi            | 6 +++---
 include/dt-bindings/clock/r8a7791-clock.h | 1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index 152c75c..c2d0c6e 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -889,16 +889,16 @@
 		mstp1_clks: mstp1_clks@e6150134 {
 			compatible = "renesas,r8a7791-mstp-clocks", "renesas,cpg-mstp-clocks";
 			reg = <0 0xe6150134 0 4>, <0 0xe6150038 0 4>;
-			clocks = <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
+			clocks = <&m2_clk>, <&p_clk>, <&p_clk>, <&p_clk>, <&rclk_clk>,
 				 <&cp_clk>, <&zs_clk>, <&zs_clk>, <&zs_clk>;
 			#clock-cells = <1>;
 			renesas,clock-indices = <
-				R8A7791_CLK_TMU1 R8A7791_CLK_TMU3 R8A7791_CLK_TMU2
+				R8A7791_CLK_JPU R8A7791_CLK_TMU1 R8A7791_CLK_TMU3 R8A7791_CLK_TMU2
 				R8A7791_CLK_CMT0 R8A7791_CLK_TMU0 R8A7791_CLK_VSP1_DU1
 				R8A7791_CLK_VSP1_DU0 R8A7791_CLK_VSP1_S
 			>;
 			clock-output-names =
-				"tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
+				"jpu", "tmu1", "tmu3", "tmu2", "cmt0", "tmu0", "vsp1-du1",
 				"vsp1-du0", "vsp1-sy";
 		};
 		mstp2_clks: mstp2_clks@e6150138 {
diff --git a/include/dt-bindings/clock/r8a7791-clock.h b/include/dt-bindings/clock/r8a7791-clock.h
index f0d4d10..58c3f49 100644
--- a/include/dt-bindings/clock/r8a7791-clock.h
+++ b/include/dt-bindings/clock/r8a7791-clock.h
@@ -25,6 +25,7 @@
 #define R8A7791_CLK_MSIOF0		0
 
 /* MSTP1 */
+#define R8A7791_CLK_JPU		6
 #define R8A7791_CLK_TMU1		11
 #define R8A7791_CLK_TMU3		21
 #define R8A7791_CLK_TMU2		22
-- 
2.1.0.rc1

