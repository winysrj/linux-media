Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1779EC10F0B
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D92B1206BA
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfCLXuc (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:50:32 -0400
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:43002 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfCLXub (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 19:50:31 -0400
X-Halon-ID: 9dde0dca-4521-11e9-8144-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 9dde0dca-4521-11e9-8144-0050569116f7;
        Wed, 13 Mar 2019 00:50:30 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Ulrich Hecht <uli+renesas@fpond.eu>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 3/3] rcar-csi2: Move setting of Field Detection Control Register
Date:   Wed, 13 Mar 2019 00:50:19 +0100
Message-Id: <20190312235019.23420-4-niklas.soderlund+renesas@ragnatech.se>
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

Later datasheet versions (rev 1.00) clarifies that the FLD register
should be set after LINKCNT.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Ulrich Hecht <uli+renesas@fpond.eu>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 0a4a71be60bee89b..b8017743b2dcfb08 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -530,7 +530,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHTC_REG, 0);
 
 	/* Configure */
-	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, VCDT_REG, vcdt);
 	if (vcdt2)
 		rcsi2_write(priv, VCDT2_REG, vcdt2);
@@ -561,6 +560,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHYCNT_REG, phycnt);
 	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
 		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
+	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
 	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
 
-- 
2.21.0

