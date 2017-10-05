Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59219 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdJEIpg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:36 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 14/25] media: lirc: do not call rc_close() on unregistered devices
Date: Thu,  5 Oct 2017 09:45:16 +0100
Message-Id: <0ee960d18bcaca9947b94a8c29df1007cf4ebb48.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
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
index 9ae60a5fa6d2..c0904fe1a6d4 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -871,7 +871,7 @@ void rc_close(struct rc_dev *rdev)
 	if (rdev) {
 		mutex_lock(&rdev->lock);
 
-		if (!--rdev->users && rdev->close != NULL)
+		if (!--rdev->users && rdev->close && rdev->registered)
 			rdev->close(rdev);
 
 		mutex_unlock(&rdev->lock);
-- 
2.13.6
