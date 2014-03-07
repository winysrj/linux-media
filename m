Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1089 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753039AbaCGQOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:09 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/7] [media] adv7180: Remove unnecessary v4l2_device_unregister_subdev() from probe error path
Date: Fri,  7 Mar 2014 17:14:29 +0100
Message-Id: <1394208873-23260-3-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-1-git-send-email-lars@metafoo.de>
References: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device can't possibly be registered at this point, so no need to to call
v4l2_device_unregister_subdev().

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 2359fd8..85cb4e9 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -616,7 +616,6 @@ static int adv7180_probe(struct i2c_client *client,
 err_free_ctrl:
 	adv7180_exit_controls(state);
 err_unreg_subdev:
-	v4l2_device_unregister_subdev(sd);
 	mutex_destroy(&state->mutex);
 err:
 	printk(KERN_ERR KBUILD_MODNAME ": Failed to probe: %d\n", ret);
-- 
1.8.0

