Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BD7C10F0C
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9E920684
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:57:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfCHX5Q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:57:16 -0500
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:51650 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfCHX5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2019 18:57:16 -0500
X-Halon-ID: e37b4326-41fd-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id e37b4326-41fd-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:57:11 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 2/3] rcar-csi2: Update start procedure for H3 ES2
Date:   Sat,  9 Mar 2019 00:57:01 +0100
Message-Id: <20190308235702.27057-3-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
References: <20190308235702.27057-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Latest information from hardware engineers reveals that H3 ES2 and ES3
behave differently when working with link speeds bellow 250 Mpbs.
Add a SoC match for H3 ES2.* and use the correct startup sequence.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 39 ++++++++++++++++++---
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 6be81d4839f35a0e..07d5c8c66b7cd382 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -914,6 +914,25 @@ static int rcsi2_init_phtw_h3_v3h_m3n(struct rcar_csi2 *priv, unsigned int mbps)
 	return rcsi2_phtw_write_array(priv, step2);
 }
 
+static int rcsi2_init_phtw_h3es2(struct rcar_csi2 *priv, unsigned int mbps)
+{
+	static const struct phtw_value step1[] = {
+		{ .data = 0xcc, .code = 0xe2 },
+		{ .data = 0x01, .code = 0xe3 },
+		{ .data = 0x11, .code = 0xe4 },
+		{ .data = 0x01, .code = 0xe5 },
+		{ .data = 0x10, .code = 0x04 },
+		{ .data = 0x38, .code = 0x08 },
+		{ .data = 0x01, .code = 0x00 },
+		{ .data = 0x4b, .code = 0xac },
+		{ .data = 0x03, .code = 0x00 },
+		{ .data = 0x80, .code = 0x07 },
+		{ /* sentinel */ },
+	};
+
+	return rcsi2_phtw_write_array(priv, step1);
+}
+
 static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
 {
 	return rcsi2_phtw_write_mbps(priv, mbps, phtw_mbps_v3m_e3, 0x44);
@@ -976,6 +995,14 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a7795es1 = {
 	.num_channels = 4,
 };
 
+static const struct rcar_csi2_info rcar_csi2_info_r8a7795es2 = {
+	.init_phtw = rcsi2_init_phtw_h3es2,
+	.hsfreqrange = hsfreqrange_h3_v3h_m3n,
+	.csi0clkfreqrange = 0x20,
+	.num_channels = 4,
+	.clear_ulps = true,
+};
+
 static const struct rcar_csi2_info rcar_csi2_info_r8a7796 = {
 	.hsfreqrange = hsfreqrange_m3w_h3es1,
 	.num_channels = 4,
@@ -1041,11 +1068,15 @@ static const struct of_device_id rcar_csi2_of_table[] = {
 };
 MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
 
-static const struct soc_device_attribute r8a7795es1[] = {
+static const struct soc_device_attribute r8a7795[] = {
 	{
 		.soc_id = "r8a7795", .revision = "ES1.*",
 		.data = &rcar_csi2_info_r8a7795es1,
 	},
+	{
+		.soc_id = "r8a7795", .revision = "ES2.*",
+		.data = &rcar_csi2_info_r8a7795es2,
+	},
 	{ /* sentinel */ },
 };
 
@@ -1063,10 +1094,10 @@ static int rcsi2_probe(struct platform_device *pdev)
 	priv->info = of_device_get_match_data(&pdev->dev);
 
 	/*
-	 * r8a7795 ES1.x behaves differently than the ES2.0+ but doesn't
-	 * have it's own compatible string.
+	 * The different ES versions of r8a7795 (H3) behave differently but
+	 * share the same compatible string.
 	 */
-	attr = soc_device_match(r8a7795es1);
+	attr = soc_device_match(r8a7795);
 	if (attr)
 		priv->info = attr->data;
 
-- 
2.21.0

