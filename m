Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39861 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966094AbeCHJtz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2018 04:49:55 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        devicetree@vger.kernel.org, heiko@sntech.de,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v6 16/17] arm64: dts: rockchip: add rx0 mipi-phy for rk3399
Date: Thu,  8 Mar 2018 17:48:06 +0800
Message-Id: <20180308094807.9443-17-jacob-chen@iotwrt.com>
In-Reply-To: <20180308094807.9443-1-jacob-chen@iotwrt.com>
References: <20180308094807.9443-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shunqian Zheng <zhengsq@rock-chips.com>

It's a Designware MIPI D-PHY, used for ISP0 in rk3399.

Signed-off-by: Shunqian Zheng <zhengsq@rock-chips.com>
Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 14ed016f2fdd..d18ab8f56ef2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1308,6 +1308,16 @@
 			status = "disabled";
 		};
 
+		mipi_dphy_rx0: mipi-dphy-rx0 {
+			compatible = "rockchip,rk3399-mipi-dphy";
+			clocks = <&cru SCLK_MIPIDPHY_REF>,
+				<&cru SCLK_DPHY_RX0_CFG>,
+				<&cru PCLK_VIO_GRF>;
+			clock-names = "dphy-ref", "dphy-cfg", "grf";
+			power-domains = <&power RK3399_PD_VIO>;
+			status = "disabled";
+		};
+
 		u2phy0: usb2-phy@e450 {
 			compatible = "rockchip,rk3399-usb2phy";
 			reg = <0xe450 0x10>;
-- 
2.16.1
