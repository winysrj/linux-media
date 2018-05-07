Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37249 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752303AbeEGP5e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 11:57:34 -0400
Received: by mail-wm0-f66.google.com with SMTP id l1-v6so16338052wmb.2
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 08:57:33 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org, Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH 1/4] media: ov2680: dt: add voltage supplies as required
Date: Mon,  7 May 2018 16:56:52 +0100
Message-Id: <20180507155655.1555-2-rui.silva@linaro.org>
In-Reply-To: <20180507155655.1555-1-rui.silva@linaro.org>
References: <20180507155655.1555-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov2680 needs to control 3 regulators for the voltage supplies and that was
missing by the first description, added their description and example here.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 Documentation/devicetree/bindings/media/i2c/ov2680.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/ov2680.txt b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
index 0e29f1a113c0..e5d8f130309d 100644
--- a/Documentation/devicetree/bindings/media/i2c/ov2680.txt
+++ b/Documentation/devicetree/bindings/media/i2c/ov2680.txt
@@ -4,6 +4,9 @@ Required Properties:
 - compatible: should be "ovti,ov2680".
 - clocks: reference to the xvclk input clock.
 - clock-names: should be "xvclk".
+- DOVDD-supply: Digital I/O voltage supply.
+- DVDD-supply: Digital core voltage supply.
+- AVDD-supply: Analog voltage supply.
 
 Optional Properties:
 - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
@@ -18,7 +21,7 @@ Endpoint node required properties for CSI-2 connection are:
 - remote-endpoint: a phandle to the bus receiver's endpoint node.
 - clock-lanes: should be set to <0> (clock lane on hardware lane 0).
 - data-lanes: should be set to <1> (one CSI-2 lane supported).
- 
+
 Example:
 
 &i2c2 {
@@ -28,6 +31,9 @@ Example:
 		clocks = <&osc>;
 		clock-names = "xvclk";
 		powerdown-gpios = <&gpio1 3 GPIO_ACTIVE_HIGH>;
+		DOVDD-supply = <&sw2_reg>;
+		DVDD-supply = <&sw2_reg>;
+		AVDD-supply = <&reg_peri_3p15v>;
 
 		port {
 			ov2680_mipi_ep: endpoint {
-- 
2.17.0
