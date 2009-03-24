Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:52847 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZCXVjg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2009 17:39:36 -0400
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-media@vger.kernel.org
Subject: [PATCH 12/13][Resubmit][drivers/media] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:38:31 -0500
Message-Id: <1237930711-16200-1-git-send-email-stoyboyker@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/media/dvb/bt8xx/dst_ca.c |    7 +++++--
 drivers/media/video/dabusb.c     |   11 ++++++++---
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 0258451..d3487c5 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -552,8 +552,10 @@ free_mem_and_exit:
 	return result;
 }
 
-static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long ioctl_arg)
+static long dst_ca_ioctl(struct file *file, unsigned int cmd, unsigned long ioctl_arg)
 {
+	lock_kernel();
+
 	struct dvb_device* dvbdev = (struct dvb_device*) file->private_data;
 	struct dst_state* state = (struct dst_state*) dvbdev->priv;
 	struct ca_slot_info *p_ca_slot_info;
@@ -647,6 +649,7 @@ static int dst_ca_ioctl(struct inode *inode, struct file *file, unsigned int cmd
 	kfree (p_ca_slot_info);
 	kfree (p_ca_caps);
 
+	unlock_kernel();
 	return result;
 }
 
@@ -684,7 +687,7 @@ static ssize_t dst_ca_write(struct file *file, const char __user *buffer, size_t
 
 static struct file_operations dst_ca_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = dst_ca_ioctl,
+	.unlocked_ioctl = dst_ca_ioctl,
 	.open = dst_ca_open,
 	.release = dst_ca_release,
 	.read = dst_ca_read,
diff --git a/drivers/media/video/dabusb.c b/drivers/media/video/dabusb.c
index 298810d..c31e76f 100644
--- a/drivers/media/video/dabusb.c
+++ b/drivers/media/video/dabusb.c
@@ -657,22 +657,26 @@ static int dabusb_release (struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long dabusb_ioctl (struct file *file, unsigned int cmd, unsigned long arg)
 {
 	pdabusb_t s = (pdabusb_t) file->private_data;
 	pbulk_transfer_t pbulk;
 	int ret = 0;
 	int version = DABUSB_VERSION;
 
+	lock_kernel();
 	dbg("dabusb_ioctl");
 
-	if (s->remove_pending)
+	if (s->remove_pending) {
+		unlock_kernel();
 		return -EIO;
+	}
 
 	mutex_lock(&s->mutex);
 
 	if (!s->usbdev) {
 		mutex_unlock(&s->mutex);
+		unlock_kernel();
 		return -EIO;
 	}
 
@@ -713,6 +717,7 @@ static int dabusb_ioctl (struct inode *inode, struct file *file, unsigned int cm
 		break;
 	}
 	mutex_unlock(&s->mutex);
+	unlock_kernel();
 	return ret;
 }
 
@@ -721,7 +726,7 @@ static const struct file_operations dabusb_fops =
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
 	.read =		dabusb_read,
-	.ioctl =	dabusb_ioctl,
+	.unlocked_ioctl =	dabusb_ioctl,
 	.open =		dabusb_open,
 	.release =	dabusb_release,
 };
-- 
1.6.2.1

