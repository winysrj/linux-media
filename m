Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CBBC43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C9B02146F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbfBRKFh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:05:37 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:63404 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728909AbfBRKFg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 05:05:36 -0500
X-Halon-ID: b999f3af-3364-11e9-b5ae-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id b999f3af-3364-11e9-b5ae-0050569116f7;
        Mon, 18 Feb 2019 11:05:32 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 1/3] rcar-csi2: Update V3M and E3 start procedure
Date:   Mon, 18 Feb 2019 11:03:11 +0100
Message-Id: <20190218100313.14529-2-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
References: <20190218100313.14529-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The latest datasheet (rev 1.50) updates the start procedure for V3M and
E3. Update the driver to match these changes.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 664d3784be2b9db9..fbbe86a7a0fe14ab 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -940,11 +940,11 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
 static int rcsi2_confirm_start_v3m_e3(struct rcar_csi2 *priv)
 {
 	static const struct phtw_value step1[] = {
-		{ .data = 0xed, .code = 0x34 },
-		{ .data = 0xed, .code = 0x44 },
-		{ .data = 0xed, .code = 0x54 },
-		{ .data = 0xed, .code = 0x84 },
-		{ .data = 0xed, .code = 0x94 },
+		{ .data = 0xee, .code = 0x34 },
+		{ .data = 0xee, .code = 0x44 },
+		{ .data = 0xee, .code = 0x54 },
+		{ .data = 0xee, .code = 0x84 },
+		{ .data = 0xee, .code = 0x94 },
 		{ /* sentinel */ },
 	};
 
-- 
2.20.1

