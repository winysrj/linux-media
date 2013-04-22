Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:62999 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3DVOFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 10:05:06 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLN00CNHTSGLVJ0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Apr 2013 23:05:04 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 01/12] s5c73m3: Fix remove() callback to free requested
 resources
Date: Mon, 22 Apr 2013 16:03:36 +0200
Message-id: <1366639427-14253-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
References: <1366639427-14253-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure v4l2_device_unregister_subdev() is called for both:
oif and sensor subdev and both media entities are freed on
driver removal.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index b353c50..ce8fcf2 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1668,13 +1668,17 @@ out_err1:
 
 static int s5c73m3_remove(struct i2c_client *client)
 {
-	struct v4l2_subdev *sd = i2c_get_clientdata(client);
-	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
+	struct v4l2_subdev *oif_sd = i2c_get_clientdata(client);
+	struct s5c73m3 *state = oif_sd_to_s5c73m3(oif_sd);
+	struct v4l2_subdev *sensor_sd = &state->sensor_sd;
 
-	v4l2_device_unregister_subdev(sd);
+	v4l2_device_unregister_subdev(oif_sd);
 
-	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	media_entity_cleanup(&sd->entity);
+	v4l2_ctrl_handler_free(oif_sd->ctrl_handler);
+	media_entity_cleanup(&oif_sd->entity);
+
+	v4l2_device_unregister_subdev(sensor_sd);
+	media_entity_cleanup(&sensor_sd->entity);
 
 	s5c73m3_unregister_spi_driver(state);
 	s5c73m3_free_gpios(state);
-- 
1.7.9.5

