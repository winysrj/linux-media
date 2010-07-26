Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20949 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab0GZOKc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jul 2010 10:10:32 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 26 Jul 2010 16:11:42 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <743102607e2c5fb20e3c0676fadbcb93d501a78e.1280151963.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Hiremath Vaibhav <hvaibhav@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Pawel Osciak <p.osciak@samsung.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Daniel Walker <dwalker@codeaurora.org>,
	Jonathan Corbet <corbet@lwn.net>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Zach Pfeffer <zpfeffer@codeaurora.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <dc4bdf3e0b02c0ac4770927f72b6cbc3f0b486a2.1280151963.git.m.nazarewicz@samsung.com>
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <743102607e2c5fb20e3c0676fadbcb93d501a78e.1280151963.git.m.nazarewicz@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Contiguous Memory Allocator framework is a set of APIs for
allocating physically contiguous chunks of memory.

Various chips require contiguous blocks of memory to operate.  Those
chips include devices such as cameras, hardware video decoders and
encoders, etc.

The code is highly modular and customisable to suit the needs of
various users.  Set of regions reserved for CMA can be configured on
run-time and it is easy to add custom allocator algorithms if one
has such need.

For more details see Documentation/contiguous-memory.txt.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Pawel Osciak <p.osciak@samsung.com>
---
 Documentation/00-INDEX                             |    2 +
 .../ABI/testing/sysfs-kernel-mm-contiguous         |    9 +
 Documentation/contiguous-memory.txt                |  646 +++++++++++
 Documentation/kernel-parameters.txt                |    4 +
 include/linux/cma.h                                |  445 ++++++++
 mm/Kconfig                                         |   34 +
 mm/Makefile                                        |    3 +
 mm/cma-best-fit.c                                  |  407 +++++++
 mm/cma.c                                           | 1170 ++++++++++++++++++++
 9 files changed, 2720 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-contiguous
 create mode 100644 Documentation/contiguous-memory.txt
 create mode 100644 include/linux/cma.h
 create mode 100644 mm/cma-best-fit.c
 create mode 100644 mm/cma.c

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
index 5405f7a..bb50209 100644
--- a/Documentation/00-INDEX
+++ b/Documentation/00-INDEX
@@ -94,6 +94,8 @@ connector/
 	- docs on the netlink based userspace<->kernel space communication mod.
 console/
 	- documentation on Linux console drivers.
+contiguous-memory.txt
+	- documentation on physically-contiguous memory allocation framework.
 cpu-freq/
 	- info on CPU frequency and voltage scaling.
 cpu-hotplug.txt
diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-contiguous b/Documentation/ABI/testing/sysfs-kernel-mm-contiguous
new file mode 100644
index 0000000..05e2f6a
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-contiguous
@@ -0,0 +1,9 @@
+What:		/sys/kernel/mm/contiguous/
+Date:		July 2008
+Contact:	Michal Nazarewicz <m.nazarewicz@samsung.com>
+Description:
+		/sys/kernel/mm/contiguous/ contains two files: asterisk and
+		map.  They are used to configure the Contiguous Memory
+		Allocator framework.
+
+		For details see Documentation/contiguous-memory.txt.
diff --git a/Documentation/contiguous-memory.txt b/Documentation/contiguous-memory.txt
new file mode 100644
index 0000000..6eb1295
--- /dev/null
+++ b/Documentation/contiguous-memory.txt
@@ -0,0 +1,646 @@
+                                                             -*- org -*-
+
+* Contiguous Memory Allocator
+
+   The Contiguous Memory Allocator (CMA) is a framework, which allows
+   setting up a machine-specific configuration for physically-contiguous
+   memory management. Memory for devices is then allocated according
+   to that configuration.
+
+   The main role of the framework is not to allocate memory, but to
+   parse and manage memory configurations, as well as to act as an
+   in-between between device drivers and pluggable allocators. It is
+   thus not tied to any memory allocation method or strategy.
+
+** Why is it needed?
+
+    Various devices on embedded systems have no scatter-getter and/or
+    IO map support and as such require contiguous blocks of memory to
+    operate.  They include devices such as cameras, hardware video
+    decoders and encoders, etc.
+
+    Such devices often require big memory buffers (a full HD frame is,
+    for instance, more then 2 mega pixels large, i.e. more than 6 MB
+    of memory), which makes mechanisms such as kmalloc() ineffective.
+
+    Some embedded devices impose additional requirements on the
+    buffers, e.g. they can operate only on buffers allocated in
+    particular location/memory bank (if system has more than one
+    memory bank) or buffers aligned to a particular memory boundary.
+
+    Development of embedded devices have seen a big rise recently
+    (especially in the V4L area) and many such drivers include their
+    own memory allocation code. Most of them use bootmem-based methods.
+    CMA framework is an attempt to unify contiguous memory allocation
+    mechanisms and provide a simple API for device drivers, while
+    staying as customisable and modular as possible.
+
+** Design
+
+    The main design goal for the CMA was to provide a customisable and
+    modular framework, which could be configured to suit the needs of
+    individual systems.  Configuration specifies a list of memory
+    regions, which then are assigned to devices.  Memory regions can
+    be shared among many device drivers or assigned exclusively to
+    one.  This has been achieved in the following ways:
+
+    1. The core of the CMA does not handle allocation of memory and
+       management of free space.  Dedicated allocators are used for
+       that purpose.
+
+       This way, if the provided solution does not match demands
+       imposed on a given system, one can develop a new algorithm and
+       easily plug it into the CMA framework.
+
+       The presented solution includes an implementation of a best-fit
+       algorithm.
+
+    2. CMA allows a run-time configuration of the memory regions it
+       will use to allocate chunks of memory from.  The set of memory
+       regions is given on command line so it can be easily changed
+       without the need for recompiling the kernel.
+
+       Each region has it's own size, alignment demand, a start
+       address (physical address where it should be placed) and an
+       allocator algorithm assigned to the region.
+
+       This means that there can be different algorithms running at
+       the same time, if different devices on the platform have
+       distinct memory usage characteristics and different algorithm
+       match those the best way.
+
+    3. When requesting memory, devices have to introduce themselves.
+       This way CMA knows who the memory is allocated for.  This
+       allows for the system architect to specify which memory regions
+       each device should use.
+
+       3a. Devices can also specify a "kind" of memory they want.
+           This makes it possible to configure the system in such
+           a way, that a single device may get memory from different
+           memory regions, depending on the "kind" of memory it
+           requested.  For example, a video codec driver might want to
+           allocate some shared buffers from the first memory bank and
+           the other from the second to get the highest possible
+           memory throughput.
+
+    4. For greater flexibility and extensibility, the framework allows
+       device drivers to register private regions of reserved memory
+       which then may be used only by them.
+
+       As an effect, if a driver would not use the rest of the CMA
+       interface, it can still use CMA allocators and other
+       mechanisms.
+
+       4a. Early in boot process, device drivers can also request the
+           CMA framework to a reserve a region of memory for them
+           which then will be used as a private region.
+
+           This way, drivers do not need to directly call bootmem,
+           memblock or similar early allocator but merely register an
+           early region and the framework will handle the rest
+           including choosing the right early allocator.
+
+** Use cases
+
+    Lets analyse some imaginary system that uses the CMA to see how
+    the framework can be used and configured.
+
+
+    We have a platform with a hardware video decoder and a camera each
+    needing 20 MiB of memory in worst case.  Our system is written in
+    such a way though that the two devices are never used at the same
+    time and memory for them may be shared.  In such a system the
+    following two configuration strings would be used:
+
+        static char regions[]  __initdata = "region=20M";
+        static char map[]      __initdata = "video,camera=region";
+
+        cma_set_defaults(regions, map, NULL);
+
+    .regions instructs CMA to allocate a region of 20 MiB and use the
+    first available memory allocator on it.  .map says that drivers
+    named "video" and "camera" are to be granted memory from the
+    previously defined region.
+
+    This can in fact be written in simpler way:
+
+        static       char regions[]  __initdata = "region=20M";
+
+        cma_set_defaults(regions, NULL, NULL);
+
+    By omitting the .map attribute, we say that all drivers are to use
+    all the regions defined with the first argument.  Generally, if
+    a device/kind pair is not matched by any rule from the .map it is
+    granted access to all regions from the .regions attribute.
+
+    We can see, that because the devices share the same region of
+    memory, we save 20 MiB of memory, compared to the situation when
+    each of the devices would reserve 20 MiB of memory for itself.
+
+
+    Now, let say that we have also many other smaller devices and we
+    want them to share some smaller pool of memory.  For instance 5
+    MiB.  This can be achieved in several ways:
+
+        static char regions[]  __initdata = "region=20M;common=5M";
+        static char map[]      __initdata =
+                "video,camera=region;*/*=common";
+
+        cma_set_defaults(regions, map, NULL);
+
+    This instructs CMA to reserve two regions and let video and camera
+    use region "region" whereas all other devices should use region
+    "common".  Alternatively, we might say:
+
+        static char regions[]  __initdata = "region=20M;common=5M";
+        static char map[]      __initdata = "video,camera=region";
+        static char asterisk[] __initdata = "common";
+
+        cma_set_defaults(regions, map, asterisk);
+
+    It works in similar fashion, expect by specifying the .asterisk
+    attribute, we say that devices not matched by any rule from .map
+    should access regions listed in .asterisk attribute.
+
+
+    Later on, after some development of the system, it can now run
+    video decoder and camera at the same time.  The 20 MiB region is
+    no longer enough for the two to share.  A quick fix can be made to
+    grant each of those devices separate regions:
+
+        static char regions[]  __initdata = "v=20M;c=20M;common=5M";
+        static char map[]      __initdata = "video=v;camera=c";
+        static char asterisk[] __initdata = "common";
+
+        cma_set_defaults(regions, map, asterisk);
+
+    This solution also shows how with CMA you can assign private pools
+    of memory to each device if that is required.
+
+    Allocation mechanisms can be replaced dynamically in a similar
+    manner as well. Let's say that during testing, it has been
+    discovered that, for a given shared region of 40 MiB,
+    fragmentation has become a problem.  It has been observed that,
+    after some time, it becomes impossible to allocate buffers of the
+    required sizes. So to satisfy our requirements, we would have to
+    reserve a larger shared region beforehand.
+
+    But fortunately, you have also managed to develop a new allocation
+    algorithm -- Neat Allocation Algorithm or "na" for short -- which
+    satisfies the needs for both devices even on a 30 MiB region.  The
+    configuration can be then quickly changed to:
+
+        static char regions[]  __initdata = "region=30M:na;common=5M";
+        static char map[]      __initdata = "video,camera=region";
+        static char asterisk[] __initdata = "common";
+
+        cma_set_defaults(regions, map, asterisk);
+
+    This shows how you can develop your own allocation algorithms if
+    the ones provided with CMA do not suit your needs and easily
+    replace them, without the need to modify CMA core or even
+    recompiling the kernel.
+
+** Technical Details
+
+*** The attributes
+
+    As shown above, CMA is configured by a set of attributes: regions,
+    map and asterisk.  The first one specifies regions that are to be
+    reserved for CMA.  The second one specifies what regions each
+    device is assigned to.  The third one specifies what regions
+    devices without rule in map should have access to.
+
+**** Regions
+
+     The format of the "regions" attribute is as follows:
+
+         regions-attr  ::= [ regions [ ';' ] ]
+         regions       ::= region [ ';' regions ]
+
+         region        ::= [ '-' ] REG-NAME
+                             '=' size
+                           [ '@' start ]
+                           [ '/' alignment ]
+                           [ ':' ALLOC-NAME ]
+
+         size          ::= MEMSIZE   // size of the region
+         start         ::= MEMSIZE   // desired start address of
+                                     // the region
+         alignment     ::= MEMSIZE   // alignment of the start
+                                     // address of the region
+
+     REG-NAME specifies the name of the region.  All regions given at
+     via the regions attribute need to have a name.  Moreover, all
+     regions need to have a unique name.  If two regions have the same
+     name it is unspecified which will be used when requesting to
+     allocate memory from region with given name.
+
+     ALLOC-NAME specifies the name of allocator to be used with the
+     region.  If no allocator name is provided, the "default"
+     allocator will be used with the region.  The "default" allocator
+     is, of course, the first allocator that has been registered. ;)
+
+     size, start and alignment are specified in bytes with suffixes
+     that memparse() accept.  If start is given, the region will be
+     reserved on given starting address (or at close to it as
+     possible).  If alignment is specified, the region will be aligned
+     to given value.
+
+     This can be also specified by the command line argument "cma".
+     If it is, platform's defaults won't be used.
+
+**** Map
+
+     The format of the "map" attribute is as follows:
+
+         map-attr      ::= [ rules [ ';' ] ]
+         rules         ::= rule [ ';' rules ]
+         rule          ::= patterns '=' regions
+
+         patterns      ::= pattern [ ',' patterns ]
+
+         regions       ::= REG-NAME [ ',' regions ] | '*'
+                       // list of regions to try to allocate memory
+                       // from
+
+         pattern       ::= dev-pattern [ '/' kind-pattern ]
+                       | '/' kind-pattern
+                       // pattern request must match for the rule to
+                       // apply; the first rule that matches is
+                       // applied; if dev-pattern part is omitted
+                       // value identical to the one used in previous
+                       // pattern is assumed
+
+         dev-pattern   ::= PATTERN-STR
+                       // pattern that device name must match for the
+                       // rule to apply.
+         kind-pattern  ::= PATTERN-STR
+                       // pattern that "kind" of memory (provided by
+                       // device) must match for the rule to apply.
+
+     The "map" attribute is a sequence of rules which specify what
+     regions should given (device, kind) pair use.  The first rule
+     that matches is applied.
+
+     For rule to match, the pattern must match (dev, kind) pair.
+     Pattern consist of the part before and after slash.  The first
+     part must match device name and the second part must match kind.
+
+     If the first part is empty, the device name is assumed to match
+     iff it matched in previous pattern.
+
+     Not specifying the second part matches only empty, or
+     not-specified kind.
+
+     Patterns may contain question marks which mach any characters and
+     end with an asterisk which match the rest of the string
+     (including nothing).
+
+     The '*' as the list of regions means to use all the regions
+     listed in the "asterisk" attribute.  Moreover, if no rule matches
+     a device the list of regions from the "asterisk" attribute is
+     used as well (ie. a "*/*=*" rule is assumed at the end).
+
+     This attribute is accessible via SysFS and can be changed at
+     run-time by writing to /sys/kernel/mm/contiguous/map.
+
+**** Asterisk
+
+     The format of the "asterisk" attribute is as follows:
+
+         asterisk-attr ::= [ regions ]
+         regions       ::= REG-NAME [ ',' regions ]
+
+     If no rule from "map" attribute match given driver, the regions
+     specified by the "asterisk" attribute are used.
+
+     If this attribute is not specified by call to cma_set_defaults()
+     it is built automatically from the regions listed in the
+     "regions" rule.  All regions are included expect for the ones
+     which name is prefixed by a minus sign.
+
+     For instance, the following:
+
+         static char regions[]  __initdata = "region=20M;common=5M";
+         static char map[]      __initdata = "video,camera=region";
+         static char asterisk[] __initdata = "common";
+
+     can be replaced by:
+
+         static char regions[]  __initdata = "-region=20M;common=5M";
+         static char map[]      __initdata = "video,camera=region";
+
+     The biggest difference is that if user specifies the "cma"
+     command line parameter and platform did not specifies the
+     "asterisk" attribute it will be built from the user-supplied
+     "cma" parameter.  If "asterisk" attribute were to be specified by
+     platform code, it would not be created from command line
+     parameter.
+
+     This attribute is accessible via SysFS and can be changed at
+     run-time by writing to /sys/kernel/mm/contiguous/asterisk.
+
+**** Examples
+
+     Some examples (whitespace added for better readability):
+
+         cma = r1 = 64M       // 64M region
+                    @512M       // starting at address 512M
+                                // (or at least as near as possible)
+                    /1M         // make sure it's aligned to 1M
+                    :foo(bar);  // uses allocator "foo" with "bar"
+                                // as parameters for it
+               r2 = 64M       // 64M region
+                    /1M;        // make sure it's aligned to 1M
+                                // uses the first available allocator
+               r3 = 64M       // 64M region
+                    @512M       // starting at address 512M
+                    :foo;       // uses allocator "foo" with no parameters
+
+         cma_map = foo = r1;
+                       // device foo with kind==NULL uses region r1
+
+                   foo/quaz = r2;  // OR:
+                   /quaz = r2;
+                       // device foo with kind == "quaz" uses region r2
+
+                   foo/* = r3;     // OR:
+                   /* = r3;
+                       // device foo with any other kind uses region r3
+
+                   bar/* = r1,r2;
+                       // device bar with any kind uses region r1 or r2
+
+                   baz?/a* , baz?/b* = r3;
+                       // devices named baz? where ? is any character
+                       // with kind being a string starting with "a" or
+                       // "b" use r3
+
+*** The device and kind of memory
+
+    The name of the device is taken form the device structure.  It is
+    not possible to use CMA if driver does not register a device
+    (actually this can be overcome if a fake device structure is
+    provided with at least the name set).
+
+    The kind of memory is an optional argument provided by the device
+    whenever it requests memory chunk.  In many cases this can be
+    ignored but sometimes it may be required for some devices.
+
+    For instance, let say that there are two memory banks and for
+    performance reasons a device uses buffers in both of them.  In
+    such case, the device driver would define two kinds and use it for
+    different buffers.  CMA attributes could look as follows:
+
+         static char regions[]  __initdata = "a=32M@0;b=32M@512M";
+         static char map[]      __initdata = "foo/a=a;foo/b=b";
+
+    And whenever the driver allocated the memory it would specify the
+    kind of memory:
+
+        buffer1 = cma_alloc(dev, "a", 1 << 20, 0);
+        buffer2 = cma_alloc(dev, "b", 1 << 20, 0);
+
+    If it was needed to try to allocate from the other bank as well if
+    the dedicated one is full, the attributes could be changed to:
+
+         static char regions[]  __initdata = "a=32M@0;b=32M@512M";
+         static char map[]      __initdata = "foo/a=a,b;foo/b=b,a";
+
+    On the other hand, if the same driver was used on a system with
+    only one bank, the command line could be changed to:
+
+         static char regions[]  __initdata = "r=64";
+         static char map[]      __initdata = "foo/*=r";
+
+    without the need to change the driver at all.
+
+*** Device API
+
+    There are four calls provided by the CMA framework to devices.  To
+    allocate a chunk of memory cma_alloc() function needs to be used:
+
+        dma_addr_t cma_alloc(const struct device *dev, const char *kind,
+                             size_t size, dma_addr_t alignment);
+
+    If required, device may specify alignment in bytes that the chunk
+    need to satisfy.  It have to be a power of two or zero.  The
+    chunks are always aligned at least to a page.
+
+    The kind specifies the kind of memory as described to in the
+    previous subsection.  If device driver does not use notion of
+    memory kinds it's safe to pass NULL as the kind.
+
+    The basic usage of the function is just a:
+
+        addr = cma_alloc(dev, NULL, size, 0);
+
+    The function returns physical address of allocated chunk or
+    a value that evaluated true if checked with IS_ERR_VALUE(), so the
+    correct way for checking for errors is:
+
+        unsigned long addr = cma_alloc(dev, size);
+        if (IS_ERR_VALUE(addr))
+                return (int)addr;
+        /* Allocated */
+
+    (Make sure to include <linux/err.h> which contains the definition
+    of the IS_ERR_VALUE() macro.)
+
+
+    Allocated chunk is freed via a cma_put() function:
+
+        int cma_put(dma_addr_t addr);
+
+    It takes physical address of the chunk as an argument and
+    decreases it's reference counter.  If the counter reaches zero the
+    chunk is freed.  Most of the time users do not need to think about
+    reference counter and simply use the cma_put() as a free call.
+
+    If one, however, were to share a chunk with others built in
+    reference counter may turn out to be handy.  To increment it, one
+    needs to use cma_get() function:
+
+        int cma_get(dma_addr_t addr);
+
+
+    The last function is the cma_info() which returns information
+    about regions assigned to given (dev, kind) pair.  Its syntax is:
+
+        int cma_info(struct cma_info *info,
+                     const struct device *dev,
+                     const char *kind);
+
+    On successful exit it fills the info structure with lower and
+    upper bound of regions, total size and number of regions assigned
+    to given (dev, kind) pair.
+
+**** Dynamic and private regions
+
+     In the basic setup, regions are provided via command line argument
+     and then allocated by platform initialisation code (which usually
+     calls cma_regions_allocate() function).
+
+     It is, however, possible to create and add regions dynamically
+     using cma_region_register() function.
+
+         int cma_region_register(struct cma_region *reg);
+
+     The region does not have to have name.  If it does not, it won't
+     be accessed via standard mapping (the one provided with cma_map
+     parameter).  Such regions are private and to allocate chunk on
+     them, one needs to call:
+
+         dma_addr_t cma_alloc_from_region(struct cma_region *reg,
+                                          size_t size, dma_addr_t alignment);
+
+     It is just like cma_alloc() expect one specifies what region to
+     allocate memory from.  The region must have been registered.
+
+**** Allocating from region specified by name
+
+     If a driver preferred allocating from a region or list of regions
+     it knows name of it can use a different call simmilar to the
+     previous:
+
+         dma_addr_t cma_alloc_from(const char *regions,
+                                   size_t size, dma_addr_t alignment);
+
+     The first argument is a comma-separated list of regions the
+     driver desires CMA to try and allocate from.  The list is
+     terminated by NUL byte or a semicolon.
+
+     Similarly, there is a call for requesting information about named
+     regions:
+
+        int cma_info_about(struct cma_info *info, const char *regions);
+
+     Generally, it should not be needed to use those interfaces but
+     they are provided nevertheless.
+
+**** Registering early regions
+
+     An early region is a region that is managed by CMA early during
+     boot process.  It's platforms responsibility to reserve memory
+     for early regions.  Later on, when CMA initialises early regions
+     with reserved memory are registered as normal regions.
+     Registering an early region may be a way for a device to request
+     a private pool of memory without worrying about actually
+     reserving the memory:
+
+         int cma_early_region_register(struct cma_region *reg);
+
+     This needs to be done quite early on in boot process, before
+     platform traverses the cma_early_regions list to reserve memory.
+
+     When boot process ends, device driver may see whether the region
+     was reserved (by checking reg->reserved flag) and if so, whether
+     it was successfully registered as a normal region (by checking
+     the reg->registered flag).  If that is the case, device driver
+     can use normal API calls to use the region.
+
+*** Allocator operations
+
+    Creating an allocator for CMA needs four functions to be
+    implemented.
+
+
+    The first two are used to initialise an allocator far given driver
+    and clean up afterwards:
+
+        int  cma_foo_init(struct cma_region *reg);
+        void cma_foo_done(struct cma_region *reg);
+
+    The first is called when allocater is attached to region.  The
+    cma_region structure has saved starting address of the region as
+    well as its size.  Any data that allocate associated with the
+    region can be saved in private_data field.
+
+    The second call cleans up and frees all resources the allocator
+    has allocated for the region.  The function can assume that all
+    chunks allocated form this region have been freed thus the whole
+    region is free.
+
+
+    The two other calls are used for allocating and freeing chunks.
+    They are:
+
+        struct cma_chunk *cma_foo_alloc(struct cma_region *reg,
+                                        size_t size, dma_addr_t alignment);
+        void cma_foo_free(struct cma_chunk *chunk);
+
+    As names imply the first allocates a chunk and the other frees
+    a chunk of memory.  It also manages a cma_chunk object
+    representing the chunk in physical memory.
+
+    Either of those function can assume that they are the only thread
+    accessing the region.  Therefore, allocator does not need to worry
+    about concurrency.  Moreover, all arguments are guaranteed to be
+    valid (i.e. page aligned size, a power of two alignment no lower
+    the a page size).
+
+
+    When allocator is ready, all that is left is to register it by
+    calling cma_allocator_register() function:
+
+            int cma_allocator_register(struct cma_allocator *alloc);
+
+    The argument is an structure with pointers to the above functions
+    and allocator's name.  The whole call may look something like
+    this:
+
+        static struct cma_allocator alloc = {
+                .name    = "foo",
+                .init    = cma_foo_init,
+                .cleanup = cma_foo_cleanup,
+                .alloc   = cma_foo_alloc,
+                .free    = cma_foo_free,
+        };
+        return cma_allocator_register(&alloc);
+
+    The name ("foo") will be available to use with command line
+    argument.
+
+*** Integration with platform
+
+    There is one function that needs to be called form platform
+    initialisation code.  That is the cma_early_regions_reserve()
+    function:
+
+        void cma_early_regions_reserve(int (*reserve)(struct cma_region *reg));
+
+    It traverses list of all of the regions given on command line and
+    reserves memory for them.  The only argument is a callback
+    function used to reserve the region.  Passing NULL as the argument
+    makes the function use cma_early_region_reserve() function which
+    uses bootmem and memblock for allocating.
+
+    Alternatively, platform code could traverse the cma_early_regions
+    list by itself but this should not be necessary.
+
+
+    Platform has also a way of providing default attributes for CMA,
+    cma_set_defaults() function is used for that purpose:
+
+        int __init cma_set_defaults(char *regions, const char *map,
+                                    const char *asterisk);
+
+    It needs to be called after early params have been parsed but
+    prior to reserving regions.  It let one specify the three
+    attributes used to configure CMA.  Any of the pointer may point to
+    a string in __initdata section.  The regions argument must be
+    modifyable though.
+
+** Future work
+
+    In the future, implementation of mechanisms that would allow the
+    free space inside the regions to be used as page cache, filesystem
+    buffers or swap devices is planned.  With such mechanisms, the
+    memory would not be wasted when not used.
+
+    Because all allocations and freeing of chunks pass the CMA
+    framework it can follow what parts of the reserved memory are
+    freed and what parts are allocated.  Tracking the unused memory
+    would let CMA use it for other purposes such as page cache, I/O
+    buffers, swap, etc.
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a698255..5c7af89 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -43,6 +43,7 @@ parameter is applicable:
 	AVR32	AVR32 architecture is enabled.
 	AX25	Appropriate AX.25 support is enabled.
 	BLACKFIN Blackfin architecture is enabled.
