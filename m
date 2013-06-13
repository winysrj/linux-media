Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42692 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMR1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 13:27:11 -0400
Date: Thu, 13 Jun 2013 18:26:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Inki Dae <inki.dae@samsung.com>
Cc: maarten.lankhorst@canonical.com, daniel@ffwll.ch,
	robdclark@gmail.com, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
	myungjoo.ham@samsung.com, yj44.cho@samsung.com,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] dmabuf-sync: Introduce buffer synchronization
	framework
Message-ID: <20130613172611.GJ18614@n2100.arm.linux.org.uk>
References: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371112088-15310-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 13, 2013 at 05:28:08PM +0900, Inki Dae wrote:
> This patch adds a buffer synchronization framework based on DMA BUF[1]
> and reservation[2] to use dma-buf resource, and based on ww-mutexes[3]
> for lock mechanism.
> 
> The purpose of this framework is not only to couple cache operations,
> and buffer access control to CPU and DMA but also to provide easy-to-use
> interfaces for device drivers and potentially user application
> (not implemented for user applications, yet). And this framework can be
> used for all dma devices using system memory as dma buffer, especially
> for most ARM based SoCs.
> 
> The mechanism of this framework has the following steps,
>     1. Register dmabufs to a sync object - A task gets a new sync object and
>     can add one or more dmabufs that the task wants to access.
>     This registering should be performed when a device context or an event
>     context such as a page flip event is created or before CPU accesses a shared
>     buffer.
> 
> 	dma_buf_sync_get(a sync object, a dmabuf);
> 
>     2. Lock a sync object - A task tries to lock all dmabufs added in its own
>     sync object. Basically, the lock mechanism uses ww-mutex[1] to avoid dead
>     lock issue and for race condition between CPU and CPU, CPU and DMA, and DMA
>     and DMA. Taking a lock means that others cannot access all locked dmabufs
>     until the task that locked the corresponding dmabufs, unlocks all the locked
>     dmabufs.
>     This locking should be performed before DMA or CPU accesses these dmabufs.
> 
> 	dma_buf_sync_lock(a sync object);
> 
>     3. Unlock a sync object - The task unlocks all dmabufs added in its own sync
>     object. The unlock means that the DMA or CPU accesses to the dmabufs have
>     been completed so that others may access them.
>     This unlocking should be performed after DMA or CPU has completed accesses
>     to the dmabufs.
> 
> 	dma_buf_sync_unlock(a sync object);
> 
>     4. Unregister one or all dmabufs from a sync object - A task unregisters
>     the given dmabufs from the sync object. This means that the task dosen't
>     want to lock the dmabufs.
>     The unregistering should be performed after DMA or CPU has completed
>     accesses to the dmabufs or when dma_buf_sync_lock() is failed.
> 
> 	dma_buf_sync_put(a sync object, a dmabuf);
> 	dma_buf_sync_put_all(a sync object);
> 
>     The described steps may be summarized as:
> 	get -> lock -> CPU or DMA access to a buffer/s -> unlock -> put
> 
> This framework includes the following two features.
>     1. read (shared) and write (exclusive) locks - A task is required to declare
>     the access type when the task tries to register a dmabuf;
>     READ, WRITE, READ DMA, or WRITE DMA.
> 
>     The below is example codes,
> 	struct dmabuf_sync *sync;
> 
> 	sync = dmabuf_sync_init(NULL, "test sync");
> 
> 	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
> 	...
> 
> 	And the below can be used as access types:
> 		DMA_BUF_ACCESS_READ,
> 		- CPU will access a buffer for read.
> 		DMA_BUF_ACCESS_WRITE,
> 		- CPU will access a buffer for read or write.
> 		DMA_BUF_ACCESS_READ | DMA_BUF_ACCESS_DMA,
> 		- DMA will access a buffer for read
> 		DMA_BUF_ACCESS_WRITE | DMA_BUF_ACCESS_DMA,
> 		- DMA will access a buffer for read or write.
> 
>     2. Mandatory resource releasing - a task cannot hold a lock indefinitely.
>     A task may never try to unlock a buffer after taking a lock to the buffer.
>     In this case, a timer handler to the corresponding sync object is called
>     in five (default) seconds and then the timed-out buffer is unlocked by work
>     queue handler to avoid lockups and to enforce resources of the buffer.
> 
> The below is how to use:
> 	1. Allocate and Initialize a sync object:
> 		struct dmabuf_sync *sync;
> 
> 		sync = dmabuf_sync_init(NULL, "test sync");
> 		...
> 
> 	2. Add a dmabuf to the sync object when setting up dma buffer relevant
> 	   registers:
> 		dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
> 		...
> 
> 	3. Lock all dmabufs of the sync object before DMA or CPU accesses
> 	   the dmabufs:
> 		dmabuf_sync_lock(sync);
> 		...
> 
> 	4. Now CPU or DMA can access all dmabufs locked in step 3.
> 
> 	5. Unlock all dmabufs added in a sync object after DMA or CPU access
> 	   to these dmabufs is completed:
> 		dmabuf_sync_unlock(sync);
> 
> 	   And call the following functions to release all resources,
> 		dmabuf_sync_put_all(sync);
> 		dmabuf_sync_fini(sync);
> 
> 	You can refer to actual example codes:
> 		https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/
> 		commit/?h=dmabuf-sync&id=4030bdee9bab5841ad32faade528d04cc0c5fc94
> 
> 		https://git.kernel.org/cgit/linux/kernel/git/daeinki/drm-exynos.git/
> 		commit/?h=dmabuf-sync&id=6ca548e9ea9e865592719ef6b1cde58366af9f5c
> 
> The framework performs cache operation based on the previous and current access
> types to the dmabufs after the locks to all dmabufs are taken:
> 	Call dma_buf_begin_cpu_access() to invalidate cache if,
> 		previous access type is DMA_BUF_ACCESS_WRITE | DMA and
> 		current access type is DMA_BUF_ACCESS_READ
> 
> 	Call dma_buf_end_cpu_access() to clean cache if,
> 		previous access type is DMA_BUF_ACCESS_WRITE and
> 		current access type is DMA_BUF_ACCESS_READ | DMA
> 
> Such cache operations are invoked via dma-buf interfaces so the dma buf exporter
> should implement dmabuf->ops->begin_cpu_access/end_cpu_access callbacks.
> 
> [1] http://lwn.net/Articles/470339/
> [2] http://lwn.net/Articles/532616/
> [3] https://patchwork-mail1.kernel.org/patch/2625321/
> 
> Signed-off-by: Inki Dae <inki.dae@samsung.com>
> ---
>  Documentation/dma-buf-sync.txt |  246 ++++++++++++++++++
>  drivers/base/Kconfig           |    7 +
>  drivers/base/Makefile          |    1 +
>  drivers/base/dmabuf-sync.c     |  555 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/dma-buf.h        |    5 +
>  include/linux/dmabuf-sync.h    |  115 +++++++++
>  include/linux/reservation.h    |    7 +
>  7 files changed, 936 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/dma-buf-sync.txt
>  create mode 100644 drivers/base/dmabuf-sync.c
>  create mode 100644 include/linux/dmabuf-sync.h
> 
> diff --git a/Documentation/dma-buf-sync.txt b/Documentation/dma-buf-sync.txt
> new file mode 100644
> index 0000000..e71b6f4
> --- /dev/null
> +++ b/Documentation/dma-buf-sync.txt
> @@ -0,0 +1,246 @@
> +                    DMA Buffer Synchronization Framework
> +                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +                                  Inki Dae
> +                      <inki dot dae at samsung dot com>
> +                          <daeinki at gmail dot com>
> +
> +This document is a guide for device-driver writers describing the DMA buffer
> +synchronization API. This document also describes how to use the API to
> +use buffer synchronization between CPU and CPU, CPU and DMA, and DMA and DMA.
> +
> +The DMA Buffer synchronization API provides buffer synchronization mechanism;
> +i.e., buffer access control to CPU and DMA, cache operations, and easy-to-use
> +interfaces for device drivers and potentially user application
> +(not implemented for user applications, yet). And this API can be used for all
> +dma devices using system memory as dma buffer, especially for most ARM based
> +SoCs.
> +
> +
> +Motivation
> +----------
> +
> +Sharing a buffer, a device cannot be aware of when the other device will access
> +the shared buffer: a device may access a buffer containing wrong data if
> +the device accesses the shared buffer while another device is still accessing
> +the shared buffer. Therefore, a user process should have waited for
> +the completion of DMA access by another device before a device tries to access
> +the shared buffer.
> +
> +Besides, there is the same issue when CPU and DMA are sharing a buffer; i.e.,
> +a user process should consider that when the user process have to send a buffer
> +to a device driver for the device driver to access the buffer as input.
> +This means that a user process needs to understand how the device driver is
> +worked. Hence, the conventional mechanism not only makes user application
> +complicated but also incurs performance overhead because the conventional
> +mechanism cannot control devices precisely without additional and complex
> +implemantations.
> +
> +In addition, in case of ARM based SoCs, most devices have no hardware cache
> +consistency mechanisms between CPU and DMA devices because they do not use ACP
> +(Accelerator Coherency Port). ACP can be connected to DMA engine or similar
> +devices in order to keep cache coherency between CPU cache and DMA device.
> +Thus, we need additional cache operations to have the devices operate properly;
> +i.e., user applications should request cache operations to kernel before DMA
> +accesses the buffer and after the completion of buffer access by CPU, or vise
> +versa.
> +
> +	buffer access by CPU -> cache clean -> buffer access by DMA
> +
> +Or,
> +	buffer access by DMA -> cache invalidate -> buffer access by CPU
> +
> +The below shows why cache operations should be requested by user
> +process,
> +    (Presume that CPU and DMA share a buffer and the buffer is mapped
> +     with user space as cachable)
> +
> +	handle = drm_gem_alloc(size);
> +	...
> +	va1 = drm_gem_mmap(handle1);
> +	va2 = malloc(size);
> +	...
> +
> +	while(conditions) {
> +		memcpy(va1, some data, size);
> +		...
> +		drm_xxx_set_dma_buffer(handle, ...);
> +		...
> +
> +		/* user need to request cache clean at here. */
> +
> +		/* blocked until dma operation is completed. */
> +		drm_xxx_start_dma(...);
> +		...
> +
> +		/* user need to request cache invalidate at here. */
> +
> +		memcpy(va2, va1, size);
> +	}
> +
> +The issue arises: user processes may incur cache operations: user processes may
> +request unnecessary cache operations to kernel. Besides, kernel cannot prevent
> +user processes from requesting such cache operations. Therefore, we need to
> +prevent such excessive and unnecessary cache operations from user processes.
> +
> +
> +Basic concept
> +-------------
> +
> +The mechanism of this framework has the following steps,
> +    1. Register dmabufs to a sync object - A task gets a new sync object and
> +    can add one or more dmabufs that the task wants to access.
> +    This registering should be performed when a device context or an event
> +    context such as a page flip event is created or before CPU accesses a shared
> +    buffer.
> +
> +	dma_buf_sync_get(a sync object, a dmabuf);
> +
> +    2. Lock a sync object - A task tries to lock all dmabufs added in its own
> +    sync object. Basically, the lock mechanism uses ww-mutex[1] to avoid dead
> +    lock issue and for race condition between CPU and CPU, CPU and DMA, and DMA
> +    and DMA. Taking a lock means that others cannot access all locked dmabufs
> +    until the task that locked the corresponding dmabufs, unlocks all the locked
> +    dmabufs.
> +    This locking should be performed before DMA or CPU accesses these dmabufs.
> +
> +	dma_buf_sync_lock(a sync object);
> +
> +    3. Unlock a sync object - The task unlocks all dmabufs added in its own sync
> +    object. The unlock means that the DMA or CPU accesses to the dmabufs have
> +    been completed so that others may access them.
> +    This unlocking should be performed after DMA or CPU has completed accesses
> +    to the dmabufs.
> +
> +	dma_buf_sync_unlock(a sync object);
> +
> +    4. Unregister one or all dmabufs from a sync object - A task unregisters
> +    the given dmabufs from the sync object. This means that the task dosen't
> +    want to lock the dmabufs.
> +    The unregistering should be performed after DMA or CPU has completed
> +    accesses to the dmabufs or when dma_buf_sync_lock() is failed.
> +
> +	dma_buf_sync_put(a sync object, a dmabuf);
> +	dma_buf_sync_put_all(a sync object);
> +
> +    The described steps may be summarized as:
> +	get -> lock -> CPU or DMA access to a buffer/s -> unlock -> put
> +
> +This framework includes the following two features.
> +    1. read (shared) and write (exclusive) locks - A task is required to declare
> +    the access type when the task tries to register a dmabuf;
> +    READ, WRITE, READ DMA, or WRITE DMA.
> +
> +    The below is example codes,
> +	struct dmabuf_sync *sync;
> +
> +	sync = dmabuf_sync_init(NULL, "test sync");
> +
> +	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
> +	...
> +
> +    2. Mandatory resource releasing - a task cannot hold a lock indefinitely.
> +    A task may never try to unlock a buffer after taking a lock to the buffer.
> +    In this case, a timer handler to the corresponding sync object is called
> +    in five (default) seconds and then the timed-out buffer is unlocked by work
> +    queue handler to avoid lockups and to enforce resources of the buffer.
> +
> +
> +Access types
> +------------
> +
> +DMA_BUF_ACCESS_READ - CPU will access a buffer for read.
> +DMA_BUF_ACCESS_WRITE - CPU will access a buffer for read or write.
> +DMA_BUF_ACCESS_READ | DMA_BUF_ACCESS_DMA - DMA will access a buffer for read
> +DMA_BUF_ACCESS_WRITE | DMA_BUF_ACCESS_DMA - DMA will access a buffer for read
> +					    or write.
> +
> +
> +API set
> +-------
> +
> +bool is_dmabuf_sync_supported(void)
> +	- Check if dmabuf sync is supported or not.
> +
> +struct dmabuf_sync *dmabuf_sync_init(void *priv, const char *name)
> +	- Allocate and initialize a new sync object. The caller can get a new
> +	sync object for buffer synchronization. priv is used to set caller's
> +	private data and name is the name of sync object.
> +
> +void dmabuf_sync_fini(struct dmabuf_sync *sync)
> +	- Release all resources to the sync object.
> +
> +int dmabuf_sync_get(struct dmabuf_sync *sync, void *sync_buf,
> +			unsigned int type)
> +	- Add a dmabuf to a sync object. The caller can group multiple dmabufs
> +	by calling this function several times. Internally, this function also
> +	takes a reference to a dmabuf.
> +
> +void dmabuf_sync_put(struct dmabuf_sync *sync, struct dma_buf *dmabuf)
> +	- Remove a given dmabuf from a sync object. Internally, this function
> +	also release every reference to the given dmabuf.
> +
> +void dmabuf_sync_put_all(struct dmabuf_sync *sync)
> +	- Remove all dmabufs added in a sync object. Internally, this function
> +	also release every reference to the dmabufs of the sync object.
> +
> +int dmabuf_sync_lock(struct dmabuf_sync *sync)
> +	- Lock all dmabufs added in a sync object. The caller should call this
> +	function prior to CPU or DMA access to the dmabufs so that others can
> +	not access the dmabufs. Internally, this function avoids dead lock
> +	issue with ww-mutex.
> +
> +int dmabuf_sync_unlock(struct dmabuf_sync *sync)
> +	- Unlock all dmabufs added in a sync object. The caller should call
> +	this function after CPU or DMA access to the dmabufs is completed so
> +	that others can access the dmabufs.
> +
> +
> +Tutorial
> +--------
> +
> +1. Allocate and Initialize a sync object:
> +	struct dmabuf_sync *sync;
> +
> +	sync = dmabuf_sync_init(NULL, "test sync");
> +	...
> +
> +2. Add a dmabuf to the sync object when setting up dma buffer relevant registers:
> +	dmabuf_sync_get(sync, dmabuf, DMA_BUF_ACCESS_READ);
> +	...
> +
> +3. Lock all dmabufs of the sync object before DMA or CPU accesses the dmabufs:
> +	dmabuf_sync_lock(sync);
> +	...
> +
> +4. Now CPU or DMA can access all dmabufs locked in step 3.
> +
> +5. Unlock all dmabufs added in a sync object after DMA or CPU access to these
> +   dmabufs is completed:
> +	dmabuf_sync_unlock(sync);
> +
> +   And call the following functions to release all resources,
> +	dmabuf_sync_put_all(sync);
> +	dmabuf_sync_fini(sync);
> +
> +
> +Cache operation
> +---------------
> +
> +The framework performs cache operation based on the previous and current access
> +types to the dmabufs after the locks to all dmabufs are taken:
> +	Call dma_buf_begin_cpu_access() to invalidate cache if,
> +		previous access type is DMA_BUF_ACCESS_WRITE | DMA and
> +		current access type is DMA_BUF_ACCESS_READ
> +
> +	Call dma_buf_end_cpu_access() to clean cache if,
> +		previous access type is DMA_BUF_ACCESS_WRITE and
> +		current access type is DMA_BUF_ACCESS_READ | DMA
> +
> +Such cache operations are invoked via dma-buf interfaces. Thus, the dma buf
> +exporter should implement dmabuf->ops->begin_cpu_access and end_cpu_access
> +callbacks.
> +
> +
> +References:
> +[1] https://patchwork-mail1.kernel.org/patch/2625321/
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 5ccf182..54a1d5a 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -212,6 +212,13 @@ config FENCE_TRACE
>  	  lockup related problems for dma-buffers shared across multiple
>  	  devices.
>  
> +config DMABUF_SYNC
> +	bool "DMABUF Synchronization Framework"
> +	depends on DMA_SHARED_BUFFER
> +	help
> +	  This option enables dmabuf sync framework for buffer synchronization between
> +	  DMA and DMA, CPU and DMA, and CPU and CPU.
> +
>  config CMA
>  	bool "Contiguous Memory Allocator"
>  	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 8a55cb9..599f6c90 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -11,6 +11,7 @@ obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
>  obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
>  obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o reservation.o
> +obj-$(CONFIG_DMABUF_SYNC) += dmabuf-sync.o
>  obj-$(CONFIG_ISA)	+= isa.o
>  obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
>  obj-$(CONFIG_NUMA)	+= node.o
> diff --git a/drivers/base/dmabuf-sync.c b/drivers/base/dmabuf-sync.c
> new file mode 100644
> index 0000000..c8723a5
> --- /dev/null
> +++ b/drivers/base/dmabuf-sync.c
> @@ -0,0 +1,555 @@
> +/*
> + * Copyright (C) 2013 Samsung Electronics Co.Ltd
> + * Authors:
> + *	Inki Dae <inki.dae@samsung.com>
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/debugfs.h>
> +#include <linux/uaccess.h>
> +
> +#include <linux/dmabuf-sync.h>
> +
> +#define MAX_SYNC_TIMEOUT	5 /* Second. */
> +
> +#define NEED_BEGIN_CPU_ACCESS(old, new)	\
> +		(old->accessed_type == (DMA_BUF_ACCESS_WRITE | \
> +					DMA_BUF_ACCESS_DMA) && \
> +		 (new->access_type == DMA_BUF_ACCESS_READ))
> +
> +#define NEED_END_CPU_ACCESS(old, new)	\
> +		(old->accessed_type == DMA_BUF_ACCESS_WRITE && \
> +		 ((new->access_type == (DMA_BUF_ACCESS_READ | \
> +					DMA_BUF_ACCESS_DMA)) || \
> +		  (new->access_type == (DMA_BUF_ACCESS_WRITE | \
> +					DMA_BUF_ACCESS_DMA))))
> +
> +int dmabuf_sync_enabled = 1;
> +
> +MODULE_PARM_DESC(enabled, "Check if dmabuf sync is supported or not");
> +module_param_named(enabled, dmabuf_sync_enabled, int, 0444);
> +
> +static void dmabuf_sync_timeout_worker(struct work_struct *work)
> +{
> +	struct dmabuf_sync *sync = container_of(work, struct dmabuf_sync, work);
> +	struct dmabuf_sync_object *sobj;
> +
> +	mutex_lock(&sync->lock);
> +
> +	list_for_each_entry(sobj, &sync->syncs, head) {
> +		if (WARN_ON(!sobj->robj))
> +			continue;
> +
> +		printk(KERN_WARNING "%s: timeout = 0x%x [type = %d, " \
> +					"refcnt = %d, locked = %d]\n",
> +					sync->name, (u32)sobj->dmabuf,
> +					sobj->access_type,
> +					atomic_read(&sobj->robj->shared_cnt),
> +					sobj->robj->locked);
> +
> +		/* unlock only valid sync object. */
> +		if (!sobj->robj->locked)
> +			continue;
> +
> +		if (sobj->robj->shared &&
> +				atomic_read(&sobj->robj->shared_cnt) > 1) {
> +			atomic_dec(&sobj->robj->shared_cnt);

So, in my long standing complaints about atomic_t, this one really takes
the biscuit.  What makes you think that this is somehow safe?

What happens if:

shared_cnt = 2
	CPU0				CPU1
	atomic_read(&shared_cnt)
					atomic_read(&shared_cnt)
	atomic_dec(&shared_cnt)
					atomic_dec(&shared_cnt)

Now, it's zero.  That's not what the above code intends.  You probably
think that because it's called "atomic_*" it has some magical properties
which saves you from stuff like this.  I'm afraid it doesn't.

sync->lock may save you from that, but if that's the case, why use
atomic_t's anyway here because you're already in a protected region.
But maybe not, because I see other uses of shared_cnt without this
lock below.

I think you need to revisit this and think more carefully about how
to deal with this counting.  If you wish to continue using the
atomic_* API, please take time to get familiar with it, and most
importantly realise that virtually any sequence of:

	if some-condition-based-on atomic_read(&something)
		do something with atomic_*(&something)

is a bug.  Maybe take a look at atomic_add_unless() which can be used
with negative values to decrement.
