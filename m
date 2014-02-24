Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:50901 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaBXRgt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Feb 2014 12:36:49 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v5 02/10] Documentation: dt: Add binding documentation for
 S5C73M3 camera
Date: Mon, 24 Feb 2014 18:35:14 +0100
Message-id: <1393263322-28215-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
References: <1393263322-28215-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds DT binding documentation for Samsung S5C73M3 camera sensor
with an embedded ISP.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
Changes since v4:
 - added missing unit-address at the example SPI device node;

Changes since v3:
 - DT binding documentation separated into this patch;

Changes since v2:
 - rephrased 'clocks' and 'clock-names' properties' description;
---
 .../devicetree/bindings/media/samsung-s5c73m3.txt  |   97 ++++++++++++++++++++
 1 file changed, 97 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5c73m3.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
new file mode 100644
index 0000000..2c85c45
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5c73m3.txt
@@ -0,0 +1,97 @@
+Samsung S5C73M3 8Mp camera ISP
+------------------------------
+
+The S5C73M3 camera ISP supports MIPI CSI-2 and parallel (ITU-R BT.656) video
+data busses. The I2C bus is the main control bus and additionally the SPI bus
+is used, mostly for transferring the firmware to and from the device. Two
+slave device nodes corresponding to these control bus interfaces are required
+and should be placed under respective bus controller nodes.
+
+I2C slave device node
+---------------------
+
+Required properties:
+
+- compatible	    : "samsung,s5c73m3";
+- reg		    : I2C slave address of the sensor;
+- vdd-int-supply    : digital power supply (1.2V);
+- vdda-supply	    : analog power supply (1.2V);
+- vdd-reg-supply    : regulator input power supply (2.8V);
+- vddio-host-supply : host I/O power supply (1.8V to 2.8V);
+- vddio-cis-supply  : CIS I/O power supply (1.2V to 1.8V);
+- vdd-af-supply     : lens power supply (2.8V);
+- xshutdown-gpios   : specifier of GPIO connected to the XSHUTDOWN pin;
+- standby-gpios     : specifier of GPIO connected to the STANDBY pin;
+- clocks	    : should contain list of phandle and clock specifier pairs
+		      according to common clock bindings for the clocks described
+		      in the clock-names property;
+- clock-names	    : should contain "cis_extclk" entry for the CIS_EXTCLK clock;
+
+Optional properties:
+
+- clock-frequency   : the frequency at which the "cis_extclk" clock should be
+		      configured to operate, in Hz; if this property is not
+		      specified default 24 MHz value will be used.
+
+The common video interfaces bindings (see video-interfaces.txt) should be used
+to specify link from the S5C73M3 to an external image data receiver. The S5C73M3
+device node should contain one 'port' child node with an 'endpoint' subnode for
+this purpose. The data link from a raw image sensor to the S5C73M3 can be
+similarly specified, but it is optional since the S5C73M3 ISP and a raw image
+sensor are usually inseparable and form a hybrid module.
+
+Following properties are valid for the endpoint node(s):
+
+endpoint subnode
+----------------
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+  video-interfaces.txt. This sensor doesn't support data lane remapping
+  and physical lane indexes in subsequent elements of the array should
+  be only consecutive ascending values.
+
+SPI device node
+---------------
+
+Required properties:
+
+- compatible	    : "samsung,s5c73m3";
+
+For more details see description of the SPI busses bindings
+(../spi/spi-bus.txt) and bindings of a specific bus controller.
+
+Example:
+
+i2c@138A000000 {
+	...
+	s5c73m3@3c {
+		compatible = "samsung,s5c73m3";
+		reg = <0x3c>;
+		vdd-int-supply = <&buck9_reg>;
+		vdda-supply = <&ldo17_reg>;
+		vdd-reg-supply = <&cam_io_reg>;
+		vddio-host-supply = <&ldo18_reg>;
+		vddio-cis-supply = <&ldo9_reg>;
+		vdd-af-supply = <&cam_af_reg>;
+		clock-frequency = <24000000>;
+		clocks = <&clk 0>;
+		clock-names = "cis_extclk";
+		reset-gpios = <&gpf1 3 1>;
+		standby-gpios = <&gpm0 1 1>;
+		port {
+			s5c73m3_ep: endpoint {
+				remote-endpoint = <&csis0_ep>;
+				data-lanes = <1 2 3 4>;
+			};
+		};
+	};
+};
+
+spi@1392000 {
+	...
+	s5c73m3_spi: s5c73m3@0 {
+		compatible = "samsung,s5c73m3";
+		reg = <0>;
+		...
+	};
+};
-- 
1.7.9.5

