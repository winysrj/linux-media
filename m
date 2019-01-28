Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5B7C282C8
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CFFA2173C
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 11:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfA1LhO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 06:37:14 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:46377 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbfA1LhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 06:37:14 -0500
Received: from dude02.hi.pengutronix.de ([2001:67c:670:100:1d::28] helo=dude02.pengutronix.de.)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1go5E0-000616-OR; Mon, 28 Jan 2019 12:37:12 +0100
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     linux-media@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        David Binderman <dcb314@hotmail.com>, kernel@pengutronix.de
Subject: [PATCH] media: imx-pxp: fix duplicated if condition
Date:   Mon, 28 Jan 2019 12:37:11 +0100
Message-Id: <20190128113711.14551-1-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::28
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix a copy&paste error to make RGB -> BT.2020 YUV conversion actually
selectable. Fixes the following warning:

  drivers/media/platform/imx-pxp.c:683:24: warning: duplicated ‘if’ condition [-Wduplicated-cond]

Reported-by: David Binderman <dcb314@hotmail.com>
Fixes: 51abcf7fdb70 ("media: imx-pxp: add i.MX Pixel Pipeline driver")
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx-pxp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/imx-pxp.c b/drivers/media/platform/imx-pxp.c
index c1c255408d16..f087dc4fc729 100644
--- a/drivers/media/platform/imx-pxp.c
+++ b/drivers/media/platform/imx-pxp.c
@@ -680,7 +680,7 @@ static void pxp_setup_csc(struct pxp_ctx *ctx)
 				csc2_coef = csc2_coef_rec709_full;
 			else
 				csc2_coef = csc2_coef_rec709_lim;
-		} else if (ycbcr_enc == V4L2_YCBCR_ENC_709) {
+		} else if (ycbcr_enc == V4L2_YCBCR_ENC_BT2020) {
 			if (quantization == V4L2_QUANTIZATION_FULL_RANGE)
 				csc2_coef = csc2_coef_bt2020_full;
 			else
-- 
2.20.1

