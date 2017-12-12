Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.137]:60001 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbdLLG3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 01:29:43 -0500
From: Leo Wen <leo.wen@rock-chips.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        rdunlap@infradead.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        eddie.cai@rock-chips.com, Leo Wen <leo.wen@rock-chips.com>
Subject: [PATCH 2/2] dt-bindings: Document the Rockchip RK1608 bindings
Date: Tue, 12 Dec 2017 14:28:15 +0800
Message-Id: <1513060095-29588-3-git-send-email-leo.wen@rock-chips.com>
In-Reply-To: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
References: <1513060095-29588-1-git-send-email-leo.wen@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT bindings documentation for Rockchip RK1608.

Signed-off-by: Leo Wen <leo.wen@rock-chips.com>
---
 Documentation/devicetree/bindings/media/rk1608.txt | 143 +++++++++++++++++++++
 MAINTAINERS                                        |   1 +
 2 files changed, 144 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rk1608.txt

diff --git a/Documentation/devicetree/bindings/media/rk1608.txt b/Documentation/devicetree/bindings/media/rk1608.txt
new file mode 100644
index 0000000..bda5cdb
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rk1608.txt
@@ -0,0 +1,143 @@
+Rockchip RK1608 as a PreISP to link on Soc
+------------------------------------------
+
+Required properties:
+
+- compatible      : "rockchip,rk1608";
+- reg             : SPI slave address of the rk1608;
+- clocks          : Must contain an entry for each entry in clock-names;
+- clock-names	  : Must contain "mclk" for the device's master clock;
+- reset-gpio      : GPIO connected to reset pin;
+- irq-gpio        : GPIO connected to irq pin;
+- sleepst-gpio    : GPIO connected to sleepst pin;
+- wakeup-gpio     : GPIO connected to wakeup pin;
+- powerdown-gpio  : GPIO connected to powerdown pin;
+- pinctrl-names   : Should contain only one value - "default";
+- pinctrl-0       : Pin control group to be used for this controller;
+
+Optional properties:
+
+- spi-max-frequency	: Maximum SPI clocking speed of the device;
+			        (for RK1608)
+- spi-min-frequency	: Minimum SPI clocking speed of the device;
+			        (for RK1608)
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
+
+&spi0 {
+	status = "okay";
+
+	spi_rk1608@00 {
+		compatible =  "rockchip,rk1608";
+		reg = <0>;
+		status = "okay";
+		spi-max-frequency = <24000000>;
+		spi-min-frequency = <12000000>;
+		clocks = <&cru SCLK_SPI0>;
+		clock-names = "mclk";
+
+		reset-gpio = <&gpio6 0 GPIO_ACTIVE_HIGH>;
+		irq-gpio = <&gpio6 2 GPIO_ACTIVE_HIGH>;
+		sleepst-gpio = <&gpio6 1 GPIO_ACTIVE_HIGH>;
+		wakeup-gpio = <&gpio6 4 GPIO_ACTIVE_HIGH>;
+		powerdown-gpio = <&gpio8 0 GPIO_ACTIVE_HIGH>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&rk1608_irq_gpios &rk1608_wake_gpios
+			     &rk1608_sleep_gpios>;
+
+		port {
+			isp_mipi_out: endpoint {
+				remote-endpoint = <&isp_mipi_in>;
+				data-lanes = <1>;
+			};
+			/*Example: we have two cameras*/
+			sensor_in0: endpoint@0 {
+				remote-endpoint = <&xxx0>;
+			};
+
+			sensor_in1: endpoint@1 {
+				remote-endpoint = <&xxx1>;
+			};
+		};
+	};
+};
+
+&mipi_phy_rx0 {
+	bus-width = <2>;
+	status = "okay";
+
+	port {
+		isp_mipi_in: endpoint {
+			remote-endpoint = <&isp_mipi_out>;
+				data-lanes = <1>;
+				link-frequencies =
+					/bits/ 64 <1000000000>;
+		};
+	};
+};
+
+&pinctrl {
+	rk1608_irq_gpios {
+		rk1608_irq_gpios: rk1608_irq_gpios {
+			rockchip,pins = <6 2 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pull = <1>;
+		};
+	};
+
+	rk1608_wake_gpios {
+		rk1608_wake_gpios: rk1608_wake_gpios {
+			rockchip,pins = <6 4 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pull = <1>;
+		};
+	};
+
+	rk1608_sleep_gpios {
+		rk1608_sleep_gpios: rk1608_sleep_gpios {
+			rockchip,pins = <6 1 RK_FUNC_GPIO &pcfg_pull_none>;
+			rockchip,pull = <1>;
+			rockchip,drive = <0>;
+		};
+	};
+
+	pcfg_pull_none_8ma: pcfg-pull-none-8ma {
+		bias-disable;
+		drive-strength = <8>;
+	};
+
+	spi0 {
+		spi0_clk: spi0-clk {
+			rockchip,pins = <5 12 RK_FUNC_1 &pcfg_pull_none_8ma>;
+		};
+		spi0_cs0: spi0-cs0 {
+			rockchip,pins = <5 13 RK_FUNC_1 &pcfg_pull_none_8ma>;
+		};
+		spi0_tx: spi0-tx {
+			rockchip,pins = <5 14 RK_FUNC_1 &pcfg_pull_none_8ma>;
+		};
+		spi0_rx: spi0-rx {
+			rockchip,pins = <5 15 RK_FUNC_1 &pcfg_pull_none_8ma>;
+		};
+		spi0_cs1: spi0-cs1 {
+			rockchip,pins = <5 16 RK_FUNC_1 &pcfg_pull_none_8ma>;
+		};
+	};
+};
diff --git a/MAINTAINERS b/MAINTAINERS
index 48235d8..196a9ff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -133,6 +133,7 @@ M:	Leo Wen <leo.wen@rock-chips.com>
 S:	Maintained
 F:	drivers/media/platform/spi/rk1608.c
 F:	drivers/media/platform/spi/rk1608.h
+F:	Documentation/devicetree/bindings/media/rk1608.txt
 
 3C59X NETWORK DRIVER
 M:	Steffen Klassert <klassert@mathematik.tu-chemnitz.de>
-- 
2.7.4
