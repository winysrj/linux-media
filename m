Return-Path: <SRS0=+L2G=PM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BE6C43387
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 03:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998A82184B
	for <linux-media@archiver.kernel.org>; Fri,  4 Jan 2019 03:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfADDG0 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 3 Jan 2019 22:06:26 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:14703 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726823AbfADDGU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2019 22:06:20 -0500
X-UUID: 48461f4e0ac34881adc7c1081d12f7b9-20190104
X-UUID: 48461f4e0ac34881adc7c1081d12f7b9-20190104
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <yunfei.dong@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1084433726; Fri, 04 Jan 2019 11:06:12 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 4 Jan 2019 11:06:11 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Fri, 4 Jan 2019 11:06:11 +0800
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
Subject: [PATCH v2,2/3] arm64: dts: Using standard CCF interface to set vcodec clk
Date:   Fri, 4 Jan 2019 11:06:00 +0800
Message-ID: <1546571161-11470-2-git-send-email-yunfei.dong@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1546571161-11470-1-git-send-email-yunfei.dong@mediatek.com>
References: <1546571161-11470-1-git-send-email-yunfei.dong@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Using standard CCF interface to set vdec/venc parent clk
and clk rate.

Signed-off-by: Yunfei Dong <yunfei.dong@mediatek.com>
Signed-off-by: Qianqian Yan <qianqian.yan@mediatek.com>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index abd2f15a544b..bbc282aae412 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -1295,6 +1295,15 @@
 				      "vencpll",
 				      "venc_lt_sel",
 				      "vdec_bus_clk_src";
+			assigned-clocks = <&topckgen CLK_TOP_VENC_LT_SEL>,
+					  <&topckgen CLK_TOP_CCI400_SEL>,
+					  <&topckgen CLK_TOP_VDEC_SEL>,
+					  <&apmixedsys CLK_APMIXED_VCODECPLL>,
+					  <&apmixedsys CLK_APMIXED_VENCPLL>;
+			assigned-clock-parents = <&topckgen CLK_TOP_VCODECPLL_370P5>,
+						 <&topckgen CLK_TOP_UNIVPLL_D2>,
+						 <&topckgen CLK_TOP_VCODECPLL>;
+			assigned-clock-rates = <0>, <0>, <0>, <1482000000>, <800000000>;
 		};
 
 		larb1: larb@16010000 {
@@ -1360,6 +1369,10 @@
 				      "venc_sel",
 				      "venc_lt_sel_src",
 				      "venc_lt_sel";
+			assigned-clocks = <&topckgen CLK_TOP_VENC_SEL>,
+					  <&topckgen CLK_TOP_VENC_LT_SEL>;
+			assigned-clock-parents = <&topckgen CLK_TOP_VENCPLL_D2>,
+						 <&topckgen CLK_TOP_UNIVPLL1_D2>;
 		};
 
 		vencltsys: clock-controller@19000000 {
-- 
2.19.1

