Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60417 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab1HBJty (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2011 05:49:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8; format=flowed
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPA003THON5TO30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:49:53 +0100 (BST)
Received: from [127.0.0.1] ([106.10.22.139])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPA00A68ON3BP@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Aug 2011 10:49:52 +0100 (BST)
Date: Tue, 02 Aug 2011 11:49:53 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 1/6] drivers: base: add shared buffer framework
In-reply-to: <4E37C7D7.40301@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4E37C841.7000709@samsung.com>
References: <4E37C7D7.40301@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch adds the framework for buffer sharing via a file descriptor. A
driver that use shared buffer (shrbuf) can export a memory description by
transforming it into a file descriptor. The reverse operation (import) 
is done
by obtaining a memory description from a file descriptor. The driver is
responsible to get and put callbacks to avoid resource leakage. Current
implementation is dedicated for dma-contiguous buffers but 
scatter-gather lists
will be use in the future.

The framework depends on anonfd framework which is used to create files that
are not associated with any inode.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
  drivers/base/Kconfig          |   11 +++++
  drivers/base/Makefile         |    1 +
  drivers/base/shared-buffer.c  |   96 
+++++++++++++++++++++++++++++++++++++++++
  include/linux/shared-buffer.h |   55 +++++++++++++++++++++++
  4 files changed, 163 insertions(+), 0 deletions(-)
  create mode 100644 drivers/base/shared-buffer.c
  create mode 100644 include/linux/shared-buffer.h

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index d57e8d0..d75a038 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -168,4 +168,15 @@ config SYS_HYPERVISOR
      bool
      default n

+config SHARED_BUFFER
+    bool "Framework for buffer sharing between drivers"
+    depends on ANON_INODES
+    help
+      This option enables the framework for buffer sharing between
+      multiple drivers. A buffer is associated with a file descriptor
+      using driver API's extensions. The descriptor is passed to other
+      driver.
+
+      If you are unsure about this, Say N here.
+
  endmenu
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 4c5701c..eeeb813 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_DEVTMPFS)    += devtmpfs.o
  obj-y            += power/
  obj-$(CONFIG_HAS_DMA)    += dma-mapping.o
  obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
+obj-$(CONFIG_SHARED_BUFFER) += shared-buffer.o
  obj-$(CONFIG_ISA)    += isa.o
  obj-$(CONFIG_FW_LOADER)    += firmware_class.o
  obj-$(CONFIG_NUMA)    += node.o
diff --git a/drivers/base/shared-buffer.c b/drivers/base/shared-buffer.c
new file mode 100644
index 0000000..105b696
--- /dev/null
+++ b/drivers/base/shared-buffer.c
@@ -0,0 +1,96 @@
+/*
+ * Framework for shared buffer
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/dma-mapping.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include <linux/shared-buffer.h>
+
+/**
+ * shrbuf_release() - release resources of shrbuf file
+ * @inode:    a file's inode, not used
+ * @file:    file pointer
+ *
+ * The function unbinds shrbuf structure from a file
+ */
+static int shrbuf_release(struct inode *inode, struct file *file)
+{
+    struct shrbuf *sb = file->private_data;
+
+    /* decrease reference counter increased in shrbuf_export */
+    sb->put(sb);
+    return 0;
+}
+
+static const struct file_operations shrbuf_fops = {
+    .release = shrbuf_release,
+};
+
+/**
+ * shrbuf_export() - transforms shrbuf into a file descriptor
+ * @sb:        shared buffer instance to be exported
+ *
+ * The function creates a file descriptor associated with a shared buffer
+ *
+ * Returns file descriptor or appropriate error on failure
+ */
+int shrbuf_export(struct shrbuf *sb)
+{
+    int fd;
+
+    BUG_ON(!sb || !sb->get || !sb->put);
+    /* binding shrbuf to a file so reference count in increased */
+    sb->get(sb);
+    /* obtaing file descriptor without inode */
+    fd = anon_inode_getfd("shrbuf", &shrbuf_fops, sb, 0);
+    /* releasing shrbuf on failure */
+    if (fd < 0)
+        sb->put(sb);
+    return fd;
+}
+
+EXPORT_SYMBOL(shrbuf_export);
+
+/**
+ * shrbuf_import() - obtain shrbuf structure from a file descriptor
+ * @fd:        file descriptor
+ *
+ * The function obtains an instance of a  shared buffer from a file 
descriptor
+ * Call sb->put when imported buffer is not longer needed
+ *
+ * Returns pointer to a shared buffer or error pointer on failure
+ */
+struct shrbuf *shrbuf_import(int fd)
+{
+    struct file *file;
+    struct shrbuf *sb;
+
+    /* obtain a file, assure that it will not be released */
+    file = fget(fd);
+    /* check if descriptor is incorrect */
+    if (!file)
+        return ERR_PTR(-EBADF);
+    /* check if dealing with shrbuf-file */
+    if (file->f_op != &shrbuf_fops) {
+        fput(file);
+        return ERR_PTR(-EINVAL);
+    }
+    /* add user of shared buffer */
+    sb = file->private_data;
+    sb->get(sb);
+    /* release the file */
+    fput(file);
+
+    return sb;
+}
+
+EXPORT_SYMBOL(shrbuf_import);
+
diff --git a/include/linux/shared-buffer.h b/include/linux/shared-buffer.h
new file mode 100644
index 0000000..ac0822f
--- /dev/null
+++ b/include/linux/shared-buffer.h
@@ -0,0 +1,55 @@
+/*
+ * Framework for shared buffer
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Author: Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_SHARED_BUFFER_H
+#define _LINUX_SHARED_BUFFER_H
+
+#include <linux/err.h>
+
+/**
+ * struct shrbuf - shared buffer instance
+ * @get:    increase number of a buffer's users
+ * @put:    decrease number of a buffer's user, release resources if needed
+ * @dma_addr:    start address of a contiguous buffer
+ * @size:    size of a contiguous buffer
+ *
+ * Both get/put methods are required. The structure is dedicated for
+ * embedding. The fields dma_addr and size are used for proof-of-concept
+ * purpose. They will be substituted by scatter-gatter lists.
+ */
+struct shrbuf {
+    void (*get)(struct shrbuf *);
+    void (*put)(struct shrbuf *);
+    unsigned long dma_addr;
+    unsigned long size;
+};
+
+#ifdef CONFIG_SHARED_BUFFER
+
+int shrbuf_export(struct shrbuf *sb);
+
+struct shrbuf *shrbuf_import(int fd);
+
+#else
+
+static inline int shrbuf_export(struct shrbuf *sb)
+{
+    return -ENODEV;
+}
+
+static inline struct shrbuf *shrbuf_import(int fd)
+{
+    return ERR_PTR(-ENODEV);
+}
+
+#endif /* CONFIG_SHARED_BUFFER */
+
+#endif /* _LINUX_SHARED_BUFFER_H */
-- 
1.7.6



