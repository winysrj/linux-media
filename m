Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:29442 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755005AbdELDWt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 23:22:49 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH v3 2/3] arm64: dts: mt8173: Fix mdp device tree
Date: Fri, 12 May 2017 11:22:40 +0800
Message-ID: <1494559361-42835-3-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1494559361-42835-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1494559361-42835-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Kurtz <djkurtz@chromium.org>

If the mdp_* nodes are under an mdp sub-node, their corresponding
platform device does not automatically get its iommu assigned properly.

Fix this by moving the mdp component nodes up a level such that they are
siblings of mdp and all other SoC subsystems.  This also simplifies the
device tree.

Although it fixes iommu assignment issue, it also break compatibility
with old device tree. So, the patch in driver is needed to iterate over
sibling mdp device nodes, not child ones, to keep driver work properly.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>

---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 126 +++++++++++++++----------------
 1 file changed, 60 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 6922252..d28a363 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -792,80 +792,74 @@
 			#clock-cells = <1>;
 		};
 
-		mdp {
-			compatible = "mediatek,mt8173-mdp";
-			#address-cells = <2>;
-			#size-cells = <2>;
-			ranges;
+		mdp_rdma0: rdma@14001000 {
+			compatible = "mediatek,mt8173-mdp-rdma",
+				     "mediatek,mt8173-mdp";
+			reg = <0 0x14001000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_RDMA0>,
+				 <&mmsys CLK_MM_MUTEX_32K>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+			iommus = <&iommu M4U_PORT_MDP_RDMA0>;
+			mediatek,larb = <&larb0>;
 			mediatek,vpu = <&vpu>;
+		};
 
-			mdp_rdma0: rdma@14001000 {
-				compatible = "mediatek,mt8173-mdp-rdma";
-				reg = <0 0x14001000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_RDMA0>,
-					 <&mmsys CLK_MM_MUTEX_32K>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-				iommus = <&iommu M4U_PORT_MDP_RDMA0>;
-				mediatek,larb = <&larb0>;
-			};
-
-			mdp_rdma1: rdma@14002000 {
-				compatible = "mediatek,mt8173-mdp-rdma";
-				reg = <0 0x14002000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_RDMA1>,
-					 <&mmsys CLK_MM_MUTEX_32K>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-				iommus = <&iommu M4U_PORT_MDP_RDMA1>;
-				mediatek,larb = <&larb4>;
-			};
+		mdp_rdma1: rdma@14002000 {
+			compatible = "mediatek,mt8173-mdp-rdma";
+			reg = <0 0x14002000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_RDMA1>,
+				 <&mmsys CLK_MM_MUTEX_32K>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+			iommus = <&iommu M4U_PORT_MDP_RDMA1>;
+			mediatek,larb = <&larb4>;
+		};
 
-			mdp_rsz0: rsz@14003000 {
-				compatible = "mediatek,mt8173-mdp-rsz";
-				reg = <0 0x14003000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_RSZ0>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-			};
+		mdp_rsz0: rsz@14003000 {
+			compatible = "mediatek,mt8173-mdp-rsz";
+			reg = <0 0x14003000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_RSZ0>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		};
 
-			mdp_rsz1: rsz@14004000 {
-				compatible = "mediatek,mt8173-mdp-rsz";
-				reg = <0 0x14004000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_RSZ1>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-			};
+		mdp_rsz1: rsz@14004000 {
+			compatible = "mediatek,mt8173-mdp-rsz";
+			reg = <0 0x14004000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_RSZ1>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		};
 
-			mdp_rsz2: rsz@14005000 {
-				compatible = "mediatek,mt8173-mdp-rsz";
-				reg = <0 0x14005000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_RSZ2>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-			};
+		mdp_rsz2: rsz@14005000 {
+			compatible = "mediatek,mt8173-mdp-rsz";
+			reg = <0 0x14005000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_RSZ2>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		};
 
-			mdp_wdma0: wdma@14006000 {
-				compatible = "mediatek,mt8173-mdp-wdma";
-				reg = <0 0x14006000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_WDMA>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-				iommus = <&iommu M4U_PORT_MDP_WDMA>;
-				mediatek,larb = <&larb0>;
-			};
+		mdp_wdma0: wdma@14006000 {
+			compatible = "mediatek,mt8173-mdp-wdma";
+			reg = <0 0x14006000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_WDMA>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+			iommus = <&iommu M4U_PORT_MDP_WDMA>;
+			mediatek,larb = <&larb0>;
+		};
 
-			mdp_wrot0: wrot@14007000 {
-				compatible = "mediatek,mt8173-mdp-wrot";
-				reg = <0 0x14007000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_WROT0>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-				iommus = <&iommu M4U_PORT_MDP_WROT0>;
-				mediatek,larb = <&larb0>;
-			};
+		mdp_wrot0: wrot@14007000 {
+			compatible = "mediatek,mt8173-mdp-wrot";
+			reg = <0 0x14007000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_WROT0>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+			iommus = <&iommu M4U_PORT_MDP_WROT0>;
+			mediatek,larb = <&larb0>;
+		};
 
-			mdp_wrot1: wrot@14008000 {
-				compatible = "mediatek,mt8173-mdp-wrot";
-				reg = <0 0x14008000 0 0x1000>;
-				clocks = <&mmsys CLK_MM_MDP_WROT1>;
-				power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
-				iommus = <&iommu M4U_PORT_MDP_WROT1>;
-				mediatek,larb = <&larb4>;
-			};
+		mdp_wrot1: wrot@14008000 {
+			compatible = "mediatek,mt8173-mdp-wrot";
+			reg = <0 0x14008000 0 0x1000>;
+			clocks = <&mmsys CLK_MM_MDP_WROT1>;
+			power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+			iommus = <&iommu M4U_PORT_MDP_WROT1>;
+			mediatek,larb = <&larb4>;
 		};
 
 		ovl0: ovl@1400c000 {
-- 
1.9.1
