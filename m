Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:12149 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727071AbeIPSkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 14:40:12 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <p.zabel@pengutronix.de>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: coda: remove redundant null pointer check before of_node_put
Date: Sun, 16 Sep 2018 21:04:49 +0800
Message-ID: <1537103089-63003-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_node_put has taken the null pinter check into account. So it is
safe to remove the duplicated check before of_node_put.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/platform/coda/coda-common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 0bffa1e..6bff416 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -376,8 +376,7 @@ static struct vdoa_data *coda_get_vdoa_data(void)
 		vdoa_data = ERR_PTR(-EPROBE_DEFER);
 
 out:
-	if (vdoa_node)
-		of_node_put(vdoa_node);
+	of_node_put(vdoa_node);
 
 	return vdoa_data;
 }
-- 
1.7.12.4
