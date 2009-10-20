Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbZJTOBY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 10:01:24 -0400
From: Jarod Wilson <jarod@redhat.com>
To: linux-kernel@vger.kernel.org,
	Mario Limonciello <superm1@ubuntu.com>
Subject: [PATCH 1/3 v2] lirc core device driver infrastructure
Date: Tue, 20 Oct 2009 09:58:50 -0400
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Christoph Bartelmus <lirc@bartelmus.de>
References: <200910200956.33391.jarod@redhat.com>
In-Reply-To: <200910200956.33391.jarod@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910200958.50574.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Core Linux Infrared Remote Control driver and infrastructure

-Add Kconfig and Makefile bits
-Add device driver interface and headers

The initial Kconfig and Makefile bits were done by Mario Limonciello for
the Ubuntu kernel, but have been tweaked a bit since then. Any errors are
probably my doing.

Changes from prior submission:
- Now uses dev_dbg instead of its own dprintk
- Dynamic device numbers used
- sleep_on() ripped out in favor of wake bits
- Kconfig text improved and simplified
- All inline keywords removed where possible
- Obfuscating #defines and wrapper functions removed
- We call 'em lirc drivers now instead of lirc plugins


Signed-off-by: Jarod Wilson <jarod@redhat.com>
Signed-off-by: Janne Grunau <j@jannau.net>
CC: Christoph Bartelmus <lirc@bartelmus.de>
CC: Mario Limonciello <superm1@ubuntu.com>

---
 MAINTAINERS                   |    9 
 drivers/input/Kconfig         |    2 
 drivers/input/Makefile        |    1 
 drivers/input/lirc/Kconfig    |   16 
 drivers/input/lirc/Makefile   |    6 
 drivers/input/lirc/lirc.h     |  100 +++++
 drivers/input/lirc/lirc_dev.c |  837 ++++++++++++++++++++++++++++++++++++++++++
 drivers/input/lirc/lirc_dev.h |  194 +++++++++
 8 files changed, 1165 insertions(+)

Index: b/MAINTAINERS
===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3219,6 +3219,15 @@ W:	http://www.pasemi.com/
 L:	linuxppc-dev@ozlabs.org
 S:	Supported
 
+LINUX INFRARED REMOTE CONTROL DRIVERS (LIRC)
+P:	Jarod Wilson
+M:	jarod@redhat.com
+P:	Christoph Bartelmus
+M:	lirc@bartelmus.de
+W:	http://www.lirc.org/
+L:	lirc-list@lists.sourceforge.net
+S:	Maintained
+
 LINUX SECURITY MODULE (LSM) FRAMEWORK
 M:	Chris Wright <chrisw@sous-sol.org>
 L:	linux-security-module@vger.kernel.org
Index: b/drivers/input/Kconfig
===================================================================
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -170,6 +170,8 @@ source "drivers/input/tablet/Kconfig"
 
 source "drivers/input/touchscreen/Kconfig"
 
+source "drivers/input/lirc/Kconfig"
+
 source "drivers/input/misc/Kconfig"
 
 endif
Index: b/drivers/input/Makefile
===================================================================
--- a/drivers/input/Makefile
+++ b/drivers/input/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_INPUT_MOUSE)	+= mouse/
 obj-$(CONFIG_INPUT_JOYSTICK)	+= joystick/
 obj-$(CONFIG_INPUT_TABLET)	+= tablet/
 obj-$(CONFIG_INPUT_TOUCHSCREEN)	+= touchscreen/
+obj-$(CONFIG_INPUT_LIRC)	+= lirc/
 obj-$(CONFIG_INPUT_MISC)	+= misc/
 
 obj-$(CONFIG_INPUT_APMPOWER)	+= apm-power.o
