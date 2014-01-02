Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:50868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABMIG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 07:08:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH, RFC 07/30] [media] radio-cadet: avoid interruptible_sleep_on race
Date: Thu,  2 Jan 2014 13:07:31 +0100
Message-Id: <1388664474-1710039-8-git-send-email-arnd@arndb.de>
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

interruptible_sleep_on is racy and going away. This replaces
one use in the radio-cadet driver with an open-coded
wait loop that lets us check the condition under the mutex
but sleep without it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/radio/radio-cadet.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 545c04c..67b5bbf 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -39,6 +39,7 @@
 #include <linux/pnp.h>
 #include <linux/sched.h>
 #include <linux/io.h>		/* outb, outb_p			*/
+#include <linux/wait.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
@@ -323,25 +324,32 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 	struct cadet *dev = video_drvdata(file);
 	unsigned char readbuf[RDS_BUFFER];
 	int i = 0;
+	DEFINE_WAIT(wait);
 
 	mutex_lock(&dev->lock);
 	if (dev->rdsstat == 0)
 		cadet_start_rds(dev);
-	if (dev->rdsin == dev->rdsout) {
+	while (1) {
+		prepare_to_wait(&dev->read_queue, &wait, TASK_INTERRUPTIBLE);
+		if (dev->rdsin != dev->rdsout)
+			break;
+
 		if (file->f_flags & O_NONBLOCK) {
 			i = -EWOULDBLOCK;
 			goto unlock;
 		}
 		mutex_unlock(&dev->lock);
-		interruptible_sleep_on(&dev->read_queue);
+		schedule();
 		mutex_lock(&dev->lock);
 	}
+
 	while (i < count && dev->rdsin != dev->rdsout)
 		readbuf[i++] = dev->rdsbuf[dev->rdsout++];
 
 	if (i && copy_to_user(data, readbuf, i))
 		i = -EFAULT;
 unlock:
+	finish_wait(&dev->read_queue, &wait);
 	mutex_unlock(&dev->lock);
 	return i;
 }
-- 
1.8.3.2