+	CMA	Contiguous Memory Allocator is enabled.
 	DRM	Direct Rendering Management support is enabled.
 	EDD	BIOS Enhanced Disk Drive Services (EDD) is enabled
 	EFI	EFI Partitioning (GPT) is enabled
@@ -476,6 +477,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Also note the kernel might malfunction if you disable
 			some critical bits.
 
+	cma=		[CMA] List of CMA regions.
+			See Documentation/contiguous-memory.txt for details.
+
 	cmo_free_hint=	[PPC] Format: { yes | no }
 			Specify whether pages are marked as being inactive
 			when they are freed.  This is used in CMO environments
diff --git a/include/linux/cma.h b/include/linux/cma.h
new file mode 100644
index 0000000..96a8652
--- /dev/null
+++ b/include/linux/cma.h
@@ -0,0 +1,445 @@
+#ifndef __LINUX_CMA_H
+#define __LINUX_CMA_H
+
+/*
+ * Contiguous Memory Allocator framework
+ * Copyright (c) 2010 by Samsung Electronics.
+ * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
+ */
+
+/*
+ * See Documentation/contiguous-memory.txt for details.
+ */
+
+/***************************** Kernel lever API *****************************/
+
+#ifdef __KERNEL__
+
+#include <linux/kref.h>
+#include <linux/rbtree.h>
+#include <linux/list.h>
+
+
+struct device;
+struct cma_info;
+
+/*
+ * Don't call it directly, use cma_alloc(), cma_alloc_from() or
+ * cma_alloc_from_region().
+ */
+dma_addr_t __must_check
+__cma_alloc(const struct device *dev, const char *kind,
+	    size_t size, dma_addr_t alignment);
+
+/* Don't call it directly, use cma_info() or cma_info_about(). */
+int
+__cma_info(struct cma_info *info, const struct device *dev, const char *kind);
+
+
+/**
+ * cma_alloc - allocates contiguous chunk of memory.
+ * @dev:	The device to perform allocation for.
+ * @kind:	A kind of memory to allocate.  A device may use several
+ * 		different kinds of memory which are configured
+ * 		separately.  Usually it's safe to pass NULL here.
+ * @size:	Size of the memory to allocate in bytes.
+ * @alignment:	Desired alignment in bytes.  Must be a power of two or
+ * 		zero.  If alignment is less then a page size it will be
+ * 		set to page size. If unsure, pass zero here.
+ *
+ * On error returns a negative error cast to dma_addr_t.  Use
+ * IS_ERR_VALUE() to check if returned value is indeed an error.
+ * Otherwise physical address of the chunk is returned.
+ */
+static inline dma_addr_t __must_check
+cma_alloc(const struct device *dev, const char *kind,
+	  size_t size, dma_addr_t alignment)
+{
+	return dev ? -EINVAL : __cma_alloc(dev, kind, size, alignment);
+}
+
+
+/**
+ * struct cma_info - information about regions returned by cma_info().
+ * @lower_bound:	The smallest address that is possible to be
+ * 			allocated for given (dev, kind) pair.
+ * @upper_bound:	The one byte after the biggest address that is
+ * 			possible to be allocated for given (dev, kind)
+ * 			pair.
+ * @total_size:	Total size of regions mapped to (dev, kind) pair.
+ * @free_size:	Total free size in all of the regions mapped to (dev, kind)
+ * 		pair.  Because of possible race conditions, it is not
+ * 		guaranteed that the value will be correct -- it gives only
+ * 		an approximation.
+ * @count:	Number of regions mapped to (dev, kind) pair.
+ */
+struct cma_info {
+	dma_addr_t lower_bound, upper_bound;
+	size_t total_size, free_size;
+	unsigned count;
+};
+
+/**
+ * cma_info - queries information about regions.
+ * @info:	Pointer to a structure where to save the information.
+ * @dev:	The device to query information for.
+ * @kind:	A kind of memory to query information for.
+ * 		If unsure, pass NULL here.
+ *
+ * On error returns a negative error, zero otherwise.
+ */
+static inline int
+cma_info(struct cma_info *info, const struct device *dev, const char *kind)
+{
+	return dev ? -EINVAL : __cma_info(info, dev, kind);
+}
+
+
+/**
+ * cma_get - increases reference counter of a chunk.
+ * @addr:	Beginning of the chunk.
+ *
+ * Returns zero on success or -ENOENT if there is no chunk at given
+ * location.  In the latter case issues a warning and a stacktrace.
+ */
+int cma_get(dma_addr_t addr);
+
+/**
+ * cma_put - decreases reference counter of a chunk.
+ * @addr:	Beginning of the chunk.
+ *
+ * Returns one if the chunk has been freed, zero if it hasn't, and
+ * -ENOENT if there is no chunk at given location.  In the latter case
+ * issues a warning and a stacktrace.
+ *
+ * If this function returns zero, you still can not count on the area
+ * remaining in memory.  Only use the return value if you want to see
+ * if the area is now gone, not present.
+ */
+int cma_put(dma_addr_t addr);
+
+
+
+/****************************** Lower lever API *****************************/
+
+/**
+ * cma_alloc_from - allocates contiguous chunk of memory from named regions.
+ * @regions:	Comma separated list of region names.  Terminated by NUL
+ * 		byte or a semicolon.  "*" or NULL means to try all regions
+ * 		which are listed as asterisk regions.
+ * @size:	Size of the memory to allocate in bytes.
+ * @alignment:	Desired alignment in bytes.  Must be a power of two or
+ * 		zero.  If alignment is less then a page size it will be
+ * 		set to page size. If unsure, pass zero here.
+ *
+ * On error returns a negative error cast to dma_addr_t.  Use
+ * IS_ERR_VALUE() to check if returned value is indeed an error.
+ * Otherwise physical address of the chunk is returned.
+ */
+static inline dma_addr_t __must_check
+cma_alloc_from(const char *regions, size_t size, dma_addr_t alignment)
+{
+	return __cma_alloc(NULL, regions, size, alignment);
+}
+
+/**
+ * cma_info_about - queries information about named regions.
+ * @info:	Pointer to a structure where to save the information.
+ * @regions:	Comma separated list of region names.  Terminated by NUL
+ * 		byte or a semicolon.
+ *
+ * On error returns a negative error, zero otherwise.
+ */
+static inline int
+cma_info_about(struct cma_info *info, const const char *regions)
+{
+	return __cma_info(info, NULL, regions);
+}
+
+
+
+struct cma_allocator;
+
+/**
+ * struct cma_region - a region reserved for CMA allocations.
+ * @name:	Unique name of the region.  Read only.
+ * @start:	Physical starting address of the region in bytes.  Always
+ * 		aligned at least to a full page.  Read only.
+ * @size:	Size of the region in bytes.  Multiply of a page size.
+ * 		Read only.
+ * @free_space:	Free space in the region.  Read only.
+ * @alignment:	Desired alignment of the region in bytes.  A power of two,
+ * 		always at least page size.  Early.
+ * @alloc:	Allocator used with this region.  NULL means allocator is
+ * 		not attached.  Private.
+ * @alloc_name:	Allocator name read from cmdline.  Private.  This may be
+ * 		different from @alloc->name.
+ * @private_data:	Allocator's private data.
+ * @used:	Whether region was already used, ie. there was at least
+ * 		one allocation request for.  Private.
+ * @list:	Entry in list of regions.  Private.
+ * @registered:	Whenthe this region has been registered.  Read only.
+ * @reserved:	Whether this region has been reserved.  Early.  Read only.
+ * @copy_name:	Whether @name and @alloc_name needs to be copied when
+ * 		this region is converted from early to normal.  Early.
+ * 		Private.
+ *
+ * Regions come in two types: an early region and normal region.  The
+ * former can be reserved or not-reserved.  Fields marked as "early"
+ * are only meaningful in early regions.
+ *
+ * Early regions are important only during initialisation.  The list
+ * of early regions is built from the "cma" command line argument or
+ * platform defaults.  Platform initialisation code is responsible for
+ * reserving space for unreserved regions that are placed on
+ * cma_early_regions list.
+ *
+ * Later, during CMA initialisation all reserved regions from the
+ * cma_early_regions list are registered as normal regions and can be
+ * used using standard mechanisms.
+ */
+ /* * @users:	Number of chunks allocated in this region. */
+struct cma_region {
+	const char *name;
+	dma_addr_t start;
+	size_t size;
+	union {
+		size_t free_space;	/* Normal region */
+		dma_addr_t alignment;	/* Early region */
+	};
+
+	struct cma_allocator *alloc;
+	const char *alloc_name;
+	union {
+		void *private_data;	/* Normal region w/ allocator */
+		unsigned used;		/* Normal regien w/o allocator */
+	};
+
+	/* unsigned users; */
+	struct list_head list;
+
+	unsigned registered:1;
+	unsigned reserved:1;
+	unsigned copy_name:1;
+};
+
+
+/**
+ * cma_region_register() - registers a region.
+ * @reg:	Region to add.
+ *
+ * Region's start and size must be set.
+ *
+ * If name is set the region will be accessible using normal mechanism
+ * like mapping or cma_alloc_from() function otherwise it will be
+ * a private region and accessible only using the
+ * cma_alloc_from_region() function.
+ *
+ * If alloc is set function will try to initialise given allocator
+ * (and will return error if it failes).  Otherwise alloc_name may
+ * point to a name of an allocator to use (if not set, the default
+ * will be used).
+ *
+ * All other fields are ignored and/or overwritten.
+ *
+ * Returns zero or negative error.  In particular, -EADDRINUSE if
+ * region overlap with already existing region.
+ */
+int __must_check cma_region_register(struct cma_region *reg);
+
+
+/**
+ * cma_alloc_from_region() - allocates contiguous chunk of memory from region.
+ * @reg:	Region to allocate chunk from.
+ * @size:	Size of the memory to allocate in bytes.
+ * @alignment:	Desired alignment in bytes.  Must be a power of two or
+ * 		zero.  If alignment is less then a page size it will be
+ * 		set to page size. If unsure, pass zero here.
+ *
+ * On error returns a negative error cast to dma_addr_t.  Use
+ * IS_ERR_VALUE() to check if returned value is indeed an error.
+ * Otherwise physical address of the chunk is returned.
+ */
+dma_addr_t __must_check
+cma_alloc_from_region(struct cma_region *reg,
+		      size_t size, dma_addr_t alignment);
+
+
+
+/****************************** Allocators API ******************************/
+
+/**
+ * struct cma_chunk - an allocated contiguous chunk of memory.
+ * @start:	Physical address in bytes.
+ * @size:	Size in bytes.
+ * @free_space:	Free space in region in bytes.  Read only.
+ * @reg:	Region this chunk belongs to.
+ * @kref:	Number of references.  Private.
+ * @by_start:	A node in an red-black tree with all chunks sorted by
+ * 		start address.
+ *
+ * The cma_allocator::alloc() operation need to set only the @start
+ * and @size fields.  The rest is handled by the caller (ie. CMA
+ * glue).
+ */
+struct cma_chunk {
+	dma_addr_t start;
+	size_t size;
+
+	struct cma_region *reg;
+	struct kref ref;
+	struct rb_node by_start;
+};
+
+
+/**
+ * struct cma_allocator - a CMA allocator.
+ * @name:	Allocator's unique name
+ * @init:	Initialises an allocator on given region.
+ * @cleanup:	Cleans up after init.  May assume that there are no chunks
+ * 		allocated in given region.
+ * @alloc:	Allocates a chunk of memory of given size in bytes and
+ * 		with given alignment.  Alignment is a power of
+ * 		two (thus non-zero) and callback does not need to check it.
+ * 		May also assume that it is the only call that uses given
+ * 		region (ie. access to the region is synchronised with
+ * 		a mutex).  This has to allocate the chunk object (it may be
+ * 		contained in a bigger structure with allocator-specific data.
+ * 		Required.
+ * @free:	Frees allocated chunk.  May also assume that it is the only
+ * 		call that uses given region.  This has to free() the chunk
+ * 		object as well.  Required.
+ * @list:	Entry in list of allocators.  Private.
+ */
+ /* * @users:	How many regions use this allocator.  Private. */
+struct cma_allocator {
+	const char *name;
+
+	int (*init)(struct cma_region *reg);
+	void (*cleanup)(struct cma_region *reg);
+	struct cma_chunk *(*alloc)(struct cma_region *reg, size_t size,
+				   dma_addr_t alignment);
+	void (*free)(struct cma_chunk *chunk);
+
+	/* unsigned users; */
+	struct list_head list;
+};
+
+
+/**
+ * cma_allocator_register() - Registers an allocator.
+ * @alloc:	Allocator to register.
+ *
+ * Adds allocator to the list of allocators managed by CMA.
+ *
+ * All of the fields of cma_allocator structure must be set except for
+ * optional name and users and list which will be overriden.
+ *
+ * Returns zero or negative error code.
+ */
+int cma_allocator_register(struct cma_allocator *alloc);
+
+
+/**************************** Initialisation API ****************************/
+
+/**
+ * cma_set_defaults() - specifies default command line parameters.
+ * @regions:	Default regions attribute.  May be overriden by "cma"
+ * 		command line argument.
+ * @map:	Default map attribute.  If not set all devices will use
+ * 		regions specified by @asterisk attribute.
+ * @asterisk:	Default asterisk attribute.  If not set will be built from
+ * 		@regions.  Specifies list of regions to use for devices
+ * 		that are missing a rule in @map.
+ *
+ * This function should be called prior to cma_early_regions_reserve()
+ * and after early parameters have been parsed.  The arguments
+ * specifies defalts for various CMA attributes.
+ *
+ * All the pointers can point to strings in __initdata.  @regions
+ * needs to be modifyable.
+ *
+ * Returns negative error code if there was an error parsing the
+ * defs->regions parameter.  Zero otherwise.
+ */
+int __init cma_set_defaults(char *regions, const char *map,
+                            const char *asterisk);
+
+
+/**
+ * cma_early_regions - a list of early regions.
+ *
+ * Platform needs to allocate space for each of the region before
+ * initcalls are executed.  If space is reserved, the reserved flag
+ * must be set.  Platform initialisation code may choose to use
+ * cma_early_regions_allocate().
+ *
+ * Later, during CMA initialisation all reserved regions from the
+ * cma_early_regions list are registered as normal regions and can be
+ * used using standard mechanisms.
+ */
+extern struct list_head cma_early_regions __initdata;
+
+
+/**
+ * cma_early_region_register() - registers an early region.
+ * @reg:	Region to add.
+ *
+ * Region's start, size and alignment must be set.
+ *
+ * If name is set the region will be accessible using normal mechanism
+ * like mapping or cma_alloc_from() function otherwise it will be
+ * a private region accessible only using the cma_alloc_from_region().
+ *
+ * If alloc is set function will try to initialise given allocator
+ * when the early region is "converted" to normal region and
+ * registered during CMA initialisation.  If this failes, the space
+ * will still be reserved but the region won't be registered.
+ *
+ * As usually, alloc_name may point to a name of an allocator to use
+ * (if both alloc and alloc_name aret set, the default will be used).
+ *
+ * All other fields are ignored and/or overwritten.
+ *
+ * Returns zero or negative error.  No checking if regions overlap is
+ * performed.
+ */
+int __init __must_check cma_early_region_register(struct cma_region *reg);
+
+
+/**
+ * cma_early_region_reserve() - reserves a physically contiguous memory region.
+ * @reg:	Early region to reserve memory for.
+ *
+ * If platform supports bootmem this is the first allocator this
+ * function tries to use.  If that failes (or bootmem is not
+ * supported) function tries to use memblec if it is available.
+ *
+ * On success sets reg->reserved flag.
+ *
+ * Returns zero or negative error.
+ */
+int __init cma_early_region_reserve(struct cma_region *reg);
+
+/**
+ * cma_early_regions_reserver() - helper function for reserving early regions.
+ * @reserve:	Callbac function used to reserve space for region.  Needs
+ * 		to return non-negative if allocation succeeded, negative
+ * 		error otherwise.  NULL means cma_early_region_alloc() will
+ * 		be used.
+ *
+ * This function traverses the %cma_early_regions list and tries to
+ * reserve memory for each early region.  It uses the @reserve
+ * callback function for that purpose.  The reserved flag of each
+ * region is updated accordingly.
+ */
+void __init cma_early_regions_reserve(int (*reserve)(struct cma_region *reg));
+
+#else
+
+#define cma_defaults(regions, map, asterisk) ((int)0)
+#define cma_early_regions_reserve(reserve)   do { } while (0)
+
+#endif
+
+#endif
diff --git a/mm/Kconfig b/mm/Kconfig
index f4e516e..468b874 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -301,3 +301,37 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.
 
 	  See Documentation/nommu-mmap.txt for more information.
