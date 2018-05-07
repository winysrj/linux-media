Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44893 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752519AbeEGQWs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:48 -0400
Received: by mail-wr0-f194.google.com with SMTP id y15-v6so17643721wrg.11
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:47 -0700 (PDT)
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
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v3 08/14] ARM: dts: imx7s: add mipi phy power domain
Date: Mon,  7 May 2018 17:21:46 +0100
Message-Id: <20180507162152.2545-9-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
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
