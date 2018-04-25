Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:33921 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752856AbeDYLA1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 07:00:27 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org, robh+dt@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] dt-bindings: media: i2c: Add mt9t111 image sensor
Date: Wed, 25 Apr 2018 13:00:13 +0200
Message-Id: <1524654014-17852-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524654014-17852-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree bindings documentation for Micron MT9T111/MT9T112 image
sensors.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/mt9t112.txt | 41 +++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mt9t112.txt

diff --git a/Documentation/devicetree/bindings/mt9t112.txt b/Documentation/devicetree/bindings/mt9t112.txt
new file mode 100644
index 0000000..cbad475
--- /dev/null
+++ b/Documentation/devicetree/bindings/mt9t112.txt
@@ -0,0 +1,41 @@
+Micron 3.1Mp CMOS Digital Image Sensor
+--------------------------------------
+
+The Micron MT9T111 and MT9T112 are 1/4 inch 3.1Mp System-On-A-Chip (SOC) CMOS
+digital image sensors which support up to QXGA (2048x1536) image resolution in
+4/3 format.
+
+The sensors can be programmed through a two-wire serial interface and can
+work both in parallel data output mode as well as in MIPI CSI-2 mode.
+
+Required Properties:
+- compatible: shall be one of the following values
+  	"micron,mt9t111" for MT9T111 sensors
+	"micron,mt9t112" for MT9T112 sensors
+
+Optional properties:
+- powerdown-gpios: reference to powerdown input GPIO signal. Pin name "STANDBY".
+  Active level is high.
+
+The device node shall contain one 'port' sub-node with one 'endpoint' child
+node, modeled accordingly to bindings described in:
+Documentation/devicetree/bindings/media/video-interfaces.txt
+
+Example:
+--------
+
+	mt9t112@3d {
+		compatible = "micron,mt9t112";
+		reg = <0x3d>;
+
+		powerdown-gpios = <&gpio4 2 GPIO_ACTIVE_HIGH>;
+
+		port {
+			mt9t112_out: endpoint {
+				pclk-sample = <1>;
+				remote-endpoint = <&ceu_in>;
+			};
+		};
+	};
+
+
-- 
2.7.4
