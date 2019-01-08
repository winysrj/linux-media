Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0973C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BA3D206A3
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 17:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfAHRUY (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 12:20:24 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36387 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727484AbfAHRUX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 12:20:23 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggv37-0005MV-Rm; Tue, 08 Jan 2019 18:20:21 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     kernel@pengutronix.de
Subject: [PATCH] media: coda: use macroblock tiling on CODA960 only
Date:   Tue,  8 Jan 2019 18:20:16 +0100
Message-Id: <20190108172016.21479-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Coda7541 and earlier do not support macroblock tiling. They do support
the NV12 format, though.  Enable macroblock tiling for NV12 only on
CODA960. This fixes crashes when trying to use NV12 support on CodaHx4.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 7518f01c48f7..3ea3066db115 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -728,7 +728,7 @@ static int coda_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f,
 		ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
 		break;
 	case V4L2_PIX_FMT_NV12:
-		if (!disable_tiling) {
+		if (!disable_tiling && ctx->dev->devtype->product == CODA_960) {
 			ctx->tiled_map_type = GDI_TILED_FRAME_MB_RASTER_MAP;
 			break;
 		}
-- 
2.20.1

