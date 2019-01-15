Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92C7C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B269520868
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 14:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="TRcJIzgJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730345AbfAOOZP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 09:25:15 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:42042 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbfAOOZO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 09:25:14 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9C7854F8;
        Tue, 15 Jan 2019 15:25:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547562312;
        bh=nIZf0tWuPTdlxqa4jw93FwMmDk6xecS4QbGLEz3vaBQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TRcJIzgJcLYvvw4vw8WGSL1sBncZ6rJzEj657Bci0IOp+KDTr4oDVShvcnA7vkVsU
         c1DlTTg/osClu5FSZCCkX+Dort9NDCQKBT3Dx9Ue3dlBmCxCJVUzBi6kaQW2qEOJVY
         P5h0KP5b+hVnn6OwD5jKXOojRBgYgG8Rf9QrlcaY=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>
Subject: [PATCH v2] media: i2c: adv748x: Remove PAGE_WAIT
Date:   Tue, 15 Jan 2019 14:25:09 +0000
Message-Id: <20190115142509.26048-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ADV748X_PAGE_WAIT is a fake page to insert arbitrary delays in the
register tables.

Its only usage was removed, so we can remove the handling and simplify
the code.

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Use for loop with regs incrementer

 drivers/media/i2c/adv748x/adv748x-core.c | 19 ++++++-------------
 drivers/media/i2c/adv748x/adv748x.h      |  1 -
 2 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 252bdb28b18b..f57cd77a32fa 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -218,20 +218,13 @@ static int adv748x_write_regs(struct adv748x_state *state,
 {
 	int ret;
 
-	while (regs->page != ADV748X_PAGE_EOR) {
-		if (regs->page == ADV748X_PAGE_WAIT) {
-			msleep(regs->value);
-		} else {
-			ret = adv748x_write(state, regs->page, regs->reg,
-				      regs->value);
-			if (ret < 0) {
-				adv_err(state,
-					"Error regs page: 0x%02x reg: 0x%02x\n",
-					regs->page, regs->reg);
-				return ret;
-			}
+	for (; regs->page != ADV748X_PAGE_EOR; regs++) {
+		ret = adv748x_write(state, regs->page, regs->reg, regs->value);
+		if (ret < 0) {
+			adv_err(state, "Error regs page: 0x%02x reg: 0x%02x\n",
+				regs->page, regs->reg);
+			return ret;
 		}
-		regs++;
 	}
 
 	return 0;
diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
index 2f8d751cfbb0..5042f9e94aee 100644
--- a/drivers/media/i2c/adv748x/adv748x.h
+++ b/drivers/media/i2c/adv748x/adv748x.h
@@ -39,7 +39,6 @@ enum adv748x_page {
 	ADV748X_PAGE_MAX,
 
 	/* Fake pages for register sequences */
-	ADV748X_PAGE_WAIT,		/* Wait x msec */
 	ADV748X_PAGE_EOR,		/* End Mark */
 };
 
-- 
2.17.1

