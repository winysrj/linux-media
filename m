Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:36039 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751310AbdGQKfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 06:35:00 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v3 04/23] dt-bindings: media: Binding document for Qualcomm Camera subsystem driver
Date: Mon, 17 Jul 2017 13:33:30 +0300
Message-Id: <1500287629-23703-5-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
References: <1500287629-23703-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add DT binding document for Qualcomm Camera subsystem driver.

CC: Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org
Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../devicetree/bindings/media/qcom,camss.txt       | 191 +++++++++++++++++++++
 1 file changed, 191 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/qcom,camss.txt

diff --git a/Documentation/devicetree/bindings/media/qcom,camss.txt b/Documentation/devicetree/bindings/media/qcom,camss.txt
new file mode 100644
index 0000000..f698498
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/qcom,camss.txt
@@ -0,0 +1,191 @@
+Qualcomm Camera Subsystem
+
+* Properties
+
+- compatible:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain:
+		- "qcom,msm8916-camss"
+- reg:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Register ranges as listed in the reg-names property.
+- reg-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "csiphy0"
+		- "csiphy0_clk_mux"
+		- "csiphy1"
+		- "csiphy1_clk_mux"
+		- "csid0"
+		- "csid1"
+		- "ispif"
+		- "csi_clk_mux"
+		- "vfe0"
+- interrupts:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: Interrupts as listed in the interrupt-names property.
+- interrupt-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+		- "csiphy0"
+		- "csiphy1"
+		- "csid0"
+		- "csid1"
+		- "ispif"
+		- "vfe0"
+- power-domains:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A phandle and power domain specifier pairs to the
+		    power domain which is responsible for collapsing
+		    and restoring power to the peripheral.
+- clocks:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and clock specifier pairs as listed
+		    in clock-names property.
+- clock-names:
+	Usage: required
+	Value type: <stringlist>
+	Definition: Should contain the following entries:
+                - "camss_top_ahb"
+                - "ispif_ahb"
+                - "csiphy0_timer"
+                - "csiphy1_timer"
+                - "csi0_ahb"
+                - "csi0"
+                - "csi0_phy"
+                - "csi0_pix"
+                - "csi0_rdi"
+                - "csi1_ahb"
+                - "csi1"
+                - "csi1_phy"
+                - "csi1_pix"
+                - "csi1_rdi"
+                - "camss_ahb"
+                - "camss_vfe_vfe"
+                - "camss_csi_vfe"
+                - "iface"
+                - "bus"
+- vdda-supply:
+	Usage: required
+	Value type: <phandle>
+	Definition: A phandle to voltage supply for CSI2.
+- iommus:
+	Usage: required
+	Value type: <prop-encoded-array>
+	Definition: A list of phandle and IOMMU specifier pairs.
+
+* Nodes
+
+- ports:
+	Usage: required
+	Definition: As described in video-interfaces.txt in same directory.
+	Properties:
+		- reg:
+			Usage: required
+			Value type: <u32>
+			Definition: Selects CSI2 PHY interface - PHY0 or PHY1.
+	Endpoint node properties:
+		- clock-lanes:
+			Usage: required
+			Value type: <u32>
+			Definition: The clock lane.
+		- data-lanes:
+			Usage: required
+			Value type: <prop-encoded-array>
+			Definition: An array of data lanes.
+
+* An Example
+
+	camss: camss@1b00000 {
+		compatible = "qcom,msm8916-camss";
+		reg = <0x1b0ac00 0x200>,
+			<0x1b00030 0x4>,
+			<0x1b0b000 0x200>,
+			<0x1b00038 0x4>,
+			<0x1b08000 0x100>,
+			<0x1b08400 0x100>,
+			<0x1b0a000 0x500>,
+			<0x1b00020 0x10>,
+			<0x1b10000 0x1000>;
+		reg-names = "csiphy0",
+			"csiphy0_clk_mux",
+			"csiphy1",
+			"csiphy1_clk_mux",
+			"csid0",
+			"csid1",
+			"ispif",
+			"csi_clk_mux",
+			"vfe0";
+		interrupts = <GIC_SPI 78 0>,
+			<GIC_SPI 79 0>,
+			<GIC_SPI 51 0>,
+			<GIC_SPI 52 0>,
+			<GIC_SPI 55 0>,
+			<GIC_SPI 57 0>;
+		interrupt-names = "csiphy0",
+			"csiphy1",
+			"csid0",
+			"csid1",
+			"ispif",
+			"vfe0";
+		power-domains = <&gcc VFE_GDSC>;
+		clocks = <&gcc GCC_CAMSS_TOP_AHB_CLK>,
+			<&gcc GCC_CAMSS_ISPIF_AHB_CLK>,
+			<&gcc GCC_CAMSS_CSI0PHYTIMER_CLK>,
+			<&gcc GCC_CAMSS_CSI1PHYTIMER_CLK>,
+			<&gcc GCC_CAMSS_CSI0_AHB_CLK>,
+			<&gcc GCC_CAMSS_CSI0_CLK>,
+			<&gcc GCC_CAMSS_CSI0PHY_CLK>,
+			<&gcc GCC_CAMSS_CSI0PIX_CLK>,
+			<&gcc GCC_CAMSS_CSI0RDI_CLK>,
+			<&gcc GCC_CAMSS_CSI1_AHB_CLK>,
+			<&gcc GCC_CAMSS_CSI1_CLK>,
+			<&gcc GCC_CAMSS_CSI1PHY_CLK>,
+			<&gcc GCC_CAMSS_CSI1PIX_CLK>,
+			<&gcc GCC_CAMSS_CSI1RDI_CLK>,
+			<&gcc GCC_CAMSS_AHB_CLK>,
+			<&gcc GCC_CAMSS_VFE0_CLK>,
+			<&gcc GCC_CAMSS_CSI_VFE0_CLK>,
+			<&gcc GCC_CAMSS_VFE_AHB_CLK>,
+			<&gcc GCC_CAMSS_VFE_AXI_CLK>;
+                clock-names = "camss_top_ahb",
+                        "ispif_ahb",
+                        "csiphy0_timer",
+                        "csiphy1_timer",
+                        "csi0_ahb",
+                        "csi0",
+                        "csi0_phy",
+                        "csi0_pix",
+                        "csi0_rdi",
+                        "csi1_ahb",
+                        "csi1",
+                        "csi1_phy",
+                        "csi1_pix",
+                        "csi1_rdi",
+                        "camss_ahb",
+                        "camss_vfe_vfe",
+                        "camss_csi_vfe",
+                        "iface",
+                        "bus";
+		vdda-supply = <&pm8916_l2>;
+		iommus = <&apps_iommu 3>;
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			port@0 {
+				reg = <0>;
+				csiphy0_ep: endpoint {
+					clock-lanes = <1>;
+					data-lanes = <0 2>;
+					remote-endpoint = <&ov5645_ep>;
+				};
+			};
+		};
+	};
-- 
2.7.4
