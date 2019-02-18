Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F7B2C10F01
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 142EA2146F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 10:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbfBRKFl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 05:05:41 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:28198 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729166AbfBRKFl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 05:05:41 -0500
X-Halon-ID: bc8a8d3d-3364-11e9-b5ae-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id bc8a8d3d-3364-11e9-b5ae-0050569116f7;
        Mon, 18 Feb 2019 11:05:37 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH 3/3] rcar-csi2: Move setting of Field Detection Control Register
Date:   Mon, 18 Feb 2019 11:03:13 +0100
Message-Id: <20190218100313.14529-4-niklas.soderlund+renesas@ragnatech.se>
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

Latest datasheet (rev 1.50) clarifies that the FLD register should be
set after LINKCNT.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 50486301c21b4bae..f90b380478775015 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -545,7 +545,6 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHTC_REG, 0);
 
 	/* Configure */
-	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, VCDT_REG, vcdt);
 	if (vcdt2)
 		rcsi2_write(priv, VCDT2_REG, vcdt2);
@@ -576,6 +575,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHYCNT_REG, phycnt);
 	rcsi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
 		    LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
+	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
 	rcsi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ | PHYCNT_RSTZ);
 
-- 
2.20.1

