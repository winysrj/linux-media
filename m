Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34737 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752045AbdGaPdt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 11:33:49 -0400
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, heiko@sntech.de, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Yakir Yang <ykk@rock-chips.com>
Subject: [PATCH v4 4/6] ARM: dts: rockchip: add RGA device node for RK3288
Date: Mon, 31 Jul 2017 23:33:00 +0800
Message-Id: <1501515182-26705-5-git-send-email-jacob-chen@iotwrt.com>
In-Reply-To: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
References: <1501515182-26705-1-git-send-email-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the RGA dt config of rk3288 SoC.

Signed-off-by: Yakir Yang <ykk@rock-chips.com>
Signed-off-by: Jacob Chen <jacob-chen@iotwrt.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 1efc2f2..cea41b7 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -945,6 +945,17 @@
 		status = "okay";
 	};
 
+	rga: rga@ff920000 {
+		compatible = "rockchip,rk3288-rga";
+		reg = <0xff920000 0x180>;
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
 		reg = <0xff930000 0x19c>;
-- 
2.7.4