+
+
+config CMA
+	bool "Contiguous Memory Allocator framework"
+	# Currently there is only one allocator so force it on
+	select CMA_BEST_FIT
+	help
+	  This enables the Contiguous Memory Allocator framework which
+	  allows drivers to allocate big physically-contiguous blocks of
+	  memory for use with hardware components that do not support I/O
+	  map nor scatter-gather.
+
+	  If you select this option you will also have to select at least
+	  one allocator algorithm below.
+
+	  To make use of CMA you need to specify the regions and
+	  driver->region mapping on command line when booting the kernel.
+
+config CMA_DEBUG
+	bool "CMA debug messages"
+	depends on CMA
+	help
+	  Enable debug messages in CMA code.
+
+config CMA_BEST_FIT
+	bool "CMA best-fit allocator"
+	depends on CMA
+	default y
+	help
+	  This is a best-fit algorithm running in O(n log n) time where
+	  n is the number of existing holes (which is never greater then
+	  the number of allocated regions and usually much smaller).  It
+	  allocates area from the smallest hole that is big enough for
+	  allocation in question.
diff --git a/mm/Makefile b/mm/Makefile
index 34b2546..54b0e99 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -47,3 +47,6 @@ obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
 obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
+
+obj-$(CONFIG_CMA) += cma.o
+obj-$(CONFIG_CMA_BEST_FIT) += cma-best-fit.o
diff --git a/mm/cma-best-fit.c b/mm/cma-best-fit.c
new file mode 100644
index 0000000..59515f9
--- /dev/null
+++ b/mm/cma-best-fit.c
@@ -0,0 +1,407 @@
+/*
+ * Contiguous Memory Allocator framework: Best Fit allocator
+ * Copyright (c) 2010 by Samsung Electronics.
+ * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
+#define pr_fmt(fmt) "cma: bf: " fmt
+
+#ifdef CONFIG_CMA_DEBUG
+#  define DEBUG
+#endif
+
+#include <linux/errno.h>       /* Error numbers */
+#include <linux/slab.h>        /* kmalloc() */
+
+#include <linux/cma.h>         /* CMA structures */
+
+
+/************************* Data Types *************************/
+
+struct cma_bf_item {
+	struct cma_chunk ch;
+	struct rb_node by_size;
+};
+
+struct cma_bf_private {
+	struct rb_root by_start_root;
+	struct rb_root by_size_root;
+};
+
+
+/************************* Prototypes *************************/
+
+/*
+ * Those are only for holes.  They must be called whenever hole's
+ * properties change but also whenever chunk becomes a hole or hole
+ * becames a chunk.
+ */
+static void __cma_bf_hole_insert_by_size(struct cma_bf_item *item);
+static void __cma_bf_hole_erase_by_size(struct cma_bf_item *item);
+static int  __must_check
+            __cma_bf_hole_insert_by_start(struct cma_bf_item *item);
+static void __cma_bf_hole_erase_by_start(struct cma_bf_item *item);
+
+/**
+ * __cma_bf_hole_take - takes a chunk of memory out of a hole.
+ * @hole:	hole to take chunk from
+ * @size:	chunk's size
+ * @alignment:	chunk's starting address alignment (must be power of two)
+ *
+ * Takes a @size bytes large chunk from hole @hole which must be able
+ * to hold the chunk.  The "must be able" includes also alignment
+ * constraint.
+ *
+ * Returns allocated item or NULL on error (if kmalloc() failed).
+ */
+static struct cma_bf_item *__must_check
+__cma_bf_hole_take(struct cma_bf_item *hole, size_t size, dma_addr_t alignment);
+
+/**
+ * __cma_bf_hole_merge_maybe - tries to merge hole with neighbours.
+ * @item: hole to try and merge
+ *
+ * Which items are preserved is undefined so you may not rely on it.
+ */
+static void __cma_bf_hole_merge_maybe(struct cma_bf_item *item);
+
+
+/************************* Device API *************************/
+
+int cma_bf_init(struct cma_region *reg)
+{
+	struct cma_bf_private *prv;
+	struct cma_bf_item *item;
+
+	prv = kzalloc(sizeof *prv, GFP_KERNEL);
+	if (unlikely(!prv))
+		return -ENOMEM;
+
+	item = kzalloc(sizeof *item, GFP_KERNEL);
+	if (unlikely(!item)) {
+		kfree(prv);
+		return -ENOMEM;
+	}
+
+	item->ch.start = reg->start;
+	item->ch.size  = reg->size;
+	item->ch.reg   = reg;
+
+	rb_root_init(&prv->by_start_root, &item->ch.by_start);
+	rb_root_init(&prv->by_size_root, &item->by_size);
+
+	reg->private_data = prv;
+	return 0;
+}
+
+void cma_bf_cleanup(struct cma_region *reg)
+{
+	struct cma_bf_private *prv = reg->private_data;
+	struct cma_bf_item *item =
+		rb_entry(prv->by_size_root.rb_node,
+			 struct cma_bf_item, by_size);
+
+	/* We can assume there is only a single hole in the tree. */
+	WARN_ON(item->by_size.rb_left || item->by_size.rb_right ||
+		item->ch.by_start.rb_left || item->ch.by_start.rb_right);
+
+	kfree(item);
+	kfree(prv);
+}
+
+struct cma_chunk *cma_bf_alloc(struct cma_region *reg,
+			       size_t size, dma_addr_t alignment)
+{
+	struct cma_bf_private *prv = reg->private_data;
+	struct rb_node *node = prv->by_size_root.rb_node;
+	struct cma_bf_item *item = NULL;
+
+	/* First find hole that is large enough */
+	while (node) {
+		struct cma_bf_item *i =
+			rb_entry(node, struct cma_bf_item, by_size);
+
+		if (i->ch.size < size) {
+			node = node->rb_right;
+		} else if (i->ch.size >= size) {
+			node = node->rb_left;
+			item = i;
+		}
+	}
+	if (!item)
+		return NULL;
+
+	/* Now look for items which can satisfy alignment requirements */
+	for (;;) {
+		dma_addr_t start = ALIGN(item->ch.start, alignment);
+		dma_addr_t end   = item->ch.start + item->ch.size;
+		if (start < end && end - start >= size) {
+			item = __cma_bf_hole_take(item, size, alignment);
+			return likely(item) ? &item->ch : NULL;
+		}
+
+		node = rb_next(node);
+		if (!node)
+			return NULL;
+
+		item  = rb_entry(node, struct cma_bf_item, by_size);
+	}
+}
+
+void cma_bf_free(struct cma_chunk *chunk)
+{
+	struct cma_bf_item *item = container_of(chunk, struct cma_bf_item, ch);
+
+	/* Add new hole */
+	if (unlikely(__cma_bf_hole_insert_by_start(item))) {
+		/*
+		 * We're screwed...  Just free the item and forget
+		 * about it.  Things are broken beyond repair so no
+		 * sense in trying to recover.
+		 */
+		kfree(item);
+	} else {
+		__cma_bf_hole_insert_by_size(item);
+
+		/* Merge with prev and next sibling */
+		__cma_bf_hole_merge_maybe(item);
+	}
+}
+
+
+/************************* Basic Tree Manipulation *************************/
+
+static void __cma_bf_hole_insert_by_size(struct cma_bf_item *item)
+{
+	struct cma_bf_private *prv = item->ch.reg->private_data;
+	struct rb_node **link = &prv->by_size_root.rb_node, *parent = NULL;
+	const typeof(item->ch.size) value = item->ch.size;
+
+	while (*link) {
+		struct cma_bf_item *i;
+		parent = *link;
+		i = rb_entry(parent, struct cma_bf_item, by_size);
+		link = value <= i->ch.size
+			? &parent->rb_left
+			: &parent->rb_right;
+	}
+
+	rb_link_node(&item->by_size, parent, link);
+	rb_insert_color(&item->by_size, &prv->by_size_root);
+}
+
+static void __cma_bf_hole_erase_by_size(struct cma_bf_item *item)
+{
+	struct cma_bf_private *prv = item->ch.reg->private_data;
+	rb_erase(&item->by_size, &prv->by_size_root);
+}
+
+static int  __must_check
+            __cma_bf_hole_insert_by_start(struct cma_bf_item *item)
+{
+	struct cma_bf_private *prv = item->ch.reg->private_data;
+	struct rb_node **link = &prv->by_start_root.rb_node, *parent = NULL;
+	const typeof(item->ch.start) value = item->ch.start;
+
+	while (*link) {
+		struct cma_bf_item *i;
+		parent = *link;
+		i = rb_entry(parent, struct cma_bf_item, ch.by_start);
+
+		if (WARN_ON(value == i->ch.start))
+			/*
+			 * This should *never* happen.  And I mean
+			 * *never*.  We could even BUG on it but
+			 * hopefully things are only a bit broken,
+			 * ie. system can still run.  We produce
+			 * a warning and return an error.
+			 */
+			return -EBUSY;
+
+		link = value <= i->ch.start
+			? &parent->rb_left
+			: &parent->rb_right;
+	}
+
+	rb_link_node(&item->ch.by_start, parent, link);
+	rb_insert_color(&item->ch.by_start, &prv->by_start_root);
+	return 0;
+}
+
+static void __cma_bf_hole_erase_by_start(struct cma_bf_item *item)
+{
+	struct cma_bf_private *prv = item->ch.reg->private_data;
+	rb_erase(&item->ch.by_start, &prv->by_start_root);
+}
+
+
+/************************* More Tree Manipulation *************************/
+
+static struct cma_bf_item *__must_check
+__cma_bf_hole_take(struct cma_bf_item *hole, size_t size, size_t alignment)
+{
+	struct cma_bf_item *item;
+
+	/*
+	 * There are three cases:
+	 * 1. the chunk takes the whole hole,
+	 * 2. the chunk is at the beginning or at the end of the hole, or
+	 * 3. the chunk is in the middle of the hole.
+	 */
+
+
+	/* Case 1, the whole hole */
+	if (size == hole->ch.size) {
+		__cma_bf_hole_erase_by_size(hole);
+		__cma_bf_hole_erase_by_start(hole);
+		return hole;
+	}
+
+
+	/* Allocate */
+	item = kmalloc(sizeof *item, GFP_KERNEL);
+	if (unlikely(!item))
+		return NULL;
+
+	item->ch.start = ALIGN(hole->ch.start, alignment);
+	item->ch.size  = size;
+
+	/* Case 3, in the middle */
+	if (item->ch.start != hole->ch.start
+	 && item->ch.start + item->ch.size !=
+	    hole->ch.start + hole->ch.size) {
+		struct cma_bf_item *tail;
+
+		/*
+		 * Space between the end of the chunk and the end of
+		 * the region, ie. space left after the end of the
+		 * chunk.  If this is dividable by alignment we can
+		 * move the chunk to the end of the hole.
+		 */
+		size_t left =
+			hole->ch.start + hole->ch.size -
+			(item->ch.start + item->ch.size);
+		if (left % alignment == 0) {
+			item->ch.start += left;
+			goto case_2;
+		}
+
+		/*
+		 * We are going to add a hole at the end.  This way,
+		 * we will reduce the problem to case 2 -- the chunk
+		 * will be at the end of the hole.
+		 */
+		tail = kmalloc(sizeof *tail, GFP_KERNEL);
+		if (unlikely(!tail)) {
+			kfree(item);
+			return NULL;
+		}
+
+		tail->ch.start = item->ch.start + item->ch.size;
+		tail->ch.size  =
+			hole->ch.start + hole->ch.size - tail->ch.start;
+		tail->ch.reg   = hole->ch.reg;
+
+		if (unlikely(__cma_bf_hole_insert_by_start(tail))) {
+			/*
+			 * Things are broken beyond repair...  Abort
+			 * inserting the hole but still continue with
+			 * allocation (seems like the best we can do).
+			 */
+
+			hole->ch.size = tail->ch.start - hole->ch.start;
+			kfree(tail);
+		} else {
+			__cma_bf_hole_insert_by_size(tail);
+			/*
+			 * It's important that we first insert the new
+			 * hole in the tree sorted by size and later
+			 * reduce the size of the old hole.  We will
+			 * update the position of the old hole in the
+			 * rb tree in code that handles case 2.
+			 */
+			hole->ch.size = tail->ch.start - hole->ch.start;
+		}
+
+		/* Go to case 2 */
+	}
+
+
+	/* Case 2, at the beginning or at the end */
+case_2:
+	/* No need to update the tree; order preserved. */
+	if (item->ch.start == hole->ch.start)
+		hole->ch.start += item->ch.size;
+
+	/* Alter hole's size */
+	hole->ch.size -= size;
+	__cma_bf_hole_erase_by_size(hole);
+	__cma_bf_hole_insert_by_size(hole);
+
+	return item;
+}
+
+
+static void __cma_bf_hole_merge_maybe(struct cma_bf_item *item)
+{
+	struct cma_bf_item *prev;
+	struct rb_node *node;
+	int twice = 2;
+
+	node = rb_prev(&item->ch.by_start);
+	if (unlikely(!node))
+		goto next;
+	prev = rb_entry(node, struct cma_bf_item, ch.by_start);
+
+	for (;;) {
+		if (prev->ch.start + prev->ch.size == item->ch.start) {
+			/* Remove previous hole from trees */
+			__cma_bf_hole_erase_by_size(prev);
+			__cma_bf_hole_erase_by_start(prev);
+
+			/* Alter this hole */
+			item->ch.size += prev->ch.size;
+			item->ch.start = prev->ch.start;
+			__cma_bf_hole_erase_by_size(item);
+			__cma_bf_hole_insert_by_size(item);
+			/*
+			 * No need to update by start trees as we do
+			 * not break sequence order
+			 */
+
+			/* Free prev hole */
+			kfree(prev);
+		}
+
+next:
+		if (!--twice)
+			break;
+
+		node = rb_next(&item->ch.by_start);
+		if (unlikely(!node))
+			break;
+		prev = item;
+		item = rb_entry(node, struct cma_bf_item, ch.by_start);
+	}
+}
+
+
+
+/************************* Register *************************/
+static int cma_bf_module_init(void)
+{
+	static struct cma_allocator alloc = {
+		.name    = "bf",
+		.init    = cma_bf_init,
+		.cleanup = cma_bf_cleanup,
+		.alloc   = cma_bf_alloc,
+		.free    = cma_bf_free,
+	};
+	return cma_allocator_register(&alloc);
+}
+module_init(cma_bf_module_init);
diff --git a/mm/cma.c b/mm/cma.c
new file mode 100644
index 0000000..0b02ab0
--- /dev/null
+++ b/mm/cma.c
@@ -0,0 +1,1170 @@
+/*
+ * Contiguous Memory Allocator framework
+ * Copyright (c) 2010 by Samsung Electronics.
+ * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License or (at your optional) any later version of the license.
+ */
+
+/*
+ * See Documentation/contiguous-memory.txt for details.
+ */
+
+#define pr_fmt(fmt) "cma: " fmt
+
+#ifdef CONFIG_CMA_DEBUG
+#  define DEBUG
+#endif
+
+#ifndef CONFIG_NO_BOOTMEM
+#  include <linux/bootmem.h>   /* alloc_bootmem_pages_nopanic() */
+#endif
+#ifdef CONFIG_HAVE_MEMBLOCK
+#  include <linux/memblock.h>  /* memblock*() */
+#endif
+#include <linux/device.h>      /* struct device, dev_name() */
+#include <linux/errno.h>       /* Error numbers */
+#include <linux/err.h>         /* IS_ERR, PTR_ERR, etc. */
+#include <linux/mm.h>          /* PAGE_ALIGN() */
+#include <linux/module.h>      /* EXPORT_SYMBOL_GPL() */
+#include <linux/mutex.h>       /* mutex */
+#include <linux/slab.h>        /* kmalloc() */
+#include <linux/string.h>      /* str*() */
+
+#include <linux/cma.h>
+
+
+/*
+ * Protects cma_regions, cma_allocators, cma_attr_map (which means
+ * cma_map and cma_map_len), cma_attr_asterisk (which means
+ * cma_asterisk and cma_asterisk_len) and cma_chunks_by_start.
+ */
+static DEFINE_MUTEX(cma_mutex);
+
+static struct kobject *cma_kobj;
+
+
+/************************* Attributes *************************/
+
+struct cma_attribute {
+	struct kobj_attribute kattr;
+	const char *value;
+	size_t length;
+	ssize_t (*validate)(const char *value);
+};
+
+#define __CMA_ATTR(_name) \
+	__ATTR(_name, 0644, cma_attr_show, cma_attr_store)
+
+static ssize_t cma_attr_show(struct kobject *kobj,
+			     struct kobj_attribute *_attr, char *page)
+{
+	struct cma_attribute *attr =
+		container_of(_attr, struct cma_attribute, kattr);
+	ssize_t len;
+
+	mutex_lock(&cma_mutex);
+
+	if (!attr->value || !attr->length) {
+		*page = 0;
+		len = 0;
+	} else {
+		len = min(attr->length, (size_t)PAGE_SIZE - 2);
+		memcpy(page, attr->value, len);
+		page[len]   = '\n';
+		page[++len] = '\0';
+	}
+
+	mutex_unlock(&cma_mutex);
+
+	return len;
+}
+
+static ssize_t cma_attr_store(struct kobject *kobj,
+			      struct kobj_attribute *_attr,
+			      const char *page, size_t count)
+{
+	struct cma_attribute *attr =
+		container_of(_attr, struct cma_attribute, kattr);
+	ssize_t len = attr->validate(page);
+	char *val = NULL;
+
+	if (len < 0)
+		return len;
+
+	if (len) {
+		val = kmemdup(page, len + 1, GFP_KERNEL);
+		if (!val)
+			return -ENOMEM;
+		val[len] = '\0';
+	}
+
+	mutex_lock(&cma_mutex);
+
+	kfree(attr->value);
+	attr->value = val;
+	attr->length = len;
+
+	mutex_unlock(&cma_mutex);
+
+	return count;
+}
+
+
+/*
+ * param        ::= [ rules [ ';' ] ]
+ * rules        ::= rule [ ';' rules ]
+ * rule         ::= patterns '=' regions
+ * patterns     ::= pattern [ ',' patterns ]
+ *
+ * regions      ::= reg-name [ ',' regions ] | '*'
+ *              // list of regions to try to allocate memory
+ *              // from for devices that match pattern
+ *
+ * pattern      ::= dev-pattern [ '/' kind-pattern ]
+ *                | '/' kind-pattern
+ *              // pattern request must match for this rule to
+ *              // apply to it; the first rule that matches is
+ *              // applied; if dev-pattern part is omitted
+ *              // value identical to the one used in previous
+ *              // rule is assumed
+ *
+ * See Documentation/contiguous-memory.txt for details.
+ *
+ * Example (white space added for convenience, forbidden in real string):
+ * cma_map = foo-dev = reg1;             -- foo-dev with no kind
+ *           bar-dev / firmware = reg3;  -- bar-dev's firmware
+ *           / * = reg2;                 -- bar-dev's all other kinds
+ *           baz-dev / * = reg1,reg2;    -- any kind of baz-dev
+ *           * / * = reg2,reg1;          -- any other allocations
+ */
+static ssize_t cma_map_validate(const char *param)
+{
+	const char *ch = param;
+
+	if (*ch == '\0' || *ch == '\n')
+		return 0;
+
+	for (;;) {
+		const char *start = ch;
+
+		while (*ch && *ch != '\n' && *ch != ';' && *ch != '=')
+			++ch;
+
+		if (*ch != '=' || start == ch) {
+			pr_err("map: expecting \"<patterns>=<regions>\" near %s\n", start);
+			return -EINVAL;
+		}
+
+		if (*ch == '*' && (ch[1] && ch[1] != '\n' && ch[1] != ';')) {
+			pr_err("map: end of ';' expecting after '*' near %s\n", start);
+			return -EINVAL;
+		}
+
+		while (*++ch != ';')
+			if (!*ch || *ch == '\n')
+				return ch - param;
+		if (ch[1] == '\0' || ch[1] == '\n')
+			return ch - param;
+		++ch;
+	}
+}
+
+
+static struct cma_attribute cma_attributes[] = {
+	{
+		.kattr		= __CMA_ATTR(map),
+		.validate	= &cma_map_validate
+	},
+	{
+		.kattr		= __CMA_ATTR(asterisk),
+		.validate	= (ssize_t (*)(const char *))&strlen,
+	},
+};
+
+#define cma_map       (cma_attributes[0].value)
+#define cma_asterisk  (cma_attributes[1].value)
+
+
+static int __init cma_attributes_init(void)
+{
+	struct cma_attribute *attr = cma_attributes;
+	int i = ARRAY_SIZE(cma_attributes), ret = 0;
+
+	do {
+		if (attr->value) {
+			/* Apply defaults.  Ignore parsing errors. */
+			const char *v = attr->value;
+			attr->value = NULL;
+			cma_attr_store(NULL, &attr->kattr, v, 0);
+		}
+
+		/*
+		 * Even if there was an error creating one file
+		 * initialise the rest.
+		 */
+		if (cma_kobj && !ret)
+			ret = sysfs_create_file(cma_kobj, &attr->kattr.attr);
+	} while (++attr, --i);
+
+	return ret;
+}
+
+
+
+/************************* Early parameter *************************/
+
+struct list_head cma_early_regions __initdata =
+	LIST_HEAD_INIT(cma_early_regions);
+
+/*
+ * regions-attr ::= [ regions [ ';' ] ]
+ * regions      ::= region [ ';' regions ]
+ *
+ * region       ::= [ '-' ] reg-name
+ *                    '=' size
+ *                  [ '@' start ]
+ *                  [ '/' alignment ]
+ *                  [ ':' alloc-name ]
+ *
+ * See Documentation/contiguous-memory.txt for details.
+ *
+ * Example:
+ * cma=reg1=64M:bf;reg2=32M@0x100000:bf;reg3=64M/1M:bf
+ *
+ * If allocator is ommited the first available allocater will be used.
+ */
+
+#define NUMPARSE(cond_ch, type, cond) ({				\
+		unsigned long long v = 0;				\
+		if (*param == (cond_ch)) {				\
+			const char *const msg = param + 1;		\
+			v = memparse(msg, &param);			\
+			if (!v || v > ~(type)0 || !(cond)) {		\
+				pr_err("param: invalid value near %s\n", msg); \
+				ret = -EINVAL;				\
+				break;					\
+			}						\
+		}							\
+		v;							\
+	})
+
+static int __init cma_param_parse(char *param)
+{
+	static int already_parsed __initdata;
+
+	static struct cma_region regions[16];
+	static char buffer[128] __initdata;
+
+	size_t left = ARRAY_SIZE(regions);
+	struct cma_region *reg = regions;
+
+	size_t buf_left = ARRAY_SIZE(buffer);
+	char *buf = buffer;
+
+	int ret = 0;
+
+	pr_debug("param: %s\n", param);
+
+	if (already_parsed)
+		return 0;
+	already_parsed = 1;
+
+	for (; *param; ++reg) {
+		dma_addr_t start, alignment;
+		size_t size;
+		int minus;
+
+		if (unlikely(!--left)) {
+			pr_err("param: too many early regions\n");
+			return -ENOSPC;
+		}
+
+		/* Parse name */
+		minus = *param == '-';
+		if (minus)
+			++param;
+
+		reg->name = param;
+		param = strchr(param, '=');
+		if (!param || param == reg->name) {
+			pr_err("param: expected \"<name>=\" near %s\n",
+			       reg->name);
+			ret = -EINVAL;
+			break;
+		}
+		*param = '\0';
+
+		/* Copy name to buffer */
+		if (!minus) {
+			size_t len = param - reg->name;
+			if (len >= buf_left) {
+				pr_err("param: names too long\n");
+				ret = -ENOSPC;
+				break;
+			}
+
+			memcpy(buf, reg->name, len);
+			buf += len;
+			*buf = ',';
+			++buf;
+			buf_left -= len;
+		}
+
+		/* Parse numbers */
+		size      = NUMPARSE('\0', size_t, true);
+		start     = NUMPARSE('@', dma_addr_t, true);
+		alignment = NUMPARSE('/', dma_addr_t, (v & (v - 1)) == 0);
+
+		alignment = max(alignment, (dma_addr_t)PAGE_SIZE);
+		start     = ALIGN(start, alignment);
+		size      = PAGE_ALIGN(size);
+		if (start + size < start) {
+			pr_err("param: invalid start, size combination\n");
+			ret = -EINVAL;
+			break;
+		}
+
+		/* Parse allocator */
+		if (*param == ':') {
+			reg->alloc_name = ++param;
+			while (*param && *param != ';')
+				++param;
+			if (param == reg->alloc_name)
+				reg->alloc_name = NULL;
+		}
+
+		/* Go to next */
+		if (*param == ';') {
+			*param = '\0';
+			++param;
+		} else if (*param) {
+			pr_err("param: expecting ';' or end of parameter near %s\n",
+			       param);
+			ret = -EINVAL;
+			break;
+		}
+
+		/* Add */
+		reg->size      = size;
+		reg->start     = start;
+		reg->alignment = alignment;
+		reg->copy_name = 1;
+
+		list_add_tail(&reg->list, &cma_early_regions);
+
+		pr_debug("param: registering early region %s (%p@%p/%p)\n",
+			 reg->name, (void *)reg->size, (void *)reg->start,
+			 (void *)reg->alignment);
+	}
+
+	if (buf != buffer) {
+		buf[-1] = '\0';
+		cma_asterisk = buffer;
+	}
+	return ret;
+}
+early_param("cma", cma_param_parse);
+
+#undef NUMPARSE
+
+
+int __init __must_check cma_early_region_register(struct cma_region *reg)
+{
+	dma_addr_t start, alignment;
+	size_t size;
+
+	if (reg->alignment & (reg->alignment - 1))
+		return -EINVAL;
+
+	alignment = max(reg->alignment, (dma_addr_t)PAGE_SIZE);
+	start     = ALIGN(reg->start, alignment);
+	size      = PAGE_ALIGN(reg->size);
+
+	if (start + size < start)
+		return -EINVAL;
+
+	reg->size      = size;
+	reg->start     = start;
+	reg->alignment = alignment;
+
+	list_add_tail(&reg->list, &cma_early_regions);
+
+	pr_debug("param: registering early region %s (%p@%p/%p)\n",
+		 reg->name, (void *)reg->size, (void *)reg->start,
+		 (void *)reg->alignment);
+
+	return 0;
+}
+
+
+
+/************************* Regions & Allocators *************************/
+
+static int __cma_region_attach_alloc(struct cma_region *reg);
+
+
+/* List of all regions.  Named regions are kept before unnamed. */
+static LIST_HEAD(cma_regions);
+
+#define cma_foreach_region(reg) \
+	list_for_each_entry(reg, &cma_regions, list)
+
+int __must_check cma_region_register(struct cma_region *reg)
+{
+	const char *name, *alloc_name;
+	struct cma_region *r;
+	char *ch = NULL;
+	int ret = 0;
+
+	if (!reg->size || reg->start + reg->size < reg->start)
+		return -EINVAL;
+
+	/* reg->users = 0; */
+	reg->used = 0;
+	reg->private_data = NULL;
+	reg->registered = 0;
+	reg->free_space = reg->size;
+
+	/* Copy name and alloc_name */
+	name = reg->name;
+	alloc_name = reg->alloc_name;
+	if (reg->copy_name && (reg->name || reg->alloc_name)) {
+		size_t name_size, alloc_size;
+
+		name_size  = reg->name       ? strlen(reg->name) + 1       : 0;
+		alloc_size = reg->alloc_name ? strlen(reg->alloc_name) + 1 : 0;
+
+		ch = kmalloc(name_size + alloc_size, GFP_KERNEL);
+		if (!ch) {
+			pr_err("%s: not enough memory to allocate name\n",
+			       reg->name ?: "(private)");
+			return -ENOMEM;
+		}
+
+		if (name_size) {
+			memcpy(ch, reg->name, name_size);
+			name = ch;
+			ch += name_size;
+		}
+
+		if (alloc_size) {
+			memcpy(ch, reg->alloc_name, alloc_size);
+			alloc_name = ch;
+		}
+	}
+
+	mutex_lock(&cma_mutex);
+
+	/* Don't let regions overlap */
+	cma_foreach_region(r)
+		if (r->start + r->size > reg->start &&
+		    r->start < reg->start + reg->size) {
+			ret = -EADDRINUSE;
+			goto done;
+		}
+
+	if (reg->alloc) {
+		ret = __cma_region_attach_alloc(reg);
+		if (unlikely(ret < 0))
+			goto done;
+	}
+
+	reg->name = name;
+	reg->alloc_name = alloc_name;
+	reg->registered = 1;
+	ch = NULL;
+
+	/*
+	 * Keep named at the beginning and unnamed (private) at the
+	 * end.  This helps in traversal when named region is looked
+	 * for.
+	 */
+	if (name)
+		list_add(&reg->list, &cma_regions);
+	else
+		list_add_tail(&reg->list, &cma_regions);
+
+done:
+	mutex_unlock(&cma_mutex);
+
+	pr_debug("%s: region %sregistered\n",
+		 reg->name ?: "(private)", ret ? "not " : "");
+	if (ch)
+		kfree(ch);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cma_region_register);
+
+static struct cma_region *__must_check
+__cma_region_find(const char **namep)
+{
+	struct cma_region *reg;
+	const char *ch, *name;
+	size_t n;
+
+	for (ch = *namep; *ch && *ch != ',' && *ch != ';'; ++ch)
+		/* nop */;
+	name = *namep;
+	*namep = *ch ? ch : (ch + 1);
+	n = ch - name;
+
+	/*
+	 * Named regions are kept in front of unnamed so if we
+	 * encounter unnamed region we can stop.
+	 */
+	cma_foreach_region(reg)
+		if (!reg->name)
+			break;
+		else if (!strncmp(name, reg->name, n) && !reg->name[n])
+			return reg;
+
+	return NULL;
+}
+
+
+/* List of all allocators. */
+static LIST_HEAD(cma_allocators);
+
+#define cma_foreach_allocator(alloc) \
+	list_for_each_entry(alloc, &cma_allocators, list)
+
+int cma_allocator_register(struct cma_allocator *alloc)
+{
+	struct cma_region *reg;
+	int first;
+
+	if (!alloc->alloc || !alloc->free)
+		return -EINVAL;
+
+	/* alloc->users = 0; */
+
+	mutex_lock(&cma_mutex);
+
+	first = list_empty(&cma_allocators);
+
+	list_add_tail(&alloc->list, &cma_allocators);
+
+	/*
+	 * Attach this allocator to all allocator-less regions that
+	 * request this particular allocator (reg->alloc_name equals
+	 * alloc->name) or if region wants the first available
+	 * allocator and we are the first.
+	 */
+	cma_foreach_region(reg) {
+		if (reg->alloc)
+			continue;
+		if (reg->alloc_name
+		  ? alloc->name && !strcmp(alloc->name, reg->alloc_name)
+		  : (!reg->used && first))
+			continue;
+
+		reg->alloc = alloc;
+		__cma_region_attach_alloc(reg);
+	}
+
+	mutex_unlock(&cma_mutex);
+
+	pr_debug("%s: allocator registered\n", alloc->name ?: "(unnamed)");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cma_allocator_register);
+
+static struct cma_allocator *__must_check
+__cma_allocator_find(const char *name)
+{
+	struct cma_allocator *alloc;
+
+	if (!name)
+		return list_empty(&cma_allocators)
+			? NULL
+			: list_entry(cma_allocators.next,
+				     struct cma_allocator, list);
+
+	cma_foreach_allocator(alloc)
+		if (alloc->name && !strcmp(name, alloc->name))
+			return alloc;
+
+	return NULL;
+}
+
+
+
+/************************* Initialise CMA *************************/
+
+int __init cma_set_defaults(char *regions, const char *map,
+                            const char *asterisk)
+{
+	if (map)
+		cma_map = map;
+
+	if (asterisk)
+		cma_asterisk = asterisk;
+
+	if (regions)
+		return cma_param_parse(regions);
+	else
+		return 0;
+}
+
+
+int __init cma_early_region_reserve(struct cma_region *reg)
+{
+	int tried = 0;
+
+	if (!reg->size || (reg->alignment & (reg->alignment - 1)) ||
+	    reg->reserved)
+		return -EINVAL;
+
+#ifndef CONFIG_NO_BOOTMEM
+
+	tried = 1;
+
+	{
+		void *ptr;
+
+		ptr = __alloc_bootmem_nopanic(reg->size, reg->alignment,
+					      reg->start);
+		if (ptr) {
+			reg->start = virt_to_phys(ptr);
+			reg->reserved = 1;
+			return 0;
+		}
+	}
+
+#endif
+
+#ifdef CONFIG_HAVE_MEMBLOCK
+
+	tried = 1;
+
+	if (reg->start) {
+		if (memblock_is_region_reserved(reg->start, reg->size) < 0 &&
+		    memblock_reserve(reg->start, reg->size) >= 0) {
+			reg->reserved = 1;
+			return 0;
+		}
+	} else {
+		/*
+		 * Use __memblock_alloc_base() since
+		 * memblock_alloc_base() panic()s.
+		 */
+		u64 ret = __memblock_alloc_base(reg->size, reg->alignment, 0);
+		if (ret &&
+		    ret < ~(dma_addr_t)0 &&
+		    ret + reg->size < ~(dma_addr_t)0 &&
+		    ret + reg->size > ret) {
+			reg->start = ret;
+			reg->reserved = 1;
+			return 0;
+		}
+
+		if (ret)
+			memblock_free(ret, reg->size);
+	}
+
+#endif
+
+	return tried ? -ENOMEM : -EOPNOTSUPP;
+}
+
+void __init cma_early_regions_reserve(int (*reserve)(struct cma_region *reg))
+{
+	struct cma_region *reg;
+
+	pr_debug("init: reserving early regions\n");
+
+	if (!reserve)
+		reserve = cma_early_region_reserve;
+
+	list_for_each_entry(reg, &cma_early_regions, list) {
+		if (reg->reserved) {
+			/* nothing */
+		} else if (reserve(reg) >= 0) {
+			pr_debug("init: %s: reserved %p@%p\n",
+				 reg->name ?: "(private)",
+				 (void *)reg->size, (void *)reg->start);
+			reg->reserved = 1;
+		} else {
+			pr_warn("init: %s: unable to reserve %p@%p/%p\n",
+				reg->name ?: "(private)",
+				(void *)reg->size, (void *)reg->start,
+				(void *)reg->alignment);
+		}
+	}
+}
+
+
+static int __init cma_init(void)
+{
+	struct cma_region *reg, *n;
+
+	pr_debug("init: initialising\n");
+
+	cma_kobj = kobject_create_and_add("contiguous", mm_kobj);
+	if (unlikely(!cma_kobj))
+		pr_err("init: unable to add sysfs directory\n");
+
+	cma_attributes_init();
+
+	list_for_each_entry_safe(reg, n, &cma_early_regions, list) {
+		INIT_LIST_HEAD(&reg->list);
+		/*
+		 * We don't care if there was an error.  It's a pity
+		 * but there's not much we can do about it any way.
+		 * If the error is on a region that was parsed from
+		 * command line then it will stay and waste a bit of
+		 * space; if it was registered using
+		 * cma_early_region_register() it's caller's
+		 * responsibility to do something about it.
+		 */
+		if (reg->reserved && cma_region_register(reg) < 0)
+			/* ignore error */;
+	}
+
+	INIT_LIST_HEAD(&cma_early_regions);
+
+	return 0;
+}
+__initcall(cma_init);
+
+
+
+/************************* Chunks *************************/
+
+/* All chunks sorted by start address. */
+static struct rb_root cma_chunks_by_start;
+
+static struct cma_chunk *__must_check __cma_chunk_find(dma_addr_t addr)
+{
+	struct cma_chunk *chunk;
+	struct rb_node *n;
+
+	for (n = cma_chunks_by_start.rb_node; n; ) {
+		chunk = rb_entry(n, struct cma_chunk, by_start);
+		if (addr < chunk->start)
+			n = n->rb_left;
+		else if (addr > chunk->start)
+			n = n->rb_right;
+		else
+			return chunk;
+	}
+	WARN("no chunk starting at %p\n", (void *)addr);
+	return NULL;
+}
+
+static int __must_check __cma_chunk_insert(struct cma_chunk *chunk)
+{
+	struct rb_node **new, *parent = NULL;
+	typeof(chunk->start) addr = chunk->start;
+
+	for (new = &cma_chunks_by_start.rb_node; *new; ) {
+		struct cma_chunk *c =
+			container_of(*new, struct cma_chunk, by_start);
+
+		parent = *new;
+		if (addr < c->start) {
+			new = &(*new)->rb_left;
+		} else if (addr > c->start) {
+			new = &(*new)->rb_right;
+		} else {
+			/*
+			 * We should never be here.  If we are it
+			 * means allocator gave us an invalid chunk
+			 * (one that has already been allocated) so we
+			 * refuse to accept it.  Our caller will
+			 * recover by freeing the chunk.
+			 */
+			WARN_ON(1);
+			return -EADDRINUSE;
+		}
+	}
+
+	rb_link_node(&chunk->by_start, parent, new);
+	rb_insert_color(&chunk->by_start, &cma_chunks_by_start);
+
+	return 0;
+}
+
+static void __cma_chunk_release(struct kref *ref)
+{
+	struct cma_chunk *chunk = container_of(ref, struct cma_chunk, ref);
+
+	rb_erase(&chunk->by_start, &cma_chunks_by_start);
+
+	chunk->reg->alloc->free(chunk);
+	/* --chunk->reg->users; */
+	chunk->reg->free_space += chunk->size;
+}
+
+
+
+/************************* The Device API *************************/
+
+static const char *__must_check
+__cma_where_from(const struct device *dev, const char *kind);
+
+
+/* Allocate. */
+
+static dma_addr_t __must_check
+__cma_alloc_from_region(struct cma_region *reg,
+			size_t size, dma_addr_t alignment)
+{
+	struct cma_chunk *chunk;
+
+	if (!reg || reg->free_space < size)
+		return -ENOMEM;
+
+	if (!reg->alloc) {
+		if (!reg->used)
+			__cma_region_attach_alloc(reg);
+		if (!reg->alloc)
+			return -ENOMEM;
+	}
+
+	chunk = reg->alloc->alloc(reg, size, alignment);
+	if (!chunk)
+		return -ENOMEM;
+
+	if (unlikely(__cma_chunk_insert(chunk) < 0)) {
+		/* We should *never* be here. */
+		chunk->reg->alloc->free(chunk);
+		kfree(chunk);
+		return -EADDRINUSE;
+	}
+
+	chunk->reg = reg;
+	kref_init(&chunk->ref);
+	/* ++reg->users; */
+	reg->free_space -= chunk->size;
+	pr_debug("allocated at %p\n", (void *)chunk->start);
+	return chunk->start;
+}
+
+dma_addr_t __must_check
+cma_alloc_from_region(struct cma_region *reg,
+		      size_t size, dma_addr_t alignment)
+{
+	dma_addr_t addr;
+
+	mutex_lock(&cma_mutex);
+
+	pr_debug("allocate %p/%p from %s\n",
+		 (void *)size, (void *)alignment,
+		 reg ? reg->name ?: "(private)" : "(null)");
+
+	if (!size || alignment & (alignment - 1) || !reg->registered)
+		addr = -EINVAL;
+	else
+		addr = __cma_alloc_from_region(reg, PAGE_ALIGN(size),
+					       max(alignment, (dma_addr_t)PAGE_SIZE));
+
+	mutex_unlock(&cma_mutex);
+
+	return addr;
+}
+EXPORT_SYMBOL_GPL(cma_alloc_from_region);
+
+dma_addr_t __must_check
+__cma_alloc(const struct device *dev, const char *kind,
+	    dma_addr_t size, dma_addr_t alignment)
+{
+	struct cma_region *reg;
+	const char *from;
+	dma_addr_t addr;
+
+	if (dev)
+		pr_debug("allocate %p/%p for %s/%s\n",
+			 (void *)size, (void *)alignment,
+			 dev_name(dev), kind ?: "");
+
+	if (!size || alignment & (alignment - 1))
+		return -EINVAL;
+
+	mutex_lock(&cma_mutex);
+
+	from = __cma_where_from(dev, kind);
+	if (unlikely(IS_ERR(from))) {
+		addr = PTR_ERR(from);
+		goto done;
+	}
+
+	pr_debug("allocate %p/%p from one of %s\n",
+		 (void *)size, (void *)alignment, from);
+
+	size = PAGE_ALIGN(size);
+	if (alignment < PAGE_SIZE)
+		alignment = PAGE_SIZE;
+
+	while (*from && *from != ';') {
+		reg = __cma_region_find(&from);
+		addr = __cma_alloc_from_region(reg, size, alignment);
+		if (!IS_ERR_VALUE(addr))
+			goto done;
+	}
+
+	pr_debug("not enough memory\n");
+	addr = -ENOMEM;
+
+done:
+	mutex_unlock(&cma_mutex);
+
+	return addr;
+}
+EXPORT_SYMBOL_GPL(__cma_alloc);
+
+
+/* Query information about regions. */
+int
+__cma_info(struct cma_info *infop, const struct device *dev, const char *kind)
+{
+	struct cma_info info = { ~(dma_addr_t)0, 0, 0, 0, 0 };
+	const char *from;
+	int ret;
+
+	if (unlikely(!infop))
+		return -EINVAL;
+
+	mutex_lock(&cma_mutex);
+
+	from = __cma_where_from(dev, kind);
+	if (IS_ERR(from)) {
+		ret = PTR_ERR(from);
+		info.lower_bound = 0;
+		goto done;
+	}
+
+	while (*from && *from != ';') {
+		struct cma_region *reg = __cma_region_find(&from);
+		if (reg) {
+			info.total_size += reg->size;
+			info.free_size += reg->free_space;
+			if (info.lower_bound > reg->start)
+				info.lower_bound = reg->start;
+			if (info.upper_bound < reg->start + reg->size)
+				info.upper_bound = reg->start + reg->size;
+			++info.count;
+		}
+	}
+
+	ret = 0;
+done:
+	mutex_unlock(&cma_mutex);
+	memcpy(infop, &info, sizeof info);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__cma_info);
+
+
+/* kref handling. */
+
+int cma_get(dma_addr_t addr)
+{
+	struct cma_chunk *c;
+
+	mutex_lock(&cma_mutex);
+	c = __cma_chunk_find(addr);
+	if (c)
+		kref_get(&c->ref);
+	mutex_unlock(&cma_mutex);
+
+	pr_debug("get(%p): %sfound\n", (void *)addr, c ? "" : "not ");
+	return c ? 0 : -ENOENT;
+}
+EXPORT_SYMBOL_GPL(cma_get);
+
+int cma_put(dma_addr_t addr)
+{
+	struct cma_chunk *c;
+	int ret;
+
+	mutex_lock(&cma_mutex);
+	c = __cma_chunk_find(addr);
+	ret = c ? kref_put(&c->ref, __cma_chunk_release) : -ENOENT;
+	mutex_unlock(&cma_mutex);
+
+	pr_debug("put(%p): %sfound%s\n", (void *)addr, c ? "" : "not ",
+		 ret > 0 ? " and destroyed" : "");
+	return ret;
+}
+EXPORT_SYMBOL_GPL(cma_put);
+
+
+/************************* Miscellaneous *************************/
+
+static int __cma_region_attach_alloc(struct cma_region *reg)
+{
+	struct cma_allocator *alloc;
+	int ret;
+
+	/*
+	 * If reg->alloc is set then caller wants us to use this
+	 * allocator.  Otherwise we need to find one by name.
+	 */
+	if (reg->alloc) {
+		alloc = reg->alloc;
+	} else {
+		alloc = __cma_allocator_find(reg->alloc_name);
+		if (!alloc) {
+			pr_warn("init: %s: %s: no such allocator\n",
+				reg->name ?: "(private)",
+				reg->alloc_name ?: "(default)");
+			reg->used = 1;
+			return -ENOENT;
+		}
+	}
+
+	/* Try to initialise the allocator. */
+	reg->private_data = NULL;
+	ret = alloc->init ? alloc->init(reg) : 0;
+	if (unlikely(ret < 0)) {
+		pr_err("init: %s: %s: unable to initialise allocator\n",
+		       reg->name ?: "(private)", alloc->name ?: "(unnamed)");
+		reg->alloc = NULL;
+		reg->used = 1;
+	} else {
+		reg->alloc = alloc;
+		/* ++alloc->users; */
+		pr_debug("init: %s: %s: initialised allocator\n",
+			 reg->name ?: "(private)", alloc->name ?: "(unnamed)");
+	}
+	return ret;
+}
+
+
+/*
+ * s            ::= rules
+ * rules        ::= rule [ ';' rules ]
+ * rule         ::= patterns '=' [ regions ]
+ * patterns     ::= pattern [ ',' patterns ]
+ * pattern      ::= dev-pattern [ '/' kind-pattern ]
+ *                | '/' kind-pattern
+ */
+static const char *__must_check
+__cma_where_from(const struct device *dev, const char *kind)
+{
+	/*
+	 * This function matches the pattern from the map attribute
+	 * agains given device name and kind.  Kind may be of course
+	 * NULL or an emtpy string.
+	 */
+
+	const char *s, *name;
+	int name_matched = 0;
+
+	/*
+	 * If dev is NULL we were called in alternative form where
+	 * kind is the from string.  All we have to do is return it
+	 * unless it's NULL or "*" in which case we return
+	 * cma_asterisk.
+	 */
+	if (!dev) {
+		if (!kind || *kind == '*')
+			return cma_asterisk ?: ERR_PTR(-ENOENT);
+		else
+			return kind;
+	}
+
+	if (!cma_map)
+		return cma_asterisk ?: ERR_PTR(-ENOENT);
+
+	name = dev_name(dev);
+	if (WARN_ON(!name || !*name))
+		return ERR_PTR(-EINVAL);
+
+	if (!kind)
+		kind = "";
+
+	/*
+	 * Now we go throught the cma_map parameter.  It is what has
+	 * been provided by command line.
+	 */
+	for (s = cma_map; *s; ++s) {
+		const char *c;
+
+		/*
+		 * If the pattern starts with a slash, the device part of the
+		 * pattern matches if it matched previously.
+		 */
+		if (*s == '/') {
+			if (!name_matched)
+				goto look_for_next;
+			goto match_kind;
+		}
+
+		/*
+		 * We are now trying to match the device name.  This also
+		 * updates the name_matched variable.  If, while reading the
+		 * spec, we ecnounter comma it means that the pattern does not
+		 * match and we need to start over with another pattern (the
+		 * one afther the comma).  If we encounter equal sign we need
+		 * to start over with another rule.  If there is a character
+		 * that does not match, we neet to look for a comma (to get
+		 * another pattern) or semicolon (to get another rule) and try
+		 * again if there is one semowhere.
+		 */
+
+		name_matched = 0;
+
+		for (c = name; *s != '*' && *c; ++c, ++s)
+			if (*s == '=')
+				goto next_rule;
+			else if (*s == ',')
+				continue;
+			else if (*s != '?' && *c != *s)
+				goto look_for_next;
+		if (*s == '*')
+			++s;
+
+		name_matched = 1;
+
+		/*
+		 * Now we need to match the kind part of the pattern.  If the
+		 * pattern is missing it we match only if kind points to an
+		 * empty string.  Otherwise wy try to match it just like name.
+		 */
+		if (*s != '/') {
+			if (*kind)
+				goto look_for_next;
+		} else {
+match_kind:		/* s points to '/' */
+			++s;
+
+			for (c = kind; *s != '*' && *c; ++c, ++s)
+				if (*s == '=')
+					goto next_rule;
+				else if (*s == ',')
+					continue;
+				else if (*s != '?' && *c != *s)
+					goto look_for_next;
+			if (*s == '*')
+				++s;
+		}
+
+		/* Return the string behind the '=' sign of the rule. */
+		if (*s == '=' || *s == ',') {
+			s = strchr(s, '=') + 1;
+			return *s == '*' ? cma_asterisk ?: ERR_PTR(-ENOENT) : s;
+		}
+
+look_for_next:
+		do {
+			++s;
+		} while (*s != ',' && *s != '=');
+		if (*s == ',')
+			continue;
+
+next_rule:	/* s points to '=' */
+		s = strchr(s, ';');
+		if (!s)
+			break;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
-- 
1.7.1

