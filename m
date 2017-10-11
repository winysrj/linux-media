Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:7565 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbdJKLQo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 07:16:44 -0400
From: Wei Yongjun <weiyongjun1@huawei.com>
To: Helen Koike <helen.koike@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Wei Yongjun <weiyongjun1@huawei.com>, <linux-media@vger.kernel.org>
Subject: [PATCH] [media] vimc: Fix return value check in vimc_add_subdevs()
Date: Wed, 11 Oct 2017 11:16:43 +0000
Message-ID: <1507720603-128932-1-git-send-email-weiyongjun1@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In case of error, the function platform_device_register_data() returns
ERR_PTR() and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/media/platform/vimc/vimc-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 51c0eee..fe088a9 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -267,11 +267,12 @@ static struct component_match *vimc_add_subdevs(struct vimc_device *vimc)
 						PLATFORM_DEVID_AUTO,
 						&pdata,
 						sizeof(pdata));
-		if (!vimc->subdevs[i]) {
+		if (IS_ERR(vimc->subdevs[i])) {
+			match = ERR_CAST(vimc->subdevs[i]);
 			while (--i >= 0)
 				platform_device_unregister(vimc->subdevs[i]);
 
-			return ERR_PTR(-ENOMEM);
+			return match;
 		}
 
 		component_match_add(&vimc->pdev.dev, &match, vimc_comp_compare,
