Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:34317 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaFGV5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jun 2014 17:57:33 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so3913365pbb.17
        for <linux-media@vger.kernel.org>; Sat, 07 Jun 2014 14:57:33 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 31/43] ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
Date: Sat,  7 Jun 2014 14:56:33 -0700
Message-Id: <1402178205-22697-32-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add mode device info to the MIPI CSI2 receiver node: compatible string,
interrupt sources, clocks.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index d793cd6..00130a8 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1011,8 +1011,13 @@
 				status = "disabled";
 			};
 
-			mipi_csi: mipi@021dc000 {
+			mipi_csi2: mipi@021dc000 {
+				compatible = "fsl,imx6-mipi-csi2";
 				reg = <0x021dc000 0x4000>;
+				interrupts = <0 100 0x04>, <0 101 0x04>;
+				clocks = <&clks 138>, <&clks 208>;
+				clock-names = "dphy_clk", "cfg_clk";
+				status = "disabled";
 			};
 
 			mipi_dsi: mipi@021e0000 {
-- 
1.7.9.5

