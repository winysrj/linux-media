Return-Path: <SRS0=SCQz=PT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2333C43612
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76E522183F
	for <linux-media@archiver.kernel.org>; Fri, 11 Jan 2019 15:44:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="HOie09fr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732105AbfAKPod (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 11 Jan 2019 10:44:33 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:59984 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbfAKPod (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Jan 2019 10:44:33 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 832C553E;
        Fri, 11 Jan 2019 16:44:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1547221471;
        bh=4s+Ws+SAkl0QGeTpZNiLBCVce3enPIAmdzkV3LkC86Q=;
        h=From:To:Cc:Subject:Date:From;
        b=HOie09frxRd5hCkaUTd3XXsl0l7V08wd6ev7Wf5pnMCEIQBQ724ex5kvA/Ov4KR8h
         W2xppSoTqWnd7eJsAAJOjoPfcoy8UiK9i+1lGHew/JeKiOd+xKJJh6Yzf8BRMIzeY5
         8EKP62BxMfpfZPRoGC+0Fr1cP8XsrJb1j5MTTeBg=
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Cc:     Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 1/2] media: i2c: adv7482: Fix wait procedure usleep_range from msleep
Date:   Fri, 11 Jan 2019 15:43:44 +0000
Message-Id: <20190111154345.29145-1-kieran.bingham+renesas@ideasonboard.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

By Documentation/timers/timers-howto.txt, when waiting 20ms from 10us,
it is correct to use usleep_range. this patch corrects it.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
(cherry picked from horms/renesas-bsp commit af0cdba377bc8a784cdae6a77fb7a822cebc7083)
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/i2c/adv748x/adv748x-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
index 64eb1bfda581..097e5c3a8e7e 100644
--- a/drivers/media/i2c/adv748x/adv748x-core.c
+++ b/drivers/media/i2c/adv748x/adv748x-core.c
@@ -273,7 +273,8 @@ static int adv748x_write_regs(struct adv748x_state *state,
 
 	while (regs->page != ADV748X_PAGE_EOR) {
 		if (regs->page == ADV748X_PAGE_WAIT) {
-			msleep(regs->value);
+			usleep_range(regs->value * 1000,
+				     (regs->value * 1000) + 1000);
 		} else {
 			ret = adv748x_write(state, regs->page, regs->reg,
 				      regs->value);
-- 
2.19.2

