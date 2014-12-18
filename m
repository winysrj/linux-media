Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:61103 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaLRIyH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 03:54:07 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <nicolas.ferre@atmel.com>
CC: <voice.shen@atmel.com>, <plagnioj@jcrosoft.com>,
	<boris.brezillon@free-electrons.com>,
	<alexandre.belloni@free-electrons.com>,
	<devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
	<linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>,
	<laurent.pinchart@ideasonboard.com>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 6/7] ARM: at91: dts: sama5d3: add ov2640 camera sensor support
Date: Thu, 18 Dec 2014 16:51:06 +0800
Message-ID: <1418892667-27428-7-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
References: <1418892667-27428-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to v4l2 dt document, we add:
  a camera host: ISI port.
  a i2c camera sensor: ov2640 port.
to sama5d3xmb.dtsi.

In the ov2640 node, it defines the pinctrls, clocks and isi port.
In the ISI node, it also reference to a ov2640 port.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
 arch/arm/boot/dts/sama5d3xmb.dtsi | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
index 0aaebc6..958a528 100644
--- a/arch/arm/boot/dts/sama5d3xmb.dtsi
+++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
@@ -52,6 +52,29 @@
 				};
 			};
 
+			i2c1: i2c@f0018000 {
+				ov2640: camera@0x30 {
+					compatible = "ovti,ov2640";
+					reg = <0x30>;
+					pinctrl-names = "default";
+					pinctrl-0 = <&pinctrl_isi_pck_as_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
+					resetb-gpios = <&pioE 24 GPIO_ACTIVE_LOW>;
+					pwdn-gpios = <&pioE 29 GPIO_ACTIVE_HIGH>;
+					/* use pck1 for the master clock of ov2640 */
+					clocks = <&pck1>;
+					clock-names = "xvclk";
+					assigned-clocks = <&pck1>;
+					assigned-clock-rates = <25000000>;
+
+					port {
+						ov2640_0: endpoint {
+							remote-endpoint = <&isi_0>;
+							bus-width = <8>;
+						};
+					};
+				};
+			};
+
 			usart1: serial@f0020000 {
 				dmas = <0>, <0>;	/*  Do not use DMA for usart1 */
 				pinctrl-names = "default";
@@ -60,6 +83,15 @@
 			};
 
 			isi: isi@f0034000 {
+				port {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					isi_0: endpoint {
+						remote-endpoint = <&ov2640_0>;
+						bus-width = <8>;
+					};
+				};
 			};
 
 			mmc1: mmc@f8000000 {
-- 
1.9.1

