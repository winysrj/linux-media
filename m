Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45833
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753049AbdC3J3M (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:29:12 -0400
Date: Thu, 30 Mar 2017 06:29:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: Re: [PATCH 04/22] gadget.rst: Enrich its ReST representation and
 add kernel-doc tag
Message-ID: <20170330062904.1142a3c6@vento.lan>
In-Reply-To: <871stf454v.fsf@intel.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
        <61bf3d87b32a57f5d223dc3fd0228c342ba1b4a0.1490813422.git.mchehab@s-opensource.com>
        <874lyb459y.fsf@intel.com>
        <871stf454v.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Mar 2017 10:04:32 +0300
Jani Nikula <jani.nikula@linux.intel.com> escreveu:

> On Thu, 30 Mar 2017, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> > On Wed, 29 Mar 2017, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:  
> >> The pandoc conversion is not perfect. Do handwork in order to:
> >>
> >> - add a title to this chapter;
> >> - use the proper warning and note markups;
> >> - use kernel-doc to include Kernel header and c files;  
> >
> > Please look at Documentation/sphinx/tmplcvt which takes care of all of
> > that.  
> 
> That said, since you've already manually done the work, you might want
> to do another conversion using the script, and diff the results to see
> if there's something you've perhaps missed. I'm pretty sure nobody's
> going to read patch 2 line-by-line...

Done. The only thing left was the original docbook title and author
information.

The diff also showed that I was a little lazy manually adjust the
gadget.rst document ;) The enclosed patch should fix those issues.

I'll likely fold it with other patches when sending a version 2.

Regards,
Mauro

[PATCH] docs-rst: improve docbook-converted documents

The output of Documentation/sphinx/tmplcvt showed that a few
adjustments could be done in order to improve the output of
the two files that were converted from docbook:

- Use the original title from docbook;
- Add author info;
- Add C references for source code xrefs;
- Use monospaced fonts to be consistent with other docs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/Documentation/driver-api/usb/gadget.rst b/Documentation/driver-api/usb/gadget.rst
index 0488b89de21c..4b02c61a389d 100644
--- a/Documentation/driver-api/usb/gadget.rst
+++ b/Documentation/driver-api/usb/gadget.rst
@@ -1,6 +1,9 @@
-Linux-USB "Gadget" kernel mode API
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~
+USB Gadget API for Linux
+~~~~~~~~~~~~~~~~~~~~~~~~
 
+:Author: David Brownell
+:Date:   20 August 2004
 
 Introduction
 ============
@@ -35,7 +38,7 @@ address a number of important problems, including:
    resources.
 
 Most Linux developers will not be able to use this API, since they have
-USB "host" hardware in a PC, workstation, or server. Linux users with
+USB ``host`` hardware in a PC, workstation, or server. Linux users with
 embedded systems are more likely to have USB peripheral hardware. To
 distinguish drivers running inside such hardware from the more familiar
 Linux "USB device drivers", which are host side proxies for the real USB
@@ -61,7 +64,7 @@ Structure of Gadget Drivers
 
 A system running inside a USB peripheral normally has at least three
 layers inside the kernel to handle USB protocol processing, and may have
-additional layers in user space code. The "gadget" API is used by the
+additional layers in user space code. The ``gadget`` API is used by the
 middle layer to interact with the lowest level (which directly handles
 hardware).
 
@@ -140,13 +143,13 @@ In Linux, from the bottom up, these layers are:
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
@@ -171,11 +174,11 @@ combined, to implement composite devices.
 Kernel Mode Gadget API
 ======================
 
-Gadget drivers declare themselves through a *struct
-usb\_gadget\_driver*, which is responsible for most parts of enumeration
-for a *struct usb\_gadget*. The response to a set\_configuration usually
-involves enabling one or more of the *struct usb\_ep* objects exposed by
-the gadget, and submitting one or more *struct usb\_request* buffers to
+Gadget drivers declare themselves through a struct
+:c:type:`usb_gadget_driver`, which is responsible for most parts of enumeration
+for a struct :c:type:`usb_gadget`. The response to a set_configuration usually
+involves enabling one or more of the struct :c:type:`usb_ep` objects exposed by
+the gadget, and submitting one or more struct :c:type:`usb_request` buffers to
 transfer data. Understand those four data types, and their operations,
 and you will understand how this API works.
 
@@ -239,28 +242,28 @@ needs to handle some differences. Use the API like this:
 1. Register a driver for the particular device side usb controller
    hardware, such as the net2280 on PCI (USB 2.0), sa11x0 or pxa25x as
    found in Linux PDAs, and so on. At this point the device is logically
-   in the USB ch9 initial state ("attached"), drawing no power and not
+   in the USB ch9 initial state (``attached``), drawing no power and not
    usable (since it does not yet support enumeration). Any host should
    not see the device, since it's not activated the data line pullup
    used by the host to detect a device, even if VBUS power is available.
 
 2. Register a gadget driver that implements some higher level device
-   function. That will then bind() to a usb\_gadget, which activates the
-   data line pullup sometime after detecting VBUS.
+   function. That will then bind() to a :c:type:`usb_gadget`, which activates
+   the data line pullup sometime after detecting VBUS.
 
 3. The hardware driver can now start enumerating. The steps it handles
-   are to accept USB power and set\_address requests. Other steps are
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
-   host issues a set\_configuration call. It enables all endpoints used
+   host issues a ``set_configuration`` call. It enables all endpoints used
    in that configuration, with all interfaces in their default settings.
    That involves using a list of the hardware's endpoints, enabling each
    endpoint according to its descriptor. It may also involve using
