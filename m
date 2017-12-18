Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33550 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933474AbdLRMP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 07:15:57 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, Joao.Pinto@synopsys.com,
        Luis.Oliveira@synopsys.com, Jose.Abreu@synopsys.com,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v4 13/16] ARM: dts: rockchip: add rx0 mipi-phy for rk3288
Date: Mon, 18 Dec 2017 20:14:42 +0800
Message-Id: <20171218121445.6086-10-jacob-chen@iotwrt.com>
In-Reply-To: <20171218121445.6086-1-jacob-chen@iotwrt.com>
References: <20171218121445.6086-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

It's a Designware MIPI D-PHY, used by ISP in rk3288.

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index ed0b17d1b116..aa9ad3a6e0a5 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -864,6 +864,13 @@
 			status = "disabled";
 		};
 
+		mipi_phy_rx0: mipi-phy-rx0 {
+			compatible = "rockchip,rk3288-mipi-dphy";
+			clocks = <&cru SCLK_MIPIDSI_24M>, <&cru PCLK_MIPI_CSI>;
+			clock-names = "dphy-ref", "pclk";
+			status = "disabled";
+		};
+
 		io_domains: io-domains {
 			compatible = "rockchip,rk3288-io-voltage-domain";
 			status = "disabled";
-- 
2.15.1
