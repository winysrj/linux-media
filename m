Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57495 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753467AbdC2Syd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:33 -0400
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
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 15/22] usb/URB.txt: convert to ReST and update it
Date: Wed, 29 Mar 2017 15:54:14 -0300
Message-Id: <fff49db3150ccb48ec909f5ed087de994d523d35.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The URB doc describes the Kernel mechanism that do USB transfers.
While the functions are already described at urb.h, there are a
number of concepts and theory that are important for USB driver
developers.

Convert it to ReST and use C ref links to point to the places
at usb.h where each function and struct is located.

A few of those descriptions were incomplete. While here, update
to reflect the current API status.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../{usb/URB.txt => driver-api/usb/URB.rst}        | 204 ++++++++++++---------
 Documentation/driver-api/usb/index.rst             |   1 +
 Documentation/driver-api/usb/usb.rst               |   2 +
 3 files changed, 120 insertions(+), 87 deletions(-)
 rename Documentation/{usb/URB.txt => driver-api/usb/URB.rst} (52%)

diff --git a/Documentation/usb/URB.txt b/Documentation/driver-api/usb/URB.rst
similarity index 52%
rename from Documentation/usb/URB.txt
rename to Documentation/driver-api/usb/URB.rst
index 50da0d455444..c5d2b68b4dae 100644
--- a/Documentation/usb/URB.txt
+++ b/Documentation/driver-api/usb/URB.rst
@@ -1,16 +1,25 @@
-Revised: 2000-Dec-05.
+USB Request Block (URB)
+~~~~~~~~~~~~~~~~~~~~~~~
+
+Revised: 2000-Dec-05
+
 Again:   2002-Jul-06
+
 Again:   2005-Sep-19
 
-    NOTE:
+Again:   2017-Mar-29
 
-    The USB subsystem now has a substantial section in "The Linux Kernel API"
-    guide (in Documentation/DocBook), generated from the current source
-    code.  This particular documentation file isn't particularly current or
-    complete; don't rely on it except for a quick overview.
 
+.. note::
 
-1.1. Basic concept or 'What is an URB?'
+    The USB subsystem now has a substantial section at :ref:`usb-hostside-api`
+    section, generated from the current source code.
+    This particular documentation file isn't complete and may not be
+    updated to the last version; don't rely on it except for a quick
+    overview.
+
+Basic concept or 'What is an URB?'
+==================================
 
 The basic idea of the new driver is message passing, the message itself is 
 called USB Request Block, or URB for short. 
@@ -19,10 +28,11 @@ called USB Request Block, or URB for short.
   and deliver the data and status back. 
 
 - Execution of an URB is inherently an asynchronous operation, i.e. the 
-  usb_submit_urb(urb) call returns immediately after it has successfully
+  :c:func:`usb_submit_urb` call returns immediately after it has successfully
   queued the requested action.
 
-- Transfers for one URB can be canceled with usb_unlink_urb(urb) at any time. 
+- Transfers for one URB can be canceled with :c:func:`usb_unlink_urb`
+  at any time.
 
 - Each URB has a completion handler, which is called after the action
   has been successfully completed or canceled. The URB also contains a
@@ -35,53 +45,55 @@ called USB Request Block, or URB for short.
   of data to (or from) devices when using periodic transfer modes.
 
 
-1.2. The URB structure
+The URB structure
+=================
 
-Some of the fields in an URB are:
+Some of the fields in struct :c:type:`urb` are::
 
