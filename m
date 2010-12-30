Return-path: <mchehab@gaivota>
Received: from xenotime.net ([72.52.115.56]:42713 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754969Ab0L3SXl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 13:23:41 -0500
Received: from chimera.site ([173.50.240.230]) by xenotime.net for <linux-media@vger.kernel.org>; Thu, 30 Dec 2010 10:23:38 -0800
Date: Thu, 30 Dec 2010 10:23:38 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] staging: usbvideo/vicam depends on USB
Message-Id: <20101230102338.540a42c5.rdunlap@xenotime.net>
In-Reply-To: <20101230125819.351debfc.sfr@canb.auug.org.au>
References: <20101230125819.351debfc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors by adding "depends on USB":

ERROR: "usb_register_driver" [drivers/staging/usbvideo/vicam.ko] undefined!
ERROR: "usb_bulk_msg" [drivers/staging/usbvideo/vicam.ko] undefined!
ERROR: "usb_control_msg" [drivers/staging/usbvideo/vicam.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/usbvideo/vicam.ko] undefined!
ERROR: "usb_get_dev" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_put_dev" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_free_urb" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_submit_urb" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_set_interface" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_kill_urb" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_register_driver" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_deregister" [drivers/staging/usbvideo/usbvideo.ko] undefined!
ERROR: "usb_alloc_urb" [drivers/staging/usbvideo/usbvideo.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/usbvideo/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20101230.orig/drivers/staging/usbvideo/Kconfig
+++ linux-next-20101230/drivers/staging/usbvideo/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_USBVIDEO
 
 config USB_VICAM
 	tristate "USB 3com HomeConnect (aka vicam) support (DEPRECATED)"
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && USB
 	select VIDEO_USBVIDEO
 	---help---
 	  Say Y here if you have 3com homeconnect camera (vicam).
