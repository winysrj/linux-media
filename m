Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44290 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab2EWJy5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:57 -0400
Subject: [PATCH 34/43] rc-core: rename mutex
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:44:59 +0200
Message-ID: <20120523094459.14474.2918.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Having a mutex named "lock" is a bit misleading.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-keytable.c |    8 ++++----
 drivers/media/rc/rc-main.c     |   22 +++++++++++-----------
 include/media/rc-core.h        |    4 ++--
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/rc/rc-keytable.c b/drivers/media/rc/rc-keytable.c
index d5b1d88..84c6e96 100644
--- a/drivers/media/rc/rc-keytable.c
+++ b/drivers/media/rc/rc-keytable.c
@@ -699,14 +699,14 @@ static int rc_input_open(struct input_dev *idev)
 	struct rc_keytable *kt = input_get_drvdata(idev);
 	struct rc_dev *dev = kt->dev;
 
-	error = mutex_lock_interruptible(&dev->lock);
+	error = mutex_lock_interruptible(&dev->mutex);
 	if (error)
 		return error;
 
 	if (dev->users++ == 0 && dev->open)
 		error = dev->open(dev);
 
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 	return error;
 }
 
@@ -722,12 +722,12 @@ static void rc_input_close(struct input_dev *idev)
 	struct rc_keytable *kt = input_get_drvdata(idev);
 	struct rc_dev *dev = kt->dev;
 
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->mutex);
 
 	if (--dev->users == 0 && dev->close)
 		dev->close(dev);
 
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 }
 
 /**
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index c2c42f9..14728fc 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -231,7 +231,7 @@ static struct {
  * It returns the protocol names of supported protocols.
  * Enabled protocols are printed in brackets.
  *
- * dev->lock is taken to guard against races between store_protocols
+ * dev->mutex is taken to guard against races between store_protocols
  * and show_protocols.
  */
 static ssize_t show_protocols(struct device *device,
@@ -246,7 +246,7 @@ static ssize_t show_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->mutex);
 
 	enabled = dev->enabled_protocols;
 	allowed = dev->get_protocols(dev);
@@ -269,7 +269,7 @@ static ssize_t show_protocols(struct device *device,
 		tmp--;
 	*tmp = '\n';
 
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 
 	return tmp + 1 - buf;
 }
@@ -290,7 +290,7 @@ static ssize_t show_protocols(struct device *device,
  * Returns -EINVAL if an invalid protocol combination or unknown protocol name
  * is used, otherwise @len.
  *
- * dev->lock is taken to guard against races between store_protocols and
+ * dev->mutex is taken to guard against races between store_protocols and
  * show_protocols.
  */
 static ssize_t store_protocols(struct device *device,
@@ -310,7 +310,7 @@ static ssize_t store_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->mutex);
 
 	if (dev->driver_type != RC_DRIVER_SCANCODE && !dev->raw) {
 		IR_dprintk(1, "Protocol switching not supported\n");
@@ -383,7 +383,7 @@ static ssize_t store_protocols(struct device *device,
 	ret = len;
 
 out:
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 	return ret;
 }
 
@@ -467,7 +467,7 @@ struct rc_dev *rc_allocate_device(void)
 	init_waitqueue_head(&dev->rxwait);
 	init_waitqueue_head(&dev->txwait);
 	spin_lock_init(&dev->txlock);
-	mutex_init(&dev->lock);
+	mutex_init(&dev->mutex);
 
 	dev->dev.type = &rc_dev_type;
 	dev->dev.class = &rc_class;
@@ -623,11 +623,11 @@ void rc_unregister_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	mutex_lock(&dev->lock);
+	mutex_lock(&dev->mutex);
 	dev->exist = false;
 	for (i = 0; i < ARRAY_SIZE(dev->keytables); i++)
 		rc_remove_keytable(dev, i);
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 
 	mutex_lock(&rc_dev_table_mutex);
 	rc_dev_table[dev->minor] = NULL;
@@ -1071,7 +1071,7 @@ static long rc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	struct rc_dev *dev = client->dev;
 	int ret;
 
-	ret = mutex_lock_interruptible(&dev->lock);
+	ret = mutex_lock_interruptible(&dev->mutex);
 	if (ret)
 		return ret;
 
@@ -1083,7 +1083,7 @@ static long rc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	ret = rc_do_ioctl(dev, cmd, arg);
 
 out:
-	mutex_unlock(&dev->lock);
+	mutex_unlock(&dev->mutex);
 	return ret;
 }
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index cf66e91..ab9a72e 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -226,7 +226,7 @@ struct ir_raw_event {
  * @driver_name: name of the hardware driver which registered this device
  * @map_name: name of the default keymap
  * @rc_map: current scan/key table
- * @lock: used where a more specific lock/mutex/etc is not available
+ * @mutex: used where a more specific lock/mutex/etc is not available
  * @minor: unique minor remote control device number
  * @exist: used to determine if the device is still valid
  * @client_list: list of clients (processes which have opened the rc chardev)
@@ -288,7 +288,7 @@ struct rc_dev {
 	const char			*map_name;
 	struct rc_keytable		*keytables[RC_MAX_KEYTABLES];
 	struct list_head		keytable_list;
-	struct mutex			lock;
+	struct mutex			mutex;
 	unsigned int			minor;
 	bool				exist;
 	struct list_head		client_list;

