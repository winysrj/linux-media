Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55327 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934019AbcAKQsC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:48:02 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Subject: [PATCH v2 5/8] [media] tvp514x: Check v4l2_of_parse_endpoint() return value
Date: Mon, 11 Jan 2016 13:47:13 -0300
Message-Id: <1452530844-30609-6-git-send-email-javier@osg.samsung.com>
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

 drivers/media/i2c/tvp514x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 7fa5f1e4fe37..7cdd94842938 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -1001,7 +1001,7 @@ static struct tvp514x_decoder tvp514x_dev = {
 static struct tvp514x_platform_data *
 tvp514x_get_pdata(struct i2c_client *client)
 {
-	struct tvp514x_platform_data *pdata;
+	struct tvp514x_platform_data *pdata = NULL;
 	struct v4l2_of_endpoint bus_cfg;
 	struct device_node *endpoint;
 	unsigned int flags;
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

