Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33964 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754060AbdJIJEo (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Oct 2017 05:04:44 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yakir Yang <ykk@rock-chips.com>
Subject: [PATCH v11 3/4] arm64: dts: rockchip: add RGA device node for RK3399
Date: Mon,  9 Oct 2017 17:04:23 +0800
Message-Id: <20171009090424.15292-4-jacob-chen@iotwrt.com>
In-Reply-To: <20171009090424.15292-1-jacob-chen@iotwrt.com>
References: <20171009090424.15292-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the RGA dt config of RK3399 SoC.

Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
Signed-off-by: Yakir Yang <ykk@rock-chips.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index d79e9b3265b9..a3fab6af5a17 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1204,6 +1204,17 @@
 		status = "disabled";
 	};
 
+	rga: rga@ff680000 {
+		compatible = "rockchip,rk3399-rga";
+		reg = <0x0 0xff680000 0x0 0x10000>;
+		interrupts = <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru ACLK_RGA>, <&cru HCLK_RGA>, <&cru SCLK_RGA_CORE>;
+		clock-names = "aclk", "hclk", "sclk";
+		resets = <&cru SRST_RGA_CORE>, <&cru SRST_A_RGA>, <&cru SRST_H_RGA>;
+		reset-names = "core", "axi", "ahb";
+		power-domains = <&power RK3399_PD_RGA>;
+	};
+
 	efuse0: efuse@ff690000 {
 		compatible = "rockchip,rk3399-efuse";
 		reg = <0x0 0xff690000 0x0 0x80>;
-- 
2.14.1
