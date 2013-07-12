Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26093 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3GLGMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jul 2013 02:12:55 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: maarten.lankhorst@canonical.com, daniel@ffwll.ch,
	robdclark@gmail.com, sumit.semwal@linaro.org,
	linux@arm.linux.org.uk, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com,
	Inki Dae <inki.dae@samsung.com>
Subject: [RFC PATCH v5 1/2] dmabuf-sync: Introduce buffer synchronization
 framework
Date: Fri, 12 Jul 2013 15:12:45 +0900
Message-id: <1373609566-10784-2-git-send-email-inki.dae@samsung.com>
In-reply-to: <1373609566-10784-1-git-send-email-inki.dae@samsung.com>
References: <1373609566-10784-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a buffer synchronization framework based on DMA BUF[1]
and and based on ww-mutexes[2] for lock mechanism.

The purpose of this framework is to provide not only buffer access control
to CPU and DMA but also easy-to-use interfaces for device drivers and
user application. This framework can be used for all dma devices using
system memory as dma buffer, especially for most ARM based SoCs.

Changelog v5:
- Rmove a dependence on reservation_object: the reservation_object is used
  to hook up to ttm and dma-buf for easy sharing of reservations across
  devices. However, the dmabuf sync can be used for all dma devices; v4l2
  and drm based drivers, so doesn't need the reservation_object anymore.
  With regared to this, it adds 'void *sync' to dma_buf structure.
- All patches are rebased on mainline, Linux v3.10.

Changelog v4:
- Add user side interface for buffer synchronization mechanism and update
  descriptions related to the user side interface.

Changelog v3:
- remove cache operation relevant codes and update document file.

Changelog v2:
- use atomic_add_unless to avoid potential bug.
- add a macro for checking valid access type.
- code clean.

The mechanism of this framework has the following steps,
    1. Register dmabufs to a sync object - A task gets a new sync object and
    can add one or more dmabufs that the task wants to access.
    This registering should be performed when a device context or an event
    context such as a page flip event is created or before CPU accesses a shared
    buffer.

	dma_buf_sync_get(a sync object, a dmabuf);

    2. Lock a sync object - A task tries to lock all dmabufs added in its own
    sync object. Basically, the lock mechanism uses ww-mutex[1] to avoid dead
    lock issue and for race condition between CPU and CPU, CPU and DMA, and DMA
    and DMA. Taking a lock means that others cannot access all locked dmabufs
    until the task that locked the corresponding dmabufs, unlocks all the locked
    dmabufs.
    This locking should be performed before DMA or CPU accesses these dmabufs.

	dma_buf_sync_lock(a sync object);

    3. Unlock a sync object - The task unlocks all dmabufs added in its own sync
    object. The unlock means that the DMA or CPU accesses to the dmabufs have
    been completed so that others may access them.
    This unlocking should be performed after DMA or CPU has completed accesses
    to the dmabufs.

	dma_buf_sync_unlock(a sync object);

    4. Unregister one or all dmabufs from a sync object - A task unregisters
    the given dmabufs from the sync object. This means that the task dosen't
    want to lock the dmabufs.
    The unregistering should be performed after DMA or CPU has completed
    accesses to the dmabufs or when dma_buf_sync_lock() is failed.

	dma_buf_sync_put(a sync object, a dmabuf);
	dma_buf_sync_put_all(a sync object);

    The described steps may be summarized as:
	get -> lock -> CPU or DMA access to a buffer/s -> unlock -> put

This framework includes the following two features.
    1. read (shared) and write (exclusive) locks - A task is required to declare
    the access type when the task tries to register a dmabuf;
    READ, WRITE, READ DMA, or WRITE DMA.

    The below is example codes,
	struct dmabuf_sync *sync;

	sync = dmabuf_sync_init(NULL, "test sync");

	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_R);
	...

	And the below can be used as access types:
		DMA_BUF_ACCESS_R - CPU will access a buffer for read.
		DMA_BUF_ACCESS_W - CPU will access a buffer for read or write.
		DMA_BUF_ACCESS_DMA_R - DMA will access a buffer for read
		DMA_BUF_ACCESS_DMA_W - DMA will access a buffer for read or
					write.

    2. Mandatory resource releasing - a task cannot hold a lock indefinitely.
    A task may never try to unlock a buffer after taking a lock to the buffer.
    In this case, a timer handler to the corresponding sync object is called
    in five (default) seconds and then the timed-out buffer is unlocked by work
    queue handler to avoid lockups and to enforce resources of the buffer.

The below is how to use interfaces for device driver:
	1. Allocate and Initialize a sync object:
		struct dmabuf_sync *sync;

		sync = dmabuf_sync_init(NULL, "test sync");
		...

	2. Add a dmabuf to the sync object when setting up dma buffer relevant
	   registers:
		dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
		...

	3. Lock all dmabufs of the sync object before DMA or CPU accesses
	   the dmabufs:
		dmabuf_sync_lock(sync);
		...

	4. Now CPU or DMA can access all dmabufs locked in step 3.

	5. Unlock all dmabufs added in a sync object after DMA or CPU access
	   to these dmabufs is completed:
		dmabuf_sync_unlock(sync);

	   And call the following functions to release all resources,
		dmabuf_sync_put_all(sync);
		dmabuf_sync_fini(sync);

	You can refer to actual example codes:
		"drm/exynos: add dmabuf sync support for g2d driver" and
		"drm/exynos: add dmabuf sync support for kms framework" from
		https://git.kernel.org/cgit/linux/kernel/git/daeinki/
		drm-exynos.git/log/?h=dmabuf-sync

And this framework includes fcntl system call[3] as interfaces exported
to user. As you know, user sees a buffer object as a dma-buf file descriptor.
So fcntl() call with the file descriptor means to lock some buffer region being
managed by the dma-buf object.

