Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58557 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3EHNqz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 May 2013 09:46:55 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.146.12])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 304EC35A55
	for <linux-media@vger.kernel.org>; Wed,  8 May 2013 15:46:25 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH RESEND 7/9] m5mols: Convert to devm_request_irq()
Date: Wed,  8 May 2013 15:46:32 +0200
Message-Id: <1368020794-21264-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1368020794-21264-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the managed function the free_irq() calls can be removed from the
probe error path and the remove handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 11f6f87..8d870b7 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -988,11 +988,11 @@ static int m5mols_probe(struct i2c_client *client,
 	init_waitqueue_head(&info->irq_waitq);
 	mutex_init(&info->lock);
 
-	ret = request_irq(client->irq, m5mols_irq_handler,
-			  IRQF_TRIGGER_RISING, MODULE_NAME, sd);
+	ret = devm_request_irq(&client->dev, client->irq, m5mols_irq_handler,
+			       IRQF_TRIGGER_RISING, MODULE_NAME, sd);
 	if (ret) {
 		dev_err(&client->dev, "Interrupt request failed: %d\n", ret);
-		goto out_me;
+		goto error;
 	}
 	info->res_type = M5MOLS_RESTYPE_MONITOR;
 	info->ffmt[0] = m5mols_default_ffmt[0];
@@ -1000,7 +1000,7 @@ static int m5mols_probe(struct i2c_client *client,
 
 	ret = m5mols_sensor_power(info, true);
 	if (ret)
-		goto out_irq;
+		goto error;
 
 	ret = m5mols_fw_start(sd);
 	if (!ret)
@@ -1009,9 +1009,7 @@ static int m5mols_probe(struct i2c_client *client,
 	ret = m5mols_sensor_power(info, false);
 	if (!ret)
 		return 0;
-out_irq:
-	free_irq(client->irq, sd);
-out_me:
+error:
 	media_entity_cleanup(&sd->entity);
 	return ret;
 }
@@ -1022,8 +1020,6 @@ static int m5mols_remove(struct i2c_client *client)
 
 	v4l2_device_unregister_subdev(sd);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
-	free_irq(client->irq, sd);
-
 	media_entity_cleanup(&sd->entity);
 
 	return 0;
-- 
1.8.1.5

