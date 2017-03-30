Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:54363 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933258AbdC3KqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH v2 12/22] usb/dma.txt: convert to ReST and add to driver-api book
Date: Thu, 30 Mar 2017 07:45:46 -0300
Message-Id: <417b24398fee257fd145f79283edf6575aacd1cf.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core features. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../{usb/dma.txt => driver-api/usb/dma.rst}        | 51 ++++++++++++----------
 Documentation/driver-api/usb/index.rst             |  1 +
 2 files changed, 28 insertions(+), 24 deletions(-)
 rename Documentation/{usb/dma.txt => driver-api/usb/dma.rst} (79%)

diff --git a/Documentation/usb/dma.txt b/Documentation/driver-api/usb/dma.rst
similarity index 79%
rename from Documentation/usb/dma.txt
rename to Documentation/driver-api/usb/dma.rst
index 444651e70d95..59d5aee89e37 100644
--- a/Documentation/usb/dma.txt
+++ b/Documentation/driver-api/usb/dma.rst
@@ -1,16 +1,19 @@
+USB DMA
+~~~~~~~
+
 In Linux 2.5 kernels (and later), USB device drivers have additional control
 over how DMA may be used to perform I/O operations.  The APIs are detailed
 in the kernel usb programming guide (kerneldoc, from the source code).
 
-
-API OVERVIEW
+API overview
+============
 
 The big picture is that USB drivers can continue to ignore most DMA issues,
 though they still must provide DMA-ready buffers (see
-Documentation/DMA-API-HOWTO.txt).  That's how they've worked through
-the 2.4 (and earlier) kernels.
+``Documentation/DMA-API-HOWTO.txt``).  That's how they've worked through
+the 2.4 (and earlier) kernels, or they can now be DMA-aware.
 
-OR:  they can now be DMA-aware.
+DMA-aware usb drivers:
 
 - New calls enable DMA-aware drivers, letting them allocate dma buffers and
   manage dma mappings for existing dma-ready buffers (see below).
@@ -20,15 +23,15 @@ OR:  they can now be DMA-aware.
   drivers must not use it.)
 
 - "usbcore" will map this DMA address, if a DMA-aware driver didn't do
-  it first and set URB_NO_TRANSFER_DMA_MAP.  HCDs
+  it first and set ``URB_NO_TRANSFER_DMA_MAP``.  HCDs
   don't manage dma mappings for URBs.
 
 - There's a new "generic DMA API", parts of which are usable by USB device
   drivers.  Never use dma_set_mask() on any USB interface or device; that
   would potentially break all devices sharing that bus.
 
-
-ELIMINATING COPIES
+Eliminating copies
+==================
 
 It's good to avoid making CPUs copy data needlessly.  The costs can add up,
 and effects like cache-trashing can impose subtle penalties.
@@ -41,7 +44,7 @@ and effects like cache-trashing can impose subtle penalties.
   For those specific cases, USB has primitives to allocate less expensive
   memory.  They work like kmalloc and kfree versions that give you the right
   kind of addresses to store in urb->transfer_buffer and urb->transfer_dma.
-  You'd also set URB_NO_TRANSFER_DMA_MAP in urb->transfer_flags:
+  You'd also set ``URB_NO_TRANSFER_DMA_MAP`` in urb->transfer_flags::
 
 	void *usb_alloc_coherent (struct usb_device *dev, size_t size,
 		int mem_flags, dma_addr_t *dma);
@@ -49,15 +52,15 @@ and effects like cache-trashing can impose subtle penalties.
 	void usb_free_coherent (struct usb_device *dev, size_t size,
 		void *addr, dma_addr_t dma);
 
-  Most drivers should *NOT* be using these primitives; they don't need
+  Most drivers should **NOT** be using these primitives; they don't need
   to use this type of memory ("dma-coherent"), and memory returned from
