Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:42389 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753427AbdKXCiC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Nov 2017 21:38:02 -0500
From: Jacob Chen <jacob-chen@iotwrt.com>
To: linux-rockchip@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        tfiga@chromium.org, zhengsq@rock-chips.com,
        laurent.pinchart@ideasonboard.com, zyc@rock-chips.com,
        eddie.cai.linux@gmail.com, jeffy.chen@rock-chips.com,
        allon.huang@rock-chips.com, devicetree@vger.kernel.org,
        heiko@sntech.de, robh+dt@kernel.org,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Jacob Chen <jacob2.chen@rock-chips.com>
Subject: [PATCH v2 06/11] dt-bindings: Document the Rockchip MIPI RX D-PHY bindings
Date: Fri, 24 Nov 2017 10:37:01 +0800
Message-Id: <20171124023706.5702-7-jacob-chen@iotwrt.com>
In-Reply-To: <20171124023706.5702-1-jacob-chen@iotwrt.com>
References: <20171124023706.5702-1-jacob-chen@iotwrt.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT bindings documentation for Rockchip MIPI D-PHY RX

Signed-off-by: Jacob Chen <jacob2.chen@rock-chips.com>
---
 .../bindings/media/rockchip-mipi-dphy.txt          | 77 ++++++++++++++++++++++
 1 file changed, 77 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt

diff --git a/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
new file mode 100644
index 000000000000..b5773b67c250
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/rockchip-mipi-dphy.txt
@@ -0,0 +1,77 @@
+Rockchip SoC MIPI RX D-PHY
+-------------------------------------------------------------
+
+Required properties:
+
+- compatible: value should be one of the following
+    "rockchip,rk3288-mipi-dphy";
+    "rockchip,rk3399-mipi-dphy";
+- rockchip,grf: GRF regs.
+- bus-width	  : maximum number of data lanes supported (SoC specific);
+- clocks	  : list of clock specifiers, corresponding to entries in
+		    clock-names property;
+- clock-names: required clock name.
+
+The device node should contain two 'port' child node, according to the bindings
+defined in Documentation/devicetree/bindings/media/video-interfaces.txt.
+The first port should be connected to sensor nodes, and the second port should be
+connected to isp node. The following are properties specific to those nodes.
+
+endpoint node
+-------------
+
+- data-lanes	  : (required) an array specifying active physical MIPI-CSI2
+		    data input lanes and their mapping to logical lanes; the
+		    array's content is unused, only its length is meaningful;
+
+
+Example:
+
+/* SoC properties */
+
+    mipi_dphy_rx0: mipi-dphy-rx0 {
+        compatible = "rockchip,rk3399-mipi-dphy";
+        clocks = <&cru SCLK_MIPIDPHY_REF>,
+            <&cru SCLK_DPHY_RX0_CFG>,
+            <&cru PCLK_VIO_GRF>;
+        clock-names = "dphy-ref", "dphy-cfg", "grf";
+        power-domains = <&power RK3399_PD_VIO>;
+        bus-width = <4>;
+    };
+
+/* Board properties */
+
+    &mipi_phy_rx0 {
+        ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                mipi_in_wcam: endpoint@0 {
+                    reg = <0>;
+                    remote-endpoint = <&wcam_out>;
+                    data-lanes = <1 2>;
+                };
+                mipi_in_ucam: endpoint@1 {
+                    reg = <1>;
+                    remote-endpoint = <&ucam_out>;
+                    data-lanes = <1>;
+                };
+            };
+
+            port@1 {
+                reg = <1>;
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                dphy_rx0_out: endpoint@0 {
+                    reg = <0>;
+                    remote-endpoint = <&isp0_mipi_in>;
+                };
+            };
+        };
+    };
\ No newline at end of file
-- 
2.15.0
