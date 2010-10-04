Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:63335 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0JDTcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Oct 2010 15:32:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] dabusb: remove the BKL
Date: Mon, 4 Oct 2010 21:32:05 +0200
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010042132.05292.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The dabusb device driver is sufficiently serialized using
its own mutex, no need for the big kernel lock here
in addition.
    
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
---

Hi Mauro,

I just realized that the dabusb driver is not actually a v4l driver,
when I did more test builds with allyesconfig and CONFIG_BKL disabled.

I've added this patch to my bkl/config queue for now, but if you want to carry
it in your tree, I'll drop it from mine.

diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 5b176bd..f3e25e9 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -32,7 +32,6 @@
 #include <linux/list.h>
 #include <linux/vmalloc.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
@@ -621,7 +620,6 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	if (devnum < DABUSB_MINOR || devnum >= (DABUSB_MINOR + NRDABUSB))
 		return -EIO;
 
-	lock_kernel();
 	s = &dabusb[devnum - DABUSB_MINOR];
 
 	dbg("dabusb_open");
@@ -630,21 +628,17 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	while (!s->usbdev || s->opened) {
 		mutex_unlock(&s->mutex);
 
-		if (file->f_flags & O_NONBLOCK) {
+		if (file->f_flags & O_NONBLOCK)
 			return -EBUSY;
-		}
 		msleep_interruptible(500);
 
-		if (signal_pending (current)) {
-			unlock_kernel();
+		if (signal_pending (current))
 			return -EAGAIN;
-		}
 		mutex_lock(&s->mutex);
 	}
 	if (usb_set_interface (s->usbdev, _DABUSB_IF, 1) < 0) {
 		mutex_unlock(&s->mutex);
 		dev_err(&s->usbdev->dev, "set_interface failed\n");
-		unlock_kernel();
 		return -EINVAL;
 	}
 	s->opened = 1;
@@ -654,7 +648,6 @@ static int dabusb_open (struct inode *inode, struct file *file)
 	file->private_data = s;
 
 	r = nonseekable_open(inode, file);
-	unlock_kernel();
 	return r;
 }
 
@@ -689,17 +682,13 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 
 	dbg("dabusb_ioctl");
 
-	lock_kernel();
-	if (s->remove_pending) {
-		unlock_kernel();
+	if (s->remove_pending)
 		return -EIO;
-	}
 
 	mutex_lock(&s->mutex);
 
 	if (!s->usbdev) {
 		mutex_unlock(&s->mutex);
-		unlock_kernel();
 		return -EIO;
 	}
 
@@ -735,7 +724,6 @@ static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg
 		break;
 	}
 	mutex_unlock(&s->mutex);
-	unlock_kernel();
 	return ret;
 }
 
