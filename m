Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:46666 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751044AbcGNMSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 08:18:36 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH 2/4] dt-bindings: Add a binding for Mediatek MDP
Date: Thu, 14 Jul 2016 20:17:59 +0800
Message-ID: <1468498681-19955-3-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1468498681-19955-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1468498681-19955-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a DT binding documentation of MDP for the MT8173 SoC
from Mediatek

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 .../devicetree/bindings/media/mediatek-mdp.txt     |   92 ++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek-mdp.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
new file mode 100644
index 0000000..ef570c3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
@@ -0,0 +1,92 @@
+* Mediatek Media Data Path
+
+Media Data Path is used for scaling and color space conversion.
+
+Required properties:
+  - compatible : should contain them as below:
+        "mediatek,mt8173-mdp"
+        "mediatek,mt8173-mdp-rdma"
+        "mediatek,mt8173-mdp-rsz"
+        "mediatek,mt8173-mdp-wdma"
+        "mediatek,mt8173-mdp-wrot"
+  - clocks : device clocks
+  - power-domains : a phandle to the power domain.
+  - mediatek,larb : should contain the larbes of current platform
+  - iommus : Mediatek IOMMU H/W has designed the fixed associations with
+        the multimedia H/W. and there is only one multimedia iommu domain.
+        "iommus = <&iommu portid>" the "portid" is from
+        dt-bindings\iommu\mt8173-iommu-port.h, it means that this portid will
+        enable iommu. The portid default is disable iommu if "<&iommu portid>"
+        don't be added.
+  - mediatek,vpu : the node of video processor unit
+
+Example:
+	mdp_rdma0: rdma@14001000 {
+		compatible = "mediatek,mt8173-mdp-rdma",
+			     "mediatek,mt8173-mdp";
+		reg = <0 0x14001000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_RDMA0>,
+			 <&mmsys CLK_MM_MUTEX_32K>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		iommus = <&iommu M4U_PORT_MDP_RDMA0>;
+		mediatek,larb = <&larb0>;
+		mediatek,vpu = <&vpu>;
+	};
+
+	mdp_rdma1: rdma@14002000 {
+		compatible = "mediatek,mt8173-mdp-rdma";
+		reg = <0 0x14002000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_RDMA1>,
+			 <&mmsys CLK_MM_MUTEX_32K>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		iommus = <&iommu M4U_PORT_MDP_RDMA1>;
+		mediatek,larb = <&larb4>;
+	};
+
+	mdp_rsz0: rsz@14003000 {
+		compatible = "mediatek,mt8173-mdp-rsz";
+		reg = <0 0x14003000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_RSZ0>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+	};
+
+	mdp_rsz1: rsz@14004000 {
+		compatible = "mediatek,mt8173-mdp-rsz";
+		reg = <0 0x14004000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_RSZ1>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+	};
+
+	mdp_rsz2: rsz@14005000 {
+		compatible = "mediatek,mt8173-mdp-rsz";
+		reg = <0 0x14005000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_RSZ2>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+	};
+
+	mdp_wdma0: wdma@14006000 {
+		compatible = "mediatek,mt8173-mdp-wdma";
+		reg = <0 0x14006000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_WDMA>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		iommus = <&iommu M4U_PORT_MDP_WDMA>;
+		mediatek,larb = <&larb0>;
+	};
+
+	mdp_wrot0: wrot@14007000 {
+		compatible = "mediatek,mt8173-mdp-wrot";
+		reg = <0 0x14007000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_WROT0>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		iommus = <&iommu M4U_PORT_MDP_WROT0>;
+		mediatek,larb = <&larb0>;
+	};
+
+	mdp_wrot1: wrot@14008000 {
+		compatible = "mediatek,mt8173-mdp-wrot";
+		reg = <0 0x14008000 0 0x1000>;
+		clocks = <&mmsys CLK_MM_MDP_WROT1>;
+		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
+		iommus = <&iommu M4U_PORT_MDP_WROT1>;
+		mediatek,larb = <&larb4>;
+	};
-- 
1.7.9.5

