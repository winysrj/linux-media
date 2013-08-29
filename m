Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3H2Hxb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 03:53:31 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Cc: maarten.lankhorst@canonical.com, sumit.semwal@linaro.org,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v8 1/2] dmabuf-sync: Add a buffer synchronization framework
Date: Thu, 29 Aug 2013 16:53:20 +0900
Message-id: <1377762801-14057-2-git-send-email-inki.dae@samsung.com>
In-reply-to: <1377762801-14057-1-git-send-email-inki.dae@samsung.com>
References: <1377762801-14057-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds a buffer synchronization framework based on DMA BUF[1]
and and based on ww-mutexes[2] for lock mechanism, and has been rebased
on linux-next.

The purpose of this framework is to provide not only buffer access control
to CPU and DMA but also easy-to-use interfaces for device drivers and
user application. This framework can be used for all dma devices using
system memory as dma buffer, especially for most ARM based SoCs.

Changelog v8:
Consider the write-and-then-read ordering pointed out by David Herrmann,
- The ordering issue means that a task don't take a lock to the dmabuf
  so this task would be stalled even though this task requested a lock to
  the dmabuf between other task unlocked and tries to lock the dmabuf
  again. For this, we have added a wait event mechanism using only generic
  APIs, wait_event_timeout and wake_up functions.

  The below is how to handle the ordering issue using this mechanism:
  1. Check if there is a sync object added prior to current task's one.
  2. If exists, it unlocks the dmabuf so that other task can take a lock
     to the dmabuf first.
  3. Wait for the wake up event from other task: current task will be
     waked up when other task unlocks the dmabuf.
  4. Take a lock to the dmabuf again.
- Code cleanups.

Changelog v7:
Fix things pointed out by Konrad Rzeszutek Wilk,
- Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
- make sure to unlock and unreference all dmabuf objects
  when dmabuf_sync_fini() is called.
- Add more comments.
- code cleanups.

Changelog v6:
- Fix sync lock to multiple reads.
- Add select system call support.
  . Wake up poll_wait when a dmabuf is unlocked.
- Remove unnecessary the use of mutex lock.
- Add private backend ops callbacks.
  . This ops has one callback for device drivers to clean up their
    sync object resource when the sync object is freed. For this,
    device drivers should implement the free callback properly.
- Update document file.

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

	sync = dmabuf_sync_init(...);
	...

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
		static void xxx_dmabuf_sync_free(void *priv)
		{
			struct xxx_context *ctx = priv;

			if (!ctx)
				return;

			ctx->sync = NULL;
		}
		...

		static struct dmabuf_sync_priv_ops driver_specific_ops = {
			.free = xxx_dmabuf_sync_free,
		};
		...

		struct dmabuf_sync *sync;

		sync = dmabuf_sync_init("test sync", &driver_specific_ops, ctx);
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

And this framework includes fcntl[3] and select system call as interfaces
exported to user. As you know, user sees a buffer object as a dma-buf file
descriptor. fcntl() call with the file descriptor means to lock some buffer
region being managed by the dma-buf object. And select() call with the file
descriptor means to poll the completion event of CPU or DMA access to
the dma-buf.

The below is how to use interfaces for user application:

fcntl system call:

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

select system call:

	fd_set wdfs or rdfs;

	FD_ZERO(&wdfs or &rdfs);
	FD_SET(fd, &wdfs or &rdfs);

	select(fd + 1, &rdfs, NULL, NULL, NULL);
		or
	select(fd + 1, NULL, &wdfs, NULL, NULL);

	Every time select system call is called, a caller will wait for
	the completion of DMA or CPU access to a shared buffer if there
	is someone accessing the shared buffer. If no anyone then select
	system call will be returned at once.

References:
[1] http://lwn.net/Articles/470339/
[2] https://patchwork.kernel.org/patch/2625361/
[3] http://linux.die.net/man/2/fcntl

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/dma-buf-sync.txt |  286 ++++++++++++
 drivers/base/Kconfig           |    7 +
 drivers/base/Makefile          |    1 +
 drivers/base/dma-buf.c         |    4 +
 drivers/base/dmabuf-sync.c     |  945 ++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h        |   16 +
 include/linux/dmabuf-sync.h    |  257 +++++++++++
 7 files changed, 1516 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-buf-sync.txt
 create mode 100644 drivers/base/dmabuf-sync.c
 create mode 100644 include/linux/dmabuf-sync.h

