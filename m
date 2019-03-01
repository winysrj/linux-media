Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD70C10F03
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 09:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC10E2087E
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 09:41:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbfCAJk7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:40:59 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:45846 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732784AbfCAJk5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 04:40:57 -0500
Received: from ramsan ([84.194.111.163])
        by albert.telenet-ops.be with bizsmtp
        id iZgv1z00M3XaVaC06Zgvf7; Fri, 01 Mar 2019 10:40:56 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1gzef1-0005Ll-In; Fri, 01 Mar 2019 10:40:55 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1gzeci-0002tr-EK; Fri, 01 Mar 2019 10:38:32 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc:     linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] media: rcar_drif: Remove devm_ioremap_resource() error printing
Date:   Fri,  1 Mar 2019 10:38:31 +0100
Message-Id: <20190301093831.11106-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

devm_ioremap_resource() already prints an error message on failure, so
there is no need to repeat that.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - Drop assignment to ret.
---
 drivers/media/platform/rcar_drif.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index c417ff8f6fe548f3..608e5217ccd50a1b 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1405,11 +1405,9 @@ static int rcar_drif_probe(struct platform_device *pdev)
 	/* Register map */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ch->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(ch->base)) {
-		ret = PTR_ERR(ch->base);
-		dev_err(&pdev->dev, "ioremap failed (%d)\n", ret);
-		return ret;
-	}
+	if (IS_ERR(ch->base))
+		return PTR_ERR(ch->base);
+
 	ch->start = res->start;
 	platform_set_drvdata(pdev, ch);
 
-- 
2.17.1

