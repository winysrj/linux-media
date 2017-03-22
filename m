Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:41935 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759361AbdCVMeY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 08:34:24 -0400
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: vladimir_zapolskiy@mentor.com, CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Subject: [PATCH v11 1/2] Documentation: DT: Add OV5647 bindings
Date: Wed, 22 Mar 2017 12:30:26 +0000
Message-Id: <28a30fddd5bcfc9e85f0bafb184acd18f8387357.1490185140.git.roliveir@synopsys.com>
In-Reply-To: <cover.1490185140.git.roliveir@synopsys.com>
References: <cover.1490185140.git.roliveir@synopsys.com>
In-Reply-To: <cover.1490185140.git.roliveir@synopsys.com>
References: <cover.1490185140.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Create device tree bindings documentation.

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

---
 .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
new file mode 100644
index 000000000000..22e44945b661
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
+- compatible		: "ovti,ov5647".
+- reg			: I2C slave address of the sensor.
+- clocks		: Reference to the xclk clock.
+
+The common video interfaces bindings (see video-interfaces.txt) should be
+used to specify link to the image data receiver. The OV5647 device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Endpoint node mandatory properties:
+
+- remote-endpoint: A phandle to the bus receiver's endpoint node.
+
+Example:
+
+	i2c@2000 {
+		...
+		ov: camera@36 {
+			compatible = "ovti,ov5647";
+			reg = <0x36>;
+			clocks = <&camera_clk>;
+			port {
+				camera_1: endpoint {
+					remote-endpoint = <&csi1_ep1>;
+				};
+			};
+		};
+	};
-- 
2.11.0
