Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:56899 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbcF2NVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 09:21:06 -0400
From: Andi Shyti <andi.shyti@samsung.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi.shyti@samsung.com>,
	Andi Shyti <andi@etezian.org>
Subject: [PATCH 14/15] lirc_dev: fix potential segfault
Date: Wed, 29 Jun 2016 22:20:43 +0900
Message-id: <1467206444-9935-15-git-send-email-andi.shyti@samsung.com>
In-reply-to: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When opening or closing a lirc character device, the framework
provides to the user the possibility to keep track of opening or
closing of the device by calling two functions:

 - set_use_inc() when opening the device
 - set_use_dec() when closing the device

if those are not set by the lirc user, the system segfaults.
Check the pointer value before calling the above functions.

Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
---
 drivers/media/rc/lirc_dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 0a3d65d..58dabdc 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -412,7 +412,10 @@ int lirc_unregister_driver(int minor)
 			ir->d.name, ir->d.minor);
 		wake_up_interruptible(&ir->buf->wait_poll);
 		mutex_lock(&ir->irctl_lock);
-		ir->d.set_use_dec(ir->d.data);
+
+		if (ir->d.set_use_dec)
+			ir->d.set_use_dec(ir->d.data);
+
 		module_put(cdev->owner);
 		mutex_unlock(&ir->irctl_lock);
 	} else {
@@ -471,7 +474,8 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	cdev = ir->cdev;
 	if (try_module_get(cdev->owner)) {
 		ir->open++;
-		retval = ir->d.set_use_inc(ir->d.data);
+		if (ir->d.set_use_inc)
+			retval = ir->d.set_use_inc(ir->d.data);
 
 		if (retval) {
 			module_put(cdev->owner);
@@ -512,7 +516,8 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	ir->open--;
 	if (ir->attached) {
-		ir->d.set_use_dec(ir->d.data);
+		if (ir->d.set_use_dec)
+			ir->d.set_use_dec(ir->d.data);
 		module_put(cdev->owner);
 	} else {
 		lirc_irctl_cleanup(ir);
-- 
2.8.1

