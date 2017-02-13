Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33577 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752296AbdBMOpV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 09:45:21 -0500
Received: by mail-wm0-f45.google.com with SMTP id t18so6989141wmt.0
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 06:45:21 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linaro-kernel@lists.linaro.org, arnd@arndb.de, labbott@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        akpm@linux-foundation.org, hverkuil@xs4all.nl
Cc: broonie@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [RFC simple allocator v2 1/2] Create Simple Allocator module
Date: Mon, 13 Feb 2017 15:45:05 +0100
Message-Id: <1486997106-23277-2-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the core of simple allocator module.
It aim to offert one common ioctl to allocate specific memory.

version 2:
- rebased on 4.10-rc7

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 Documentation/simple-allocator.txt              |  81 +++++++++++
 drivers/Kconfig                                 |   2 +
 drivers/Makefile                                |   1 +
 drivers/simpleallocator/Kconfig                 |  10 ++
 drivers/simpleallocator/Makefile                |   1 +
 drivers/simpleallocator/simple-allocator-priv.h |  33 +++++
 drivers/simpleallocator/simple-allocator.c      | 180 ++++++++++++++++++++++++
 include/uapi/linux/simple-allocator.h           |  35 +++++
 8 files changed, 343 insertions(+)
 create mode 100644 Documentation/simple-allocator.txt
 create mode 100644 drivers/simpleallocator/Kconfig
 create mode 100644 drivers/simpleallocator/Makefile
 create mode 100644 drivers/simpleallocator/simple-allocator-priv.h
 create mode 100644 drivers/simpleallocator/simple-allocator.c
 create mode 100644 include/uapi/linux/simple-allocator.h

diff --git a/Documentation/simple-allocator.txt b/Documentation/simple-allocator.txt
new file mode 100644
index 0000000..89ba883
--- /dev/null
+++ b/Documentation/simple-allocator.txt
@@ -0,0 +1,81 @@
+Simple Allocator Framework
+
+Simple Allocator offer a single ioctl SA_IOC_ALLOC to allocate buffers
+on dedicated memory regions and export them as a dmabuf file descriptor.
+Using dmabuf file descriptor allow to share this memory between processes
+and/or import it into other frameworks like v4l2 or drm/kms (prime).
+When userland wants to free the memory only a call to close() in needed
+so it could done even without knowing that buffer has been allocated by
+simple allocator ioctl.
+
+Each memory regions will be seen as a filein /dev/.
+For example CMA regions will exposed has /dev/cmaX.
+
+Implementing a simple allocator
+-------------------------------
+
+Simple Allocator provide helpers functions to register/unregister an
+allocator:
+- simple_allocator_register(struct sa_device *sadev)
+  Register simple_allocator_device using sa_device structure where name,
+  owner and allocate fields must be set.
+
+- simple_allocator_unregister(struct sa_device *sadev)
+  Unregister a simple allocator device.
+
+Using Simple Allocator /dev interface example
+---------------------------------------------
+
+This example of code allocate a buffer on the first CMA region (/dev/cma0)
+before mmap and close it.
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include "simple-allocator.h"
+
+#define LENGTH 1024*16
+
+void main (void)
+{
+	struct simple_allocate_data data;
+	int fd = open("/dev/cma0", O_RDWR, 0);
+	int ret;
+	void *mem;
+
+	if (fd < 0) {
+		printf("Can't open /dev/cma0\n");
+		return;
+	}
+
+	memset(&data, 0, sizeof(data));
+
+	data.length = LENGTH;
+	data.flags = O_RDWR | O_CLOEXEC;
+
+	ret = ioctl(fd, SA_IOC_ALLOC, &data);
+	if (ret) {
+		printf("Buffer allocation failed\n");
+		goto end;
+	}
+
+	mem = mmap(0, LENGTH, PROT_READ | PROT_WRITE, MAP_SHARED, data.fd, 0);
+	if (mem == MAP_FAILED) {
+		printf("mmap failed\n");
+	}
+
+	memset(mem, 0xFF, LENGTH);
+	munmap(mem, LENGTH);
+
+	printf("test simple allocator CMA OK\n");
+end:
+	close(fd);
+}
diff --git a/drivers/Kconfig b/drivers/Kconfig
index e1e2066..a6d8828 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -202,4 +202,6 @@ source "drivers/hwtracing/intel_th/Kconfig"
 
 source "drivers/fpga/Kconfig"
 
