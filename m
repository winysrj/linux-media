Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38093 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755439AbdL2HyA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Dec 2017 02:54:00 -0500
From: Shunqian Zheng <zhengsq@rock-chips.com>
To: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org, Joao.Pinto@synopsys.com,
        Luis.Oliveira@synopsys.com, Jose.Abreu@synopsys.com,
        jacob2.chen@rock-chips.com
Subject: [PATCH v5 11/16] dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
Date: Fri, 29 Dec 2017 15:52:53 +0800
Message-Id: <1514533978-20408-12-git-send-email-zhengsq@rock-chips.com>
In-Reply-To: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
References: <1514533978-20408-1-git-send-email-zhengsq@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jacob Chen <jacob2.chen@rock-chips.com>

Add DT bindings documentation for Rockchip MIPI D-PHY RX

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/media/rockchip-mipi-dphy.txt          | 88 ++++++++++++++++++++++
 1 file changed, 88 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt

diff --git a/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
new file mode 100644
index 0000000..0571d7f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
@@ -0,0 +1,88 @@
+Rockchip SoC MIPI RX D-PHY
+-------------------------------------------------------------
+
+Required properties:
+- compatible: value should be one of the following
+	"rockchip,rk3288-mipi-dphy"
+	"rockchip,rk3399-mipi-dphy"
+- clocks : list of clock specifiers, corresponding to entries in
+	clock-names property;
+- clock-names: required clock name.
+
+MIPI RX0 D-PHY use registers in "general register files", it
+should be a child of the GRF.
+MIPI TXRX D-PHY have its own registers, it must have a reg property.
+
+Optional properties:
+- reg: offset and length of the register set for the device.
+
+port node
+-------------------
+
+The device node should contain two 'port' child nodes, according to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+The first port show the sensors connected in this mipi-dphy.
+- endpoint:
+	- remote-endpoint: Linked to a sensor with a MIPI CSI-2 video bus.
+	- data-lanes : (required) an array specifying active physical MIPI-CSI2
+			data input lanes and their mapping to logical lanes; the
+			D-PHY can't reroute lanes, so the array's content should
+			be consecutive and only its length is meaningful.
+
+The port node must contain at least one endpoint. It could have multiple endpoints
+linked to different sensors, but please note that they are not supposed to be
+activated at the same time.
+
+The second port should be connected to isp node.
+- endpoint:
+	- remote-endpoint:  Linked to Rockchip ISP1, which is defined
+		in rockchip-isp1.txt.
+
+Device node example
+-------------------
+
+grf: syscon@ff770000 {
+	compatible = "rockchip,rk3288-grf", "syscon", "simple-mfd";
+
+...
+
+	mipi_dphy_rx0: mipi-dphy-rx0 {
+		compatible = "rockchip,rk3399-mipi-dphy";
+		clocks = <&cru SCLK_MIPIDPHY_REF>,
+			<&cru SCLK_DPHY_RX0_CFG>,
+			<&cru PCLK_VIO_GRF>;
+		clock-names = "dphy-ref", "dphy-cfg", "grf";
+		power-domains = <&power RK3399_PD_VIO>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				mipi_in_wcam: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&wcam_out>;
+					data-lanes = <1 2>;
+				};
+				mipi_in_ucam: endpoint@1 {
+					reg = <1>;
+					remote-endpoint = <&ucam_out>;
+					data-lanes = <1>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+
+				dphy_rx0_out: endpoint {
+					remote-endpoint = <&isp0_mipi_in>;
+				};
+			};
+		};
+	};
+};
-- 
1.9.1
