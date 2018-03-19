Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33983 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966145AbeCSQOt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 12:14:49 -0400
Received: by mail-pl0-f67.google.com with SMTP id u11-v6so6857329plq.1
        for <linux-media@vger.kernel.org>; Mon, 19 Mar 2018 09:14:49 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH] media: ov5645: add missing of_node_put() in error path
Date: Tue, 20 Mar 2018 01:14:17 +0900
Message-Id: <1521476057-28792-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device node obtained with of_graph_get_next_endpoint() should be
released by calling of_node_put().  But it was not released when
v4l2_fwnode_endpoint_parse() failed.

This change moves the of_node_put() call before the error check and
fixes the issue.

Cc: Todor Tomov <todor.tomov@linaro.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov5645.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
index d28845f..a31fe18 100644
--- a/drivers/media/i2c/ov5645.c
+++ b/drivers/media/i2c/ov5645.c
@@ -1131,13 +1131,14 @@ static int ov5645_probe(struct i2c_client *client,
 
 	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
 					 &ov5645->ep);
+
+	of_node_put(endpoint);
+
 	if (ret < 0) {
 		dev_err(dev, "parsing endpoint node failed\n");
 		return ret;
 	}
 
-	of_node_put(endpoint);
-
 	if (ov5645->ep.bus_type != V4L2_MBUS_CSI2) {
 		dev_err(dev, "invalid bus type, must be CSI2\n");
 		return -EINVAL;
-- 
2.7.4
