Return-Path: <SRS0=NzSx=OO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_RHS_DOB,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8951EC04EB9
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 568BC206B7
	for <linux-media@archiver.kernel.org>; Wed,  5 Dec 2018 09:26:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 568BC206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbeLEJZw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 5 Dec 2018 04:25:52 -0500
Received: from mail.bootlin.com ([62.4.15.54]:39880 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbeLEJZ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Dec 2018 04:25:27 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id A74C220E39; Wed,  5 Dec 2018 10:25:24 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-79-44.w90-88.abo.wanadoo.fr [90.88.21.44])
        by mail.bootlin.com (Postfix) with ESMTPSA id BCE7920A59;
        Wed,  5 Dec 2018 10:25:06 +0100 (CET)
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
Subject: [PATCH v2 12/15] media: cedrus: Add device-tree compatible and variant for H5 support
Date:   Wed,  5 Dec 2018 10:24:41 +0100
Message-Id: <20181205092444.29497-13-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
References: <20181205092444.29497-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Add the necessary compatible for supporting the H5 SoC along with a
description of the capabilities of this variant.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index 82558455384a..f04b9bf23774 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -388,6 +388,10 @@ static const struct cedrus_variant sun8i_h3_cedrus_variant = {
 	.capabilities	= CEDRUS_CAPABILITY_UNTILED,
 };
 
+static const struct cedrus_variant sun50i_h5_cedrus_variant = {
+	.capabilities	= CEDRUS_CAPABILITY_UNTILED,
+};
+
 static const struct of_device_id cedrus_dt_match[] = {
 	{
 		.compatible = "allwinner,sun4i-a10-video-engine",
@@ -409,6 +413,10 @@ static const struct of_device_id cedrus_dt_match[] = {
 		.compatible = "allwinner,sun8i-h3-video-engine",
 		.data = &sun8i_h3_cedrus_variant,
 	},
+	{
+		.compatible = "allwinner,sun50i-h5-video-engine",
+		.data = &sun50i_h5_cedrus_variant,
+	},
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, cedrus_dt_match);
-- 
2.19.2

