Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45626C43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 03:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2108921872
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 03:06:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfADDGU (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 22:06:20 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:46062 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726418AbfADDGT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2019 22:06:19 -0500
X-UUID: bdb2d26b301a417cbc605ca980883c51-20190104
X-UUID: bdb2d26b301a417cbc605ca980883c51-20190104
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <yunfei.dong@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 350645939; Fri, 04 Jan 2019 11:06:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 4 Jan 2019 11:06:10 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 4 Jan 2019 11:06:10 +0800
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
Subject: [PATCH v2,1/3] media: dt-bindings: media: add 'assigned-clocks' to vcodec examples
Date:   Fri, 4 Jan 2019 11:05:59 +0800
Message-ID: <1546571161-11470-1-git-send-email-yunfei.dong@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
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
change note:
v2: modify subject
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

