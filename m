Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46870 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbaCAWwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Mar 2014 17:52:32 -0500
Received: by mail-wi0-f172.google.com with SMTP id r20so2025519wiv.17
        for <linux-media@vger.kernel.org>; Sat, 01 Mar 2014 14:52:31 -0800 (PST)
From: James Hogan <james.hogan@imgtec.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-media@vger.kernel.org
Subject: [PATCH] rc-main: fix missing unlock if no devno left
Date: Sat,  1 Mar 2014 22:52:25 +0000
Message-Id: <1393714345-28585-1-git-send-email-james.hogan@imgtec.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While playing with make coccicheck I noticed this message:
drivers/media/rc/rc-main.c:1245:3-9: preceding lock on line 1238

It was introduced by commit 587d1b06e07b ([media] rc-core: reuse device
numbers) which returns -ENOMEM after a mutex_lock without first
unlocking it when there are no more device numbers left. The added code
doesn't depend on the device lock, so move it before the lock is taken.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/rc/rc-main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 2ec60f8..79bcd41 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1228,24 +1228,24 @@ int rc_register_device(struct rc_dev *dev)
 		dev->input_dev->open = ir_open;
 	if (dev->close)
 		dev->input_dev->close = ir_close;
 
-	/*
-	 * Take the lock here, as the device sysfs node will appear
-	 * when device_add() is called, which may trigger an ir-keytable udev
-	 * rule, which will in turn call show_protocols and access
-	 * dev->enabled_protocols before it has been initialized.
-	 */
-	mutex_lock(&dev->lock);
-
 	do {
 		devno = find_first_zero_bit(ir_core_dev_number,
 					    IRRCV_NUM_DEVICES);
 		/* No free device slots */
 		if (devno >= IRRCV_NUM_DEVICES)
 			return -ENOMEM;
 	} while (test_and_set_bit(devno, ir_core_dev_number));
 
+	/*
+	 * Take the lock here, as the device sysfs node will appear
+	 * when device_add() is called, which may trigger an ir-keytable udev
+	 * rule, which will in turn call show_protocols and access
+	 * dev->enabled_protocols before it has been initialized.
+	 */
+	mutex_lock(&dev->lock);
+
 	dev->devno = devno;
 	dev_set_name(&dev->dev, "rc%ld", dev->devno);
 	dev_set_drvdata(&dev->dev, dev);
 	rc = device_add(&dev->dev);
-- 
1.8.3.2

