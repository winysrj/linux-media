Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55320 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933768AbcAKQrz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:47:55 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v2 3/8] [media] s5c73m3: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 13:47:11 -0300
Message-Id: <1452530844-30609-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

Changes in v2: None

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

