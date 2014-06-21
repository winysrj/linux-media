Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:44332 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaFUWUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jun 2014 18:20:39 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 2/2] media: mt9m111: add device-tree documentation
Date: Sun, 22 Jun 2014 00:19:55 +0200
Message-Id: <1403389195-17386-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1403389195-17386-1-git-send-email-robert.jarzmik@free.fr>
References: <1403389195-17386-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree bindings documentation for the Micron mt9m111 image
sensor.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 .../devicetree/bindings/media/i2c/mt9m111.txt      | 28 ++++++++++++++++++++++
 1 file changed, 28 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9m111.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/mt9m111.txt b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
new file mode 100644
index 0000000..ed5a334
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/mt9m111.txt
@@ -0,0 +1,28 @@
+Micron 1.3Mp CMOS Digital Image Sensor
+
+The Micron MT9M111 is a CMOS active pixel digital image sensor with an active
+array size of 1280H x 1024V. It is programmable through a simple two-wire serial
+interface.
+
+Required Properties:
+- compatible: value should be "micron,mt9m111"
+
+For further reading on port node refer to
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	i2c_master {
+		mt9m111@5d {
+			compatible = "micron,mt9m111";
+			reg = <0x5d>;
+
+			remote = <&pxa_camera>;
+			port {
+				mt9m111_1: endpoint {
+					bus-width = <8>;
+					remote-endpoint = <&pxa_camera>;
+				};
+			};
+		};
+	};
-- 
2.0.0.rc2

