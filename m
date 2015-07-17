Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36891 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbbGQODG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 10:03:06 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mats Randgaard <matrandg@cisco.com>, linux-media@vger.kernel.org,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/4] [media] tc358743: register v4l2 asynchronous subdevice
Date: Fri, 17 Jul 2015 16:02:53 +0200
Message-Id: <1437141776-8967-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for registering the sensor subdevice using the v4l2-async API.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/i2c/tc358743.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
index 34d4f32..8d9906b 100644
--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -1710,6 +1710,16 @@ static int tc358743_probe(struct i2c_client *client,
 		goto err_hdl;
 	}
 
+	state->pad.flags = MEDIA_PAD_FL_SOURCE;
+	err = media_entity_init(&sd->entity, 1, &state->pad, 0);
+	if (err < 0)
+		goto err_hdl;
+
+	sd->dev = &client->dev;
+	err = v4l2_async_register_subdev(sd);
+	if (err < 0)
+		goto err_hdl;
+
 	mutex_init(&state->confctl_mutex);
 
 	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
@@ -1740,6 +1750,7 @@ err_work_queues:
 	destroy_workqueue(state->work_queues);
 	mutex_destroy(&state->confctl_mutex);
 err_hdl:
+	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(&state->hdl);
 	return err;
 }
@@ -1751,8 +1762,10 @@ static int tc358743_remove(struct i2c_client *client)
 
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	mutex_destroy(&state->confctl_mutex);
+	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(&state->hdl);
 
 	return 0;
-- 
2.1.4

