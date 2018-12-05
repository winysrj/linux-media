Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	URIBL_RHS_DOB,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6105FC04EBF
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2502A2082B
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2502A2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbeLEJZZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:25 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39787 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbeLEJZR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:17 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id CC9D020D23; Wed,  5 Dec 2018 10:25:14 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id 6A28220726;
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
Subject: [PATCH v2 04/15] soc: sunxi: sram: Enable EMAC clock access for H3 variant
Date:   Wed,  5 Dec 2018 10:24:33 +0100
Message-Id: <20181205092444.29497-5-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Just like the A64 and H5, the H3 SoC uses the system control block
to enable the EMAC clock.

Add a variant structure definition for the H3 and use it over the A10
one. This will allow using the H3-specific binding for the syscon node
attached to the EMAC instead of the generic syscon binding.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/soc/sunxi/sunxi_sram.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/sunxi/sunxi_sram.c b/drivers/soc/sunxi/sunxi_sram.c
index 71e3ee4a3f19..fd81a3c0db45 100644
--- a/drivers/soc/sunxi/sunxi_sram.c
+++ b/drivers/soc/sunxi/sunxi_sram.c
@@ -290,6 +290,10 @@ static const struct sunxi_sramc_variant sun4i_a10_sramc_variant = {
 	/* Nothing special */
 };
 
+static const struct sunxi_sramc_variant sun8i_h3_sramc_variant = {
+	.has_emac_clock = true,
+};
+
 static const struct sunxi_sramc_variant sun50i_a64_sramc_variant = {
 	.has_emac_clock = true,
 };
@@ -369,7 +373,7 @@ static const struct of_device_id sunxi_sram_dt_match[] = {
 	},
 	{
 		.compatible = "allwinner,sun8i-h3-system-control",
-		.data = &sun4i_a10_sramc_variant,
+		.data = &sun8i_h3_sramc_variant,
 	},
 	{
 		.compatible = "allwinner,sun50i-a64-sram-controller",
-- 
2.19.2