@@ -293,7 +296,7 @@ built by integrating reusable components.
 Note that the lifecycle above can be slightly different for OTG devices.
 Other than providing an additional OTG descriptor in each configuration,
 only the HNP-related differences are particularly visible to driver
-code. They involve reporting requirements during the SET\_CONFIGURATION
+code. They involve reporting requirements during the ``SET_CONFIGURATION``
 request, and the option to invoke HNP during some suspend callbacks.
 Also, SRP changes the semantics of ``usb_gadget_wakeup`` slightly.
 
@@ -336,10 +339,10 @@ multi-configuration devices (also more than one function, but not
 necessarily sharing a given configuration). There is however an optional
 framework which makes it easier to reuse and combine functions.
 
-Devices using this framework provide a *struct usb\_composite\_driver*,
-which in turn provides one or more *struct usb\_configuration*
-instances. Each such configuration includes at least one *struct
-usb\_function*, which packages a user visible role such as "network
+Devices using this framework provide a struct :c:type:`usb_composite_driver`,
+which in turn provides one or more struct :c:type:`usb_configuration`
+instances. Each such configuration includes at least one struct
+:c:type:`usb_function`, which packages a user visible role such as "network
 link" or "mass storage device". Management functions may also exist,
 such as "Device Firmware Upgrade".
 
@@ -354,7 +357,7 @@ Composite Device Functions
 
 At this writing, a few of the current gadget drivers have been converted
 to this framework. Near-term plans include converting all of them,
-except for "gadgetfs".
+except for ``gadgetfs``.
 
 Peripheral Controller Drivers
 =============================
@@ -365,7 +368,7 @@ which supports USB 2.0 high speed and is based on PCI. This is the
 and 2.6; contact NetChip Technologies for development boards and product
 information.
 
-Other hardware working in the "gadget" framework includes: Intel's PXA
+Other hardware working in the ``gadget`` framework includes: Intel's PXA
 25x and IXP42x series processors (``pxa2xx_udc``), Toshiba TC86c001
 "Goku-S" (``goku_udc``), Renesas SH7705/7727 (``sh_udc``), MediaQ 11xx
 (``mq11xx_udc``), Hynix HMS30C7202 (``h7202_udc``), National 9303/4
@@ -396,7 +399,7 @@ Gadget Drivers
 In addition to *Gadget Zero* (used primarily for testing and development
 with drivers for usb controller hardware), other gadget drivers exist.
 
-There's an *ethernet* gadget driver, which implements one of the most
+There's an ``ethernet`` gadget driver, which implements one of the most
 useful *Communications Device Class* (CDC) models. One of the standards
 for cable modem interoperability even specifies the use of this ethernet
 model as one of two mandatory options. Gadgets using this code look to a
@@ -408,16 +411,16 @@ driver also implements a "good parts only" subset of CDC Ethernet. (That
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
@@ -453,21 +456,21 @@ Systems need specialized hardware support to implement OTG, notably
 including a special *Mini-AB* jack and associated transceiver to support
 *Dual-Role* operation: they can act either as a host, using the standard
 Linux-USB host side driver stack, or as a peripheral, using this
-"gadget" framework. To do that, the system software relies on small
+``gadget`` framework. To do that, the system software relies on small
 additions to those programming interfaces, and on a new internal
 component (here called an "OTG Controller") affecting which driver stack
 connects to the OTG port. In each role, the system can re-use the
 existing pool of hardware-neutral drivers, layered on top of the
-controller driver interfaces (*usb\_bus* or *usb\_gadget*). Such drivers
-need at most minor changes, and most of the calls added to support OTG
-can also benefit non-OTG products.
+controller driver interfaces (:c:type:`usb_bus` or :c:type:`usb_gadget`).
+Such drivers need at most minor changes, and most of the calls added to
+support OTG can also benefit non-OTG products.
 
--  Gadget drivers test the *is\_otg* flag, and use it to determine
+-  Gadget drivers test the ``is_otg`` flag, and use it to determine
    whether or not to include an OTG descriptor in each of their
    configurations.
 
 -  Gadget drivers may need changes to support the two new OTG protocols,
-   exposed in new gadget attributes such as *b\_hnp\_enable* flag. HNP
+   exposed in new gadget attributes such as ``b_hnp_enable`` flag. HNP
    support should be reported through a user interface (two LEDs could
    suffice), and is triggered in some cases when the host suspends the
    peripheral. SRP support can be user-initiated just like remote
@@ -494,8 +497,8 @@ can also benefit non-OTG products.
    been distributed, so driver bugs can't normally be fixed if they're
    found after shipment.
 
-Additional changes are needed below those hardware-neutral *usb\_bus*
-and *usb\_gadget* driver interfaces; those aren't discussed here in any
+Additional changes are needed below those hardware-neutral :c:type:`usb_bus`
+and :c:type:`usb_gadget` driver interfaces; those aren't discussed here in any
 detail. Those affect the hardware-specific code for each USB Host or
 Peripheral controller, and how the HCD initializes (since OTG can be
 active only on a single port). They also involve what may be called an
diff --git a/Documentation/driver-api/usb/writing_usb_driver.rst b/Documentation/driver-api/usb/writing_usb_driver.rst
index 180859f664db..c751c2e99fb0 100644
--- a/Documentation/driver-api/usb/writing_usb_driver.rst
+++ b/Documentation/driver-api/usb/writing_usb_driver.rst
@@ -1,7 +1,10 @@
 .. _writing-usb-driver:
 
-Writing USB drivers
-~~~~~~~~~~~~~~~~~~~
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+Writing USB Device Drivers
+~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+:Author: Greg Kroah-Hartman
 
 Introduction
 ============


Thanks,
Mauro
