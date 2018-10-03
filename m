Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbeJCP5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 11:57:19 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, joro@8bytes.org,
        arnd@arndb.de
Cc: rick.chang@mediatek.com, bin.liu@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, sboyd@codeaurora.org,
        sean.wang@mediatek.com, chen.zhong@mediatek.com,
        weiyi.lu@mediatek.com, ryder.lee@mediatek.com,
        yong.wu@mediatek.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 4/4] dt-bindings: mediatek: Add bindig for MT7623 IOMMU and SMI
Date: Wed,  3 Oct 2018 11:09:12 +0200
Message-Id: <20181003090912.30501-5-matthias.bgg@gmail.com>
In-Reply-To: <20181003090912.30501-1-matthias.bgg@gmail.com>
References: <20181003090912.30501-1-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch add the binding documentation for the iommu and smi
devices on the MT7623 SoC.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../bindings/memory-controllers/mediatek,smi-common.txt        | 1 +
 .../bindings/memory-controllers/mediatek,smi-larb.txt          | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.txt b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.txt
index 615abdd0eb0d..e937ddd871a6 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-common.txt
@@ -17,6 +17,7 @@ Required properties:
 - compatible : must be one of :
 	"mediatek,mt2701-smi-common"
 	"mediatek,mt2712-smi-common"
+	"mediatek,mt7623-smi-common", "mediatek,mt2701-smi-common"
 	"mediatek,mt8173-smi-common"
 - reg : the register and size of the SMI block.
 - power-domains : a phandle to the power domain of this local arbiter.
diff --git a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
index 083155cdc2a0..94eddcae77ab 100644
--- a/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
@@ -6,6 +6,7 @@ Required properties:
 - compatible : must be one of :
 		"mediatek,mt2701-smi-larb"
 		"mediatek,mt2712-smi-larb"
+		"mediatek,mt7623-smi-larb", "mediatek,mt2701-smi-larb"
 		"mediatek,mt8173-smi-larb"
 - reg : the register and size of this local arbiter.
 - mediatek,smi : a phandle to the smi_common node.
@@ -16,7 +17,7 @@ Required properties:
 	    the register.
   - "smi" : It's the clock for transfer data and command.
 
-Required property for mt2701 and mt2712:
+Required property for mt2701, mt2712 and mt7623:
 - mediatek,larb-id :the hardware id of this larb.
 
 Example:
-- 
2.19.0
