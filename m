Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:40415 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752471AbeEGQWp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 May 2018 12:22:45 -0400
Received: by mail-wr0-f193.google.com with SMTP id v60-v6so29359656wrc.7
        for <linux-media@vger.kernel.org>; Mon, 07 May 2018 09:22:45 -0700 (PDT)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v3 07/14] media: dt-bindings: add bindings for i.MX7 media driver
Date: Mon,  7 May 2018 17:21:45 +0100
Message-Id: <20180507162152.2545-8-rui.silva@linaro.org>
In-Reply-To: <20180507162152.2545-1-rui.silva@linaro.org>
References: <20180507162152.2545-1-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for i.MX7 media drivers.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 .../devicetree/bindings/media/imx7.txt        | 152 ++++++++++++++++++
 1 file changed, 152 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/imx7.txt

diff --git a/Documentation/devicetree/bindings/media/imx7.txt b/Documentation/devicetree/bindings/media/imx7.txt
new file mode 100644
index 000000000000..06d723d6354d
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx7.txt
@@ -0,0 +1,152 @@
+Freescale i.MX7 Media Video Device
+==================================
+
+Video Media Controller node
+---------------------------
+
+This is the media controller node for video capture support. It is a
+virtual device that lists the camera serial interface nodes that the
+media device will control.
+
+Required properties:
+- compatible : "fsl,imx7-capture-subsystem";
+- ports      : Should contain a list of phandles pointing to camera
+		sensor interface port of CSI
+
+example:
+
+capture-subsystem {
+	compatible = "fsl,imx7-capture-subsystem";
+	ports = <&csi>;
+};
+
+
+mipi_csi2 node
+--------------
+
+This is the device node for the MIPI CSI-2 receiver core in i.MX7 SoC. It is
+compatible with previous version of Samsung D-phy.
+
+Required properties:
+
+- compatible    : "fsl,imx7-mipi-csi2";
+- reg           : base address and length of the register set for the device;
+- interrupts    : should contain MIPI CSIS interrupt;
+- clocks        : list of clock specifiers, see
+        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
+- clock-names   : must contain "pclk", "wrap" and "phy" entries, matching
+                  entries in the clock property;
+- power-domains : a phandle to the power domain, see
+          Documentation/devicetree/bindings/power/power_domain.txt for details.
+- reset-names   : should include following entry "mrst";
+- resets        : a list of phandle, should contain reset entry of
+                  reset-names;
+- phy-supply    : from the generic phy bindings, a phandle to a regulator that
+	          provides power to MIPI CSIS core;
+- bus-width     : maximum number of data lanes supported (SoC specific);
+
+Optional properties:
+
+- clock-frequency : The IP's main (system bus) clock frequency in Hz, default
+		    value when this property is not specified is 166 MHz;
+
+port node
+---------
+
+- reg		  : (required) can take the values 0 or 1, where 0 is the
+                     related sink port and port 1 should be the source one;
+
+endpoint node
+-------------
+
+- data-lanes    : (required) an array specifying active physical MIPI-CSI2
+		    data input lanes and their mapping to logical lanes; the
+		    array's content is unused, only its length is meaningful;
+
+- fsl,csis-hs-settle : (optional) differential receiver (HS-RX) settle time;
+
+example:
+
+        mipi_csi: mipi-csi@30750000 {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                compatible = "fsl,imx7-mipi-csi2";
+                reg = <0x30750000 0x10000>;
+                interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&clks IMX7D_IPG_ROOT_CLK>,
+                                <&clks IMX7D_MIPI_CSI_ROOT_CLK>,
+                                <&clks IMX7D_MIPI_DPHY_ROOT_CLK>;
+                clock-names = "pclk", "wrap", "phy";
+                clock-names = "mipi", "phy";
+                clock-frequency = <166000000>;
+                power-domains = <&pgc_mipi_phy>;
+                phy-supply = <&reg_1p0d>;
+                resets = <&src IMX7_RESET_MIPI_PHY_MRST>;
+                reset-names = "mrst";
+                bus-width = <4>;
+                fsl,csis-hs-settle = <3>;
+                fsl,csis-clk-settle = <0>;
+
+                port@0 {
+                        reg = <0>;
+
+                        mipi_from_sensor: endpoint {
+                                remote-endpoint = <&ov2680_to_mipi>;
+                                data-lanes = <1>;
+                        };
+                };
+
+                port@1 {
+                        reg = <1>;
+
+                        mipi_vc0_to_csi_mux: endpoint {
+                                remote-endpoint = <&csi_mux_from_mipi_vc0>;
+                        };
+                };
+        };
+
+
+csi node
+--------
+
+This is device node for the CMOS Sensor Interface (CSI) which enables the chip
+to connect directly to external CMOS image sensors.
+
+Required properties:
+
+- compatible    : "fsl,imx7-csi";
+- reg           : base address and length of the register set for the device;
+- interrupts    : should contain CSI interrupt;
+- clocks        : list of clock specifiers, see
+        Documentation/devicetree/bindings/clock/clock-bindings.txt for details;
+- clock-names   : must contain "axi", "mclk" and "dcic" entries, matching
+                 entries in the clock property;
+
+port node
+---------
+
+- reg		  : (required) should be 0 for the sink port;
+
+example:
+
+                csi: csi@30710000 {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        compatible = "fsl,imx7-csi";
+                        reg = <0x30710000 0x10000>;
+                        interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+                        clocks = <&clks IMX7D_CLK_DUMMY>,
+                                        <&clks IMX7D_CSI_MCLK_ROOT_CLK>,
+                                        <&clks IMX7D_CLK_DUMMY>;
+                        clock-names = "axi", "mclk", "dcic";
+
+                        port@0 {
+                                reg = <0>;
+
+                                csi_from_csi_mux: endpoint {
+                                        remote-endpoint = <&csi_mux_to_csi>;
+                                };
+                        };
+                };
-- 
2.17.0