The below is how to use interfaces for user application:
	struct flock filelock;

	1. Lock a dma buf:
		filelock.l_type = F_WRLCK or F_RDLCK;

		/* lock entire region to the dma buf. */
		filelock.lwhence = SEEK_CUR;
		filelock.l_start = 0;
		filelock.l_len = 0;

		fcntl(dmabuf fd, F_SETLKW or F_SETLK, &filelock);
		...
		CPU access to the dma buf

	2. Unlock a dma buf:
		filelock.l_type = F_UNLCK;

		fcntl(dmabuf fd, F_SETLKW or F_SETLK, &filelock);

		close(dmabuf fd) call would also unlock the dma buf. And for more
		detail, please refer to [3]

References:
[1] http://lwn.net/Articles/470339/
[2] https://patchwork.kernel.org/patch/2625361/
[3] http://linux.die.net/man/2/fcntl

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/dma-buf-sync.txt |  290 +++++++++++++++++
 drivers/base/Kconfig           |    7 +
 drivers/base/Makefile          |    1 +
 drivers/base/dma-buf.c         |    4 +
 drivers/base/dmabuf-sync.c     |  674 ++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h        |   16 +
 include/linux/dmabuf-sync.h    |  178 +++++++++++
 7 files changed, 1170 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-buf-sync.txt
 create mode 100644 drivers/base/dmabuf-sync.c
 create mode 100644 include/linux/dmabuf-sync.h

