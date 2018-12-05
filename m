Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D20C04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBEEC20878
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBEEC20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbeLEJZR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:17 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39765 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbeLEJZQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:16 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 3A68020510; Wed,  5 Dec 2018 10:25:14 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id D3DA920717;
        Wed,  5 Dec 2018 10:25:03 +0100 (CET)
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
Subject: [PATCH v2 02/15] ARM: dts: sun8i: a33: Remove unnecessary reserved memory node
Date:   Wed,  5 Dec 2018 10:24:31 +0100
Message-Id: <20181205092444.29497-3-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

While we believed that the memory for the video engine had to be kept
in the first 256 MiBs of DRAM, this is no longer true starting with the
A33 and any address can be mapped.

As a result, remove the reserved memory node and let the kernel allocate
the CMA pool wherever it sees fit.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 arch/arm/boot/dts/sun8i-a33.dtsi | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index c2c10cd4a210..9ac4fae6c10d 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -186,21 +186,6 @@
 		};
 	};
 
-	reserved-memory {
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		/* Address must be kept in the lower 256 MiBs of DRAM for VE. */
-		default-pool {
-			compatible = "shared-dma-pool";
-			size = <0x6000000>;
-			alloc-ranges = <0x4a000000 0x6000000>;
-			reusable;
-			linux,cma-default;
-		};
-	};
-
 	sound: sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "sun8i-a33-audio";
-- 
2.19.2

