Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34228 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbcDXVK2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:10:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id n3so20028538wmn.1
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2016 14:10:28 -0700 (PDT)
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
To: sakari.ailus@iki.fi
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
Subject: [RFC PATCH 14/24] media: et8ek8: add device tree binding document
Date: Mon, 25 Apr 2016 00:08:14 +0300
Message-Id: <1461532104-24032-15-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sebastian Reichel <sre@kernel.org>

Add the document for et8ek8 dt.
---
 .../bindings/media/i2c/toshiba,et8ek8.txt          | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
new file mode 100644
index 0000000..acb9290
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/toshiba,et8ek8.txt
@@ -0,0 +1,56 @@
+Toshiba ET8EK8 sensor
+
+Toshiba ET8EK8 is an image sensor used in the Nokia N900.
+
+Additional information about video interfaces in DT can be found in
+Documentation/devicetree/bindings/media/video-interfaces.txt .
+
+Mandatory properties
+--------------------
+
+- compatible: "toshiba,et8ek8"
+- reg: I2C address (0x3e, or an alternative address)
+- vana-supply: Analogue voltage supply (VANA), typically 2.8 volts (sensor
+  dependent).
+- clocks: External clock to the sensor
+- clock-frequency: Frequency of the external clock to the sensor
+
+Optional properties
+-------------------
+
+- reset-gpios: XSHUTDOWN GPIO
+
+
+Endpoint node mandatory properties
+----------------------------------
+
+- clock-lanes: <0>
+- data-lanes: <1>
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
+
+Example
+-------
+
+&i2c2 {
+	clock-frequency = <400000>;
+
+	cam1: camera@3e {
+		compatible = "toshiba,et8ek8";
+		reg = <0x3e>;
+
+		vana-supply = <&vaux4>;
+
+		clocks = <&isp 0>;
+		clock-frequency = <9600000>;
+
+		reset-gpio = <&gpio4 6 GPIO_ACTIVE_HIGH>; /* 102 */
+
+		port {
+			cam1_1: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1>;
+				remote-endpoint = <&isp_csi>;
+			};
+		};
+	};
+};
-- 
1.9.1

