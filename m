Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50396 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbeEQMvM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 08:51:12 -0400
Received: by mail-wm0-f68.google.com with SMTP id t11-v6so8290412wmt.0
        for <linux-media@vger.kernel.org>; Thu, 17 May 2018 05:51:12 -0700 (PDT)
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
Subject: [PATCH v4 08/12] ARM: dts: imx7s: add multiplexer controls
Date: Thu, 17 May 2018 13:50:29 +0100
Message-Id: <20180517125033.18050-9-rui.silva@linaro.org>
In-Reply-To: <20180517125033.18050-1-rui.silva@linaro.org>
References: <20180517125033.18050-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IOMUXC General Purpose Register has bitfield to control video bus
multiplexer to control the CSI input between the MIPI-CSI2 and parallel
interface. Add that register and mask.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 arch/arm/boot/dts/imx7s.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 67450ad89940..3590dab529f9 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -520,8 +520,14 @@
 
 			gpr: iomuxc-gpr@30340000 {
 				compatible = "fsl,imx7d-iomuxc-gpr",
-					"fsl,imx6q-iomuxc-gpr", "syscon";
+					"fsl,imx6q-iomuxc-gpr", "syscon", "simple-mfd";
 				reg = <0x30340000 0x10000>;
+
+				mux: mux-controller {
+					compatible = "mmio-mux";
+					#mux-control-cells = <1>;
+					mux-reg-masks = <0x14 0x00000010>;
+				};
 			};
 
 			ocotp: ocotp-ctrl@30350000 {
-- 
2.17.0
