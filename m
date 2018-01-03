Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:41474 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750753AbeACSXY (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 3 Jan 2018 13:23:24 -0500
Received: by mail-pg0-f67.google.com with SMTP id 77so984631pgd.8
        for <linux-media@vger.kernel.org>; Wed, 03 Jan 2018 10:23:24 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v2 1/4] media: mt9m111: create subdevice device node
Date: Thu,  4 Jan 2018 03:22:44 +0900
Message-Id: <1515003767-12006-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1515003767-12006-1-git-send-email-akinobu.mita@gmail.com>
References: <1515003767-12006-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so that the
subdevice device node is created.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* Changelog v2
- Fix typo s/meida/media/ in the patch title, noticed by Sakari Ailus

 drivers/media/i2c/mt9m111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index b1665d9..4fa10df 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -951,6 +951,8 @@ static int mt9m111_probe(struct i2c_client *client,
 	mt9m111->ctx = &context_b;
 
 	v4l2_i2c_subdev_init(&mt9m111->subdev, client, &mt9m111_subdev_ops);
+	mt9m111->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
 	v4l2_ctrl_handler_init(&mt9m111->hdl, 5);
 	v4l2_ctrl_new_std(&mt9m111->hdl, &mt9m111_ctrl_ops,
 			V4L2_CID_VFLIP, 0, 1, 1, 0);
-- 
2.7.4
