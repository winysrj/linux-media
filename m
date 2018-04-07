Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36215 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751741AbeDGPss (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Apr 2018 11:48:48 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 3/6] media: ov772x: create subdevice device node
Date: Sun,  8 Apr 2018 00:48:07 +0900
Message-Id: <1523116090-13101-4-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
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
 drivers/media/i2c/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index c56f910..4bb81ff 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1301,6 +1301,7 @@ static int ov772x_probe(struct i2c_client *client,
 	client->flags |= I2C_CLIENT_SCCB;
 
 	v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
+	priv->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	v4l2_ctrl_handler_init(&priv->hdl, 3);
 	v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
-- 
2.7.4