diff --git a/Documentation/dma-buf-sync.txt b/Documentation/dma-buf-sync.txt
new file mode 100644
index 0000000..4427759
--- /dev/null
+++ b/Documentation/dma-buf-sync.txt
@@ -0,0 +1,290 @@
+                    DMA Buffer Synchronization Framework
+                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+                                  Inki Dae
+                      <inki dot dae at samsung dot com>
+                          <daeinki at gmail dot com>
+
+This document is a guide for device-driver writers describing the DMA buffer
+synchronization API. This document also describes how to use the API to
+use buffer synchronization mechanism between DMA and DMA, CPU and DMA, and
+CPU and CPU.
+
+The DMA Buffer synchronization API provides buffer synchronization mechanism;
+i.e., buffer access control to CPU and DMA, and easy-to-use interfaces for
+device drivers and user application. And this API can be used for all dma
+devices using system memory as dma buffer, especially for most ARM based SoCs.
+
+
+Motivation
+----------
+
+Buffer synchronization issue between DMA and DMA:
+	Sharing a buffer, a device cannot be aware of when the other device
+	will access the shared buffer: a device may access a buffer containing
+	wrong data if the device accesses the shared buffer while another
+	device is still accessing the shared buffer.
+	Therefore, a user process should have waited for the completion of DMA
+	access by another device before a device tries to access the shared
+	buffer.
+
+Buffer synchronization issue between CPU and DMA:
+	A user process should consider that when having to send a buffer, filled
+	by CPU, to a device driver for the device driver to access the buffer as
+	a input buffer while CPU and DMA are sharing the buffer.
+	This means that the user process needs to understand how the device
+	driver is worked. Hence, the conventional mechanism not only makes
+	user application complicated but also incurs performance overhead.
+
+Buffer synchronization issue between CPU and CPU:
+	In case that two processes share one buffer; shared with DMA also,
+	they may need some mechanism to allow process B to access the shared
+	buffer after the completion of CPU access by process A.
+	Therefore, process B should have waited for the completion of CPU access
+	by process A using the mechanism before trying to access the shared
+	buffer.
+
+What is the best way to solve these buffer synchronization issues?
+	We may need a common object that a device driver and a user process
+	notify the common object of when they try to access a shared buffer.
+	That way we could decide when we have to allow or not to allow for CPU
+	or DMA to access the shared buffer through the common object.
+	If so, what could become the common object? Right, that's a dma-buf[1].
+	Now we have already been using the dma-buf to share one buffer with
+	other drivers.
+
+How we can utilize multi threads for more performance?
+	DMA and CPU works individually. So CPU could perform other works while
+	DMA are performing some works, and vise versa.
+	However, in the conventional way, that is not easy to do so because
+	DMA operation is depend on CPU operation, and vice versa.
+
+	Conventional way:
+        User                                     Kernel
+        ---------------------------------------------------------------------
+        CPU writes something to src
+        send the src to driver------------------------->
+                                                 update DMA register
+        request DMA start(1)--------------------------->
+                                                 DMA start
+                <---------completion signal(2)----------
+        CPU accesses dst
+
+        (1) Request DMA start after the CPU access to src buffer is completed.
+        (2) Access dst buffer after DMA access to the dst buffer is completed.
+
+On the other hand, if there is something to control buffer access between CPU
+and DMA? The below shows that:
+
+        User(thread a)          User(thread b)            Kernel
+        ---------------------------------------------------------------------
+        send a src to driver---------------------------------->
+                                                          update DMA register
+        lock the src
+                                request DMA start(1)---------->
+        CPU acccess to src
+        unlock the src                                    lock src and dst
+                                                          DMA start
+                <-------------completion signal(2)-------------
+        lock dst                                          DMA completion
+        CPU access to dst                                 unlock src and dst
+        unlock DST
+
+        (1) Try to start DMA operation while CPU is accessing the src buffer.
+        (2) Try CPU access to dst buffer while DMA is accessing the dst buffer.
+
+	In the same way, we could reduce hand shaking overhead between
+	two processes when those processes need to share a shared buffer.
+	There may be other cases that we could reduce overhead as well.
+
+
+Basic concept
+-------------
+
+The mechanism of this framework has the following steps,
+    1. Register dmabufs to a sync object - A task gets a new sync object and
+    can add one or more dmabufs that the task wants to access.
+    This registering should be performed when a device context or an event
+    context such as a page flip event is created or before CPU accesses a shared
+    buffer.
+
+	dma_buf_sync_get(a sync object, a dmabuf);
+
+    2. Lock a sync object - A task tries to lock all dmabufs added in its own
+    sync object. Basically, the lock mechanism uses ww-mutexes[2] to avoid dead
+    lock issue and for race condition between CPU and CPU, CPU and DMA, and DMA
+    and DMA. Taking a lock means that others cannot access all locked dmabufs
+    until the task that locked the corresponding dmabufs, unlocks all the locked
+    dmabufs.
+    This locking should be performed before DMA or CPU accesses these dmabufs.
+
+	dma_buf_sync_lock(a sync object);
+
+    3. Unlock a sync object - The task unlocks all dmabufs added in its own sync
+    object. The unlock means that the DMA or CPU accesses to the dmabufs have
+    been completed so that others may access them.
+    This unlocking should be performed after DMA or CPU has completed accesses
+    to the dmabufs.
+
+	dma_buf_sync_unlock(a sync object);
+
+    4. Unregister one or all dmabufs from a sync object - A task unregisters
+    the given dmabufs from the sync object. This means that the task dosen't
+    want to lock the dmabufs.
+    The unregistering should be performed after DMA or CPU has completed
+    accesses to the dmabufs or when dma_buf_sync_lock() is failed.
+
+	dma_buf_sync_put(a sync object, a dmabuf);
+	dma_buf_sync_put_all(a sync object);
+
+    The described steps may be summarized as:
+	get -> lock -> CPU or DMA access to a buffer/s -> unlock -> put
+
+This framework includes the following two features.
+    1. read (shared) and write (exclusive) locks - A task is required to declare
+    the access type when the task tries to register a dmabuf;
+    READ, WRITE, READ DMA, or WRITE DMA.
+
+    The below is example codes,
+	struct dmabuf_sync *sync;
+
+	sync = dmabuf_sync_init(NULL, "test sync");
+
+	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_R);
+	...
+
+    2. Mandatory resource releasing - a task cannot hold a lock indefinitely.
+    A task may never try to unlock a buffer after taking a lock to the buffer.
+    In this case, a timer handler to the corresponding sync object is called
+    in five (default) seconds and then the timed-out buffer is unlocked by work
+    queue handler to avoid lockups and to enforce resources of the buffer.
+
+
+Access types
+------------
+
+DMA_BUF_ACCESS_R - CPU will access a buffer for read.
+DMA_BUF_ACCESS_W - CPU will access a buffer for read or write.
+DMA_BUF_ACCESS_DMA_R - DMA will access a buffer for read
+DMA_BUF_ACCESS_DMA_W - DMA will access a buffer for read or write.
+
+
+Generic user interfaces
+-----------------------
+
+And this framework includes fcntl system call[3] as interfaces exported
+to user. As you know, user sees a buffer object as a dma-buf file descriptor.
+So fcntl() call with the file descriptor means to lock some buffer region being
+managed by the dma-buf object.
+
+
+API set
+-------
+
+bool is_dmabuf_sync_supported(void)
+	- Check if dmabuf sync is supported or not.
+
+struct dmabuf_sync *dmabuf_sync_init(void *priv, const char *name)
+	- Allocate and initialize a new sync object. The caller can get a new
+	sync object for buffer synchronization. priv is used to set caller's
+	private data and name is the name of sync object.
+
+void dmabuf_sync_fini(struct dmabuf_sync *sync)
+	- Release all resources to the sync object.
+
+int dmabuf_sync_get(struct dmabuf_sync *sync, void *sync_buf,
+			unsigned int type)
+	- Get dmabuf sync object. Internally, this function allocates
+	a dmabuf_sync object and adds a given dmabuf to it, and also takes
+	a reference to the dmabuf. The caller can tie up multiple dmabufs
+	into one sync object by calling this function several times.
+
+void dmabuf_sync_put(struct dmabuf_sync *sync, struct dma_buf *dmabuf)
+	- Put dmabuf sync object to a given dmabuf. Internally, this function
+	removes a given dmabuf from a sync object and remove the sync object.
+	At this time, the dmabuf is putted.
+
+void dmabuf_sync_put_all(struct dmabuf_sync *sync)
+	- Put dmabuf sync object to dmabufs. Internally, this function removes
+	all dmabufs from a sync object and remove the sync object.
+	At this time, all dmabufs are putted.
+
+int dmabuf_sync_lock(struct dmabuf_sync *sync)
+	- Lock all dmabufs added in a sync object. The caller should call this
+	function prior to CPU or DMA access to the dmabufs so that others can
+	not access the dmabufs. Internally, this function avoids dead lock
+	issue with ww-mutexes.
+
+int dmabuf_sync_single_lock(struct dma_buf *dmabuf)
+	- Lock a dmabuf. The caller should call this
+	function prior to CPU or DMA access to the dmabuf so that others can
+	not access the dmabuf.
+
+int dmabuf_sync_unlock(struct dmabuf_sync *sync)
+	- Unlock all dmabufs added in a sync object. The caller should call
+	this function after CPU or DMA access to the dmabufs is completed so
+	that others can access the dmabufs.
+
+void dmabuf_sync_single_unlock(struct dma_buf *dmabuf)
+	- Unlock a dmabuf. The caller should call this function after CPU or
+	DMA access to the dmabuf is completed so that others can access
+	the dmabuf.
+
+
+Tutorial for device driver
+--------------------------
+
+1. Allocate and Initialize a sync object:
+	struct dmabuf_sync *sync;
+
+	sync = dmabuf_sync_init(NULL, "test sync");
+	...
+
+2. Add a dmabuf to the sync object when setting up dma buffer relevant registers:
+	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
+	...
+
+3. Lock all dmabufs of the sync object before DMA or CPU accesses the dmabufs:
+	dmabuf_sync_lock(sync);
+	...
+
+4. Now CPU or DMA can access all dmabufs locked in step 3.
+
+5. Unlock all dmabufs added in a sync object after DMA or CPU access to these
+   dmabufs is completed:
+	dmabuf_sync_unlock(sync);
+
+   And call the following functions to release all resources,
+	dmabuf_sync_put_all(sync);
+	dmabuf_sync_fini(sync);
+
+
+Tutorial for user application
+-----------------------------
+	struct flock filelock;
+
+1. Lock a dma buf:
+	filelock.l_type = F_WRLCK or F_RDLCK;
+
+	/* lock entire region to the dma buf. */
+	filelock.lwhence = SEEK_CUR;
+	filelock.l_start = 0;
+	filelock.l_len = 0;
+
+	fcntl(dmabuf fd, F_SETLKW or F_SETLK, &filelock);
+	...
+	CPU access to the dma buf
+
+2. Unlock a dma buf:
+	filelock.l_type = F_UNLCK;
+
+	fcntl(dmabuf fd, F_SETLKW or F_SETLK, &filelock);
+
+	close(dmabuf fd) call would also unlock the dma buf. And for more
+	detail, please refer to [3]
+
+
+References:
+[1] http://lwn.net/Articles/470339/
+[2] https://patchwork.kernel.org/patch/2625361/
+[3] http://linux.die.net/man/2/fcntl
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index 5daa259..35e1518 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -200,6 +200,13 @@ config DMA_SHARED_BUFFER
 	  APIs extension; the file's descriptor can then be passed on to other
 	  driver.
 
