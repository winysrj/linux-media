Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33493 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbcFNWvT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:19 -0400
Received: by mail-pf0-f195.google.com with SMTP id c74so306638pfb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:18 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 19/38] ARM: dts: imx6-sabrelite: add video capture ports and connections
Date: Tue, 14 Jun 2016 15:49:15 -0700
Message-Id: <1465944574-15745-20-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Defines the host video capture device node and an OV5642 camera sensor
node on i2c2. The host capture device connects to the OV5642 via the
parallel-bus mux input on the ipu1_csi0_mux.

Note there is a pin conflict with GPIO6. This pin functions as a power
input pin to the OV5642, but ENET requires it to wake-up the ARM cores
on normal RX and TX packet done events (see 6261c4c8). So by default,
capture is disabled, enable by uncommenting __OV5642_CAPTURE__ macro.
Ethernet will still work just not quite as well.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi | 95 ++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index c47fe6c..9709183 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -39,9 +39,20 @@
  *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  *     OTHER DEALINGS IN THE SOFTWARE.
  */
+
+#include <dt-bindings/clock/imx6qdl-clock.h>
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/input.h>
 
+/*
+ * Uncomment the following macro to enable OV5642 video capture
+ * support. There is a pin conflict for GPIO6 between ENET wake-up
+ * interrupt function and power-down pin function for the OV5642.
+ * ENET will still work when enabling OV5642 capture, just not
+ * quite as well.
+ */
+/* #define __OV5642_CAPTURE__ */
+
 / {
 	chosen {
 		stdout-path = &uart2;
@@ -218,8 +229,37 @@
 			};
 		};
 	};
+
+#ifdef __OV5642_CAPTURE__
+	ipucap0: ipucap@0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>;
+		status = "okay";
+	};
+#endif
+};
+
+#ifdef __OV5642_CAPTURE__
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+	data-shift = <12>; /* Lines 19:12 used */
+	hsync-active = <1>;
+	vync-active = <1>;
 };
 
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+#endif
+	
 &audmux {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_audmux>;
@@ -271,8 +311,11 @@
 	txd1-skew-ps = <0>;
 	txd2-skew-ps = <0>;
 	txd3-skew-ps = <0>;
+#ifndef __OV5642_CAPTURE__
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
+
+#endif
 	status = "okay";
 };
 
@@ -301,6 +344,30 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
+
+#ifdef __OV5642_CAPTURE__
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ov5642>;
+		clocks = <&clks IMX6QDL_CLK_CKO2>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		reset-gpios = <&gpio1 8 0>;
+		pwdn-gpios = <&gpio1 6 0>;
+		gp-gpios = <&gpio1 16 0>;
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
+#endif
 };
 
 &i2c3 {
@@ -373,7 +440,9 @@
 				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b0b0
 				/* Phy reset */
 				MX6QDL_PAD_EIM_D23__GPIO3_IO23		0x000b0
+#ifndef __OV5642_CAPTURE__
 				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
+#endif
 			>;
 		};
 
@@ -448,6 +517,32 @@
 			>;
 		};
 
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
+		pinctrl_ov5642: ov5642grp {
+			fsl,pins = <
+				MX6QDL_PAD_SD1_DAT0__GPIO1_IO16 0x80000000
+				MX6QDL_PAD_GPIO_6__GPIO1_IO06   0x80000000
+				MX6QDL_PAD_GPIO_8__GPIO1_IO08   0x80000000
+				MX6QDL_PAD_GPIO_3__CCM_CLKO2    0x80000000
+			>;
+		};
+
 		pinctrl_pwm1: pwm1grp {
 			fsl,pins = <
 				MX6QDL_PAD_SD1_DAT3__PWM1_OUT 0x1b0b1
-- 
1.9.1

