Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5925 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S969445AbdAEQIL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 11:08:11 -0500
From: <sean.wang@mediatek.com>
To: <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>
CC: <andi.shyti@samsung.com>, <hverkuil@xs4all.nl>, <sean@mess.org>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 1/2] Documentation: devicetree: Add document bindings for mtk-cir
Date: Fri, 6 Jan 2017 00:06:23 +0800
Message-ID: <1483632384-8107-2-git-send-email-sean.wang@mediatek.com>
In-Reply-To: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sean Wang <sean.wang@mediatek.com>

This patch adds documentation for devicetree bindings for
Mediatek IR controller.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
---
 .../devicetree/bindings/media/mtk-cir.txt          | 23 ++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 linux-4.8.rc1_p0/Documentation/devicetree/bindings/media/mtk-cir.txt

diff --git a/Documentation/devicetree/bindings/media/mtk-cir.txt b/Documentation/devicetree/bindings/media/mtk-cir.txt
new file mode 100644
index 0000000..bbedd71
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mtk-cir.txt
@@ -0,0 +1,23 @@
+Device-Tree bindings for Mediatek IR controller found in Mediatek SoC family
+
+Required properties:
+- compatible	    : "mediatek,mt7623-ir"
+- clocks	    : list of clock specifiers, corresponding to
+		      entries in clock-names property;
+- clock-names	    : should contain "clk" entries;
+- interrupts	    : should contain IR IRQ number;
+- reg		    : should contain IO map address for IR.
+
+Optional properties:
+- linux,rc-map-name : Remote control map name.
+
+Example:
+
+cir: cir@0x10013000 {
+	compatible = "mediatek,mt7623-ir";
+	reg = <0 0x10013000 0 0x1000>;
+	interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_LOW>;
+	clocks = <&infracfg CLK_INFRA_IRRX>;
+	clock-names = "clk";
+	linux,rc-map-name = "rc-rc6-mce";
+};
-- 
1.9.1

