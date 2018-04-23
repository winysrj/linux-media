Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33097 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755372AbeDWNtE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:49:04 -0400
Received: by mail-wr0-f194.google.com with SMTP id z73-v6so41512735wrb.0
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 06:49:03 -0700 (PDT)
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
Subject: [PATCH v2 12/15] ARM: dts: imx7s: add capture subsystem
Date: Mon, 23 Apr 2018 14:47:47 +0100
Message-Id: <20180423134750.30403-13-rui.silva@linaro.org>
In-Reply-To: <20180423134750.30403-1-rui.silva@linaro.org>
References: <20180423134750.30403-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add media capture subsystem device to i.MX7 definitions.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 6b49b73053f9..333d9fe6b989 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -1189,4 +1189,9 @@
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