-  kmalloc() will work just fine.
+  :c:func:`kmalloc` will work just fine.
 
   The memory buffer returned is "dma-coherent"; sometimes you might need to
   force a consistent memory access ordering by using memory barriers.  It's
   not using a streaming DMA mapping, so it's good for small transfers on
   systems where the I/O would otherwise thrash an IOMMU mapping.  (See
-  Documentation/DMA-API-HOWTO.txt for definitions of "coherent" and
+  ``Documentation/DMA-API-HOWTO.txt`` for definitions of "coherent" and
   "streaming" DMA mappings.)
 
   Asking for 1/Nth of a page (as well as asking for N pages) is reasonably
@@ -75,15 +78,15 @@ and effects like cache-trashing can impose subtle penalties.
   way to expose these capabilities ... and in any case, HIGHMEM is mostly a
   design wart specific to x86_32.  So your best bet is to ensure you never
   pass a highmem buffer into a USB driver.  That's easy; it's the default
-  behavior.  Just don't override it; e.g. with NETIF_F_HIGHDMA.
+  behavior.  Just don't override it; e.g. with ``NETIF_F_HIGHDMA``.
 
   This may force your callers to do some bounce buffering, copying from
   high memory to "normal" DMA memory.  If you can come up with a good way
   to fix this issue (for x86_32 machines with over 1 GByte of memory),
   feel free to submit patches.
 
-
-WORKING WITH EXISTING BUFFERS
+Working with existing buffers
+=============================
 
 Existing buffers aren't usable for DMA without first being mapped into the
 DMA address space of the device.  However, most buffers passed to your
@@ -92,7 +95,7 @@ of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
 
 - When you're using scatterlists, you can map everything at once.  On some
   systems, this kicks in an IOMMU and turns the scatterlists into single
-  DMA transactions:
+  DMA transactions::
 
 	int usb_buffer_map_sg (struct usb_device *dev, unsigned pipe,
 		struct scatterlist *sg, int nents);
@@ -103,7 +106,7 @@ of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
 	void usb_buffer_unmap_sg (struct usb_device *dev, unsigned pipe,
 		struct scatterlist *sg, int n_hw_ents);
 
-  It's probably easier to use the new usb_sg_*() calls, which do the DMA
+  It's probably easier to use the new ``usb_sg_*()`` calls, which do the DMA
   mapping and apply other tweaks to make scatterlist i/o be fast.
 
 - Some drivers may prefer to work with the model that they're mapping large
@@ -112,10 +115,10 @@ of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
   here, since it's cheaper to just synchronize the buffer than to unmap it
   each time an urb completes and then re-map it on during resubmission.
 
-  These calls all work with initialized urbs:  urb->dev, urb->pipe,
-  urb->transfer_buffer, and urb->transfer_buffer_length must all be
-  valid when these calls are used (urb->setup_packet must be valid too
-  if urb is a control request):
+  These calls all work with initialized urbs:  ``urb->dev``, ``urb->pipe``,
+  ``urb->transfer_buffer``, and ``urb->transfer_buffer_length`` must all be
+  valid when these calls are used (``urb->setup_packet`` must be valid too
+  if urb is a control request)::
 
 	struct urb *usb_buffer_map (struct urb *urb);
 
@@ -123,9 +126,9 @@ of Documentation/DMA-API-HOWTO.txt, titled "What memory is DMA-able?")
 
 	void usb_buffer_unmap (struct urb *urb);
 
-  The calls manage urb->transfer_dma for you, and set URB_NO_TRANSFER_DMA_MAP
-  so that usbcore won't map or unmap the buffer.  They cannot be used for
-  setup_packet buffers in control requests.
+  The calls manage ``urb->transfer_dma`` for you, and set
+  ``URB_NO_TRANSFER_DMA_MAP`` so that usbcore won't map or unmap the buffer.
+  They cannot be used for setup_packet buffers in control requests.
 
 Note that several of those interfaces are currently commented out, since
 they don't have current users.  See the source code.  Other than the dmasync
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 23c76c17fc19..d7610777784b 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -9,6 +9,7 @@ Linux USB API
    anchors
    bulk-streams
    callbacks
+   dma
    power-management
    writing_usb_driver
    writing_musb_glue_layer
-- 
2.9.3
