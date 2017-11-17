Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756904AbdKQOSW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:18:22 -0500
Date: Fri, 17 Nov 2017 15:18:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philippe Ombredanne <pombredanne@nexb.com>
Subject: [PATCH] media: usbvision: remove unneeded DRIVER_LICENSE #define
Message-ID: <20171117141826.GC17880@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to #define the license of the driver, just put it in
the MODULE_LICENSE() line directly as a text string.

This allows tools that check that the module license matches the source
code license to work properly, as there is no need to unwind the
unneeded dereference.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Johan Hovold <johan@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbvision/usbvision-video.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 960272d3c924..0f5954a1fea2 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -72,7 +72,6 @@
 #define DRIVER_NAME "usbvision"
 #define DRIVER_ALIAS "USBVision"
 #define DRIVER_DESC "USBVision USB Video Device Driver for Linux"
-#define DRIVER_LICENSE "GPL"
 #define USBVISION_VERSION_STRING "0.9.11"
 
 #define	ENABLE_HEXDUMP	0	/* Enable if you need it */
@@ -141,7 +140,7 @@ MODULE_PARM_DESC(radio_nr, "Set radio device number (/dev/radioX).  Default: -1
 /* Misc stuff */
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE(DRIVER_LICENSE);
+MODULE_LICENSE("GPL");
 MODULE_VERSION(USBVISION_VERSION_STRING);
 MODULE_ALIAS(DRIVER_ALIAS);
 
-- 
2.15.0
