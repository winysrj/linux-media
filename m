Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82035C10F00
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 525F6206BA
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 23:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfCLXuQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 19:50:16 -0400
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:12010 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfCLXuQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 19:50:16 -0400
X-Halon-ID: 922b383d-4521-11e9-8144-0050569116f7
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (unknown [89.233.230.99])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPA
        id 922b383d-4521-11e9-8144-0050569116f7;
        Wed, 13 Mar 2019 00:50:15 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3] rcar-csi2: Propagate the FLD signal for NTSC and PAL
Date:   Wed, 13 Mar 2019 00:49:55 +0100
Message-Id: <20190312234955.23310-1-niklas.soderlund+renesas@ragnatech.se>
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
 drivers/media/platform/rcar-vin/rcar-csi2.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)
---
Hi,

This patch depends on '[PATCH v3 0/2] rcar-csi2: Use standby mode 
instead of resetting'.

* Changes since v2
- Set FLD_DET_SEL = 01

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 10f1b4978ed7dcc6..6c7c7e6072ffb09e 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -68,6 +68,7 @@ struct rcar_csi2;
 /* Field Detection Control */
 #define FLD_REG				0x1c
 #define FLD_FLD_NUM(n)			(((n) & 0xff) << 16)
+#define FLD_DET_SEL(n)			(((n) & 0x3) << 4)
 #define FLD_FLD_EN4			BIT(3)
 #define FLD_FLD_EN3			BIT(2)
 #define FLD_FLD_EN2			BIT(1)
@@ -475,7 +476,7 @@ static int rcsi2_calc_mbps(struct rcar_csi2 *priv, unsigned int bpp)
 static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 {
 	const struct rcar_csi2_format *format;
-	u32 phycnt, vcdt = 0, vcdt2 = 0;
+	u32 phycnt, vcdt = 0, vcdt2 = 0, fld = 0;
 	unsigned int i;
 	int mbps, ret;
 
@@ -507,6 +508,16 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
 			vcdt2 |= vcdt_part << ((i % 2) * 16);
 	}
 
+	if (priv->mf.field == V4L2_FIELD_ALTERNATE) {
+		fld = FLD_DET_SEL(1) | FLD_FLD_EN4 | FLD_FLD_EN3 | FLD_FLD_EN2
+			| FLD_FLD_EN;
+
+		if (priv->mf.height == 240)
+			fld |= FLD_FLD_NUM(2);
+		else
+			fld |= FLD_FLD_NUM(1);
+	}
+
 	phycnt = PHYCNT_ENABLECLK;
 	phycnt |= (1 << priv->lanes) - 1;
 
@@ -519,8 +530,7 @@ static int rcsi2_start_receiver(struct rcar_csi2 *priv)
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

