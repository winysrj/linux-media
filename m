Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42457 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754448AbeDVP5J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 11:57:09 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v3 11/11] media: ov772x: create subdevice device node
Date: Mon, 23 Apr 2018 00:56:17 +0900
Message-Id: <1524412577-14419-12-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
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
* v3
- No changes

 drivers/media/i2c/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index c9fdc67..a41c9d3 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1404,6 +1404,7 @@ static int ov772x_probe(struct i2c_client *client,
 	mutex_init(&priv->lock);
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	/* Use our mutex for the controls */
 	priv->hdl.lock = &priv->lock;
-- 
2.7.4
