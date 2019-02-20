Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D597CC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEBC421773
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 07:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfBTHxT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:53:19 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:61833 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726120AbfBTHxT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 02:53:19 -0500
X-UUID: 1cdcbf8917784721bc78365995d974fc-20190220
X-UUID: 1cdcbf8917784721bc78365995d974fc-20190220
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <jerry-ch.chen@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 827404719; Wed, 20 Feb 2019 15:53:10 +0800
Received: from MTKMBS06N1.mediatek.inc (172.21.101.129) by
 mtkexhb02.mediatek.inc (172.21.101.103) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:53:09 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs06n1.mediatek.inc (172.21.101.129) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 20 Feb 2019 15:53:08 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 20 Feb 2019 15:53:08 +0800
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
Subject: [RFC PATCH V0 5/7] dts: arm64: mt8183: Add FD nodes
Date:   Wed, 20 Feb 2019 15:48:11 +0800
Message-ID: <1550648893-42050-6-git-send-email-Jerry-Ch.chen@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
References: <1550648893-42050-1-git-send-email-Jerry-Ch.chen@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch adds nodes for Face Detection (FD) unit. FD is embedded
in Mediatek SoCs and works with the co-processor to perform face
detection on the input data and image and output detected face result.

Signed-off-by: Jerry-ch Chen <jerry-ch.chen@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index b3d8dfd..45c7e2f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -440,6 +440,26 @@
 			#clock-cells = <1>;
 		};
 
+		fd_smem: fd_smem {
+			compatible = "mediatek,fd_smem";
+			mediatek,larb = <&larb5>;
+			iommus = <&iommu M4U_PORT_CAM_IMGI>;
+		};
+
+		fd:fd@1502b000 {
+			compatible = "mediatek,fd";
+			mediatek,larb = <&larb5>;
+			mediatek,vpu = <&vpu>;
+			iommus = <&iommu M4U_PORT_CAM_FDVT_RP>,
+				 <&iommu M4U_PORT_CAM_FDVT_WR>,
+				 <&iommu M4U_PORT_CAM_FDVT_RB>;
+			reg = <0 0x1502b000 0 0x1000>;
+			interrupts = <GIC_SPI 269 IRQ_TYPE_LEVEL_LOW>;
+			clocks = <&imgsys CLK_IMG_FDVT>;
+			clock-names = "FD_CLK_IMG_FD";
+			smem_device = <&fd_smem>;
+		};
+
 		vdecsys: syscon@16000000 {
 			compatible = "mediatek,mt8183-vdecsys", "syscon";
 			reg = <0 0x16000000 0 0x1000>;
-- 
1.9.1

