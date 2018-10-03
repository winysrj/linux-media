Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbeJCP5H (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 11:57:07 -0400
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
Subject: [PATCH 1/4] dt-bindings: clock: mediatek: add support for MT7623
Date: Wed,  3 Oct 2018 11:09:09 +0200
Message-Id: <20181003090912.30501-2-matthias.bgg@gmail.com>
In-Reply-To: <20181003090912.30501-1-matthias.bgg@gmail.com>
References: <20181003090912.30501-1-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds bindings for apmixedsys, audsys, bpsys, ethsys,
hifsys, imgsys, infracfg, mmsys, pericfg, topckgen and vdecsys
for MT6723.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../devicetree/bindings/arm/mediatek/mediatek,apmixedsys.txt     | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,audsys.txt         | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,bdpsys.txt         | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,ethsys.txt         | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,hifsys.txt         | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,imgsys.txt         | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,infracfg.txt       | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,mmsys.txt          | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,pericfg.txt        | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,topckgen.txt       | 1 +
 .../devicetree/bindings/arm/mediatek/mediatek,vdecsys.txt        | 1 +
 11 files changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,apmixedsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,apmixedsys.txt
index b404d592ce58..4e4a3c0ab9ab 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,apmixedsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,apmixedsys.txt
@@ -10,6 +10,7 @@ Required Properties:
 	- "mediatek,mt2712-apmixedsys", "syscon"
 	- "mediatek,mt6797-apmixedsys"
 	- "mediatek,mt7622-apmixedsys"
+	- "mediatek,mt7623-apmixedsys", "mediatek,mt2701-apmixedsys"
 	- "mediatek,mt8135-apmixedsys"
 	- "mediatek,mt8173-apmixedsys"
 - #clock-cells: Must be 1
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.txt
index 34a69ba67f13..d1606b2c3e63 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,audsys.txt
@@ -8,6 +8,7 @@ Required Properties:
 - compatible: Should be one of:
 	- "mediatek,mt2701-audsys", "syscon"
 	- "mediatek,mt7622-audsys", "syscon"
+	- "mediatek,mt7623-audsys", "mediatek,mt2701-audsys", "syscon"
 - #clock-cells: Must be 1
 
 The AUDSYS controller uses the common clk binding from
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,bdpsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,bdpsys.txt
index 4010e37c53a0..149567a38215 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,bdpsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,bdpsys.txt
@@ -8,6 +8,7 @@ Required Properties:
 - compatible: Should be:
 	- "mediatek,mt2701-bdpsys", "syscon"
 	- "mediatek,mt2712-bdpsys", "syscon"
+	- "mediatek,mt7623-bdpsys", "mediatek,mt2701-bdpsys", "syscon"
 - #clock-cells: Must be 1
 
 The bdpsys controller uses the common clk binding from
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,ethsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,ethsys.txt
index 8f5335b480ac..f17cfe64255d 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,ethsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,ethsys.txt
@@ -8,6 +8,7 @@ Required Properties:
 - compatible: Should be:
 	- "mediatek,mt2701-ethsys", "syscon"
 	- "mediatek,mt7622-ethsys", "syscon"
+	- "mediatek,mt7623-ethsys", "mediatek,mt2701-ethsys", "syscon"
 - #clock-cells: Must be 1
 - #reset-cells: Must be 1
 
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,hifsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,hifsys.txt
index f5629d64cef2..323905af82c3 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,hifsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,hifsys.txt
@@ -9,6 +9,7 @@ Required Properties:
 - compatible: Should be:
 	- "mediatek,mt2701-hifsys", "syscon"
 	- "mediatek,mt7622-hifsys", "syscon"
+	- "mediatek,mt7623-hifsys", "mediatek,mt2701-hifsys", "syscon"
 - #clock-cells: Must be 1
 
 The hifsys controller uses the common clk binding from
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,imgsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,imgsys.txt
index 868bd51a98be..3f99672163e3 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,imgsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,imgsys.txt
@@ -9,6 +9,7 @@ Required Properties:
 	- "mediatek,mt2701-imgsys", "syscon"
 	- "mediatek,mt2712-imgsys", "syscon"
 	- "mediatek,mt6797-imgsys", "syscon"
+	- "mediatek,mt7623-imgsys", "mediatek,mt2701-imgsys", "syscon"
 	- "mediatek,mt8173-imgsys", "syscon"
 - #clock-cells: Must be 1
 
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,infracfg.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,infracfg.txt
index 566f153f9f83..89f4272a1441 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,infracfg.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,infracfg.txt
@@ -11,6 +11,7 @@ Required Properties:
 	- "mediatek,mt2712-infracfg", "syscon"
 	- "mediatek,mt6797-infracfg", "syscon"
 	- "mediatek,mt7622-infracfg", "syscon"
+	- "mediatek,mt7623-infracfg", "mediatek,mt2701-infracfg", "syscon"
 	- "mediatek,mt8135-infracfg", "syscon"
 	- "mediatek,mt8173-infracfg", "syscon"
 - #clock-cells: Must be 1
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mmsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mmsys.txt
index 4eb8bbe15c01..15d977afad31 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mmsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mmsys.txt
@@ -9,6 +9,7 @@ Required Properties:
 	- "mediatek,mt2701-mmsys", "syscon"
 	- "mediatek,mt2712-mmsys", "syscon"
 	- "mediatek,mt6797-mmsys", "syscon"
+	- "mediatek,mt7623-mmsys", "mediatek,mt2701-mmsys", "syscon"
 	- "mediatek,mt8173-mmsys", "syscon"
 - #clock-cells: Must be 1
 
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
index fb58ca8c2770..6755514deb80 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
@@ -10,6 +10,7 @@ Required Properties:
 	- "mediatek,mt2701-pericfg", "syscon"
 	- "mediatek,mt2712-pericfg", "syscon"
 	- "mediatek,mt7622-pericfg", "syscon"
+	- "mediatek,mt7623-pericfg", "mediatek,mt2701-pericfg", "syscon"
 	- "mediatek,mt8135-pericfg", "syscon"
 	- "mediatek,mt8173-pericfg", "syscon"
 - #clock-cells: Must be 1
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,topckgen.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,topckgen.txt
index 24014a7e2332..d849465b8c99 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,topckgen.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,topckgen.txt
@@ -10,6 +10,7 @@ Required Properties:
 	- "mediatek,mt2712-topckgen", "syscon"
 	- "mediatek,mt6797-topckgen"
 	- "mediatek,mt7622-topckgen"
+	- "mediatek,mt7623-topckgen", "mediatek,mt2701-topckgen"
 	- "mediatek,mt8135-topckgen"
 	- "mediatek,mt8173-topckgen"
 - #clock-cells: Must be 1
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,vdecsys.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,vdecsys.txt
index ea40d05089f8..3212afc753c8 100644
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,vdecsys.txt
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,vdecsys.txt
@@ -9,6 +9,7 @@ Required Properties:
 	- "mediatek,mt2701-vdecsys", "syscon"
 	- "mediatek,mt2712-vdecsys", "syscon"
 	- "mediatek,mt6797-vdecsys", "syscon"
+	- "mediatek,mt7623-vdecsys", "mediatek,mt2701-vdecsys", "syscon"
 	- "mediatek,mt8173-vdecsys", "syscon"
 - #clock-cells: Must be 1
 
-- 
2.19.0
