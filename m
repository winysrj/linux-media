Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:62793 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKLbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 06:31:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Romain Izard <romain.izard.pro@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Thadeu Lima de Souza Cascardo <cascardo@cascardo.eti.br>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: gadget: restore tristate-choice for legacy gadgets
Date: Mon, 11 Dec 2017 12:30:13 +0100
Message-Id: <20171211113048.3514863-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

One patch that was meant as a cleanup apparently did more than it intended,
allowing all combinations of legacy gadget drivers to be built into the
kernel, and leaving an empty 'choice' statement behind:

drivers/usb/gadget/Kconfig:487:warning: choice default symbol 'USB_ETH' is not contained in the choice

The description of commit 7a9618a22aad ("usb: gadget: allow to enable legacy
drivers without USB_ETH") was a bit cryptic, as it did not change the
behavior of USB_ETH other than allowing it to be built into the kernel
alongside other legacy gadgets, which is not a valid configuration.

As Felipe explained in the description for commit bc49d1d17dcf ("usb:
gadget: don't couple configfs to legacy gadgets"), the configfs based
gadgets can be freely configured as loadable modules or built-in
drivers, but the legacy gadgets can only be modules if there is more
than one of them, so we require the 'choice' statement here.

This leaves the added USB_GADGET_LEGACY menuconfig symbol in place,
but then restores the 'choice' below it, so we can enforce the
single-legacy-gadget rule as before.

Fixes: 7a9618a22aad ("usb: gadget: allow to enable legacy drivers without USB_ETH")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/Kconfig        | 28 ----------------------------
 drivers/usb/gadget/legacy/Kconfig | 28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 0a19a76645ad..eab61f552c19 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -482,34 +482,6 @@ config USB_CONFIGFS_F_TCM
 	  Both protocols can work on USB2.0 and USB3.0.
 	  UAS utilizes the USB 3.0 feature called streams support.
 
-choice
-	tristate "USB Gadget precomposed configurations"
-	default USB_ETH
-	optional
-	help
-	  A Linux "Gadget Driver" talks to the USB Peripheral Controller
-	  driver through the abstract "gadget" API.  Some other operating
-	  systems call these "client" drivers, of which "class drivers"
-	  are a subset (implementing a USB device class specification).
-	  A gadget driver implements one or more USB functions using
-	  the peripheral hardware.
-
-	  Gadget drivers are hardware-neutral, or "platform independent",
-	  except that they sometimes must understand quirks or limitations
-	  of the particular controllers they work with.  For example, when
-	  a controller doesn't support alternate configurations or provide
-	  enough of the right types of endpoints, the gadget driver might
-	  not be able work with that controller, or might need to implement
-	  a less common variant of a device class protocol.
-
-	  The available choices each represent a single precomposed USB
-	  gadget configuration. In the device model, each option contains
-	  both the device instantiation as a child for a USB gadget
-	  controller, and the relevant drivers for each function declared
-	  by the device.
-
-endchoice
-
 source "drivers/usb/gadget/legacy/Kconfig"
 
 endif # USB_GADGET
diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
index 9570bbeced4f..2d80a9d1d5d9 100644
--- a/drivers/usb/gadget/legacy/Kconfig
+++ b/drivers/usb/gadget/legacy/Kconfig
@@ -21,6 +21,32 @@ menuconfig USB_GADGET_LEGACY
 
 if USB_GADGET_LEGACY
 
+choice
+	tristate "USB Gadget precomposed configurations"
+	default USB_ETH
+	optional
+	help
+	  A Linux "Gadget Driver" talks to the USB Peripheral Controller
+	  driver through the abstract "gadget" API.  Some other operating
+	  systems call these "client" drivers, of which "class drivers"
+	  are a subset (implementing a USB device class specification).
+	  A gadget driver implements one or more USB functions using
+	  the peripheral hardware.
+
+	  Gadget drivers are hardware-neutral, or "platform independent",
+	  except that they sometimes must understand quirks or limitations
+	  of the particular controllers they work with.  For example, when
+	  a controller doesn't support alternate configurations or provide
+	  enough of the right types of endpoints, the gadget driver might
+	  not be able work with that controller, or might need to implement
+	  a less common variant of a device class protocol.
+
+	  The available choices each represent a single precomposed USB
+	  gadget configuration. In the device model, each option contains
+	  both the device instantiation as a child for a USB gadget
+	  controller, and the relevant drivers for each function declared
+	  by the device.
+
 config USB_ZERO
 	tristate "Gadget Zero (DEVELOPMENT)"
 	select USB_LIBCOMPOSITE
@@ -499,4 +525,6 @@ config USB_G_WEBCAM
 	  Say "y" to link the driver statically, or "m" to build a
 	  dynamically linked module called "g_webcam".
 
+endchoice
+
 endif
-- 
2.9.0
