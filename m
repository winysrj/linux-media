Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17463 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbbIPBfc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2015 21:35:32 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>,
	<treding@nvidia.com>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <gerrit2@nvidia.com>
Subject: [PATCH 2/3] ARM64: add tegra-vi support in T210 device-tree
Date: Tue, 15 Sep 2015 18:35:30 -0700
Message-ID: <1442367331-20046-3-git-send-email-pengw@nvidia.com>
In-Reply-To: <1442367331-20046-1-git-send-email-pengw@nvidia.com>
References: <1442367331-20046-1-git-send-email-pengw@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Following device tree support for Tegra VI now:
 - "vi" node which might have 6 ports/endpoints
 - in TPG mode, "vi" node don't need to define any ports/endpoints
 - ports/endpoints defines the link between VI and external sensors.

Signed-off-by: Bryan Wu <pengw@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts |   8 +
 arch/arm64/boot/dts/nvidia/tegra210.dtsi          | 174 +++++++++++++++++++++-
 2 files changed, 181 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts b/arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts
index d4ee460..534ada52 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts
@@ -7,6 +7,14 @@
 	model = "NVIDIA Tegra210 P2571 reference board (E.1)";
 	compatible = "nvidia,p2571-e01", "nvidia,tegra210";
 
+	host1x@0,50000000 {
+		vi@0,54080000 {
+			status = "okay";
+
+			avdd-dsi-csi-supply = <&vdd_dsi_csi>;
+		};
+	};
+
 	pinmux: pinmux@0,700008d4 {
 		pinctrl-names = "boot";
 		pinctrl-0 = <&state_boot>;
diff --git a/arch/arm64/boot/dts/nvidia/tegra210.dtsi b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
index 1168bcd..3f6501f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -109,9 +109,181 @@
 
 		vi@0,54080000 {
 			compatible = "nvidia,tegra210-vi";
-			reg = <0x0 0x54080000 0x0 0x00040000>;
+			reg = <0x0 0x54080000 0x0 0x800>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
+			clocks = <&tegra_car TEGRA210_CLK_VI>,
+				 <&tegra_car TEGRA210_CLK_CSI>,
+				 <&tegra_car TEGRA210_CLK_PLL_C>;
+			clock-names = "vi", "csi", "parent";
+			resets = <&tegra_car 20>;
+			reset-names = "vi";
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
 
 		tsec@0,54100000 {
-- 
2.1.4


-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
