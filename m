Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51147 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753529AbdC2Sye (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 14:54:34 -0400
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
Subject: [PATCH 17/22] usb.rst: get rid of some Sphinx errors
Date: Wed, 29 Mar 2017 15:54:16 -0300
Message-Id: <ea93a879099e0fcedae10c02c89b6a0475cea128.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
In-Reply-To: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Get rid of those warnings:

    Documentation/driver-api/usb/usb.rst:615: ERROR: Unknown target name: "usb_type".
    Documentation/driver-api/usb/usb.rst:615: ERROR: Unknown target name: "usb_dir".
    Documentation/driver-api/usb/usb.rst:615: ERROR: Unknown target name: "usb_recip".
    Documentation/driver-api/usb/usb.rst:679: ERROR: Unknown target name: "usbdevfs_urb_type".

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/driver-api/usb/usb.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/driver-api/usb/usb.rst b/Documentation/driver-api/usb/usb.rst
index d15ab8ae5239..5ebaf669704c 100644
--- a/Documentation/driver-api/usb/usb.rst
+++ b/Documentation/driver-api/usb/usb.rst
@@ -615,8 +615,8 @@ USBDEVFS_CONTROL
     The first eight bytes of this structure are the contents of the
     SETUP packet to be sent to the device; see the USB 2.0 specification
     for details. The bRequestType value is composed by combining a
-    USB_TYPE_\* value, a USB_DIR_\* value, and a USB_RECIP_\*
-    value (from *<linux/usb.h>*). If wLength is nonzero, it describes
+    ``USB_TYPE_*`` value, a ``USB_DIR_*`` value, and a ``USB_RECIP_*``
+    value (from ``linux/usb.h``). If wLength is nonzero, it describes
     the length of the data buffer, which is either written to the device
     (USB_DIR_OUT) or read from the device (USB_DIR_IN).
 
@@ -678,7 +678,7 @@ the blocking is separate.
 
 These requests are packaged into a structure that resembles the URB used
 by kernel device drivers. (No POSIX Async I/O support here, sorry.) It
-identifies the endpoint type (USBDEVFS_URB_TYPE_\*), endpoint
+identifies the endpoint type (``USBDEVFS_URB_TYPE_*``), endpoint
 (number, masked with USB_DIR_IN as appropriate), buffer and length,
 and a user "context" value serving to uniquely identify each request.
 (It's usually a pointer to per-request data.) Flags can modify requests
-- 
2.9.3
