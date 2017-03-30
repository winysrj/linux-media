Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42051 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933270AbdC3KqL (ORCPT
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
Subject: [PATCH v2 14/22] usb/hotplug.txt: convert to ReST and add to driver-api book
Date: Thu, 30 Mar 2017 07:45:48 -0300
Message-Id: <3116d4bf22f930179da736d620b3d8109b5bb510.1490870599.git.mchehab@s-opensource.com>
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
 .../hotplug.txt => driver-api/usb/hotplug.rst}     | 66 ++++++++++++----------
 Documentation/driver-api/usb/index.rst             |  1 +
 2 files changed, 37 insertions(+), 30 deletions(-)
 rename Documentation/{usb/hotplug.txt => driver-api/usb/hotplug.rst} (76%)

diff --git a/Documentation/usb/hotplug.txt b/Documentation/driver-api/usb/hotplug.rst
similarity index 76%
rename from Documentation/usb/hotplug.txt
rename to Documentation/driver-api/usb/hotplug.rst
index 5b243f315b2c..79663e653ca1 100644
--- a/Documentation/usb/hotplug.txt
+++ b/Documentation/driver-api/usb/hotplug.rst
@@ -1,4 +1,9 @@
-LINUX HOTPLUGGING
+USB hotplugging
+~~~~~~~~~~~~~~~
+
+Linux Hotplugging
+=================
+
 
 In hotpluggable busses like USB (and Cardbus PCI), end-users plug devices
 into the bus with power on.  In most cases, users expect the devices to become
@@ -30,11 +35,11 @@ Because some of those actions rely on information about drivers (metadata)
 that is currently available only when the drivers are dynamically linked,
 you get the best hotplugging when you configure a highly modular system.
 
+Kernel Hotplug Helper (``/sbin/hotplug``)
+=========================================
 
-KERNEL HOTPLUG HELPER (/sbin/hotplug)
-
-There is a kernel parameter: /proc/sys/kernel/hotplug, which normally
-holds the pathname "/sbin/hotplug".  That parameter names a program
+There is a kernel parameter: ``/proc/sys/kernel/hotplug``, which normally
+holds the pathname ``/sbin/hotplug``.  That parameter names a program
 which the kernel may invoke at various times.
 
 The /sbin/hotplug program can be invoked by any subsystem as part of its
@@ -51,26 +56,26 @@ Hotplug software and other resources is available at:
 Mailing list information is also available at that site.
 
 
---------------------------------------------------------------------------
+USB Policy Agent
+================
 
-
-USB POLICY AGENT
-
-The USB subsystem currently invokes /sbin/hotplug when USB devices
+The USB subsystem currently invokes ``/sbin/hotplug`` when USB devices
 are added or removed from system.  The invocation is done by the kernel
 hub workqueue [hub_wq], or else as part of root hub initialization
 (done by init, modprobe, kapmd, etc).  Its single command line parameter
 is the string "usb", and it passes these environment variables:
 
-    ACTION ... "add", "remove"
-    PRODUCT ... USB vendor, product, and version codes (hex)
-    TYPE ... device class codes (decimal)
-    INTERFACE ... interface 0 class codes (decimal)
+========== ============================================
+ACTION     ``add``, ``remove``
+PRODUCT    USB vendor, product, and version codes (hex)
+TYPE       device class codes (decimal)
+INTERFACE  interface 0 class codes (decimal)
+========== ============================================
 
 If "usbdevfs" is configured, DEVICE and DEVFS are also passed.  DEVICE is
 the pathname of the device, and is useful for devices with multiple and/or
 alternate interfaces that complicate driver selection.  By design, USB
-hotplugging is independent of "usbdevfs":  you can do most essential parts
+hotplugging is independent of ``usbdevfs``:  you can do most essential parts
 of USB device setup without using that filesystem, and without running a
 user mode daemon to detect changes in system configuration.
 
@@ -79,19 +84,20 @@ modules, and can invoke driver-specific setup scripts.  The newest ones
 leverage USB module-init-tools support.  Later agents might unload drivers.
 
 
-USB MODUTILS SUPPORT
+USB Modutils Support
+====================
 
-Current versions of module-init-tools will create a "modules.usbmap" file
-which contains the entries from each driver's MODULE_DEVICE_TABLE.  Such
+Current versions of module-init-tools will create a ``modules.usbmap`` file
+which contains the entries from each driver's ``MODULE_DEVICE_TABLE``.  Such
 files can be used by various user mode policy agents to make sure all the
 right driver modules get loaded, either at boot time or later.
 
-See <linux/usb.h> for full information about such table entries; or look
+See ``linux/usb.h`` for full information about such table entries; or look
 at existing drivers.  Each table entry describes one or more criteria to
 be used when matching a driver to a device or class of devices.  The
 specific criteria are identified by bits set in "match_flags", paired
 with field values.  You can construct the criteria directly, or with
-macros such as these, and use driver_info to store more information.
+macros such as these, and use driver_info to store more information::
 
     USB_DEVICE (vendorId, productId)
 	... matching devices with specified vendor and product ids
@@ -103,7 +109,7 @@ macros such as these, and use driver_info to store more information.
 	... matching specified device class info
 
 A short example, for a driver that supports several specific USB devices
-and their quirks, might have a MODULE_DEVICE_TABLE like this:
+and their quirks, might have a MODULE_DEVICE_TABLE like this::
 
     static const struct usb_device_id mydriver_id_table[] = {
 	{ USB_DEVICE (0x9999, 0xaaaa), driver_info: QUIRK_X },
@@ -116,10 +122,10 @@ and their quirks, might have a MODULE_DEVICE_TABLE like this:
 Most USB device drivers should pass these tables to the USB subsystem as
 well as to the module management subsystem.  Not all, though: some driver
 frameworks connect using interfaces layered over USB, and so they won't
-need such a "struct usb_driver".
+need such a struct :c:type:`usb_driver`.
 
 Drivers that connect directly to the USB subsystem should be declared
-something like this:
+something like this::
 
     static struct usb_driver mydriver = {
 	.name		= "mydriver",
@@ -138,11 +144,11 @@ something like this:
 
 When the USB subsystem knows about a driver's device ID table, it's used when
 choosing drivers to probe().  The thread doing new device processing checks
-drivers' device ID entries from the MODULE_DEVICE_TABLE against interface and
-device descriptors for the device.  It will only call probe() if there is a
-match, and the third argument to probe() will be the entry that matched.
-
-If you don't provide an id_table for your driver, then your driver may get
-probed for each new device; the third parameter to probe() will be null.
-
+drivers' device ID entries from the ``MODULE_DEVICE_TABLE`` against interface
+and device descriptors for the device.  It will only call ``probe()`` if there
+is a match, and the third argument to ``probe()`` will be the entry that
+matched.
 
+If you don't provide an ``id_table`` for your driver, then your driver may get
+probed for each new device; the third parameter to ``probe()`` will be
+``NULL``.
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 1e2a0c54eb3d..43f0a8b72b11 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -11,6 +11,7 @@ Linux USB API
    callbacks
    dma
    power-management
+   hotplug
    error-codes
    writing_usb_driver
    writing_musb_glue_layer
-- 
2.9.3