-struct urb
-{
-// (IN) device and pipe specify the endpoint queue
+  struct urb
+  {
+  // (IN) device and pipe specify the endpoint queue
 	struct usb_device *dev;         // pointer to associated USB device
 	unsigned int pipe;              // endpoint information
 
-	unsigned int transfer_flags;    // ISO_ASAP, SHORT_NOT_OK, etc.
+	unsigned int transfer_flags;    // URB_ISO_ASAP, URB_SHORT_NOT_OK, etc.
 
-// (IN) all urbs need completion routines
+  // (IN) all urbs need completion routines
 	void *context;                  // context for completion routine
-	void (*complete)(struct urb *); // pointer to completion routine
+	usb_complete_t complete;        // pointer to completion routine
 
-// (OUT) status after each completion
+  // (OUT) status after each completion
 	int status;                     // returned status
 
-// (IN) buffer used for data transfers
+  // (IN) buffer used for data transfers
 	void *transfer_buffer;          // associated data buffer
-	int transfer_buffer_length;     // data buffer length
+	u32 transfer_buffer_length;     // data buffer length
 	int number_of_packets;          // size of iso_frame_desc
 
-// (OUT) sometimes only part of CTRL/BULK/INTR transfer_buffer is used
-	int actual_length;              // actual data buffer length
+  // (OUT) sometimes only part of CTRL/BULK/INTR transfer_buffer is used
+	u32 actual_length;              // actual data buffer length
 
-// (IN) setup stage for CTRL (pass a struct usb_ctrlrequest)
-	unsigned char* setup_packet;    // setup packet (control only)
+  // (IN) setup stage for CTRL (pass a struct usb_ctrlrequest)
+	unsigned char *setup_packet;    // setup packet (control only)
 
-// Only for PERIODIC transfers (ISO, INTERRUPT)
-    // (IN/OUT) start_frame is set unless ISO_ASAP isn't set
+  // Only for PERIODIC transfers (ISO, INTERRUPT)
+    // (IN/OUT) start_frame is set unless URB_ISO_ASAP isn't set
 	int start_frame;                // start frame
 	int interval;                   // polling interval
 
     // ISO only: packets are only "best effort"; each can have errors
 	int error_count;                // number of errors
 	struct usb_iso_packet_descriptor iso_frame_desc[0];
-};
+  };
 
 Your driver must create the "pipe" value using values from the appropriate
 endpoint descriptor in an interface that it's claimed.
 
 
-1.3. How to get an URB?
+How to get an URB?
+==================
 
-URBs are allocated with the following call
+URBs are allocated by calling :c:func:`usb_alloc_urb`::
 
 	struct urb *usb_alloc_urb(int isoframes, int mem_flags)
 
@@ -91,7 +103,7 @@ you want to schedule. For CTRL/BULK/INT, use 0.  The mem_flags parameter
 holds standard memory allocation flags, letting you control (among other
 things) whether the underlying code may block or not.
 
-To free an URB, use
+To free an URB, use :c:func:`usb_free_urb`::
 
 	void usb_free_urb(struct urb *urb)
 
@@ -100,78 +112,84 @@ returned to you in a completion callback.  It will automatically be
 deallocated when it is no longer in use.
 
 
-1.4. What has to be filled in?
+What has to be filled in?
+=========================
 
 Depending on the type of transaction, there are some inline functions 
-defined in <linux/usb.h> to simplify the initialization, such as
-fill_control_urb() and fill_bulk_urb().  In general, they need the usb
-device pointer, the pipe (usual format from usb.h), the transfer buffer,
-the desired transfer length, the completion  handler, and its context. 
-Take a look at the some existing drivers to see how they're used.
+defined in ``linux/usb.h`` to simplify the initialization, such as
+:c:func:`usb_fill_control_urb`, :c:func:`usb_fill_bulk_urb` and
+:c:func:`usb_fill_int_urb`.  In general, they need the usb device pointer,
+the pipe (usual format from usb.h), the transfer buffer, the desired transfer
+length, the completion handler, and its context. Take a look at the some
+existing drivers to see how they're used.
 
 Flags:
-For ISO there are two startup behaviors: Specified start_frame or ASAP.
-For ASAP set URB_ISO_ASAP in transfer_flags.
 
-If short packets should NOT be tolerated, set URB_SHORT_NOT_OK in 
+- For ISO there are two startup behaviors: Specified start_frame or ASAP.
+- For ASAP set ``URB_ISO_ASAP`` in transfer_flags.
+
+If short packets should NOT be tolerated, set ``URB_SHORT_NOT_OK`` in
 transfer_flags.
 
 
-1.5. How to submit an URB?
+How to submit an URB?
+=====================
 
-Just call
+Just call :c:func:`usb_submit_urb`::
 
 	int usb_submit_urb(struct urb *urb, int mem_flags)
 
-The mem_flags parameter, such as SLAB_ATOMIC, controls memory allocation,
-such as whether the lower levels may block when memory is tight.
+The ``mem_flags`` parameter, such as ``GFP_ATOMIC``, controls memory
+allocation, such as whether the lower levels may block when memory is tight.
 
 It immediately returns, either with status 0 (request queued) or some
 error code, usually caused by the following:
 
