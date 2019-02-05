Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F96BC282D7
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A8152145D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfBEGn3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:43:29 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:57419 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726416AbfBEGn2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:43:28 -0500
X-UUID: 1325cc3a9ba04033b173ada8128e629c-20190205
X-UUID: 1325cc3a9ba04033b173ada8128e629c-20190205
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1925219229; Tue, 05 Feb 2019 14:43:22 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:21 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 5 Feb 2019 14:43:21 +0800
From:   Frederic Chen <frederic.chen@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>
CC:     <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <yuzhao@chromium.org>,
        <zwisler@chromium.org>
Subject: [RFC PATCH V0 4/7] [media] dt-bindings: mt8183: Added camera ISP Pass 1 dt-bindings
Date:   Tue, 5 Feb 2019 14:42:43 +0800
Message-ID: <1549348966-14451-5-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Jungo Lin <jungo.lin@mediatek.com>

This patch adds DT binding document for the Pass 1 (P1) unit in
Mediatek's camera ISP system. The Pass 1 unit grabs the sensor data
out from the sensor interface, applies ISP effects and writes the
image data to DRAM.

Signed-off-by: Jungo Lin <jungo.lin@mediatek.com>
Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 .../bindings/media/mediatek,mt8183-camisp.txt      | 59 ++++++++++++++++++++++
 1 file changed, 59 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-camisp.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek,mt8183-camisp.txt b/Documentation/devicetree/bindings/media/mediatek,mt8183-camisp.txt
new file mode 100644
index 0000000..ba16b4e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek,mt8183-camisp.txt
@@ -0,0 +1,59 @@
+* Mediatek Image Signal Processor Pass 1 (ISP P1)
+
+The Pass 1 unit of Mediatek's camera ISP system grabs the sensor data out
+from the sensor interface, applies ISP effects and writes the image data
+to DRAM. Furthermore, Pass 1 unit has the ability to output two different
+resolutions frames at the same time to increase the performance of the
+camera application.
+
+Required properties:
+- compatible: "mediatek,mt8183-camisp" for MT8183
+- reg: Must contain an entry for each entry in reg-names.
+- interrupts: interrupt number to the cpu.
+- iommus: should point to the respective IOMMU block with master port
+  as argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
+  for details.
+- power-domains : a phandle to the power domain of this local arbiter.
+- mediatek,smi : a phandle to the smi_common node.
+- clocks: device clocks, see
+  Documentation/devicetree/bindings/clock/clock-bindings.txt for details.
+- clock-names: must be "CAMSYS_CAM_CGPDN" and "CAMSYS_CAMTG_CGPDN".
+- mediatek,larb: must contain the local arbiters in the current SOCs, see
+  Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
+  for details.
+- mediatek,vpu : the node of video processor unit
+- smem_device : the shared memory device managing the shared memory between
+  Pass 1 unit and the video processor unit
+
+Example:
+	camisp: camisp@1a000000 {
+		compatible = "mediatek,mt8183-camisp", "syscon";
+		reg = <0 0x1a000000 0 0x1000>,
+		      <0 0x1a003000 0 0x1000>,
+		      <0 0x1a004000 0 0x2000>,
+		      <0 0x1a006000 0 0x2000>;
+		reg-names = "camisp",
+		            "cam1",
+		            "cam2",
+		            "cam3";
+		interrupts = <GIC_SPI 253 IRQ_TYPE_LEVEL_LOW>,
+				<GIC_SPI 254 IRQ_TYPE_LEVEL_LOW>,
+				<GIC_SPI 255 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "cam1",
+		            "cam2",
+		            "cam3";
+		iommus = <&iommu M4U_PORT_CAM_LSCI0>,
+				<&iommu M4U_PORT_CAM_LSCI1>,
+				<&iommu M4U_PORT_CAM_BPCI>;
+		#clock-cells = <1>;
+		power-domains = <&scpsys MT8183_POWER_DOMAIN_CAM>;
+		/* Camera CCF */
+		clocks = <&camsys CLK_CAM_CAM>,
+				<&camsys CLK_CAM_CAMTG>;
+		clock-names = "CAMSYS_CAM_CGPDN",
+				"CAMSYS_CAMTG_CGPDN";
+		mediatek,larb = <&larb3>,
+				<&larb6>;
+		mediatek,vpu = <&vpu>;
+		smem_device = <&cam_smem>;
+	};
-- 
1.9.1

