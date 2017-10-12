Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:46482 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751600AbdJLQVm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:21:42 -0400
Received: by mail-pf0-f196.google.com with SMTP id p87so5542838pfj.3
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:21:41 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/4] media: ov7670: create subdevice device node
Date: Fri, 13 Oct 2017 01:21:14 +0900
Message-Id: <1507825277-18364-2-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
References: <1507825277-18364-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the V4L2_SUBDEV_FL_HAS_DEVNODE flag for the subdevice so it is
possible to create a subdevice device node.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/ov7670.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e88549f..d3f7d61 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1585,6 +1585,7 @@ static int ov7670_probe(struct i2c_client *client,
 		return -ENOMEM;
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov7670_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	info->clock_speed = 30; /* default: a guess */
 	if (client->dev.platform_data) {
-- 
2.7.4
