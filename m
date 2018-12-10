Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 493CAC04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 160E820851
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:54:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 160E820851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=jmondi.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbeLJOyM (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 09:54:12 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44353 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbeLJOyM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 09:54:12 -0500
X-Originating-IP: 2.224.242.101
Received: from w540.lan (2-224-242-101.ip172.fastwebnet.it [2.224.242.101])
        (Authenticated sender: jacopo@jmondi.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 29E2360014;
        Mon, 10 Dec 2018 14:54:08 +0000 (UTC)
From:   Jacopo Mondi <jacopo+renesas@jmondi.org>
To:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH] media: rcar-csi2: Fix PHTW table values for E3/V3M
Date:   Mon, 10 Dec 2018 15:53:55 +0100
Message-Id: <1544453635-16359-1-git-send-email-jacopo+renesas@jmondi.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The PHTW selection algorithm implemented in rcsi2_phtw_write_mbps() checks for
lower bound of the interval used to match the desired bandwidth. Use that
in place of the currently used upport bound.

Fixes: 10c08812fe60 ("media: rcar: rcar-csi2: Update V3M/E3 PHTW tables")
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 62 ++++++++++++++---------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 80ad906d1136..7e9cb8bcfe70 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -152,37 +152,37 @@ static const struct rcsi2_mbps_reg phtw_mbps_h3_v3h_m3n[] = {
 };

 static const struct rcsi2_mbps_reg phtw_mbps_v3m_e3[] = {
-	{ .mbps =   89, .reg = 0x00 },
-	{ .mbps =   99, .reg = 0x20 },
-	{ .mbps =  109, .reg = 0x40 },
-	{ .mbps =  129, .reg = 0x02 },
-	{ .mbps =  139, .reg = 0x22 },
-	{ .mbps =  149, .reg = 0x42 },
-	{ .mbps =  169, .reg = 0x04 },
-	{ .mbps =  179, .reg = 0x24 },
-	{ .mbps =  199, .reg = 0x44 },
-	{ .mbps =  219, .reg = 0x06 },
-	{ .mbps =  239, .reg = 0x26 },
-	{ .mbps =  249, .reg = 0x46 },
-	{ .mbps =  269, .reg = 0x08 },
-	{ .mbps =  299, .reg = 0x28 },
-	{ .mbps =  329, .reg = 0x0a },
-	{ .mbps =  359, .reg = 0x2a },
-	{ .mbps =  399, .reg = 0x4a },
-	{ .mbps =  449, .reg = 0x0c },
-	{ .mbps =  499, .reg = 0x2c },
-	{ .mbps =  549, .reg = 0x0e },
-	{ .mbps =  599, .reg = 0x2e },
-	{ .mbps =  649, .reg = 0x10 },
-	{ .mbps =  699, .reg = 0x30 },
-	{ .mbps =  749, .reg = 0x12 },
-	{ .mbps =  799, .reg = 0x32 },
-	{ .mbps =  849, .reg = 0x52 },
-	{ .mbps =  899, .reg = 0x72 },
-	{ .mbps =  949, .reg = 0x14 },
-	{ .mbps =  999, .reg = 0x34 },
-	{ .mbps = 1049, .reg = 0x54 },
-	{ .mbps = 1099, .reg = 0x74 },
+	{ .mbps =   80, .reg = 0x00 },
+	{ .mbps =   90, .reg = 0x20 },
+	{ .mbps =  100, .reg = 0x40 },
+	{ .mbps =  110, .reg = 0x02 },
+	{ .mbps =  130, .reg = 0x22 },
+	{ .mbps =  140, .reg = 0x42 },
+	{ .mbps =  150, .reg = 0x04 },
+	{ .mbps =  170, .reg = 0x24 },
+	{ .mbps =  180, .reg = 0x44 },
+	{ .mbps =  200, .reg = 0x06 },
+	{ .mbps =  220, .reg = 0x26 },
+	{ .mbps =  240, .reg = 0x46 },
+	{ .mbps =  250, .reg = 0x08 },
+	{ .mbps =  270, .reg = 0x28 },
+	{ .mbps =  300, .reg = 0x0a },
+	{ .mbps =  330, .reg = 0x2a },
+	{ .mbps =  360, .reg = 0x4a },
+	{ .mbps =  400, .reg = 0x0c },
+	{ .mbps =  450, .reg = 0x2c },
+	{ .mbps =  500, .reg = 0x0e },
+	{ .mbps =  550, .reg = 0x2e },
+	{ .mbps =  600, .reg = 0x10 },
+	{ .mbps =  650, .reg = 0x30 },
+	{ .mbps =  700, .reg = 0x12 },
+	{ .mbps =  750, .reg = 0x32 },
+	{ .mbps =  800, .reg = 0x52 },
+	{ .mbps =  850, .reg = 0x72 },
+	{ .mbps =  900, .reg = 0x14 },
+	{ .mbps =  950, .reg = 0x34 },
+	{ .mbps = 1000, .reg = 0x54 },
+	{ .mbps = 1050, .reg = 0x74 },
 	{ .mbps = 1125, .reg = 0x16 },
 	{ /* sentinel */ },
 };
--
2.7.4

