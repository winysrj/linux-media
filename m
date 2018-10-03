Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbeJCP5P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Oct 2018 11:57:15 -0400
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
Subject: [PATCH 3/4] [media] dt-bindings: mediatek: Add JPEG Decoder binding for MT7623
Date: Wed,  3 Oct 2018 11:09:11 +0200
Message-Id: <20181003090912.30501-4-matthias.bgg@gmail.com>
In-Reply-To: <20181003090912.30501-1-matthias.bgg@gmail.com>
References: <20181003090912.30501-1-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a binding documentation for the JPEG Decoder of the
MT7623 SoC.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 .../devicetree/bindings/media/mediatek-jpeg-decoder.txt          | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt b/Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
index 3813947b4d4f..044b11913c49 100644
--- a/Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
+++ b/Documentation/devicetree/bindings/media/mediatek-jpeg-decoder.txt
@@ -5,6 +5,7 @@ Mediatek JPEG Decoder is the JPEG decode hardware present in Mediatek SoCs
 Required properties:
 - compatible : must be one of the following string:
 	"mediatek,mt8173-jpgdec"
+	"mediatek,mt7623-jpgdec", "mediatek,mt2701-jpgdec"
 	"mediatek,mt2701-jpgdec"
 - reg : physical base address of the jpeg decoder registers and length of
   memory mapped region.
-- 
2.19.0
