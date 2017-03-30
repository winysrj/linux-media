Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52480 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934820AbdC3ULq (ORCPT
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
Subject: [PATCH 3/9] genericirq.tmpl: convert it to ReST
Date: Thu, 30 Mar 2017 17:11:30 -0300
Message-Id: <de437318af3e6384319aba8d9e199a4645108822.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Brainless conversion of genericirq.tmpl book to ReST, via
	Documentation/sphinx/tmplcvt

Copyright information inserted manually.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/DocBook/Makefile        |   2 +-
 Documentation/DocBook/genericirq.tmpl | 520 ----------------------------------
 Documentation/core-api/genericirq.rst | 445 +++++++++++++++++++++++++++++
 Documentation/core-api/index.rst      |   1 +
 4 files changed, 447 insertions(+), 521 deletions(-)
 delete mode 100644 Documentation/DocBook/genericirq.tmpl
 create mode 100644 Documentation/core-api/genericirq.rst

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 7d94db2b53cd..e0c13655f770 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -11,7 +11,7 @@ DOCBOOKS := z8530book.xml  \
 	    networking.xml \
 	    kernel-api.xml filesystems.xml lsm.xml kgdb.xml \
 	    libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml scsi.xml \
+	    s390-drivers.xml scsi.xml \
 	    sh.xml w1.xml
 
 ifeq ($(DOCBOOKS),)
diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
deleted file mode 100644
index 59fb5c077541..000000000000
--- a/Documentation/DocBook/genericirq.tmpl
+++ /dev/null
@@ -1,520 +0,0 @@
-<?xml version="1.0" encoding="UTF-8"?>
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
-	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
-
-<book id="Generic-IRQ-Guide">
- <bookinfo>
-  <title>Linux generic IRQ handling</title>
-
-  <authorgroup>
-   <author>
-    <firstname>Thomas</firstname>
-    <surname>Gleixner</surname>
-    <affiliation>
-     <address>
-      <email>tglx@linutronix.de</email>
-     </address>
-    </affiliation>
-   </author>
-   <author>
-    <firstname>Ingo</firstname>
-    <surname>Molnar</surname>
-    <affiliation>
-     <address>
-      <email>mingo@elte.hu</email>
-     </address>
-    </affiliation>
-   </author>
-  </authorgroup>
-
-  <copyright>
-   <year>2005-2010</year>
-   <holder>Thomas Gleixner</holder>
-  </copyright>
-  <copyright>
-   <year>2005-2006</year>
-   <holder>Ingo Molnar</holder>
-  </copyright>
-
-  <legalnotice>
-   <para>
-     This documentation is free software; you can redistribute
-     it and/or modify it under the terms of the GNU General Public
-     License version 2 as published by the Free Software Foundation.
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
-  <chapter id="intro">
-    <title>Introduction</title>
-    <para>
-	The generic interrupt handling layer is designed to provide a
-	complete abstraction of interrupt handling for device drivers.
-	It is able to handle all the different types of interrupt controller
-	hardware. Device drivers use generic API functions to request, enable,
-	disable and free interrupts. The drivers do not have to know anything
-	about interrupt hardware details, so they can be used on different
-	platforms without code changes.
-    </para>
-    <para>
-  	This documentation is provided to developers who want to implement
-	an interrupt subsystem based for their architecture, with the help
-	of the generic IRQ handling layer.
-    </para>
-  </chapter>
-
-  <chapter id="rationale">
-    <title>Rationale</title>
-	<para>
-	The original implementation of interrupt handling in Linux uses
-	the __do_IRQ() super-handler, which is able to deal with every
-	type of interrupt logic.
-	</para>
-	<para>
-	Originally, Russell King identified different types of handlers to
-	build a quite universal set for the ARM interrupt handler
-	implementation in Linux 2.5/2.6. He distinguished between:
-	<itemizedlist>
-	  <listitem><para>Level type</para></listitem>
-	  <listitem><para>Edge type</para></listitem>
-	  <listitem><para>Simple type</para></listitem>
-	</itemizedlist>
-	During the implementation we identified another type:
-	<itemizedlist>
-	  <listitem><para>Fast EOI type</para></listitem>
-	</itemizedlist>
-	In the SMP world of the __do_IRQ() super-handler another type
-	was identified:
-	<itemizedlist>
-	  <listitem><para>Per CPU type</para></listitem>
-	</itemizedlist>
-	</para>
-	<para>
-	This split implementation of high-level IRQ handlers allows us to
-	optimize the flow of the interrupt handling for each specific
-	interrupt type. This reduces complexity in that particular code path
-	and allows the optimized handling of a given type.
-	</para>
-	<para>
-	The original general IRQ implementation used hw_interrupt_type
-	structures and their ->ack(), ->end() [etc.] callbacks to
-	differentiate the flow control in the super-handler. This leads to
-	a mix of flow logic and low-level hardware logic, and it also leads
-	to unnecessary code duplication: for example in i386, there is an
-	ioapic_level_irq and an ioapic_edge_irq IRQ-type which share many
-	of the low-level details but have different flow handling.
-	</para>
-	<para>
-	A more natural abstraction is the clean separation of the
-	'irq flow' and the 'chip details'.
-	</para>
-	<para>
-	Analysing a couple of architecture's IRQ subsystem implementations
-	reveals that most of them can use a generic set of 'irq flow'
-	methods and only need to add the chip-level specific code.
-	The separation is also valuable for (sub)architectures
-	which need specific quirks in the IRQ flow itself but not in the
-	chip details - and thus provides a more transparent IRQ subsystem
-	design.
-	</para>
-	<para>
-	Each interrupt descriptor is assigned its own high-level flow
-	handler, which is normally one of the generic
-	implementations. (This high-level flow handler implementation also
-	makes it simple to provide demultiplexing handlers which can be
-	found in embedded platforms on various architectures.)
-	</para>
-	<para>
-	The separation makes the generic interrupt handling layer more
-	flexible and extensible. For example, an (sub)architecture can
-	use a generic IRQ-flow implementation for 'level type' interrupts
-	and add a (sub)architecture specific 'edge type' implementation.
-	</para>
-	<para>
-	To make the transition to the new model easier and prevent the
-	breakage of existing implementations, the __do_IRQ() super-handler
-	is still available. This leads to a kind of duality for the time
-	being. Over time the new model should be used in more and more
-	architectures, as it enables smaller and cleaner IRQ subsystems.
-	It's deprecated for three years now and about to be removed.
-	</para>
-  </chapter>
-  <chapter id="bugs">
-    <title>Known Bugs And Assumptions</title>
-    <para>
-	None (knock on wood).
-    </para>
-  </chapter>
-
-  <chapter id="Abstraction">
-    <title>Abstraction layers</title>
-    <para>
-	There are three main levels of abstraction in the interrupt code:
-	<orderedlist>
-	  <listitem><para>High-level driver API</para></listitem>
-	  <listitem><para>High-level IRQ flow handlers</para></listitem>
-	  <listitem><para>Chip-level hardware encapsulation</para></listitem>
-	</orderedlist>
-    </para>
-    <sect1 id="Interrupt_control_flow">
-	<title>Interrupt control flow</title>
-	<para>
-	Each interrupt is described by an interrupt descriptor structure
-	irq_desc. The interrupt is referenced by an 'unsigned int' numeric
-	value which selects the corresponding interrupt description structure
-	in the descriptor structures array.
-	The descriptor structure contains status information and pointers
-	to the interrupt flow method and the interrupt chip structure
-	which are assigned to this interrupt.
-	</para>
-	<para>
-	Whenever an interrupt triggers, the low-level architecture code calls
-	into the generic interrupt code by calling desc->handle_irq().
-	This high-level IRQ handling function only uses desc->irq_data.chip
-	primitives referenced by the assigned chip descriptor structure.
-	</para>
-    </sect1>
-    <sect1 id="Highlevel_Driver_API">
-	<title>High-level Driver API</title>
-	<para>
-	  The high-level Driver API consists of following functions:
-	  <itemizedlist>
-	  <listitem><para>request_irq()</para></listitem>
-	  <listitem><para>free_irq()</para></listitem>
-	  <listitem><para>disable_irq()</para></listitem>
-	  <listitem><para>enable_irq()</para></listitem>
-	  <listitem><para>disable_irq_nosync() (SMP only)</para></listitem>
-	  <listitem><para>synchronize_irq() (SMP only)</para></listitem>
-	  <listitem><para>irq_set_irq_type()</para></listitem>
-	  <listitem><para>irq_set_irq_wake()</para></listitem>
-	  <listitem><para>irq_set_handler_data()</para></listitem>
-	  <listitem><para>irq_set_chip()</para></listitem>
-	  <listitem><para>irq_set_chip_data()</para></listitem>
-          </itemizedlist>
-	  See the autogenerated function documentation for details.
-	</para>
-    </sect1>
-    <sect1 id="Highlevel_IRQ_flow_handlers">
-	<title>High-level IRQ flow handlers</title>
-	<para>
-	  The generic layer provides a set of pre-defined irq-flow methods:
-	  <itemizedlist>
-	  <listitem><para>handle_level_irq</para></listitem>
-	  <listitem><para>handle_edge_irq</para></listitem>
-	  <listitem><para>handle_fasteoi_irq</para></listitem>
-	  <listitem><para>handle_simple_irq</para></listitem>
-	  <listitem><para>handle_percpu_irq</para></listitem>
-	  <listitem><para>handle_edge_eoi_irq</para></listitem>
-	  <listitem><para>handle_bad_irq</para></listitem>
-	  </itemizedlist>
-	  The interrupt flow handlers (either pre-defined or architecture
-	  specific) are assigned to specific interrupts by the architecture
-	  either during bootup or during device initialization.
-	</para>
-	<sect2 id="Default_flow_implementations">
-	<title>Default flow implementations</title>
-	    <sect3 id="Helper_functions">
-	 	<title>Helper functions</title>
-		<para>
-		The helper functions call the chip primitives and
-		are used by the default flow implementations.
-		The following helper functions are implemented (simplified excerpt):
-		<programlisting>
-default_enable(struct irq_data *data)
-{
-	desc->irq_data.chip->irq_unmask(data);
-}
-
-default_disable(struct irq_data *data)
-{
-	if (!delay_disable(data))
-		desc->irq_data.chip->irq_mask(data);
-}
-
-default_ack(struct irq_data *data)
-{
-	chip->irq_ack(data);
-}
-
-default_mask_ack(struct irq_data *data)
-{
-	if (chip->irq_mask_ack) {
-		chip->irq_mask_ack(data);
-	} else {
-		chip->irq_mask(data);
-		chip->irq_ack(data);
-	}
-}
-
-noop(struct irq_data *data))
-{
-}
-
-		</programlisting>
-	        </para>
-	    </sect3>
-	</sect2>
-	<sect2 id="Default_flow_handler_implementations">
-	<title>Default flow handler implementations</title>
-	    <sect3 id="Default_Level_IRQ_flow_handler">
-	 	<title>Default Level IRQ flow handler</title>
-		<para>
-		handle_level_irq provides a generic implementation
-		for level-triggered interrupts.
-		</para>
-		<para>
-		The following control flow is implemented (simplified excerpt):
-		<programlisting>
-desc->irq_data.chip->irq_mask_ack();
-handle_irq_event(desc->action);
-desc->irq_data.chip->irq_unmask();
-		</programlisting>
-		</para>
-	    </sect3>
-	    <sect3 id="Default_FASTEOI_IRQ_flow_handler">
-		<title>Default Fast EOI IRQ flow handler</title>
-		<para>
-		handle_fasteoi_irq provides a generic implementation
-		for interrupts, which only need an EOI at the end of
-		the handler.
-		</para>
-		<para>
-		The following control flow is implemented (simplified excerpt):
-		<programlisting>
-handle_irq_event(desc->action);
-desc->irq_data.chip->irq_eoi();
-		</programlisting>
-		</para>
-	    </sect3>
-	    <sect3 id="Default_Edge_IRQ_flow_handler">
-	 	<title>Default Edge IRQ flow handler</title>
-		<para>
-		handle_edge_irq provides a generic implementation
-		for edge-triggered interrupts.
-		</para>
-		<para>
-		The following control flow is implemented (simplified excerpt):
-		<programlisting>
-if (desc->status &amp; running) {
-	desc->irq_data.chip->irq_mask_ack();
-	desc->status |= pending | masked;
-	return;
-}
-desc->irq_data.chip->irq_ack();
-desc->status |= running;
-do {
-	if (desc->status &amp; masked)
-		desc->irq_data.chip->irq_unmask();
-	desc->status &amp;= ~pending;
-	handle_irq_event(desc->action);
-} while (status &amp; pending);
-desc->status &amp;= ~running;
-		</programlisting>
-		</para>
-   	    </sect3>
-	    <sect3 id="Default_simple_IRQ_flow_handler">
-	 	<title>Default simple IRQ flow handler</title>
-		<para>
-		handle_simple_irq provides a generic implementation
-		for simple interrupts.
-		</para>
-		<para>
-		Note: The simple flow handler does not call any
-		handler/chip primitives.
-		</para>
-		<para>
-		The following control flow is implemented (simplified excerpt):
-		<programlisting>
-handle_irq_event(desc->action);
-		</programlisting>
-		</para>
-   	    </sect3>
-	    <sect3 id="Default_per_CPU_flow_handler">
-	 	<title>Default per CPU flow handler</title>
-		<para>
-		handle_percpu_irq provides a generic implementation
-		for per CPU interrupts.
-		</para>
-		<para>
-		Per CPU interrupts are only available on SMP and
-		the handler provides a simplified version without
-		locking.
-		</para>
-		<para>
-		The following control flow is implemented (simplified excerpt):
-		<programlisting>
-if (desc->irq_data.chip->irq_ack)
-	desc->irq_data.chip->irq_ack();
-handle_irq_event(desc->action);
-if (desc->irq_data.chip->irq_eoi)
-        desc->irq_data.chip->irq_eoi();
-		</programlisting>
-		</para>
-   	    </sect3>
-	    <sect3 id="EOI_Edge_IRQ_flow_handler">
-	 	<title>EOI Edge IRQ flow handler</title>
-		<para>
-		handle_edge_eoi_irq provides an abnomination of the edge
-		handler which is solely used to tame a badly wreckaged
-		irq controller on powerpc/cell.
-		</para>
-   	    </sect3>
-	    <sect3 id="BAD_IRQ_flow_handler">
-	 	<title>Bad IRQ flow handler</title>
-		<para>
-		handle_bad_irq is used for spurious interrupts which
-		have no real handler assigned..
-		</para>
-   	    </sect3>
-	</sect2>
-	<sect2 id="Quirks_and_optimizations">
-	<title>Quirks and optimizations</title>
-	<para>
-	The generic functions are intended for 'clean' architectures and chips,
-	which have no platform-specific IRQ handling quirks. If an architecture
-	needs to implement quirks on the 'flow' level then it can do so by
-	overriding the high-level irq-flow handler.
-	</para>
-	</sect2>
-	<sect2 id="Delayed_interrupt_disable">
-	<title>Delayed interrupt disable</title>
-	<para>
-	This per interrupt selectable feature, which was introduced by Russell
-	King in the ARM interrupt implementation, does not mask an interrupt
-	at the hardware level when disable_irq() is called. The interrupt is
-	kept enabled and is masked in the flow handler when an interrupt event
-	happens. This prevents losing edge interrupts on hardware which does
-	not store an edge interrupt event while the interrupt is disabled at
-	the hardware level. When an interrupt arrives while the IRQ_DISABLED
-	flag is set, then the interrupt is masked at the hardware level and
-	the IRQ_PENDING bit is set. When the interrupt is re-enabled by
-	enable_irq() the pending bit is checked and if it is set, the
-	interrupt is resent either via hardware or by a software resend
-	mechanism. (It's necessary to enable CONFIG_HARDIRQS_SW_RESEND when
-	you want to use the delayed interrupt disable feature and your
-	hardware is not capable of retriggering	an interrupt.)
-	The delayed interrupt disable is not configurable.
-	</para>
-	</sect2>
-    </sect1>
-    <sect1 id="Chiplevel_hardware_encapsulation">
-	<title>Chip-level hardware encapsulation</title>
-	<para>
-	The chip-level hardware descriptor structure irq_chip
-	contains all the direct chip relevant functions, which
-	can be utilized by the irq flow implementations.
-	  <itemizedlist>
-	  <listitem><para>irq_ack()</para></listitem>
-	  <listitem><para>irq_mask_ack() - Optional, recommended for performance</para></listitem>
-	  <listitem><para>irq_mask()</para></listitem>
-	  <listitem><para>irq_unmask()</para></listitem>
-	  <listitem><para>irq_eoi() - Optional, required for EOI flow handlers</para></listitem>
-	  <listitem><para>irq_retrigger() - Optional</para></listitem>
-	  <listitem><para>irq_set_type() - Optional</para></listitem>
-	  <listitem><para>irq_set_wake() - Optional</para></listitem>
-	  </itemizedlist>
-	These primitives are strictly intended to mean what they say: ack means
-	ACK, masking means masking of an IRQ line, etc. It is up to the flow
-	handler(s) to use these basic units of low-level functionality.
-	</para>
-    </sect1>
-  </chapter>
-
-  <chapter id="doirq">
-     <title>__do_IRQ entry point</title>
-     <para>
-	The original implementation __do_IRQ() was an alternative entry
-	point for all types of interrupts. It no longer exists.
-     </para>
-     <para>
-	This handler turned out to be not suitable for all
-	interrupt hardware and was therefore reimplemented with split
-	functionality for edge/level/simple/percpu interrupts. This is not
-	only a functional optimization. It also shortens code paths for
-	interrupts.
-      </para>
-  </chapter>
-
-  <chapter id="locking">
-     <title>Locking on SMP</title>
-     <para>
-	The locking of chip registers is up to the architecture that
-	defines the chip primitives. The per-irq structure is
-	protected via desc->lock, by the generic layer.
-     </para>
-  </chapter>
-
-  <chapter id="genericchip">
-     <title>Generic interrupt chip</title>
-     <para>
-       To avoid copies of identical implementations of IRQ chips the
-       core provides a configurable generic interrupt chip
-       implementation. Developers should check carefully whether the
-       generic chip fits their needs before implementing the same
-       functionality slightly differently themselves.
-     </para>
-!Ekernel/irq/generic-chip.c
-  </chapter>
-
-  <chapter id="structs">
-     <title>Structures</title>
-     <para>
-     This chapter contains the autogenerated documentation of the structures which are
-     used in the generic IRQ layer.
-     </para>
-!Iinclude/linux/irq.h
-!Iinclude/linux/interrupt.h
-  </chapter>
-
-  <chapter id="pubfunctions">
-     <title>Public Functions Provided</title>
-     <para>
-     This chapter contains the autogenerated documentation of the kernel API functions
-      which are exported.
-     </para>
-!Ekernel/irq/manage.c
-!Ekernel/irq/chip.c
-  </chapter>
-
-  <chapter id="intfunctions">
-     <title>Internal Functions Provided</title>
-     <para>
-     This chapter contains the autogenerated documentation of the internal functions.
-     </para>
-!Ikernel/irq/irqdesc.c
-!Ikernel/irq/handle.c
-!Ikernel/irq/chip.c
-  </chapter>
-
-  <chapter id="credits">
-     <title>Credits</title>
-	<para>
-		The following people have contributed to this document:
-		<orderedlist>
-			<listitem><para>Thomas Gleixner<email>tglx@linutronix.de</email></para></listitem>
-			<listitem><para>Ingo Molnar<email>mingo@elte.hu</email></para></listitem>
-		</orderedlist>
-	</para>
-  </chapter>
-</book>
diff --git a/Documentation/core-api/genericirq.rst b/Documentation/core-api/genericirq.rst
new file mode 100644
index 000000000000..65d023b26864
--- /dev/null
+++ b/Documentation/core-api/genericirq.rst
@@ -0,0 +1,445 @@
+.. include:: <isonum.txt>
+
+==========================
+Linux generic IRQ handling
+==========================
+
+:Copyright: |copy| 2005-2010: Thomas Gleixner
+:Copyright: |copy| 2005-2006:  Ingo Molnar
+
+Introduction
+============
+
+The generic interrupt handling layer is designed to provide a complete
+abstraction of interrupt handling for device drivers. It is able to
+handle all the different types of interrupt controller hardware. Device
+drivers use generic API functions to request, enable, disable and free
+interrupts. The drivers do not have to know anything about interrupt
+hardware details, so they can be used on different platforms without
+code changes.
+
+This documentation is provided to developers who want to implement an
+interrupt subsystem based for their architecture, with the help of the
+generic IRQ handling layer.
+
+Rationale
+=========
+
+The original implementation of interrupt handling in Linux uses the
+__do_IRQ() super-handler, which is able to deal with every type of
+interrupt logic.
+
+Originally, Russell King identified different types of handlers to build
+a quite universal set for the ARM interrupt handler implementation in
+Linux 2.5/2.6. He distinguished between:
+
+-  Level type
+
+-  Edge type
+
+-  Simple type
+
+During the implementation we identified another type:
+
+-  Fast EOI type
+
+In the SMP world of the __do_IRQ() super-handler another type was
+identified:
+
+-  Per CPU type
+
+This split implementation of high-level IRQ handlers allows us to
+optimize the flow of the interrupt handling for each specific interrupt
+type. This reduces complexity in that particular code path and allows
+the optimized handling of a given type.
+
+The original general IRQ implementation used hw_interrupt_type
+structures and their ->ack(), ->end() [etc.] callbacks to differentiate
+the flow control in the super-handler. This leads to a mix of flow logic
+and low-level hardware logic, and it also leads to unnecessary code
+duplication: for example in i386, there is an ioapic_level_irq and an
+ioapic_edge_irq IRQ-type which share many of the low-level details but
+have different flow handling.
+
+A more natural abstraction is the clean separation of the 'irq flow' and
+the 'chip details'.
+
+Analysing a couple of architecture's IRQ subsystem implementations
+reveals that most of them can use a generic set of 'irq flow' methods
+and only need to add the chip-level specific code. The separation is
+also valuable for (sub)architectures which need specific quirks in the
+IRQ flow itself but not in the chip details - and thus provides a more
+transparent IRQ subsystem design.
+
+Each interrupt descriptor is assigned its own high-level flow handler,
+which is normally one of the generic implementations. (This high-level
+flow handler implementation also makes it simple to provide
+demultiplexing handlers which can be found in embedded platforms on
+various architectures.)
+
+The separation makes the generic interrupt handling layer more flexible
+and extensible. For example, an (sub)architecture can use a generic
+IRQ-flow implementation for 'level type' interrupts and add a
+(sub)architecture specific 'edge type' implementation.
+
+To make the transition to the new model easier and prevent the breakage
+of existing implementations, the __do_IRQ() super-handler is still
+available. This leads to a kind of duality for the time being. Over time
+the new model should be used in more and more architectures, as it
+enables smaller and cleaner IRQ subsystems. It's deprecated for three
+years now and about to be removed.
+
+Known Bugs And Assumptions
+==========================
+
+None (knock on wood).
+
+Abstraction layers
+==================
+
+There are three main levels of abstraction in the interrupt code:
+
+1. High-level driver API
+
+2. High-level IRQ flow handlers
+
+3. Chip-level hardware encapsulation
+
+Interrupt control flow
+----------------------
+
+Each interrupt is described by an interrupt descriptor structure
+irq_desc. The interrupt is referenced by an 'unsigned int' numeric
+value which selects the corresponding interrupt description structure in
+the descriptor structures array. The descriptor structure contains
+status information and pointers to the interrupt flow method and the
+interrupt chip structure which are assigned to this interrupt.
+
+Whenever an interrupt triggers, the low-level architecture code calls
+into the generic interrupt code by calling desc->handle_irq(). This
+high-level IRQ handling function only uses desc->irq_data.chip
+primitives referenced by the assigned chip descriptor structure.
+
+High-level Driver API
+---------------------
+
+The high-level Driver API consists of following functions:
+
+-  request_irq()
+
+-  free_irq()
+
+-  disable_irq()
+
+-  enable_irq()
+
+-  disable_irq_nosync() (SMP only)
+
+-  synchronize_irq() (SMP only)
+
+-  irq_set_irq_type()
+
+-  irq_set_irq_wake()
+
+-  irq_set_handler_data()
+
+-  irq_set_chip()
+
+-  irq_set_chip_data()
+
+See the autogenerated function documentation for details.
+
+High-level IRQ flow handlers
+----------------------------
+
+The generic layer provides a set of pre-defined irq-flow methods:
+
+-  handle_level_irq
+
+-  handle_edge_irq
+
+-  handle_fasteoi_irq
+
+-  handle_simple_irq
+
+-  handle_percpu_irq
+
+-  handle_edge_eoi_irq
+
+-  handle_bad_irq
+
+The interrupt flow handlers (either pre-defined or architecture
+specific) are assigned to specific interrupts by the architecture either
+during bootup or during device initialization.
+
+Default flow implementations
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Helper functions
+^^^^^^^^^^^^^^^^
+
+The helper functions call the chip primitives and are used by the
+default flow implementations. The following helper functions are
+implemented (simplified excerpt)::
+
+    default_enable(struct irq_data *data)
+    {
+        desc->irq_data.chip->irq_unmask(data);
+    }
+
+    default_disable(struct irq_data *data)
+    {
+        if (!delay_disable(data))
+            desc->irq_data.chip->irq_mask(data);
+    }
+
+    default_ack(struct irq_data *data)
+    {
+        chip->irq_ack(data);
+    }
+
+    default_mask_ack(struct irq_data *data)
+    {
+        if (chip->irq_mask_ack) {
+            chip->irq_mask_ack(data);
+        } else {
+            chip->irq_mask(data);
+            chip->irq_ack(data);
+        }
+    }
+
+    noop(struct irq_data *data))
+    {
+    }
+
+
+
+Default flow handler implementations
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Default Level IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_level_irq provides a generic implementation for level-triggered
+interrupts.
+
+The following control flow is implemented (simplified excerpt)::
+
+    desc->irq_data.chip->irq_mask_ack();
+    handle_irq_event(desc->action);
+    desc->irq_data.chip->irq_unmask();
+
+
+Default Fast EOI IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_fasteoi_irq provides a generic implementation for interrupts,
+which only need an EOI at the end of the handler.
+
+The following control flow is implemented (simplified excerpt)::
+
+    handle_irq_event(desc->action);
+    desc->irq_data.chip->irq_eoi();
+
+
+Default Edge IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_edge_irq provides a generic implementation for edge-triggered
+interrupts.
+
+The following control flow is implemented (simplified excerpt)::
+
+    if (desc->status & running) {
+        desc->irq_data.chip->irq_mask_ack();
+        desc->status |= pending | masked;
+        return;
+    }
+    desc->irq_data.chip->irq_ack();
+    desc->status |= running;
+    do {
+        if (desc->status & masked)
+            desc->irq_data.chip->irq_unmask();
+        desc->status &= ~pending;
+        handle_irq_event(desc->action);
+    } while (status & pending);
+    desc->status &= ~running;
+
+
+Default simple IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_simple_irq provides a generic implementation for simple
+interrupts.
+
+.. note::
+
+   The simple flow handler does not call any handler/chip primitives.
+
+The following control flow is implemented (simplified excerpt)::
+
+    handle_irq_event(desc->action);
+
+
+Default per CPU flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_percpu_irq provides a generic implementation for per CPU
+interrupts.
+
+Per CPU interrupts are only available on SMP and the handler provides a
+simplified version without locking.
+
+The following control flow is implemented (simplified excerpt)::
+
+    if (desc->irq_data.chip->irq_ack)
+        desc->irq_data.chip->irq_ack();
+    handle_irq_event(desc->action);
+    if (desc->irq_data.chip->irq_eoi)
+            desc->irq_data.chip->irq_eoi();
+
+
+EOI Edge IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^^^^^^
+
+handle_edge_eoi_irq provides an abnomination of the edge handler
+which is solely used to tame a badly wreckaged irq controller on
+powerpc/cell.
+
+Bad IRQ flow handler
+^^^^^^^^^^^^^^^^^^^^
+
+handle_bad_irq is used for spurious interrupts which have no real
+handler assigned..
+
+Quirks and optimizations
+~~~~~~~~~~~~~~~~~~~~~~~~
+
+The generic functions are intended for 'clean' architectures and chips,
+which have no platform-specific IRQ handling quirks. If an architecture
+needs to implement quirks on the 'flow' level then it can do so by
+overriding the high-level irq-flow handler.
+
+Delayed interrupt disable
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+This per interrupt selectable feature, which was introduced by Russell
+King in the ARM interrupt implementation, does not mask an interrupt at
+the hardware level when disable_irq() is called. The interrupt is kept
+enabled and is masked in the flow handler when an interrupt event
+happens. This prevents losing edge interrupts on hardware which does not
+store an edge interrupt event while the interrupt is disabled at the
+hardware level. When an interrupt arrives while the IRQ_DISABLED flag
+is set, then the interrupt is masked at the hardware level and the
+IRQ_PENDING bit is set. When the interrupt is re-enabled by
+enable_irq() the pending bit is checked and if it is set, the interrupt
+is resent either via hardware or by a software resend mechanism. (It's
+necessary to enable CONFIG_HARDIRQS_SW_RESEND when you want to use
+the delayed interrupt disable feature and your hardware is not capable
+of retriggering an interrupt.) The delayed interrupt disable is not
+configurable.
+
+Chip-level hardware encapsulation
+---------------------------------
+
+The chip-level hardware descriptor structure irq_chip contains all the
+direct chip relevant functions, which can be utilized by the irq flow
+implementations.
+
+-  irq_ack()
+
+-  irq_mask_ack() - Optional, recommended for performance
+
+-  irq_mask()
+
+-  irq_unmask()
+
+-  irq_eoi() - Optional, required for EOI flow handlers
+
+-  irq_retrigger() - Optional
+
+-  irq_set_type() - Optional
+
+-  irq_set_wake() - Optional
+
+These primitives are strictly intended to mean what they say: ack means
+ACK, masking means masking of an IRQ line, etc. It is up to the flow
+handler(s) to use these basic units of low-level functionality.
+
+__do_IRQ entry point
+====================
+
+The original implementation __do_IRQ() was an alternative entry point
+for all types of interrupts. It no longer exists.
+
+This handler turned out to be not suitable for all interrupt hardware
+and was therefore reimplemented with split functionality for
+edge/level/simple/percpu interrupts. This is not only a functional
+optimization. It also shortens code paths for interrupts.
+
+Locking on SMP
+==============
+
+The locking of chip registers is up to the architecture that defines the
+chip primitives. The per-irq structure is protected via desc->lock, by
+the generic layer.
+
+Generic interrupt chip
+======================
+
+To avoid copies of identical implementations of IRQ chips the core
+provides a configurable generic interrupt chip implementation.
+Developers should check carefully whether the generic chip fits their
+needs before implementing the same functionality slightly differently
+themselves.
+
+.. kernel-doc:: kernel/irq/generic-chip.c
+   :export:
+
+Structures
+==========
+
+This chapter contains the autogenerated documentation of the structures
+which are used in the generic IRQ layer.
+
+.. kernel-doc:: include/linux/irq.h
+   :internal:
+
+.. kernel-doc:: include/linux/interrupt.h
+   :internal:
+
+Public Functions Provided
+=========================
+
+This chapter contains the autogenerated documentation of the kernel API
+functions which are exported.
+
+.. kernel-doc:: kernel/irq/manage.c
+   :export:
+
+.. kernel-doc:: kernel/irq/chip.c
+   :export:
+
+Internal Functions Provided
+===========================
+
+This chapter contains the autogenerated documentation of the internal
+functions.
+
+.. kernel-doc:: kernel/irq/irqdesc.c
+   :internal:
+
+.. kernel-doc:: kernel/irq/handle.c
+   :internal:
+
+.. kernel-doc:: kernel/irq/chip.c
+   :internal:
+
+Credits
+=======
+
+The following people have contributed to this document:
+
+1. Thomas Gleixner tglx@linutronix.de
+
+2. Ingo Molnar mingo@elte.hu
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 0d93d8089136..c058febbd991 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -16,6 +16,7 @@ Core utilities
    cpu_hotplug
    local_ops
    workqueue
+   genericirq
 
 Interfaces for kernel debugging
 ===============================
-- 
2.9.3
