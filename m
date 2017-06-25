Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56415 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdFYMbm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:31:42 -0400
Subject: [PATCH 05/19] lirc_dev: make better use of file->private_data
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:31:40 +0200
Message-ID: <149839390015.28811.7835116643584059188.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

By making better use of file->private_data in lirc_dev we can avoid
digging around in the irctls[] array, thereby simplifying the code.

External drivers need to use lirc_get_pdata() instead of mucking around
in file->private_data.

The newly introduced lirc_init_pdata() function isn't very elegant, but
it's a stopgap measure which can be removed once lirc_zilog is converted
to rc-core.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/lirc_dev.c             |   70 +++++++++----------------------
 drivers/staging/media/lirc/lirc_zilog.c |   53 ++++-------------------
 include/media/lirc_dev.h                |    3 +
 3 files changed, 33 insertions(+), 93 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 61ed90a975ad..2de840dd829d 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -243,36 +243,18 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
-	struct irctl *ir;
+	struct irctl *ir = container_of(inode->i_cdev, struct irctl, cdev);
 	int retval;
 
-	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
-		pr_err("open result for %d is -ENODEV\n", iminor(inode));
-		return -ENODEV;
-	}
-
-	if (mutex_lock_interruptible(&lirc_dev_lock))
-		return -ERESTARTSYS;
-
-	ir = irctls[iminor(inode)];
-	mutex_unlock(&lirc_dev_lock);
-
-	if (!ir) {
-		retval = -ENODEV;
-		goto error;
-	}
-
 	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
 
-	if (ir->open) {
-		retval = -EBUSY;
-		goto error;
-	}
+	if (ir->open)
+		return -EBUSY;
 
 	if (ir->d.rdev) {
 		retval = rc_open(ir->d.rdev);
 		if (retval)
-			goto error;
+			return retval;
 	}
 
 	if (ir->buf)
@@ -280,25 +262,18 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 
 	ir->open++;
 
+	lirc_init_pdata(inode, file);
 	nonseekable_open(inode, file);
 
 	return 0;
-
-error:
-	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = irctls[iminor(inode)];
+	struct irctl *ir = file->private_data;
 	int ret;
 
-	if (!ir) {
-		pr_err("called with invalid irctl\n");
-		return -EINVAL;
-	}
-
 	ret = mutex_lock_killable(&lirc_dev_lock);
 	WARN_ON(ret);
 
@@ -314,14 +289,9 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
 
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 {
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct irctl *ir = file->private_data;
 	unsigned int ret;
 
-	if (!ir) {
-		pr_err("called with invalid irctl\n");
-		return POLLERR;
-	}
-
 	if (!ir->attached)
 		return POLLHUP | POLLERR;
 
@@ -344,14 +314,9 @@ EXPORT_SYMBOL(lirc_dev_fop_poll);
 
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	struct irctl *ir = file->private_data;
 	__u32 mode;
 	int result = 0;
-	struct irctl *ir = irctls[iminor(file_inode(file))];
-
-	if (!ir) {
-		pr_err("no irctl found!\n");
-		return -ENODEV;
-	}
 
 	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
 		ir->d.name, ir->d.minor, cmd);
