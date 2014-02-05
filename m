Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbaBEQl7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 29/47] adv7604: Add support for asynchronous probing
Date: Wed,  5 Feb 2014 17:42:20 +0100
Message-Id: <1391618558-5580-30-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lars-Peter Clausen <lars@metafoo.de>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 71c8570..98ac383 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2337,6 +2337,11 @@ static int adv7604_probe(struct i2c_client *client,
 		goto err_entity;
 	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
 			client->addr << 1, client->adapter->name);
+
+	err = v4l2_async_register_subdev(sd);
+	if (err)
+		goto err_entity;
+
 	return 0;
 
 err_entity:
@@ -2360,6 +2365,7 @@ static int adv7604_remove(struct i2c_client *client)
 
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7604_unregister_clients(to_state(sd));
-- 
1.8.3.2

