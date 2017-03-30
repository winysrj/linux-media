Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52648 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934842AbdC3ULq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:46 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Takashi Iwai <tiwai@suse.de>,
        Markus Heiser <markus.heiser@darmarit.de>,
        Silvio Fricke <silvio.fricke@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/9] kernel-api.tmpl: convert it to ReST
Date: Thu, 30 Mar 2017 17:11:32 -0300
Message-Id: <0186e4eb40e09f92a7ec59f195d93af38176433f.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brainless conversion of genericirq.tmpl book to ReST, via
	Documentation/sphinx/tmplcvt

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/Makefile        |   2 +-
 Documentation/DocBook/kernel-api.tmpl | 331 ---------------------------
 Documentation/core-api/index.rst      |   1 +
 Documentation/core-api/kernel-api.rst | 419 ++++++++++++++++++++++++++++++++++
 4 files changed, 421 insertions(+), 332 deletions(-)
 delete mode 100644 Documentation/DocBook/kernel-api.tmpl
 create mode 100644 Documentation/core-api/kernel-api.rst

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index e0c13655f770..13056d40e11b 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -9,7 +9,7 @@
 DOCBOOKS := z8530book.xml  \
 	    kernel-hacking.xml kernel-locking.xml \
 	    networking.xml \
-	    kernel-api.xml filesystems.xml lsm.xml kgdb.xml \
+	    filesystems.xml lsm.xml kgdb.xml \
 	    libata.xml mtdnand.xml librs.xml rapidio.xml \
 	    s390-drivers.xml scsi.xml \
 	    sh.xml w1.xml
