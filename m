Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E6CC43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 17:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8865B20870
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 17:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="urw7i/yV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbfAKRlu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 12:41:50 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33736 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730100AbfAKRlt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 12:41:49 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id F0FCB565;
        Fri, 11 Jan 2019 18:41:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547228507;
        bh=nvKuBswDQlnBtUKqkgbPKbQVp5dPgMNwIlh3wHRr9v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=urw7i/yVMCJT8PgftNDUfhxOnWmgFSceKIT/OGwhD6+soAPcr8/9X5wuSqmvZb2JD
         ch7jCkRA0myTJU0kvLSbNm9WQ94+lfv3XPP189UHz4in0nA6E7sGVnTRZJtLlw5+hq
         rJtjvM93cmaRzSM7WgcStZVVkAiaonNQd5DNG3RA=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Cc:     linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 2/2] media: i2c: adv748x: Remove PAGE_WAIT
Date:   Fri, 11 Jan 2019 17:41:41 +0000
Message-Id: <20190111174141.12594-3-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
References: <20190111174141.12594-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The ADV748X_PAGE_WAIT is a fake page to insert arbitrary delays in the
register tables.

Its only usage was removed, so we can remove the handling and simplify
the code.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 17 ++++++-----------
 drivers/media/i2c/adv748x/adv748x.h      |  1 -
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 252bdb28b18b..8199e0b20790 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -219,18 +219,13 @@ static int adv748x_write_regs(struct adv748x_state *state,
 	int ret;
 
 	while (regs->page != ADV748X_PAGE_EOR) {
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
+		ret = adv748x_write(state, regs->page, regs->reg, regs->value);
+		if (ret < 0) {
+			adv_err(state, "Error regs page: 0x%02x reg: 0x%02x\n",
+				regs->page, regs->reg);
+			return ret;
 		}
+
 		regs++;
 	}
 
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

