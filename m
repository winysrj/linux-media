Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:24998 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaFUWW0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 18:22:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 1/2] media: soc_camera: pxa_camera documentation device-tree support
Date: Sun, 22 Jun 2014 00:21:46 +0200
Message-Id: <1403389307-17489-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree bindings documentation for pxa_camera driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 .../devicetree/bindings/media/pxa-camera.txt       | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/pxa-camera.txt

diff --git a/Documentation/devicetree/bindings/media/pxa-camera.txt b/Documentation/devicetree/bindings/media/pxa-camera.txt
new file mode 100644
index 0000000..9835aae
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/pxa-camera.txt
@@ -0,0 +1,39 @@
+Marvell PXA camera host interface
+
+Required properties:
+ - compatible: Should be "marvell,pxa27x-qci"
+ - reg: register base and size
+ - interrupts: the interrupt number
+ - any required generic properties defined in video-interfaces.txt
+
+Optional properties:
+ - clock-frequency: host interface is driving MCLK, and MCLK rate is this rate
+
+Example:
+
+	pxa_camera: pxa_camera@50000000 {
+		compatible = "marvell,pxa27x-qci";
+		reg = <0x50000000 0x1000>;
+		interrupts = <33>;
+
+		clocks = <&pxa2xx_clks 24>;
+		clock-names = "camera";
+		status = "okay";
+
+		clock-frequency = <50000000>;
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Parallel bus endpoint */
+			qci: endpoint@0 {
+				reg = <0>;		/* Local endpoint # */
+				remote-endpoint = <&mt9m111_1>;
+				bus-width = <8>;	/* Used data lines */
+				hsync-active = <0>;	/* Active low */
+				vsync-active = <0>;	/* Active low */
+				pclk-sample = <1>;	/* Rising */
+			};
+		};
+	};
-- 
2.0.0.rc2

