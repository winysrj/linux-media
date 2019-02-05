Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BB9C282CC
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41CA52175B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbfBEGnc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:43:32 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:36811 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726956AbfBEGn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:43:29 -0500
X-UUID: f7d793d229434f0ab3b349d403a2d31c-20190205
X-UUID: f7d793d229434f0ab3b349d403a2d31c-20190205
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 935287863; Tue, 05 Feb 2019 14:43:21 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:20 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 5 Feb 2019 14:43:20 +0800
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
Subject: [RFC PATCH V0 3/7] [media] dt-bindings: mt8183: Added CAM-SMEM dt-bindings
Date:   Tue, 5 Feb 2019 14:42:42 +0800
Message-ID: <1549348966-14451-4-git-send-email-frederic.chen@mediatek.com>
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

This patch adds the DT binding documentation for the shared memory
between Pass 1 unit of the camera ISP system and the co-processor
in Mediatek SoCs.

Signed-off-by: Jungo Lin <jungo.lin@mediatek.com>
Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 .../bindings/media/mediatek,cam_smem.txt           | 32 ++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,cam_smem.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek,cam_smem.txt b/Documentation/devicetree/bindings/media/mediatek,cam_smem.txt
new file mode 100644
index 0000000..d0d9c17
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek,cam_smem.txt
@@ -0,0 +1,32 @@
+Mediatek Camera ISP Pass 1 Shared Memory Device
+
+Mediatek Camera ISP Pass 1 Shared Memory Device is used to manage shared
+memory among CPU, Camera ISP Pass 1 hardware and coprocessor. The Camera
+ISP Pass 1 is a hardware unit for processing image signal from the image
+sensor. Camera ISP Pass 1 is responsible for RAW processing and 3A tuning.
+
+It is associated with a reserved memory region
+(Please see Documentation\devicetree\bindings\reserved-memory\mediatek,
+reserve-memory-cam_smem.txt) and and provides the context to
+allocate memory with dma addresses.
+
+Required properties:
+- compatible: Should be "mediatek,cam_smem"
+
+- iommus: should point to the respective IOMMU block with master port
+  as argument, see Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
+  for details.
+
+- mediatek,larb: must contain the local arbiters in the current SOCs, see
+  Documentation/devicetree/bindings/memory-controllers/mediatek,smi-larb.txt
+  for details.
+
+Example:
+	cam_smem: cam_smem {
+		compatible = "mediatek,cam_smem";
+		mediatek,larb = <&larb3>,
+				<&larb6>;
+		iommus = <&iommu M4U_PORT_CAM_LSCI0>,
+				<&iommu M4U_PORT_CAM_LSCI1>,
+				<&iommu M4U_PORT_CAM_BPCI>;
+	};
-- 
1.9.1

