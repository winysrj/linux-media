Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39651 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936994AbdIZUOG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:06 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 13/20] media: lirc: do not call rc_close() on unregistered devices
Date: Tue, 26 Sep 2017 21:13:52 +0100
Message-Id: <90f549715c1cab293bdd5fa1152d7969837cca61.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
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
index 2d7e9f8a15c3..247f19efc852 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -858,7 +858,7 @@ void rc_close(struct rc_dev *rdev)
 	if (rdev) {
 		mutex_lock(&rdev->lock);
 
-		if (!--rdev->users && rdev->close != NULL)
+		if (!--rdev->users && rdev->close && rdev->registered)
 			rdev->close(rdev);
 
 		mutex_unlock(&rdev->lock);
-- 
2.13.5
