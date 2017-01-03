Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35774 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935262AbdACU5p (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 15:57:45 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
To: shawnguo@kernel.org, kernel@pengutronix.de, fabio.estevam@nxp.com,
        robh+dt@kernel.org, mark.rutland@arm.com, linux@armlinux.org.uk,
        mchehab@kernel.org, gregkh@linuxfoundation.org,
        p.zabel@pengutronix.de
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 04/19] ARM: dts: imx6-sabrelite: add OV5642 and OV5640 camera sensors
Date: Tue,  3 Jan 2017 12:57:14 -0800
Message-Id: <1483477049-19056-5-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
References: <1483477049-19056-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enables the OV5642 parallel-bus sensor, and the OV5640 MIPI CSI-2 sensor.
Both hang off the same i2c2 bus, so they require different (and non-
default) i2c slave addresses.

The OV5642 connects to the parallel-bus mux input port on ipu1_csi0_mux.

The OV5640 connects to the input port on the MIPI CSI-2 receiver on
mipi_csi. It is set to transmit over MIPI virtual channel 1.

Note there is a pin conflict with GPIO6. This pin functions as a power
input pin to the OV5642, but ENET uses it as the h/w workaround for
erratum ERR006687, to wake-up the ARM cores on normal RX and TX packet
done events (see 6261c4c8). So workaround 6261c4c8 is reverted here to
support the OV5642, and the "fsl,err006687-workaround-present" boolean
also must be removed. The result is that the CPUidle driver will no longer
allow entering the deep idle states on the sabrelite.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6dl-sabrelite.dts   |   5 ++
 arch/arm/boot/dts/imx6q-sabrelite.dts    |   6 ++
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 122 ++++++++++++++++++++++++++++++-
 3 files changed, 129 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx6dl-sabrelite.dts b/arch/arm/boot/dts/imx6dl-sabrelite.dts
index 0f06ca5..fec2524 100644
--- a/arch/arm/boot/dts/imx6dl-sabrelite.dts
+++ b/arch/arm/boot/dts/imx6dl-sabrelite.dts
@@ -48,3 +48,8 @@
 	model = "Freescale i.MX6 DualLite SABRE Lite Board";
 	compatible = "fsl,imx6dl-sabrelite", "fsl,imx6dl";
 };
+
+&ipu1_csi1_from_ipu1_csi1_mux {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
diff --git a/arch/arm/boot/dts/imx6q-sabrelite.dts b/arch/arm/boot/dts/imx6q-sabrelite.dts
index 66d10d8..9e2d26d 100644
--- a/arch/arm/boot/dts/imx6q-sabrelite.dts
+++ b/arch/arm/boot/dts/imx6q-sabrelite.dts
@@ -52,3 +52,9 @@
 &sata {
 	status = "okay";
 };
+
+&ipu1_csi1_from_mipi_vc1 {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
+
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index 1f9076e..4a50bb1 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -39,6 +39,8 @@
  *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  *     OTHER DEALINGS IN THE SOFTWARE.
  */
+
+#include <dt-bindings/clock/imx6qdl-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
@@ -96,6 +98,15 @@
 		};
 	};
 
+	mipi_xclk: mipi_xclk {
+		compatible = "pwm-clock";
+		#clock-cells = <0>;
+		clock-frequency = <22000000>;
+		clock-output-names = "mipi_pwm3";
+		pwms = <&pwm3 0 45>; /* 1 / 45 ns = 22 MHz */
+		status = "okay";
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 		pinctrl-names = "default";
@@ -220,6 +231,22 @@
 	};
 };
 
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+	data-shift = <12>; /* Lines 19:12 used */
+	hsync-active = <1>;
+	vync-active = <1>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
+};
+
+&ipu1_csi0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_ipu1_csi0>;
+};
+
 &audmux {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_audmux>;
@@ -271,9 +298,6 @@
 	txd1-skew-ps = <0>;
 	txd2-skew-ps = <0>;
 	txd3-skew-ps = <0>;
-	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
-			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
-	fsl,err006687-workaround-present;
 	status = "okay";
 };
 
