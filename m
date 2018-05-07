Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44337 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbeEGP5h (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:57:37 -0400
Received: by mail-wr0-f196.google.com with SMTP id y15-v6so17563177wrg.11
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 08:57:37 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 2/4] media: ov2680: dt: rename gpio to reset and fix polarity
Date: Mon,  7 May 2018 16:56:53 +0100
Message-Id: <20180507155655.1555-3-rui.silva@linaro.org>
In-Reply-To: <20180507155655.1555-1-rui.silva@linaro.org>
References: <20180507155655.1555-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the GPIO 3 controls both reset and powerdown, we rename it to reset. Fix
the polarity of this, as it is a low active signal and not an high active.

As at it, rename the mipi endpoint in the example to be coherent with the a real
case that will be introduce for imx7 media driver.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 Documentation/devicetree/bindings/media/i2c/ov2680.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2680.txt b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
index e5d8f130309d..11e925ed9dad 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov2680.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
@@ -9,8 +9,8 @@ Required Properties:
 - AVDD-supply: Analog voltage supply.
 
 Optional Properties:
-- powerdown-gpios: reference to the GPIO connected to the powerdown pin,
-		     if any. This is an active high signal to the OV2680.
+- reset-gpios: reference to the GPIO connected to the powerdown/reset pin,
+               if any. This is an active low signal to the OV2680.
 
 The device node must contain one 'port' child node for its digital output
 video port, and this port must have a single endpoint in accordance with
@@ -30,14 +30,14 @@ Example:
 		reg = <0x36>;
 		clocks = <&osc>;
 		clock-names = "xvclk";
-		powerdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 3 GPIO_ACTIVE_LOW>;
 		DOVDD-supply = <&sw2_reg>;
 		DVDD-supply = <&sw2_reg>;
 		AVDD-supply = <&reg_peri_3p15v>;
 
 		port {
-			ov2680_mipi_ep: endpoint {
-				remote-endpoint = <&mipi_sensor_ep>;
+			ov2680_to_mipi: endpoint {
+				remote-endpoint = <&mipi_from_sensor>;
 				clock-lanes = <0>;
 				data-lanes = <1>;
 			};
-- 
2.17.0
