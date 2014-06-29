Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:58156 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaF2OUp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jun 2014 10:20:45 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 2/2] media: soc_camera: pxa_camera documentation device-tree support
Date: Sun, 29 Jun 2014 16:20:00 +0200
Message-Id: <1404051600-20838-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
References: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree bindings documentation for pxa_camera driver.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

---
Since V1: Mark's review
          - wildcard pxa27x becomes pxa270
          - clock name "camera" becomes "ciclk"
          - add mclk clock provider
---
 .../devicetree/bindings/media/pxa-camera.txt       | 43 ++++++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/pxa-camera.txt

diff --git a/Documentation/devicetree/bindings/media/pxa-camera.txt b/Documentation/devicetree/bindings/media/pxa-camera.txt
new file mode 100644
index 0000000..11f5b5d
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/pxa-camera.txt
@@ -0,0 +1,43 @@
+Marvell PXA camera host interface
+
+Required properties:
+ - compatible: Should be "marvell,pxa270-qci"
+ - reg: register base and size
+ - interrupts: the interrupt number
+ - any required generic properties defined in video-interfaces.txt
+
+Optional properties:
+ - clocks: input clock (see clock-bindings.txt)
+ - clock-output-names: should contain the name of the clock driving the
+                       sensor master clock MCLK
+ - clock-frequency: host interface is driving MCLK, and MCLK rate is this rate
+
+Example:
+
+	pxa_camera: pxa_camera@50000000 {
+		compatible = "marvell,pxa270-qci";
+		reg = <0x50000000 0x1000>;
+		interrupts = <33>;
+
+		clocks = <&pxa2xx_clks 24>;
+		clock-names = "ciclk";
+		clock-frequency = <50000000>;
+		clock-output-names = "qci_mclk";
+
+		status = "okay";
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

