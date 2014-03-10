Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48726 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaCJXOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 19:14:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 29/48] adv7604: Add support for asynchronous probing
Date: Tue, 11 Mar 2014 00:15:40 +0100
Message-Id: <1394493359-14115-30-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394493359-14115-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lars-Peter Clausen <lars@metafoo.de>

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/i2c/adv7604.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index de3db42..c3a76ac 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -2333,6 +2333,11 @@ static int adv7604_probe(struct i2c_client *client,
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
@@ -2356,6 +2361,7 @@ static int adv7604_remove(struct i2c_client *client)
 
 	cancel_delayed_work(&state->delayed_work_enable_hotplug);
 	destroy_workqueue(state->work_queues);
+	v4l2_async_unregister_subdev(sd);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7604_unregister_clients(to_state(sd));
-- 
1.8.3.2

