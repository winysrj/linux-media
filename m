Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1111 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753630AbaCGQOL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:11 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 6/7] [media] adv7180: Add support for async device registration
Date: Fri,  7 Mar 2014 17:14:32 +0100
Message-Id: <1394208873-23260-6-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-1-git-send-email-lars@metafoo.de>
References: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for async device registration to the adv7180 driver.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index c750aae..623cec5 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -597,8 +597,16 @@ static int adv7180_probe(struct i2c_client *client,
 	ret = init_device(client, state);
 	if (ret)
 		goto err_free_ctrl;
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret)
+		goto err_free_irq;
+
 	return 0;
 
+err_free_irq:
+	if (state->irq > 0)
+		free_irq(client->irq, state);
 err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unreg_subdev:
@@ -612,6 +620,8 @@ static int adv7180_remove(struct i2c_client *client)
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
 
+	v4l2_async_unregister_subdev(sd);
+
 	if (state->irq > 0)
 		free_irq(client->irq, state);
 
-- 
1.8.0

