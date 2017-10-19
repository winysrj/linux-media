Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:55527 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752781AbdJSQbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 12:31:40 -0400
Received: by mail-pf0-f193.google.com with SMTP id 17so6937214pfn.12
        for <linux-media@vger.kernel.org>; Thu, 19 Oct 2017 09:31:40 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/4] media: max2175: don't clear V4L2_SUBDEV_FL_IS_I2C
Date: Fri, 20 Oct 2017 01:31:21 +0900
Message-Id: <1508430683-8674-3-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
References: <1508430683-8674-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The v4l2_i2c_subdev_init() sets V4L2_SUBDEV_FL_IS_I2C flag in the
subdev->flags.  But this driver overwrites subdev->flags immediately after
calling v4l2_i2c_subdev_init().  So V4L2_SUBDEV_FL_IS_I2C is not set after
all.

This stops breaking subdev->flags and preserves V4L2_SUBDEV_FL_IS_I2C.

Side note: According to the comment in v4l2_device_unregister(), this is
problematic only if the device is platform bus device.  Device tree or
ACPI based devices are not affected.

Cc: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index bf0e821..2f1966b 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -1345,7 +1345,7 @@ static int max2175_probe(struct i2c_client *client,
 	v4l2_i2c_subdev_init(sd, client, &max2175_ops);
 	ctx->client = client;
 
-	sd->flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	/* Controls */
 	hdl = &ctx->ctrl_hdl;
-- 
2.7.4
