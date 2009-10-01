Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44327 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255AbZJAKu6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 06:50:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KQU00CHL0CBGB40@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Oct 2009 11:40:59 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KQU00F170CA0K@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Oct 2009 11:40:59 +0100 (BST)
Date: Thu, 01 Oct 2009 12:39:29 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Global Video Buffers Pool - PMM and UPBuffer reference drivers [RFC]
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Cc: "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	Tomasz Fujak <t.fujak@samsung.com>
Message-id: <E4D3F24EA6C9E54F817833EAE0D912AC077151C44B@bssrvexch01.BS.local>
Content-language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

During the discussion of Global Video Buffers Pool RFC
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/10204
on Linux Plumbers 2009 Conference in Portland we (Marek Szyprowski
and Tomasz Fujak from Samsung Poland R&D Center) declared to present the
source code of our solution. We hope that some ideas behind it or the
code can be used as a reference for the upcoming V4L2 global video
buffers pool approach. Please keep in mind, that our current solution is
not based on V4L2 framework, thus some code adaptation would definitely
be needed. The included patch creates file in drivers/s3cmm (S3C
multimedia) and include/linux/s3c directories (please keep in mind that
these paths are temporary).


Background
----------

Our solution is designed for S3C6410 SOC which is a UMA system based on
ARM core. The SOC includes the following multimedia integrated
peripherals: frame buffer, 2D graphics accelerator (rotator, blitter and
post processor which is capable of color space conversion), JPEG and
multi-format video codec, 3D graphics accelerator and a camera
interface. The common feature of all these IPs is the fact the they all
require memory buffers for input and/or output data. All IPs can access
system memory only directly, but none can actually do a scatter/gather
so the buffer must be contiguous in physical memory.


Our solution
------------

We decided to create a global pool for contiguous physical memory
buffers. The contiguous memory is reserved on system boot and later
passed to a memory allocator. Our solution is motivated by
1) reducing the total memory usage (reserving fixed memory buffers for
each separate device would be a real memory waste, as we assume that not
all devices will be used simultaneously) and
2) ability to share memory buffers between devices (to have zero-copy
buffer sharing between devices).

For allocating the buffers from the reserved memory areas we use 'best
fit' algorithm. This of course might lead to some memory fragmentation,
but we assume that this depends on the use cases and usage patterns. The
algorithm itself would typically be changed to fit a usage pattern.

In our solution all memory buffers are all allocated by user-space
applications, because only user applications have enough information
which devices will be used in the video processing pipeline. For
example:

MFC video decoder -> Post Processor (scaler and color space converter)
 -> Frame Buffer memory.

Allocated buffers are always mapped into user-space application's
virtual memory. Multimedia device drivers can access allocated memory
buffers basing on the provided pair of user-space address and the buffer
size. Such pair indentifies memory region unambiguously and can be
easily checked for physical contiguity. In case it isn't we decided to
create so called shadow buffer (bounce buffer) and handle it
transparently (we are aware that such case is a huge performance loss,
so applications should avoid it, but in some cases it might be really
required).

Our solutions consists of 2 modules: PMM - Physical Memory Manager and
UPBuffer - a Userspace Physical Memory Buffer translation layer. PMM
manages physical memory reserved for the buffers and provides an special
device that can be used by user-space application to allocate and map a
buffer. The UPBuffer layer translates provided user-space buffer pointer
address and buffer size into an address of the physical memory that can
be used by the multimedia devices. If such a translation succeeds the
physical memory region will be properly locked and is guaranteed to be
in the memory till the end of transaction. Each transaction must be
closed by the multimedia device driver explicitly.


Technical details
-----------------

1. Physical memory allocation

PMM reserves the contiguous physical memory with bootmem kernel
allocator. A boot parameter is used to provide information how much
memory should be allocated, for example: adding a 'pmm=32M' parameter
would reserve 32MiB of system memory on system boot.

2. Allocating a buffer from userspace

PMM provides a /dev/pmm special device. Each time the application wants
to allocate a buffer it opens the /dev/pmm special file, calls
IOCTL_PMM_ALLOC ioctl and the mmaps it into its virtual memory. The
struct pmm_area_info parameter for IOCTL_PMM_ALLOC ioctl describes the
memory requirements for the buffer (please refer to
include/linux/s3c/pmm.h) - like buffer size, memory alignment, memory
type (PMM supports different memory types, although currently only one
is used) and cpu cache coherency rules (memory can be mapped as
cacheable or non-cacheable). The buffer is freed when the file
descriptor reference count reaches zero (so the file is closed, is
unmmaped from applications memory and released from multimedia devices).

3. Buffer locking

If user application performed a mmap call on some special device and a
driver mapped some physical memory into user address space (usually with
remap_pfn_range function), this will create a vm_area structure with
VM_PFNMAP flag set in user address space map. UPBuffer layer can easily
perform a reverse mapping (virtual address to physical memory address)
by simply reading the PTE values and checking if it is contiguous in
physical memory. The only problem is how to guarantee the security of
this solution. VM_PFNMAP-type areas do not have associated page
structures so that memory pages cannot be locked directly in page cache.
However such memory area would not be freed until the special file that
is behind it is still in use. We found that is can be correctly locked
by increasing reference counter of that special file (vm_area->vm_file).
This would lock the mapping from being freed if user would accidently do
something really nasty like unmapping that area.

4. Accessing foreign driver's buffers

Our solution transparently integrates with other open source drivers
that provides their own buffers via mmap call. The only requirement is
that the underlying memory mapping should be done with remap_pfn_range()
like function. Luckily this is the case of the frame buffer driver. This
way user application can transparently use a mmaped frame buffer area as
a destination buffer for multimedia transaction.

5. Shadow Buffers

If user application provides a pointer to the standard heap or stack
memory (which in most cases is not contiguous) our UPBuffer translation
layer can transparently provide a shadow buffers that are allocated from
contiguous memory and copy user data from/to these buffers. This way the
multimedia device driver would not even need to know or care what kind
of memory an user application provided. The driver always gets a valid
address in physical memory and the whole magic is hidden in the UPBuffer
layer.

6. Speed issues

In the typical use cases application allocated a few buffers from
/dev/pmm and then uses them in the video pipeline. Preparing/locking a
memory buffer required some traversing of memory management tables to
find if the supplied user pointer maps to allocated buffer in physical
memory. The complete check if the all PTE from the specified vm_area
points to contiguous memory might be time consuming. However if we
assume that only our kernel drivers creates the PFN-type mappings in
user memory address space, we might do some simplifications. We checked
that none of our kernel drivers create a discontinuous memory mapping in
a single vm_area. Basing on this fact we decided to introduce a kernel
option which would disable the contiguity check on the PFN-type mapping
(CONFIG_UP_BUFFER_NO_PFN_CHECK). This heavily improved the performance
of the prepare() operations.

Application can also use NO_CACHE type buffer mapping to speedup buffer
synchronization before and after multimedia transactions when the buffer
would not be read by the CPU (we found that performance of the
sequential CPU write access is not degraded much if the buffer is mapped
uncacheable bufferable). If the area is mapped as NO_CACHE, a UPBuffer
translation layer detects this and sets all cache operations to noop to
increase synchronization speed.

7. SYSV SHM integration

One of the key features of the PMM module is the ability to convert an
allocated buffer into SYSV SHM (shared memory) area. This enables many
useful use cases. Buffers can be easily shared between application
without the need of copying them. It is also possible to utilize an
X-SHM extension of X11 protocol and feed XServer with the video buffers
directly. Our custom XServer uses 2D accelerator to blit pixmaps, thus
this results in zero-copy blitting from userspace application buffer
(allocated with PMM) though SYSV SHM and X-SHM to XServer's frame buffer
memory.

Allocated memory buffer can be converted with IOCTL_PMM_SHMGET ioctl of
the /dev/pmm special file (please refer to include/linux/s3c/pmm.h).


Multimedia device drivers example
---------------------------------

1. Code example

A very simple (without error checking and so) example of the hypothetical
resizer based on our framework:

struct resizer_addr_t {
        u32 vaddr;
        u32 size;
};

struct upbuf *image_src;
struct upbuf *image_dst;
struct resizer_params *image_params;

int resizer_ioctl(struct inode *inode, struct file *file, unsigned
                                        int cmd, unsigned long arg)
{
        struct resizer_addr_t addr;

        switch (cmd) {
        case RESIZER_SET_SRC:
                copy_from_user(&addr, (void *)arg, sizeof(resizer_addr_t));
                upbuf_prepare(image_src, addr.vaddr, addr.size, UPBUF_ANY);
                break;

        case RESIZER_SET_DST:
                ...

        case RESIZER_SET_PARAMS:
                /* read resizer coeficients, etc */
                ...

        case RESIZER_START:
                upbuf_sync(image_src, UPBUF_PREPARE_FROM_USER);
                upbuf_sync(image_dst, UPBUF_PREPARE_TO_USER);
                resizer_hw_set_registers(image_params, image_src, image_dst);
                resizer_hw_ready = 0;
                resizer_hw_start();
                /* isr will set resizer_hw_ready and wakeup the queue */
                wait_event(queue, resizer_hw_ready);
                upbuf_sync(image_dst, UPBUF_FINISH_TO_USER);
                break;

        case RESIZER_RELEASE_SRC:
                upbuf_release(image_src);
                break;

        case RESIZER_RELEASE_DST:
                ...
        ...
        }
        return 0;
}

2. Comments

Multimedia device drives get user space pointer to the buffer and
buffer size pair via their custom ioctl. Then they call upbuf_prepare()
function to convert it to physical memory address. Then just before
starting a DMA transaction on a multimedia device the driver should
synchronize the buffer state with upbuf_sync() function (there are 3
types of synchronization modes: UPBUF_PREPARE_FROM_USER,
UPBUF_PREPARE_TO_USER, UPBUF_PREPARE_MODIFY_USER, which results in
different cache operations and/or shadow buffer copying). When the
transaction is finished and we want to return buffers to the userspace,
the driver should call upbuf_sync() with UPBUF_FINISH_TO_USER on the DMA
target buffers. For more information please refer to
include/linux/s3c/upbuffer.h file. When the driver does not need the
buffer any more it should call the upbuf_release() function, which
unlocks the buffer and frees the resources.

Splitting the buffer enqueue operation into prepare() and
sync(PREPARE_*) functions as well as splitting the dequeue operation
into sync(FINISH_*) and release() functions gave us flexibility to
control and schedule multimedia transactions. This way the buffer might
be used for more than one transaction in the same driver between
upbuf_prepare() ... upbuf_release() calls pair. This also moved all time
consuming operations (address translation and buffer locking) to the
prepare function which might be done only once, on pipeline init.


Complete source code of our solution
------------------------------------

This patch adds Physical Memory Manager and UPBuffer user space pointer
address translation layers developed by Samsung Poland R&D Center.


Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>


---
 arch/arm/mach-s3c6410/Kconfig                 |    1 +
 arch/arm/mach-s3c6410/include/mach/pmm-plat.h |   40 +
 drivers/Kconfig                               |    3 +
 drivers/Makefile                              |    1 +
 drivers/s3cmm/Kconfig                         |  142 +++
 drivers/s3cmm/Makefile                        |    9 +
 drivers/s3cmm/pmm-init.c                      |   75 ++
 drivers/s3cmm/pmm.c                           | 1400 +++++++++++++++++++++++++
 drivers/s3cmm/upbuffer.c                      |  608 +++++++++++
 include/linux/s3c/pmm.h                       |  141 +++
 include/linux/s3c/upbuffer.h                  |  131 +++
 ipc/shm.c                                     |   24 +-
 mm/shmem.c                                    |   55 +-
 13 files changed, 2613 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm/mach-s3c6410/include/mach/pmm-plat.h
 create mode 100644 drivers/s3cmm/Kconfig
 create mode 100644 drivers/s3cmm/Makefile
 create mode 100644 drivers/s3cmm/pmm-init.c
 create mode 100644 drivers/s3cmm/pmm.c
 create mode 100644 drivers/s3cmm/upbuffer.c
 create mode 100644 include/linux/s3c/pmm.h
 create mode 100644 include/linux/s3c/upbuffer.h

diff --git a/arch/arm/mach-s3c6410/Kconfig b/arch/arm/mach-s3c6410/Kconfig
index fe638cf..2c9cace 100644
--- a/arch/arm/mach-s3c6410/Kconfig
+++ b/arch/arm/mach-s3c6410/Kconfig
@@ -11,6 +11,7 @@ config CPU_S3C6410
        bool
        select CPU_S3C6400_INIT
        select CPU_S3C6400_CLOCK
+       select PMM_POSSIBLE
        help
          Enable S3C6410 CPU support

