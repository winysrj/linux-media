Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39967
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755234AbdDENX0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 5 Apr 2017 09:23:26 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH v2 17/21] usb.rst: get rid of some Sphinx errors
Date: Wed,  5 Apr 2017 10:23:11 -0300
Message-Id: <7c3d290a55dd2da162ed1730e7a3529ee4b2c53d.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1491398120.git.mchehab@s-opensource.com>
References: <cover.1491398120.git.mchehab@s-opensource.com>
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
