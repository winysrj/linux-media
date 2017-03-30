Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47305 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933406AbdC3KqO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 06:46:14 -0400
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
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Masanari Iida <standby24x7@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Christian Gromm <christian.gromm@microchip.com>,
        Andrey Shvetsov <andrey.shvetsov@k2l.de>,
        Peter Chen <peter.chen@nxp.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-pm@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 21/22] docs-rst: fix usb cross-references
Date: Thu, 30 Mar 2017 07:45:55 -0300
Message-Id: <50db04845612db92568d121fa1eed29271d77e21.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
In-Reply-To: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
References: <3068fc7fac09293300b9c59ece0adb985232de12.1490870599.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As some USB documentation files got moved, adjust their
cross-references to their new place.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/ABI/stable/sysfs-bus-usb            | 2 +-
 Documentation/driver-api/usb/URB.rst              | 2 ++
 Documentation/driver-api/usb/callbacks.rst        | 4 ++--
 Documentation/driver-api/usb/error-codes.rst      | 2 ++
 Documentation/driver-api/usb/persist.rst          | 2 ++
 Documentation/driver-api/usb/power-management.rst | 2 +-
 Documentation/driver-api/usb/usb.rst              | 4 ++--
 Documentation/power/swsusp.txt                    | 2 +-
 drivers/staging/most/hdm-usb/hdm_usb.c            | 2 +-
 drivers/usb/core/Kconfig                          | 2 +-
 10 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-bus-usb b/Documentation/ABI/stable/sysfs-bus-usb
index 831f15d9672f..b832eeff9999 100644
--- a/Documentation/ABI/stable/sysfs-bus-usb
+++ b/Documentation/ABI/stable/sysfs-bus-usb
@@ -9,7 +9,7 @@ Description:
 		hubs this facility is always enabled and their device
 		directories will not contain this file.
 
-		For more information, see Documentation/usb/persist.txt.
+		For more information, see Documentation/driver-api/usb/persist.rst.
 
 What:		/sys/bus/usb/devices/.../power/autosuspend
 Date:		March 2007
diff --git a/Documentation/driver-api/usb/URB.rst b/Documentation/driver-api/usb/URB.rst
index 2bcd06c2c5aa..810ceb0e71bb 100644
--- a/Documentation/driver-api/usb/URB.rst
+++ b/Documentation/driver-api/usb/URB.rst
@@ -1,3 +1,5 @@
+.. _usb-urb:
+
 USB Request Block (URB)
 ~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/driver-api/usb/callbacks.rst b/Documentation/driver-api/usb/callbacks.rst
index 93a8d53e27e7..2b80cf54bcc3 100644
--- a/Documentation/driver-api/usb/callbacks.rst
+++ b/Documentation/driver-api/usb/callbacks.rst
@@ -8,7 +8,7 @@ Usbcore will call into a driver through callbacks defined in the driver
 structure and through the completion handler of URBs a driver submits.
 Only the former are in the scope of this document. These two kinds of
 callbacks are completely independent of each other. Information on the
-completion callback can be found in Documentation/usb/URB.txt.
+completion callback can be found in :ref:`usb-urb`.
 
 The callbacks defined in the driver structure are:
 
@@ -53,7 +53,7 @@ The callbacks defined in the driver structure are:
 
 The ioctl interface (2) should be used only if you have a very good
 reason. Sysfs is preferred these days. The PM callbacks are covered
-separately in Documentation/usb/power-management.txt.
+separately in :ref:`usb-power-management`.
 
 Calling conventions
 ===================
diff --git a/Documentation/driver-api/usb/error-codes.rst b/Documentation/driver-api/usb/error-codes.rst
index 9c11a0fd16cb..a3e84bfac776 100644
--- a/Documentation/driver-api/usb/error-codes.rst
+++ b/Documentation/driver-api/usb/error-codes.rst
@@ -1,3 +1,5 @@
+.. _usb-error-codes:
+
 USB Error codes
 ~~~~~~~~~~~~~~~
 
