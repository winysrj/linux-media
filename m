Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55334 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934052AbcAKQsI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:48:08 -0500
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
Subject: [PATCH v2 6/8] [media] tvp7002: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 13:47:14 -0300
Message-Id: <1452530844-30609-7-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
References: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_of_parse_endpoint() function can fail so check the return value.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

---

Changes in v2:
- Assign pdata to NULL in case v4l2_of_parse_endpoint() fails before kzalloc.
  Suggested by Sakari Ailus.

 drivers/media/i2c/tvp7002.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index 83c79fa5f61d..4df640c3aa40 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -894,7 +894,7 @@ static struct tvp7002_config *
 tvp7002_get_pdata(struct i2c_client *client)
 {
 	struct v4l2_of_endpoint bus_cfg;
-	struct tvp7002_config *pdata;
+	struct tvp7002_config *pdata = NULL;
 	struct device_node *endpoint;
 	unsigned int flags;
 
@@ -905,11 +905,13 @@ tvp7002_get_pdata(struct i2c_client *client)
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

