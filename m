Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:54336 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab0INTfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Sep 2010 15:35:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: arnd@arndb.de
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 16/18] dvb-core: kill the big kernel lock
Date: Tue, 14 Sep 2010 21:35:07 +0200
Message-Id: <1284492909-7147-17-git-send-email-arnd@arndb.de>
In-Reply-To: <1284492909-7147-1-git-send-email-arnd@arndb.de>
References: <1284492909-7147-1-git-send-email-arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The dvb core only uses the big kernel lock in the open
and ioctl functions, which means it can be replaced with
a dvb specific mutex. Fortunately, all the ioctl functions
go through dvb_usercopy, so we can move the serialization
in there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/dvb/dvb-core/dmxdev.c         |   17 ++---------------
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |    8 +-------
 drivers/media/dvb/dvb-core/dvb_net.c        |    9 +--------
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 +++++++----------
 4 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index 0042306..2de13b0 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
-#include <linux/smp_lock.h>
 #include <linux/poll.h>
 #include <linux/ioctl.h>
 #include <linux/wait.h>
@@ -1088,13 +1087,7 @@ static int dvb_demux_do_ioctl(struct file *file,
 static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
-	int ret;
-
-	lock_kernel();
-	ret = dvb_usercopy(file, cmd, arg, dvb_demux_do_ioctl);
-	unlock_kernel();
-
-	return ret;
+	return dvb_usercopy(file, cmd, arg, dvb_demux_do_ioctl);
 }
 
 static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
@@ -1186,13 +1179,7 @@ static int dvb_dvr_do_ioctl(struct file *file,
 static long dvb_dvr_ioctl(struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
-	int ret;
-
-	lock_kernel();
-	ret = dvb_usercopy(file, cmd, arg, dvb_dvr_do_ioctl);
-	unlock_kernel();
-
-	return ret;
+	return dvb_usercopy(file, cmd, arg, dvb_dvr_do_ioctl);
 }
 
 static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index cb97e6b..1723a98 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -1259,13 +1259,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct file *file,
 static long dvb_ca_en50221_io_ioctl(struct file *file,
 				    unsigned int cmd, unsigned long arg)
 {
-	int ret;
-
-	lock_kernel();
-	ret = dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
-	unlock_kernel();
-
-	return ret;
+	return dvb_usercopy(file, cmd, arg, dvb_ca_en50221_io_do_ioctl);
 }
 
 
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index 6c3a8a0..a080322 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -59,7 +59,6 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/dvb/net.h>
-#include <linux/smp_lock.h>
 #include <linux/uio.h>
 #include <asm/uaccess.h>
 #include <linux/crc32.h>
@@ -1445,13 +1444,7 @@ static int dvb_net_do_ioctl(struct file *file,
 static long dvb_net_ioctl(struct file *file,
 	      unsigned int cmd, unsigned long arg)
 {
-	int ret;
-
-	lock_kernel();
-	ret = dvb_usercopy(file, cmd, arg, dvb_net_do_ioctl);
-	unlock_kernel();
-
-	return ret;
+	return dvb_usercopy(file, cmd, arg, dvb_net_do_ioctl);
 }
 
 static int dvb_net_close(struct inode *inode, struct file *file)
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index b915c39..28f486e 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -32,9 +32,9 @@
 #include <linux/fs.h>
 #include <linux/cdev.h>
 #include <linux/mutex.h>
-#include <linux/smp_lock.h>
 #include "dvbdev.h"
 
+static DEFINE_MUTEX(dvbdev_mutex);
 static int dvbdev_debug;
 
 module_param(dvbdev_debug, int, 0644);
@@ -68,7 +68,7 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 {
 	struct dvb_device *dvbdev;
 
-	lock_kernel();
+	mutex_lock(&dvbdev_mutex);
 	down_read(&minor_rwsem);
 	dvbdev = dvb_minors[iminor(inode)];
 
@@ -91,12 +91,12 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		}
 		fops_put(old_fops);
 		up_read(&minor_rwsem);
-		unlock_kernel();
+		mutex_unlock(&dvbdev_mutex);
 		return err;
 	}
 fail:
 	up_read(&minor_rwsem);
-	unlock_kernel();
+	mutex_unlock(&dvbdev_mutex);
 	return -ENODEV;
 }
 
@@ -158,7 +158,6 @@ long dvb_generic_ioctl(struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
 	struct dvb_device *dvbdev = file->private_data;
-	int ret;
 
 	if (!dvbdev)
 		return -ENODEV;
@@ -166,11 +165,7 @@ long dvb_generic_ioctl(struct file *file,
 	if (!dvbdev->kernel_ioctl)
 		return -EINVAL;
 
-	lock_kernel();
-	ret = dvb_usercopy(file, cmd, arg, dvbdev->kernel_ioctl);
-	unlock_kernel();
-
-	return ret;
+	return dvb_usercopy(file, cmd, arg, dvbdev->kernel_ioctl);
 }
 EXPORT_SYMBOL(dvb_generic_ioctl);
 
@@ -421,8 +416,10 @@ int dvb_usercopy(struct file *file,
 	}
 
 	/* call driver */
+	mutex_lock(&dvbdev_mutex);
 	if ((err = func(file, cmd, parg)) == -ENOIOCTLCMD)
 		err = -EINVAL;
+	mutex_unlock(&dvbdev_mutex);
 
 	if (err < 0)
 		goto out;
-- 
1.7.1

