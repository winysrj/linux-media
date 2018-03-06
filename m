Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.141]:46513 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbeCFB7v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2018 20:59:51 -0500
From: Wen Nuan <leo.wen@rock-chips.com>
To: mchehab@kernel.org, davem@davemloft.net,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rdunlap@infradead.org, jacob2.chen@rock-chips.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        eddie.cai@rock-chips.com, Leo Wen <leo.wen@rock-chips.com>
Subject: [PATCH V3 2/2] dt-bindings: Document the Rockchip RK1608 bindings
Date: Tue,  6 Mar 2018 09:59:20 +0800
Message-Id: <1520301560-114573-3-git-send-email-leo.wen@rock-chips.com>
In-Reply-To: <1520301560-114573-1-git-send-email-leo.wen@rock-chips.com>
References: <1520301560-114573-1-git-send-email-leo.wen@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Leo Wen <leo.wen@rock-chips.com>

Add DT bindings documentation for Rockchip RK1608.

Changes V3:
- Instead use the *-gpios.
- Delete the rockchip,powerdown0 and rockchip,powerdown1 GPIO.
- Delete the rockchip,reset0 and rockchip,reset1 GPIO.

Signed-off-by: Leo Wen <leo.wen@rock-chips.com>
---
 Documentation/devicetree/bindings/media/rk1608.txt | 87 ++++++++++++++++++++++
 MAINTAINERS                                        |  1 +
 2 files changed, 88 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rk1608.txt

diff --git a/Documentation/devicetree/bindings/media/rk1608.txt b/Documentation/devicetree/bindings/media/rk1608.txt
new file mode 100644
index 0000000..72b01da
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rk1608.txt
@@ -0,0 +1,87 @@
+Rockchip RK1608 as a PreISP to link on Soc
+------------------------------------------
+
+Required properties:
+
+- compatible		: "rockchip,rk1608";
+- reg			: SPI slave address of the rk1608;
+- clocks		: Must contain an entry for each entry in clock-names;
+- clock-names		: Must contain "mclk" for the device's master clock;
+- reset-gpios		: GPIO connected to reset pin;
+- irq-gpios		: GPIO connected to irq pin;
+- sleepst-gpios		: GPIO connected to sleepst pin;
+- wakeup-gpios		: GPIO connected to wakeup pin;
+- powerdown-gpios	: GPIO connected to powerdown pin;
+- pinctrl-names		: Should contain only one value - "default";
+- pinctrl-0		: Pin control group to be used for this controller;
+
+Optional properties:
+
+- spi-max-frequency	: Maximum SPI clocking speed of the device;
+
+The device node should contain one 'port' child node with one child 'endpoint'
+node, according to the bindings defined in Documentation/devicetree/bindings/
+media/video-interfaces.txt. The following are properties specific to those
+nodes.
+
+endpoint node
+-------------
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+	       video-interfaces.txt. If present it should be <1> - the device
+	       supports only one data lane without re-mapping.
+
+Note1: Since no data is generated in RK1608，so this is meaningful that you need
+a extra sensor (such as a camera) mounted on RK1608. You need to use endpoint@x
+to match these sensors.
+
+Note2:You must set the current value of the spi pins to be 8mA, if they are not.
+
+Example:
+&spi0 {
+	status = "okay";
+	spi_rk1608@00 {
+		compatible =  "rockchip,rk1608";
+		status = "okay";
+		reg = <0>;
+		spi-max-frequency = <24000000>;
+		link-freqs = /bits/ 64 <LINK_FREQ>;
+		clocks = <&cru SCLK_SPI0>, <&cru SCLK_VIP_OUT>,
+		<&cru DCLK_VOP0>, <&cru ACLK_VIP>, <&cru HCLK_VIP>,
+		<&cru PCLK_ISP_IN>, <&cru PCLK_ISP_IN>,
+		<&cru PCLK_ISP_IN>, <&cru SCLK_MIPIDSI_24M>,
+		<&cru PCLK_MIPI_CSI>;
+		clock-names = "mclk", "mipi_clk",  "pd_cif", "aclk_cif",
+			"hclk_cif", "cif0_in", "g_pclkin_cif",
+			"cif0_out", "clk_mipi_24m", "hclk_mipiphy";
+		reset-gpios = <&gpio6 0 GPIO_ACTIVE_HIGH>;
+		irq-gpios = <&gpio6 2 GPIO_ACTIVE_HIGH>;
+		sleepst-gpios = <&gpio6 1 GPIO_ACTIVE_HIGH>;
+		wakeup-gpios = <&gpio6 4 GPIO_ACTIVE_HIGH>;
+		powerdown-gpios = <&gpio8 0 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&rk1608_irq_gpios &rk1608_wake_gpios
+			     &rk1608_sleep_gpios>;
+
+		port@0 {
+			mipi_dphy_out: endpoint {
+				remote-endpoint = <&mipi_dphy_in>;
+				clock-lanes = <0>;
+				data-lanes = <1 2 3 4>;
+				clock-noncontinuous;
+				link-frequencies =
+					/bits/ 64 <LINK_FREQ>;
+			};
+		};
+		/* Example: we have two cameras */
+		port@1 {
+			sensor_in0: endpoint@0 {
+				remote-endpoint = <&sensor_out0>;
+			};
+			sensor_in1: endpoint@1 {
+				remote-endpoint = <&sensor_out1>;
+			};
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index b2a98e3..04d227b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -141,6 +141,7 @@ M:	Leo Wen <leo.wen@rock-chips.com>
 S:	Maintained
 F:	drivers/media/spi/rk1608.c
 F:	drivers/media/spi/rk1608.h
+F:	Documentation/devicetree/bindings/media/rk1608.txt
 
 3C59X NETWORK DRIVER
 M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
-- 
2.7.4