@@ -410,16 +375,11 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			  size_t length,
 			  loff_t *ppos)
 {
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct irctl *ir = file->private_data;
 	unsigned char *buf;
 	int ret = 0, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	if (!ir) {
-		pr_err("called with invalid irctl\n");
-		return -ENODEV;
-	}
-
 	if (!LIRC_CAN_REC(ir->d.features))
 		return -EINVAL;
 
@@ -510,9 +470,19 @@ ssize_t lirc_dev_fop_read(struct file *file,
 }
 EXPORT_SYMBOL(lirc_dev_fop_read);
 
+void lirc_init_pdata(struct inode *inode, struct file *file)
+{
+	struct irctl *ir = container_of(inode->i_cdev, struct irctl, cdev);
+
+	file->private_data = ir;
+}
+EXPORT_SYMBOL(lirc_init_pdata);
+
 void *lirc_get_pdata(struct file *file)
 {
-	return irctls[iminor(file_inode(file))]->d.data;
+	struct irctl *ir = file->private_data;
+
+	return ir->d.data;
 }
 EXPORT_SYMBOL(lirc_get_pdata);
 
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 10594aea2a5c..6d4c5a957ab4 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -879,7 +879,7 @@ static int fw_load(struct IR_tx *tx)
 static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 		    loff_t *ppos)
 {
-	struct IR *ir = filep->private_data;
+	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	int ret = 0, written = 0, retries = 0;
@@ -1089,7 +1089,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		     loff_t *ppos)
 {
-	struct IR *ir = filep->private_data;
+	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_tx *tx;
 	size_t i;
 	int failures = 0;
@@ -1197,7 +1197,7 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 /* copied from lirc_dev */
 static unsigned int poll(struct file *filep, poll_table *wait)
 {
-	struct IR *ir = filep->private_data;
+	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
@@ -1230,7 +1230,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 
 static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
-	struct IR *ir = filep->private_data;
+	struct IR *ir = lirc_get_pdata(filep);
 	unsigned long __user *uptr = (unsigned long __user *)arg;
 	int result;
 	unsigned long mode, features;
@@ -1280,46 +1280,18 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	return result;
 }
 
-static struct IR *get_ir_device_by_minor(unsigned int minor)
-{
-	struct IR *ir;
-	struct IR *ret = NULL;
-
-	mutex_lock(&ir_devices_lock);
-
-	if (!list_empty(&ir_devices_list)) {
-		list_for_each_entry(ir, &ir_devices_list, list) {
-			if (ir->l.minor == minor) {
-				ret = get_ir_device(ir, true);
-				break;
-			}
-		}
-	}
-
-	mutex_unlock(&ir_devices_lock);
-	return ret;
-}
-
 /*
- * Open the IR device.  Get hold of our IR structure and
- * stash it in private_data for the file
+ * Open the IR device.
  */
 static int open(struct inode *node, struct file *filep)
 {
 	struct IR *ir;
-	unsigned int minor = MINOR(node->i_rdev);
-
-	/* find our IR struct */
-	ir = get_ir_device_by_minor(minor);
 
-	if (!ir)
-		return -ENODEV;
+	lirc_init_pdata(node, filep);
+	ir = lirc_get_pdata(filep);
 
 	atomic_inc(&ir->open_count);
 
-	/* stash our IR struct */
-	filep->private_data = ir;
-
 	nonseekable_open(node, filep);
 	return 0;
 }
@@ -1327,14 +1299,7 @@ static int open(struct inode *node, struct file *filep)
 /* Close the IR device */
 static int close(struct inode *node, struct file *filep)
 {
-	/* find our IR struct */
-	struct IR *ir = filep->private_data;
-
-	if (!ir) {
-		pr_err("ir: %s: no private_data attached to the file!\n",
-		       __func__);
-		return -ENODEV;
-	}
+	struct IR *ir = lirc_get_pdata(filep);
 
 	atomic_dec(&ir->open_count);
 
@@ -1489,6 +1454,8 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 */
 		ir->l.rbuf = &ir->rbuf;
 		ir->l.dev  = &adap->dev;
+		/* This will be returned by lirc_get_pdata() */
+		ir->l.data = ir;
 		ret = lirc_buffer_init(ir->l.rbuf,
 				       ir->l.chunk_size, ir->l.buffer_size);
 		if (ret)
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 53eef86e07a0..20c5c5d6f101 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -179,6 +179,9 @@ extern int lirc_register_driver(struct lirc_driver *d);
 
 extern void lirc_unregister_driver(struct lirc_driver *d);
 
+/* Must be called in the open fop before lirc_get_pdata() can be used */
+void lirc_init_pdata(struct inode *inode, struct file *file);
+
 /* Returns the private data stored in the lirc_driver
  * associated with the given device file pointer.
  */
