Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40656 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933341AbdC3KqL (ORCPT
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
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v2 04/22] usb.rst: Enrich its ReST representation
Date: Thu, 30 Mar 2017 07:45:38 -0300
Message-Id: <f6647d7f131d9f1831da1977341a8ecd378441c8.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- use the proper warning and note markups;
- add references for parts of the document that will be
  cross-referenced on other USB docs;
- some minor adjustments to make it better to read in
  text mode and in html.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/usb.rst | 48 +++++++++++++-----------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/Documentation/driver-api/usb/usb.rst b/Documentation/driver-api/usb/usb.rst
index b856abb3200e..7e820768ee4f 100644
--- a/Documentation/driver-api/usb/usb.rst
+++ b/Documentation/driver-api/usb/usb.rst
@@ -102,6 +102,8 @@ disconnect testing (while the device is active) with each different host
 controller driver, to make sure drivers don't have bugs of their own as
 well as to make sure they aren't relying on some HCD-specific behavior.
 
+.. _usb_chapter9:
+
 USB-Standard Types
 ==================
 
@@ -112,6 +114,8 @@ USB, and in APIs including this host side API, gadget APIs, and usbfs.
 .. kernel-doc:: include/linux/usb/ch9.h
    :internal:
 
+.. _usb_header:
+
 Host-Side Data Types and Macros
 ===============================
 
@@ -209,7 +213,7 @@ library that wraps it. Such libraries include
 `libusb <http://libusb.sourceforge.net>`__ for C/C++, and
 `jUSB <http://jUSB.sourceforge.net>`__ for Java.
 
-    **Note**
+.. note::
 
     This particular documentation is incomplete, especially with respect
     to the asynchronous mode. As of kernel 2.5.66 the code and this
@@ -319,9 +323,7 @@ files. For information about the current format of this file, see the
 sources.
 
 This file, in combination with the poll() system call, can also be used
-to detect when devices are added or removed:
-
-::
+to detect when devices are added or removed::
 
     int fd;
     struct pollfd pfd;
@@ -407,9 +409,7 @@ The ioctl() Requests
 --------------------
 
 To use these ioctls, you need to include the following headers in your
-userspace program:
-
-::
+userspace program::
 
     #include <linux/usb.h>
     #include <linux/usbdevice_fs.h>
@@ -458,9 +458,7 @@ USBDEVFS_CLAIMINTERFACE
 
 USBDEVFS_CONNECTINFO
     Says whether the device is lowspeed. The ioctl parameter points to a
-    structure like this:
-
-    ::
+    structure like this::
 
 	struct usbdevfs_connectinfo {
 		unsigned int   devnum;
@@ -477,9 +475,7 @@ USBDEVFS_CONNECTINFO
 USBDEVFS_GETDRIVER
     Returns the name of the kernel driver bound to a given interface (a
     string). Parameter is a pointer to this structure, which is
-    modified:
-
-    ::
+    modified::
 
 	struct usbdevfs_getdriver {
 		unsigned int  interface;
@@ -490,9 +486,7 @@ USBDEVFS_GETDRIVER
 
 USBDEVFS_IOCTL
     Passes a request from userspace through to a kernel driver that has
-    an ioctl entry in the *struct usb_driver* it registered.
-
-    ::
+    an ioctl entry in the *struct usb_driver* it registered::
 
 	struct usbdevfs_ioctl {
 		int     ifno;
@@ -534,7 +528,7 @@ USBDEVFS_RELEASEINTERFACE
     the number of the interface (bInterfaceNumber from descriptor); File
     modification time is not updated by this request.
 
-	**Warning**
+.. warning::
 
 	*No security check is made to ensure that the task which made
 	the claim is the one which is releasing it. This means that user
@@ -574,9 +568,7 @@ a time.
 
 USBDEVFS_BULK
     Issues a bulk read or write request to the device. The ioctl
-    parameter is a pointer to this structure:
-
-    ::
+    parameter is a pointer to this structure::
 
 	struct usbdevfs_bulktransfer {
 		unsigned int  ep;
@@ -606,9 +598,7 @@ USBDEVFS_CLEAR_HALT
 
 USBDEVFS_CONTROL
     Issues a control request to the device. The ioctl parameter points
-    to a structure like this:
-
-    ::
+    to a structure like this::
 
 	struct usbdevfs_ctrltransfer {
 		__u8   bRequestType;
@@ -638,7 +628,7 @@ USBDEVFS_RESET
     the reset, this rebinds all device interfaces. File modification
     time is not updated by this request.
 
-	**Warning**
+.. warning::
 
 	*Avoid using this call* until some usbcore bugs get fixed, since
 	it does not fully synchronize device, interface, and driver (not
@@ -646,9 +636,7 @@ USBDEVFS_RESET
 
 USBDEVFS_SETINTERFACE
     Sets the alternate setting for an interface. The ioctl parameter is
-    a pointer to a structure like this:
-
-    ::
+    a pointer to a structure like this::
 
 	struct usbdevfs_setinterface {
 		unsigned int  interface;
@@ -669,7 +657,7 @@ USBDEVFS_SETCONFIGURATION
     configuration (bConfigurationValue from descriptor). File
     modification time is not updated by this request.
 
-	**Warning**
+.. warning::
 
 	*Avoid using this call* until some usbcore bugs get fixed, since
 	it does not fully synchronize device, interface, and driver (not
@@ -702,9 +690,7 @@ When usbfs returns these urbs, the status value is updated, and the
 buffer may have been modified. Except for isochronous transfers, the
 actual_length is updated to say how many bytes were transferred; if the
 USBDEVFS_URB_DISABLE_SPD flag is set ("short packets are not OK"), if
-fewer bytes were read than were requested then you get an error report.
-
-::
+fewer bytes were read than were requested then you get an error report::
 
     struct usbdevfs_iso_packet_desc {
 	    unsigned int                     length;
-- 
2.9.3
