Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55013 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728064AbeHJQvw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Aug 2018 12:51:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id c14-v6so2096577wmb.4
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2018 07:21:45 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v7 06/12] ARM: dts: imx7s: add mipi phy power domain
Date: Fri, 10 Aug 2018 15:20:39 +0100
Message-Id: <20180810142045.27657-7-rui.silva@linaro.org>
In-Reply-To: <20180810142045.27657-1-rui.silva@linaro.org>
References: <20180810142045.27657-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add power domain index 0 related with mipi-phy to imx7s.

While at it rename pcie power-domain node to remove pgc prefix.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 9ced589bfa96..df4a29365468 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -610,7 +610,13 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					pgc_pcie_phy: pgc-power-domain@1 {
+					pgc_mipi_phy: power-domain@0 {
+						#power-domain-cells = <0>;
+						reg = <0>;
+						power-supply = <&reg_1p0d>;
+					};
+
+					pgc_pcie_phy: power-domain@1 {
 						#power-domain-cells = <0>;
 						reg = <1>;
 						power-supply = <&reg_1p0d>;
-- 
2.18.0
