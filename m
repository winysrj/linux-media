Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3881 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbIWBag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 21:30:36 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<treding@nvidia.com>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <bmurthyv@nvidia.com>,
	<linux-tegra@vger.kernel.org>
Subject: [PATCH 3/3] Documentation: DT bindings: add VI and CSI bindings
Date: Tue, 22 Sep 2015 18:30:34 -0700
Message-ID: <1442971834-2721-4-git-send-email-pengw@nvidia.com>
In-Reply-To: <1442971834-2721-1-git-send-email-pengw@nvidia.com>
References: <1442971834-2721-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Bryan Wu <pengw@nvidia.com>
---
 .../bindings/gpu/nvidia,tegra20-host1x.txt         | 211 ++++++++++++++++++++-
 1 file changed, 205 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
index 46d6ead..433cb52 100644
--- a/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+++ b/Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
@@ -40,10 +40,39 @@ of the following host1x client modules:
   - interrupts: The interrupt outputs from the controller.
   - clocks: Must contain one entry, for the module clock.
     See ../clocks/clock-bindings.txt for details.
+  - clock-names: Must include the following entries:
+    - vi
+      This MUST be the first entry.
+    - csi
+    - parent
   - resets: Must contain an entry for each entry in reset-names.
     See ../reset/reset.txt for details.
   - reset-names: Must include the following entries:
     - vi
+  - power-domains: The power domains settings.
+    See ../power/power_domain.txt
+  - iommus: The IOMMU settings.
+    See ../iommu/iommu.txt
+  - ports: several VI input ports which connecting CSI ports. Ports contain
+    several port and each port has one endpoint.
+    See ../graph.txt and ../media/video-interfaces.txt
+  - avdd-dsi-csi-supply: a regulator required by VI.
+
+- csi: camera serial interface
+
+  Required properties:
+  - compatible: "nvidia,tegra<chip>-csi"
+  - reg: Physical base address and length of the controller's registers.
+  - interrupts: The interrupt outputs from the controller.
+  - clocks: Must contain one entry, for the module clock.
+    See ../clocks/clock-bindings.txt for details.
+  - clock-names: Must include the following entries:
+    - cil
+      This MUST be the first entry.
+  - ports: 2 ports presenting 2 channels of CSI. Each port has 2 endpoints:
+    one connects to sensor device tree node as input and the other one connects
+    to VI endpoint.
+    See ../graph.txt and ../media/video-interfaces.txt
 
 - epp: encoder pre-processor
 
@@ -274,13 +303,183 @@ Example:
 			reset-names = "mpe";
 		};
 
-		vi {
-			compatible = "nvidia,tegra20-vi";
-			reg = <0x54080000 0x00040000>;
-			interrupts = <0 69 0x04>;
-			clocks = <&tegra_car TEGRA20_CLK_VI>;
-			resets = <&tegra_car 100>;
+		vi@0,54080000 {
+			compatible = "nvidia,tegra210-vi";
+			reg = <0x0 0x54080000 0x0 0x800>;
+			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
+			status = "disabled";
+			clocks = <&tegra_car TEGRA210_CLK_VI>,
+				 <&tegra_car TEGRA210_CLK_CSI>,
+				 <&tegra_car TEGRA210_CLK_PLL_C>;
+			clock-names = "vi", "csi", "parent";
+			resets = <&tegra_car 20>;
 			reset-names = "vi";
+
+			power-domains = <&pmc TEGRA_POWERGATE_VENC>;
+
+			iommus = <&mc TEGRA_SWGROUP_VI>;
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
+
+					vi_in0: endpoint {
+						remote-endpoint = <&csi_out0>;
+					};
+				};
+				port@1 {
+					reg = <1>;
+
+					vi_in1: endpoint {
+						remote-endpoint = <&csi_out1>;
+					};
+				};
+				port@2 {
+					reg = <2>;
+
+					vi_in2: endpoint {
+						remote-endpoint = <&csi_out2>;
+					};
+				};
+				port@3 {
+					reg = <3>;
+
+					vi_in3: endpoint {
+						remote-endpoint = <&csi_out3>;
+					};
+				};
+				port@4 {
+					reg = <4>;
+
+					vi_in4: endpoint {
+						remote-endpoint = <&csi_out4>;
+					};
+				};
+				port@5 {
+					reg = <5>;
+
+					vi_in5: endpoint {
+						remote-endpoint = <&csi_out5>;
+					};
+				};
+
+			};
+		};
+
+		csi@0,54080838 {
+			compatible = "nvidia,tegra210-csi";
+			reg = <0x0 0x54080838 0x0 0x700>;
+			clocks = <&tegra_car TEGRA210_CLK_CILAB>;
+			clock-names = "cil";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in0: endpoint@0 {
+						reg = <0x0>;
+					};
+					csi_out0: endpoint@1 {
+						reg = <0x1>;
+						remote-endpoint = <&vi_in0>;
+					};
+				};
+				port@1 {
+					reg = <1>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in1: endpoint@0 {
+						reg = <0>;
+					};
+					csi_out1: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vi_in1>;
+					};
+				};
+			};
+		};
+
+		csi@1,54081038 {
+			compatible = "nvidia,tegra210-csi";
+			reg = <0x0 0x54081038 0x0 0x700>;
+			clocks = <&tegra_car TEGRA210_CLK_CILCD>;
+			clock-names = "cil";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@2 {
+					reg = <2>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in2: endpoint@0 {
+						reg = <0>;
+					};
+
+					csi_out2: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vi_in2>;
+					};
+				};
+				port@3 {
+					reg = <3>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in3: endpoint@0 {
+						reg = <0>;
+					};
+
+					csi_out3: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vi_in3>;
+					};
+				};
+			};
+		};
+
+		csi@2,54081838 {
+			compatible = "nvidia,tegra210-csi";
+			reg = <0x0 0x54081838 0x0 0x700>;
+			clocks = <&tegra_car TEGRA210_CLK_CILE>;
+			clock-names = "cil";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@4 {
+					reg = <4>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in4: endpoint@0 {
+						reg = <0>;
+					};
+					csi_out4: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vi_in4>;
+					};
+				};
+				port@5 {
+					reg = <5>;
+					#address-cells = <1>;
+					#size-cells = <0>;
+					csi_in5: endpoint@0 {
+						reg = <0>;
+					};
+					csi_out5: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vi_in5>;
+					};
+				};
+			};
 		};
 
 		epp {
-- 
2.1.4

