Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab0FAUvj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 16:51:39 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o51Kpdes017774
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:51:39 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [10.16.43.238])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o51KpbLP000971
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:51:38 -0400
Received: from ihatethathostname.lab.bos.redhat.com (ihatethathostname.lab.bos.redhat.com [127.0.0.1])
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.3) with ESMTP id o51Kpb1w031631
	for <linux-media@vger.kernel.org>; Tue, 1 Jun 2010 16:51:37 -0400
Received: (from jarod@localhost)
	by ihatethathostname.lab.bos.redhat.com (8.14.4/8.14.4/Submit) id o51KpbZ7031629
	for linux-media@vger.kernel.org; Tue, 1 Jun 2010 16:51:37 -0400
Date: Tue, 1 Jun 2010 16:51:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/3] IR: add core lirc device interface
Message-ID: <20100601205137.GA31616@redhat.com>
References: <20100601205005.GA28322@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100601205005.GA28322@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the core lirc device interface (http://lirc.org/).

This is a 99.9% unaltered lirc_dev device interface (only change being
the path to lirc.h), which has been carried in the Fedora kernels and
has been built for numerous other distro kernels for years. In the
next two patches in this series, ir-core will be wired up to make use
of the lirc interface as one of many IR protocol decoder options. In
this case, raw IR will be delivered to the lirc userspace daemon, which
will then handle the decoding.

Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig    |   11 +
 drivers/media/IR/Makefile   |    1 +
 drivers/media/IR/lirc_dev.c |  850 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/IR/lirc_dev.h |  228 ++++++++++++
 include/media/lirc.h        |  159 ++++++++
 5 files changed, 1249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/IR/lirc_dev.c
 create mode 100644 drivers/media/IR/lirc_dev.h
 create mode 100644 include/media/lirc.h

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index 7ffa86f..c3010fb 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -8,6 +8,17 @@ config VIDEO_IR
 	depends on IR_CORE
 	default IR_CORE
 
+config LIRC
+	tristate
+	default y
+
+	---help---
+	   Enable this option to build the Linux Infrared Remote
+	   Control (LIRC) core device interface driver. The LIRC
+	   interface passes raw IR to and from userspace, where the
+	   LIRC daemon handles protocol decoding for IR reception ann
+	   encoding for IR transmitting (aka "blasting").
+
 source "drivers/media/IR/keymaps/Kconfig"
 
 config IR_NEC_DECODER
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index b43fe36..3ba00bb 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -5,6 +5,7 @@ obj-y += keymaps/
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
 obj-$(CONFIG_VIDEO_IR) += ir-common.o
+obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
 obj-$(CONFIG_IR_RC6_DECODER) += ir-rc6-decoder.o
diff --git a/drivers/media/IR/lirc_dev.c b/drivers/media/IR/lirc_dev.c
new file mode 100644
index 0000000..7e45800
--- /dev/null
+++ b/drivers/media/IR/lirc_dev.c
@@ -0,0 +1,850 @@
+/*
+ * LIRC base driver
+ *
+ * by Artur Lipowski <alipowski@interia.pl>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/errno.h>
+#include <linux/ioctl.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
+#include <linux/completion.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/wait.h>
+#include <linux/unistd.h>
+#include <linux/kthread.h>
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
+#include <linux/smp_lock.h>
+#ifdef CONFIG_COMPAT
+#include <linux/compat.h>
+#endif
+
+#include <media/lirc.h>
+#include "lirc_dev.h"
+
+static int debug;
+
+#define IRCTL_DEV_NAME	"BaseRemoteCtl"
+#define NOPLUG		-1
+#define LOGHEAD		"lirc_dev (%s[%d]): "
+
+static dev_t lirc_base_dev;
+
+struct irctl {
+	struct lirc_driver d;
+	int attached;
+	int open;
+
+	struct mutex irctl_lock;
+	struct lirc_buffer *buf;
+	unsigned int chunk_size;
+
+	struct task_struct *task;
+	long jiffies_to_wait;
+
+	struct cdev cdev;
+};
+
+static DEFINE_MUTEX(lirc_dev_lock);
+
+static struct irctl *irctls[MAX_IRCTL_DEVICES];
+
+/* Only used for sysfs but defined to void otherwise */
+static struct class *lirc_class;
+
+/*  helper function
+ *  initializes the irctl structure
+ */
+static void init_irctl(struct irctl *ir)
+{
+	dev_dbg(ir->d.dev, LOGHEAD "initializing irctl\n",
+		ir->d.name, ir->d.minor);
+	mutex_init(&ir->irctl_lock);
+	ir->d.minor = NOPLUG;
+}
+
+static void cleanup(struct irctl *ir)
+{
+	dev_dbg(ir->d.dev, LOGHEAD "cleaning up\n", ir->d.name, ir->d.minor);
+
+	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+
+	if (ir->buf != ir->d.rbuf) {
+		lirc_buffer_free(ir->buf);
+		kfree(ir->buf);
+	}
+	ir->buf = NULL;
+}
+
+/*  helper function
+ *  reads key codes from driver and puts them into buffer
+ *  returns 0 on success
+ */
+static int add_to_buf(struct irctl *ir)
+{
+	if (ir->d.add_to_buf) {
+		int res = -ENODATA;
+		int got_data = 0;
+
+		/*
+		 * service the device as long as it is returning
+		 * data and we have space
+		 */
+get_data:
+		res = ir->d.add_to_buf(ir->d.data, ir->buf);
+		if (res == 0) {
+			got_data++;
+			goto get_data;
+		}
+
+		if (res == -ENODEV)
+			kthread_stop(ir->task);
+
+		return got_data ? 0 : res;
+	}
+
+	return 0;
+}
+
+/* main function of the polling thread
+ */
+static int lirc_thread(void *irctl)
+{
+	struct irctl *ir = irctl;
+
+	dev_dbg(ir->d.dev, LOGHEAD "poll thread started\n",
+		ir->d.name, ir->d.minor);
+
+	do {
+		if (ir->open) {
+			if (ir->jiffies_to_wait) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(ir->jiffies_to_wait);
+			}
+			if (kthread_should_stop())
+				break;
+			if (!add_to_buf(ir))
+				wake_up_interruptible(&ir->buf->wait_poll);
+		} else {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule();
+		}
+	} while (!kthread_should_stop());
+
+	dev_dbg(ir->d.dev, LOGHEAD "poll thread ended\n",
+		ir->d.name, ir->d.minor);
+
+	return 0;
+}
+
+
+static struct file_operations fops = {
+	.owner		= THIS_MODULE,
+	.read		= lirc_dev_fop_read,
+	.write		= lirc_dev_fop_write,
+	.poll		= lirc_dev_fop_poll,
+	.ioctl		= lirc_dev_fop_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= lirc_dev_fop_compat_ioctl,
+#endif
+	.open		= lirc_dev_fop_open,
+	.release	= lirc_dev_fop_close,
+};
+
+static int lirc_cdev_add(struct irctl *ir)
+{
+	int retval;
+	struct lirc_driver *d = &ir->d;
+
+	if (d->fops) {
+		cdev_init(&ir->cdev, d->fops);
+		ir->cdev.owner = d->owner;
+	} else {
+		cdev_init(&ir->cdev, &fops);
+		ir->cdev.owner = THIS_MODULE;
+	}
+	kobject_set_name(&ir->cdev.kobj, "lirc%d", d->minor);
+
+	retval = cdev_add(&ir->cdev, MKDEV(MAJOR(lirc_base_dev), d->minor), 1);
+	if (retval)
+		kobject_put(&ir->cdev.kobj);
+
+	return retval;
+}
+
+int lirc_register_driver(struct lirc_driver *d)
+{
+	struct irctl *ir;
+	int minor;
+	int bytes_in_key;
+	unsigned int chunk_size;
+	unsigned int buffer_size;
+	int err;
+
+	if (!d) {
+		printk(KERN_ERR "lirc_dev: lirc_register_driver: "
+		       "driver pointer must be not NULL!\n");
+		err = -EBADRQC;
+		goto out;
+	}
+
+	if (MAX_IRCTL_DEVICES <= d->minor) {
+		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+			"\"minor\" must be between 0 and %d (%d)!\n",
+			MAX_IRCTL_DEVICES-1, d->minor);
+		err = -EBADRQC;
+		goto out;
+	}
+
+	if (1 > d->code_length || (BUFLEN * 8) < d->code_length) {
+		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+			"code length in bits for minor (%d) "
+			"must be less than %d!\n",
+			d->minor, BUFLEN * 8);
+		err = -EBADRQC;
+		goto out;
+	}
+
+	dev_dbg(d->dev, "lirc_dev: lirc_register_driver: sample_rate: %d\n",
+		d->sample_rate);
+	if (d->sample_rate) {
+		if (2 > d->sample_rate || HZ < d->sample_rate) {
+			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+				"sample_rate must be between 2 and %d!\n", HZ);
+			err = -EBADRQC;
+			goto out;
+		}
+		if (!d->add_to_buf) {
+			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+				"add_to_buf cannot be NULL when "
+				"sample_rate is set\n");
+			err = -EBADRQC;
+			goto out;
+		}
+	} else if (!(d->fops && d->fops->read) && !d->rbuf) {
+		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+			"fops->read and rbuf cannot all be NULL!\n");
+		err = -EBADRQC;
+		goto out;
+	} else if (!d->rbuf) {
+		if (!(d->fops && d->fops->read && d->fops->poll &&
+		      d->fops->ioctl)) {
+			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+				"neither read, poll nor ioctl can be NULL!\n");
+			err = -EBADRQC;
+			goto out;
+		}
+	}
+
+	mutex_lock(&lirc_dev_lock);
+
+	minor = d->minor;
+
+	if (minor < 0) {
+		/* find first free slot for driver */
+		for (minor = 0; minor < MAX_IRCTL_DEVICES; minor++)
+			if (!irctls[minor])
+				break;
+		if (MAX_IRCTL_DEVICES == minor) {
+			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+				"no free slots for drivers!\n");
+			err = -ENOMEM;
+			goto out_lock;
+		}
+	} else if (irctls[minor]) {
+		dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+			"minor (%d) just registered!\n", minor);
+		err = -EBUSY;
+		goto out_lock;
+	}
+
+	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
+	if (!ir) {
+		err = -ENOMEM;
+		goto out_lock;
+	}
+	init_irctl(ir);
+	irctls[minor] = ir;
+	d->minor = minor;
+
+	if (d->sample_rate) {
+		ir->jiffies_to_wait = HZ / d->sample_rate;
+	} else {
+		/* it means - wait for external event in task queue */
+		ir->jiffies_to_wait = 0;
+	}
+
+	/* some safety check 8-) */
+	d->name[sizeof(d->name)-1] = '\0';
+
+	bytes_in_key = BITS_TO_LONGS(d->code_length) +
+			(d->code_length % 8 ? 1 : 0);
+	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
+	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
+
+	if (d->rbuf) {
+		ir->buf = d->rbuf;
+	} else {
+		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+		if (!ir->buf) {
+			err = -ENOMEM;
+			goto out_lock;
+		}
+		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
+		if (err) {
+			kfree(ir->buf);
+			goto out_lock;
+		}
+	}
+	ir->chunk_size = ir->buf->chunk_size;
+
+	if (d->features == 0)
+		d->features = LIRC_CAN_REC_LIRCCODE;
+
+	ir->d = *d;
+	ir->d.minor = minor;
+
+	device_create(lirc_class, ir->d.dev,
+		      MKDEV(MAJOR(lirc_base_dev), ir->d.minor), NULL,
+		      "lirc%u", ir->d.minor);
+
+	if (d->sample_rate) {
+		/* try to fire up polling thread */
+		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
+		if (IS_ERR(ir->task)) {
+			dev_err(d->dev, "lirc_dev: lirc_register_driver: "
+				"cannot run poll thread for minor = %d\n",
+				d->minor);
+			err = -ECHILD;
+			goto out_sysfs;
+		}
+	}
+
+	err = lirc_cdev_add(ir);
+	if (err)
+		goto out_sysfs;
+
+	ir->attached = 1;
+	mutex_unlock(&lirc_dev_lock);
+
+	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
+		 ir->d.name, ir->d.minor);
+	return minor;
+
+out_sysfs:
+	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+out_lock:
+	mutex_unlock(&lirc_dev_lock);
+out:
+	return err;
+}
+EXPORT_SYMBOL(lirc_register_driver);
+
+int lirc_unregister_driver(int minor)
+{
+	struct irctl *ir;
+
+	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
+		printk(KERN_ERR "lirc_dev: lirc_unregister_driver: "
+		       "\"minor (%d)\" must be between 0 and %d!\n",
+		       minor, MAX_IRCTL_DEVICES-1);
+		return -EBADRQC;
+	}
+
+	ir = irctls[minor];
+
+	mutex_lock(&lirc_dev_lock);
+
+	if (ir->d.minor != minor) {
+		printk(KERN_ERR "lirc_dev: lirc_unregister_driver: "
+		       "minor (%d) device not registered!", minor);
+		mutex_unlock(&lirc_dev_lock);
+		return -ENOENT;
+	}
+
+	/* end up polling thread */
+	if (ir->task)
+		kthread_stop(ir->task);
+
+	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
+		ir->d.name, ir->d.minor);
+
+	ir->attached = 0;
+	if (ir->open) {
+		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
+			ir->d.name, ir->d.minor);
+		wake_up_interruptible(&ir->buf->wait_poll);
+		mutex_lock(&ir->irctl_lock);
+		ir->d.set_use_dec(ir->d.data);
+		module_put(ir->d.owner);
+		mutex_unlock(&ir->irctl_lock);
+		cdev_del(&ir->cdev);
+	} else {
+		cleanup(ir);
+		cdev_del(&ir->cdev);
+		kfree(ir);
+		irctls[minor] = NULL;
+	}
+
+	mutex_unlock(&lirc_dev_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(lirc_unregister_driver);
+
+int lirc_dev_fop_open(struct inode *inode, struct file *file)
+{
+	struct irctl *ir;
+	int retval = 0;
+
+	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
+		printk(KERN_WARNING "lirc_dev [%d]: open result = -ENODEV\n",
+		       iminor(inode));
+		return -ENODEV;
+	}
+
+	if (mutex_lock_interruptible(&lirc_dev_lock))
+		return -ERESTARTSYS;
+
+	ir = irctls[iminor(inode)];
+	if (!ir) {
+		retval = -ENODEV;
+		goto error;
+	}
+
+	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
+
+	if (ir->d.minor == NOPLUG) {
+		retval = -ENODEV;
+		goto error;
+	}
+
+	if (ir->open) {
+		retval = -EBUSY;
+		goto error;
+	}
+
+	if (try_module_get(ir->d.owner)) {
+		++ir->open;
+		retval = ir->d.set_use_inc(ir->d.data);
+
+		if (retval) {
+			module_put(ir->d.owner);
+			--ir->open;
+		} else {
+			lirc_buffer_clear(ir->buf);
+		}
+		if (ir->task)
+			wake_up_process(ir->task);
+	}
+
+error:
+	if (ir)
+		dev_dbg(ir->d.dev, LOGHEAD "open result = %d\n",
+			ir->d.name, ir->d.minor, retval);
+
+	mutex_unlock(&lirc_dev_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(lirc_dev_fop_open);
+
+int lirc_dev_fop_close(struct inode *inode, struct file *file)
+{
+	struct irctl *ir = irctls[iminor(inode)];
+
+	dev_dbg(ir->d.dev, LOGHEAD "close called\n", ir->d.name, ir->d.minor);
+
+	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
+
+	--ir->open;
+	if (ir->attached) {
+		ir->d.set_use_dec(ir->d.data);
+		module_put(ir->d.owner);
+	} else {
+		cleanup(ir);
+		irctls[ir->d.minor] = NULL;
+		kfree(ir);
+	}
+
+	mutex_unlock(&lirc_dev_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(lirc_dev_fop_close);
+
+unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
+{
+	struct irctl *ir = irctls[iminor(file->f_dentry->d_inode)];
+	unsigned int ret;
+
+	dev_dbg(ir->d.dev, LOGHEAD "poll called\n", ir->d.name, ir->d.minor);
+
+	if (!ir->attached) {
+		mutex_unlock(&ir->irctl_lock);
+		return POLLERR;
+	}
+
+	poll_wait(file, &ir->buf->wait_poll, wait);
+
+	if (ir->buf)
+		if (lirc_buffer_empty(ir->buf))
+			ret = 0;
+		else
+			ret = POLLIN | POLLRDNORM;
+	else
+		ret = POLLERR;
+
+	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
+		ir->d.name, ir->d.minor, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL(lirc_dev_fop_poll);
+
+int lirc_dev_fop_ioctl(struct inode *inode, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+	unsigned long mode;
+	int result = 0;
+	struct irctl *ir = irctls[iminor(inode)];
+
+	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
+		ir->d.name, ir->d.minor, cmd);
+
+	if (ir->d.minor == NOPLUG || !ir->attached) {
+		dev_dbg(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
+			ir->d.name, ir->d.minor);
+		return -ENODEV;
+	}
+
+	switch (cmd) {
+	case LIRC_GET_FEATURES:
+		result = put_user(ir->d.features, (unsigned long *)arg);
+		break;
+	case LIRC_GET_REC_MODE:
+		if (!(ir->d.features & LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = put_user(LIRC_REC2MODE
+				  (ir->d.features & LIRC_CAN_REC_MASK),
+				  (unsigned long *)arg);
+		break;
+	case LIRC_SET_REC_MODE:
+		if (!(ir->d.features & LIRC_CAN_REC_MASK))
+			return -ENOSYS;
+
+		result = get_user(mode, (unsigned long *)arg);
+		if (!result && !(LIRC_MODE2REC(mode) & ir->d.features))
+			result = -EINVAL;
+		/*
+		 * FIXME: We should actually set the mode somehow but
+		 * for now, lirc_serial doesn't support mode changing either
+		 */
+		break;
+	case LIRC_GET_LENGTH:
+		result = put_user(ir->d.code_length, (unsigned long *)arg);
+		break;
+	case LIRC_GET_MIN_TIMEOUT:
+		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
+		    ir->d.min_timeout == 0)
+			return -ENOSYS;
+
+		result = put_user(ir->d.min_timeout, (int *) arg);
+		break;
+	case LIRC_GET_MAX_TIMEOUT:
+		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
+		    ir->d.max_timeout == 0)
+			return -ENOSYS;
+
+		result = put_user(ir->d.max_timeout, (int *) arg);
+		break;
+	default:
+		result = -EINVAL;
+	}
+
+	dev_dbg(ir->d.dev, LOGHEAD "ioctl result = %d\n",
+		ir->d.name, ir->d.minor, result);
+
+	return result;
+}
+EXPORT_SYMBOL(lirc_dev_fop_ioctl);
+
+#ifdef CONFIG_COMPAT
+#define LIRC_GET_FEATURES_COMPAT32     _IOR('i', 0x00000000, __u32)
+
+#define LIRC_GET_SEND_MODE_COMPAT32    _IOR('i', 0x00000001, __u32)
+#define LIRC_GET_REC_MODE_COMPAT32     _IOR('i', 0x00000002, __u32)
+
+#define LIRC_GET_LENGTH_COMPAT32       _IOR('i', 0x0000000f, __u32)
+
+#define LIRC_SET_SEND_MODE_COMPAT32    _IOW('i', 0x00000011, __u32)
+#define LIRC_SET_REC_MODE_COMPAT32     _IOW('i', 0x00000012, __u32)
+
+long lirc_dev_fop_compat_ioctl(struct file *file,
+			       unsigned int cmd32,
+			       unsigned long arg)
+{
+	mm_segment_t old_fs;
+	int ret;
+	unsigned long val;
+	unsigned int cmd;
+
+	switch (cmd32) {
+	case LIRC_GET_FEATURES_COMPAT32:
+	case LIRC_GET_SEND_MODE_COMPAT32:
+	case LIRC_GET_REC_MODE_COMPAT32:
+	case LIRC_GET_LENGTH_COMPAT32:
+	case LIRC_SET_SEND_MODE_COMPAT32:
+	case LIRC_SET_REC_MODE_COMPAT32:
+		/*
+		 * These commands expect (unsigned long *) arg
+		 * but the 32-bit app supplied (__u32 *).
+		 * Conversion is required.
+		 */
+		if (get_user(val, (__u32 *)compat_ptr(arg)))
+			return -EFAULT;
+		lock_kernel();
+		/*
+		 * tell lirc_dev_fop_ioctl that it's safe to use the pointer
+		 * to val which is in kernel address space and not in
+		 * user address space.
+		 */
+		old_fs = get_fs();
+		set_fs(KERNEL_DS);
+
+		cmd = _IOC(_IOC_DIR(cmd32), _IOC_TYPE(cmd32), _IOC_NR(cmd32),
+		(_IOC_TYPECHECK(unsigned long)));
+		ret = lirc_dev_fop_ioctl(file->f_path.dentry->d_inode, file,
+					 cmd, (unsigned long)(&val));
+
+		set_fs(old_fs);
+		unlock_kernel();
+	switch (cmd) {
+	case LIRC_GET_FEATURES:
+	case LIRC_GET_SEND_MODE:
+	case LIRC_GET_REC_MODE:
+	case LIRC_GET_LENGTH:
+		if (!ret && put_user(val, (__u32 *)compat_ptr(arg)))
+			return -EFAULT;
+		break;
+	}
+	return ret;
+
+	case LIRC_GET_SEND_CARRIER:
+	case LIRC_GET_REC_CARRIER:
+	case LIRC_GET_SEND_DUTY_CYCLE:
+	case LIRC_GET_REC_DUTY_CYCLE:
+	case LIRC_GET_REC_RESOLUTION:
+	case LIRC_SET_SEND_CARRIER:
+	case LIRC_SET_REC_CARRIER:
+	case LIRC_SET_SEND_DUTY_CYCLE:
+	case LIRC_SET_REC_DUTY_CYCLE:
+	case LIRC_SET_TRANSMITTER_MASK:
+	case LIRC_SET_REC_DUTY_CYCLE_RANGE:
+	case LIRC_SET_REC_CARRIER_RANGE:
+		/*
+		 * These commands expect (unsigned int *)arg
+		 * so no problems here. Just handle the locking.
+		 */
+		lock_kernel();
+		cmd = cmd32;
+		ret = lirc_dev_fop_ioctl(file->f_path.dentry->d_inode,
+					 file, cmd, arg);
+		unlock_kernel();
+		return ret;
+	default:
+		/* unknown */
+		printk(KERN_ERR "lirc_dev: %s(%s:%d): Unknown cmd %08x\n",
+		       __func__, current->comm, current->pid, cmd32);
+		return -ENOIOCTLCMD;
+	}
+}
+EXPORT_SYMBOL(lirc_dev_fop_compat_ioctl);
+#endif
+
+
+ssize_t lirc_dev_fop_read(struct file *file,
+			  char *buffer,
+			  size_t length,
+			  loff_t *ppos)
+{
+	struct irctl *ir = irctls[iminor(file->f_dentry->d_inode)];
+	unsigned char buf[ir->chunk_size];
+	int ret = 0, written = 0;
+	DECLARE_WAITQUEUE(wait, current);
+
+	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
+
+	if (mutex_lock_interruptible(&ir->irctl_lock))
+		return -ERESTARTSYS;
+	if (!ir->attached) {
+		mutex_unlock(&ir->irctl_lock);
+		return -ENODEV;
+	}
+
+	if (length % ir->chunk_size) {
+		dev_dbg(ir->d.dev, LOGHEAD "read result = -EINVAL\n",
+			ir->d.name, ir->d.minor);
+		mutex_unlock(&ir->irctl_lock);
+		return -EINVAL;
+	}
+
+	/*
+	 * we add ourselves to the task queue before buffer check
+	 * to avoid losing scan code (in case when queue is awaken somewhere
+	 * between while condition checking and scheduling)
+	 */
+	add_wait_queue(&ir->buf->wait_poll, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	/*
+	 * while we didn't provide 'length' bytes, device is opened in blocking
+	 * mode and 'copy_to_user' is happy, wait for data.
+	 */
+	while (written < length && ret == 0) {
+		if (lirc_buffer_empty(ir->buf)) {
+			/* According to the read(2) man page, 'written' can be
+			 * returned as less than 'length', instead of blocking
+			 * again, returning -EWOULDBLOCK, or returning
+			 * -ERESTARTSYS */
+			if (written)
+				break;
+			if (file->f_flags & O_NONBLOCK) {
+				ret = -EWOULDBLOCK;
+				break;
+			}
+			if (signal_pending(current)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+
+			mutex_unlock(&ir->irctl_lock);
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (mutex_lock_interruptible(&ir->irctl_lock)) {
+				ret = -ERESTARTSYS;
+				break;
+			}
+
+			if (!ir->attached) {
+				ret = -ENODEV;
+				break;
+			}
+		} else {
+			lirc_buffer_read(ir->buf, buf);
+			ret = copy_to_user((void *)buffer+written, buf,
+					   ir->buf->chunk_size);
+			written += ir->buf->chunk_size;
+		}
+	}
+
+	remove_wait_queue(&ir->buf->wait_poll, &wait);
+	set_current_state(TASK_RUNNING);
+	mutex_unlock(&ir->irctl_lock);
+
+	dev_dbg(ir->d.dev, LOGHEAD "read result = %s (%d)\n",
+		ir->d.name, ir->d.minor, ret ? "-EFAULT" : "OK", ret);
+
+	return ret ? ret : written;
+}
+EXPORT_SYMBOL(lirc_dev_fop_read);
+
+void *lirc_get_pdata(struct file *file)
+{
+	void *data = NULL;
+
+	if (file && file->f_dentry && file->f_dentry->d_inode &&
+	    file->f_dentry->d_inode->i_rdev) {
+		struct irctl *ir;
+		ir = irctls[iminor(file->f_dentry->d_inode)];
+		data = ir->d.data;
+	}
+
+	return data;
+}
+EXPORT_SYMBOL(lirc_get_pdata);
+
+
+ssize_t lirc_dev_fop_write(struct file *file, const char *buffer,
+			   size_t length, loff_t *ppos)
+{
+	struct irctl *ir = irctls[iminor(file->f_dentry->d_inode)];
+
+	dev_dbg(ir->d.dev, LOGHEAD "write called\n", ir->d.name, ir->d.minor);
+
+	if (!ir->attached)
+		return -ENODEV;
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(lirc_dev_fop_write);
+
+
+static int __init lirc_dev_init(void)
+{
+	int retval;
+
+	lirc_class = class_create(THIS_MODULE, "lirc");
+	if (IS_ERR(lirc_class)) {
+		retval = PTR_ERR(lirc_class);
+		printk(KERN_ERR "lirc_dev: class_create failed\n");
+		goto error;
+	}
+
+	retval = alloc_chrdev_region(&lirc_base_dev, 0, MAX_IRCTL_DEVICES,
+				     IRCTL_DEV_NAME);
+	if (retval) {
+		class_destroy(lirc_class);
+		printk(KERN_ERR "lirc_dev: alloc_chrdev_region failed\n");
+		goto error;
+	}
+
+
+	printk(KERN_INFO "lirc_dev: IR Remote Control driver registered, "
+	       "major %d \n", MAJOR(lirc_base_dev));
+
+error:
+	return retval;
+}
+
+
+
+static void __exit lirc_dev_exit(void)
+{
+	class_destroy(lirc_class);
+	unregister_chrdev_region(lirc_base_dev, MAX_IRCTL_DEVICES);
+	printk(KERN_INFO "lirc_dev: module unloaded\n");
+}
+
+module_init(lirc_dev_init);
+module_exit(lirc_dev_exit);
+
+MODULE_DESCRIPTION("LIRC base driver module");
+MODULE_AUTHOR("Artur Lipowski");
+MODULE_LICENSE("GPL");
+
+module_param(debug, bool, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(debug, "Enable debugging messages");
diff --git a/drivers/media/IR/lirc_dev.h b/drivers/media/IR/lirc_dev.h
new file mode 100644
index 0000000..533356d
--- /dev/null
+++ b/drivers/media/IR/lirc_dev.h
@@ -0,0 +1,228 @@
+/*
+ * LIRC base driver
+ *
+ * by Artur Lipowski <alipowski@interia.pl>
+ *        This code is licensed under GNU GPL
+ *
+ */
+
+#ifndef _LINUX_LIRC_DEV_H
+#define _LINUX_LIRC_DEV_H
+
+#define MAX_IRCTL_DEVICES 4
+#define BUFLEN            16
+
+#define mod(n, div) ((n) % (div))
+
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/ioctl.h>
+#include <linux/poll.h>
+#include <linux/kfifo.h>
+#include <media/lirc.h>
+
+struct lirc_buffer {
+	wait_queue_head_t wait_poll;
+	spinlock_t fifo_lock;
+	unsigned int chunk_size;
+	unsigned int size; /* in chunks */
+	/* Using chunks instead of bytes pretends to simplify boundary checking
+	 * And should allow for some performance fine tunning later */
+	struct kfifo fifo;
+	u8 fifo_initialized;
+};
+
+static inline void lirc_buffer_clear(struct lirc_buffer *buf)
+{
+	unsigned long flags;
+
+	if (buf->fifo_initialized) {
+		spin_lock_irqsave(&buf->fifo_lock, flags);
+		kfifo_reset(&buf->fifo);
+		spin_unlock_irqrestore(&buf->fifo_lock, flags);
+	} else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_init(struct lirc_buffer *buf,
+				    unsigned int chunk_size,
+				    unsigned int size)
+{
+	int ret;
+
+	init_waitqueue_head(&buf->wait_poll);
+	spin_lock_init(&buf->fifo_lock);
+	buf->chunk_size = chunk_size;
+	buf->size = size;
+	ret = kfifo_alloc(&buf->fifo, size * chunk_size, GFP_KERNEL);
+	if (ret == 0)
+		buf->fifo_initialized = 1;
+
+	return ret;
+}
+
+static inline void lirc_buffer_free(struct lirc_buffer *buf)
+{
+	if (buf->fifo_initialized) {
+		kfifo_free(&buf->fifo);
+		buf->fifo_initialized = 0;
+	} else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_len(struct lirc_buffer *buf)
+{
+	int len;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->fifo_lock, flags);
+	len = kfifo_len(&buf->fifo);
+	spin_unlock_irqrestore(&buf->fifo_lock, flags);
+
+	return len;
+}
+
+static inline int lirc_buffer_full(struct lirc_buffer *buf)
+{
+	return lirc_buffer_len(buf) == buf->size * buf->chunk_size;
+}
+
+static inline int lirc_buffer_empty(struct lirc_buffer *buf)
+{
+	return !lirc_buffer_len(buf);
+}
+
+static inline int lirc_buffer_available(struct lirc_buffer *buf)
+{
+	return buf->size - (lirc_buffer_len(buf) / buf->chunk_size);
+}
+
+static inline unsigned int lirc_buffer_read(struct lirc_buffer *buf,
+					    unsigned char *dest)
+{
+	unsigned int ret = 0;
+
+	if (lirc_buffer_len(buf) >= buf->chunk_size)
+		ret = kfifo_out_locked(&buf->fifo, dest, buf->chunk_size,
+				       &buf->fifo_lock);
+	return ret;
+
+}
+
+static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
+					     unsigned char *orig)
+{
+	unsigned int ret;
+
+	ret = kfifo_in_locked(&buf->fifo, orig, buf->chunk_size,
+			      &buf->fifo_lock);
+
+	return ret;
+}
+
+struct lirc_driver {
+	char name[40];
+	int minor;
+	unsigned long code_length;
+	unsigned int buffer_size; /* in chunks holding one code each */
+	int sample_rate;
+	unsigned long features;
+
+	unsigned int chunk_size;
+
+	void *data;
+	int min_timeout;
+	int max_timeout;
+	int (*add_to_buf) (void *data, struct lirc_buffer *buf);
+	struct lirc_buffer *rbuf;
+	int (*set_use_inc) (void *data);
+	void (*set_use_dec) (void *data);
+	struct file_operations *fops;
+	struct device *dev;
+	struct module *owner;
+};
+
+/* name:
+ * this string will be used for logs
+ *
+ * minor:
+ * indicates minor device (/dev/lirc) number for registered driver
+ * if caller fills it with negative value, then the first free minor
+ * number will be used (if available)
+ *
+ * code_length:
+ * length of the remote control key code expressed in bits
+ *
+ * sample_rate:
+ *
+ * data:
+ * it may point to any driver data and this pointer will be passed to
+ * all callback functions
+ *
+ * add_to_buf:
+ * add_to_buf will be called after specified period of the time or
+ * triggered by the external event, this behavior depends on value of
+ * the sample_rate this function will be called in user context. This
+ * routine should return 0 if data was added to the buffer and
+ * -ENODATA if none was available. This should add some number of bits
+ * evenly divisible by code_length to the buffer
+ *
+ * rbuf:
+ * if not NULL, it will be used as a read buffer, you will have to
+ * write to the buffer by other means, like irq's (see also
+ * lirc_serial.c).
+ *
+ * set_use_inc:
+ * set_use_inc will be called after device is opened
+ *
+ * set_use_dec:
+ * set_use_dec will be called after device is closed
+ *
+ * fops:
+ * file_operations for drivers which don't fit the current driver model.
+ *
+ * Some ioctl's can be directly handled by lirc_dev if the driver's
+ * ioctl function is NULL or if it returns -ENOIOCTLCMD (see also
+ * lirc_serial.c).
+ *
+ * owner:
+ * the module owning this struct
+ *
+ */
+
+
+/* following functions can be called ONLY from user context
+ *
+ * returns negative value on error or minor number
+ * of the registered device if success
+ * contents of the structure pointed by p is copied
+ */
+extern int lirc_register_driver(struct lirc_driver *d);
+
+/* returns negative value on error or 0 if success
+*/
+extern int lirc_unregister_driver(int minor);
+
+/* Returns the private data stored in the lirc_driver
+ * associated with the given device file pointer.
+ */
+void *lirc_get_pdata(struct file *file);
+
+/* default file operations
+ * used by drivers if they override only some operations
+ */
+int lirc_dev_fop_open(struct inode *inode, struct file *file);
+int lirc_dev_fop_close(struct inode *inode, struct file *file);
+unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait);
+int lirc_dev_fop_ioctl(struct inode *inode, struct file *file,
+		       unsigned int cmd, unsigned long arg);
+ssize_t lirc_dev_fop_read(struct file *file, char *buffer, size_t length,
+			  loff_t *ppos);
+ssize_t lirc_dev_fop_write(struct file *file, const char *buffer, size_t length,
+			   loff_t *ppos);
+long lirc_dev_fop_compat_ioctl(struct file *file, unsigned int cmd32,
+			       unsigned long arg);
+
+#endif
diff --git a/include/media/lirc.h b/include/media/lirc.h
new file mode 100644
index 0000000..9ca6876
--- /dev/null
+++ b/include/media/lirc.h
@@ -0,0 +1,159 @@
+/*
+ * lirc.h - linux infrared remote control header file
+ * last modified 2007/09/27
+ */
+
+#ifndef _LINUX_LIRC_H
+#define _LINUX_LIRC_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* <obsolete> */
+#define PULSE_BIT       0x01000000
+#define PULSE_MASK      0x00FFFFFF
+/* </obsolete> */
+
+#define LIRC_MODE2_SPACE     0x00000000
+#define LIRC_MODE2_PULSE     0x01000000
+#define LIRC_MODE2_FREQUENCY 0x02000000
+#define LIRC_MODE2_TIMEOUT   0x03000000
+
+#define LIRC_VALUE_MASK      0x00FFFFFF
+#define LIRC_MODE2_MASK      0xFF000000
+
+#define LIRC_SPACE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_SPACE)
+#define LIRC_PULSE(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_PULSE)
+#define LIRC_FREQUENCY(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_FREQUENCY)
+#define LIRC_TIMEOUT(val) (((val)&LIRC_VALUE_MASK) | LIRC_MODE2_TIMEOUT)
+
+#define LIRC_VALUE(val) ((val)&LIRC_VALUE_MASK)
+#define LIRC_MODE2(val) ((val)&LIRC_MODE2_MASK)
+
+#define LIRC_IS_SPACE(val) (LIRC_MODE2(val) == LIRC_MODE2_SPACE)
+#define LIRC_IS_PULSE(val) (LIRC_MODE2(val) == LIRC_MODE2_PULSE)
+#define LIRC_IS_FREQUENCY(val) (LIRC_MODE2(val) == LIRC_MODE2_FREQUENCY)
+#define LIRC_IS_TIMEOUT(val) (LIRC_MODE2(val) == LIRC_MODE2_TIMEOUT)
+
+/*** lirc compatible hardware features ***/
+
+#define LIRC_MODE2SEND(x) (x)
+#define LIRC_SEND2MODE(x) (x)
+#define LIRC_MODE2REC(x) ((x) << 16)
+#define LIRC_REC2MODE(x) ((x) >> 16)
+
+#define LIRC_MODE_RAW                  0x00000001
+#define LIRC_MODE_PULSE                0x00000002
+#define LIRC_MODE_MODE2                0x00000004
+#define LIRC_MODE_LIRCCODE             0x00000010
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_SEND_MASK             0x0000003f
+
+#define LIRC_CAN_SET_SEND_CARRIER      0x00000100
+#define LIRC_CAN_SET_SEND_DUTY_CYCLE   0x00000200
+#define LIRC_CAN_SET_TRANSMITTER_MASK  0x00000400
+
+#define LIRC_CAN_REC_RAW               LIRC_MODE2REC(LIRC_MODE_RAW)
+#define LIRC_CAN_REC_PULSE             LIRC_MODE2REC(LIRC_MODE_PULSE)
+#define LIRC_CAN_REC_MODE2             LIRC_MODE2REC(LIRC_MODE_MODE2)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
+#define LIRC_CAN_SET_REC_TIMEOUT          0x10000000
+#define LIRC_CAN_SET_REC_FILTER           0x08000000
+
+#define LIRC_CAN_MEASURE_CARRIER          0x02000000
+
+#define LIRC_CAN_SEND(x) ((x)&LIRC_CAN_SEND_MASK)
+#define LIRC_CAN_REC(x) ((x)&LIRC_CAN_REC_MASK)
+
+#define LIRC_CAN_NOTIFY_DECODE            0x01000000
+
+/*** IOCTL commands for lirc driver ***/
+
+#define LIRC_GET_FEATURES              _IOR('i', 0x00000000, unsigned long)
+
+#define LIRC_GET_SEND_MODE             _IOR('i', 0x00000001, unsigned long)
+#define LIRC_GET_REC_MODE              _IOR('i', 0x00000002, unsigned long)
+#define LIRC_GET_SEND_CARRIER          _IOR('i', 0x00000003, unsigned int)
+#define LIRC_GET_REC_CARRIER           _IOR('i', 0x00000004, unsigned int)
+#define LIRC_GET_SEND_DUTY_CYCLE       _IOR('i', 0x00000005, unsigned int)
+#define LIRC_GET_REC_DUTY_CYCLE        _IOR('i', 0x00000006, unsigned int)
+#define LIRC_GET_REC_RESOLUTION        _IOR('i', 0x00000007, unsigned int)
+
+#define LIRC_GET_MIN_TIMEOUT           _IOR('i', 0x00000008, uint32_t)
+#define LIRC_GET_MAX_TIMEOUT           _IOR('i', 0x00000009, uint32_t)
+
+#define LIRC_GET_MIN_FILTER_PULSE      _IOR('i', 0x0000000a, uint32_t)
+#define LIRC_GET_MAX_FILTER_PULSE      _IOR('i', 0x0000000b, uint32_t)
+#define LIRC_GET_MIN_FILTER_SPACE      _IOR('i', 0x0000000c, uint32_t)
+#define LIRC_GET_MAX_FILTER_SPACE      _IOR('i', 0x0000000d, uint32_t)
+
+/* code length in bits, currently only for LIRC_MODE_LIRCCODE */
+#define LIRC_GET_LENGTH                _IOR('i', 0x0000000f, unsigned long)
+
+#define LIRC_SET_SEND_MODE             _IOW('i', 0x00000011, unsigned long)
+#define LIRC_SET_REC_MODE              _IOW('i', 0x00000012, unsigned long)
+/* Note: these can reset the according pulse_width */
+#define LIRC_SET_SEND_CARRIER          _IOW('i', 0x00000013, unsigned int)
+#define LIRC_SET_REC_CARRIER           _IOW('i', 0x00000014, unsigned int)
+#define LIRC_SET_SEND_DUTY_CYCLE       _IOW('i', 0x00000015, unsigned int)
+#define LIRC_SET_REC_DUTY_CYCLE        _IOW('i', 0x00000016, unsigned int)
+#define LIRC_SET_TRANSMITTER_MASK      _IOW('i', 0x00000017, unsigned int)
+
+/*
+ * when a timeout != 0 is set the driver will send a
+ * LIRC_MODE2_TIMEOUT data packet, otherwise LIRC_MODE2_TIMEOUT is
+ * never sent, timeout is disabled by default
+ */
+#define LIRC_SET_REC_TIMEOUT           _IOW('i', 0x00000018, uint32_t)
+
+/*
+ * pulses shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_PULSE      _IOW('i', 0x00000019, uint32_t)
+/*
+ * spaces shorter than this are filtered out by hardware (software
+ * emulation in lirc_dev?)
+ */
+#define LIRC_SET_REC_FILTER_SPACE      _IOW('i', 0x0000001a, uint32_t)
+/*
+ * if filter cannot be set independantly for pulse/space, this should
+ * be used
+ */
+#define LIRC_SET_REC_FILTER            _IOW('i', 0x0000001b, uint32_t)
+
+/*
+ * to set a range use
+ * LIRC_SET_REC_DUTY_CYCLE_RANGE/LIRC_SET_REC_CARRIER_RANGE with the
+ * lower bound first and later
+ * LIRC_SET_REC_DUTY_CYCLE/LIRC_SET_REC_CARRIER with the upper bound
+ */
+
+#define LIRC_SET_REC_DUTY_CYCLE_RANGE  _IOW('i', 0x0000001e, unsigned int)
+#define LIRC_SET_REC_CARRIER_RANGE     _IOW('i', 0x0000001f, unsigned int)
+
+#define LIRC_NOTIFY_DECODE             _IO('i', 0x00000020)
+
+/*
+ * from the next key press on the driver will send
+ * LIRC_MODE2_FREQUENCY packets
+ */
+#define LIRC_MEASURE_CARRIER_ENABLE    _IO('i', 0x00000021)
+#define LIRC_MEASURE_CARRIER_DISABLE   _IO('i', 0x00000022)
+
+#endif
-- 
1.6.5.2


-- 
Jarod Wilson
jarod@redhat.com