diff --git a/arch/arm/mach-s3c6410/include/mach/pmm-plat.h b/arch/arm/mach-s3c6410/include/mach/pmm-plat.h
new file mode 100644
index 0000000..3b2f29e
--- /dev/null
+++ b/arch/arm/mach-s3c6410/include/mach/pmm-plat.h
@@ -0,0 +1,40 @@
+#ifndef __KERNEL_PMM_PLATFORM_H
+#define __KERNEL_PMM_PLATFORM_H
+
+/*
+ * Physical Memory Managment platform dependent definitions
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ */
+
+
+/**
+ * Number of types of memory.  Must be positive number no greater then
+ * 16 (in fact 32 but let keep it under 16).
+ */
+#define PMM_MEMORY_TYPES          1
+
+/**
+ * Memory types.  Each memory type must be a power of two.  If you are
+ * confused, and do not know which type to use, try PMM_MEM_ANY macro.
+ */
+enum {
+       /** A general purpose RAM memory. */
+       PMM_MEM_GENERAL     = 1 <<  0
+};
+
+/**
+ * A default bitwise OR of memory types to use if no elaborate choice
+ * is needed.  If you are confused, and do not know which type to use,
+ * try this macro.
+ */
+#define PMM_MEM_ANY PMM_MEM_GENERAL
+
+#ifdef __KERNEL__
+
+/** Mask of types that user space tools can allocate. */
+#define PMM_USER_MEMORY_TYPES_MASK 1
+
+#endif
+
+#endif
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 48bbdbe..d70fc9f 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -113,4 +113,7 @@ source "drivers/xen/Kconfig"
 source "drivers/staging/Kconfig"

 source "drivers/platform/Kconfig"
+
+source "drivers/s3cmm/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 6ee53c7..e0ef71d 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -109,5 +109,6 @@ obj-$(CONFIG_SSB)           += ssb/
 obj-$(CONFIG_VIRTIO)           += virtio/
 obj-$(CONFIG_VLYNQ)            += vlynq/
 obj-$(CONFIG_STAGING)          += staging/
+obj-$(CONFIG_S3CMM)            += s3cmm/
 obj-y                          += platform/
 obj-y                          += ieee802154/
