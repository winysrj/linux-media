Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3BEC282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 870D121916
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 11:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfBALWI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 06:22:08 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:24426 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728316AbfBALWI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 06:22:08 -0500
X-UUID: 195c73ae84334c9f9f514e6ef63118a6-20190201
X-UUID: 195c73ae84334c9f9f514e6ef63118a6-20190201
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <frederic.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1839704010; Fri, 01 Feb 2019 19:22:01 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs03n1.mediatek.inc (172.21.101.181) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 1 Feb 2019 19:21:59 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 1 Feb 2019 19:22:00 +0800
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
        <srv_heupstream@mediatek.com>
Subject: [RFC PATCH V0 3/7] [media] dt-bindings: mt8183: Added DIP-SMEM dt-bindings
Date:   Fri, 1 Feb 2019 19:21:27 +0800
Message-ID: <1549020091-42064-4-git-send-email-frederic.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
References: <1549020091-42064-1-git-send-email-frederic.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds the DT binding documentation for the shared memory
between DIP (Digital Image Processing) unit of the camera ISP system
and the co-processor in Mediatek SoCs.

Signed-off-by: Frederic Chen <frederic.chen@mediatek.com>
---
 .../bindings/media/mediatek,dip_smem.txt           | 29 ++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,dip_smem.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
new file mode 100644
index 0000000..5533721
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek,dip_smem.txt
@@ -0,0 +1,29 @@
+Mediatek ISP Shared Memory Device
+
+Mediatek ISP Shared Memory Device is used to manage shared memory
+among CPU, ISP IPs and coprocessor. It is associated with a reserved
+memory region (Please see Documentation\devicetree\bindings\
+reserved-memory\mediatek,reserve-memory-isp_smem.txt) and
+and provide the context to allocate memory with dma addresses.
+
+Required properties:
+- compatible: Should be "mediatek,isp_smem"
+
+- iommus: should point to the respective IOMMU block with master port
+  as argument. Please set the ports which may be accessed
+  through the common path. You can see
+  Documentation/devicetree/bindings/iommu/mediatek,iommu.txt
+  for the detail.
+
+- mediatek,larb: must contain the local arbiters in the current Socs.
+  Please set the larb of camsys for Pass 1 and imgsys for DIP, or both
+  if you are using all the camera function. You can see
+  Documentation/devicetree/bindings/memory-controllers/
+  mediatek,smi-larb.txt for the detail.
+
+Example:
+	isp_smem: isp_smem {
+		compatible = "mediatek,isp_smem";
+		mediatek,larb = <&larb5>;
+		iommus = <&iommu M4U_PORT_CAM_IMGI>;
+	};
-- 
1.9.1

