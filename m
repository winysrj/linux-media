Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57626 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab3EMJhc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 05:37:32 -0400
Received: by mail-pb0-f42.google.com with SMTP id up7so4318378pbc.15
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 02:37:32 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, sachin.kamat@linaro.org
Subject: [PATCH 2/2] [media] rc: gpio-ir-recv: Remove redundant platform_set_drvdata()
Date: Mon, 13 May 2013 14:54:08 +0530
Message-Id: <1368437048-13172-2-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1368437048-13172-1-git-send-email-sachin.kamat@linaro.org>
References: <1368437048-13172-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
driver is bound) removes the need to set driver data field to
NULL.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/rc/gpio-ir-recv.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 8b82ae9..07aacfa 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -178,7 +178,6 @@ static int gpio_ir_recv_probe(struct platform_device *pdev)
 	return 0;
 
 err_request_irq:
-	platform_set_drvdata(pdev, NULL);
 	rc_unregister_device(rcdev);
 	rcdev = NULL;
 err_register_rc_device:
@@ -196,7 +195,6 @@ static int gpio_ir_recv_remove(struct platform_device *pdev)
 	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
 
 	free_irq(gpio_to_irq(gpio_dev->gpio_nr), gpio_dev);
-	platform_set_drvdata(pdev, NULL);
 	rc_unregister_device(gpio_dev->rcdev);
 	gpio_free(gpio_dev->gpio_nr);
 	kfree(gpio_dev);
-- 
1.7.9.5