+source "drivers/simpleallocator/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 060026a..5081eb8 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -173,3 +173,4 @@ obj-$(CONFIG_STM)		+= hwtracing/stm/
 obj-$(CONFIG_ANDROID)		+= android/
 obj-$(CONFIG_NVMEM)		+= nvmem/
 obj-$(CONFIG_FPGA)		+= fpga/
+obj-$(CONFIG_SIMPLE_ALLOCATOR) 	+= simpleallocator/
diff --git a/drivers/simpleallocator/Kconfig b/drivers/simpleallocator/Kconfig
new file mode 100644
index 0000000..c6fc2e3
--- /dev/null
+++ b/drivers/simpleallocator/Kconfig
@@ -0,0 +1,10 @@
+menu "Simple Allocator"
+
+config SIMPLE_ALLOCATOR
+	tristate "Simple Alllocator Framework"
+	select DMA_SHARED_BUFFER
+	---help---
+	   The Simple Allocator Framework adds an API to allocate and share
+	   memory in userland.
+
+endmenu
diff --git a/drivers/simpleallocator/Makefile b/drivers/simpleallocator/Makefile
new file mode 100644
index 0000000..e27c6ad
--- /dev/null
+++ b/drivers/simpleallocator/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SIMPLE_ALLOCATOR) += simple-allocator.o
diff --git a/drivers/simpleallocator/simple-allocator-priv.h b/drivers/simpleallocator/simple-allocator-priv.h
new file mode 100644
index 0000000..33f5a33
--- /dev/null
+++ b/drivers/simpleallocator/simple-allocator-priv.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (C) Linaro 2016
+ *
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org>
+ *
+ * License terms:  GNU General Public License (GPL)
+ */
+
+#ifndef _SIMPLE_ALLOCATOR_PRIV_H_
+#define _SIMPLE_ALLOCATOR_PRIV_H_
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/dma-buf.h>
+
+/**
+ * struct sa_device - simple allocator device
+ * @owner: module owner, must be set to THIS_MODULE
+ * @name: name of the allocator
+ * @allocate: callabck for memory allocation
+ */
+struct sa_device {
+	struct device	dev;
+	struct cdev	chrdev;
+	struct module	*owner;
+	const char	*name;
+	struct dma_buf *(*allocate)(struct sa_device *, u64 length, u32 flags);
+};
+
+int simple_allocator_register(struct sa_device *sadev);
+void simple_allocator_unregister(struct sa_device *sadev);
+
+#endif
diff --git a/drivers/simpleallocator/simple-allocator.c b/drivers/simpleallocator/simple-allocator.c
new file mode 100644
index 0000000..d89ccbf
--- /dev/null
+++ b/drivers/simpleallocator/simple-allocator.c
@@ -0,0 +1,180 @@
+/*
+ * Copyright (C) Linaro 2016
+ *
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org>
+ *
+ * License terms:  GNU General Public License (GPL)
+ */
+
+#include <linux/module.h>
+#include <linux/simple-allocator.h>
+#include <linux/uaccess.h>
+
+#include "simple-allocator-priv.h"
+
+#define SA_MAJOR	222
+#define SA_NUM_DEVICES	256
+#define SA_NAME		"simple_allocator"
+
+static int sa_minor;
+
+static struct class sa_class = {
+	.name = SA_NAME,
+};
+
+static long sa_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct sa_device *sadev = filp->private_data;
+	int ret = -ENODEV;
+
+	switch (cmd) {
+	case SA_IOC_ALLOC:
+	{
+		struct simple_allocate_data data;
+		struct dma_buf *dmabuf;
+
+		if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
+			return -EFAULT;
+
+		if (data.version != 0)
+			return -EINVAL;
+
+		dmabuf = sadev->allocate(sadev, data.length, data.flags);
+		if (!dmabuf)
+			return -EINVAL;
+
+		data.fd = dma_buf_fd(dmabuf, data.flags);
+		if (data.fd < 0) {
+			dma_buf_put(dmabuf);
+			return -EINVAL;
+		}
+
+		data.length = dmabuf->size;
+
+		if (copy_to_user((void __user *)arg, &data, _IOC_SIZE(cmd))) {
+			dma_buf_put(dmabuf);
+			return -EFAULT;
+		}
+
+		return 0;
+	}
+	}
+	return ret;
+}
+
+static int sa_open(struct inode *inode, struct file *filp)
+{
+	struct sa_device *sadev = container_of(inode->i_cdev,
+					       struct sa_device, chrdev);
+
+	if (!sadev)
+		return -ENODEV;
+
+	get_device(&sadev->dev);
+	filp->private_data = sadev;
+	return 0;
+}
+
+static int sa_release(struct inode *inode, struct file *filp)
+{
+	struct sa_device *sadev = container_of(inode->i_cdev,
+					       struct sa_device, chrdev);
+
+	if (!sadev)
+		return -ENODEV;
+
+	put_device(&sadev->dev);
+	return 0;
+}
+
+static const struct file_operations sa_fops = {
+	.owner = THIS_MODULE,
+	.open = sa_open,
+	.release = sa_release,
+	.unlocked_ioctl = sa_ioctl,
+};
+
+/**
+ * simple_allocator_register - register a simple allocator
+ * @sadev: simple allocator structure to be registered
+ *
+ * Return 0 if allocator has been regsitered, either a negative value.
+ */
+int simple_allocator_register(struct sa_device *sadev)
+{
+	int ret;
+
+	if (!sadev->name || !sadev->allocate)
+		return -EINVAL;
+
+	cdev_init(&sadev->chrdev, &sa_fops);
+	sadev->chrdev.owner = sadev->owner;
+
+	ret = cdev_add(&sadev->chrdev, MKDEV(SA_MAJOR, sa_minor), 1);
+	if (ret < 0)
+		return ret;
+
+	sadev->dev.class = &sa_class;
+	sadev->dev.devt = MKDEV(SA_MAJOR, sa_minor);
+	dev_set_name(&sadev->dev, "%s%d", sadev->name, sa_minor);
+	ret = device_register(&sadev->dev);
+	if (ret < 0)
+		goto cleanup;
+
+	sa_minor++;
+	return 0;
+
+cleanup:
+	cdev_del(&sadev->chrdev);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(simple_allocator_register);
+
+/**
+ * simple_allocator_unregister - unregister a simple allocator
+ * @sadev: simple allocator device to be unregistered
+ */
+void simple_allocator_unregister(struct sa_device *sadev)
+{
+	if (!sadev)
+		return;
+
+	cdev_del(&sadev->chrdev);
+	device_del(&sadev->dev);
+	put_device(&sadev->dev);
+}
+EXPORT_SYMBOL_GPL(simple_allocator_unregister);
+
+static int __init sa_init(void)
+{
+	dev_t dev = MKDEV(SA_MAJOR, 0);
+	int ret;
+
+	ret = register_chrdev_region(dev, SA_NUM_DEVICES, SA_NAME);
+	if (ret < 0)
+		return ret;
+
+	ret = class_register(&sa_class);
+	if (ret < 0) {
+		unregister_chrdev_region(dev, SA_NUM_DEVICES);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void __exit sa_exit(void)
+{
+	dev_t dev = MKDEV(SA_MAJOR, 0);
+
+	class_unregister(&sa_class);
+	unregister_chrdev_region(dev, SA_NUM_DEVICES);
+}
+
+subsys_initcall(sa_init);
+module_exit(sa_exit);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
+MODULE_DESCRIPTION("Simple allocator");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SA_MAJOR);
diff --git a/include/uapi/linux/simple-allocator.h b/include/uapi/linux/simple-allocator.h
new file mode 100644
index 0000000..5520a85
--- /dev/null
+++ b/include/uapi/linux/simple-allocator.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) Linaro 2016
+ *
+ * Author: Benjamin Gaignard <benjamin.gaignard@linaro.org>
+ *
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef _SIMPLE_ALLOCATOR_H_
+#define _SIMPLE_ALLOCATOR_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/**
+ * struct simple_allocate_data - allocation parameters
+ * @version:	structure version (must be set to 0)
+ * @length:	size of the requested buffer
+ * @flags:	mode flags for the file like O_RDWR or O_CLOEXEC
+ * @fd:		returned file descriptor
+ */
+struct simple_allocate_data {
+	__u64 version;
+	__u64 length;
+	__u32 flags;
+	__u32 reserved1;
+	__s32 fd;
+	__u32 reserved2;
+};
+
+#define SA_IOC_MAGIC 'S'
+
+#define SA_IOC_ALLOC _IOWR(SA_IOC_MAGIC, 0, struct simple_allocate_data)
+
+#endif
-- 
1.9.1