-- Out of memory (-ENOMEM)
-- Unplugged device (-ENODEV)
-- Stalled endpoint (-EPIPE)
-- Too many queued ISO transfers (-EAGAIN)
-- Too many requested ISO frames (-EFBIG)
-- Invalid INT interval (-EINVAL)
-- More than one packet for INT (-EINVAL)
+- Out of memory (``-ENOMEM``)
+- Unplugged device (``-ENODEV``)
+- Stalled endpoint (``-EPIPE``)
+- Too many queued ISO transfers (``-EAGAIN``)
+- Too many requested ISO frames (``-EFBIG``)
+- Invalid INT interval (``-EINVAL``)
+- More than one packet for INT (``-EINVAL``)
 
-After submission, urb->status is -EINPROGRESS; however, you should never
-look at that value except in your completion callback.
+After submission, ``urb->status`` is ``-EINPROGRESS``; however, you should
+never look at that value except in your completion callback.
 
 For isochronous endpoints, your completion handlers should (re)submit
-URBs to the same endpoint with the ISO_ASAP flag, using multi-buffering,
-to get seamless ISO streaming.
+URBs to the same endpoint with the ``URB_ISO_ASAP`` flag, using
+multi-buffering, to get seamless ISO streaming.
 
 
-1.6. How to cancel an already running URB?
+How to cancel an already running URB?
+=====================================
 
 There are two ways to cancel an URB you've submitted but which hasn't
 been returned to your driver yet.  For an asynchronous cancel, call
+:c:func:`usb_unlink_urb`::
 
 	int usb_unlink_urb(struct urb *urb)
 
 It removes the urb from the internal list and frees all allocated
 HW descriptors. The status is changed to reflect unlinking.  Note
-that the URB will not normally have finished when usb_unlink_urb()
+that the URB will not normally have finished when :c:func:`usb_unlink_urb`
 returns; you must still wait for the completion handler to be called.
 
-To cancel an URB synchronously, call
+To cancel an URB synchronously, call :c:func:`usb_kill_urb`::
 
 	void usb_kill_urb(struct urb *urb)
 
-It does everything usb_unlink_urb does, and in addition it waits
+It does everything :c:func:`usb_unlink_urb` does, and in addition it waits
 until after the URB has been returned and the completion handler
 has finished.  It also marks the URB as temporarily unusable, so
 that if the completion handler or anyone else tries to resubmit it
-they will get a -EPERM error.  Thus you can be sure that when
-usb_kill_urb() returns, the URB is totally idle.
+they will get a ``-EPERM`` error.  Thus you can be sure that when
+:c:func:`usb_kill_urb` returns, the URB is totally idle.
 
 There is a lifetime issue to consider.  An URB may complete at any
 time, and the completion handler may free the URB.  If this happens
-while usb_unlink_urb or usb_kill_urb is running, it will cause a
-memory-access violation.  The driver is responsible for avoiding this,
+while :c:func:`usb_unlink_urb` or :c:func:`usb_kill_urb` is running, it will
+cause a memory-access violation.  The driver is responsible for avoiding this,
 which often means some sort of lock will be needed to prevent the URB
 from being deallocated while it is still in use.
 
@@ -181,24 +199,25 @@ when usb_unlink_urb is invoked.  The general solution to this problem
 is to increment the URB's reference count while holding the lock, then
 drop the lock and call usb_unlink_urb or usb_kill_urb, and then
 decrement the URB's reference count.  You increment the reference
-count by calling
+count by calling :c:func`usb_get_urb`::
 
 	struct urb *usb_get_urb(struct urb *urb)
 
 (ignore the return value; it is the same as the argument) and
-decrement the reference count by calling usb_free_urb.  Of course,
+decrement the reference count by calling :c:func:`usb_free_urb`.  Of course,
 none of this is necessary if there's no danger of the URB being freed
 by the completion handler.
 
 
-1.7. What about the completion handler?
+What about the completion handler?
+==================================
 
-The handler is of the following type:
+The handler is of the following type::
 
 	typedef void (*usb_complete_t)(struct urb *)
 
 I.e., it gets the URB that caused the completion call. In the completion
-handler, you should have a look at urb->status to detect any USB errors.
+handler, you should have a look at ``urb->status`` to detect any USB errors.
 Since the context parameter is included in the URB, you can pass
 information to the completion handler.
 
@@ -208,26 +227,33 @@ sixteen packets to transfer your 1KByte buffer, and ten of them might
 have transferred successfully before the completion was called.
 
 
