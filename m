Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:45283 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbcAGS2u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Jan 2016 13:28:50 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 5/8] [media] tvp514x: Check v4l2_of_parse_endpoint() return value
Date: Thu,  7 Jan 2016 15:27:19 -0300
Message-Id: <1452191248-15847-6-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
References: <1452191248-15847-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/i2c/tvp514x.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7fa5f1e4fe37..7a1e20feade9 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1013,11 +1013,13 @@ tvp514x_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
+	if (v4l2_of_parse_endpoint(endpoint, &bus_cfg))
+		goto done;
+
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		goto done;
 
-	v4l2_of_parse_endpoint(endpoint, &bus_cfg);
 	flags = bus_cfg.bus.parallel.flags;
 
 	if (flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
-- 
2.4.3

