Return-Path: <SRS0=4gsG=RD=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C93C10F00
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 11:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C964218B0
	for <linux-media@archiver.kernel.org>; Thu, 28 Feb 2019 11:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbfB1LGW (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:06:22 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:35248 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbfB1LGW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 06:06:22 -0500
Received: from ramsan ([84.194.111.163])
        by albert.telenet-ops.be with bizsmtp
        id iB6L1z00G3XaVaC06B6L5E; Thu, 28 Feb 2019 12:06:20 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1gzJW8-0007UC-1N; Thu, 28 Feb 2019 12:06:20 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1gzJW7-0000WS-Vu; Thu, 28 Feb 2019 12:06:20 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] media: rcar_drif: Remove devm_ioremap_resource() error printing
Date:   Thu, 28 Feb 2019 12:06:16 +0100
Message-Id: <20190228110616.1966-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

devm_ioremap_resource() already prints an error message on failure, so
there is no need to repeat that.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/media/platform/rcar_drif.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index c417ff8f6fe548f3..d4efade7aea60e32 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1407,7 +1407,6 @@ static int rcar_drif_probe(struct platform_device *pdev)
 	ch->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(ch->base)) {
 		ret = PTR_ERR(ch->base);
-		dev_err(&pdev->dev, "ioremap failed (%d)\n", ret);
 		return ret;
 	}
 	ch->start = res->start;
-- 
2.17.1

