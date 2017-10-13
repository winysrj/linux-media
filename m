Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54340 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753245AbdJMWxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 18:53:50 -0400
From: Pierre-Hugues Husson <phh@phh.me>
To: linux-rockchip@lists.infradead.org
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Pierre-Hugues Husson <phh@phh.me>
Subject: [PATCH 2/3] arm64: dts: rockchip: add the cec clk for dw-mipi-hdmi on rk3399
Date: Sat, 14 Oct 2017 00:53:36 +0200
Message-Id: <20171013225337.5196-3-phh@phh.me>
In-Reply-To: <20171013225337.5196-1-phh@phh.me>
References: <20171013225337.5196-1-phh@phh.me>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index ab7629c5b856..a65f7f744a40 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1601,8 +1601,12 @@
 		compatible = "rockchip,rk3399-dw-hdmi";
 		reg = <0x0 0xff940000 0x0 0x20000>;
 		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH 0>;
-		clocks = <&cru PCLK_HDMI_CTRL>, <&cru SCLK_HDMI_SFR>, <&cru PLL_VPLL>, <&cru PCLK_VIO_GRF>;
-		clock-names = "iahb", "isfr", "vpll", "grf";
+		clocks = <&cru PCLK_HDMI_CTRL>,
+			 <&cru SCLK_HDMI_SFR>,
+			 <&cru PLL_VPLL>,
+			 <&cru PCLK_VIO_GRF>,
+			 <&cru SCLK_HDMI_CEC>;
+		clock-names = "iahb", "isfr", "vpll", "grf", "cec";
 		power-domains = <&power RK3399_PD_HDCP>;
 		reg-io-width = <4>;
 		rockchip,grf = <&grf>;
-- 
2.14.1
