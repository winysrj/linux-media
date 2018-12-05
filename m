Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_RHS_DOB,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B90C04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 063A3206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 063A3206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbeLEJZZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:25 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39779 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeLEJZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:17 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 812B920717; Wed,  5 Dec 2018 10:25:14 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 2504C2071D;
        Wed,  5 Dec 2018 10:25:04 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 03/15] ARM: dts: sun8i: h3: Remove unnecessary reserved memory node
Date:   Wed,  5 Dec 2018 10:24:32 +0100
Message-Id: <20181205092444.29497-4-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just like on the A33, the video engine on the H3 can map any address in
memory, so there is no particular need to have reserved memory at a fixed
address.

As a result, remove the reserved memory node and let the kernel allocate
the CMA pool wherever it sees fit.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index dbb7e71b6d69..e438e54580e1 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -119,20 +119,6 @@
 			     <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_LOW)>;
 	};
 
-	reserved-memory {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		default-pool {
-			compatible = "shared-dma-pool";
-			size = <0x6000000>;
-			alloc-ranges = <0x4a000000 0x6000000>;
-			reusable;
-			linux,cma-default;
-		};
-	};
-
 	soc {
 		system-control@1c00000 {
 			compatible = "allwinner,sun8i-h3-system-control";
-- 
2.19.2

