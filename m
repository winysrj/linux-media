Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1052 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752951AbaCGQOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:09 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/7] [media] adv7180: Fix remove order
Date: Fri,  7 Mar 2014 17:14:27 +0100
Message-Id: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mutex is used in the subdev callbacks, so unregister the subdev before the
mutex is destroyed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index d7d99f1..1a3622a 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -616,8 +616,8 @@ static int adv7180_probe(struct i2c_client *client,
 err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unreg_subdev:
-	mutex_destroy(&state->mutex);
 	v4l2_device_unregister_subdev(sd);
+	mutex_destroy(&state->mutex);
 err:
 	printk(KERN_ERR KBUILD_MODNAME ": Failed to probe: %d\n", ret);
 	return ret;
@@ -640,8 +640,8 @@ static int adv7180_remove(struct i2c_client *client)
 		}
 	}
 
-	mutex_destroy(&state->mutex);
 	v4l2_device_unregister_subdev(sd);
+	mutex_destroy(&state->mutex);
 	return 0;
 }
 
-- 
1.8.0

