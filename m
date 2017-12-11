Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:53909 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751347AbdLKLbO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 06:31:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb: gadget: webcam: fix V4L2 Kconfig dependency
Date: Mon, 11 Dec 2017 12:30:14 +0100
Message-Id: <20171211113048.3514863-2-arnd@arndb.de>
In-Reply-To: <20171211113048.3514863-1-arnd@arndb.de>
References: <20171211113048.3514863-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Configuring the USB_G_WEBCAM driver as built-in leads to a link
error when CONFIG_VIDEO_V4L2 is a loadable module:

drivers/usb/gadget/function/f_uvc.o: In function `uvc_function_setup':
f_uvc.c:(.text+0xfe): undefined reference to `v4l2_event_queue'
drivers/usb/gadget/function/f_uvc.o: In function `uvc_function_ep0_complete':
f_uvc.c:(.text+0x188): undefined reference to `v4l2_event_queue'

This changes the Kconfig dependency to disallow that configuration,
and force it to be a module in that case as well.

This is apparently a rather old bug, but very hard to trigger
even in thousands of randconfig builds.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/legacy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
index 2d80a9d1d5d9..fbd974965399 100644
--- a/drivers/usb/gadget/legacy/Kconfig
+++ b/drivers/usb/gadget/legacy/Kconfig
@@ -513,7 +513,7 @@ endif
 # or video class gadget drivers), or specific hardware, here.
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
-	depends on VIDEO_DEV
+	depends on VIDEO_V4L2
 	select USB_LIBCOMPOSITE
 	select VIDEOBUF2_VMALLOC
 	select USB_F_UVC
-- 
2.9.0
