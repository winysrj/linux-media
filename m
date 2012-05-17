Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:25440 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762205Ab2EQQak (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 May 2012 12:30:40 -0400
Received: from maxwell.research.nokia.com (maxwell.research.nokia.com [172.21.199.25])
	by mgw-da02.nokia.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with ESMTP id q4HGUcYr007059
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:39 +0300
Received: from lanttu (lanttu-o.localdomain [192.168.239.74])
	by maxwell.research.nokia.com (Postfix) with ESMTPS id 16D951F4C5A
	for <linux-media@vger.kernel.org>; Thu, 17 May 2012 19:30:38 +0300 (EEST)
Received: from sakke by lanttu with local (Exim 4.72)
	(envelope-from <sakari.ailus@maxwell.research.nokia.com>)
	id 1SV3az-00087J-Ps
	for linux-media@vger.kernel.org; Thu, 17 May 2012 19:30:33 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 10/10] smiapp: Use v4l2_ctrl_new_int_menu() instead of v4l2_ctrl_new_custom()
Date: Thu, 17 May 2012 19:30:09 +0300
Message-Id: <1337272209-31061-10-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <4FB52770.9000400@maxwell.research.nokia.com>
References: <4FB52770.9000400@maxwell.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/smiapp/smiapp-core.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
index ffc6eb7..f518026 100644
--- a/drivers/media/video/smiapp/smiapp-core.c
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -508,7 +508,7 @@ static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
 static int smiapp_init_controls(struct smiapp_sensor *sensor)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
-	struct v4l2_ctrl_config cfg;
+	unsigned int max;
 	int rval;
 
 	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 7);
@@ -572,17 +572,12 @@ static int smiapp_init_controls(struct smiapp_sensor *sensor)
 		goto error;
 	sensor->src->ctrl_handler.lock = &sensor->mutex;
 
-	memset(&cfg, 0, sizeof(cfg));
+	for (max = 0; sensor->platform_data->op_sys_clock[max + 1]; max++);
 
-	cfg.ops = &smiapp_ctrl_ops;
-	cfg.id = V4L2_CID_LINK_FREQ;
-	cfg.type = V4L2_CTRL_TYPE_INTEGER_MENU;
-	while (sensor->platform_data->op_sys_clock[cfg.max + 1])
-		cfg.max++;
-	cfg.qmenu_int = sensor->platform_data->op_sys_clock;
-
-	sensor->link_freq = v4l2_ctrl_new_custom(
-		&sensor->src->ctrl_handler, &cfg, NULL);
+	sensor->link_freq = v4l2_ctrl_new_int_menu(
+		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_LINK_FREQ, max, 0,
+		sensor->platform_data->op_sys_clock);
 
 	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
 		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
-- 
1.7.2.5

