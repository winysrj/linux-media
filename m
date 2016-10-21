Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33199 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752106AbcJUIzq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 04:55:46 -0400
Received: by mail-qk0-f176.google.com with SMTP id n189so139029468qke.0
        for <linux-media@vger.kernel.org>; Fri, 21 Oct 2016 01:55:46 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, mchehab@kernel.org, patrice.chotard@st.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] c8sectpfe: Remove clk_disable_unprepare hacks
Date: Fri, 21 Oct 2016 09:55:32 +0100
Message-Id: <1477040132-31442-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that CLK_PROC_STFE is defined as a critical clock in
DT, we can remove the commented clk_disable_unprepare from
the c8sectpfe driver. This means we now have balanced
clk*enable/disable calls in the driver, but on STiH407
family the clock in reality will never actually be disabled.

This is due to a HW bug where once the IP has been configured
and the SLIM core is running, disabling the clock causes a
unrecoverable bus lockup.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
index 30c148b..79d793b 100644
--- a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
+++ b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c
@@ -888,8 +888,7 @@ static int c8sectpfe_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_disable:
-	/* TODO uncomment when upstream has taken a reference on this clk */
-	/*clk_disable_unprepare(fei->c8sectpfeclk);*/
+	clk_disable_unprepare(fei->c8sectpfeclk);
 	return ret;
 }
 
@@ -924,11 +923,8 @@ static int c8sectpfe_remove(struct platform_device *pdev)
 	if (readl(fei->io + SYS_OTHER_CLKEN))
 		writel(0, fei->io + SYS_OTHER_CLKEN);
 
-	/* TODO uncomment when upstream has taken a reference on this clk */
-	/*
 	if (fei->c8sectpfeclk)
 		clk_disable_unprepare(fei->c8sectpfeclk);
-	*/
 
 	return 0;
 }
-- 
1.9.1

