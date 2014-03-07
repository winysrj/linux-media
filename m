Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-096.synserver.de ([212.40.185.96]:1092 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753093AbaCGQOJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Mar 2014 11:14:09 -0500
From: Lars-Peter Clausen <lars@metafoo.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/7] [media] adv7180: Remove duplicated probe error message
Date: Fri,  7 Mar 2014 17:14:30 +0100
Message-Id: <1394208873-23260-4-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-1-git-send-email-lars@metafoo.de>
References: <1394208873-23260-1-git-send-email-lars@metafoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device driver core already prints out a very similar message when a driver
fails to probe. No need to print one in the driver itself.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/media/i2c/adv7180.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 85cb4e9..98a3ff1 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -618,7 +618,6 @@ err_free_ctrl:
 err_unreg_subdev:
 	mutex_destroy(&state->mutex);
 err:
-	printk(KERN_ERR KBUILD_MODNAME ": Failed to probe: %d\n", ret);
 	return ret;
 }
 
-- 
1.8.0

