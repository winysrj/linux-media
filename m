Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45270 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbcAGS2B (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 13:28:01 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/8] [media] s5c73m3: Check v4l2_of_parse_endpoint() return value
Date: Thu,  7 Jan 2016 15:27:17 -0300
Message-Id: <1452191248-15847-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/s5c73m3/s5c73m3-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index 57b3d27993a4..08af58fb8e7d 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1639,8 +1639,10 @@ static int s5c73m3_get_platform_data(struct s5c73m3 *state)
 		return 0;
 	}
 
-	v4l2_of_parse_endpoint(node_ep, &ep);
+	ret = v4l2_of_parse_endpoint(node_ep, &ep);
 	of_node_put(node_ep);
+	if (ret)
+		return ret;
 
 	if (ep.bus_type != V4L2_MBUS_CSI2) {
 		dev_err(dev, "unsupported bus type\n");
-- 
2.4.3