diff --git a/Documentation/DocBook/kernel-api.tmpl b/Documentation/DocBook/kernel-api.tmpl
deleted file mode 100644
index ecfd0ea40661..000000000000
--- a/Documentation/DocBook/kernel-api.tmpl
+++ /dev/null
@@ -1,331 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-
-<book id="LinuxKernelAPI">
- <bookinfo>
-  <title>The Linux Kernel API</title>
-  
-  <legalnotice>
-   <para>
-     This documentation is free software; you can redistribute
-     it and/or modify it under the terms of the GNU General Public
-     License as published by the Free Software Foundation; either
-     version 2 of the License, or (at your option) any later
-     version.
-   </para>
-      
-   <para>
-     This program is distributed in the hope that it will be
-     useful, but WITHOUT ANY WARRANTY; without even the implied
-     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
-     See the GNU General Public License for more details.
-   </para>
-      
-   <para>
-     You should have received a copy of the GNU General Public
-     License along with this program; if not, write to the Free
-     Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
-     MA 02111-1307 USA
-   </para>
-      
-   <para>
-     For more details see the file COPYING in the source
-     distribution of Linux.
-   </para>
-  </legalnotice>
- </bookinfo>
-
-<toc></toc>
-
-  <chapter id="adt">
-     <title>Data Types</title>
-     <sect1><title>Doubly Linked Lists</title>
-!Iinclude/linux/list.h
-     </sect1>
-  </chapter>
-
-  <chapter id="libc">
-     <title>Basic C Library Functions</title>
-
-     <para>
-       When writing drivers, you cannot in general use routines which are
-       from the C Library.  Some of the functions have been found generally
-       useful and they are listed below.  The behaviour of these functions
-       may vary slightly from those defined by ANSI, and these deviations
-       are noted in the text.
-     </para>
-
-     <sect1><title>String Conversions</title>
-!Elib/vsprintf.c
-!Finclude/linux/kernel.h kstrtol
-!Finclude/linux/kernel.h kstrtoul
-!Elib/kstrtox.c
-     </sect1>
-     <sect1><title>String Manipulation</title>
-<!-- All functions are exported at now
-X!Ilib/string.c
- -->
-!Elib/string.c
-     </sect1>
-     <sect1><title>Bit Operations</title>
-!Iarch/x86/include/asm/bitops.h
-     </sect1>
-  </chapter>
-
-  <chapter id="kernel-lib">
-     <title>Basic Kernel Library Functions</title>
-
-     <para>
-       The Linux kernel provides more basic utility functions.
-     </para>
-
-     <sect1><title>Bitmap Operations</title>
-!Elib/bitmap.c
-!Ilib/bitmap.c
-     </sect1>
-
-     <sect1><title>Command-line Parsing</title>
-!Elib/cmdline.c
-     </sect1>
-
-     <sect1 id="crc"><title>CRC Functions</title>
-!Elib/crc7.c
-!Elib/crc16.c
-!Elib/crc-itu-t.c
-!Elib/crc32.c
-!Elib/crc-ccitt.c
-     </sect1>
-
-     <sect1 id="idr"><title>idr/ida Functions</title>
-!Pinclude/linux/idr.h idr sync
-!Plib/idr.c IDA description
-!Elib/idr.c
-     </sect1>
-  </chapter>
-
-  <chapter id="mm">
-     <title>Memory Management in Linux</title>
-     <sect1><title>The Slab Cache</title>
-!Iinclude/linux/slab.h
-!Emm/slab.c
-!Emm/util.c
-     </sect1>
-     <sect1><title>User Space Memory Access</title>
-!Iarch/x86/include/asm/uaccess_32.h
-!Earch/x86/lib/usercopy_32.c
-     </sect1>
-     <sect1><title>More Memory Management Functions</title>
-!Emm/readahead.c
-!Emm/filemap.c
-!Emm/memory.c
-!Emm/vmalloc.c
-!Imm/page_alloc.c
-!Emm/mempool.c
-!Emm/dmapool.c
-!Emm/page-writeback.c
-!Emm/truncate.c
-     </sect1>
-  </chapter>
-
-
-  <chapter id="ipc">
-     <title>Kernel IPC facilities</title>
-
-     <sect1><title>IPC utilities</title>
-!Iipc/util.c
-     </sect1>
-  </chapter>
-
-  <chapter id="kfifo">
-     <title>FIFO Buffer</title>
-     <sect1><title>kfifo interface</title>
-!Iinclude/linux/kfifo.h
-     </sect1>
-  </chapter>
-
-  <chapter id="relayfs">
-     <title>relay interface support</title>
-
-     <para>
-	Relay interface support
-	is designed to provide an efficient mechanism for tools and
-	facilities to relay large amounts of data from kernel space to
-	user space.
-     </para>
-
-     <sect1><title>relay interface</title>
-!Ekernel/relay.c
-!Ikernel/relay.c
-     </sect1>
-  </chapter>
-
-  <chapter id="modload">
-     <title>Module Support</title>
-     <sect1><title>Module Loading</title>
-!Ekernel/kmod.c
-     </sect1>
-     <sect1><title>Inter Module support</title>
-        <para>
-           Refer to the file kernel/module.c for more information.
-        </para>
-<!-- FIXME: Removed for now since no structured comments in source
-X!Ekernel/module.c
--->
-     </sect1>
-  </chapter>
-
-  <chapter id="hardware">
-     <title>Hardware Interfaces</title>
-     <sect1><title>Interrupt Handling</title>
-!Ekernel/irq/manage.c
-     </sect1>
-
-     <sect1><title>DMA Channels</title>
-!Ekernel/dma.c
-     </sect1>
-
-     <sect1><title>Resources Management</title>
-!Ikernel/resource.c
-!Ekernel/resource.c
-     </sect1>
-
-     <sect1><title>MTRR Handling</title>
-!Earch/x86/kernel/cpu/mtrr/main.c
-     </sect1>
-
-     <sect1><title>PCI Support Library</title>
-!Edrivers/pci/pci.c
-!Edrivers/pci/pci-driver.c
-!Edrivers/pci/remove.c
-!Edrivers/pci/search.c
-!Edrivers/pci/msi.c
-!Edrivers/pci/bus.c
-!Edrivers/pci/access.c
-!Edrivers/pci/irq.c
-!Edrivers/pci/htirq.c
-<!-- FIXME: Removed for now since no structured comments in source
-X!Edrivers/pci/hotplug.c
--->
-!Edrivers/pci/probe.c
-!Edrivers/pci/slot.c
-!Edrivers/pci/rom.c
-!Edrivers/pci/iov.c
-!Idrivers/pci/pci-sysfs.c
-     </sect1>
-     <sect1><title>PCI Hotplug Support Library</title>
-!Edrivers/pci/hotplug/pci_hotplug_core.c
-     </sect1>
-  </chapter>
-
-  <chapter id="firmware">
-     <title>Firmware Interfaces</title>
-     <sect1><title>DMI Interfaces</title>
-!Edrivers/firmware/dmi_scan.c
-     </sect1>
-     <sect1><title>EDD Interfaces</title>
-!Idrivers/firmware/edd.c
-     </sect1>
-  </chapter>
-
-  <chapter id="security">
-     <title>Security Framework</title>
-!Isecurity/security.c
-!Esecurity/inode.c
-  </chapter>
-
-  <chapter id="audit">
-     <title>Audit Interfaces</title>
-!Ekernel/audit.c
-!Ikernel/auditsc.c
-!Ikernel/auditfilter.c
-  </chapter>
-
-  <chapter id="accounting">
-     <title>Accounting Framework</title>
-!Ikernel/acct.c
-  </chapter>
-
-  <chapter id="blkdev">
-     <title>Block Devices</title>
-!Eblock/blk-core.c
-!Iblock/blk-core.c
-!Eblock/blk-map.c
-!Iblock/blk-sysfs.c
-!Eblock/blk-settings.c
-!Eblock/blk-exec.c
-!Eblock/blk-flush.c
-!Eblock/blk-lib.c
-!Eblock/blk-tag.c
-!Iblock/blk-tag.c
-!Eblock/blk-integrity.c
-!Ikernel/trace/blktrace.c
-!Iblock/genhd.c
-!Eblock/genhd.c
-  </chapter>
-
-  <chapter id="chrdev">
-	<title>Char devices</title>
-!Efs/char_dev.c
-  </chapter>
-
-  <chapter id="miscdev">
-     <title>Miscellaneous Devices</title>
-!Edrivers/char/misc.c
-  </chapter>
-
-  <chapter id="clk">
-     <title>Clock Framework</title>
-
-     <para>
-	The clock framework defines programming interfaces to support
-	software management of the system clock tree.
-	This framework is widely used with System-On-Chip (SOC) platforms
-	to support power management and various devices which may need
-	custom clock rates.
-	Note that these "clocks" don't relate to timekeeping or real
-	time clocks (RTCs), each of which have separate frameworks.
-	These <structname>struct clk</structname> instances may be used
-	to manage for example a 96 MHz signal that is used to shift bits
-	into and out of peripherals or busses, or otherwise trigger
-	synchronous state machine transitions in system hardware.
-     </para>
-
-     <para>
-	Power management is supported by explicit software clock gating:
-	unused clocks are disabled, so the system doesn't waste power
-	changing the state of transistors that aren't in active use.
-	On some systems this may be backed by hardware clock gating,
-	where clocks are gated without being disabled in software.
-	Sections of chips that are powered but not clocked may be able
-	to retain their last state.
-	This low power state is often called a <emphasis>retention
-	mode</emphasis>.
-	This mode still incurs leakage currents, especially with finer
-	circuit geometries, but for CMOS circuits power is mostly used
-	by clocked state changes.
-     </para>
-
-     <para>
-	Power-aware drivers only enable their clocks when the device
-	they manage is in active use.  Also, system sleep states often
-	differ according to which clock domains are active:  while a
-	"standby" state may allow wakeup from several active domains, a
-	"mem" (suspend-to-RAM) state may require a more wholesale shutdown
-	of clocks derived from higher speed PLLs and oscillators, limiting
-	the number of possible wakeup event sources.  A driver's suspend
-	method may need to be aware of system-specific clock constraints
-	on the target sleep state.
-     </para>
-
-     <para>
-        Some platforms support programmable clock generators.  These
-	can be used by external chips of various kinds, such as other
-	CPUs, multimedia codecs, and devices with strict requirements
-	for interface clocking.
-     </para>
-
-!Iinclude/linux/clk.h
-  </chapter>
-
-</book>
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index c058febbd991..da64e2e7ddfd 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -11,6 +11,7 @@ Core utilities
 .. toctree::
    :maxdepth: 1
 
