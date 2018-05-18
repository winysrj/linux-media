Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54432 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753421AbeERJ2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 05:28:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id f6-v6so12981062wmc.4
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 02:28:40 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        linux-clk@vger.kernel.org, Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v5 07/12] ARM: dts: imx7s: add mipi phy power domain
Date: Fri, 18 May 2018 10:28:01 +0100
Message-Id: <20180518092806.3829-8-rui.silva@linaro.org>
In-Reply-To: <20180518092806.3829-1-rui.silva@linaro.org>
References: <20180518092806.3829-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add power domain index 0 related with mipi-phy to imx7s.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 4d42335c0dee..67450ad89940 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -636,6 +636,12 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 
+					pgc_mipi_phy: pgc-power-domain@0 {
+						#power-domain-cells = <0>;
+						reg = <0>;
+						power-supply = <&reg_1p0d>;
+					};
+
 					pgc_pcie_phy: pgc-power-domain@1 {
 						#power-domain-cells = <0>;
 						reg = <1>;
-- 
2.17.0
