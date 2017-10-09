Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33885 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754058AbdJIJEl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 05:04:41 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yakir Yang <ykk@rock-chips.com>
Subject: [PATCH v11 2/4] ARM: dts: rockchip: add RGA device node for RK3288
Date: Mon,  9 Oct 2017 17:04:22 +0800
Message-Id: <20171009090424.15292-3-jacob-chen@iotwrt.com>
In-Reply-To: <20171009090424.15292-1-jacob-chen@iotwrt.com>
References: <20171009090424.15292-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the RGA dt config of rk3288 SoC.

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index a0a0b08bff74..8c6dfc0abc42 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -972,6 +972,17 @@
 		status = "disabled";
 	};
 
+	rga: rga@ff920000 {
+		compatible = "rockchip,rk3288-rga";
+		reg = <0x0 0xff920000 0x0 0x180>;
+		interrupts = <GIC_SPI 18 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru ACLK_RGA>, <&cru HCLK_RGA>, <&cru SCLK_RGA>;
+		clock-names = "aclk", "hclk", "sclk";
+		power-domains = <&power RK3288_PD_VIO>;
+		resets = <&cru SRST_RGA_CORE>, <&cru SRST_RGA_AXI>, <&cru SRST_RGA_AHB>;
+		reset-names = "core", "axi", "ahb";
+	};
+
 	vopb: vop@ff930000 {
 		compatible = "rockchip,rk3288-vop";
 		reg = <0x0 0xff930000 0x0 0x19c>;
-- 
2.14.1
