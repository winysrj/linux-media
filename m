Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:59427 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756303AbdDMHdQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Apr 2017 03:33:16 -0400
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
Subject: [PATCH 1/3] dt-bindings: mt8173: Fix mdp device tree
Date: Thu, 13 Apr 2017 15:33:05 +0800
Message-ID: <1492068787-17838-2-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1492068787-17838-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1492068787-17838-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the mdp_* nodes are under an mdp sub-node, their corresponding
platform device does not automatically get its iommu assigned properly.

Fix this by moving the mdp component nodes up a level such that they are
siblings of mdp and all other SoC subsystems.  This also simplifies the
device tree.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>

---
 Documentation/devicetree/bindings/media/mediatek-mdp.txt | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/mediatek-mdp.txt b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
index 4182063..0d03e3a 100644
--- a/Documentation/devicetree/bindings/media/mediatek-mdp.txt
+++ b/Documentation/devicetree/bindings/media/mediatek-mdp.txt
@@ -2,7 +2,7 @@
 
 Media Data Path is used for scaling and color space conversion.
 
-Required properties (controller (parent) node):
+Required properties (controller node):
 - compatible: "mediatek,mt8173-mdp"
 - mediatek,vpu: the node of video processor unit, see
   Documentation/devicetree/bindings/media/mediatek-vpu.txt for details.
@@ -32,21 +32,16 @@ Required properties (DMA function blocks, child node):
   for details.
 
 Example:
-mdp {
-	compatible = "mediatek,mt8173-mdp";
-	#address-cells = <2>;
-	#size-cells = <2>;
-	ranges;
-	mediatek,vpu = <&vpu>;
-
 	mdp_rdma0: rdma@14001000 {
 		compatible = "mediatek,mt8173-mdp-rdma";
+			     "mediatek,mt8173-mdp";
 		reg = <0 0x14001000 0 0x1000>;
 		clocks = <&mmsys CLK_MM_MDP_RDMA0>,
 			 <&mmsys CLK_MM_MUTEX_32K>;
 		power-domains = <&scpsys MT8173_POWER_DOMAIN_MM>;
 		iommus = <&iommu M4U_PORT_MDP_RDMA0>;
 		mediatek,larb = <&larb0>;
+		mediatek,vpu = <&vpu>;
 	};
 
 	mdp_rdma1: rdma@14002000 {
@@ -106,4 +101,3 @@ mdp {
 		iommus = <&iommu M4U_PORT_MDP_WROT1>;
 		mediatek,larb = <&larb4>;
 	};
-};
-- 
1.9.1
