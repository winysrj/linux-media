Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34326 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753433AbdLTQdw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Dec 2017 11:33:52 -0500
Received: by mail-pf0-f193.google.com with SMTP id a90so12782078pfk.1
        for <linux-media@vger.kernel.org>; Wed, 20 Dec 2017 08:33:51 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/4] meida: mt9m111: create subdevice device node
Date: Thu, 21 Dec 2017 01:33:31 +0900
Message-Id: <1513787614-12008-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
References: <1513787614-12008-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so that the
subdevice device node is created.

Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
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
