Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34270 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0HRDBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Aug 2010 23:01:37 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1281100495.git.m.nazarewicz@samsung.com>
References: <cover.1281100495.git.m.nazarewicz@samsung.com>
Date: Wed, 18 Aug 2010 12:01:35 +0900
Message-ID: <AANLkTikp49oOny-vrtRTsJvA3Sps08=w7__JjdA3FE8t@mail.gmail.com>
Subject: Re: [PATCH/RFCv3 0/6] The Contiguous Memory Allocator framework
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	Daniel Walker <dwalker@codeaurora.org>,
	Russell King <linux@arm.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Pawel Osciak <p.osciak@samsung.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	linux-kernel@vger.kernel.org, Hiremath Vaibhav <hvaibhav@ti.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, kgene.kim@samsung.com,
	Zach Pfeffer <zpfeffer@codeaurora.org>, jaeryul.oh@samsung.com,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Are there any comments or ack?

We hope this method included at mainline kernel if possible.
It's really needed feature for our multimedia frameworks.

Thank you,
Kyungmin Park

On Fri, Aug 6, 2010 at 10:22 PM, Michal Nazarewicz
<m.nazarewicz@samsung.com> wrote:
> Hello everyone,
>
> The following patchset implements a Contiguous Memory Allocator. �For
> those who have not yet stumbled across CMA an excerpt from
> documentation:
>
> � The Contiguous Memory Allocator (CMA) is a framework, which allows
> � setting up a machine-specific configuration for physically-contiguous
> � memory management. Memory for devices is then allocated according
> � to that configuration.
>
> � The main role of the framework is not to allocate memory, but to
> � parse and manage memory configurations, as well as to act as an
> � in-between between device drivers and pluggable allocators. It is
> � thus not tied to any memory allocation method or strategy.
>
> For more information please refer to the second patch from the
> patchset which contains the documentation.
>
>
> Links to the previous versions of the patchsets:
> v2: <http://article.gmane.org/gmane.linux.kernel.mm/50986/>
> v1: <http://article.gmane.org/gmane.linux.kernel.mm/50669/>
>
>
> This is the third version of the patchset. �All of the changes are
> concentrated in the second, the third and the fourth patch -- the
> other patches are almost identical.
>
>
> Major observable changes between the second (the previous) and the
> third (this) versions are:
>
> 1. The command line parameters have been removed (and moved to
> � a separate patch, the fourth one). �As a consequence, the
> � cma_set_defaults() function has been changed -- it no longer
> � accepts a string with list of regions but an array of regions.
>
> 2. The "asterisk" attribute has been removed. �Now, each region has an
> � "asterisk" flag which lets one specify whether this region should
> � by considered "asterisk" region.
>
> 3. SysFS support has been moved to a separate patch (the third one in
> � the series) and now also includes list of regions.
>
>
> Major observable changes between the first and the second versions
> are:
>
> 1. The "cma_map" command line have been removed. �In exchange, a SysFS
> � entry has been created under kernel/mm/contiguous.
>
> � The intended way of specifying the attributes is
> � a cma_set_defaults() function called by platform initialisation
> � code. �"regions" attribute (the string specified by "cma" command
> � line parameter) can be overwritten with command line parameter; the
> � other attributes can be changed during run-time using the SysFS
> � entries.
>
> 2. The behaviour of the "map" attribute has been modified slightly.
> � Currently, if no rule matches given device it is assigned regions
> � specified by the "asterisk" attribute. �It is by default built from
> � the region names given in "regions" attribute.
>
> 3. Devices can register private regions as well as regions that can be
> � shared but are not reserved using standard CMA mechanisms.
> � A private region has no name and can be accessed only by devices
> � that have the pointer to it.
>
> 4. The way allocators are registered has changed. �Currently,
> � a cma_allocator_register() function is used for that purpose.
> � Moreover, allocators are attached to regions the first time memory
> � is registered from the region or when allocator is registered which
> � means that allocators can be dynamic modules that are loaded after
> � the kernel booted (of course, it won't be possible to allocate
> � a chunk of memory from a region if allocator is not loaded).
>
> 5. Index of new functions:
>
> +static inline dma_addr_t __must_check
> +cma_alloc_from(const char *regions, size_t size, dma_addr_t alignment)
>
> +static inline int
> +cma_info_about(struct cma_info *info, const const char *regions)
>
> +int __must_check cma_region_register(struct cma_region *reg);
>
> +dma_addr_t __must_check
> +cma_alloc_from_region(struct cma_region *reg,
> + � � � � � � � � � � size_t size, dma_addr_t alignment);
>
> +static inline dma_addr_t __must_check
> +cma_alloc_from(const char *regions,
> + � � � � � � � size_t size, dma_addr_t alignment);
>
> +int cma_allocator_register(struct cma_allocator *alloc);
>
>
> Michal Nazarewicz (6):
> �lib: rbtree: rb_root_init() function added
> �mm: cma: Contiguous Memory Allocator added
> �mm: cma: Added SysFS support
> �mm: cma: Added command line parameters support
> �mm: cma: Test device and application added
> �arm: Added CMA to Aquila and Goni
>
> �Documentation/00-INDEX � � � � � � � � � � � � � � | � �2 +
> �.../ABI/testing/sysfs-kernel-mm-contiguous � � � � | � 58 +
> �Documentation/contiguous-memory.txt � � � � � � � �| �651 +++++++++
> �Documentation/kernel-parameters.txt � � � � � � � �| � �4 +
> �arch/arm/mach-s5pv210/mach-aquila.c � � � � � � � �| � 31 +
> �arch/arm/mach-s5pv210/mach-goni.c � � � � � � � � �| � 31 +
> �drivers/misc/Kconfig � � � � � � � � � � � � � � � | � �8 +
> �drivers/misc/Makefile � � � � � � � � � � � � � � �| � �1 +
> �drivers/misc/cma-dev.c � � � � � � � � � � � � � � | �184 +++
> �include/linux/cma.h � � � � � � � � � � � � � � � �| �475 +++++++
> �include/linux/rbtree.h � � � � � � � � � � � � � � | � 11 +
> �mm/Kconfig � � � � � � � � � � � � � � � � � � � � | � 54 +
> �mm/Makefile � � � � � � � � � � � � � � � � � � � �| � �2 +
> �mm/cma-best-fit.c � � � � � � � � � � � � � � � � �| �407 ++++++
> �mm/cma.c � � � � � � � � � � � � � � � � � � � � � | 1446 ++++++++++++++++++++
> �tools/cma/cma-test.c � � � � � � � � � � � � � � � | �373 +++++
> �16 files changed, 3738 insertions(+), 0 deletions(-)
> �create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-contiguous
> �create mode 100644 Documentation/contiguous-memory.txt
> �create mode 100644 drivers/misc/cma-dev.c
> �create mode 100644 include/linux/cma.h
> �create mode 100644 mm/cma-best-fit.c
> �create mode 100644 mm/cma.c
> �create mode 100644 tools/cma/cma-test.c
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
