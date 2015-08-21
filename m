Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16022 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbHUAwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2015 20:52:23 -0400
From: Bryan Wu <pengw@nvidia.com>
To: <hansverk@cisco.com>, <linux-media@vger.kernel.org>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<treding@nvidia.com>, <wenjiaz@nvidia.com>, <davidw@nvidia.com>,
	<gfitzer@nvidia.com>
Subject: [PATCH 2/2] ARM64: add tegra-vi support in T210 device-tree
Date: Thu, 20 Aug 2015 17:51:37 -0700
Message-ID: <1440118300-32491-3-git-send-email-pengw@nvidia.com>
In-Reply-To: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com>
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
 arch/arm64/boot/dts/nvidia/tegra210-p2571-e01.dts |  8 ++++++++
 arch/arm64/boot/dts/nvidia/tegra210.dtsi          | 13 +++++++++++++
 2 files changed, 21 insertions(+)

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
index 1168bcd..78bfaad 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -112,6 +112,19 @@
 			reg = <0x0 0x54080000 0x0 0x00040000>;
 			interrupts = <GIC_SPI 69 IRQ_TYPE_LEVEL_HIGH>;
 			status = "disabled";
+			clocks = <&tegra_car TEGRA210_CLK_VI>,
+				 <&tegra_car TEGRA210_CLK_CSI>,
+				 <&tegra_car TEGRA210_CLK_PLL_C>,
+				 <&tegra_car TEGRA210_CLK_CILAB>,
+				 <&tegra_car TEGRA210_CLK_CILCD>,
+				 <&tegra_car TEGRA210_CLK_CILE>;
+			clock-names = "vi", "csi", "parent", "cilab", "cilcd", "cile";
+			resets = <&tegra_car 20>;
+			reset-names = "vi";
+
+			power-domains = <&pmc TEGRA_POWERGATE_VENC>;
+
+			iommus = <&mc TEGRA_SWGROUP_VI>;
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
