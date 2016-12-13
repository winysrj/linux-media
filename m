Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:44196 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932502AbcLMOdF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 09:33:05 -0500
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: mchehab@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Cc: davem@davemloft.net, gregkh@linuxfoundation.org,
        geert+renesas@glider.be, akpm@linux-foundation.org,
        linux@roeck-us.net, hverkuil@xs4all.nl,
        dheitmueller@kernellabs.com, slongerbeam@gmail.com,
        lars@metafoo.de, robert.jarzmik@free.fr, pavel@ucw.cz,
        pali.rohar@gmail.com, sakari.ailus@linux.intel.com,
        mark.rutland@arm.com, Ramiro.Oliveira@synopsys.com,
        CARLOS.PALMINHA@synopsys.com
Subject: [PATCH v6 1/2] Add OV5647 device tree documentation
Date: Tue, 13 Dec 2016 14:32:36 +0000
Message-Id: <c47834c1c9c2a8e23f41a12c8717601f4a901506.1481639091.git.roliveir@synopsys.com>
In-Reply-To: <cover.1481639091.git.roliveir@synopsys.com>
References: <cover.1481639091.git.roliveir@synopsys.com>
In-Reply-To: <cover.1481639091.git.roliveir@synopsys.com>
References: <cover.1481639091.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create device tree bindings documentation.

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
new file mode 100644
index 0000000..46e5e30
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
@@ -0,0 +1,35 @@
+Omnivision OV5647 raw image sensor
+---------------------------------
+
+OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
+and CCI (I2C compatible) control bus.
+
+Required properties:
+
+- compatible	: "ovti,ov5647";
+- reg		: I2C slave address of the sensor;
+- clocks	: Reference to the xclk clock.
+- clock-names	: Should be "xclk".
+- clock-frequency: Frequency of the xclk clock
+
+The common video interfaces bindings (see video-interfaces.txt) should be
+used to specify link to the image data receiver. The OV5647 device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Example:
+
+	i2c@0x02000 {
+		...
+		ov: camera@0x36 {
+			compatible = "ovti,ov5647";
+			reg = <0x36>;
+			clocks = <&camera_clk>;
+			clock-names = "xclk";
+			clock-frequency = <30000000>;
+			port {
+				camera_1: endpoint {
+					remote-endpoint = <&csi1_ep1>;
+				};
+			};
+		};
+	};
-- 
2.10.2


