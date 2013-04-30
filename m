Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:41138 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3D3G3U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Apr 2013 02:29:20 -0400
Received: by mail-pb0-f43.google.com with SMTP id ma3so110042pbc.16
        for <linux-media@vger.kernel.org>; Mon, 29 Apr 2013 23:29:20 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, sachin.kamat@linaro.org, patches@linaro.org
Subject: [PATCH 4/4] [media] s3c-camif: Use dev_info instead of printk
Date: Tue, 30 Apr 2013 11:46:21 +0530
Message-Id: <1367302581-15478-4-git-send-email-sachin.kamat@linaro.org>
In-Reply-To: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
References: <1367302581-15478-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev_info is preferred to printk. Silences the related checkpatch
warning.
WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ...
then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s3c-camif/camif-regs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s3c-camif/camif-regs.c b/drivers/media/platform/s3c-camif/camif-regs.c
index 7b22d6c..a9e3b16 100644
--- a/drivers/media/platform/s3c-camif/camif-regs.c
+++ b/drivers/media/platform/s3c-camif/camif-regs.c
@@ -601,6 +601,6 @@ void camif_hw_dump_regs(struct camif_dev *camif, const char *label)
 	pr_info("--- %s ---\n", label);
 	for (i = 0; i < ARRAY_SIZE(registers); i++) {
 		u32 cfg = readl(camif->io_base + registers[i].offset);
-		printk(KERN_INFO "%s:\t0x%08x\n", registers[i].name, cfg);
+		dev_info(camif->dev, "%s:\t0x%08x\n", registers[i].name, cfg);
 	}
 }
-- 
1.7.9.5

