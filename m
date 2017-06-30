Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:4879 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751787AbdF3GDV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 02:03:21 -0400
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <sean@mess.org>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH v1 1/4] dt-bindings: media: mtk-cir: Add support for MT7622 SoC
Date: Fri, 30 Jun 2017 14:03:04 +0800
Message-ID: <a778a3a33a273f00d3ff071d62fe672a207d949c.1498794408.git.sean.wang@mediatek.com>
In-Reply-To: <cover.1498794408.git.sean.wang@mediatek.com>
References: <cover.1498794408.git.sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

Document the devicetree bindings for CIR on MediaTek MT7622
SoC.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 Documentation/devicetree/bindings/media/mtk-cir.txt | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/mtk-cir.txt b/Documentation/devicetree/bindings/media/mtk-cir.txt
index 2be2005..5e18087 100644
--- a/Documentation/devicetree/bindings/media/mtk-cir.txt
+++ b/Documentation/devicetree/bindings/media/mtk-cir.txt
@@ -2,10 +2,14 @@ Device-Tree bindings for Mediatek consumer IR controller
 found in Mediatek SoC family
 
 Required properties:
-- compatible	    : "mediatek,mt7623-cir"
+- compatible	    : Should be
+			"mediatek,mt7623-cir": for MT7623 SoC
+			"mediatek,mt7622-cir": for MT7622 SoC
 - clocks	    : list of clock specifiers, corresponding to
 		      entries in clock-names property;
-- clock-names	    : should contain "clk" entries;
+- clock-names	    : should contain
+			- "clk" entries: for MT7623 SoC
+			- "clk", "bus" entries: for MT7622 SoC
 - interrupts	    : should contain IR IRQ number;
 - reg		    : should contain IO map address for IR.
 
-- 
2.7.4
