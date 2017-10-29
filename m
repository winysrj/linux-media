Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:47171 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932115AbdJ2U70 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 29 Oct 2017 16:59:26 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 19/28] media: lirc: do not call rc_close() on unregistered devices
Date: Sun, 29 Oct 2017 20:59:25 +0000
Message-Id: <7cd54b39b168355dbe013a4b32e11fa4262dac1b.1509309834.git.sean@mess.org>
In-Reply-To: <cover.1509309834.git.sean@mess.org>
References: <cover.1509309834.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a lirc chardev is held open after a device is unplugged, rc_close()
will be called after rc_unregister_device(). The driver is not expecting
any calls at this point, and the iguanair driver causes an oops in
this scenario.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 9e73899b5994..9a8fc86b0835 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -885,7 +885,7 @@ void rc_close(struct rc_dev *rdev)
 	if (rdev) {
 		mutex_lock(&rdev->lock);
 
-		if (!--rdev->users && rdev->close != NULL)
+		if (!--rdev->users && rdev->close && rdev->registered)
 			rdev->close(rdev);
 
 		mutex_unlock(&rdev->lock);
-- 
2.13.6
