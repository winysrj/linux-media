Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36313 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164671AbdEYAaJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 20:30:09 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v7 03/34] [media] dt/bindings: Add bindings for OV5640
Date: Wed, 24 May 2017 17:29:18 -0700
Message-Id: <1495672189-29164-4-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
References: <1495672189-29164-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for the OV5640 camera sensor.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/media/i2c/ov5640.txt       | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5640.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
new file mode 100644
index 0000000..540b36c
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
@@ -0,0 +1,45 @@
+* Omnivision OV5640 MIPI CSI-2 sensor
+
+Required Properties:
+- compatible: should be "ovti,ov5640"
+- clocks: reference to the xclk input clock.
+- clock-names: should be "xclk".
+- DOVDD-supply: Digital I/O voltage supply, 1.8 volts
+- AVDD-supply: Analog voltage supply, 2.8 volts
+- DVDD-supply: Digital core voltage supply, 1.5 volts
+
+Optional Properties:
+- reset-gpios: reference to the GPIO connected to the reset pin, if any.
+	       This is an active low signal to the OV5640.
+- powerdown-gpios: reference to the GPIO connected to the powerdown pin,
+		   if any. This is an active high signal to the OV5640.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+&i2c1 {
+	ov5640: camera@3c {
+		compatible = "ovti,ov5640";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		reg = <0x3c>;
+		clocks = <&clks IMX6QDL_CLK_CKO>;
+		clock-names = "xclk";
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen3_reg>;  /* 2.8v */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v */
+		powerdown-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
+
+		port {
+			ov5640_to_mipi_csi2: endpoint {
+				remote-endpoint = <&mipi_csi2_from_ov5640>;
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+			};
+		};
+	};
+};
-- 
2.7.4
