Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58575 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933367AbdC3KqL (ORCPT
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
Subject: [PATCH v2 05/22] gadget.rst: Enrich its ReST representation and add kernel-doc tag
Date: Thu, 30 Mar 2017 07:45:39 -0300
Message-Id: <a8367c68db5229ecd360892b163cb6b0f19df046.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pandoc conversion is not perfect. Do handwork in order to:

- add a title to this chapter;
- use the proper warning and note markups;
- use kernel-doc to include Kernel header and c files;
- remove legacy notes with regards to DocBook;
- some other minor adjustments to make it better to read in
  text mode and in html.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/gadget.rst | 127 +++++++++++++-------------------
 1 file changed, 52 insertions(+), 75 deletions(-)

diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
index 52b299b1ca6d..3e8a3809c0b8 100644
--- a/Documentation/driver-api/usb/gadget.rst
+++ b/Documentation/driver-api/usb/gadget.rst
@@ -38,7 +38,7 @@ address a number of important problems, including:
    resources.
 
 Most Linux developers will not be able to use this API, since they have
-USB "host" hardware in a PC, workstation, or server. Linux users with
+USB ``host`` hardware in a PC, workstation, or server. Linux users with
 embedded systems are more likely to have USB peripheral hardware. To
 distinguish drivers running inside such hardware from the more familiar
 Linux "USB device drivers", which are host side proxies for the real USB
@@ -64,7 +64,7 @@ Structure of Gadget Drivers
 
 A system running inside a USB peripheral normally has at least three
 layers inside the kernel to handle USB protocol processing, and may have
-additional layers in user space code. The "gadget" API is used by the
+additional layers in user space code. The ``gadget`` API is used by the
 middle layer to interact with the lowest level (which directly handles
 hardware).
 
@@ -143,13 +143,13 @@ In Linux, from the bottom up, these layers are:
 *Additional Layers*
     Other layers may exist. These could include kernel layers, such as
     network protocol stacks, as well as user mode applications building
-    on standard POSIX system call APIs such as *open()*, *close()*,
-    *read()* and *write()*. On newer systems, POSIX Async I/O calls may
+    on standard POSIX system call APIs such as ``open()``, ``close()``,
+    ``read()`` and ``write()``. On newer systems, POSIX Async I/O calls may
     be an option. Such user mode code will not necessarily be subject to
     the GNU General Public License (GPL).
 
 OTG-capable systems will also need to include a standard Linux-USB host
-side stack, with *usbcore*, one or more *Host Controller Drivers*
+side stack, with ``usbcore``, one or more *Host Controller Drivers*
 (HCDs), *USB Device Drivers* to support the OTG "Targeted Peripheral
 List", and so forth. There will also be an *OTG Controller Driver*,
 which is visible to gadget and device driver developers only indirectly.
@@ -174,24 +174,20 @@ combined, to implement composite devices.
 Kernel Mode Gadget API
 ======================
 
-Gadget drivers declare themselves through a *struct
-usb_gadget_driver*, which is responsible for most parts of enumeration
-for a *struct usb_gadget*. The response to a set_configuration usually
-involves enabling one or more of the *struct usb_ep* objects exposed by
-the gadget, and submitting one or more *struct usb_request* buffers to
+Gadget drivers declare themselves through a struct
+:c:type:`usb_gadget_driver`, which is responsible for most parts of enumeration
+for a struct :c:type:`usb_gadget`. The response to a set_configuration usually
+involves enabling one or more of the struct :c:type:`usb_ep` objects exposed by
+the gadget, and submitting one or more struct :c:type:`usb_request` buffers to
 transfer data. Understand those four data types, and their operations,
 and you will understand how this API works.
 
-    **Note**
+.. Note::
 
-    This documentation was prepared using the standard Linux kernel
-    ``docproc`` tool, which turns text and in-code comments into SGML
-    DocBook and then into usable formats such as HTML or PDF. Other than
-    the "Chapter 9" data types, most of the significant data types and
-    functions are described here.
+    Other than the "Chapter 9" data types, most of the significant data
+    types and functions are described here.
 
-    However, docproc does not understand all the C constructs that are
-    used, so some relevant information is likely omitted from what you
+    However, some relevant information is likely omitted from what you
     are reading. One example of such information is endpoint
     autoconfiguration. You'll have to read the header file, and use
     example source code (such as that for "Gadget Zero"), to fully
@@ -199,10 +195,10 @@ and you will understand how this API works.
 
     The part of the API implementing some basic driver capabilities is
     specific to the version of the Linux kernel that's in use. The 2.6
-    kernel includes a *driver model* framework that has no analogue on
-    earlier kernels; so those parts of the gadget API are not fully
-    portable. (They are implemented on 2.4 kernels, but in a different
-    way.) The driver model state is another part of this API that is
+    and upper kernel versions include a *driver model* framework that has
+    no analogue on earlier kernels; so those parts of the gadget API are
+    not fully portable. (They are implemented on 2.4 kernels, but in a
+    different way.) The driver model state is another part of this API that is
     ignored by the kerneldoc tools.
 
 The core API does not expose every possible hardware feature, only the
@@ -246,34 +242,34 @@ needs to handle some differences. Use the API like this:
 1. Register a driver for the particular device side usb controller
    hardware, such as the net2280 on PCI (USB 2.0), sa11x0 or pxa25x as
    found in Linux PDAs, and so on. At this point the device is logically
-   in the USB ch9 initial state ("attached"), drawing no power and not
+   in the USB ch9 initial state (``attached``), drawing no power and not
    usable (since it does not yet support enumeration). Any host should
    not see the device, since it's not activated the data line pullup
    used by the host to detect a device, even if VBUS power is available.
 
 2. Register a gadget driver that implements some higher level device
-   function. That will then bind() to a usb_gadget, which activates the
-   data line pullup sometime after detecting VBUS.
+   function. That will then bind() to a :c:type:`usb_gadget`, which activates
+   the data line pullup sometime after detecting VBUS.
 
 3. The hardware driver can now start enumerating. The steps it handles
-   are to accept USB power and set_address requests. Other steps are
+   are to accept USB ``power`` and ``set_address`` requests. Other steps are
    handled by the gadget driver. If the gadget driver module is unloaded
    before the host starts to enumerate, steps before step 7 are skipped.
 
-4. The gadget driver's setup() call returns usb descriptors, based both
+4. The gadget driver's ``setup()`` call returns usb descriptors, based both
    on what the bus interface hardware provides and on the functionality
    being implemented. That can involve alternate settings or
    configurations, unless the hardware prevents such operation. For OTG
    devices, each configuration descriptor includes an OTG descriptor.
 
 5. The gadget driver handles the last step of enumeration, when the USB
-   host issues a set_configuration call. It enables all endpoints used
+   host issues a ``set_configuration`` call. It enables all endpoints used
    in that configuration, with all interfaces in their default settings.
    That involves using a list of the hardware's endpoints, enabling each
    endpoint according to its descriptor. It may also involve using
-   :c:func:`usb_gadget_vbus_draw()` to let more power be drawn
-   from VBUS, as allowed by that configuration. For OTG devices, setting
-   a configuration may also involve reporting HNP capabilities through a
+   ``usb_gadget_vbus_draw`` to let more power be drawn from VBUS, as
+   allowed by that configuration. For OTG devices, setting a
+   configuration may also involve reporting HNP capabilities through a
    user interface.
 
 6. Do real work and perform data transfers, possibly involving changes
@@ -300,22 +296,18 @@ built by integrating reusable components.
 Note that the lifecycle above can be slightly different for OTG devices.
 Other than providing an additional OTG descriptor in each configuration,
 only the HNP-related differences are particularly visible to driver
-code. They involve reporting requirements during the SET_CONFIGURATION
+code. They involve reporting requirements during the ``SET_CONFIGURATION``
 request, and the option to invoke HNP during some suspend callbacks.
-Also, SRP changes the semantics of :c:func:`usb_gadget_wakeup()`
-slightly.
+Also, SRP changes the semantics of ``usb_gadget_wakeup`` slightly.
 
 USB 2.0 Chapter 9 Types and Constants
 -------------------------------------
 
 Gadget drivers rely on common USB structures and constants defined in
-the ``<linux/usb/ch9.h>`` header file, which is standard in Linux 2.6
-kernels. These are the same types and constants used by host side
+the :ref:`linux/usb/ch9.h <usb_chapter9>` header file, which is standard in
+Linux 2.6+ kernels. These are the same types and constants used by host side
 drivers (and usbcore).
 
-.. kernel-doc:: include/linux/usb/ch9.h
-   :internal:
-
 Core Objects and Methods
 ------------------------
 
@@ -347,10 +339,10 @@ multi-configuration devices (also more than one function, but not
 necessarily sharing a given configuration). There is however an optional
 framework which makes it easier to reuse and combine functions.
 
-Devices using this framework provide a *struct usb_composite_driver*,
-which in turn provides one or more *struct usb_configuration*
-instances. Each such configuration includes at least one *struct
-usb_function*, which packages a user visible role such as "network
+Devices using this framework provide a struct :c:type:`usb_composite_driver`,
+which in turn provides one or more struct :c:type:`usb_configuration`
+instances. Each such configuration includes at least one struct
+:c:type:`usb_function`, which packages a user visible role such as "network
 link" or "mass storage device". Management functions may also exist,
 such as "Device Firmware Upgrade".
 
@@ -365,22 +357,7 @@ Composite Device Functions
 
 At this writing, a few of the current gadget drivers have been converted
 to this framework. Near-term plans include converting all of them,
-except for "gadgetfs".
-
-.. kernel-doc:: drivers/usb/gadget/function/f_acm.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_ecm.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_subset.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_obex.c
-   :export:
-
-.. kernel-doc:: drivers/usb/gadget/function/f_serial.c
-   :export:
+except for ``gadgetfs``.
 
 Peripheral Controller Drivers
 =============================
@@ -391,7 +368,7 @@ which supports USB 2.0 high speed and is based on PCI. This is the
 and 2.6; contact NetChip Technologies for development boards and product
 information.
 
-Other hardware working in the "gadget" framework includes: Intel's PXA
+Other hardware working in the ``gadget`` framework includes: Intel's PXA
 25x and IXP42x series processors (``pxa2xx_udc``), Toshiba TC86c001
 "Goku-S" (``goku_udc``), Renesas SH7705/7727 (``sh_udc``), MediaQ 11xx
 (``mq11xx_udc``), Hynix HMS30C7202 (``h7202_udc``), National 9303/4
@@ -422,7 +399,7 @@ Gadget Drivers
 In addition to *Gadget Zero* (used primarily for testing and development
 with drivers for usb controller hardware), other gadget drivers exist.
 
-There's an *ethernet* gadget driver, which implements one of the most
+There's an ``ethernet`` gadget driver, which implements one of the most
 useful *Communications Device Class* (CDC) models. One of the standards
 for cable modem interoperability even specifies the use of this ethernet
 model as one of two mandatory options. Gadgets using this code look to a
@@ -434,16 +411,16 @@ driver also implements a "good parts only" subset of CDC Ethernet. (That
 subset doesn't advertise itself as CDC Ethernet, to avoid creating
 problems.)
 
-Support for Microsoft's *RNDIS* protocol has been contributed by
+Support for Microsoft's ``RNDIS`` protocol has been contributed by
 Pengutronix and Auerswald GmbH. This is like CDC Ethernet, but it runs
 on more slightly USB hardware (but less than the CDC subset). However,
 its main claim to fame is being able to connect directly to recent
 versions of Windows, using drivers that Microsoft bundles and supports,
 making it much simpler to network with Windows.
 
-There is also support for user mode gadget drivers, using *gadgetfs*.
+There is also support for user mode gadget drivers, using ``gadgetfs``.
 This provides a *User Mode API* that presents each endpoint as a single
-file descriptor. I/O is done using normal *read()* and *read()* calls.
+file descriptor. I/O is done using normal ``read()`` and ``read()`` calls.
 Familiar tools like GDB and pthreads can be used to develop and debug
 user mode drivers, so that once a robust controller driver is available
 many applications for it won't require new kernel mode software. Linux
@@ -479,35 +456,35 @@ Systems need specialized hardware support to implement OTG, notably
 including a special *Mini-AB* jack and associated transceiver to support
 *Dual-Role* operation: they can act either as a host, using the standard
 Linux-USB host side driver stack, or as a peripheral, using this
-"gadget" framework. To do that, the system software relies on small
+``gadget`` framework. To do that, the system software relies on small
 additions to those programming interfaces, and on a new internal
 component (here called an "OTG Controller") affecting which driver stack
 connects to the OTG port. In each role, the system can re-use the
 existing pool of hardware-neutral drivers, layered on top of the
-controller driver interfaces (*usb_bus* or *usb_gadget*). Such drivers
-need at most minor changes, and most of the calls added to support OTG
-can also benefit non-OTG products.
+controller driver interfaces (:c:type:`usb_bus` or :c:type:`usb_gadget`).
+Such drivers need at most minor changes, and most of the calls added to
+support OTG can also benefit non-OTG products.
 
--  Gadget drivers test the *is_otg* flag, and use it to determine
+-  Gadget drivers test the ``is_otg`` flag, and use it to determine
    whether or not to include an OTG descriptor in each of their
    configurations.
 
 -  Gadget drivers may need changes to support the two new OTG protocols,
-   exposed in new gadget attributes such as *b_hnp_enable* flag. HNP
+   exposed in new gadget attributes such as ``b_hnp_enable`` flag. HNP
    support should be reported through a user interface (two LEDs could
    suffice), and is triggered in some cases when the host suspends the
    peripheral. SRP support can be user-initiated just like remote
    wakeup, probably by pressing the same button.
 
 -  On the host side, USB device drivers need to be taught to trigger HNP
-   at appropriate moments, using :c:func:`usb_suspend_device()`.
-   That also conserves battery power, which is useful even for non-OTG
+   at appropriate moments, using ``usb_suspend_device()``. That also
+   conserves battery power, which is useful even for non-OTG
    configurations.
 
 -  Also on the host side, a driver must support the OTG "Targeted
    Peripheral List". That's just a whitelist, used to reject peripherals
    not supported with a given Linux OTG host. *This whitelist is
-   product-specific; each product must modify ``otg_whitelist.h`` to
+   product-specific; each product must modify* ``otg_whitelist.h`` *to
    match its interoperability specification.*
 
    Non-OTG Linux hosts, like PCs and workstations, normally have some
@@ -520,8 +497,8 @@ can also benefit non-OTG products.
    been distributed, so driver bugs can't normally be fixed if they're
    found after shipment.
 
-Additional changes are needed below those hardware-neutral *usb_bus*
-and *usb_gadget* driver interfaces; those aren't discussed here in any
+Additional changes are needed below those hardware-neutral :c:type:`usb_bus`
+and :c:type:`usb_gadget` driver interfaces; those aren't discussed here in any
 detail. Those affect the hardware-specific code for each USB Host or
 Peripheral controller, and how the HCD initializes (since OTG can be
 active only on a single port). They also involve what may be called an
-- 
2.9.3
