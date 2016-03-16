Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:37900 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbcCPSxu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2016 14:53:50 -0400
Received: by mail-wm0-f43.google.com with SMTP id l68so85948573wml.1
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2016 11:53:50 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH] media: rc: remove unneeded mutex in rc_register_device
Message-ID: <56E9ABB0.3010106@gmail.com>
Date: Wed, 16 Mar 2016 19:53:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Access to dev->initialized is atomic, therefore we don't have to
protect it with a mutex.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/media/rc/rc-main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 4e9bbe7..68541b1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1492,9 +1492,7 @@ int rc_register_device(struct rc_dev *dev)
 	}
 
 	/* Allow the RC sysfs nodes to be accessible */
-	mutex_lock(&dev->lock);
 	atomic_set(&dev->initialized, 1);
-	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
 		   dev->minor,
-- 
2.7.3

