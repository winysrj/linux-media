Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55324 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933601AbcAKQr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:47:57 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v2 4/8] [media] s5k5baf: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 13:47:12 -0300
Message-Id: <1452530844-30609-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---

Changes in v2: None

 drivers/media/i2c/s5k5baf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index fc3a5a8e6c9c..db82ed05792e 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1868,8 +1868,11 @@ static int s5k5baf_parse_device_node(struct s5k5baf *state, struct device *dev)
 		return -EINVAL;
 	}
 
-	v4l2_of_parse_endpoint(node_ep, &ep);
+	ret = v4l2_of_parse_endpoint(node_ep, &ep);
 	of_node_put(node_ep);
+	if (ret)
+		return ret;
+
 	state->bus_type = ep.bus_type;
 
 	switch (state->bus_type) {
-- 
2.4.3

