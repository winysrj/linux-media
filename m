Return-Path: <SRS0=znln=PF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE273C43387
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 06:33:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A634A218F0
	for <linux-media@archiver.kernel.org>; Fri, 28 Dec 2018 06:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbeL1GdR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 28 Dec 2018 01:33:17 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:36229 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726143AbeL1GdR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Dec 2018 01:33:17 -0500
X-UUID: 1a09032d29cb4d28a16d856d37cd3bcf-20181228
X-UUID: 1a09032d29cb4d28a16d856d37cd3bcf-20181228
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <yunfei.dong@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 563086114; Fri, 28 Dec 2018 14:33:08 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 28 Dec 2018 14:33:06 +0800
Received: from localhost.localdomain (10.17.3.153) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 28 Dec 2018 14:33:06 +0800
From:   Yunfei Dong <yunfei.dong@mediatek.com>
To:     Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     Yunfei Dong <yunfei.dong@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Qianqian Yan <qianqian.yan@mediatek.com>
Subject: [PATCH 1/3] media: dt-bindings: media: Fix MTK document for vcodec
Date:   Fri, 28 Dec 2018 14:33:03 +0800
Message-ID: <1545978785-31375-1-git-send-email-yunfei.dong@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 615A63778B9FF5E7981ABA5EE4362CBD2764F8C1FD427C7370841448243143FD2000:8
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix MTK binding document for MT8173 dtsi changed in order
to use standard CCF interface.
MT8173 SoC from Mediatek.

Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
---
 .../devicetree/bindings/media/mediatek-vcodec.txt   | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
index 2a615d84a682..b6b5dde6abd8 100644
--- a/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
+++ b/Documentation/devicetree/bindings/media/mediatek-vcodec.txt
@@ -66,6 +66,15 @@ vcodec_dec: vcodec@16000000 {
                   "vencpll",
                   "venc_lt_sel",
                   "vdec_bus_clk_src";
+    assigned-clocks = <&topckgen CLK_TOP_VENC_LT_SEL>,
+                      <&topckgen CLK_TOP_CCI400_SEL>,
+                      <&topckgen CLK_TOP_VDEC_SEL>,
+                      <&apmixedsys CLK_APMIXED_VCODECPLL>,
+                      <&apmixedsys CLK_APMIXED_VENCPLL>;
+    assigned-clock-parents = <&topckgen CLK_TOP_VCODECPLL_370P5>,
+                             <&topckgen CLK_TOP_UNIVPLL_D2>,
+                             <&topckgen CLK_TOP_VCODECPLL>;
+    assigned-clock-rates = <0>, <0>, <0>, <1482000000>, <800000000>;
   };
 
   vcodec_enc: vcodec@18002000 {
@@ -105,4 +114,8 @@ vcodec_dec: vcodec@16000000 {
                   "venc_sel",
                   "venc_lt_sel_src",
                   "venc_lt_sel";
+    assigned-clocks = <&topckgen CLK_TOP_VENC_SEL>,
+                      <&topckgen CLK_TOP_VENC_LT_SEL>;
+    assigned-clock-parents = <&topckgen CLK_TOP_VENCPLL_D2>,
+                             <&topckgen CLK_TOP_UNIVPLL1_D2>;
   };
-- 
2.19.1