diff --git a/Documentation/dma-buf-sync.txt b/Documentation/dma-buf-sync.txt
new file mode 100644
index 0000000..5945c8a
--- /dev/null
+++ b/Documentation/dma-buf-sync.txt
@@ -0,0 +1,286 @@
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
+And this framework includes fcntl[3] and select system calls as interfaces
+exported to user. As you know, user sees a buffer object as a dma-buf file
+descriptor. fcntl() call with the file descriptor means to lock some buffer
+region being managed by the dma-buf object. And select call with the file
+descriptor means to poll the completion event of CPU or DMA access to
+the dma-buf.
+
+
+API set
+-------
+
+bool is_dmabuf_sync_supported(void)
+	- Check if dmabuf sync is supported or not.
+
+struct dmabuf_sync *dmabuf_sync_init(const char *name,
+					struct dmabuf_sync_priv_ops *ops,
+					void priv*)
+	- Allocate and initialize a new sync object. The caller can get a new
+	sync object for buffer synchronization. ops is used for device driver
+	to clean up its own sync object. For this, each device driver should
+	implement a free callback. priv is used for device driver to get its
+	device context when free callback is called.
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
+	static void xxx_dmabuf_sync_free(void *priv)
+	{
+		struct xxx_context *ctx = priv;
+
+		if (!ctx)
+			return;
+
+		ctx->sync = NULL;
+	}
+	...
+
+	static struct dmabuf_sync_priv_ops driver_specific_ops = {
+		.free = xxx_dmabuf_sync_free,
+	};
+	...
+
+	struct dmabuf_sync *sync;
+
+	sync = dmabuf_sync_init("test sync", &driver_specific_ops, ctx);
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
+fcntl system call:
+
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
+select system call:
+
+	fd_set wdfs or rdfs;
+
+	FD_ZERO(&wdfs or &rdfs);
+	FD_SET(fd, &wdfs or &rdfs);
+
+	select(fd + 1, &rdfs, NULL, NULL, NULL);
+		or
+	select(fd + 1, NULL, &wdfs, NULL, NULL);
+
+	Every time select system call is called, a caller will wait for
+	the completion of DMA or CPU access to a shared buffer if there
+	is someone accessing the shared buffer. If no anyone then select
+	system call will be returned at once.
+
+References:
+[1] http://lwn.net/Articles/470339/
+[2] https://patchwork.kernel.org/patch/2625361/
+[3] http://linux.die.net/man/2/fcntl
diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index e373671..23e0fbf 100644
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
 config DMA_CMA
 	bool "DMA Contiguous Memory Allocator"
 	depends on HAVE_DMA_CONTIGUOUS && CMA
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 94e8a80..e88d9b8 100644
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
index d03da13..cc42a38 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -30,6 +30,7 @@
 #include <linux/export.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/dmabuf-sync.h>
 
 static inline int is_dma_buf_file(struct file *);
 
@@ -57,6 +58,8 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	list_del(&dmabuf->list_node);
 	mutex_unlock(&db_list.lock);
 
+	dmabuf_sync_reservation_fini(dmabuf);
+
 	kfree(dmabuf);
 	return 0;
 }
@@ -135,6 +138,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 
 	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
 
+	dmabuf_sync_reservation_init(dmabuf);
 	dmabuf->file = file;
 
 	mutex_init(&dmabuf->lock);
