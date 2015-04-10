Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:35344 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbbDJWNg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 18:13:36 -0400
Received: by widdi4 with SMTP id di4so11476631wid.0
        for <linux-media@vger.kernel.org>; Fri, 10 Apr 2015 15:13:35 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: i2c: ov2659: Use v4l2_of_alloc_parse_endpoint()
Date: Fri, 10 Apr 2015 23:13:28 +0100
Message-Id: <1428704008-29640-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Instead of parsing the link-frequencies property in the driver, let
v4l2_of_alloc_parse_endpoint() do it.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 This patch depends on https://patchwork.kernel.org/patch/6190901/
 
 drivers/media/i2c/ov2659.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index edebd11..c1e310b 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1340,8 +1340,8 @@ static struct ov2659_platform_data *
 ov2659_get_pdata(struct i2c_client *client)
 {
 	struct ov2659_platform_data *pdata;
+	struct v4l2_of_endpoint *bus_cfg;
 	struct device_node *endpoint;
-	int ret;
 
 	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
 		return client->dev.platform_data;
@@ -1350,18 +1350,27 @@ ov2659_get_pdata(struct i2c_client *client)
 	if (!endpoint)
 		return NULL;
 
+	bus_cfg = v4l2_of_alloc_parse_endpoint(endpoint);
+	if (IS_ERR(bus_cfg)) {
+		pdata = NULL;
+		goto done;
+	}
+
 	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		goto done;
 
-	ret = of_property_read_u64(endpoint, "link-frequencies",
-				   &pdata->link_frequency);
-	if (ret) {
-		dev_err(&client->dev, "link-frequencies property not found\n");
+	if (bus_cfg->nr_of_link_frequencies != 1) {
+		dev_err(&client->dev,
+			"link-frequencies property not found or too many\n");
 		pdata = NULL;
+		goto done;
 	}
 
+	pdata->link_frequency = bus_cfg->link_frequencies[0];
+
 done:
+	v4l2_of_free_endpoint(bus_cfg);
 	of_node_put(endpoint);
 	return pdata;
 }
-- 
2.1.0

