Return-Path: <SRS0=FbF1=QN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1885BC282CC
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBD752083B
	for <linux-media@archiver.kernel.org>; Wed,  6 Feb 2019 10:26:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z3/rQ9o4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfBFK0J (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 6 Feb 2019 05:26:09 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44988 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729393AbfBFK0I (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2019 05:26:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id v16so5033614wrn.11
        for <linux-media@vger.kernel.org>; Wed, 06 Feb 2019 02:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l1CtKO6V+4HtmzEfS2pTeqx8xeoh5M0LOaS1U2hjAuU=;
        b=z3/rQ9o4yU2862vNXPyOvjh80vHfqpy8ueGt5vlIEo3U4eUOcZcrWAxhevuji4Mxcf
         o5kwKsiEJsjuK232XD//JBE3nl7hcul7BePJkWJojGRj3aAlZKytkNorVLmMrihA40Dz
         D976t/lmMWDYStrDdwMAVgq3RnNIjIsAxWIT7Fbjh3F6pxV3bsiY/Vta0bEOHZ4KiZVt
         69/2TD7ZhgvEZX1hgyCrzJFgj3aHJa3cezmmtUMfFduQUZEfVA0wV2h48bXmX8Hr8sP+
         gldoY0S8ileQht5ROWAy9ZH6NF0l2FOvKucLpG7PSqgFwmwPft7OURNhnuhn+DeH7Hob
         iBJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1CtKO6V+4HtmzEfS2pTeqx8xeoh5M0LOaS1U2hjAuU=;
        b=Q9iPk+rEDgLVRsd9rLvWGC2hDYv9hU223RGMnTF2PP5UwpymGTpct3vzG7+O8E2KR6
         YvjulMqv7L8AJQhLy8xMwpQ2hte9V7RQqzBLXCIDGgUAxEBN+E20RltTv7u5M4nVTzSU
         6msP8okSAHIZy9jM0ZBC5YUhOgh+prntIo24hBpPw6i4r/d2tFqhG2sFDI4Xc7hg0qlQ
         alhygYpwH6FvrmPNvLttLjF9HaGYshuJ84ziwVEtnCbpTylpZGVygXiBGU4vIAElFU7B
         FX0AEOusc5XwZ2vcxyn0+oM+L0Gz7f8+Z8KfTmmVnWGRpI1AEGZnyDASP8NoK+HwGDf2
         CqFA==
X-Gm-Message-State: AHQUAuanuJ9nQwLiQb5r3x1reiB/9y7PrWaX7UtXhF5gbGIFSSS1Gh3s
        joIQVLHB8DS5ny0HuncF6TjGoQ==
X-Google-Smtp-Source: AHgI3Iae2MheBGHrucUoRL3EOzJjhCa2c3qByQAVvVk2RC6/NZBBXSRjjA1BM2IXydAqQNUhQt751w==
X-Received: by 2002:a5d:4b01:: with SMTP id v1mr7026444wrq.5.1549448766514;
        Wed, 06 Feb 2019 02:26:06 -0800 (PST)
Received: from arch-late.local (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id i192sm18149631wmg.7.2019.02.06.02.26.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Feb 2019 02:26:06 -0800 (PST)
From:   Rui Miguel Silva <rui.silva@linaro.org>
To:     sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v13 08/13] ARM: dts: imx7: Add video mux, csi and mipi_csi and connections
Date:   Wed,  6 Feb 2019 10:25:17 +0000
Message-Id: <20190206102522.29212-9-rui.silva@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190206102522.29212-1-rui.silva@linaro.org>
References: <20190206102522.29212-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds the device tree nodes for csi, video multiplexer and
mipi-csi besides the graph connecting the necessary endpoints to make
the media capture entities to work in imx7 Warp board.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 arch/arm/boot/dts/imx7s-warp.dts | 51 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/imx7s.dtsi     | 27 +++++++++++++++++
 2 files changed, 78 insertions(+)

diff --git a/arch/arm/boot/dts/imx7s-warp.dts b/arch/arm/boot/dts/imx7s-warp.dts
index 23431faecaf4..358bcae7ebaf 100644
--- a/arch/arm/boot/dts/imx7s-warp.dts
+++ b/arch/arm/boot/dts/imx7s-warp.dts
@@ -277,6 +277,57 @@
 	status = "okay";
 };
 
+&gpr {
+	csi_mux {
+		compatible = "video-mux";
+		mux-controls = <&mux 0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@1 {
+			reg = <1>;
+
+			csi_mux_from_mipi_vc0: endpoint {
+				remote-endpoint = <&mipi_vc0_to_csi_mux>;
+			};
+		};
+
+		port@2 {
+			reg = <2>;
+
+			csi_mux_to_csi: endpoint {
+				remote-endpoint = <&csi_from_csi_mux>;
+			};
+		};
+	};
+};
+
+&csi {
+	status = "okay";
+
+	port {
+		csi_from_csi_mux: endpoint {
+			remote-endpoint = <&csi_mux_to_csi>;
+		};
+	};
+};
+
+&mipi_csi {
+	clock-frequency = <166000000>;
+	status = "okay";
+	#address-cells = <1>;
+	#size-cells = <0>;
+	fsl,csis-hs-settle = <3>;
+
+	port@1 {
+		reg = <1>;
+
+		mipi_vc0_to_csi_mux: endpoint {
+			remote-endpoint = <&csi_mux_from_mipi_vc0>;
+		};
+	};
+};
+
 &wdog1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog>;
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 792efcd2caa1..01962f85cab6 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -8,6 +8,7 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/reset/imx7-reset.h>
 #include "imx7d-pinfunc.h"
 
 / {
@@ -709,6 +710,17 @@
 				status = "disabled";
 			};
 
+			csi: csi@30710000 {
+				compatible = "fsl,imx7-csi";
+				reg = <0x30710000 0x10000>;
+				interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX7D_CLK_DUMMY>,
+						<&clks IMX7D_CSI_MCLK_ROOT_CLK>,
+						<&clks IMX7D_CLK_DUMMY>;
+				clock-names = "axi", "mclk", "dcic";
+				status = "disabled";
+			};
+
 			lcdif: lcdif@30730000 {
 				compatible = "fsl,imx7d-lcdif", "fsl,imx28-lcdif";
 				reg = <0x30730000 0x10000>;
@@ -718,6 +730,21 @@
 				clock-names = "pix", "axi";
 				status = "disabled";
 			};
+
+			mipi_csi: mipi-csi@30750000 {
+				compatible = "fsl,imx7-mipi-csi2";
+				reg = <0x30750000 0x10000>;
+				interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX7D_IPG_ROOT_CLK>,
+					<&clks IMX7D_MIPI_CSI_ROOT_CLK>,
+					<&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
+				clock-names = "pclk", "wrap", "phy";
+				power-domains = <&pgc_mipi_phy>;
+				phy-supply = <&reg_1p0d>;
+				resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
+				reset-names = "mrst";
+				status = "disabled";
+			};
 		};
 
 		aips3: aips-bus@30800000 {
-- 
2.20.1