diff --git a/drivers/base/dmabuf-sync.c b/drivers/base/dmabuf-sync.c
new file mode 100644
index 0000000..1ab05a3
--- /dev/null
+++ b/drivers/base/dmabuf-sync.c
@@ -0,0 +1,945 @@
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
+#define MAX_SYNC_TIMEOUT	5	/* Second. */
+#define MAX_WAIT_TIMEOUT	2000	/* Millisecond. */
+
+#define WAKE_UP_SYNC_OBJ(obj) {			\
+		if (obj->waiting) {		\
+			obj->waiting = false;	\
+			wake_up(&obj->wq);	\
+		}				\
+	}
+
+#define DEL_OBJ_FROM_RSV(obj, rsv) {					\
+		struct dmabuf_sync_object *e, *n;			\
+									\
+		list_for_each_entry_safe(e, n, &rsv->syncs, r_head) {	\
+			if (e == obj && !e->task)			\
+				list_del_init(&e->r_head);		\
+		}							\
+}
+
+int dmabuf_sync_enabled = 1;
+
+MODULE_PARM_DESC(enabled, "Check if dmabuf sync is supported or not");
+module_param_named(enabled, dmabuf_sync_enabled, int, 0444);
+
+DEFINE_WW_CLASS(dmabuf_sync_ww_class);
+EXPORT_SYMBOL_GPL(dmabuf_sync_ww_class);
+
+static void dmabuf_sync_timeout_worker(struct work_struct *work)
+{
+	struct dmabuf_sync *sync = container_of(work, struct dmabuf_sync, work);
+	struct dmabuf_sync_object *sobj;
+
+	mutex_lock(&sync->lock);
+
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		struct dmabuf_sync_reservation *rsvp = sobj->robj;
+
+		mutex_lock(&rsvp->lock);
+
+		pr_warn("%s: timeout = 0x%p [type = %d:%d, "
+					"refcnt = %d, locked = %d]\n",
+					sync->name, sobj->dmabuf,
+					rsvp->accessed_type,
+					sobj->access_type,
+					atomic_read(&rsvp->shared_cnt),
+					rsvp->locked);
+
+		if (rsvp->polled) {
+			rsvp->poll_event = true;
+			rsvp->polled = false;
+			wake_up_interruptible(&rsvp->poll_wait);
+		}
+
+		/*
+		 * Wake up a task blocked by dmabuf_sync_wait_prev_objs().
+		 *
+		 * If sobj->waiting is true, the task is waiting for the wake
+		 * up event so wake up the task if a given time period is
+		 * elapsed and current task is timed out.
+		 */
+		WAKE_UP_SYNC_OBJ(sobj);
+
+		/* Delete a sync object from reservation object of dmabuf. */
+		DEL_OBJ_FROM_RSV(sobj, rsvp);
+
+		if (atomic_add_unless(&rsvp->shared_cnt, -1, 1)) {
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		/* unlock only valid sync object. */
+		if (!rsvp->locked) {
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		mutex_unlock(&rsvp->lock);
+		ww_mutex_unlock(&rsvp->sync_lock);
+
+		mutex_lock(&rsvp->lock);
+		rsvp->locked = false;
+
+		if (sobj->access_type & DMA_BUF_ACCESS_R)
+			pr_warn("%s: r-unlocked = 0x%p\n",
+					sync->name, sobj->dmabuf);
+		else
+			pr_warn("%s: w-unlocked = 0x%p\n",
+					sync->name, sobj->dmabuf);
+
+		mutex_unlock(&rsvp->lock);
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
+static void dmabuf_sync_wait_prev_objs(struct dmabuf_sync_object *sobj,
+					struct dmabuf_sync_reservation *rsvp,
+					struct ww_acquire_ctx *ctx)
+{
+	mutex_lock(&rsvp->lock);
+
+	/*
+	 * This function handles the write-and-then-read ordering issue.
+	 *
+	 * The ordering issue:
+	 * There is a case that a task don't take a lock to a dmabuf so
+	 * this task would be stalled even though this task requested a lock
+	 * to the dmabuf between other task unlocked and tries to lock
+	 * the dmabuf again.
+	 *
+	 * How to handle the ordering issue:
+	 * 1. Check if there is a sync object added prior to current task's one.
+	 * 2. If exists, it unlocks the dmabuf so that other task can take
+	 *	a lock to the dmabuf first.
+	 * 3. Wait for the wake up event from other task: current task will be
+	 *	waked up when other task unlocks the dmabuf.
+	 * 4. Take a lock to the dmabuf again.
+	 */
+	if (!list_empty(&rsvp->syncs)) {
+		struct dmabuf_sync_object *r_sobj, *next;
+
+		list_for_each_entry_safe(r_sobj, next, &rsvp->syncs,
+					r_head) {
+			long timeout;
+
+			/*
+			 * Find a sync object added to rsvp->syncs by other task
+			 * before current task tries to lock the dmabuf again.
+			 * If sobj == r_sobj, it means that there is no any task
+			 * that added its own sync object to rsvp->syncs so out
+			 * of this loop.
+			 */
+			if (sobj == r_sobj)
+				break;
+
+			/*
+			 * Unlock the dmabuf if there is a sync object added
+			 * to rsvp->syncs so that other task can take a lock
+			 * first.
+			 */
+			if (rsvp->locked) {
+				ww_mutex_unlock(&rsvp->sync_lock);
+				rsvp->locked = false;
+			}
+
+			r_sobj->waiting = true;
+
+			atomic_inc(&r_sobj->refcnt);
+			mutex_unlock(&rsvp->lock);
+
+			/* Wait for the wake up event from other task. */
+			timeout = wait_event_timeout(r_sobj->wq,
+					!r_sobj->waiting,
+					msecs_to_jiffies(MAX_WAIT_TIMEOUT));
+			if (!timeout) {
+				r_sobj->waiting = false;
+				pr_warn("wait event timeout: sobj = 0x%p\n",
+						r_sobj);
+
+				/*
+				 * A sync object from fcntl system call has no
+				 * timeout handler so delete ane free r_sobj
+				 * once timeout here without checking refcnt.
+				 */
+				if (r_sobj->task) {
+					list_del_init(&r_sobj->r_head);
+					kfree(r_sobj);
+				}
+			}
+
+			if (!atomic_add_unless(&r_sobj->refcnt, -1, 1))
+				kfree(r_sobj);
+
+			/*
+			 * Other task unlocked the dmabuf so take a lock again.
+			 */
+			ww_mutex_lock(&rsvp->sync_lock, ctx);
+
+			mutex_lock(&rsvp->lock);
+			rsvp->locked = true;
+		}
+	}
+
+	mutex_unlock(&rsvp->lock);
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
+		struct dmabuf_sync_reservation *rsvp = sobj->robj;
+
+		if (WARN_ON(!rsvp))
+			continue;
+
+		mutex_lock(&rsvp->lock);
+
+		/* Don't lock in case of read and read. */
+		if (rsvp->accessed_type & DMA_BUF_ACCESS_R &&
+		    sobj->access_type & DMA_BUF_ACCESS_R) {
+			atomic_inc(&rsvp->shared_cnt);
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		if (sobj == res_sobj) {
+			res_sobj = NULL;
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		/*
+		 * Add a sync object to reservation object of dmabuf
+		 * to handle the write-and-then-read ordering issue.
+		 *
+		 * For more details, see dmabuf_sync_wait_prev_objs function.
+		 */
+		list_add_tail(&sobj->r_head, &rsvp->syncs);
+		mutex_unlock(&rsvp->lock);
+
+		ret = ww_mutex_lock(&rsvp->sync_lock, ctx);
+		if (ret < 0) {
+			contended_sobj = sobj;
+
+			if (ret == -EDEADLK)
+				pr_warn("%s: deadlock = 0x%p\n",
+					sync->name, sobj->dmabuf);
+			goto err;
+		}
+
+		mutex_lock(&rsvp->lock);
+		rsvp->locked = true;
+
+		mutex_unlock(&rsvp->lock);
+
+		/*
+		 * Check if there is a sync object added to reservation object
+		 * of dmabuf before current task takes a lock to the dmabuf.
+		 * And ithen wait for the for the wake up event from other task
+		 * if exists.
+		 */
+		dmabuf_sync_wait_prev_objs(sobj, rsvp, ctx);
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
+		struct dmabuf_sync_reservation *rsvp = sobj->robj;
+
+		mutex_lock(&rsvp->lock);
+
+		/* Don't need to unlock in case of read and read. */
+		if (atomic_add_unless(&rsvp->shared_cnt, -1, 1)) {
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		/*
+		 * Delete a sync object from reservation object of dmabuf.
+		 *
+		 * The sync object was added to reservation object of dmabuf
+		 * just before ww_mutex_lock() is called.
+		 */
+		DEL_OBJ_FROM_RSV(sobj, rsvp);
+		mutex_unlock(&rsvp->lock);
+
+		ww_mutex_unlock(&rsvp->sync_lock);
+
+		mutex_lock(&rsvp->lock);
+		rsvp->locked = false;
+		mutex_unlock(&rsvp->lock);
+	}
+
+	if (res_sobj) {
+		struct dmabuf_sync_reservation *rsvp = res_sobj->robj;
+
+		mutex_lock(&rsvp->lock);
+
+		if (!atomic_add_unless(&rsvp->shared_cnt, -1, 1)) {
+			/*
+			 * Delete a sync object from reservation object
+			 * of dmabuf.
+			 */
+			DEL_OBJ_FROM_RSV(sobj, rsvp);
+			mutex_unlock(&rsvp->lock);
+
+			ww_mutex_unlock(&rsvp->sync_lock);
+
+			mutex_lock(&rsvp->lock);
+			rsvp->locked = false;
+		}
+
+		mutex_unlock(&rsvp->lock);
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
+		struct dmabuf_sync_reservation *rsvp = sobj->robj;
+
+		mutex_lock(&rsvp->lock);
+
+		if (rsvp->polled) {
+			rsvp->poll_event = true;
+			rsvp->polled = false;
+			wake_up_interruptible(&rsvp->poll_wait);
+		}
+
+		/*
+		 * Wake up a task blocked by dmabuf_sync_wait_prev_objs().
+		 *
+		 * If sobj->waiting is true, the task is waiting for wake_up
+		 * call. So wake up the task if a given time period was
+		 * elapsed so current task was timed out.
+		 */
+		WAKE_UP_SYNC_OBJ(sobj);
+
+		/* Delete a sync object from reservation object of dmabuf. */
+		DEL_OBJ_FROM_RSV(sobj, rsvp);
+
+		if (atomic_add_unless(&rsvp->shared_cnt, -1, 1)) {
+			mutex_unlock(&rsvp->lock);
+			continue;
+		}
+
+		mutex_unlock(&rsvp->lock);
+
+		ww_mutex_unlock(&rsvp->sync_lock);
+
+		mutex_lock(&rsvp->lock);
+		rsvp->locked = false;
+		mutex_unlock(&rsvp->lock);
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
+ * dmabuf_sync_is_supported - Check if dmabuf sync is supported or not.
+ */
+bool dmabuf_sync_is_supported(void)
+{
+	return dmabuf_sync_enabled == 1;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_is_supported);
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
+struct dmabuf_sync *dmabuf_sync_init(const char *name,
+					struct dmabuf_sync_priv_ops *ops,
+					void *priv)
+{
+	struct dmabuf_sync *sync;
+
+	sync = kzalloc(sizeof(*sync), GFP_KERNEL);
+	if (!sync)
+		return ERR_PTR(-ENOMEM);
+
+	strncpy(sync->name, name, DMABUF_SYNC_NAME_SIZE);
+
+	sync->ops = ops;
+	sync->priv = priv;
+	INIT_LIST_HEAD(&sync->syncs);
+	mutex_init(&sync->lock);
+	INIT_WORK(&sync->work, dmabuf_sync_timeout_worker);
+
+	return sync;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_init);
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
+	struct dmabuf_sync_object *sobj;
+
+	if (WARN_ON(!sync))
+		return;
+
+	if (list_empty(&sync->syncs))
+		goto free_sync;
+
+	list_for_each_entry(sobj, &sync->syncs, head) {
+		struct dmabuf_sync_reservation *rsvp = sobj->robj;
+
+		mutex_lock(&rsvp->lock);
+
+		if (rsvp->locked) {
+			mutex_unlock(&rsvp->lock);
+			ww_mutex_unlock(&rsvp->sync_lock);
+
+			mutex_lock(&rsvp->lock);
+			rsvp->locked = false;
+		}
+
+		mutex_unlock(&rsvp->lock);
+	}
+
+	/*
+	 * If !list_empty(&sync->syncs) then it means that dmabuf_sync_put()
+	 * or dmabuf_sync_put_all() was never called. So unreference all
+	 * dmabuf objects added to sync->syncs, and remove them from the syncs.
+	 */
+	dmabuf_sync_put_all(sync);
+
+free_sync:
+	if (sync->ops && sync->ops->free)
+		sync->ops->free(sync->priv);
+
+	kfree(sync);
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_fini);
+
+/*
+ * dmabuf_sync_get_obj - Add a given object to sync's list.
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
+	if (!dmabuf->sync)
+		return -EFAULT;
+
+	if (!IS_VALID_DMA_BUF_ACCESS_TYPE(type))
+		return -EINVAL;
+
+	if ((type & DMA_BUF_ACCESS_RW) == DMA_BUF_ACCESS_RW)
+		type &= ~DMA_BUF_ACCESS_R;
+
+	sobj = kzalloc(sizeof(*sobj), GFP_KERNEL);
+	if (!sobj)
+		return -ENOMEM;
+
+	get_dma_buf(dmabuf);
+
+	sobj->dmabuf = dmabuf;
+	sobj->robj = dmabuf->sync;
+	sobj->access_type = type;
+	atomic_set(&sobj->refcnt, 1);
+	init_waitqueue_head(&sobj->wq);
+
+	mutex_lock(&sync->lock);
+	list_add_tail(&sobj->head, &sync->syncs);
+	mutex_unlock(&sync->lock);
+
+	return 0;
+}
+
+/*
+ * dmabuf_sync_put_obj - Release a given sync object.
+ *
+ * @sync: An object to dmabuf_sync structure.
+ *
+ * This function should be called if some operation failed after
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
+
+		if (!atomic_add_unless(&sobj->refcnt, -1, 1))
+			kfree(sobj);
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
+ * This function should be called if some operation failed after
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
+
+		if (!atomic_add_unless(&sobj->refcnt, -1, 1))
+			kfree(sobj);
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
+	if (!sync)
+		return -EFAULT;
+
+	if (list_empty(&sync->syncs))
+		return -EINVAL;
+
+	if (sync->status != DMABUF_SYNC_GOT)
+		return -EINVAL;
+
+	ret = dmabuf_sync_lock_objs(sync, &sync->ctx);
+	if (ret < 0)
+		return ret;
+
+	sync->status = DMABUF_SYNC_LOCKED;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_lock);
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
+	if (!sync)
+		return -EFAULT;
+
+	/* If current dmabuf sync object wasn't reserved then just return. */
+	if (sync->status != DMABUF_SYNC_LOCKED)
+		return -EAGAIN;
+
+	dmabuf_sync_unlock_objs(sync, &sync->ctx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_unlock);
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
+	struct dmabuf_sync_object *sobj;
+
+	if (!dmabuf->sync)
+		return -EFAULT;
+
+	if (!IS_VALID_DMA_BUF_ACCESS_TYPE(type))
+		return -EINVAL;
+
+	get_dma_buf(dmabuf);
+	robj = dmabuf->sync;
+
+	sobj = kzalloc(sizeof(*sobj), GFP_KERNEL);
+	if (!sobj) {
+		dma_buf_put(dmabuf);
+		return -ENOMEM;
+	}
+
+	sobj->dmabuf = dmabuf;
+	sobj->task = (unsigned long)current;
+	atomic_set(&sobj->refcnt, 1);
+	init_waitqueue_head(&sobj->wq);
+
+	mutex_lock(&robj->lock);
+
+	/* Don't lock in case of read and read. */
+	if (robj->accessed_type & DMA_BUF_ACCESS_R && type & DMA_BUF_ACCESS_R) {
+		atomic_inc(&robj->shared_cnt);
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
+	/*
+	 * Add a sync object to reservation object of dmabuf to handle
+	 * the write-and-then-read ordering issue.
+	 */
+	list_add_tail(&sobj->r_head, &robj->syncs);
+	mutex_unlock(&robj->lock);
+
+	/* Unlocked by dmabuf_sync_single_unlock or dmabuf_sync_unlock. */
+	mutex_lock(&robj->sync_lock.base);
+
+	mutex_lock(&robj->lock);
+	robj->locked = true;
+	mutex_unlock(&robj->lock);
+
+	/*
+	 * Check if there is a sync object added to reservation object of
+	 * dmabuf before current task takes a lock to the dmabuf, and wait
+	 * for the for the wake up event from other task if exists.
+	 */
+	dmabuf_sync_wait_prev_objs(sobj, robj, NULL);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_single_lock);
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
+	struct dmabuf_sync_object *sobj, *next;
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
+	if (robj->polled) {
+		robj->poll_event = true;
+		robj->polled = false;
+		wake_up_interruptible(&robj->poll_wait);
+	}
+
+	/*
+	 * Wake up a blocked task/tasks by dmabuf_sync_wait_prev_objs()
+	 * with two steps.
+	 *
+	 * 1. Wake up a task waiting for the wake up event to a sync object
+	 *	of same task, and remove the sync object from reservation
+	 *	object of dmabuf, and then go to out: requested by same task.
+	 * 2. Wait up a task waiting for the wake up event to a sync object
+	 *	of other task, and remove the sync object if not existed
+	 *	at step 1: requested by other task.
+	 *
+	 * The reason, we have to handle it with the above two steps,
+	 * is that fcntl system call is called with a file descriptor so
+	 * kernel side cannot be aware of which sync object of robj->syncs
+	 * should be waked up and deleted at this function.
+	 * So for this, we use the above two steps to find a sync object
+	 * to be waked up.
+	 */
+	list_for_each_entry_safe(sobj, next, &robj->syncs, r_head) {
+		if (sobj->task == (unsigned long)current) {
+			/*
+			 * Wake up a task blocked by
+			 * dmabuf_sync_wait_prev_objs().
+			 */
+			WAKE_UP_SYNC_OBJ(sobj);
+
+			list_del_init(&sobj->r_head);
+
+			if (!atomic_add_unless(&sobj->refcnt, -1, 1))
+				kfree(sobj);
+			goto out;
+		}
+	}
+
+	list_for_each_entry_safe(sobj, next, &robj->syncs, r_head) {
+		if (sobj->task) {
+			/*
+			 * Wake up a task blocked by
+			 * dmabuf_sync_wait_prev_objs().
+			 */
+			WAKE_UP_SYNC_OBJ(sobj);
+
+			list_del_init(&sobj->r_head);
+
+			if (!atomic_add_unless(&sobj->refcnt, -1, 1))
+				kfree(sobj);
+			break;
+		}
+	}
+
+out:
+	if (atomic_add_unless(&robj->shared_cnt, -1 , 1)) {
+		mutex_unlock(&robj->lock);
+		dma_buf_put(dmabuf);
+		return;
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
+EXPORT_SYMBOL_GPL(dmabuf_sync_single_unlock);
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
+	if (!sync || !sync_buf)
+		return -EFAULT;
+
+	ret = dmabuf_sync_get_obj(sync, sync_buf, type);
+	if (ret < 0)
+		return ret;
+
+	sync->status = DMABUF_SYNC_GOT;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabuf_sync_get);
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
+EXPORT_SYMBOL_GPL(dmabuf_sync_put);
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
+EXPORT_SYMBOL_GPL(dmabuf_sync_put_all);
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
index 0000000..fc0bb4e
--- /dev/null
+++ b/include/linux/dmabuf-sync.h
@@ -0,0 +1,257 @@
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
+#include <linux/ww_mutex.h>
+#include <linux/sched.h>
+#include <linux/dma-buf.h>
+
+#define DMABUF_SYNC_NAME_SIZE	64
+
+/*
+ * Status to a dmabuf_sync object.
+ *
+ * @DMABUF_SYNC_GOT: Indicate that one more dmabuf objects have been added
+ *			to a sync's list.
+ * @DMABUF_SYNC_LOCKED: Indicate that all dmabuf objects in a sync's list
+ *			have been locked.
+ */
+enum dmabuf_sync_status {
+	DMABUF_SYNC_GOT		= 1,
+	DMABUF_SYNC_LOCKED,
+};
+
+/*
+ * A structure for dmabuf_sync_reservation.
+ *
+ * @syncs: A list head to sync object and this is global to system.
+ *	This contains sync objects of tasks that requested a lock
+ *	to this dmabuf.
+ * @sync_lock: This provides read or write lock to a dmabuf.
+ *	Except in the below cases, a task will be blocked if the task
+ *	tries to lock a dmabuf for CPU or DMA access when other task
+ *	already locked the dmabuf.
+ *
+ *	Before		After
+ *	--------------------------
+ *	CPU read	CPU read
+ *	CPU read	DMA read
+ *	DMA read	CPU read
+ *	DMA read	DMA read
+ *
+ * @lock: Protecting a dmabuf_sync_reservation object.
+ * @poll_wait: A wait queue object to poll a dmabuf object.
+ * @poll_event: Indicate whether a dmabuf object - being polled -
+ *	was unlocked or not. If true, a blocked task will be out
+ *	of select system call.
+ * @poll: Indicate whether the polling to a dmabuf object was requested
+ *	or not by userspace.
+ * @shared_cnt: Shared count to a dmabuf object.
+ * @accessed_type: Indicate how and who a dmabuf object was accessed by.
+ *	One of the below types could be set.
+ *	DMA_BUF_ACCESS_R -> CPU access for read.
+ *	DMA_BUF_ACCRSS_W -> CPU access for write.
+ *	DMA_BUF_ACCESS_R | DMA_BUF_ACCESS_DMA -> DMA access for read.
+ *	DMA_BUF_ACCESS_W | DMA_BUF_ACCESS_DMA -> DMA access for write.
+ * @locked: Indicate whether a dmabuf object has been locked or not.
+ *
+ */
+struct dmabuf_sync_reservation {
+	struct list_head	syncs;
+	struct ww_mutex		sync_lock;
+	struct mutex		lock;
+	wait_queue_head_t	poll_wait;
+	unsigned int		poll_event;
+	unsigned int		polled;
+	atomic_t		shared_cnt;
+	unsigned int		accessed_type;
+	unsigned int		locked;
+};
+
+/*
+ * A structure for dmabuf_sync_object.
+ *
+ * @head: A list head to be added to dmabuf_sync's syncs.
+ * @r_head: A list head to be added to dmabuf_sync_reservation's syncs.
+ * @robj: A reservation_object object.
+ * @dma_buf: A dma_buf object.
+ * @task: An address value to current task.
+ *	This is used to indicate who is a owner of a sync object.
+ * @wq: A wait queue head.
+ *	This is used to guarantee that a task can take a lock to a dmabuf
+ *	if the task requested a lock to the dmabuf prior to other task.
+ *	For more details, see dmabuf_sync_wait_prev_objs function.
+ * @refcnt: A reference count to a sync object.
+ * @access_type: Indicate how a current task tries to access
+ *	a given buffer, and one of the below types could be set.
+ *	DMA_BUF_ACCESS_R -> CPU access for read.
+ *	DMA_BUF_ACCRSS_W -> CPU access for write.
+ *	DMA_BUF_ACCESS_R | DMA_BUF_ACCESS_DMA -> DMA access for read.
+ *	DMA_BUF_ACCESS_W | DMA_BUF_ACCESS_DMA -> DMA access for write.
+ * @waiting: Indicate whether current task is waiting for the wake up event
+ *	from other task or not.
+ */
+struct dmabuf_sync_object {
+	struct list_head		head;
+	struct list_head		r_head;
+	struct dmabuf_sync_reservation	*robj;
+	struct dma_buf			*dmabuf;
+	unsigned long			task;
+	wait_queue_head_t		wq;
+	atomic_t			refcnt;
+	unsigned int			access_type;
+	unsigned int			waiting;
+};
+
+struct dmabuf_sync_priv_ops {
+	void (*free)(void *priv);
+};
+
+/*
+ * A structure for dmabuf_sync.
+ *
+ * @syncs: A list head to sync object and this is global to system.
+ *	This contains sync objects of dmabuf_sync owner.
+ * @list: A list entry used as committed list node
+ * @lock: Protecting a dmabuf_sync object.
+ * @ctx: A current context for ww mutex.
+ * @work: A work struct to release resources at timeout.
+ * @priv: A private data.
+ * @name: A string to dmabuf sync owner.
+ * @timer: A timer list to avoid lockup and release resources.
+ * @status: Indicate current status (DMABUF_SYNC_GOT or DMABUF_SYNC_LOCKED).
+ */
+struct dmabuf_sync {
+	struct list_head		syncs;
+	struct list_head		list;
+	struct mutex			lock;
+	struct ww_acquire_ctx		ctx;
+	struct work_struct		work;
+	void				*priv;
+	struct dmabuf_sync_priv_ops	*ops;
+	char				name[DMABUF_SYNC_NAME_SIZE];
+	struct timer_list		timer;
+	unsigned int			status;
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
+	INIT_LIST_HEAD(&obj->syncs);
+
+	init_waitqueue_head(&obj->poll_wait);
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
+bool dmabuf_sync_is_supported(void);
+
+struct dmabuf_sync *dmabuf_sync_init(const char *name,
+					struct dmabuf_sync_priv_ops *ops,
+					void *priv);
+
+void dmabuf_sync_fini(struct dmabuf_sync *sync);
+
+int dmabuf_sync_lock(struct dmabuf_sync *sync);
+
+int dmabuf_sync_unlock(struct dmabuf_sync *sync);
+
+int dmabuf_sync_single_lock(struct dma_buf *dmabuf, unsigned int type,
+				bool wait);
+
+void dmabuf_sync_single_unlock(struct dma_buf *dmabuf);
+
+int dmabuf_sync_get(struct dmabuf_sync *sync, void *sync_buf,
+				unsigned int type);
+
+void dmabuf_sync_put(struct dmabuf_sync *sync, struct dma_buf *dmabuf);
+
+void dmabuf_sync_put_all(struct dmabuf_sync *sync);
+
+#else
+
+static inline void dmabuf_sync_reservation_init(struct dma_buf *dmabuf) { }
+
+static inline void dmabuf_sync_reservation_fini(struct dma_buf *dmabuf) { }
+
+static inline bool dmabuf_sync_is_supported(void) { return false; }
+
+static inline  struct dmabuf_sync *dmabuf_sync_init(const char *name,
+					struct dmabuf_sync_priv_ops *ops,
+					void *priv)
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