+   kernel-api
    assoc_array
    atomic_ops
    cpu_hotplug
diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
new file mode 100644
index 000000000000..e820247e90d3
--- /dev/null
+++ b/Documentation/core-api/kernel-api.rst
@@ -0,0 +1,419 @@
+====================
+The Linux Kernel API
+====================
+
+Data Types
+==========
+
+Doubly Linked Lists
+-------------------
+
+.. kernel-doc:: include/linux/list.h
+   :internal:
+
+Basic C Library Functions
+=========================
+
+When writing drivers, you cannot in general use routines which are from
+the C Library. Some of the functions have been found generally useful
+and they are listed below. The behaviour of these functions may vary
+slightly from those defined by ANSI, and these deviations are noted in
+the text.
+
+String Conversions
+------------------
+
+.. kernel-doc:: lib/vsprintf.c
+   :export:
+
+.. kernel-doc:: include/linux/kernel.h
+   :functions: kstrtol
+
+.. kernel-doc:: include/linux/kernel.h
+   :functions: kstrtoul
+
+.. kernel-doc:: lib/kstrtox.c
+   :export:
+
+String Manipulation
+-------------------
+
+.. kernel-doc:: lib/string.c
+   :export:
+
+Bit Operations
+--------------
+
+.. kernel-doc:: arch/x86/include/asm/bitops.h
+   :internal:
+
+Basic Kernel Library Functions
+==============================
+
+The Linux kernel provides more basic utility functions.
+
+Bitmap Operations
+-----------------
+
+.. kernel-doc:: lib/bitmap.c
+   :export:
+
+.. kernel-doc:: lib/bitmap.c
+   :internal:
+
+Command-line Parsing
+--------------------
+
+.. kernel-doc:: lib/cmdline.c
+   :export:
+
+CRC Functions
+-------------
+
+.. kernel-doc:: lib/crc7.c
+   :export:
+
+.. kernel-doc:: lib/crc16.c
+   :export:
+
+.. kernel-doc:: lib/crc-itu-t.c
+   :export:
+
+.. kernel-doc:: lib/crc32.c
+   :export:
+
+.. kernel-doc:: lib/crc-ccitt.c
+   :export:
+
+idr/ida Functions
+-----------------
+
+.. kernel-doc:: include/linux/idr.h
+   :doc: idr sync
+
+.. kernel-doc:: lib/idr.c
+   :doc: IDA description
+
+.. kernel-doc:: lib/idr.c
+   :export:
+
+Memory Management in Linux
+==========================
+
+The Slab Cache
+--------------
+
+.. kernel-doc:: include/linux/slab.h
+   :internal:
+
+.. kernel-doc:: mm/slab.c
+   :export:
+
+.. kernel-doc:: mm/util.c
+   :export:
+
+User Space Memory Access
+------------------------
+
+.. kernel-doc:: arch/x86/include/asm/uaccess_32.h
+   :internal:
+
+.. kernel-doc:: arch/x86/lib/usercopy_32.c
+   :export:
+
+More Memory Management Functions
+--------------------------------
+
+.. kernel-doc:: mm/readahead.c
+   :export:
+
+.. kernel-doc:: mm/filemap.c
+   :export:
+
+.. kernel-doc:: mm/memory.c
+   :export:
+
+.. kernel-doc:: mm/vmalloc.c
+   :export:
+
+.. kernel-doc:: mm/page_alloc.c
+   :internal:
+
+.. kernel-doc:: mm/mempool.c
+   :export:
+
+.. kernel-doc:: mm/dmapool.c
+   :export:
+
+.. kernel-doc:: mm/page-writeback.c
+   :export:
+
+.. kernel-doc:: mm/truncate.c
+   :export:
+
+Kernel IPC facilities
+=====================
+
+IPC utilities
+-------------
+
+.. kernel-doc:: ipc/util.c
+   :internal:
+
+FIFO Buffer
+===========
+
+kfifo interface
+---------------
+
+.. kernel-doc:: include/linux/kfifo.h
+   :internal:
+
+relay interface support
+=======================
+
+Relay interface support is designed to provide an efficient mechanism
+for tools and facilities to relay large amounts of data from kernel
+space to user space.
+
+relay interface
+---------------
+
+.. kernel-doc:: kernel/relay.c
+   :export:
+
+.. kernel-doc:: kernel/relay.c
+   :internal:
+
+Module Support
+==============
+
+Module Loading
+--------------
+
+.. kernel-doc:: kernel/kmod.c
+   :export:
+
+Inter Module support
+--------------------
+
+Refer to the file kernel/module.c for more information.
+
+Hardware Interfaces
+===================
+
+Interrupt Handling
+------------------
+
+.. kernel-doc:: kernel/irq/manage.c
+   :export:
+
+DMA Channels
+------------
+
+.. kernel-doc:: kernel/dma.c
+   :export:
+
+Resources Management
+--------------------
+
+.. kernel-doc:: kernel/resource.c
+   :internal:
+
+.. kernel-doc:: kernel/resource.c
+   :export:
+
+MTRR Handling
+-------------
+
+.. kernel-doc:: arch/x86/kernel/cpu/mtrr/main.c
+   :export:
+
+PCI Support Library
+-------------------
+
+.. kernel-doc:: drivers/pci/pci.c
+   :export:
+
+.. kernel-doc:: drivers/pci/pci-driver.c
+   :export:
+
+.. kernel-doc:: drivers/pci/remove.c
+   :export:
+
+.. kernel-doc:: drivers/pci/search.c
+   :export:
+
+.. kernel-doc:: drivers/pci/msi.c
+   :export:
+
+.. kernel-doc:: drivers/pci/bus.c
+   :export:
+
+.. kernel-doc:: drivers/pci/access.c
+   :export:
+
+.. kernel-doc:: drivers/pci/irq.c
+   :export:
+
+.. kernel-doc:: drivers/pci/htirq.c
+   :export:
+
+.. kernel-doc:: drivers/pci/probe.c
+   :export:
+
+.. kernel-doc:: drivers/pci/slot.c
+   :export:
+
+.. kernel-doc:: drivers/pci/rom.c
+   :export:
+
+.. kernel-doc:: drivers/pci/iov.c
+   :export:
+
+.. kernel-doc:: drivers/pci/pci-sysfs.c
+   :internal:
+
+PCI Hotplug Support Library
+---------------------------
+
+.. kernel-doc:: drivers/pci/hotplug/pci_hotplug_core.c
+   :export:
+
+Firmware Interfaces
+===================
+
+DMI Interfaces
+--------------
+
+.. kernel-doc:: drivers/firmware/dmi_scan.c
+   :export:
+
+EDD Interfaces
+--------------
+
+.. kernel-doc:: drivers/firmware/edd.c
+   :internal:
+
+Security Framework
+==================
+
+.. kernel-doc:: security/security.c
+   :internal:
+
+.. kernel-doc:: security/inode.c
+   :export:
+
+Audit Interfaces
+================
+
+.. kernel-doc:: kernel/audit.c
+   :export:
+
+.. kernel-doc:: kernel/auditsc.c
+   :internal:
+
+.. kernel-doc:: kernel/auditfilter.c
+   :internal:
+
+Accounting Framework
+====================
+
+.. kernel-doc:: kernel/acct.c
+   :internal:
+
+Block Devices
+=============
+
+.. kernel-doc:: block/blk-core.c
+   :export:
+
+.. kernel-doc:: block/blk-core.c
+   :internal:
+
+.. kernel-doc:: block/blk-map.c
+   :export:
+
+.. kernel-doc:: block/blk-sysfs.c
+   :internal:
+
+.. kernel-doc:: block/blk-settings.c
+   :export:
+
+.. kernel-doc:: block/blk-exec.c
+   :export:
+
+.. kernel-doc:: block/blk-flush.c
+   :export:
+
+.. kernel-doc:: block/blk-lib.c
+   :export:
+
+.. kernel-doc:: block/blk-tag.c
+   :export:
+
+.. kernel-doc:: block/blk-tag.c
+   :internal:
+
+.. kernel-doc:: block/blk-integrity.c
+   :export:
+
+.. kernel-doc:: kernel/trace/blktrace.c
+   :internal:
+
+.. kernel-doc:: block/genhd.c
+   :internal:
+
+.. kernel-doc:: block/genhd.c
+   :export:
+
+Char devices
+============
+
+.. kernel-doc:: fs/char_dev.c
+   :export:
+
+Miscellaneous Devices
+=====================
+
+.. kernel-doc:: drivers/char/misc.c
+   :export:
+
+Clock Framework
+===============
+
+The clock framework defines programming interfaces to support software
+management of the system clock tree. This framework is widely used with
+System-On-Chip (SOC) platforms to support power management and various
+devices which may need custom clock rates. Note that these "clocks"
+don't relate to timekeeping or real time clocks (RTCs), each of which
+have separate frameworks. These :c:type:`struct clk <clk>`
+instances may be used to manage for example a 96 MHz signal that is used
+to shift bits into and out of peripherals or busses, or otherwise
+trigger synchronous state machine transitions in system hardware.
+
+Power management is supported by explicit software clock gating: unused
+clocks are disabled, so the system doesn't waste power changing the
+state of transistors that aren't in active use. On some systems this may
+be backed by hardware clock gating, where clocks are gated without being
+disabled in software. Sections of chips that are powered but not clocked
+may be able to retain their last state. This low power state is often
+called a *retention mode*. This mode still incurs leakage currents,
+especially with finer circuit geometries, but for CMOS circuits power is
+mostly used by clocked state changes.
+
+Power-aware drivers only enable their clocks when the device they manage
+is in active use. Also, system sleep states often differ according to
+which clock domains are active: while a "standby" state may allow wakeup
+from several active domains, a "mem" (suspend-to-RAM) state may require
+a more wholesale shutdown of clocks derived from higher speed PLLs and
+oscillators, limiting the number of possible wakeup event sources. A
+driver's suspend method may need to be aware of system-specific clock
+constraints on the target sleep state.
+
+Some platforms support programmable clock generators. These can be used
+by external chips of various kinds, such as other CPUs, multimedia
+codecs, and devices with strict requirements for interface clocking.
+
+.. kernel-doc:: include/linux/clk.h
+   :internal:
-- 
2.9.3
