Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6EFC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E642A2080D
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfBEGne (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:43:34 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:55634 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727966AbfBEGne (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:43:34 -0500
X-UUID: 238a2f9dd4114cc38d4a692ce5b2f48e-20190205
X-UUID: 238a2f9dd4114cc38d4a692ce5b2f48e-20190205
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1622095840; Tue, 05 Feb 2019 14:43:24 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs03n2.mediatek.inc (172.21.101.182) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 5 Feb 2019 14:43:16 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 5 Feb 2019 14:43:16 +0800
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
Subject: [RFC PATCH V0 1/7] [media] dt-bindings: mt8183: Add binding for ISP Pass 1 shared memory
Date:   Tue, 5 Feb 2019 14:42:40 +0800
Message-ID: <1549348966-14451-2-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
References: <1549348966-14451-1-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 71D25D377E8559684CD0A7C4FAE049DD288B7706DB62CB8DF3F5F8E9012CD7052000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds the binding for describing the shared memory
used to exchange configuration and tuning data between the
co-processor and Pass 1 (P1) unit of the camera ISP system on
Mediatek SoCs.

Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 .../mediatek,reserve-memory-cam_smem.txt           | 44 ++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-cam_smem.txt

diff --git a/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-cam_smem.txt b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-cam_smem.txt
new file mode 100644
index 0000000..05c1bf1
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/mediatek,reserve-memory-cam_smem.txt
@@ -0,0 +1,44 @@
+Mediatek ISP Pass 1 Shared Memory binding
+
+This binding describes the shared memory, which serves the purpose of
+describing the shared memory region used to exchange data between Pass 1
+unit of Image Signal Processor (ISP) and the co-processor in Mediatek
+SoCs.
+
+The co-processor doesn't have the iommu so we need to use the physical
+address to access the shared buffer in the firmware.
+
+The Pass 1 unit of ISP can access memory through the iommu so it
+uses the dma address to access the memory region.
+(See iommu/mediatek,iommu.txt for the detailed description of Mediatek IOMMU)
+
+
+Required properties:
+
+- compatible: must be "mediatek,reserve-memory-cam_smem"
+
+- reg: required for static allocation (see reserved-memory.txt for
+  the detailed usage)
+
+- alloc-range: required for dynamic allocation. The range must
+  between 0x00000400 and 0x100000000 due to the co-processer's
+  addressing limitation
+
+- size: required for dynamic allocation. The unit is bytes.
+
+
+Example:
+
+The following example shows the ISP Pass1 shared memory setup for MT8183.
+
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+		reserve-memory-cam_smem {
+			compatible = "mediatek,reserve-memory-cam_smem";
+			size = <0 0x1400000>;
+			alignment = <0 0x1000>;
+			alloc-ranges = <0 0x40000000 0 0x50000000>;
+		};
+	};
-- 
1.9.1

