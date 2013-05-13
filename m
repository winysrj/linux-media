Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:62142 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3EMJh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:37:29 -0400
Received: by mail-pb0-f49.google.com with SMTP id rp2so1593249pbb.22
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:37:29 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, sachin.kamat@linaro.org,
	Pelagicore AB <info@pelagicore.com>
Subject: [PATCH 1/2] [media] timblogiw: Remove redundant platform_set_drvdata()
Date: Mon, 13 May 2013 14:54:07 +0530
Message-Id: <1368437048-13172-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Pelagicore AB <info@pelagicore.com>
---
 drivers/media/platform/timblogiw.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index a2f7bdd..99861c63 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -834,11 +834,9 @@ static int timblogiw_probe(struct platform_device *pdev)
 		goto err_request;
 	}
 
-
 	return 0;
 
 err_request:
-	platform_set_drvdata(pdev, NULL);
 	v4l2_device_unregister(&lw->v4l2_dev);
 err_register:
 	kfree(lw);
@@ -858,8 +856,6 @@ static int timblogiw_remove(struct platform_device *pdev)
 
 	kfree(lw);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.9.5

