Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54397 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934033AbdC3ULp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 16:11:45 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4/9] genericirq.rst: add cross-reference links and use monospaced fonts
Date: Thu, 30 Mar 2017 17:11:31 -0300
Message-Id: <0c4b5d008e1665f4398e6fd60ada2458004c2632.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1490904090.git.mchehab@s-opensource.com>
References: <cover.1490904090.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The document describes several functions that are documented
there via kernel doc macros. Add cross-references to them.

In order to be consistend with other documents, use monospaced
fonts for fields.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/core-api/genericirq.rst | 97 +++++++++++++++++------------------
 1 file changed, 46 insertions(+), 51 deletions(-)

diff --git a/Documentation/core-api/genericirq.rst b/Documentation/core-api/genericirq.rst
index 65d023b26864..0054bd48be84 100644
--- a/Documentation/core-api/genericirq.rst
+++ b/Documentation/core-api/genericirq.rst
@@ -26,7 +26,7 @@ Rationale
 =========
 
 The original implementation of interrupt handling in Linux uses the
-__do_IRQ() super-handler, which is able to deal with every type of
+:c:func:`__do_IRQ` super-handler, which is able to deal with every type of
 interrupt logic.
 
 Originally, Russell King identified different types of handlers to build
@@ -43,7 +43,7 @@ During the implementation we identified another type:
 
 -  Fast EOI type
 
-In the SMP world of the __do_IRQ() super-handler another type was
+In the SMP world of the :c:func:`__do_IRQ` super-handler another type was
 identified:
 
 -  Per CPU type
@@ -54,11 +54,11 @@ type. This reduces complexity in that particular code path and allows
 the optimized handling of a given type.
 
 The original general IRQ implementation used hw_interrupt_type
-structures and their ->ack(), ->end() [etc.] callbacks to differentiate
+structures and their ``->ack``, ``->end`` [etc.] callbacks to differentiate
 the flow control in the super-handler. This leads to a mix of flow logic
 and low-level hardware logic, and it also leads to unnecessary code
-duplication: for example in i386, there is an ioapic_level_irq and an
-ioapic_edge_irq IRQ-type which share many of the low-level details but
+duplication: for example in i386, there is an ``ioapic_level_irq`` and an
+``ioapic_edge_irq`` IRQ-type which share many of the low-level details but
 have different flow handling.
 
 A more natural abstraction is the clean separation of the 'irq flow' and
@@ -83,7 +83,7 @@ IRQ-flow implementation for 'level type' interrupts and add a
 (sub)architecture specific 'edge type' implementation.
 
 To make the transition to the new model easier and prevent the breakage
-of existing implementations, the __do_IRQ() super-handler is still
+of existing implementations, the :c:func:`__do_IRQ` super-handler is still
 available. This leads to a kind of duality for the time being. Over time
 the new model should be used in more and more architectures, as it
 enables smaller and cleaner IRQ subsystems. It's deprecated for three
@@ -116,7 +116,7 @@ status information and pointers to the interrupt flow method and the
 interrupt chip structure which are assigned to this interrupt.
 
 Whenever an interrupt triggers, the low-level architecture code calls
-into the generic interrupt code by calling desc->handle_irq(). This
+into the generic interrupt code by calling :c:func:`desc->handle_irq`. This
 high-level IRQ handling function only uses desc->irq_data.chip
 primitives referenced by the assigned chip descriptor structure.
 
@@ -125,27 +125,27 @@ High-level Driver API
 
 The high-level Driver API consists of following functions:
 
--  request_irq()
+-  :c:func:`request_irq`
 
--  free_irq()
+-  :c:func:`free_irq`
 
--  disable_irq()
+-  :c:func:`disable_irq`
 
--  enable_irq()
+-  :c:func:`enable_irq`
 
--  disable_irq_nosync() (SMP only)
+-  :c:func:`disable_irq_nosync` (SMP only)
 
--  synchronize_irq() (SMP only)
+-  :c:func:`synchronize_irq` (SMP only)
 
--  irq_set_irq_type()
+-  :c:func:`irq_set_irq_type`
 
--  irq_set_irq_wake()
+-  :c:func:`irq_set_irq_wake`
 
--  irq_set_handler_data()
+-  :c:func:`irq_set_handler_data`
 
--  irq_set_chip()
+-  :c:func:`irq_set_chip`
 
--  irq_set_chip_data()
+-  :c:func:`irq_set_chip_data`
 
 See the autogenerated function documentation for details.
 
@@ -154,19 +154,19 @@ High-level IRQ flow handlers
 
 The generic layer provides a set of pre-defined irq-flow methods:
 
--  handle_level_irq
+-  :c:func:`handle_level_irq`
 
--  handle_edge_irq
+-  :c:func:`handle_edge_irq`
 
--  handle_fasteoi_irq
+-  :c:func:`handle_fasteoi_irq`
 
--  handle_simple_irq
+-  :c:func:`handle_simple_irq`
 
--  handle_percpu_irq
+-  :c:func:`handle_percpu_irq`
 
--  handle_edge_eoi_irq
+-  :c:func:`handle_edge_eoi_irq`
 
--  handle_bad_irq
+-  :c:func:`handle_bad_irq`
 
 The interrupt flow handlers (either pre-defined or architecture
 specific) are assigned to specific interrupts by the architecture either
@@ -225,9 +225,9 @@ interrupts.
 
 The following control flow is implemented (simplified excerpt)::
 
