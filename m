Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34714 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbcFNWvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:17 -0400
Received: by mail-pf0-f194.google.com with SMTP id 66so306166pfy.1
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:17 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 17/38] ARM: dts: imx6qdl: Flesh out MIPI CSI2 receiver node
Date: Tue, 14 Jun 2016 15:49:13 -0700
Message-Id: <1465944574-15745-18-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add to the MIPI CSI2 receiver node: compatible string, interrupt sources,
clocks.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index ed613eb..50499eb 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1119,7 +1119,14 @@
 			};
 
 			mipi_csi: mipi@021dc000 {
+				compatible = "fsl,imx-mipi-csi2";
 				reg = <0x021dc000 0x4000>;
+				interrupts = <0 100 0x04>, <0 101 0x04>;
+				clocks = <&clks IMX6QDL_CLK_HSI_TX>,
+					 <&clks IMX6QDL_CLK_VIDEO_27M>,
+					 <&clks IMX6QDL_CLK_EIM_SEL>;
+				clock-names = "dphy_clk", "cfg_clk", "pix_clk";
+				status = "disabled";
 			};
 
 			mipi_dsi: mipi@021e0000 {
-- 
1.9.1