diff --git a/drivers/s3cmm/Kconfig b/drivers/s3cmm/Kconfig
new file mode 100644
index 0000000..34ad0be
--- /dev/null
+++ b/drivers/s3cmm/Kconfig
@@ -0,0 +1,142 @@
+#
+# Misc strange devices
+#
+
+menuconfig S3CMM
+       bool "S3C Multimedia devices"
+       ---help---
+         Say Y here to get to see options for device drivers from various
+         different categories. This option alone does not add any kernel code.
+
+         If you say N, all options in this submenu will be skipped and disabled.
+
+if S3CMM
+
+config PMM_POSSIBLE
+       bool
+       default no
+
+config ARCH_HAS_OWN_PMM_INIT
+       bool
+       default no
+
+config PMM_BUILD_INIT
+       bool
+       depends on PMM && !ARCH_HAS_OWN_PMM_INIT
+       default y
+
+config PMM
+       tristate "Physical Memory Management"
+       depends on PMM_POSSIBLE
+       default no
+       help
+         This option enables support for Physical Memory Management
+         driver.  It allows allocating continuous physical memory blocks
+         from memory areas reserved during boot time.  Memory can be
+         further divided into several types (like SDRAM or SRAM).
+
+         If you are not sure, say N here.
+
+config PMM_DEVICE
+       bool "PMM user space device"
+       depends on PMM
+       default yes
+       help
+         This options makes PMM register a "pmm" misc device throught
+         which user space applications may allocate continuous memory
+         blocks.
+
+config PMM_SHM
+       bool "PMM SysV IPC integration"
+       depends on PMM = y && PMM_DEVICE && SYSVIPC
+       default yes
+       help
+         This options enables PMM to associate a PMM allocated area with
+         a SysV shared memory ids.  This may be usefull for
+         X applications which share memory throught a shared momey id
+         (shmid).
+
+config PMM_DEBUG
+       bool "PMM Debug output"
+       depends on PMM
+       default no
+       help
+         This enables additional debug output from PMM module.  With this
+         option PMM will printk whenever most of the functions are
+         called.  This may be helpful when debugging, otherwise it
+         provides no functionality.
+
+         If you are not sure, say N here.
+
+config PMM_DEBUG_FS
+       bool "PMM debugfs interface"
+       depends on PMM && DEBUG_FS
+       default no
+       help
+         This enables debugfs interface for PMM module.  The interface
+         provides files with a list of allocated areas as well as free
+         regions (holes).  This may be helpful when debugging, otherwise
+         it provides little functionality.
+
+         If you are not sure, say N here.
+
+config PMM_DEBUG_OPERATIONS
+       bool "PMM logging operations via debugfs interface"
+       depends on PMM_DEBUG_FS
+       default no
+       help
+         This enables logging operations via debugfs interface for PMM
+         module.  The interface provides file 'operations' with a list
+         of logged events like allocation of PMM segment or its release.
+         Using this option may slow down PMM engine. Moreover it demand
+         memory for operation buffering.
+
+         If you are not sure, say N here.
+
+
+config UP_BUFFER
+       tristate "Userspace Physical Memory Buffer support"
+       default no
+       help
+         This option enables support for Userspace Physical Memory buffer
+         helper. It allows other drivers to use directly physical memory
+         that was allocaled in userspace.
+
+         If you are not sure, say N here.
+
+config UP_BUFFER_DEBUG
+       depends on UP_BUFFER
+       bool "UP Buffer: Verbose debugging messages (DEVELOPMENT)"
+       default no
+       help
+         Enables verbose debug in Userspace Physical Memory Buffer layer.
+
+config UP_BUFFER_NO_PFN_CHECK
+       depends on UP_BUFFER
+       bool "Assume continuous memory in DIRECT_PFN mapped VMA (DANGEROUS)"
+       help
+         This option disables checking if physical memory mapped in
+         DIRECT_PFN type VMA areas is continuous. This speeds up buffer
+         prepare operation.
+
+         Memory areas created by PMM or mmaping a device is continuous by
+         by default, so this check can be avoided. However if there are
+         drivers that do some kernel memory hacking, this check might be
+         required.
+
+choice
+       depends on UP_BUFFER
+       prompt "UP Buffer allocator"
+       help
+         Lets you choose what mechanizm will UP Buffer use to allocate
+         physical memory blocks when needed.
+
+config UP_BUFFER_PMM
+       bool "Physical Memory Management" if PMM = UP_BUFFER || PMM = y
+
+config UP_BUFFER_DMAC
+       bool "DMA Coherent"
+
+endchoice
+
+endif # S3CMM
diff --git a/drivers/s3cmm/Makefile b/drivers/s3cmm/Makefile
new file mode 100644
index 0000000..c90a0e6
--- /dev/null
+++ b/drivers/s3cmm/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for s3c multimedia devices
+#
+
+obj-$(CONFIG_UP_BUFFER) += upbuffer.o
+obj-$(CONFIG_PMM)       += pmm.o
+obj-$(CONFIG_PMM_BUILD_INIT)   += pmm-init.o
+
+# multimedia device drivers
diff --git a/drivers/s3cmm/pmm-init.c b/drivers/s3cmm/pmm-init.c
new file mode 100644
index 0000000..f1e31a5
--- /dev/null
+++ b/drivers/s3cmm/pmm-init.c
@@ -0,0 +1,75 @@
+/*
+ * Physical Memory Managment initialisation code
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+
+#include <linux/module.h>      /* EXPORT_SYMBOL */
+#include <linux/mm.h>          /* PAGE_ALIGN */
+#include <linux/bootmem.h>     /* alloc_bootmem_pages_nopanic() */
+#define __KERNEL_PMM_INSIDE 1
+#include <linux/s3c/pmm.h>     /* pmm_module_platform_init() prototype */
+#undef __KERNEL_PMM_INSIDE
+
+
+static unsigned long pmm_memory_start;
+static unsigned long pmm_memory_size;
+
+
+static int __init pmm_early_param(char *param)
+{
+       unsigned long long size;
+       void *ptr;
+
+       size = memparse(param, 0);
+#if defined CONFIG_PMM_DEBUG
+       printk(KERN_INFO "pmm: pmm_early_param(%s {interpreted as 0x%llx})\n",
+              param, size);
+#endif
+
+       if (size <= 0) {
+               return -EINVAL;
+       } else if (size > (1ull << 30)) {
+               printk(KERN_WARNING
+                      "pmm: refusing to allocate more then 1GiB (requested %llu)\n",
+                      size);
+               return -EINVAL;
+       }
+
+       pmm_memory_size = PAGE_ALIGN((unsigned long)size);
+       ptr = alloc_bootmem_pages_nopanic(pmm_memory_size);
+       if (!ptr) {
+               printk(KERN_ERR "pmm: failed to allocate %lu\n",
+                      pmm_memory_size);
+       } else {
+               pmm_memory_start = virt_to_phys(ptr);
+#if defined CONFIG_PMM_DEBUG
+               printk(KERN_INFO
+                      "pmm: allocated memory at 0x%08lx (virt: %p)\n",
+                      pmm_memory_start, ptr);
+#endif
+       }
+
+       return 0;
+}
+early_param("pmm", pmm_early_param);
+
+
+
+/** Called from pmm_module_init() when module is initialised. */
+void pmm_module_platform_init(pmm_add_region_func add_region)
+{
+#if defined CONFIG_PMM_DEBUG
+       printk(KERN_INFO "pmm: pmm_module_platform_init() [%08lx+%08lx]\n",
+              pmm_memory_start, pmm_memory_size);
+#endif
+       if (pmm_memory_start && pmm_memory_size)
+               add_region(pmm_memory_start, pmm_memory_size,
+                          PMM_MEM_GENERAL, 0);
+}
+EXPORT_SYMBOL(pmm_module_platform_init);
diff --git a/drivers/s3cmm/pmm.c b/drivers/s3cmm/pmm.c
new file mode 100644
index 0000000..271df52
--- /dev/null
+++ b/drivers/s3cmm/pmm.c
@@ -0,0 +1,1400 @@
+/*
+ * Physical Memory Managment
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * Written by Michal Nazarewicz (mina86@mina86.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License.
+ */
+
+#include <linux/errno.h>       /* Error numbers */
+#include <linux/file.h>        /* fput() */
+#include <linux/fs.h>          /* struct file */
+#include <linux/bitops.h>      /* ffs() */
+#include <linux/kref.h>        /* struct kref */
+#include <linux/mm.h>          /* Memory stuff */
+#include <linux/mman.h>
+#include <linux/module.h>      /* Standard module stuff */
+#include <linux/rbtree.h>      /* rb_node, rb_root & co */
+#include <linux/sched.h>       /* struct task_struct */
+#include <linux/types.h>       /* Just to be safe ;) */
+#include <linux/uaccess.h>     /* __copy_{to,from}_user */
+
+#if defined CONFIG_PMM_DEVICE
+#  include <linux/miscdevice.h>/* misc_register() and company */
+#  if defined CONFIG_PMM_SHM
+#    include <linux/file.h>    /* fput(), get_file() */
+#    include <linux/ipc_namespace.h>   /* ipc_namespace */
+#    include <linux/nsproxy.h> /* current->nsproxy */
+#    include <linux/security.h>/* security_shm_{alloc,free}() */
+#    include <linux/shm.h>     /* struct shmid_kernel */
+
+#    include "../../ipc/util.h"/* ipc_* */
+
+#    define shm_ids(ns)     ((ns)->ids[IPC_SHM_IDS])
+#    define shm_unlock(shp) ipc_unlock(&(shp)->shm_perm)
+#  endif
+#endif
+
+#if defined CONFIG_PMM_DEBUG_FS
+#  include <linux/debugfs.h>   /* Whole debugfs stuff */
+#  include <linux/sched.h>
+#  include <asm/current.h>
+#endif
+
+#define __KERNEL_PMM_INSIDE 1
+#include <linux/s3c/pmm.h>     /* PMM's stuff */
+#undef  __KERNEL_PMM_INSIDE
+
+
+/* Check if PMM_MEMORY_TYPES has a valid value. */
+#if PMM_MEMORY_TYPES < 1 || PMM_MEMORY_TYPES > 32
+#  error PMM_MEMORY_TYPES < 1 || PMM_MEMORY_TYPES > 32
+#endif
+
+#if (PMM_USER_MEMORY_TYPES_MASK & ~((1 << PMM_MEMORY_TYPES) - 1)) != 0
+#  warning (PMM_USER_MEMORY_TYPES_MASK & ~((1 << PMM_MEMORY_TYPES) - 1)) != 0
+#endif
+
+
+/* Debug messages. */
+#if defined CONFIG_PMM_DEBUG
+#  if defined DEBUG
+#    undef  DEBUG
+#  endif
+#  define DEBUG(fmt, ...) \
+       printk(KERN_INFO "pmm debug: " fmt "\n", ##__VA_ARGS__)
+#else
+#  define DEBUG(fmt, ...) do { } while (0)
+#endif
+
+
+
+/********************************************************************/
+/****************************** Global ******************************/
+/********************************************************************/
+
+
+/** PMM Item's flags.  See pmm_item structure. */
+enum {
+       PMM_HOLE      = 1 << 31,  /**< This item is a hole, not area */
+       PMM_ITEM_LAST = 1 << 30   /**< The item is at the end of the region. */
+};
+
+
+
+/**
+ * A structure describing a single allocated area or a hole.
+ */
+struct pmm_item {
+       /* Keep size as the first element! Several functions assume it is
+          there! */
+       size_t         size;           /**< Area's size. */
+       size_t         start;          /**< Starting address. */
+       unsigned       flags;          /**< Undocummented as of yet. */
+#if PMM_MEMORY_TYPES != 1
+       unsigned       type;           /**< Memory type. */
+#endif
+
+       /** Node in rb tree sorted by starting address. */
+       struct rb_node by_start;
+
+       union {
+               /**
+                * Node in rb tree sorted by hole's size.  There is one tree
+                * per memory type.  Meaningful only for holes.
+                */
+               struct rb_node by_size_per_type;
+               /**
+                * Number of struct file or devices that reffer to this area.
+                */
+               struct kref          refcount;
+       };
+};
+
+#if PMM_MEMORY_TYPES == 1
+#  define PMM_TYPE(obj) 1
+#else
+#  define PMM_TYPE(obj) ((obj)->type)
+#endif
+
+
+
+/** Mutex used throught all the module. */
+static DEFINE_MUTEX(pmm_mutex);
+
+
+/** A per type rb tree of holes sorted by size. */
+static struct pmm_mem_type {
+       struct rb_root root;
+} pmm_mem_types[PMM_MEMORY_TYPES];
+
+
+/** A rb tree of holes and areas sorted by starting address. */
+static struct rb_root pmm_items = RB_ROOT;
+
+
+/** operation type */
+#define PMM_OP_ALLOC        'a'
+#define PMM_OP_ALLOC_FAILED 'f'
+#define PMM_OP_RELEASE      'r'
+#define PMM_OP_GET          'g'
+#define PMM_OP_PUT          'p'
+
+/** pmm operation log, contains action type,
+ * pid of process that called action moreover
+ * pointer and size of allocaded physical memory */
+struct pmm_op_log {
+       char      type;           /**< Operation type PMM_OP_(ALLOC/FREE) */
+       size_t    size;           /**< Area's size. */
+       size_t    required_size;  /**< Requested area's size. */
+       size_t    start;          /**< Starting address. */
+       pid_t     pid;            /**< Pid of operation caller*/
+       unsigned  time_stamp;     /**< Time stamp in jiffies */
+       struct pmm_op_log *next;  /**< Pointer to next list element */
+};
+
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+
+static struct pmm_op_log *pmm_op_head = NULL;
+static struct pmm_op_log *pmm_op_tail = NULL;
+static DECLARE_MUTEX(pmm_op_lock);
+
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+
+static inline
+int pmm_op_push(char type, size_t start, size_t size,
+                       size_t required_size)
+{
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+       struct pmm_op_log *tmp;
+       tmp = kmalloc(sizeof(struct pmm_op_log), GFP_KERNEL);
+
+       if (!tmp)
+               return -ENOMEM;
+
+       tmp->type = type;
+       tmp->start = start;
+       tmp->size = size;
+       tmp->required_size = required_size;
+       tmp->pid = current->pid;
+       tmp->time_stamp = jiffies;
+       tmp->next = NULL;
+
+       down(&pmm_op_lock);
+
+       if (pmm_op_tail)
+               pmm_op_tail->next = tmp;
+       else
+               pmm_op_head = tmp;
+
+       pmm_op_tail = tmp;
+
+       up(&pmm_op_lock);
+       return 0;
+#else
+       return -ENOMEM;
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+}
+
+static inline
+int pmm_op_pop(struct pmm_op_log *op_log)
+{
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+       struct pmm_op_log *tmp;
+
+       down(&pmm_op_lock);
+
+       if (!pmm_op_head) {
+               up(&pmm_op_lock);
+               return -1;
+       }
+
+       tmp = pmm_op_head;
+       pmm_op_head = pmm_op_head->next;
+
+       if (pmm_op_head == NULL)
+               pmm_op_tail = NULL;
+
+       up(&pmm_op_lock);
+
+       *op_log = *tmp;
+
+       kfree(tmp);
+
+       return 0;
+#else
+       return -1;
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+}
+
+
+/****************************************************************************/
+/****************************** Core functions ******************************/
+/****************************************************************************/
+
+
+static        void __pmm_item_insert_by_size (struct pmm_item *item);
+static inline void __pmm_item_erase_by_size  (struct pmm_item *item);
+static        void __pmm_item_insert_by_start(struct pmm_item *item);
+static inline void __pmm_item_erase_by_start (struct pmm_item *item);
+
+
+
+/**
+ * Takes a \a size bytes large area from hole \a hole.  Takes \a
+ * alignment into consideration.  \a hole must be able to hold the
+ * area.
+ * @param  hole     hole to take area from
+ * @param  size     area's size
+ * @param  alignment area's starting address alignment (must be power of two)
+ * @return allocated area or NULL on error (if kmalloc() failed)
+ */
+static struct pmm_item *__pmm_hole_take(struct pmm_item *hole,
+                                        size_t size, size_t alignment);
+
+
+/**
+ * Tries to merge two holes.  Both arguments points to \c by_start
+ * fields of the holes.  If both are not NULL and the previous hole's
+ * end address is the same as next hole's start address then both
+ * holes are merged.  Previous hole is freed.  In any case, the hole
+ * that has a larger starting address is preserved (but possibly
+ * enlarged).
+ *
+ * @param  prev_node \c by_start \c rb_node of a previous hole
+ * @param  next_node \c by_start \c rb_node of a next hole
+ * @return hole with larger start address (possibli merged with
+ *         previous one).
+ */
+static void __pmm_hole_merge_maybe(struct rb_node *prev_node,
+                                   struct rb_node *next_node);
+
+
+/**
+ * Tries to allocate an area of given memory type.  \a node is a root
+ * of a by_size_per_type tree (as name points out each memory type has
+ * its own by_size tree).  The function implements best fit algorithm
+ * searching for the smallest hole where area can be allocated in.
+ *
+ * @param  node     by_size_per_type tree root
+ * @param  size     area's size
+ * @param  alignment area's starting address alignment (must be power of two)
+ */
+static struct pmm_item *__pmm_alloc(struct pmm_mem_type *mem_type,
+                                    size_t size, size_t alignment);
+
+
+/**
+ * Finds item by start address.
+ * @param  start start address.
+ * @param  msg   string to add to warning messages.
+ */
+static struct pmm_item *__pmm_find_area(size_t start, const char *msg);
+
+
+
+/****************************** Allocation ******************************/
+
+__must_check
+static struct pmm_item *pmm_alloc_internal(struct pmm_area_info *info)
+{
+       struct pmm_item *area = 0;
+       size_t required_size;
+       unsigned i = 0, t;
+
+       DEBUG("pmm_alloc(%8x, %d, %04x, %8x)",
+             info->size, info->type, info->flags, info->alignment);
+
+       /* Verify */
+       if (!info->size || (info->alignment & (info->alignment - 1)))
+               return 0;
+
+       t = info->type & ((1 << PMM_MEMORY_TYPES) - 1);
+       if (!t)
+               return 0;
+
+       if (info->alignment < PAGE_SIZE)
+               info->alignment = PAGE_SIZE;
+
+       required_size = info->size;
+       info->size = PAGE_ALIGN(info->size);
+
+       /* Find area */
+       mutex_lock(&pmm_mutex);
+       do {
+               if (t & 1)
+                       area = __pmm_alloc(pmm_mem_types + i,
+                                          info->size, info->alignment);
+       } while (!area && (++i, t >>= 1));
+       mutex_unlock(&pmm_mutex);
+
+
+       /* Return result */
+       if (area) {
+               pmm_op_push(PMM_OP_ALLOC, area->start, area->size,
+                           required_size);
+               kref_init(&area->refcount);
+
+               info->magic     = PMM_MAGIC;
+               info->size      = area->size;
+               info->type      = PMM_TYPE(area);
+               if (info->flags & PMM_KNOWN_FLAGS)
+                       area->flags |= (info->flags & PMM_KNOWN_FLAGS);
+               info->flags     = area->flags;
+               info->alignment =
+                       (area->start ^ (area->start - 1)) & area->start;
+       } else {
+               pmm_op_push(PMM_OP_ALLOC_FAILED, 0, 0, required_size);
+       }
+
+       return area;
+}
+
+__must_check
+size_t pmm_alloc    (struct pmm_area_info *info)
+{
+       struct pmm_item *area = pmm_alloc_internal(info);
+       return area ? area->start : 0;
+}
+EXPORT_SYMBOL(pmm_alloc);
+
+int    pmm_get      (size_t paddr)
+{
+       struct pmm_item *area;
+       int ret = 0;
+
+       mutex_lock(&pmm_mutex);
+
+       area = __pmm_find_area(paddr, "pmm_get");
+       if (area) {
+               pmm_op_push(PMM_OP_GET, area->start, area->size, area->size);
+               kref_get(&area->refcount);
+       } else
+               ret = -ENOENT;
+
+       mutex_unlock(&pmm_mutex);
+       return ret;
+}
+EXPORT_SYMBOL(pmm_get);
+
+
+/****************************** Deallocation ******************************/
+
+static void __pmm_kref_release(struct kref *kref)
+{
+       struct pmm_item *area = container_of(kref, struct pmm_item, refcount);
+       pmm_op_push(PMM_OP_RELEASE, area->start, area->size, 0);
+
+       /* Convert area into hole */
+       area->flags |= PMM_HOLE;
+       __pmm_item_insert_by_size(area);
+       /* PMM_ITEM_LAST flag is preserved */
+
+       /* Merge with prev and next sibling */
+       __pmm_hole_merge_maybe(rb_prev(&area->by_start), &area->by_start);
+       __pmm_hole_merge_maybe(&area->by_start, rb_next(&area->by_start));
+}
+
+#if defined CONFIG_PMM_DEVICE
+
+static int  pmm_put_internal  (struct pmm_item *area)
+{
+       int ret = 0;
+
+       if (area) {
+               mutex_lock(&pmm_mutex);
+
+               if (area->flags & PMM_HOLE) {
+                       printk(KERN_ERR
+                              "pmm: pmm_put_int: item at 0x%08x is a hole\n",
+                              area->start);
+                       ret = -ENOENT;
+               } else {
+                       pmm_op_push(PMM_OP_PUT, area->start, area->size, 0);
+                       kref_put(&area->refcount, __pmm_kref_release);
+               }
+
+               mutex_unlock(&pmm_mutex);
+       }
+       return ret;
+}
+
+#endif
+
+int    pmm_put      (size_t paddr)
+{
+       int ret = 0;
+
+       if (paddr) {
+               struct pmm_item *area;
+               mutex_lock(&pmm_mutex);
+
+               area = __pmm_find_area(paddr, "pmm_put");
+               if (area) {
+                       pmm_op_push(PMM_OP_PUT, area->start, area->size, 0);
+                       kref_put(&area->refcount, __pmm_kref_release);
+               } else
+                       ret = -ENOENT;
+
+               mutex_unlock(&pmm_mutex);
+       }
+       return ret;
+}
+EXPORT_SYMBOL(pmm_put);
+
+
+
+
+
+/************************************************************************/
+/****************************** PMM device ******************************/
+/************************************************************************/
+
+#if defined CONFIG_PMM_DEVICE
+
+static int pmm_file_open(struct inode *inode, struct file *file);
+static int pmm_file_release(struct inode *inode, struct file *file);
+static int pmm_file_ioctl(struct inode *inode, struct file *file,
+                          unsigned cmd, unsigned long arg);
+static int pmm_file_mmap(struct file *file, struct vm_area_struct *vma);
+
+/* Cannot be static if CONFIG_PMM_SHM is on, ipc/shm.c uses it's address. */
+#if !defined CONFIG_PMM_SHM
+static
+#endif
+const struct file_operations pmm_fops = {
+       .owner   = THIS_MODULE,
+       .open    = pmm_file_open,
+       .release = pmm_file_release,
+       .ioctl   = pmm_file_ioctl,
+       .mmap    = pmm_file_mmap,
+};
+
+
+
+static int pmm_file_open(struct inode *inode, struct file *file)
+{
+       DEBUG("file_open(%p)", file);
+       file->private_data = 0;
+       return 0;
+}
+
+
+static int pmm_file_release(struct inode *inode, struct file *file)
+{
+       DEBUG("file_release(%p)", file);
+
+       if (file->private_data != 0)
+               pmm_put_internal(file->private_data);
+
+       return 0;
+}
+
+
+
+#if defined CONFIG_PMM_SHM
+
+/*
+ * Called from ipcneew() with shm_ids.rw_mutex held as a writer.  See
+ * newseg() in ipc/shm.c for some more info (this function is based on
+ * that one).
+ */
+struct file *shmem_pmm_file_setup(char *name, loff_t size);
+
+static int pmm_newseg(struct ipc_namespace *ns, struct ipc_params *params)
+{
+       key_t        key      = params->key;
+       struct file *pmm_file = (void *)params->u.size; /* XXX */
+       int          shmflg   = params->flg;
+
+       struct pmm_item *area = pmm_file->private_data;
+       const int numpages    = (area->size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+       struct file *file;
+       struct shmid_kernel *shp;
+       char name[13];
+       int ret;
+
+       if (ns->shm_tot + numpages > ns->shm_ctlall)
+               return -ENOSPC;
+
+       shp = ipc_rcu_alloc(sizeof(*shp));
+       if (!shp)
+               return -ENOMEM;
+
+       shp->shm_perm.key  = key;
+       shp->shm_perm.mode = (shmflg & S_IRWXUGO);
+       shp->mlock_user    = NULL;
+
+       shp->shm_perm.security = NULL;
+       ret = security_shm_alloc(shp);
+       if (ret) {
+               ipc_rcu_putref(shp);
+               return ret;
+       }
+
+       sprintf(name, "SYSV%08x", key);
+       file = shmem_pmm_file_setup(name, area->size);
+       if (IS_ERR(file)) {
+               ret = PTR_ERR(file);
+               goto no_file;
+       }
+
+       file->private_data     = area;
+       file->f_op             = &pmm_fops;
+       pmm_op_push(PMM_OP_GET, area->start, area->size, area->size);
+       kref_get(&area->refcount);
+
+       /*
+        * shmid gets reported as "inode#" in /proc/pid/maps.
+        * proc-ps tools use this. Changing this will break them.
+        */
+       file->f_dentry->d_inode->i_ino = shp->shm_perm.id;
+
+       ret = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
+       if (ret < 0)
+               goto no_id;
+
+       shp->shm_cprid  = task_tgid_vnr(current);
+       shp->shm_lprid  = 0;
+       shp->shm_atim   = shp->shm_dtim = 0;
+       shp->shm_ctim   = get_seconds();
+       shp->shm_segsz  = area->size;
+       shp->shm_nattch = 0;
+       shp->shm_file   = file;
+
+       ns->shm_tot += numpages;
+       ret = shp->shm_perm.id;
+       shm_unlock(shp);
+       return ret;
+
+no_id:
+       fput(file);
+no_file:
+       security_shm_free(shp);
+       ipc_rcu_putref(shp);
+       return ret;
+}
+
+#endif /* CONFIG_PMM_SHM */
+
+
+
+static int pmm_file_ioctl(struct inode *inode, struct file *file,
+                          unsigned cmd, unsigned long arg)
+{
+       DEBUG("file_ioctl(%p, cmd = %d, arg = %lu)", file, cmd, arg);
+
+       switch (cmd) {
+       case IOCTL_PMM_ALLOC: {
+               struct pmm_area_info info;
+               struct pmm_item     *area;
+               if (!arg)
+                       return -EINVAL;
+               if (file->private_data) /* Already allocated */
+                       return -EBADFD;
+               if (copy_from_user(&info, (void *)arg, sizeof info))
+                       return -EFAULT;
+               if (info.magic != PMM_MAGIC)
+                       return -ENOTTY;
+               info.type &= PMM_USER_MEMORY_TYPES_MASK;
+               area = pmm_alloc_internal(&info);
+               if (!area)
+                       return -ENOMEM;
+               if (copy_to_user((void *)arg, &info, sizeof info)) {
+                       pmm_put_internal(area);
+                       return -EFAULT;
+               }
+               file->private_data = area;
+               return 0;
+       }
+
+       case IOCTL_PMM_SHMGET: {
+#if defined CONFIG_PMM_SHM
+               struct pmm_shm_info  info;
+               struct ipc_namespace *ns;
+               struct ipc_params shm_params;
+               struct ipc_ops shm_ops;
+
+               if (!arg)
+                       return -EINVAL;
+               if (!file->private_data)
+                       return -EBADFD;
+               if (copy_from_user(&info, (void *)arg, sizeof info))
+                       return -EFAULT;
+               if (info.magic != PMM_MAGIC)
+                       return -ENOTTY;
+
+               ns = current->nsproxy->ipc_ns;
+
+               shm_params.key    = info.key;
+               shm_params.flg    = info.shmflg | IPC_CREAT | IPC_EXCL;
+               shm_params.u.size = (size_t)file; /* XXX */
+
+               shm_ops.getnew      = pmm_newseg;
+               /* We can set those two to NULL since thanks to IPC_CREAT |
+                  IPC_EXCL flags util.c never reffer to those functions. */
+               shm_ops.associate   = 0;
+               shm_ops.more_checks = 0;
+
+               return ipcget(ns, &shm_ids(ns), &shm_ops, &shm_params);
+#else
+               return -ENOSYS;
+#endif
+       }
+
+       default:
+               return -ENOTTY;
+       }
+}
+
+
+
+#if defined CONFIG_PMM_SHM
+/* We add a dummy vm_operations_struct with a dummy fault handler as
+   some kernel code may check if fault is set and treate situantion
+   when it isn't as a bug (that's the case in ipc/shm.c for instance).
+   This code should be safe as the area is physical and fault shall
+   never happen (the pages are always in memory). */
+static int  pmm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+       (void)vma; (void)vmf;
+       return -EFAULT;
+}
+
+static struct vm_operations_struct pmm_vm_ops = {
+       .fault  = pmm_vm_fault,
+};
+#endif
+
+
+static int pmm_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+       int ret = -EBADFD;
+       DEBUG("pmm_file_mmap(%p, %p)", (void *)file, (void *)vma);
+       if (file->private_data) {
+               const size_t pgoff  = vma->vm_pgoff;
+               const size_t offset = pgoff << PAGE_SHIFT;
+               const size_t length = vma->vm_end - vma->vm_start;
+               struct pmm_item *const area = file->private_data;
+
+               if (offset >= area->size || length > area->size ||
+                   offset + length > area->size)
+                       ret = -ENOSPC;
+               else {
+                       /* non cache mapping */
+                       if (area->flags & PMM_NO_CACHE)
+                       {
+                               vma->vm_page_prot =
+                                       pgprot_writecombine(vma->vm_page_prot);
+                       }
+                       ret = remap_pfn_range(vma, vma->vm_start,
+                                             __phys_to_pfn(area->start+offset),
+                                             length, vma->vm_page_prot);
+
+#if defined CONFIG_PMM_SHM
+                       vma->vm_ops = &pmm_vm_ops;
+
+                       /*
+                        * From mm/memory.c:
+                        *
+                        *     There's a horrible special case to
+                        *     handle copy-on-write behaviour that
+                        *     some programs depend on. We mark the
+                        *     "original" un-COW'ed pages by matching
+                        *     them up with "vma->vm_pgoff".
+                        *
+                        * Unfortunatelly, this brakes shmdt() when
+                        * PMM area is converted into System V IPC.
+                        * As those pages won't be COW pages we revert
+                        * changes made by remap_pfn_range() to
+                        * vma->vm_pgoff.
+                        */
+                       vma->vm_pgoff = pgoff;
+#endif
+               }
+
+       }
+       return ret;
+}
+
+
+#endif /* CONFIG_PMM_DEVICE */
+
+
+
+
+
+/**********************************************************************/
+/****************************** Debug FS ******************************/
+/**********************************************************************/
+
+#if defined CONFIG_PMM_DEBUG_FS
+
+static struct dentry *pmm_debugfs_dir;
+
+
+static int     pmm_debugfs_items_open (struct inode *, struct file *);
+static int     pmm_debugfs_holes_per_type_open
+                                      (struct inode *, struct file *);
+static int     pmm_debugfs_release    (struct inode *, struct file *);
+static ssize_t pmm_debugfs_read       (struct file *, char __user *,
+                                       size_t, loff_t *);
+static loff_t  pmm_debugfs_llseek     (struct file *, loff_t, int);
+
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+static int pmm_debugfs_operation_log_open( struct inode *i, struct file *f);
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+
+static const struct {
+       const struct file_operations items;
+       const struct file_operations holes_per_type;
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+       const struct file_operations operation_log;
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+} pmm_debugfs_fops = {
+       .items = {
+               .owner   = THIS_MODULE,
+               .open    = pmm_debugfs_items_open,
+               .release = pmm_debugfs_release,
+               .read    = pmm_debugfs_read,
+               .llseek  = pmm_debugfs_llseek,
+       },
+       .holes_per_type = {
+               .owner   = THIS_MODULE,
+               .open    = pmm_debugfs_holes_per_type_open,
+               .release = pmm_debugfs_release,
+               .read    = pmm_debugfs_read,
+               .llseek  = pmm_debugfs_llseek,
+       },
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+       .operation_log = {
+               .owner   = THIS_MODULE,
+               .open    = pmm_debugfs_operation_log_open,
+               .release = pmm_debugfs_release,
+               .read    = pmm_debugfs_read,
+               .llseek  = pmm_debugfs_llseek,
+       },
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+};
+
+
+struct pmm_debugfs_buffer {
+       size_t size;
+       size_t capacity;
+       char buffer[];
+};
+
+static struct pmm_debugfs_buffer *
+pmm_debugfs_buf_cat(struct pmm_debugfs_buffer *buf,
+                    void *data, size_t size);
+
+
+
+
+static void pmm_debugfs_init(void)
+{
+       static u8 pmm_memory_types = PMM_MEMORY_TYPES;
+       static char pmm_debugfs_names[PMM_MEMORY_TYPES][4];
+
+       struct dentry *dir;
+       unsigned i;
+
+       if (pmm_debugfs_dir)
+               return;
+
+       dir = pmm_debugfs_dir = debugfs_create_dir("pmm", 0);
+       if (!dir || dir == ERR_PTR(-ENODEV)) {
+               pmm_debugfs_dir = 0;
+               return;
+       }
+
+       debugfs_create_file("items", 0440, dir, 0, &pmm_debugfs_fops.items);
+
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+       debugfs_create_file("operation", 0440, dir, 0,
+                           &pmm_debugfs_fops.operation_log);
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+
+       dir = debugfs_create_dir("types", dir);
+       if (!dir)
+               return;
+
+       debugfs_create_u8("count", 0440, dir, &pmm_memory_types);
+       for (i = 0; i < ARRAY_SIZE(pmm_debugfs_names); ++i) {
+               sprintf(pmm_debugfs_names[i], "%u", i);
+               debugfs_create_file(pmm_debugfs_names[i], 0440, dir,
+                                   pmm_mem_types + i,
+                                   &pmm_debugfs_fops.holes_per_type);
+       }
+}
+
+
+static void pmm_debugfs_done(void)
+{
+       if (pmm_debugfs_dir) {
+               debugfs_remove_recursive(pmm_debugfs_dir);
+               pmm_debugfs_dir = 0;
+       }
+}
+
+
+static int     pmm_debugfs__open      (struct inode *i, struct file *f,
+                                       struct rb_root *root, int by_start)
+{
+       struct pmm_debugfs_buffer *buf = 0;
+       struct rb_node *node;
+       int ret = 0;
+
+       mutex_lock(&pmm_mutex);
+
+       for (node = rb_first(root); node; node = rb_next(node)) {
+               size_t size = 128;
+               char tmp[128];
+
+               struct pmm_item *item;
+               item = by_start
+                       ? rb_entry(node, struct pmm_item, by_start)
+                       : rb_entry(node, struct pmm_item, by_size_per_type);
+               size = sprintf(tmp, "%c %08x %08x [%08x] fl %08x tp %08x\n",
+                              item->flags & PMM_HOLE ? 'f' : 'a',
+                              item->start, item->start + item->size,
+                              item->size,
+                              item->flags, PMM_TYPE(item));
+
+               buf = pmm_debugfs_buf_cat(buf, tmp, size);
+               if (!buf) {
+                       ret = -ENOMEM;
+                       goto error;
+               }
+       }
+
+       f->private_data = buf;
+ error:
+       mutex_unlock(&pmm_mutex);
+       return ret;
+
+}
+
+#if defined CONFIG_PMM_DEBUG_OPERATIONS
+static int pmm_debugfs_operation_log_open( struct inode *i, struct file *f)
+{
+       struct pmm_debugfs_buffer *buf = 0;
+       struct pmm_op_log op;
+
+       while( pmm_op_pop(&op) == 0) {
+               size_t tmp_size;
+               char tmp[128];
+               tmp_size = sprintf(tmp, "%08x %08x %c %08x %08x %08x\n",
+                                  op.time_stamp, (u32)op.pid, op.type,
+                                  op.required_size, op.size, op.start);
+               buf = pmm_debugfs_buf_cat(buf, tmp, tmp_size);
+               if (!buf)
+                       return -ENOMEM;
+       }
+
+       f->private_data = buf;
+       return 0;
+}
+#endif /* CONFIG_PMM_DEBUG_OPERATIONS */
+
+static int     pmm_debugfs_items_open (struct inode *i, struct file *f)
+{
+       return pmm_debugfs__open(i, f, &pmm_items, 1);
+}
+
+static int     pmm_debugfs_holes_per_type_open (struct inode *i,
+                                                struct file *f)
+{
+       return pmm_debugfs__open(i, f, i->i_private, 0);
+}
+
+
+
+static int     pmm_debugfs_release    (struct inode *i, struct file *f)
+{
+       kfree(f->private_data);
+       return 0;
+}
+
+
+static ssize_t pmm_debugfs_read       (struct file *f, char __user *user_buf,
+                                       size_t size, loff_t *offp)
+{
+       const struct pmm_debugfs_buffer *const buf = f->private_data;
+       const loff_t off = *offp;
+
+       if (!buf || off >= buf->size)
+               return 0;
+
+       if (size >= buf->size - off)
+               size = buf->size - off;
+
+       size -= copy_to_user(user_buf, buf->buffer + off, size);
+       *offp += off + size;
+
+       return size;
+}
+
+
+static loff_t  pmm_debugfs_llseek     (struct file *f, loff_t offset,
+                                       int whence) {
+       switch (whence) {
+       case SEEK_END:
+               offset += ((struct pmm_debugfs_buffer *)f->private_data)->size;
+               break;
+       case SEEK_CUR:
+               offset += f->f_pos;
+               break;
+       }
+
+       return offset >= 0 ? f->f_pos = offset : -EINVAL;
+}
+
+
+
+
+static struct pmm_debugfs_buffer *
+pmm_debugfs_buf_cat(struct pmm_debugfs_buffer *buf,
+                    void *data, size_t size)
+{
+       /* Allocate more memory; buf may be NULL */
+       if (!buf || buf->size + size > buf->capacity) {
+               const size_t tmp = (buf ? buf->size : 0) + size + sizeof *buf;
+               size_t s = (buf ? buf->capacity + sizeof *buf : 128);
+               struct pmm_debugfs_buffer *b;
+
+               while (s < tmp)
+                       s <<= 1;
+
+               b = krealloc(buf, s, GFP_KERNEL);
+               if (!b) {
+                       kfree(buf);
+                       return 0;
+               }
+
+               if (!buf)
+                       b->size = 0;
+
+               buf = b;
+               buf->capacity = s - sizeof *buf;
+       }
+
+       memcpy(buf->buffer + buf->size, data, size);
+       buf->size += size;
+
+       return buf;
+}
+
+
+#endif /* CONFIG_PMM_DEBUG_FS */
+
+
+
+
+
+/****************************************************************************/
+/****************************** Initialisation ******************************/
+/****************************************************************************/
+
+#if defined CONFIG_PMM_DEVICE
+static struct miscdevice pmm_miscdev = {
+       .minor = MISC_DYNAMIC_MINOR,
+       .name  = "pmm",
+       .fops  = &pmm_fops
+};
+
+static int pmm_miscdev_registered;
+#endif
+
+static const char banner[] __initdata =
+       KERN_INFO "PMM Driver, (c) 2009 Samsung Electronics\n";
+
+
+
+static int  __init pmm_add_region(size_t paddr, size_t size,
+                                  unsigned type, unsigned flags)
+{
+       /* Create hole */
+       {
+               struct pmm_item     *hole;
+
+               if (!type || (type & (type - 1)) ||
+                   type > (1 << (PMM_MEMORY_TYPES - 1))) {
+                       printk(KERN_ERR "pmm: invalid memory type: %u\n", type);
+                       return -EINVAL;
+               }
+
+               hole = kmalloc(sizeof *hole, GFP_KERNEL);
+               if (!hole) {
+                       printk(KERN_ERR
+                              "pmm: not enough memory to add region\n");
+                       return -ENOMEM;
+               }
+
+               DEBUG("pmm_add_region(%8x, %8x, %d, %04x)",
+                     paddr, size, type, flags);
+
+               hole->start = paddr;
+               hole->size  = size;
+               hole->flags = flags | PMM_ITEM_LAST | PMM_HOLE;
+#if PMM_MEMORY_TYPES != 1
+               hole->type  = type;
+#endif
+
+               mutex_lock(&pmm_mutex);
+
+               __pmm_item_insert_by_size (hole);
+               __pmm_item_insert_by_start(hole);
+
+               mutex_unlock(&pmm_mutex);
+       }
+
+       return 0;
+}
+
+
+static int __init pmm_module_init(void)
+{
+#if defined CONFIG_PMM_DEVICE
+       int ret;
+#endif
+
+       printk(banner);
+       DEBUG("pmm: loading");
+
+#if defined CONFIG_PMM_DEVICE
+       /* Register misc device */
+       ret = misc_register(&pmm_miscdev);
+       if (ret) {
+               /*
+                * Even if we don't register the misc device we can
+                * continue providing kernel level API, so we don't
+                * return here with error.
+                */
+               printk(KERN_WARNING
+                      "pmm: could not register misc device (ret = %d)\n",
+                      ret);
+       } else
+               pmm_miscdev_registered = 1;
+#endif
+
+       pmm_module_platform_init(pmm_add_region);
+
+#if defined CONFIG_PMM_DEBUG_FS
+       pmm_debugfs_init();
+#endif
+
+       DEBUG("pmm: loaded");
+       return 0;
+}
+module_init(pmm_module_init);
+
+
+static void __exit pmm_module_exit(void)
+{
+#if defined CONFIG_PMM_DEVICE
+       if (pmm_miscdev_registered)
+               misc_deregister(&pmm_miscdev);
+#endif
+
+#if defined CONFIG_PMM_DEBUG_FS
+       pmm_debugfs_done();
+#endif
+
+       printk(KERN_INFO "PMM driver module exit\n");
+}
+module_exit(pmm_module_exit);
+
+
+MODULE_AUTHOR("Michal Nazarewicz");
+MODULE_LICENSE("GPL");
+
+
+
+
+
+/***************************************************************************/
+/************************* Internal core functions *************************/
+/***************************************************************************/
+
+static        void __pmm_item_insert_by_size (struct pmm_item *item)
+{
+       struct rb_node **link, *parent = 0;
+       const size_t size = item->size;
+       unsigned n = 0;
+
+#if PMM_MEMORY_TYPES != 1
+       n = ffs(item->type) - 1;
+       BUG_ON(n >= PMM_MEMORY_TYPES);
+#endif
+
+       /* Figure out where to put new node */
+       for (link = &pmm_mem_types[n].root.rb_node; *link; ) {
+               struct pmm_item *h;
+
+               parent = *link;
+               h = rb_entry(parent, struct pmm_item, by_size_per_type);
+
+               if (size <= h->size)
+                       link = &parent->rb_left;
+               else
+                       link = &parent->rb_right;
+       }
+
+       /* Add new node and rebalance tree. */
+       rb_link_node(&item->by_size_per_type, parent, link);
+       rb_insert_color(&item->by_size_per_type, &pmm_mem_types[n].root);
+}
+
+
+static inline void __pmm_item_erase_by_size  (struct pmm_item *item)
+{
+       unsigned n = 0;
+
+#if PMM_MEMORY_TYPES != 1
+       n = ffs(item->type) - 1;
+       BUG_ON(n >= PMM_MEMORY_TYPES);
+#endif
+
+       rb_erase(&item->by_size_per_type, &pmm_mem_types[n].root);
+}
+
+
+static        void __pmm_item_insert_by_start(struct pmm_item *item)
+{
+       struct rb_node **link, *parent = 0;
+       const size_t start = item->start;
+
+       /* Figure out where to put new node */
+       for (link = &pmm_items.rb_node; *link; ) {
+               struct pmm_item *h;
+
+               parent = *link;
+               h = rb_entry(parent, struct pmm_item, by_start);
+
+               if (start <= h->start)
+                       link = &parent->rb_left;
+               else
+                       link = &parent->rb_right;
+       }
+
+       /* Add new node and rebalance tree. */
+       rb_link_node(&item->by_start, parent, link);
+       rb_insert_color(&item->by_start, &pmm_items);
+}
+
+
+static inline void __pmm_item_erase_by_start (struct pmm_item *item)
+{
+       rb_erase(&item->by_start, &pmm_items);
+}
+
+
+static struct pmm_item *__pmm_hole_take(struct pmm_item *hole,
+                                        size_t size, size_t alignment)
+{
+       struct pmm_item *area;
+
+       /* There are three cases:
+          1. the area takes the whole hole,
+          2. the area is at the begining or at the end of the hole, or
+          3. the area is in the middle of the hole. */
+
+
+       /* Case 1 */
+       if (size == hole->size) {
+               /* Convert hole into area */
+               __pmm_item_erase_by_size(hole);
+               hole->flags &= ~PMM_HOLE;
+               /* A PMM_ITEM_LAST flag is set if we are spliting last hole */
+               return hole;
+       }
+
+
+       /* Allocate */
+       area = kmalloc(sizeof *area, GFP_KERNEL);
+       if (!area)
+               return 0;
+
+       area->start = ALIGN(hole->start, alignment);
+       area->size  = size;
+#if PMM_MEMORY_TYPES != 1
+       area->type  = hole->type;
+#endif
+       /* A PMM_ITEM_LAST flag is set if we are spliting last hole */
+       area->flags = hole->flags & ~PMM_HOLE;
+
+
+       /* If there is to be space before the area or this is a last
+          item in given region try allocating area at the end.  As
+          a side effect, first allocation will be usually from the
+          end but we don't care. ;) */
+       if ((area->start != hole->start || (hole->flags & PMM_ITEM_LAST))
+           && area->start + area->size != hole->start + hole->size) {
+               size_t left =
+                       hole->start + hole->size - area->start - area->size;
+               if (left % alignment == 0)
+                       area->start += left;
+       }
+
+
+       /* Case 2 */
+       if (area->start == hole->start ||
+           area->start + area->size == hole->start + hole->size) {
+               /* Alter hole's size */
+               hole->size -= size;
+               __pmm_item_erase_by_size (hole);
+               __pmm_item_insert_by_size(hole);
+
+               /* Alter hole's start; it does not require updating
+                  the tree */
+               if (area->start == hole->start) {
+                       hole->start += area->size;
+                       area->flags &= ~PMM_ITEM_LAST;
+               } else {
+                       hole->flags &= ~PMM_ITEM_LAST;
+               }
+
+       /* Case 3 */
+       } else {
+               struct pmm_item *next = kmalloc(sizeof *next, GFP_KERNEL);
+               size_t hole_end = hole->start + hole->size;
+
+               if (!next) {
+                       kfree(area);
+                       return 0;
+               }
+
+               /* Alter hole's size */
+               hole->size = area->start - hole->start;
+               hole->flags &= ~PMM_ITEM_LAST;
+               __pmm_item_erase_by_size(hole);
+               __pmm_item_insert_by_size(hole);
+
+               /* Add next hole */
+               next->start = area->start + area->size;
+               next->size  = hole_end - next->start;
+#if PMM_MEMORY_TYPES != 1
+               next->type  = hole->type;
+#endif
+               next->flags = hole->flags;
+               __pmm_item_insert_by_size (next);
+               __pmm_item_insert_by_start(next);
+
+               /* Since there is a hole after this area it (the area) is not
+                  last so clear the flag. */
+               area->flags &= ~PMM_ITEM_LAST;
+       }
+
+
+       /* Add area to the tree */
+       __pmm_item_insert_by_start(area);
+       return area;
+}
+
+
+static void __pmm_hole_merge_maybe(struct rb_node *prev_node,
+                                   struct rb_node *next_node)
+{
+       if (next_node && prev_node) {
+               struct pmm_item *prev, *next;
+               prev = rb_entry(prev_node, struct pmm_item, by_start);
+               next = rb_entry(next_node, struct pmm_item, by_start);
+
+               if ((prev->flags & next->flags & PMM_HOLE) &&
+                   prev->start + prev->size == next->start) {
+                       /* Remove previous hole from trees */
+                       __pmm_item_erase_by_size (prev);
+                       __pmm_item_erase_by_start(prev);
+
+                       /* Alter next hole */
+                       next->size += prev->size;
+                       next->start = prev->start;
+                       __pmm_item_erase_by_size (next);
+                       __pmm_item_insert_by_size(next);
+                       /* No need to update by start tree */
+
+                       /* Free prev hole */
+                       kfree(prev);
+
+                       /* Since we are deleting previous hole adding it to the
+                          next the PMM_ITEM_LAST flag is preserved. */
+               }
+       }
+}
+
+
+static struct pmm_item *__pmm_alloc(struct pmm_mem_type *mem_type,
+                                    size_t size, size_t alignment)
+{
+       struct rb_node *node = mem_type->root.rb_node;
+       struct pmm_item *hole = 0;
+
+       /* Find a smallest hole >= size */
+       while (node) {
+               struct pmm_item *const h =
+                       rb_entry(node, struct pmm_item, by_size_per_type);
+               if (h->size < size)
+                       node = node->rb_right; /* Go to larger holes. */
+               else {
+                       hole = h;              /* This hole is ok ... */
+                       node = node->rb_left;  /* ... but try smaller */
+               }
+       }
+
+       /* Iterate over holes and find first which fits */
+       while (hole) {
+               const size_t start = ALIGN(hole->start, alignment);
+               if (start >=  hole->start &&    /* just in case of overflows */
+                   start < hole->start + hole->size &&
+                   start + size <= hole->start + hole->size)
+                       break;
+               hole = (node = rb_next(&hole->by_size_per_type))
+                       ? rb_entry(node, struct pmm_item, by_size_per_type)
+                       : 0;
+       }
+
+       /* Return */
+       return hole ? __pmm_hole_take(hole, size, alignment) : 0;
+}
+
+
+static struct pmm_item *__pmm_find_area(size_t paddr, const char *msg)
+{
+       struct rb_node  *node = pmm_items.rb_node;
+       struct pmm_item *area;
+
+       /* NULL */
+       if (!paddr)
+               return 0;
+
+       /* Find the area */
+       while (node) {
+               area = rb_entry(node, struct pmm_item, by_start);
+               if (paddr < area->start)
+                       node = node->rb_left;
+               else if (paddr > area->start)
+                       node = node->rb_right;
+               else
+                       break;
+       }
+
+       /* Not found? */
+       if (!node) {
+               printk(KERN_ERR "pmm: %s: area at 0x%08x does not exist\n",
+                      msg, paddr);
+               return 0;
+       }
+
+       /* Not an area but a hole */
+       if (area->flags & PMM_HOLE) {
+               printk(KERN_ERR "pmm: %s: item at 0x%08x is a hole\n",
+                      msg, paddr);
+               return 0;
+       }
+
+       /* Return */
+       return area;
+}
diff --git a/drivers/s3cmm/upbuffer.c b/drivers/s3cmm/upbuffer.c
new file mode 100644
index 0000000..f580a92
--- /dev/null
+++ b/drivers/s3cmm/upbuffer.c
@@ -0,0 +1,608 @@
+/*
+ * Helper functions for accessing userspace memory buffers
+ *
+ * Copyright (c) 2009 Samsung Corp.
+ *
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+#include <asm/io.h>
+#include <asm/page.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/file.h>
+#include <linux/pagemap.h>
+#include <linux/dma-mapping.h>
+#include <asm/memory.h>
+
+#include <linux/s3c/upbuffer.h>
+
+#if ! defined CONFIG_UP_BUFFER_PMM && ! defined CONFIG_UP_BUFFER_DMAC
+#  error "Nighter CONFIG_UP_BUFFER_PMM nor CONFIG_UP_BUFFER_DMAC selected"
+#endif
+
+#if defined CONFIG_UP_BUFFER_PMM
+#  include <linux/s3c/pmm.h>
+#endif
+
+#ifdef CONFIG_UP_BUFFER_DEBUG
+#define debug(fmt,args...) printk(KERN_INFO fmt, ##args)
+#else
+#define debug(fmt,args...)
+#endif
+
+/* ARM specific: PTE_CACHEABLE matches hardware cachable flag */
+#define PTE_CACHEABLE  (1 << 3)
+
+struct upbuf_private {
+       unsigned int flags;
+       unsigned long user_vaddr;
+       unsigned long page_va_first;
+       unsigned long page_pa_first;
+       unsigned long page_offset;
+       unsigned long page_count;
+       unsigned long page_buff_size;
+
+       pid_t pid;
+       union {
+               struct file  *file;
+               struct page **pages;
+       } data;
+
+       int (*sync   )(struct upbuf *upbuf, enum upbuf_direction dir,
+                      unsigned long offset, unsigned long size);
+       int (*release)(struct upbuf *upbuf);
+};
+
+
+/* case 0:
+ * userspace physical memory cannot be directly used (non-continous,
+ * not a real memory, etc)
+ * create shadow buffer and copy data on each sync
+ */
+
+/* TODO: use DMA to copy from/to non-continous userspace buffers (if
+ * possible) */
+static int shadow_buffer_sync(struct upbuf *buf, enum upbuf_direction dir,
+       unsigned long offset, unsigned long size)
+{
+       int res = 0;
+       BUG_ON(!buf->vaddr);
+
+       switch (dir) {
+       case UPBUF_PREPARE_FROM_USER:
+       case UPBUF_PREPARE_MODIFY_USER:
+               res = copy_from_user(buf->vaddr+offset,
+                                    (const void*)buf->priv->user_vaddr+offset,
+                                    size);
+               /* Clean (write back) and invalidate the specified virtual
+                  address range */
+               dmac_flush_range(buf->vaddr, buf->vaddr + size);
+               outer_flush_range(buf->paddr, buf->paddr + size + 1);
+               break;
+
+       case UPBUF_PREPARE_TO_USER:
+               /* Invalidate (discard) the specified virtual address
+                  range. */
+               dmac_inv_range(buf->vaddr, buf->vaddr + size);
+               outer_inv_range(buf->paddr, buf->paddr + size + 1);
+               break;
+
+       case UPBUF_FINISH_TO_USER:
+               res = copy_to_user((void*)(buf->priv->user_vaddr+offset),
+                                  ((char *)buf->vaddr)+offset, size);
+               break;
+
+       default:
+               res = -EINVAL;
+       }
+
+       return res;
+}
+
+
+static int shadow_buffer_release(struct upbuf *buf)
+{
+       debug("shadow_buffer_release\n");
+       BUG_ON(!buf->vaddr);
+
+#if defined CONFIG_UP_BUFFER_PMM
+       pmm_put(buf->paddr);
+#elif defined CONFIG_UP_BUFFER_DMAC
+       dma_free_coherent(NULL, buf->size, buf->vaddr, buf->paddr);
+#endif
+
+       return 0;
+}
+
+
+static int shadow_buffer_prepare(struct upbuf *buf)
+{
+#if defined CONFIG_UP_BUFFER_PMM
+       struct pmm_area_info info;
+#endif
+       unsigned long paddr;
+       void *vaddr;
+
+       debug("Preparing shaddow buffer for virt buffer 0x%08lx, size %ld\n",
+             (long unsigned int)buf->vaddr, buf->size);
+
+#if defined CONFIG_UP_BUFFER_PMM
+       info.magic     = PMM_MAGIC;
+       info.size      = buf->size;
+       info.type      = 0xffff;
+       info.flags     = 0;
+       info.alignment = 0;
+       paddr          = pmm_alloc(&info);
+
+       if (!paddr) {
+               debug("Error: cannot allocate shadow buffer!\n");
+               return -ENOMEM;
+       }
+
+       vaddr = ioremap_cached(paddr, buf->size);
+       if (!vaddr) {
+               debug("Error: cannot map shadow buffer!\n");
+               pmm_put(paddr);
+               return -ENOMEM;
+       }
+       buf->priv->flags |= UPBUF_MAP_KERNEL_DONE;
+#elif defined CONFIG_UP_BUFFER_DMAC
+       vaddr = dma_alloc_coherent(NULL, buf->size, &paddr, GFP_KERNEL);
+       if (!vaddr) {
+               debug("Error: cannot allocate shadow buffer!\n");
+               return -ENOMEM;
+       }
+#endif
+
+       debug("Allocated continous physical memory area: phys addr 0x%08lx, "
+             "virt addr 0x%08lx, size %lx\n",
+             paddr, (unsigned long)vaddr, buf->size);
+
+       buf->paddr               = paddr;
+       buf->vaddr               = vaddr;
+       buf->priv->page_pa_first = paddr;
+#if !defined CONFIG_UP_BUFFER_PMM
+       /* Make sure upbuf_prepare() will map it to kernel space. */
+       buf->priv->flags        |= UPBUF_MAP_KERNEL;
+#endif
+       buf->priv->sync          = shadow_buffer_sync;
+       buf->priv->release       = shadow_buffer_release;
+       return 0;
+}
+
+
+
+/* case 1:
+ * physical memory mapped directly into userspace vma, VM_PFNMAP flag is set,
+ * this mapping is done as mmaping special (device) file (i.e. /dev/fb0)
+ */
+
+static int direct_common_sync(struct upbuf *b, enum upbuf_direction dir,
+                              int usermem, unsigned long offset,
+                              unsigned long size)
+{
+       const struct upbuf_private *const priv = b->priv;
+       char *vaddr = b->vaddr ? b->vaddr : (void*)priv->user_vaddr;
+       unsigned long paddr = b->paddr;
+       int res = 0;
+
+       vaddr += offset;
+       paddr += offset;
+
+       switch (dir) {
+       case UPBUF_PREPARE_FROM_USER:
+               /* Clean (write back) and invalidate the specified virtual
+                  address range */
+               dmac_clean_range(vaddr, vaddr + size);
+               outer_flush_range(paddr, paddr + size + 1);
+               break;
+
+       case UPBUF_PREPARE_TO_USER:
+               /* Invalidate (discard) the specified virtual address
+                  range. */
+               dmac_inv_range(vaddr, vaddr + size);
+               outer_inv_range(paddr, paddr + size + 1);
+               break;
+
+       case UPBUF_PREPARE_MODIFY_USER:
+               /* Clean and invalidate (discard) the specified
+                  virtual address range. */
+               dmac_flush_range(vaddr, vaddr + size);
+               outer_flush_range(paddr, paddr + size + 1);
+               break;
+
+       case UPBUF_FINISH_TO_USER:
+               if (usermem) {
+                       struct page **pages = priv->data.pages;
+                       int i, start, end;
+                       start = (priv->page_offset + offset) >> PAGE_SHIFT;
+                       end = (priv->page_offset + offset + size + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+                       for (i = start; i <= end; ++i)
+                               if (!PageReserved(pages[i]))
+                                       SetPageDirty(pages[i]);
+               }
+               break;
+
+       default:
+               res = -EINVAL;
+       }
+       return res;
+}
+
+static int direct_pfn_sync(struct upbuf *b, enum upbuf_direction dir,
+                           unsigned long offset, unsigned long size)
+{
+       return direct_common_sync(b, dir, 0, offset, size);
+}
+
+static int direct_pfn_release(struct upbuf *b)
+{
+       debug("direct_pfn_release\n");
+       BUG_ON(!b->priv->data.file);
+
+       /* decrement file use count */
+       fput(b->priv->data.file);
+       b->priv->data.file = 0;
+
+       return 0;
+}
+
+static int get_pte(struct vm_area_struct *vma, unsigned long address,
+                   unsigned int flags, pte_t *dst)
+{
+       pgd_t *pgd;
+       pud_t *pud;
+       pmd_t *pmd;
+       pte_t *pte;
+//     spinlock_t *ptl;
+
+       pgd = pgd_offset(vma->vm_mm, address);
+       if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+               goto no_page_table;
+
+       pud = pud_offset(pgd, address);
+       if (pud_none(*pud) || unlikely(pgd_bad(*pud)))
+               goto no_page_table;
+
+       pmd = pmd_offset(pud, address);
+       if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
+               goto no_page_table;
+
+       pte = pte_offset_map(pmd, address);
+//     pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
+       if (!pte_present(*pte))
+               goto unlock;
+       *dst = *pte;
+
+//     pte_unmap_unlock(ptep, ptl);
+       return 0;
+
+unlock:
+//     pte_unmap_unlock(ptep, ptl);
+no_page_table:
+       return -EFAULT;
+}
+
+#define pte_phys(x) (pte_val(x) & PAGE_MASK)
+
+static int direct_pfn_prepare(struct upbuf *b, struct vm_area_struct *vma)
+{
+       struct upbuf_private *priv = b->priv;
+       unsigned long start, base;
+       int page_count, i, res;
+       pte_t pte;
+
+       debug("direct_pfn_prepare\n");
+
+       if (!(vma->vm_flags & VM_PFNMAP) || !vma->vm_file) {
+               return -EINVAL;
+       }
+
+       page_count = priv->page_count;
+       BUG_ON(!page_count);
+
+       debug("Direct PFN mapping found, "
+             "using special file reference counter.\n");
+
+       /* increment vma file use count before hacking with pte map */
+       get_file(vma->vm_file);
+
+       start = priv->page_va_first;
+       res   = get_pte(vma, start, 0, &pte);
+       if (res < 0)
+               goto error;
+       base  = pte_phys(pte);
+
+#ifndef UP_BUFFER_NO_PFN_CHECK
+       /* Validate PTEs, check if continiuous area */
+       for (i = 1; i < page_count; ++i) {
+               res   = get_pte(vma, start + PAGE_SIZE * i, 0, &pte);
+               if (res < 0)
+                       goto error;
+               if (pte_phys(pte) != base + PAGE_SIZE * i) {
+                       res = -EINVAL;
+                       goto error;
+               }
+       } while (++i < page_count);
+#endif
+       /* Success */
+       debug("Found buffer that is continous physical memory area: "
+             "vaddr (userspace) 0x%08lx, phys 0x%08lx, size %ld, pte %08lx\n",
+             start, base, b->size, pte);
+       priv->page_pa_first = base;
+       b->paddr            = priv->page_pa_first + priv->page_offset;
+       priv->data.file     = vma->vm_file;
+       priv->sync          = direct_pfn_sync;
+       priv->release       = direct_pfn_release;
+       debug("vma = %p, vma->vm_file = %p\n", (void*)vma, (void*)vma->vm_file);
+
+       if ((pte & PTE_CACHEABLE) == 0) {
+               priv->flags |= UPBUF_NO_CACHE;
+               debug("vma area is not CPU cached, using noop sync()\n");
+       }
+       return 0;
+
+error:
+       fput(vma->vm_file);
+       return res;
+}
+
+/* ************ */
+
+/* case 2:
+ * normal process memory, struct page * available for every page, this
+ * can be either stack or heap, usualy can be continous only if size
+ * <= single page,
+ */
+
+static int direct_usermem_sync(struct upbuf *b, enum upbuf_direction dir,
+                               unsigned long offset, unsigned long size)
+{
+       return direct_common_sync(b, dir, 1, offset, size);
+}
+
+static int direct_usermem_release(struct upbuf *b)
+{
+       struct upbuf_private *priv = b->priv;
+       struct page **pages = priv->data.pages;
+       int i = priv->page_count;
+
+       debug("direct_usermem_release\n");
+       BUG_ON(pages == NULL || i == 0);
+
+       do {
+               page_cache_release(*pages);
+               ++pages;
+       } while (--i);
+
+       kfree(priv->data.pages);
+       priv->data.pages = 0;
+
+       return 0;
+}
+
+static int direct_usermem_prepare(struct upbuf *b)
+{
+       struct upbuf_private *priv = b->priv;
+       int page_count = priv->page_count;
+       struct page **pages;
+       unsigned long page_base;
+       int res = 0;
+       int i;
+
+       debug("direct_usermem_prepare\n");
+
+       pages = kmalloc(page_count * sizeof(struct page*), GFP_KERNEL);
+       if (pages == NULL)
+               return -ENOMEM;
+
+       res = get_user_pages(current, current->mm, priv->page_va_first,
+                            page_count, 1, 1, pages, NULL);
+       if (res != page_count) {
+               page_count = res;
+               res = -EINVAL;
+               goto free;
+       }
+
+       page_base = page_to_pfn(pages[0]);
+       for (i = 1; i < page_count; i++)
+               if (page_to_pfn(pages[i]) != page_base + i) {
+                       debug("This userspace memory is not continous\n");
+                       res = -EINVAL;
+                       goto free;
+               }
+
+       /* Success */
+       debug("Found userspace buffer that is continous physical memory area: "
+             "vaddr (userspace) 0x%08lx, phys 0x%08lx, size %ld\n",
+             priv->page_va_first, page_base << PAGE_SHIFT, b->size);
+       priv->page_pa_first = page_base << PAGE_SHIFT;
+       b->paddr            = priv->page_pa_first + priv->page_offset;
+       priv->data.pages    = pages;
+       priv->sync          = direct_usermem_sync;
+       priv->release       = direct_usermem_release;
+       return 0;
+
+free:
+       for (i = 0; i < page_count; i++)
+               page_cache_release(pages[i]);
+       kfree(pages);
+
+       return res;
+}
+
+/* ************ */
+
+int upbuf_prepare(struct upbuf *buf, unsigned long vaddr, unsigned long size,
+                  enum upbuf_flags flags)
+{
+       struct vm_area_struct *vma;
+       struct upbuf_private *priv;
+       unsigned int page_va_last;
+       void *kernel_vaddr;
+       int res;
+
+       BUG_ON(buf == NULL || current == NULL);
+
+       debug("upbuf_prepare: vaddr 0x%08lx, size 0x%ld, flags %d\n",
+             vaddr, size, flags);
+
+
+       /* Get the VMA */
+       vma = find_extend_vma(current->mm, vaddr);
+       debug("vma: %p\n", vma);
+       if (!vma)
+               return -EFAULT;
+
+
+       /* Init structure */
+       priv = kmalloc(sizeof *priv, GFP_KERNEL);
+       if (!priv)
+               return -ENOMEM;
+
+       buf->size            = size;
+       buf->paddr           = 0;
+       buf->vaddr           = 0;
+       buf->priv            = priv;
+       priv->flags          = flags;
+       priv->user_vaddr     = vaddr;
+       priv->page_offset    = vaddr & ~PAGE_MASK;
+       priv->page_va_first  = vaddr &  PAGE_MASK;
+       page_va_last         = (vaddr + size - 1) & PAGE_MASK;
+       priv->page_count     =
+               ((page_va_last - priv->page_va_first) >> PAGE_SHIFT) + 1;
+       priv->page_buff_size = priv->page_count << PAGE_SHIFT;
+       priv->pid            = current->pid;
+       priv->sync           = 0;
+       priv->release        = 0;
+
+
+       /* Try direct mappings */
+       if (vma->vm_end >= vaddr + size) {
+               res = direct_pfn_prepare(buf, vma);
+               if (res == 0)
+                       goto map_kernel;
+
+               res = direct_usermem_prepare(buf);
+               if (res == 0)
+                       goto map_kernel;
+       } else {
+               debug("Virtual area from 0x%08lx + 0x%08lx does not belong "
+                     "to single vm_area, cannot map it directly!\n",
+                     vaddr, size);
+       }
+
+       /* If direct mappings failed, try shadow buffer */
+       if (flags & UPBUF_NO_SHADOW) {
+               res = -EINVAL;
+               goto error_free;
+       }
+
+       res = shadow_buffer_prepare(buf);
+       if (res)
+               goto error_free;
+
+
+       /* We have a buffer prepared -- do we need to map it? */
+map_kernel:
+       if (buf->vaddr == NULL && (flags & UPBUF_MAP_KERNEL)) {
+               kernel_vaddr = ioremap_cached(buf->paddr, size);
+               if (!kernel_vaddr) {
+                       res = -ENOMEM;
+                       goto error_release;
+               }
+
+               debug("Buffer is at 0x%p in kernel space.\n", kernel_vaddr);
+               buf->vaddr        = kernel_vaddr;
+               buf->priv->flags |= UPBUF_MAP_KERNEL_DONE;
+       }
+       return 0;
+
+
+       /* Failed */
+error_release:
+       if (priv->release)
+               priv->release(buf);
+error_free:
+       kfree(buf->priv);
+       buf->priv = 0;
+       return res;
+
+}
+EXPORT_SYMBOL(upbuf_prepare);
+
+
+int upbuf_sync(struct upbuf *buf, enum upbuf_direction dir)
+{
+       BUG_ON(buf == NULL || buf->priv == NULL);
+       BUG_ON(current == NULL || in_interrupt());
+       /* FIX ME: add a check if the process context is valid */
+       /*debug("upbuf_sync direction %d\n", dir);*/
+       if (buf->priv->flags & UPBUF_NO_CACHE)
+               return 0;
+       return buf->priv->sync ? buf->priv->sync(buf, dir, 0, buf->size) : 0;
+}
+EXPORT_SYMBOL(upbuf_sync);
+
+
+int upbuf_sync_range(struct upbuf *buf, enum upbuf_direction dir,
+                     unsigned long offset, unsigned long size)
+{
+       BUG_ON(buf == NULL || buf->priv == NULL);
+       BUG_ON(current == NULL || in_interrupt());
+       /* FIX ME: add a check if the process context is valid */
+       debug("upbuf_sync direction %d, offset %ld, size %ld\n", dir, offset, size);
+
+       if (offset == 0 && size == 0)
+               size = buf->size;
+       if (offset > buf->size || offset+size > buf->size)
+               return -EINVAL;
+
+       if (buf->priv->flags & UPBUF_NO_CACHE)
+               return 0;
+       return buf->priv->sync ? buf->priv->sync(buf, dir, offset, size) : 0;
+}
+EXPORT_SYMBOL(upbuf_sync_range);
+
+
+int upbuf_release(struct upbuf *buf)
+{
+       int res = 0;
+       BUG_ON(buf == NULL || buf->priv == NULL);
+       /* BUG_ON(current == NULL || buf->priv->pid != current->pid); */
+       debug("upbuf_release\n");
+
+       if (buf->priv->release)
+               res = buf->priv->release(buf);
+
+       if ((buf->priv->flags & UPBUF_MAP_KERNEL_DONE) && buf->vaddr) {
+               iounmap(buf->vaddr);
+               buf->vaddr = 0;
+               buf->priv->flags &= ~UPBUF_MAP_KERNEL_DONE;
+       }
+
+       if (res == 0) {
+               kfree(buf->priv);
+               buf->size  = 0;
+               buf->paddr = 0;
+               buf->vaddr = 0;
+               buf->priv  = 0;
+       }
+       return res;
+}
+EXPORT_SYMBOL(upbuf_release);
diff --git a/include/linux/s3c/pmm.h b/include/linux/s3c/pmm.h
new file mode 100644
index 0000000..7fcd266
--- /dev/null
+++ b/include/linux/s3c/pmm.h
@@ -0,0 +1,141 @@
+#ifndef __KERNEL_PMM_H
+#define __KERNEL_PMM_H
+
+/** @file
+ * Physical Memory Managment module.
+ * Copyright (c) 2009 by Samsung Electronics.  All rights reserved.
+ * @author Michal Nazarewicz (mina86@mina86.com)
+ */
+
+
+#include <linux/ioctl.h>
+
+#include <mach/pmm-plat.h> /* Definition of platform dependend memory types. */
+
+
+
+/** An information about area exportable to user space. */
+struct pmm_area_info {
+       unsigned magic;      /**< Magic number (must be PMM_MAGIC) */
+       size_t   size;       /**< Size of the area */
+       unsigned type;       /**< Memory's type */
+       unsigned flags;      /**< Flags */
+       size_t   alignment;  /**< Area's alignment as a power of two */
+};
+
+/** PMM Area's flags.  See pmm_area_info structure. */
+enum {
+       PMM_NO_CACHE  = 1 << 0  /**< Map as no-cached region */
+};
+
+/** Accepted values of pmm_area_info::flags field. */
+#define PMM_KNOWN_FLAGS        (PMM_NO_CACHE)
+
+/** Value of pmm_area_info::magic field. */
+#define PMM_MAGIC (('p' << 24) | ('M' << 16) | ('m' << 8) | 0x42)
+
+
+/**
+ * Allocates area.  Accepts struct pmm_area_info as in/out
+ * argument.  Meaning of each field is as follows:
+ * - @c size     size in bytes of desired area.
+ * - @c type     mask of types to allocate from
+ * - @c flags    additional flags (no flags defined yet)
+ * - @c alignment area's alignment as a power of two
+ * Returns area's key or -1 on error.
+ */
+#define IOCTL_PMM_ALLOC    _IOWR('p', 0, struct pmm_area_info)
+
+
+/** Parameters passed to @c IOCTL_PMM_SHMGET call. */
+struct pmm_shm_info {
+       unsigned magic;      /**< Magic number (must be PMM_MAGIC) */
+       key_t    key;        /**< IPC shared memory key. */
+       int      shmflg;     /**< IPC shared memory flags. */
+};
+
+/**
+ * Converts a PMM area into a System V IPC shared memory.  Accepts
+ * struct pmm_shm_info as an argument.  This structure has two fields:
+ * @c key and @c shmflg.  Meaning of those arguments are the same as
+ * arguments for @c shmget(2) system call.  Note that @c IPC_CREAT and
+ * @c IPC_EXCL flags are implied.
+ */
+#define IOCTL_PMM_SHMGET   _IOR('p', 0, struct pmm_shm_info)
+
+
+
+
+#if __KERNEL__
+
+
+#include <linux/mutex.h>       /* Mutexes */
+
+
+
+/**
+ * Allocates continuous block of memory.  Allocated area must be
+ * released (@see pmm_release()) when code no longer uses it.
+ * Arguments to the function are passed in a pmm_area_info
+ * structure (which see).  Meaning of each is described below:
+ *
+ * @a info->u.size specifies how large the area shall be.  It must
+ * be page aligned.
+ *
+ * @a info->u.type is a bitwise OR of all memory types that should be
+ * tried.  The module may define several types of memory and user
+ * space programs may desire to allocate areas of different types.
+ * This attribute specifies what types user space tool is interested
+ * in.  Area will be allocated in first type that had enough space.
+ *
+ * @a info->u.flags is a bitwise OR of additional flags.  None are
+ * defined as of yet.
+ *
+ * @a info->u.alignment specifies size alignment of a physical
+ * address of the area.  It must be power of two or zero.  If given,
+ * physical address will be a multiple of that value.  In fact, the
+ * area may have a bigger alignment -- the final alignment will be saved
+ * in info structure.
+ *
+ * If the area is allocated sucesfully @a info is filled with
+ * information about the area.
+ *
+ * @param  info    input/output argument
+ * @return area's physical address or zero on error
+ */
+__must_check
+size_t pmm_alloc      (struct pmm_area_info *info);
+
+
+/**
+ * Increases PMM's area reference counter.
+ * @param  addr block's physical address.
+ * @return zero on success, negative on error
+ */
+int    pmm_get        (size_t paddr);
+
+/**
+ * Decreases PMM's area reference counter and possibly frees it if it
+ * reaches zero.
+ *
+ * @param  addr block's physical address.
+ * @return zero on success, negative on error
+ */
+int    pmm_put        (size_t paddr);
+
+
+
+#if defined __KERNEL_PMM_INSIDE
+
+typedef int    (*pmm_add_region_func )(size_t paddr, size_t size,
+                                       unsigned type, unsigned flags);
+
+/** Defined by platform, used by pmm_module_init(). */
+void pmm_module_platform_init(pmm_add_region_func add_region);
+
+#endif /* __KERNEL_PMM_INSIDE */
+
+
+#endif /* __KERNEL__ */
+
+#endif /* __KERNEL_PMM_H */
diff --git a/include/linux/s3c/upbuffer.h b/include/linux/s3c/upbuffer.h
new file mode 100644
index 0000000..00c404c
--- /dev/null
+++ b/include/linux/s3c/upbuffer.h
@@ -0,0 +1,131 @@
+/*
+ * Helper functions for accessing userspace memory buffers
+ *
+ * Copyright (c) 2009 Samsung Corp.
+ *
+ * Author: Marek Szyprowski <m.szyprowski@samsung.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ *
+ */
+
+#ifndef UP_BUFFER_H
+#define UP_BUFFER_H
+
+#include <linux/types.h>
+
+enum upbuf_flags {
+       UPBUF_ANY = 0,
+       UPBUF_NO_SHADOW = 1<<1,         /* don't create shadow buffer, fail instead */
+       UPBUF_MAP_KERNEL = 1<<2,        /* create virtual address mapping in kernel space */
+
+       /* private flags */
+       UPBUF_MAP_KERNEL_DONE = 1<<16,  /* virtual address mapping in kernel space sucessfully created*/
+       UPBUF_NO_CACHE = 1<<17, /* area is not cpu cached, no need for syncing */
+};
+
+enum upbuf_direction {
+       UPBUF_PREPARE_FROM_USER,
+       UPBUF_PREPARE_TO_USER,
+       UPBUF_PREPARE_MODIFY_USER,
+       UPBUF_FINISH_TO_USER,
+};
+
+
+struct upbuf_private;
+
+
+struct upbuf {
+       /* Buffer size */
+       unsigned long size;
+
+       /* Physical address */
+       unsigned long paddr;
+
+       /* Virtual addres (kernel space) */
+       void *vaddr;
+
+       /* Private upbuffer data, do not touch. */
+       struct upbuf_private *priv;
+};
+
+/*
+ * All function must be called with valid current process pointer.
+ * Do not call them from interrupts or kernel threads!
+ */
+
+/** upbuf_prepare()
+ * @upbuf: structure to fill with buffer info data
+ * @u_vaddr: userspace virtual address of the buffer
+ * @size: buffer size
+ * @flags: see upbuf_flags enum
+ *
+ * This function prepares a userspace buffer: find the physical memory
+ * that is occupied by the passed userspace pointer and size pairs.
+ *
+ * If the userspace memory cannot be used directly (i.e. it is not
+ * continuous), a shadow buffer might be created (UPBUF_NO_SHADOW flag
+ * disables this).
+ *
+ * After sucessful call a transladed physical memory address is available
+ * in upbuf->paddr.
+ *
+ * An optional buffer mapping into kernel virtual address space can be
+ * made by passing UPBUF_MAP_KERNEL flag. A kernel virual address of a
+ * buffer is in upbuf->vaddr.
+ *
+ * Returns zero on success, else negative errno.
+ */
+int __must_check upbuf_prepare(struct upbuf *upbuf, unsigned long u_vaddr, unsigned long size, enum upbuf_flags flags);
+
+/** upbuf_sync()
+ * @upbuf: structure with buffer info data filled
+ * @dir: synchronisation direction, see upbuf_flags enum
+ *
+ * Any buffer must be properly synchronised before and after it is used
+ * by a DMA hardware. This results in flushing/invalidating cpu caches
+ * or/and performing a memory copy if shadow buffer is used.
+ *
+ * Available synchronisation directions before DMA transaction:
+ * UPBUF_PREPARE_FROM_USER: DMA hardware will READ data from user buffer
+ * UPBUF_PREPARE_TO_USER: DMA hardware will WRITE data to user buffer
+ * UPBUF_PREPARE_MODIFY_USER: DMA hardware will MODIFY data in user buffer
+ *
+ * Available synchronisation directions after DMA transaction:
+ * UPBUF_FINISH_TO_USER: DMA hardware wrote or modified data to/in user buffer
+ *
+ * Returns zero on success, else negative errno.
+ */
+int __must_check upbuf_sync(struct upbuf *upbuf, enum upbuf_direction dir);
+
+/** upbuf_sync_range()
+ * @upbuf: structure with buffer info data filled
+ * @dir: synchronisation direction, see upbuf_flags enum
+ * @offset: offset (in bytes) from start of the buffer
+ * @size: number of bytes to sync
+ *
+ * This function synchronises only a specified range of the buffer,
+ * usefull if one buffer is used as many logical buffers.
+ *
+ * See upbuf_sync() for further information.
+ *
+ * Returns zero on success, else negative errno.
+ */
+int __must_check upbuf_sync_range(struct upbuf *upbuf, enum upbuf_direction dir, unsigned long offset, unsigned long size);
+
+/** upbuf_release()
+ * @upbuf: structure with buffer info data filled
+ *
+ * Free all structures associated with buffer and unlock userspace memory.
+ * All not synchronized changes are might be lost.
+ *
+ * Note that @upbuf cannot be NULL!
+ *
+ * Returns zero on success, else negative errno.
+ */
+int upbuf_release(struct upbuf *upbuf);
+
+#endif /* UP_BUFFER_H */
+
diff --git a/ipc/shm.c b/ipc/shm.c
index 9eb1488..af4519a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -810,6 +810,10 @@ out:
  */
 long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
 {
+#if defined CONFIG_PMM_SHM
+       extern struct file_operations pmm_fops;
+#endif
+
        struct shmid_kernel *shp;
        unsigned long addr;
        unsigned long size;
@@ -881,7 +885,14 @@ long do_shmat(int shmid, char __user *shmaddr, int shmflg, ulong *raddr)
        path.dentry = dget(shp->shm_file->f_path.dentry);
        path.mnt    = shp->shm_file->f_path.mnt;
        shp->shm_nattch++;
-       size = i_size_read(path.dentry->d_inode);
+
+#if defined CONFIG_PMM_SHM
+       if (shp->shm_file->f_op == &pmm_fops)
+               size = *(size_t *)shp->shm_file->private_data;
+       else
+#endif
+               size = i_size_read(path.dentry->d_inode);
+
        shm_unlock(shp);

        err = -ENOMEM;
@@ -969,6 +980,10 @@ SYSCALL_DEFINE3(shmat, int, shmid, char __user *, shmaddr, int, shmflg)
  */
 SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
 {
+#if defined CONFIG_PMM_SHM
+       extern struct file_operations pmm_fops;
+#endif
+
        struct mm_struct *mm = current->mm;
        struct vm_area_struct *vma;
        unsigned long addr = (unsigned long)shmaddr;
@@ -1018,7 +1033,12 @@ SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
                        (vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff) {


-                       size = vma->vm_file->f_path.dentry->d_inode->i_size;
+#if defined CONFIG_PMM_SHM
+                       if (shm_file_data(vma->vm_file)->file->f_op == &pmm_fops)
+                               size = *(size_t *)vma->vm_file->private_data;
+                       else
+#endif
+                               size = vma->vm_file->f_path.dentry->d_inode->i_size;
                        do_munmap(mm, vma->vm_start, vma->vm_end - vma->vm_start);
                        /*
                         * We discovered the size of the shm segment, so
diff --git a/mm/shmem.c b/mm/shmem.c
index ccf446a..31513ad 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2608,13 +2608,8 @@ int shmem_lock(struct file *file, int lock, struct user_struct *user)

 /* common code */

-/**
- * shmem_file_setup - get an unlinked file living in tmpfs
- * @name: name for dentry (to be seen in /proc/<pid>/maps
- * @size: size to be set for the file
- * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
- */
-struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
+static struct file *__shmem_file_setup(const char *name, loff_t size,
+                                       unsigned long flags, int pmm_area)
 {
        int error;
        struct file *file;
@@ -2625,11 +2620,13 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
        if (IS_ERR(shm_mnt))
                return (void *)shm_mnt;

-       if (size < 0 || size > SHMEM_MAX_BYTES)
-               return ERR_PTR(-EINVAL);
+       if (!pmm_area) {
+               if (size < 0 || size > SHMEM_MAX_BYTES)
+                       return ERR_PTR(-EINVAL);

-       if (shmem_acct_size(flags, size))
-               return ERR_PTR(-ENOMEM);
+               if (shmem_acct_size(flags, size))
+                       return ERR_PTR(-ENOMEM);
+       }

        error = -ENOMEM;
        this.name = name;
@@ -2657,9 +2654,11 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
                  &shmem_file_operations);

 #ifndef CONFIG_MMU
-       error = ramfs_nommu_expand_for_mapping(inode, size);
-       if (error)
-               goto close_file;
+       if (!pmm_area) {
+               error = ramfs_nommu_expand_for_mapping(inode, size);
+               if (error)
+                       goto close_file;
+       }
 #endif
        ima_counts_get(file);
        return file;
@@ -2669,11 +2668,37 @@ close_file:
 put_dentry:
        dput(dentry);
 put_memory:
-       shmem_unacct_size(flags, size);
+       if (!pmm_area)
+               shmem_unacct_size(flags, size);
        return ERR_PTR(error);
 }
+
+/**
+ * shmem_file_setup - get an unlinked file living in tmpfs
+ * @name: name for dentry (to be seen in /proc/<pid>/maps
+ * @size: size to be set for the file
+ * @flags: VM_NORESERVE suppresses pre-accounting of the entire object size
+ */
+struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags)
+{
+       return __shmem_file_setup(name, size, flags, 0);
+}
 EXPORT_SYMBOL_GPL(shmem_file_setup);

+
+#if defined CONFIG_PMM_SHM
+
+/*
+ * PMM uses this function when converting a PMM area into a System
+ * V shared memory.
+ */
+struct file *shmem_pmm_file_setup(char *name, loff_t size)
+{
+       return __shmem_file_setup(name, size, 0, 1);
+}
+
+#endif
+
 /**
  * shmem_zero_setup - setup a shared anonymous mapping
  * @vma: the vma to be mmapped is prepared by do_mmap_pgoff
--
1.6.4


Best regards
--
Marek Szyprowski
Samsung Poland R&D Center
