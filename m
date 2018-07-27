Return-path: <linux-media-owner@vger.kernel.org>
Received: from bran.ispras.ru ([83.149.199.196]:16167 "EHLO smtp.ispras.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729541AbeG0NJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Jul 2018 09:09:51 -0400
From: Anton Vasilyev <vasilyev@ispras.ru>
To: Helen Koike <helen.koike@collabora.com>
Cc: Anton Vasilyev <vasilyev@ispras.ru>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] media: vimc: Remove redundant free
Date: Fri, 27 Jul 2018 14:47:59 +0300
Message-Id: <20180727114759.10601-1-vasilyev@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 4a29b7090749 ("[media] vimc: Subdevices as modules") removes
vimc allocation from vimc_probe(), so corresponding deallocation
on the error path tries to free static memory.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
---
 drivers/media/platform/vimc/vimc-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index fe088a953860..9246f265de31 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -328,7 +328,6 @@ static int vimc_probe(struct platform_device *pdev)
 	if (ret) {
 		media_device_cleanup(&vimc->mdev);
 		vimc_rm_subdevs(vimc);
-		kfree(vimc);
 		return ret;
 	}
 
-- 
2.18.0
