Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38725 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752656AbdC2Syb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:31 -0400
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
Subject: [PATCH 09/22] usb/callbacks.txt: convert to ReST and add to driver-api book
Date: Wed, 29 Mar 2017 15:54:08 -0300
Message-Id: <eb4a8687217ed9aa4823c26cca728ba0aebf8a56.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This document describe some USB core functions. Add it to the
driver-api book.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../callbacks.txt => driver-api/usb/callbacks.rst} | 61 +++++++++++++++-------
 Documentation/driver-api/usb/index.rst             |  1 +
 2 files changed, 43 insertions(+), 19 deletions(-)
 rename Documentation/{usb/callbacks.txt => driver-api/usb/callbacks.rst} (78%)

diff --git a/Documentation/usb/callbacks.txt b/Documentation/driver-api/usb/callbacks.rst
similarity index 78%
rename from Documentation/usb/callbacks.txt
rename to Documentation/driver-api/usb/callbacks.rst
index 9e85846bdb98..93a8d53e27e7 100644
--- a/Documentation/usb/callbacks.txt
+++ b/Documentation/driver-api/usb/callbacks.rst
@@ -1,3 +1,6 @@
+USB core callbacks
+~~~~~~~~~~~~~~~~~~
+
 What callbacks will usbcore do?
 ===============================
 
@@ -11,30 +14,42 @@ The callbacks defined in the driver structure are:
 
 1. Hotplugging callbacks:
 
- * @probe: Called to see if the driver is willing to manage a particular
- *	interface on a device.
- * @disconnect: Called when the interface is no longer accessible, usually
- *	because its device has been (or is being) disconnected or the
- *	driver module is being unloaded.
+ - @probe:
+	Called to see if the driver is willing to manage a particular
+	interface on a device.
+
+ - @disconnect:
+	Called when the interface is no longer accessible, usually
+	because its device has been (or is being) disconnected or the
+	driver module is being unloaded.
 
 2. Odd backdoor through usbfs:
 
- * @ioctl: Used for drivers that want to talk to userspace through
- *	the "usbfs" filesystem.  This lets devices provide ways to
- *	expose information to user space regardless of where they
- *	do (or don't) show up otherwise in the filesystem.
+ - @ioctl:
+	Used for drivers that want to talk to userspace through
+	the "usbfs" filesystem.  This lets devices provide ways to
+	expose information to user space regardless of where they
+	do (or don't) show up otherwise in the filesystem.
 
 3. Power management (PM) callbacks:
 
- * @suspend: Called when the device is going to be suspended.
- * @resume: Called when the device is being resumed.
- * @reset_resume: Called when the suspended device has been reset instead
- *	of being resumed.
+ - @suspend:
+	Called when the device is going to be suspended.
+
+ - @resume:
+	Called when the device is being resumed.
+
+ - @reset_resume:
+	Called when the suspended device has been reset instead
+	of being resumed.
 
 4. Device level operations:
 
- * @pre_reset: Called when the device is about to be reset.
- * @post_reset: Called after the device has been reset
+ - @pre_reset:
+	Called when the device is about to be reset.
+
+ - @post_reset:
+	Called after the device has been reset
 
 The ioctl interface (2) should be used only if you have a very good
 reason. Sysfs is preferred these days. The PM callbacks are covered
@@ -58,7 +73,9 @@ an interface. A driver's bond to an interface is exclusive.
 The probe() callback
 --------------------
 
-int (*probe) (struct usb_interface *intf,
+::
+
+  int (*probe) (struct usb_interface *intf,
 		const struct usb_device_id *id);
 
 Accept or decline an interface. If you accept the device return 0,
@@ -75,7 +92,9 @@ initialisation that doesn't take too long is a good idea here.
 The disconnect() callback
 -------------------------
 
-void (*disconnect) (struct usb_interface *intf);
+::
+
+  void (*disconnect) (struct usb_interface *intf);
 
 This callback is a signal to break any connection with an interface.
 You are not allowed any IO to a device after returning from this
@@ -93,7 +112,9 @@ Device level callbacks
 pre_reset
 ---------
 
-int (*pre_reset)(struct usb_interface *intf);
+::
+
+  int (*pre_reset)(struct usb_interface *intf);
 
 A driver or user space is triggering a reset on the device which
 contains the interface passed as an argument. Cease IO, wait for all
@@ -107,7 +128,9 @@ are in atomic context.
 post_reset
 ----------
 
-int (*post_reset)(struct usb_interface *intf);
+::
+
+  int (*post_reset)(struct usb_interface *intf);
 
 The reset has completed.  Restore any saved device state and begin
 using the device again.
diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 6fe7611f7332..441c5dacdf27 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -8,6 +8,7 @@ Linux USB API
    gadget
    anchors
    bulk-streams
+   callbacks
    writing_usb_driver
    writing_musb_glue_layer
 
-- 
2.9.3
