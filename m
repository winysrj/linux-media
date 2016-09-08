Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48379
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbcIHNF7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 09:05:59 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "H . Nikolaus Schaller" <hns@goldelico.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] ov9650: add support for asynchronous probing
Date: Thu,  8 Sep 2016 09:05:40 -0400
Message-Id: <1473339940-24572-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow the sub-device to be probed asynchronously so a bridge driver that's
waiting for the device can be notified and its .bound callback executed.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/i2c/ov9650.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index be5a7fd4f076..502c72238a4a 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -23,6 +23,7 @@
 #include <linux/videodev2.h>
 
 #include <media/media-entity.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
@@ -1520,6 +1521,10 @@ static int ov965x_probe(struct i2c_client *client,
 	/* Update exposure time min/max to match frame format */
 	ov965x_update_exposure_ctrl(ov965x);
 
+	ret = v4l2_async_register_subdev(sd);
+	if (ret < 0)
+		goto err_ctrls;
+
 	return 0;
 err_ctrls:
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
@@ -1532,7 +1537,7 @@ static int ov965x_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
-	v4l2_device_unregister_subdev(sd);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	media_entity_cleanup(&sd->entity);
 
-- 
2.7.4

