Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3932EC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07830206BA
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfCLXu3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:50:29 -0400
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:40973 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726880AbfCLXu3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 19:50:29 -0400
X-Halon-ID: 9bbfbb6c-4521-11e9-8144-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 9bbfbb6c-4521-11e9-8144-0050569116f7;
        Wed, 13 Mar 2019 00:50:27 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ulrich Hecht <uli+renesas@fpond.eu>
Subject: [PATCH v3 1/3] rcar-csi2: Update V3M and E3 start procedure
Date:   Wed, 13 Mar 2019 00:50:17 +0100
Message-Id: <20190312235019.23420-2-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190312235019.23420-1-niklas.soderlund+renesas@ragnatech.se>
References: <20190312235019.23420-1-niklas.soderlund+renesas@ragnatech.se>
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
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 6c7c7e6072ffb09e..aaf35afc6c87b3c0 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -923,11 +923,11 @@ static int rcsi2_init_phtw_v3m_e3(struct rcar_csi2 *priv, unsigned int mbps)
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
2.21.0