diff --git a/Documentation/driver-api/usb/persist.rst b/Documentation/driver-api/usb/persist.rst
index ea1b43f0559e..08cafc6292c1 100644
--- a/Documentation/driver-api/usb/persist.rst
+++ b/Documentation/driver-api/usb/persist.rst
@@ -1,3 +1,5 @@
+.. _usb-persist:
+
 USB device persistence during system suspend
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
diff --git a/Documentation/driver-api/usb/power-management.rst b/Documentation/driver-api/usb/power-management.rst
index c068257f6d27..79beb807996b 100644
--- a/Documentation/driver-api/usb/power-management.rst
+++ b/Documentation/driver-api/usb/power-management.rst
@@ -328,7 +328,7 @@ possible to work around the hibernation-forces-disconnect problem by
 using the USB Persist facility.)
 
 The ``reset_resume`` method is used by the USB Persist facility (see
-``Documentation/usb/persist.txt``) and it can also be used under certain
+:ref:`usb-persist`) and it can also be used under certain
 circumstances when ``CONFIG_USB_PERSIST`` is not enabled.  Currently, if a
 device is reset during a resume and the driver does not have a
 ``reset_resume`` method, the driver won't receive any notification about
diff --git a/Documentation/driver-api/usb/usb.rst b/Documentation/driver-api/usb/usb.rst
index 5ebaf669704c..6824089ef4c8 100644
--- a/Documentation/driver-api/usb/usb.rst
+++ b/Documentation/driver-api/usb/usb.rst
@@ -424,8 +424,8 @@ header.
 Unless noted otherwise, the ioctl requests described here will update
 the modification time on the usbfs file to which they are applied
 (unless they fail). A return of zero indicates success; otherwise, a
-standard USB error code is returned. (These are documented in
-``Documentation/usb/error-codes.txt`` in your kernel sources.)
+standard USB error code is returned (These are documented in
+:ref:`usb-error-codes`).
 
 Each of these files multiplexes access to several I/O streams, one per
 endpoint. Each device has one control endpoint (endpoint zero) which
diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index 8cc17ca71813..9f2f942a01cf 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -406,7 +406,7 @@ Firewire, CompactFlash, MMC, external SATA, or even IDE hotplug bays)
 before suspending; then remount them after resuming.
 
 There is a work-around for this problem.  For more information, see
-Documentation/usb/persist.txt.
+Documentation/driver-api/usb/persist.rst.
 
 Q: Can I suspend-to-disk using a swap partition under LVM?
 
diff --git a/drivers/staging/most/hdm-usb/hdm_usb.c b/drivers/staging/most/hdm-usb/hdm_usb.c
index 65211d1824b7..2bfea9b48366 100644
--- a/drivers/staging/most/hdm-usb/hdm_usb.c
+++ b/drivers/staging/most/hdm-usb/hdm_usb.c
@@ -490,7 +490,7 @@ static void hdm_write_completion(struct urb *urb)
  * disconnect.  In the interval before the hub driver starts disconnect
  * processing, devices may receive such fault reports for every request.
  *
- * See <https://www.kernel.org/doc/Documentation/usb/error-codes.txt>
+ * See <https://www.kernel.org/doc/Documentation/driver-api/usb/error-codes.rst>
  */
 static void hdm_read_completion(struct urb *urb)
 {
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index 0e5a889742b3..4d75d9a80001 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -26,7 +26,7 @@ config USB_DEFAULT_PERSIST
 	  unplugged, causing any mounted filesystems to be lost.  The
 	  persist feature can still be enabled for individual devices
 	  through the power/persist sysfs node. See
-	  Documentation/usb/persist.txt for more info.
+	  Documentation/driver-api/usb/persist.rst for more info.
 
 	  If you have any questions about this, say Y here, only say N
 	  if you know exactly what you are doing.
-- 
2.9.3
