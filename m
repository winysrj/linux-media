Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1087 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753240AbaCGQOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:09 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] [media] adv7180: Free control handler on remove()
Date: Fri,  7 Mar 2014 17:14:28 +0100
Message-Id: <1394208873-23260-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-1-git-send-email-lars@metafoo.de>
References: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make sure to free the control handler when the device is removed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 1a3622a..2359fd8 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -641,6 +641,7 @@ static int adv7180_remove(struct i2c_client *client)
 	}
 
 	v4l2_device_unregister_subdev(sd);
+	adv7180_exit_controls(state);
 	mutex_destroy(&state->mutex);
 	return 0;
 }
-- 
1.8.0

