Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40433 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752581AbeEGQW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:56 -0400
Received: by mail-wr0-f193.google.com with SMTP id v60-v6so29360219wrc.7
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:55 -0700 (PDT)
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
Subject: [PATCH v3 11/14] ARM: dts: imx7s: add capture subsystem
Date: Mon,  7 May 2018 17:21:49 +0100
Message-Id: <20180507162152.2545-12-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add media capture subsystem device to i.MX7 definitions.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 0bae41f2944c..058e0cbf8ee7 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1175,4 +1175,9 @@
 			assigned-clock-parents = <&clks IMX7D_PLL_ENET_MAIN_500M_CLK>;
 		};
 	};
+
+	capture-subsystem {
+		compatible = "fsl,imx7-capture-subsystem";
+		ports = <&csi>;
+	};
 };
-- 
2.17.0