Index: b/drivers/input/lirc/Kconfig
===================================================================
--- /dev/null
+++ b/drivers/input/lirc/Kconfig
@@ -0,0 +1,16 @@
+#
+# LIRC driver(s) configuration
+#
+menuconfig INPUT_LIRC
+	bool "Linux Infrared Remote Control IR receiver/transmitter drivers"
+	help
+	  Say Y here, and all supported Linux Infrared Remote Control IR and
+	  RF receiver and transmitter drivers will be displayed. When paired
+	  with a remote control and the lirc daemon, the receiver drivers
+	  allow control of your Linux system via remote control.
+
+if INPUT_LIRC
+
+# Device-specific drivers go here
+
+endif
Index: b/drivers/input/lirc/Makefile
===================================================================
--- /dev/null
+++ b/drivers/input/lirc/Makefile
@@ -0,0 +1,6 @@
+# Makefile for the lirc drivers.
+#
+
+# Each configuration option enables a list of files.
+
+obj-$(CONFIG_INPUT_LIRC)	+= lirc_dev.o
Index: b/drivers/input/lirc/lirc.h
===================================================================
--- /dev/null
+++ b/drivers/input/lirc/lirc.h
@@ -0,0 +1,100 @@
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
+#define PULSE_BIT  0x01000000
+#define PULSE_MASK 0x00FFFFFF
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
+#define LIRC_MODE_CODE                 0x00000008
+#define LIRC_MODE_LIRCCODE             0x00000010
+#define LIRC_MODE_STRING               0x00000020
+
+
+#define LIRC_CAN_SEND_RAW              LIRC_MODE2SEND(LIRC_MODE_RAW)
+#define LIRC_CAN_SEND_PULSE            LIRC_MODE2SEND(LIRC_MODE_PULSE)
+#define LIRC_CAN_SEND_MODE2            LIRC_MODE2SEND(LIRC_MODE_MODE2)
+#define LIRC_CAN_SEND_CODE             LIRC_MODE2SEND(LIRC_MODE_CODE)
+#define LIRC_CAN_SEND_LIRCCODE         LIRC_MODE2SEND(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_SEND_STRING           LIRC_MODE2SEND(LIRC_MODE_STRING)
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
+#define LIRC_CAN_REC_CODE              LIRC_MODE2REC(LIRC_MODE_CODE)
+#define LIRC_CAN_REC_LIRCCODE          LIRC_MODE2REC(LIRC_MODE_LIRCCODE)
+#define LIRC_CAN_REC_STRING            LIRC_MODE2REC(LIRC_MODE_STRING)
+
+#define LIRC_CAN_REC_MASK              LIRC_MODE2REC(LIRC_CAN_SEND_MASK)
+
+#define LIRC_CAN_SET_REC_CARRIER       (LIRC_CAN_SET_SEND_CARRIER << 16)
+#define LIRC_CAN_SET_REC_DUTY_CYCLE    (LIRC_CAN_SET_SEND_DUTY_CYCLE << 16)
+
+#define LIRC_CAN_SET_REC_DUTY_CYCLE_RANGE 0x40000000
+#define LIRC_CAN_SET_REC_CARRIER_RANGE    0x80000000
+#define LIRC_CAN_GET_REC_RESOLUTION       0x20000000
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
+#endif
Index: b/drivers/input/lirc/lirc_dev.c
===================================================================
--- /dev/null
+++ b/drivers/input/lirc/lirc_dev.c
@@ -0,0 +1,837 @@
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
+#include "lirc.h"
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
+	struct mutex buffer_lock;
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
+	mutex_init(&ir->buffer_lock);
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
+		d->features = (d->code_length > 8) ?
+			LIRC_CAN_REC_LIRCCODE : LIRC_CAN_REC_CODE;
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
+		mutex_lock(&ir->buffer_lock);
+		ir->d.set_use_dec(ir->d.data);
+		module_put(ir->d.owner);
+		mutex_unlock(&ir->buffer_lock);
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
+		mutex_unlock(&ir->buffer_lock);
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
+	if (mutex_lock_interruptible(&ir->buffer_lock))
+		return -ERESTARTSYS;
+	if (!ir->attached) {
+		mutex_unlock(&ir->buffer_lock);
+		return -ENODEV;
+	}
+
+	if (length % ir->chunk_size) {
+		dev_dbg(ir->d.dev, LOGHEAD "read result = -EINVAL\n",
+			ir->d.name, ir->d.minor);
+		mutex_unlock(&ir->buffer_lock);
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
+			mutex_unlock(&ir->buffer_lock);
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+
+			if (mutex_lock_interruptible(&ir->buffer_lock)) {
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
+	mutex_unlock(&ir->buffer_lock);
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
Index: b/drivers/input/lirc/lirc_dev.h
===================================================================
--- /dev/null
+++ b/drivers/input/lirc/lirc_dev.h
@@ -0,0 +1,194 @@
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
+
+struct lirc_buffer {
+	wait_queue_head_t wait_poll;
+	spinlock_t lock;
+	unsigned int chunk_size;
+	unsigned int size; /* in chunks */
+	/* Using chunks instead of bytes pretends to simplify boundary checking
+	 * And should allow for some performance fine tunning later */
+	struct kfifo *fifo;
+};
+
+static inline void lirc_buffer_clear(struct lirc_buffer *buf)
+{
+	if (buf->fifo)
+		kfifo_reset(buf->fifo);
+	else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_init(struct lirc_buffer *buf,
+				    unsigned int chunk_size,
+				    unsigned int size)
+{
+	init_waitqueue_head(&buf->wait_poll);
+	spin_lock_init(&buf->lock);
+	buf->chunk_size = chunk_size;
+	buf->size = size;
+	buf->fifo = kfifo_alloc(size*chunk_size, GFP_KERNEL, &buf->lock);
+	if (!buf->fifo)
+		return -ENOMEM;
+	return 0;
+}
+
+static inline void lirc_buffer_free(struct lirc_buffer *buf)
+{
+	if (buf->fifo)
+		kfifo_free(buf->fifo);
+	else
+		WARN(1, "calling %s on an uninitialized lirc_buffer\n",
+		     __func__);
+}
+
+static inline int lirc_buffer_full(struct lirc_buffer *buf)
+{
+	return kfifo_len(buf->fifo) == buf->size * buf->chunk_size;
+}
+
+static inline int lirc_buffer_empty(struct lirc_buffer *buf)
+{
+	return !kfifo_len(buf->fifo);
+}
+
+static inline int lirc_buffer_available(struct lirc_buffer *buf)
+{
+	return buf->size - (kfifo_len(buf->fifo) / buf->chunk_size);
+}
+
+static inline void lirc_buffer_read(struct lirc_buffer *buf,
+			       unsigned char *dest)
+{
+	if (kfifo_len(buf->fifo) >= buf->chunk_size)
+		kfifo_get(buf->fifo, dest, buf->chunk_size);
+}
+
+static inline void lirc_buffer_write(struct lirc_buffer *buf,
+				unsigned char *orig)
+{
+	kfifo_put(buf->fifo, orig, buf->chunk_size);
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
