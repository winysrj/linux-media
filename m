Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5757C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8066121773
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfBTHxN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:53:13 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:34977 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725765AbfBTHxN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 02:53:13 -0500
X-UUID: deb13cdba6e94696b999d06638598005-20190220
X-UUID: deb13cdba6e94696b999d06638598005-20190220
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <jerry-ch.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 516461948; Wed, 20 Feb 2019 15:53:08 +0800
Received: from MTKMBS06N2.mediatek.inc (172.21.101.130) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:53:08 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs06n2.mediatek.inc (172.21.101.130) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:53:07 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 20 Feb 2019 15:53:07 +0800
From:   Jerry-ch Chen <Jerry-Ch.chen@mediatek.com>
To:     <hans.verkuil@cisco.com>,
        <laurent.pinchart+renesas@ideasonboard.com>, <tfiga@chromium.org>,
        <matthias.bgg@gmail.com>, <mchehab@kernel.org>
CC:     <yuzhao@chromium.org>, <zwisler@chromium.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <Sean.Cheng@mediatek.com>,
        <sj.huang@mediatek.com>, <christie.yu@mediatek.com>,
        <holmes.chiou@mediatek.com>, <frederic.chen@mediatek.com>,
        <Jerry-ch.Chen@mediatek.com>, <jungo.lin@mediatek.com>,
        <Rynn.Wu@mediatek.com>, <linux-media@vger.kernel.org>,
        <srv_heupstream@mediatek.com>, <devicetree@vger.kernel.org>,
        Jerry-ch Chen <jerry-ch.chen@mediatek.com>
Subject: [RFC PATCH V0 4/7] [media] dt-bindings: mt8183: Added FD dt-bindings
Date:   Wed, 20 Feb 2019 15:48:10 +0800
Message-ID: <1550648893-42050-5-git-send-email-Jerry-Ch.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: D00B037DE5B09A9535FA6E07DB648BC8A9B799E9CB79082D304071DCDCD14E0D2000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds DT binding documentation for the Face Detection (FD)
unit of the camera system on Mediatek's SoCs.

Signed-off-by: Jerry-ch Chen <jerry-ch.chen@mediatek.com>
---
 .../bindings/media/mediatek,mt8183-fd.txt          | 30 ++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt

diff --git a/Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt b/Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt
new file mode 100644
index 0000000..d8dbb89
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/mediatek,mt8183-fd.txt
@@ -0,0 +1,30 @@
+* Mediatek Face Detection Unit (FD)
+
+Face Detection (FD) unit is a typical memory-to-memory HW device.
+It provides hardware accelerated face detection function, and it
+is able to detect different poses of faces. FD will writre result
+of detected face into memory as output.
+
+Required properties:
+- compatible: "mediatek,fd"
+- reg: Must contain an entry for each entry in reg-names.
+- reg-names: Must include the following entries:
+- interrupts: interrupt number to the cpu.
+- clocks : clock name from clock manager
+- clock-names: must be main. It is the main clock of FD
+
+Example:
+	fd:fd@1502b000 {
+		compatible = "mediatek,fd";
+		mediatek,larb = <&larb5>;
+		mediatek,vpu = <&vpu>;
+		iommus = <&iommu M4U_PORT_CAM_FDVT_RP>,
+			 <&iommu M4U_PORT_CAM_FDVT_WR>,
+			 <&iommu M4U_PORT_CAM_FDVT_RB>;
+		reg = <0 0x1502b000 0 0x1000>;
+		interrupts = <GIC_SPI 269 IRQ_TYPE_LEVEL_LOW>;
+		clocks = <&imgsys CLK_IMG_FDVT>;
+		clock-names = "FD_CLK_IMG_FDVT";
+		smem_device = <&fd_smem>;
+	};
+
-- 
1.9.1

