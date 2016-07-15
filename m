Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bn3nam01on0052.outbound.protection.outlook.com ([104.47.33.52]:11824
	"EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932785AbcGOMOs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 08:14:48 -0400
From: Peter Chen <peter.chen@nxp.com>
To: <bparrot@ti.com>, <mchehab@kernel.org>
CC: Peter Chen <peter.chen@nxp.com>, <linux-media@vger.kernel.org>
Subject: [PATCH 1/1] media: platform: ti-vpe: call of_node_put on non-null pointer
Date: Fri, 15 Jul 2016 17:33:06 +0800
Message-ID: <1468575186-24961-1-git-send-email-peter.chen@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It should call of_node_put on non-null poiner.

Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
---
 drivers/media/platform/ti-vpe/cal.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 82001e6..00c3e97 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1761,13 +1761,13 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	}
 
 cleanup_exit:
-	if (!remote_ep)
+	if (remote_ep)
 		of_node_put(remote_ep);
-	if (!sensor_node)
+	if (sensor_node)
 		of_node_put(sensor_node);
-	if (!ep_node)
+	if (ep_node)
 		of_node_put(ep_node);
-	if (!port)
+	if (port)
 		of_node_put(port);
 
 	return ret;
-- 
1.9.1

