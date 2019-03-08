Return-Path: <SRS0=k2dg=RL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B112EC4360F
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:52:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79F7920857
	for <linux-media@archiver.kernel.org>; Fri,  8 Mar 2019 23:52:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbfCHXwY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Mar 2019 18:52:24 -0500
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:34061 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726233AbfCHXwY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Mar 2019 18:52:24 -0500
X-Halon-ID: 33c4f4bc-41fd-11e9-846a-005056917a89
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-01.atm.binero.net (Halon) with ESMTPA
        id 33c4f4bc-41fd-11e9-846a-005056917a89;
        Sat, 09 Mar 2019 00:52:20 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Date:   Sat,  9 Mar 2019 00:51:57 +0100
Message-Id: <20190308235157.26357-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Depending on which video standard is used the driver needs to setup the
hardware to correctly handle fields. If stream is identified as NTSC
or PAL setup field detection and propagate the field detection signal.

Later versions of the datasheet have been updated to make it clear
that FLD register should be set to 0 when dealing with non-interlaced
field formats.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

---

Hi,

This patch depends on [PATCH v2 0/2] rcar-csi2: Use standby mode instead of resetting


diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 7a1c9b549e0fffc6..d9b29dbbcc2949de 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -475,7 +475,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 {
 	const struct rcar_csi2_format *format;
-	u32 phycnt, vcdt = 0, vcdt2 = 0;
+	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
 	unsigned int i;
 	int mbps, ret;
 
@@ -507,6 +507,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 			vcdt2 |= vcdt_part << ((i % 2) * 16);
 	}
 
+	if (priv->mf.field != V4L2_FIELD_NONE &&
+	    (priv->mf.height == 240 || priv->mf.height == 288)) {
+		fld =  FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN;
+
+		if (priv->mf.height == 240)
+			fld |= FLD_FLD_NUM(2);
+		else
+			fld |= FLD_FLD_NUM(1);
+	}
+
 	phycnt = PHYCNT_ENABLECLK;
 	phycnt |= (1 << priv->lanes) - 1;
 
@@ -519,8 +529,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 	rcsi2_write(priv, PHTC_REG, 0);
 
 	/* Configure */
-	rcsi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
-		    FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
+	rcsi2_write(priv, FLD_REG, fld);
 	rcsi2_write(priv, VCDT_REG, vcdt);
 	if (vcdt2)
 		rcsi2_write(priv, VCDT2_REG, vcdt2);
-- 
2.21.0

