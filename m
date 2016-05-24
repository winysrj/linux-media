Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:20886 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503AbcEXNbw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 09:31:52 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Uli Middelberg <uli@middelberg.de>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v4 2/7] media: s5p-mfc: use generic reserved memory bindings
Date: Tue, 24 May 2016 15:31:25 +0200
Message-id: <1464096690-23605-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
References: <1464096690-23605-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use generic reserved memory bindings and mark old, custom properties
as obsoleted.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../devicetree/bindings/media/s5p-mfc.txt          | 39 +++++++++++++++++-----
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/s5p-mfc.txt b/Documentation/devicetree/bindings/media/s5p-mfc.txt
index 2d5787e..92c94f5 100644
--- a/Documentation/devicetree/bindings/media/s5p-mfc.txt
+++ b/Documentation/devicetree/bindings/media/s5p-mfc.txt
@@ -21,15 +21,18 @@ Required properties:
   - clock-names : from common clock binding: must contain "mfc",
 		  corresponding to entry in the clocks property.
 
-  - samsung,mfc-r : Base address of the first memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
-  - samsung,mfc-l : Base address of the second memory bank used by MFC
-		    for DMA contiguous memory allocation and its size.
-
 Optional properties:
   - power-domains : power-domain property defined with a phandle
 			   to respective power domain.
+  - memory-region : from reserved memory binding: phandles to two reserved
+	memory regions, first is for "left" mfc memory bus interfaces,
+	second if for the "right" mfc memory bus, used when no SYSMMU
+	support is available
+
+Obsolete properties:
+  - samsung,mfc-r, samsung,mfc-l : support removed, please use memory-region
+	property instead
+
 
 Example:
 SoC specific DT entry:
@@ -43,9 +46,29 @@ mfc: codec@13400000 {
 	clock-names = "mfc";
 };
 
+Reserved memory specific DT entry for given board (see reserved memory binding
+for more information):
+
+reserved-memory {
+	#address-cells = <1>;
+	#size-cells = <1>;
+	ranges;
+
+	mfc_left: region@51000000 {
+		compatible = "shared-dma-pool";
+		no-map;
+		reg = <0x51000000 0x800000>;
+	};
+
+	mfc_right: region@43000000 {
+		compatible = "shared-dma-pool";
+		no-map;
+		reg = <0x43000000 0x800000>;
+	};
+};
+
 Board specific DT entry:
 
 codec@13400000 {
-	samsung,mfc-r = <0x43000000 0x800000>;
-	samsung,mfc-l = <0x51000000 0x800000>;
+	memory-region = <&mfc_left>, <&mfc_right>;
 };
-- 
1.9.2

