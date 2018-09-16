Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:12156 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728350AbeIPSwR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Sep 2018 14:52:17 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <mchehab@kernel.org>
CC: <bparrot@ti.com>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: platform: remove redundant null pointer check before of_node_put
Date: Sun, 16 Sep 2018 21:16:51 +0800
Message-ID: <1537103811-63670-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_node_put has taken the null pinter check into account. So it is
safe to remove the duplicated check before of_node_put.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/media/platform/ti-vpe/cal.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index cc052b2..5f9d4e0 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1747,14 +1747,10 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	}
 
 cleanup_exit:
-	if (remote_ep)
-		of_node_put(remote_ep);
-	if (sensor_node)
-		of_node_put(sensor_node);
-	if (ep_node)
-		of_node_put(ep_node);
-	if (port)
-		of_node_put(port);
+	of_node_put(remote_ep);
+	of_node_put(sensor_node);
+	of_node_put(ep_node);
+	of_node_put(port);
 
 	return ret;
 }
-- 
1.7.12.4