@@ -302,6 +326,52 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+	camera: ov5642@42 {
+		compatible = "ovti,ov5642";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5642>;
+		clocks = <&clks IMX6QDL_CLK_CKO2>;
+		clock-names = "xclk";
+		reg = <0x42>;
+		xclk = <24000000>;
+		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
+		pwdn-gpios = <&gpio1 6 GPIO_ACTIVE_HIGH>;
+		gp-gpios = <&gpio1 16 GPIO_ACTIVE_HIGH>;
+
+		port {
+			ov5642_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+
+	mipi_camera: ov5640@40 {
+		compatible = "ovti,ov5640_mipi";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5640>;
+		clocks = <&mipi_xclk>;
+		clock-names = "xclk";
+		reg = <0x40>;
+		xclk = <22000000>;
+		reset-gpios = <&gpio2 5 GPIO_ACTIVE_LOW>; /* NANDF_D5 */
+		pwdn-gpios = <&gpio6 9 GPIO_ACTIVE_HIGH>; /* NANDF_WP_B */
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ov5640_to_mipi_csi: endpoint@1 {
+				reg = <1>;
+				remote-endpoint = <&mipi_csi_from_mipi_sensor>;
+				data-lanes = <0 1>;
+				clock-lanes = <2>;
+			};
+		};
+	};
 };
 
 &i2c3 {
@@ -374,7 +444,6 @@
 				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b030
 				/* Phy reset */
 				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
-				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
 			>;
 		};
 
@@ -449,6 +518,39 @@
 			>;
 		};
 
+		pinctrl_ov5642: ov5642grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
+				MX6QDL_PAD_GPIO_6__GPIO1_IO06   0x80000000
+				MX6QDL_PAD_GPIO_8__GPIO1_IO08   0x80000000
+				MX6QDL_PAD_GPIO_3__CCM_CLKO2    0x80000000
+			>;
+		};
+
+		pinctrl_ipu1_csi0: ipu1grp-csi0 {
+			fsl,pins = <
+				MX6QDL_PAD_CSI0_DAT12__IPU1_CSI0_DATA12    0x80000000
+				MX6QDL_PAD_CSI0_DAT13__IPU1_CSI0_DATA13    0x80000000
+				MX6QDL_PAD_CSI0_DAT14__IPU1_CSI0_DATA14    0x80000000
+				MX6QDL_PAD_CSI0_DAT15__IPU1_CSI0_DATA15    0x80000000
+				MX6QDL_PAD_CSI0_DAT16__IPU1_CSI0_DATA16    0x80000000
+				MX6QDL_PAD_CSI0_DAT17__IPU1_CSI0_DATA17    0x80000000
+				MX6QDL_PAD_CSI0_DAT18__IPU1_CSI0_DATA18    0x80000000
+				MX6QDL_PAD_CSI0_DAT19__IPU1_CSI0_DATA19    0x80000000
+				MX6QDL_PAD_CSI0_PIXCLK__IPU1_CSI0_PIXCLK   0x80000000
+				MX6QDL_PAD_CSI0_MCLK__IPU1_CSI0_HSYNC      0x80000000
+				MX6QDL_PAD_CSI0_VSYNC__IPU1_CSI0_VSYNC     0x80000000
+				MX6QDL_PAD_CSI0_DATA_EN__IPU1_CSI0_DATA_EN 0x80000000
+			>;
+		};
+
+                pinctrl_ov5640: ov5640grp {
+                        fsl,pins = <
+				MX6QDL_PAD_NANDF_D5__GPIO2_IO05 0x000b0
+				MX6QDL_PAD_NANDF_WP_B__GPIO6_IO09 0x0b0b0
+                        >;
+                };
+
 		pinctrl_pwm1: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD1_DAT3__PWM1_OUT 0x1b0b1
@@ -605,3 +707,15 @@
 	vmmc-supply = <&reg_3p3v>;
 	status = "okay";
 };
+
+&mipi_csi {
+        status = "okay";
+};
+
+/* Incoming port from sensor */
+&mipi_csi_from_mipi_sensor {
+        remote-endpoint = <&ov5640_to_mipi_csi>;
+        data-lanes = <0 1>;
+        clock-lanes = <2>;
+};
+
-- 
2.7.4

