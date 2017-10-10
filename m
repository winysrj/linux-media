Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33367 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755354AbdJJHSS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 03:18:18 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 15/26] media: lirc: do not call rc_close() on unregistered devices
Date: Tue, 10 Oct 2017 08:18:17 +0100
Message-Id: <c4bbdade93f3cf832660ce295117fa4c7273991b.1507618841.git.sean@mess.org>
In-Reply-To: <cover.1507618840.git.sean@mess.org>
References: <cover.1507618840.git.sean@mess.org>
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
