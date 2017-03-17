Return-path: <linux-media-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:56551 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751651AbdCQSvD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 14:51:03 -0400
From: Logan Gunthorpe <logang@deltatee.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-mtd@lists.infradead.org,
        linux-media@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>
Date: Fri, 17 Mar 2017 12:48:08 -0600
Message-Id: <1489776503-3151-2-git-send-email-logang@deltatee.com>
In-Reply-To: <1489776503-3151-1-git-send-email-logang@deltatee.com>
References: <1489776503-3151-1-git-send-email-logang@deltatee.com>
Subject: [PATCH v5 01/16] chardev: add helper function to register char devs with a struct device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Credit for this patch goes is shared with Dan Williams [1]. I've
taken things one step further to make the helper function more
useful and clean up calling code.

There's a common pattern in the kernel whereby a struct cdev is placed
in a structure along side a struct device which manages the life-cycle
of both. In the naive approach, the reference counting is broken and
the struct device can free everything before the chardev code
is entirely released.

Many developers have solved this problem by linking the internal kobjs
in this fashion:

cdev.kobj.parent = &parent_dev.kobj;

The cdev code explicitly gets and puts a reference to it's kobj parent.
So this seems like it was intended to be used this way. Dmitrty Torokhov
first put this in place in 2012 with this commit:

2f0157f char_dev: pin parent kobject

and the first instance of the fix was then done in the input subsystem
in the following commit:

4a215aa Input: fix use-after-free introduced with dynamic minor changes

Subsequently over the years, however, this issue seems to have tripped
up multiple developers independently. For example, see these commits:

0d5b7da iio: Prevent race between IIO chardev opening and IIO device
(by Lars-Peter Clausen in 2013)

ba0ef85 tpm: Fix initialization of the cdev
(by Jason Gunthorpe in 2015)

5b28dde [media] media: fix use-after-free in cdev_put() when app exits
after driver unbind
(by Shauh Khan in 2016)

This technique is similarly done in at least 15 places within the kernel
and probably should have been done so in another, at least, 5 places.
The kobj line also looks very suspect in that one would not expect
drivers to have to mess with kobject internals in this way.
Even highly experienced kernel developers can be surprised by this
code, as seen in [2].

To help alleviate this situation, and hopefully prevent future
wasted effort on this problem, this patch introduces a helper function
to register a char device along with its parent struct device.
This creates a more regular API for tying a char device to its parent
without the developer having to set members in the underlying kobject.

This patch introduce cdev_device_add and cdev_device_del which
replaces a common pattern including setting the kobj parent, calling
cdev_add and then calling device_add. It also introduces cdev_set_parent
for the few cases that set the kobject parent without using device_add.

[1] https://lkml.org/lkml/2017/2/13/700
[2] https://lkml.org/lkml/2017/2/10/370

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 fs/char_dev.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cdev.h |  5 +++
 2 files changed, 91 insertions(+)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 44a240c..fb8507f 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -471,6 +471,85 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 	return 0;
 }
 
+/**
+ * cdev_set_parent() - set the parent kobject for a char device
+ * @p: the cdev structure
+ * @kobj: the kobject to take a reference to
+ *
+ * cdev_set_parent() sets a parent kobject which will be referenced
+ * appropriately so the parent is not freed before the cdev. This
+ * should be called before cdev_add.
+ */
+void cdev_set_parent(struct cdev *p, struct kobject *kobj)
+{
+	WARN_ON(!kobj->state_initialized);
+	p->kobj.parent = kobj;
+}
+
+/**
+ * cdev_device_add() - add a char device and it's corresponding
+ *	struct device, linkink
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_add() adds the char device represented by @cdev to the system,
+ * just as cdev_add does. It then adds @dev to the system using device_add
+ * The dev_t for the char device will be taken from the struct device which
+ * needs to be initialized first. This helper function correctly takes a
+ * reference to the parent device so the parent will not get released until
+ * all references to the cdev are released.
+ *
+ * This helper uses dev->devt for the device number. If it is not set
+ * it will not add the cdev and it will be equivalent to device_add.
+ *
+ * This function should be used whenever the struct cdev and the
+ * struct device are members of the same structure whose lifetime is
+ * managed by the struct device.
+ *
+ * NOTE: Callers must assume that userspace was able to open the cdev and
+ * can call cdev fops callbacks at any time, even if this function fails.
+ */
+int cdev_device_add(struct cdev *cdev, struct device *dev)
+{
+	int rc = 0;
+
+	if (dev->devt) {
+		cdev_set_parent(cdev, &dev->kobj);
+
+		rc = cdev_add(cdev, dev->devt, 1);
+		if (rc)
+			return rc;
+	}
+
+	rc = device_add(dev);
+	if (rc)
+		cdev_del(cdev);
+
+	return rc;
+}
+
+/**
+ * cdev_device_del() - inverse of cdev_device_add
+ * @dev: the device structure
+ * @cdev: the cdev structure
+ *
+ * cdev_device_del() is a helper function to call cdev_del and device_del.
+ * It should be used whenever cdev_device_add is used.
+ *
+ * If dev->devt is not set it will not remove the cdev and will be equivalent
+ * to device_del.
+ *
+ * NOTE: This guarantees that associated sysfs callbacks are not running
+ * or runnable, however any cdevs already open will remain and their fops
+ * will still be callable even after this function returns.
+ */
+void cdev_device_del(struct cdev *cdev, struct device *dev)
+{
+	device_del(dev);
+	if (dev->devt)
+		cdev_del(cdev);
+}
+
 static void cdev_unmap(dev_t dev, unsigned count)
 {
 	kobj_unmap(cdev_map, dev, count);
@@ -482,6 +561,10 @@ static void cdev_unmap(dev_t dev, unsigned count)
  *
  * cdev_del() removes @p from the system, possibly freeing the structure
  * itself.
+ *
+ * NOTE: This guarantees that cdev device will no longer be able to be
+ * opened, however any cdevs already open will remain and their fops will
+ * still be callable even after cdev_del returns.
  */
 void cdev_del(struct cdev *p)
 {
@@ -570,5 +653,8 @@ EXPORT_SYMBOL(cdev_init);
 EXPORT_SYMBOL(cdev_alloc);
 EXPORT_SYMBOL(cdev_del);
 EXPORT_SYMBOL(cdev_add);
+EXPORT_SYMBOL(cdev_set_parent);
+EXPORT_SYMBOL(cdev_device_add);
+EXPORT_SYMBOL(cdev_device_del);
 EXPORT_SYMBOL(__register_chrdev);
 EXPORT_SYMBOL(__unregister_chrdev);
diff --git a/include/linux/cdev.h b/include/linux/cdev.h
index f876361..408bc09 100644
--- a/include/linux/cdev.h
+++ b/include/linux/cdev.h
@@ -4,6 +4,7 @@
 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
 #include <linux/list.h>
+#include <linux/device.h>
 
 struct file_operations;
 struct inode;
@@ -26,6 +27,10 @@ void cdev_put(struct cdev *p);
 
 int cdev_add(struct cdev *, dev_t, unsigned);
 
+void cdev_set_parent(struct cdev *p, struct kobject *kobj);
+int cdev_device_add(struct cdev *cdev, struct device *dev);
+void cdev_device_del(struct cdev *cdev, struct device *dev);
+
 void cdev_del(struct cdev *);
 
 void cd_forget(struct inode *);
-- 
2.1.4