-NOTE:  ***** WARNING *****
-NEVER SLEEP IN A COMPLETION HANDLER.  These are often called in atomic
-context.
+.. warning::
+
+   NEVER SLEEP IN A COMPLETION HANDLER.
+
+   These are often called in atomic context.
 
 In the current kernel, completion handlers run with local interrupts
 disabled, but in the future this will be changed, so don't assume that
 local IRQs are always disabled inside completion handlers.
 
-1.8. How to do isochronous (ISO) transfers?
+How to do isochronous (ISO) transfers?
+======================================
 
-For ISO transfers you have to fill a usb_iso_packet_descriptor structure,
-allocated at the end of the URB by usb_alloc_urb(n,mem_flags), for each
-packet you want to schedule.   You also have to set urb->interval to say
-how often to make transfers; it's often one per frame (which is once
-every microframe for highspeed devices).  The actual interval used will
-be a power of two that's no bigger than what you specify.
+Besides the fields present on a bulk transfer, for ISO, you also
+also have to set ``urb->interval`` to say how often to make transfers; it's
+often one per frame (which is once every microframe for highspeed devices).
+The actual interval used will be a power of two that's no bigger than what
+you specify. You can use the :c:func:`usb_fill_int_urb` macro to fill
+most ISO transfer fields.
 
-The usb_submit_urb() call modifies urb->interval to the implemented interval
-value that is less than or equal to the requested interval value.  If
-ISO_ASAP scheduling is used, urb->start_frame is also updated.
+For ISO transfers you also have to fill a :c:type:`usb_iso_packet_descriptor`
+structure, allocated at the end of the URB by :c:func:`usb_alloc_urb`, for
+each packet you want to schedule.
+
+The :c:func:`usb_submit_urb` call modifies ``urb->interval`` to the implemented
+interval value that is less than or equal to the requested interval value.  If
+``URB_ISO_ASAP`` scheduling is used, ``urb->start_frame`` is also updated.
 
 For each entry you have to specify the data offset for this frame (base is
 transfer_buffer), and the length you want to write/expect to read.
@@ -237,25 +263,29 @@ It is allowed to specify a varying length from frame to frame (e.g. for
 audio synchronisation/adaptive transfer rates). You can also use the length 
 0 to omit one or more frames (striping).
 
-For scheduling you can choose your own start frame or ISO_ASAP. As explained
-earlier, if you always keep at least one URB queued and your completion
-keeps (re)submitting a later URB, you'll get smooth ISO streaming (if usb
-bandwidth utilization allows).
+For scheduling you can choose your own start frame or ``URB_ISO_ASAP``. As
+explained earlier, if you always keep at least one URB queued and your
+completion keeps (re)submitting a later URB, you'll get smooth ISO streaming
+(if usb bandwidth utilization allows).
 
 If you specify your own start frame, make sure it's several frames in advance
 of the current frame.  You might want this model if you're synchronizing
 ISO data with some other event stream.
 
 
-1.9. How to start interrupt (INT) transfers?
+How to start interrupt (INT) transfers?
+=======================================
 
 Interrupt transfers, like isochronous transfers, are periodic, and happen
 in intervals that are powers of two (1, 2, 4 etc) units.  Units are frames
 for full and low speed devices, and microframes for high speed ones.
-The usb_submit_urb() call modifies urb->interval to the implemented interval
-value that is less than or equal to the requested interval value.
+You can use the :c:func:`usb_fill_int_urb` macro to fill INT transfer fields.
+
+The :c:func:`usb_submit_urb` call modifies ``urb->interval`` to the implemented
+interval value that is less than or equal to the requested interval value.
 
 In Linux 2.6, unlike earlier versions, interrupt URBs are not automagically
 restarted when they complete.  They end when the completion handler is
 called, just like other URBs.  If you want an interrupt URB to be restarted,
 your completion handler must resubmit it.
+s
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 3f08cb5d5feb..1bf64edc8c8a 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -10,6 +10,7 @@ Linux USB API
    bulk-streams
    callbacks
    dma
+   URB
    power-management
    hotplug
    persist
diff --git a/Documentation/driver-api/usb/usb.rst b/Documentation/driver-api/usb/usb.rst
index 7e820768ee4f..d15ab8ae5239 100644
--- a/Documentation/driver-api/usb/usb.rst
+++ b/Documentation/driver-api/usb/usb.rst
@@ -1,3 +1,5 @@
+.. _usb-hostside-api:
+
 ===========================
 The Linux-USB Host Side API
 ===========================
-- 
2.9.3
