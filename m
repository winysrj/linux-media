Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35732 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933259AbdC3KqL (ORCPT
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
Subject: [PATCH v2 15/22] usb/persist.txt: convert to ReST and add to driver-api book
Date: Thu, 30 Mar 2017 07:45:49 -0300
Message-Id: <77bb941f5d5819c972eba0a1d8eb4ba384d7b1a3.1490870599.git.mchehab@s-opensource.com>
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
 Documentation/driver-api/usb/index.rst             |  1 +
 .../persist.txt => driver-api/usb/persist.rst}     | 22 +++++++++++++---------
 2 files changed, 14 insertions(+), 9 deletions(-)
 rename Documentation/{usb/persist.txt => driver-api/usb/persist.rst} (94%)

diff --git a/Documentation/driver-api/usb/index.rst b/Documentation/driver-api/usb/index.rst
index 43f0a8b72b11..3f08cb5d5feb 100644
--- a/Documentation/driver-api/usb/index.rst
+++ b/Documentation/driver-api/usb/index.rst
@@ -12,6 +12,7 @@ Linux USB API
    dma
    power-management
    hotplug
+   persist
    error-codes
    writing_usb_driver
    writing_musb_glue_layer
diff --git a/Documentation/usb/persist.txt b/Documentation/driver-api/usb/persist.rst
similarity index 94%
rename from Documentation/usb/persist.txt
rename to Documentation/driver-api/usb/persist.rst
index 35d70eda9ad6..ea1b43f0559e 100644
--- a/Documentation/usb/persist.txt
+++ b/Documentation/driver-api/usb/persist.rst
@@ -1,11 +1,12 @@
-		USB device persistence during system suspend
+USB device persistence during system suspend
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-		   Alan Stern <stern@rowland.harvard.edu>
+:Author: Alan Stern <stern@rowland.harvard.edu>
+:Date: September 2, 2006 (Updated February 25, 2008)
 
-		September 2, 2006 (Updated February 25, 2008)
 
-
-	What is the problem?
+What is the problem?
+====================
 
 According to the USB specification, when a USB bus is suspended the
 bus must continue to supply suspend current (around 1-5 mA).  This
@@ -63,7 +64,8 @@ suspended -- but it will crash as soon as it wakes up, which isn't
 much better.)
 
 
-	What is the solution?
+What is the solution?
+=====================
 
 The kernel includes a feature called USB-persist.  It tries to work
 around these issues by allowing the core USB device data structures to
@@ -99,7 +101,7 @@ now a good and happy place.
 
 Note that the "USB-persist" feature will be applied only to those
 devices for which it is enabled.  You can enable the feature by doing
-(as root):
+(as root)::
 
 	echo 1 >/sys/bus/usb/devices/.../power/persist
 
@@ -110,7 +112,8 @@ doesn't even exist, so you only have to worry about setting it for
 devices where it really matters.
 
 
-	Is this the best solution?
+Is this the best solution?
+==========================
 
 Perhaps not.  Arguably, keeping track of mounted filesystems and
 memory mappings across device disconnects should be handled by a
@@ -130,7 +133,8 @@ just mass-storage devices.  It might turn out to be equally useful for
 other device types, such as network interfaces.
 
 
-	WARNING: USB-persist can be dangerous!!
+WARNING: USB-persist can be dangerous!!
+=======================================
 
 When recovering an interrupted power session the kernel does its best
 to make sure the USB device hasn't been changed; that is, the same
-- 
2.9.3
