Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44274 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933293Ab2EWJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:54 -0400
Subject: [PATCH 15/43] rc-core: add ioctl support to the rc chardev
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:19 +0200
Message-ID: <20120523094319.14474.160.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add basic support for ioctl operations on the rc chardev.

Only two ioctl's are defined for now: one to get the rc-core
version and one to get the driver type of a given chardev.

Userspace is expected to make sure that both match the expected
values before proceeding with any ioctl/read/write ops.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 drivers/media/rc/rc-main.c           |   66 ++++++++++++++++++++++++++++++++++
 include/media/rc-core.h              |   19 ++++++++++
 3 files changed, 86 insertions(+)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index e34b531..2a69c0d 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -269,6 +269,7 @@ Code  Seq#(hex)	Include File		Comments
 'v'	C0-FF	linux/meye.h		conflict!
 'v'	D0-DF	drivers/media/video/cpia2/cpia2dev.h	conflict!
 'w'	all				CERN SCI driver
+'x'	all	media/rc-core.h		Remote Control drivers
 'y'	00-1F				packet based user level communications
 					<mailto:zapman@interlan.net>
 'z'	00-3F				CAN bus card	conflict!
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 3389822..d9ed1a8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1663,6 +1663,68 @@ static int rc_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &client->fasync);
 }
 
+/**
+ * rc_do_ioctl() - internal implementation of ioctl handling
+ * @dev:	the &struct rc_dev to perform the command on
+ * @cmd:	the ioctl command to perform
+ * @arg:	the argument to the ioctl cmd
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which is called with the @dev mutex held) performs
+ * the actual processing of ioctl commands.
+ */
+static long rc_do_ioctl(struct rc_dev *dev, unsigned int cmd, unsigned long arg)
+{
+	void __user *p = (void __user *)arg;
+	unsigned int __user *ip = (unsigned int __user *)p;
+
+	switch (cmd) {
+
+	case RCIOCGVERSION:
+		return put_user(RC_VERSION, ip);
+
+	case RCIOCGTYPE:
+		return put_user(dev->driver_type, ip);
+	}
+
+	return -EINVAL;
+}
+
+/**
+ * rc_ioctl() - allows userspace to do ioctl operations on the rc device file
+ * @fd:		the file descriptor corresponding to the opened rc device
+ * @file:	the &struct file corresponding to the previous open()
+ * @cmd:	the ioctl command to perform
+ * @arg:	the argument to the ioctl cmd
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which implements the ioctl functionality in
+ * &struct file_operations) allows userspace to perform various ioctl
+ * operations on a rc device file.
+ */
+static long rc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+	int ret;
+
+	ret = mutex_lock_interruptible(&dev->lock);
+	if (ret)
+		return ret;
+
+	if (!dev->exist) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = rc_do_ioctl(dev, cmd, arg);
+
+out:
+	mutex_unlock(&dev->lock);
+	return ret;
+}
+
+
 static const struct file_operations rc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= rc_open,
@@ -1671,6 +1733,10 @@ static const struct file_operations rc_fops = {
 	.write		= rc_write,
 	.poll		= rc_poll,
 	.fasync		= rc_fasync,
+	.unlocked_ioctl	= rc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= rc_ioctl,
+#endif
 };
 
 static int __init rc_core_init(void)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 1810984..e3d445b 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -29,6 +29,25 @@ do {								\
 		pr_debug("%s: " fmt, __func__, ##__VA_ARGS__);	\
 } while (0)
 
+#define RC_VERSION 0x010000
+
+/*
+ * ioctl definitions
+ *
+ * Note: userspace programs which wish to interact with /dev/rc/rc? devices
+ *	 should make sure that the RC version and driver type is known
+ *	 (by using RCIOCGVERSION and RCIOCGTYPE) before continuing with any
+ *	 read/write/ioctl ops.
+ */
+#define RC_IOC_MAGIC	'x'
+
+/* get rc version */
+#define RCIOCGVERSION	_IOR(RC_IOC_MAGIC, 0x01, unsigned int)
+
+/* get driver/hardware type */
+#define RCIOCGTYPE	_IOR(RC_IOC_MAGIC, 0x02, unsigned int)
+
+
 enum rc_driver_type {
 	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
 	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */

