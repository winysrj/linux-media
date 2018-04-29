Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33523 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754059AbeD2ROO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Apr 2018 13:14:14 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v4 14/14] media: ov772x: create subdevice device node
Date: Mon, 30 Apr 2018 02:13:13 +0900
Message-Id: <1525021993-17789-15-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so that the
subdevice device node is created.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v4
- No changes

 drivers/media/i2c/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index f3c4f78..ec45eed 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1403,6 +1403,7 @@ static int ov772x_probe(struct i2c_client *client,
 	mutex_init(&priv->lock);
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	/* Use our mutex for the controls */
 	priv->hdl.lock = &priv->lock;
-- 
2.7.4