-    desc->irq_data.chip->irq_mask_ack();
+    :c:func:`desc->irq_data.chip->irq_mask_ack`;
     handle_irq_event(desc->action);
-    desc->irq_data.chip->irq_unmask();
+    :c:func:`desc->irq_data.chip->irq_unmask`;
 
 
 Default Fast EOI IRQ flow handler
@@ -239,7 +239,7 @@ which only need an EOI at the end of the handler.
 The following control flow is implemented (simplified excerpt)::
 
     handle_irq_event(desc->action);
-    desc->irq_data.chip->irq_eoi();
+    :c:func:`desc->irq_data.chip->irq_eoi`;
 
 
 Default Edge IRQ flow handler
@@ -251,15 +251,15 @@ interrupts.
 The following control flow is implemented (simplified excerpt)::
 
     if (desc->status & running) {
-        desc->irq_data.chip->irq_mask_ack();
+        :c:func:`desc->irq_data.chip->irq_mask_ack`;
         desc->status |= pending | masked;
         return;
     }
-    desc->irq_data.chip->irq_ack();
+    :c:func:`desc->irq_data.chip->irq_ack`;
     desc->status |= running;
     do {
         if (desc->status & masked)
-            desc->irq_data.chip->irq_unmask();
+            :c:func:`desc->irq_data.chip->irq_unmask`;
         desc->status &= ~pending;
         handle_irq_event(desc->action);
     } while (status & pending);
@@ -293,10 +293,10 @@ simplified version without locking.
 The following control flow is implemented (simplified excerpt)::
 
     if (desc->irq_data.chip->irq_ack)
-        desc->irq_data.chip->irq_ack();
+        :c:func:`desc->irq_data.chip->irq_ack`;
     handle_irq_event(desc->action);
     if (desc->irq_data.chip->irq_eoi)
-            desc->irq_data.chip->irq_eoi();
+            :c:func:`desc->irq_data.chip->irq_eoi`;
 
 
 EOI Edge IRQ flow handler
@@ -325,14 +325,14 @@ Delayed interrupt disable
 
 This per interrupt selectable feature, which was introduced by Russell
 King in the ARM interrupt implementation, does not mask an interrupt at
-the hardware level when disable_irq() is called. The interrupt is kept
+the hardware level when :c:func:`disable_irq` is called. The interrupt is kept
 enabled and is masked in the flow handler when an interrupt event
 happens. This prevents losing edge interrupts on hardware which does not
 store an edge interrupt event while the interrupt is disabled at the
 hardware level. When an interrupt arrives while the IRQ_DISABLED flag
 is set, then the interrupt is masked at the hardware level and the
 IRQ_PENDING bit is set. When the interrupt is re-enabled by
-enable_irq() the pending bit is checked and if it is set, the interrupt
+:c:func:`enable_irq` the pending bit is checked and if it is set, the interrupt
 is resent either via hardware or by a software resend mechanism. (It's
 necessary to enable CONFIG_HARDIRQS_SW_RESEND when you want to use
 the delayed interrupt disable feature and your hardware is not capable
@@ -342,25 +342,25 @@ configurable.
 Chip-level hardware encapsulation
 ---------------------------------
 
-The chip-level hardware descriptor structure irq_chip contains all the
-direct chip relevant functions, which can be utilized by the irq flow
+The chip-level hardware descriptor structure :c:type:`irq_chip` contains all
+the direct chip relevant functions, which can be utilized by the irq flow
 implementations.
 
--  irq_ack()
+-  ``irq_ack``
 
--  irq_mask_ack() - Optional, recommended for performance
+-  ``irq_mask_ack`` - Optional, recommended for performance
 
--  irq_mask()
+-  ``irq_mask``
 
--  irq_unmask()
+-  ``irq_unmask``
 
--  irq_eoi() - Optional, required for EOI flow handlers
+-  ``irq_eoi`` - Optional, required for EOI flow handlers
 
--  irq_retrigger() - Optional
+-  ``irq_retrigger`` - Optional
 
--  irq_set_type() - Optional
+-  ``irq_set_type`` - Optional
 
--  irq_set_wake() - Optional
+-  ``irq_set_wake`` - Optional
 
 These primitives are strictly intended to mean what they say: ack means
 ACK, masking means masking of an IRQ line, etc. It is up to the flow
@@ -369,7 +369,7 @@ handler(s) to use these basic units of low-level functionality.
 __do_IRQ entry point
 ====================
 
-The original implementation __do_IRQ() was an alternative entry point
+The original implementation :c:func:`__do_IRQ` was an alternative entry point
 for all types of interrupts. It no longer exists.
 
 This handler turned out to be not suitable for all interrupt hardware
@@ -415,10 +415,8 @@ This chapter contains the autogenerated documentation of the kernel API
 functions which are exported.
 
 .. kernel-doc:: kernel/irq/manage.c
-   :export:
 
 .. kernel-doc:: kernel/irq/chip.c
-   :export:
 
 Internal Functions Provided
 ===========================
@@ -427,13 +425,10 @@ This chapter contains the autogenerated documentation of the internal
 functions.
 
 .. kernel-doc:: kernel/irq/irqdesc.c
-   :internal:
 
 .. kernel-doc:: kernel/irq/handle.c
-   :internal:
 
 .. kernel-doc:: kernel/irq/chip.c
-   :internal:
 
 Credits
 =======
-- 
2.9.3
