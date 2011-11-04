Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:55809 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1KDOUJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 10:20:09 -0400
Date: Fri, 04 Nov 2011 15:19:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/8] s5p-fimc: Fix wrong pointer dereference when unregistering
 sensors
In-reply-to: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1320416402-22883-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1320416402-22883-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After i2c_unregister_device() has been called the client object can already
be freed and thus using the client pointer may lead to dereferencing freed
memory. Avoid this by saving the adapter pointer for further use before
i2c_unregister_device() call.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
index cc337b1..d558ae7 100644
--- a/drivers/media/video/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
@@ -220,6 +220,7 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 	sd = v4l2_i2c_new_subdev_board(&fmd->v4l2_dev, adapter,
 				       s_info->pdata->board_info, NULL);
 	if (IS_ERR_OR_NULL(sd)) {
+		i2c_put_adapter(adapter);
 		v4l2_err(&fmd->v4l2_dev, "Failed to acquire subdev\n");
 		return NULL;
 	}
@@ -234,12 +235,15 @@ static struct v4l2_subdev *fimc_md_register_sensor(struct fimc_md *fmd,
 static void fimc_md_unregister_sensor(struct v4l2_subdev *sd)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct i2c_adapter *adapter;
 
 	if (!client)
 		return;
 	v4l2_device_unregister_subdev(sd);
+	adapter = client->adapter;
 	i2c_unregister_device(client);
-	i2c_put_adapter(client->adapter);
+	if (adapter)
+		i2c_put_adapter(adapter);
 }
 
 static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
-- 
1.7.7.1

