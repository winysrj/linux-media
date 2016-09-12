Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:63476 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933178AbcILPfc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Sep 2016 11:35:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: uvc: add V4L2 dependency
Date: Mon, 12 Sep 2016 17:34:57 +0200
Message-Id: <20160912153521.3136533-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Building the UVC gadget into the kernel fails to build when
CONFIG_VIDEO_V4L2 is a loadable module:

drivers/usb/gadget/function/usb_f_uvc.o: In function `uvc_function_ep0_complete':
uvc_configfs.c:(.text.uvc_function_ep0_complete+0x84): undefined reference to `v4l2_event_queue'
drivers/usb/gadget/function/usb_f_uvc.o: In function `uvc_function_disable':
uvc_configfs.c:(.text.uvc_function_disable+0x34): undefined reference to `v4l2_event_queue'

Adding a dependency in USB_CONFIGFS_F_UVC (which is a bool symbol)
make the 'select USB_F_UVC' statement turn the USB_F_UVC into 'm'
whenever CONFIG_VIDEO_V4L2=m too, avoiding the link failure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/gadget/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 2ea3fc3c41b9..8ad203296079 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -420,6 +420,7 @@ config USB_CONFIGFS_F_HID
 config USB_CONFIGFS_F_UVC
 	bool "USB Webcam function"
 	depends on USB_CONFIGFS
+	depends on VIDEO_V4L2
 	depends on VIDEO_DEV
 	select VIDEOBUF2_VMALLOC
 	select USB_F_UVC
-- 
2.9.0