+config DMABUF_SYNC
+	bool "DMABUF Synchronization Framework"
+	depends on DMA_SHARED_BUFFER
+	help
+	  This option enables dmabuf sync framework for buffer synchronization between
+	  DMA and DMA, CPU and DMA, and CPU and CPU.
+
 config CMA
 	bool "Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 48029aa..e06a5d7 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -11,6 +11,7 @@ obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o reservation.o
+obj-$(CONFIG_DMABUF_SYNC) += dmabuf-sync.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 08fe897..9a26981 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/dmabuf-sync.h>
 
 static inline int is_dma_buf_file(struct file *);
 
@@ -56,6 +57,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	list_del(&dmabuf->list_node);
 	mutex_unlock(&db_list.lock);
 
+	dmabuf_sync_reservation_fini(dmabuf);
+
 	kfree(dmabuf);
 	return 0;
 }
@@ -134,6 +137,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
 
+	dmabuf_sync_reservation_init(dmabuf);
 	dmabuf->file = file;
 
 	mutex_init(&dmabuf->lock);
diff --git a/drivers/base/dmabuf-sync.c b/drivers/base/dmabuf-sync.c
new file mode 100644
index 0000000..0b83111
--- /dev/null
+++ b/drivers/base/dmabuf-sync.c
@@ -0,0 +1,674 @@
+/*
+ * Copyright (C) 2013 Samsung Electronics Co.Ltd
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+
+#include <linux/dmabuf-sync.h>
+
+#define MAX_SYNC_TIMEOUT	5 /* Second. */
+
+int dmabuf_sync_enabled = 1;
+
+MODULE_PARM_DESC(enabled, "Check if dmabuf sync is supported or not");
+module_param_named(enabled, dmabuf_sync_enabled, int, 0444);
+
+DEFINE_WW_CLASS(dmabuf_sync_ww_class);
+EXPORT_SYMBOL(dmabuf_sync_ww_class);
+
+static void dmabuf_sync_timeout_worker(struct work_struct *work)
+{
+	struct dmabuf_sync *sync = container_of(work, struct dmabuf_sync, work);
+	struct dmabuf_sync_object *sobj;
+
+	mutex_lock(&sync->lock);
+
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		if (WARN_ON(!sobj->robj))
+			continue;
+
+		mutex_lock(&sobj->robj->lock);
+
+		printk(KERN_WARNING "%s: timeout = 0x%x [type = %d, " \
+					"refcnt = %d, locked = %d]\n",
+					sync->name, (u32)sobj->dmabuf,
+					sobj->access_type,
+					atomic_read(&sobj->robj->shared_cnt),
+					sobj->robj->locked);
+
+		/* unlock only valid sync object. */
+		if (!sobj->robj->locked) {
+			mutex_unlock(&sobj->robj->lock);
+			continue;
+		}
+
+		if (sobj->robj->shared &&
+		    atomic_add_unless(&sobj->robj->shared_cnt, -1, 1)) {
+			mutex_unlock(&sobj->robj->lock);
+			continue;
+		}
+
+		mutex_unlock(&sobj->robj->lock);
+
+		ww_mutex_unlock(&sobj->robj->sync_lock);
+
+		mutex_lock(&sobj->robj->lock);
+
+		if (sobj->access_type & DMA_BUF_ACCESS_R)
+			printk(KERN_WARNING "%s: r-unlocked = 0x%x\n",
+					sync->name, (u32)sobj->dmabuf);
+		else
+			printk(KERN_WARNING "%s: w-unlocked = 0x%x\n",
+					sync->name, (u32)sobj->dmabuf);
+
+		mutex_unlock(&sobj->robj->lock);
+	}
+
+	sync->status = 0;
+	mutex_unlock(&sync->lock);
+
+	dmabuf_sync_put_all(sync);
+	dmabuf_sync_fini(sync);
+}
+
+static void dmabuf_sync_lock_timeout(unsigned long arg)
+{
+	struct dmabuf_sync *sync = (struct dmabuf_sync *)arg;
+
+	schedule_work(&sync->work);
+}
+
+static int dmabuf_sync_lock_objs(struct dmabuf_sync *sync,
+					struct ww_acquire_ctx *ctx)
+{
+	struct dmabuf_sync_object *contended_sobj = NULL;
+	struct dmabuf_sync_object *res_sobj = NULL;
+	struct dmabuf_sync_object *sobj = NULL;
+	int ret;
+
+	if (ctx)
+		ww_acquire_init(ctx, &dmabuf_sync_ww_class);
+
+retry:
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		if (WARN_ON(!sobj->robj))
+			continue;
+
+		mutex_lock(&sobj->robj->lock);
+
+		/* Don't lock in case of read and read. */
+		if (sobj->robj->accessed_type & DMA_BUF_ACCESS_R &&
+		    sobj->access_type & DMA_BUF_ACCESS_R) {
+			atomic_inc(&sobj->robj->shared_cnt);
+			sobj->robj->shared = true;
+			mutex_unlock(&sobj->robj->lock);
+			continue;
+		}
+
+		if (sobj == res_sobj) {
+			res_sobj = NULL;
+			mutex_unlock(&sobj->robj->lock);
+			continue;
+		}
+
+		mutex_unlock(&sobj->robj->lock);
+
+		ret = ww_mutex_lock(&sobj->robj->sync_lock, ctx);
+		if (ret < 0) {
+			contended_sobj = sobj;
+
+			if (ret == -EDEADLK)
+				printk(KERN_WARNING"%s: deadlock = 0x%x\n",
+					sync->name, (u32)sobj->dmabuf);
+			goto err;
+		}
+
+		mutex_lock(&sobj->robj->lock);
+		sobj->robj->locked = true;
+
+		mutex_unlock(&sobj->robj->lock);
+	}
+
+	if (ctx)
+		ww_acquire_done(ctx);
+
+	init_timer(&sync->timer);
+
+	sync->timer.data = (unsigned long)sync;
+	sync->timer.function = dmabuf_sync_lock_timeout;
+	sync->timer.expires = jiffies + (HZ * MAX_SYNC_TIMEOUT);
+
+	add_timer(&sync->timer);
+
+	return 0;
+
+err:
+	list_for_each_entry_continue_reverse(sobj, &sync->syncs, head) {
+		mutex_lock(&sobj->robj->lock);
+
+		/* Don't need to unlock in case of read and read. */
+		if (atomic_add_unless(&sobj->robj->shared_cnt, -1, 1)) {
+			mutex_unlock(&sobj->robj->lock);
+			continue;
+		}
+
+		ww_mutex_unlock(&sobj->robj->sync_lock);
+		sobj->robj->locked = false;
+
+		mutex_unlock(&sobj->robj->lock);
+	}
+
+	if (res_sobj) {
+		mutex_lock(&res_sobj->robj->lock);
+
+		if (!atomic_add_unless(&res_sobj->robj->shared_cnt, -1, 1)) {
+			ww_mutex_unlock(&res_sobj->robj->sync_lock);
+			res_sobj->robj->locked = false;
+		}
+
+		mutex_unlock(&res_sobj->robj->lock);
+	}
+
+	if (ret == -EDEADLK) {
+		ww_mutex_lock_slow(&contended_sobj->robj->sync_lock, ctx);
+		res_sobj = contended_sobj;
+
+		goto retry;
+	}
+
+	if (ctx)
+		ww_acquire_fini(ctx);
+
+	return ret;
+}
+
+static void dmabuf_sync_unlock_objs(struct dmabuf_sync *sync,
+					struct ww_acquire_ctx *ctx)
+{
+	struct dmabuf_sync_object *sobj;
+
+	if (list_empty(&sync->syncs))
+		return;
+
+	mutex_lock(&sync->lock);
+
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		mutex_lock(&sobj->robj->lock);
+
+		if (sobj->robj->shared) {
+			if (atomic_add_unless(&sobj->robj->shared_cnt, -1,
+						1)) {
+				mutex_unlock(&sobj->robj->lock);
+				continue;
+			}
+
+			mutex_unlock(&sobj->robj->lock);
+
+			ww_mutex_unlock(&sobj->robj->sync_lock);
+
+			mutex_lock(&sobj->robj->lock);
+			sobj->robj->shared = false;
+			sobj->robj->locked = false;
+		} else {
+			mutex_unlock(&sobj->robj->lock);
+
+			ww_mutex_unlock(&sobj->robj->sync_lock);
+
+			mutex_lock(&sobj->robj->lock);
+			sobj->robj->locked = false;
+		}
+
+		mutex_unlock(&sobj->robj->lock);
+	}
+
+	mutex_unlock(&sync->lock);
+
+	if (ctx)
+		ww_acquire_fini(ctx);
+
+	del_timer(&sync->timer);
+}
+
+/**
+ * is_dmabuf_sync_supported - Check if dmabuf sync is supported or not.
+ */
+bool is_dmabuf_sync_supported(void)
+{
+	return dmabuf_sync_enabled == 1;
+}
+EXPORT_SYMBOL(is_dmabuf_sync_supported);
+
+/**
+ * dmabuf_sync_init - Allocate and initialize a dmabuf sync.
+ *
+ * @priv: A device private data.
+ * @name: A sync object name.
+ *
+ * This function should be called when a device context or an event
+ * context such as a page flip event is created. And the created
+ * dmabuf_sync object should be set to the context.
+ * The caller can get a new sync object for buffer synchronization
+ * through this function.
+ */
+struct dmabuf_sync *dmabuf_sync_init(void *priv, const char *name)
+{
+	struct dmabuf_sync *sync;
+
+	sync = kzalloc(sizeof(*sync), GFP_KERNEL);
+	if (!sync)
+		return ERR_PTR(-ENOMEM);
+
+	strncpy(sync->name, name, ARRAY_SIZE(sync->name) - 1);
+
+	sync->priv = priv;
+	INIT_LIST_HEAD(&sync->syncs);
+	mutex_init(&sync->lock);
+	INIT_WORK(&sync->work, dmabuf_sync_timeout_worker);
+
+	return sync;
+}
+EXPORT_SYMBOL(dmabuf_sync_init);
+
+/**
+ * dmabuf_sync_fini - Release a given dmabuf sync.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * This function should be called if some operation is failed after
+ * dmabuf_sync_init call to release relevant resources, and after
+ * dmabuf_sync_unlock function is called.
+ */
+void dmabuf_sync_fini(struct dmabuf_sync *sync)
+{
+	if (WARN_ON(!sync))
+		return;
+
+	kfree(sync);
+}
+EXPORT_SYMBOL(dmabuf_sync_fini);
+
+/*
+ * dmabuf_sync_get_obj - Add a given object to syncs list.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ * @dmabuf: An object to dma_buf structure.
+ * @type: A access type to a dma buf.
+ *	The DMA_BUF_ACCESS_R means that this dmabuf could be accessed by
+ *	others for read access. On the other hand, the DMA_BUF_ACCESS_W
+ *	means that this dmabuf couldn't be accessed by others but would be
+ *	accessed by caller's dma exclusively. And the DMA_BUF_ACCESS_DMA can be
+ *	combined.
+ *
+ * This function creates and initializes a new dmabuf sync object and it adds
+ * the dmabuf sync object to syncs list to track and manage all dmabufs.
+ */
+static int dmabuf_sync_get_obj(struct dmabuf_sync *sync, struct dma_buf *dmabuf,
+					unsigned int type)
+{
+	struct dmabuf_sync_object *sobj;
+
+	if (!dmabuf->sync) {
+		WARN_ON(1);
+		return -EFAULT;
+	}
+
+	if (!IS_VALID_DMA_BUF_ACCESS_TYPE(type))
+		return -EINVAL;
+
+	if ((type & DMA_BUF_ACCESS_RW) == DMA_BUF_ACCESS_RW)
+		type &= ~DMA_BUF_ACCESS_R;
+
+	sobj = kzalloc(sizeof(*sobj), GFP_KERNEL);
+	if (!sobj) {
+		WARN_ON(1);
+		return -ENOMEM;
+	}
+
+	sobj->dmabuf = dmabuf;
+	sobj->robj = dmabuf->sync;
+
+	mutex_lock(&sync->lock);
+	list_add_tail(&sobj->head, &sync->syncs);
+	mutex_unlock(&sync->lock);
+
+	get_dma_buf(dmabuf);
+
+	mutex_lock(&sobj->robj->lock);
+	sobj->access_type = type;
+	mutex_unlock(&sobj->robj->lock);
+
+	return 0;
+}
+
+/*
+ * dmabuf_sync_put_obj - Release a given sync object.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * This function should be called if some operation is failed after
+ * dmabuf_sync_get_obj call to release a given sync object.
+ */
+static void dmabuf_sync_put_obj(struct dmabuf_sync *sync,
+					struct dma_buf *dmabuf)
+{
+	struct dmabuf_sync_object *sobj;
+
+	mutex_lock(&sync->lock);
+
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		if (sobj->dmabuf != dmabuf)
+			continue;
+
+		dma_buf_put(sobj->dmabuf);
+
+		list_del_init(&sobj->head);
+		kfree(sobj);
+		break;
+	}
+
+	if (list_empty(&sync->syncs))
+		sync->status = 0;
+
+	mutex_unlock(&sync->lock);
+}
+
+/*
+ * dmabuf_sync_put_objs - Release all sync objects of dmabuf_sync.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * This function should be called if some operation is failed after
+ * dmabuf_sync_get_obj call to release all sync objects.
+ */
+static void dmabuf_sync_put_objs(struct dmabuf_sync *sync)
+{
+	struct dmabuf_sync_object *sobj, *next;
+
+	mutex_lock(&sync->lock);
+
+	list_for_each_entry_safe(sobj, next, &sync->syncs, head) {
+		dma_buf_put(sobj->dmabuf);
+
+		list_del_init(&sobj->head);
+		kfree(sobj);
+	}
+
+	mutex_unlock(&sync->lock);
+
+	sync->status = 0;
+}
+
+/**
+ * dmabuf_sync_lock - lock all dmabufs added to syncs list.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * The caller should call this function prior to CPU or DMA access to
+ * the dmabufs so that others can not access the dmabufs.
+ * Internally, this function avoids dead lock issue with ww-mutex.
+ */
+int dmabuf_sync_lock(struct dmabuf_sync *sync)
+{
+	int ret;
+
+	if (!sync) {
+		WARN_ON(1);
+		return -EFAULT;
+	}
+
+	if (list_empty(&sync->syncs))
+		return -EINVAL;
+
+	if (sync->status != DMABUF_SYNC_GOT)
+		return -EINVAL;
+
+	ret = dmabuf_sync_lock_objs(sync, &sync->ctx);
+	if (ret < 0) {
+		WARN_ON(1);
+		return ret;
+	}
+
+	sync->status = DMABUF_SYNC_LOCKED;
+
+	return ret;
+}
+EXPORT_SYMBOL(dmabuf_sync_lock);
+
+/**
+ * dmabuf_sync_unlock - unlock all objects added to syncs list.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * The caller should call this function after CPU or DMA access to
+ * the dmabufs is completed so that others can access the dmabufs.
+ */
+int dmabuf_sync_unlock(struct dmabuf_sync *sync)
+{
+	if (!sync) {
+		WARN_ON(1);
+		return -EFAULT;
+	}
+
+	/* If current dmabuf sync object wasn't reserved then just return. */
+	if (sync->status != DMABUF_SYNC_LOCKED)
+		return -EAGAIN;
+
+	dmabuf_sync_unlock_objs(sync, &sync->ctx);
+
+	return 0;
+}
+EXPORT_SYMBOL(dmabuf_sync_unlock);
+
+/**
+ * dmabuf_sync_single_lock - lock a dma buf.
+ *
+ * @dmabuf: A dma buf object that tries to lock.
+ * @type: A access type to a dma buf.
+ *	The DMA_BUF_ACCESS_R means that this dmabuf could be accessed by
+ *	others for read access. On the other hand, the DMA_BUF_ACCESS_W
+ *	means that this dmabuf couldn't be accessed by others but would be
+ *	accessed by caller's dma exclusively. And the DMA_BUF_ACCESS_DMA can
+ *	be combined with other.
+ * @wait: Indicate whether caller is blocked or not.
+ *	true means that caller will be blocked, and false means that this
+ *	function will return -EAGAIN if this caller can't take the lock
+ *	right now.
+ *
+ * The caller should call this function prior to CPU or DMA access to the dmabuf
+ * so that others cannot access the dmabuf.
+ */
+int dmabuf_sync_single_lock(struct dma_buf *dmabuf, unsigned int type,
+				bool wait)
+{
+	struct dmabuf_sync_reservation *robj;
+
+	if (!dmabuf->sync) {
+		WARN_ON(1);
+		return -EFAULT;
+	}
+
+	if (!IS_VALID_DMA_BUF_ACCESS_TYPE(type)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	get_dma_buf(dmabuf);
+	robj = dmabuf->sync;
+
+	mutex_lock(&robj->lock);
+
+	/* Don't lock in case of read and read. */
+	if (robj->accessed_type & DMA_BUF_ACCESS_R && type & DMA_BUF_ACCESS_R) {
+		atomic_inc(&robj->shared_cnt);
+		robj->shared = true;
+		mutex_unlock(&robj->lock);
+		return 0;
+	}
+
+	/*
+	 * In case of F_SETLK, just return -EAGAIN if this dmabuf has already
+	 * been locked.
+	 */
+	if (!wait && robj->locked) {
+		mutex_unlock(&robj->lock);
+		dma_buf_put(dmabuf);
+		return -EAGAIN;
+	}
+
+	mutex_unlock(&robj->lock);
+
+	mutex_lock(&robj->sync_lock.base);
+
+	mutex_lock(&robj->lock);
+	robj->locked = true;
+	mutex_unlock(&robj->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(dmabuf_sync_single_lock);
+
+/**
+ * dmabuf_sync_single_unlock - unlock a dma buf.
+ *
+ * @dmabuf: A dma buf object that tries to unlock.
+ *
+ * The caller should call this function after CPU or DMA access to
+ * the dmabuf is completed so that others can access the dmabuf.
+ */
+void dmabuf_sync_single_unlock(struct dma_buf *dmabuf)
+{
+	struct dmabuf_sync_reservation *robj;
+
+	if (!dmabuf->sync) {
+		WARN_ON(1);
+		return;
+	}
+
+	robj = dmabuf->sync;
+
+	mutex_lock(&robj->lock);
+
+	if (robj->shared) {
+		if (atomic_add_unless(&robj->shared_cnt, -1 , 1)) {
+			mutex_unlock(&robj->lock);
+			return;
+		}
+
+		robj->shared = false;
+	}
+
+	mutex_unlock(&robj->lock);
+
+	mutex_unlock(&robj->sync_lock.base);
+
+	mutex_lock(&robj->lock);
+	robj->locked = false;
+	mutex_unlock(&robj->lock);
+
+	dma_buf_put(dmabuf);
+
+	return;
+}
+EXPORT_SYMBOL(dmabuf_sync_single_unlock);
+
+/**
+ * dmabuf_sync_get - Get dmabuf sync object.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ * @sync_buf: A dmabuf object to be synchronized with others.
+ * @type: A access type to a dma buf.
+ *	The DMA_BUF_ACCESS_R means that this dmabuf could be accessed by
+ *	others for read access. On the other hand, the DMA_BUF_ACCESS_W
+ *	means that this dmabuf couldn't be accessed by others but would be
+ *	accessed by caller's dma exclusively. And the DMA_BUF_ACCESS_DMA can
+ *	be combined with other.
+ *
+ * This function should be called after dmabuf_sync_init function is called.
+ * The caller can tie up multiple dmabufs into one sync object by calling this
+ * function several times. Internally, this function allocates
+ * a dmabuf_sync_object and adds a given dmabuf to it, and also takes
+ * a reference to a dmabuf.
+ */
+int dmabuf_sync_get(struct dmabuf_sync *sync, void *sync_buf, unsigned int type)
+{
+	int ret;
+
+	if (!sync || !sync_buf) {
+		WARN_ON(1);
+		return -EFAULT;
+	}
+
+	ret = dmabuf_sync_get_obj(sync, sync_buf, type);
+	if (ret < 0) {
+		WARN_ON(1);
+		return ret;
+	}
+
+	sync->status = DMABUF_SYNC_GOT;
+
+	return 0;
+}
+EXPORT_SYMBOL(dmabuf_sync_get);
+
+/**
+ * dmabuf_sync_put - Put dmabuf sync object to a given dmabuf.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ * @dmabuf: An dmabuf object.
+ *
+ * This function should be called if some operation is failed after
+ * dmabuf_sync_get function is called to release the dmabuf, or
+ * dmabuf_sync_unlock function is called. Internally, this function
+ * removes a given dmabuf from a sync object and remove the sync object.
+ * At this time, the dmabuf is putted.
+ */
+void dmabuf_sync_put(struct dmabuf_sync *sync, struct dma_buf *dmabuf)
+{
+	if (!sync || !dmabuf) {
+		WARN_ON(1);
+		return;
+	}
+
+	if (list_empty(&sync->syncs))
+		return;
+
+	dmabuf_sync_put_obj(sync, dmabuf);
+}
+EXPORT_SYMBOL(dmabuf_sync_put);
+
+/**
+ * dmabuf_sync_put_all - Put dmabuf sync object to dmabufs.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * This function should be called if some operation is failed after
+ * dmabuf_sync_get function is called to release all sync objects, or
+ * dmabuf_sync_unlock function is called. Internally, this function
+ * removes dmabufs from a sync object and remove the sync object.
+ * At this time, all dmabufs are putted.
+ */
+void dmabuf_sync_put_all(struct dmabuf_sync *sync)
+{
+	if (!sync) {
+		WARN_ON(1);
+		return;
+	}
+
+	if (list_empty(&sync->syncs))
+		return;
+
+	dmabuf_sync_put_objs(sync);
+}
+EXPORT_SYMBOL(dmabuf_sync_put_all);
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index dfac5ed..0109673 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -115,6 +115,7 @@ struct dma_buf_ops {
  * @exp_name: name of the exporter; useful for debugging.
  * @list_node: node for dma_buf accounting and debugging.
  * @priv: exporter specific private data for this buffer object.
+ * @sync: sync object linked to this dma-buf
  */
 struct dma_buf {
 	size_t size;
@@ -128,6 +129,7 @@ struct dma_buf {
 	const char *exp_name;
 	struct list_head list_node;
 	void *priv;
+	void *sync;
 };
 
 /**
@@ -148,6 +150,20 @@ struct dma_buf_attachment {
 	void *priv;
 };
 
+#define	DMA_BUF_ACCESS_R	0x1
+#define DMA_BUF_ACCESS_W	0x2
+#define DMA_BUF_ACCESS_DMA	0x4
+#define DMA_BUF_ACCESS_RW	(DMA_BUF_ACCESS_R | DMA_BUF_ACCESS_W)
+#define DMA_BUF_ACCESS_DMA_R	(DMA_BUF_ACCESS_R | DMA_BUF_ACCESS_DMA)
+#define DMA_BUF_ACCESS_DMA_W	(DMA_BUF_ACCESS_W | DMA_BUF_ACCESS_DMA)
+#define DMA_BUF_ACCESS_DMA_RW	(DMA_BUF_ACCESS_DMA_R | DMA_BUF_ACCESS_DMA_W)
+#define IS_VALID_DMA_BUF_ACCESS_TYPE(t)	(t == DMA_BUF_ACCESS_R || \
+					 t == DMA_BUF_ACCESS_W || \
+					 t == DMA_BUF_ACCESS_DMA_R || \
+					 t == DMA_BUF_ACCESS_DMA_W || \
+					 t == DMA_BUF_ACCESS_RW || \
+					 t == DMA_BUF_ACCESS_DMA_RW)
+
 /**
  * get_dma_buf - convenience wrapper for get_file.
  * @dmabuf:	[in]	pointer to dma_buf
diff --git a/include/linux/dmabuf-sync.h b/include/linux/dmabuf-sync.h
new file mode 100644
index 0000000..2502ad6
--- /dev/null
+++ b/include/linux/dmabuf-sync.h
@@ -0,0 +1,178 @@
+/*
+ * Copyright (C) 2013 Samsung Electronics Co.Ltd
+ * Authors:
+ *	Inki Dae <inki.dae@samsung.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ */
+
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/dma-buf.h>
+
+enum dmabuf_sync_status {
+	DMABUF_SYNC_GOT		= 1,
+	DMABUF_SYNC_LOCKED,
+};
+
+struct dmabuf_sync_reservation {
+	struct ww_mutex		sync_lock;
+	struct mutex		lock;
+	atomic_t		shared_cnt;
+	unsigned int		accessed_type;
+	unsigned int		shared;
+	unsigned int		locked;
+};
+
+/*
+ * A structure for dmabuf_sync_object.
+ *
+ * @head: A list head to be added to syncs list.
+ * @robj: A reservation_object object.
+ * @dma_buf: A dma_buf object.
+ * @access_type: Indicate how a current task tries to access
+ *	a given buffer.
+ */
+struct dmabuf_sync_object {
+	struct list_head		head;
+	struct dmabuf_sync_reservation	*robj;
+	struct dma_buf			*dmabuf;
+	unsigned int			access_type;
+};
+
+/*
+ * A structure for dmabuf_sync.
+ *
+ * @syncs: A list head to sync object and this is global to system.
+ * @list: A list entry used as committed list node
+ * @lock: A mutex lock to current sync object.
+ * @ctx: A current context for ww mutex.
+ * @work: A work struct to release resources at timeout.
+ * @priv: A private data.
+ * @name: A string to dmabuf sync owner.
+ * @timer: A timer list to avoid lockup and release resources.
+ * @status: Indicate current status (DMABUF_SYNC_GOT or DMABUF_SYNC_LOCKED).
+ */
+struct dmabuf_sync {
+	struct list_head	syncs;
+	struct list_head	list;
+	struct mutex		lock;
+	struct ww_acquire_ctx	ctx;
+	struct work_struct	work;
+	void			*priv;
+	char			name[64];
+	struct timer_list	timer;
+	unsigned int		status;
+};
+
+#ifdef CONFIG_DMABUF_SYNC
+
+extern struct ww_class dmabuf_sync_ww_class;
+
+static inline void dmabuf_sync_reservation_init(struct dma_buf *dmabuf)
+{
+	struct dmabuf_sync_reservation *obj;
+
+	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return;
+
+	dmabuf->sync = obj;
+
+	ww_mutex_init(&obj->sync_lock, &dmabuf_sync_ww_class);
+
+	mutex_init(&obj->lock);
+	atomic_set(&obj->shared_cnt, 1);
+}
+
+static inline void dmabuf_sync_reservation_fini(struct dma_buf *dmabuf)
+{
+	struct dmabuf_sync_reservation *obj;
+
+	if (!dmabuf->sync)
+		return;
+
+	obj = dmabuf->sync;
+
+	ww_mutex_destroy(&obj->sync_lock);
+
+	kfree(obj);
+}
+
+extern bool is_dmabuf_sync_supported(void);
+
+extern struct dmabuf_sync *dmabuf_sync_init(void *priv, const char *name);
+
+extern void dmabuf_sync_fini(struct dmabuf_sync *sync);
+
+extern int dmabuf_sync_lock(struct dmabuf_sync *sync);
+
+extern int dmabuf_sync_unlock(struct dmabuf_sync *sync);
+
+int dmabuf_sync_single_lock(struct dma_buf *dmabuf, unsigned int type,
+				bool wait);
+
+void dmabuf_sync_single_unlock(struct dma_buf *dmabuf);
+
+extern int dmabuf_sync_get(struct dmabuf_sync *sync, void *sync_buf,
+				unsigned int type);
+
+extern void dmabuf_sync_put(struct dmabuf_sync *sync, struct dma_buf *dmabuf);
+
+extern void dmabuf_sync_put_all(struct dmabuf_sync *sync);
+
+#else
+
+static inline void dmabuf_sync_reservation_init(struct dma_buf *dmabuf) { }
+
+static inline void dmabuf_sync_reservation_fini(struct dma_buf *dmabuf) { }
+
+static inline bool is_dmabuf_sync_supported(void) { return false; }
+
+static inline struct dmabuf_sync *dmabuf_sync_init(void *priv,
+					const char *names)
+{
+	return ERR_PTR(0);
+}
+
+static inline void dmabuf_sync_fini(struct dmabuf_sync *sync) { }
+
+static inline int dmabuf_sync_lock(struct dmabuf_sync *sync)
+{
+	return 0;
+}
+
+static inline int dmabuf_sync_unlock(struct dmabuf_sync *sync)
+{
+	return 0;
+}
+
+static inline int dmabuf_sync_single_lock(struct dma_buf *dmabuf,
+						unsigned int type,
+						bool wait)
+{
+	return 0;
+}
+
+static inline void dmabuf_sync_single_unlock(struct dma_buf *dmabuf)
+{
+	return;
+}
+
+static inline int dmabuf_sync_get(struct dmabuf_sync *sync,
+					void *sync_buf,
+					unsigned int type)
+{
+	return 0;
+}
+
+static inline void dmabuf_sync_put(struct dmabuf_sync *sync,
+					struct dma_buf *dmabuf) { }
+
+static inline void dmabuf_sync_put_all(struct dmabuf_sync *sync) { }
+
+#endif
-- 
1.7.5.4

