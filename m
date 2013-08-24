Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab3HXL6o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Aug 2013 07:58:44 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] Fix build errors on usbtv when driver is builtin
Date: Sat, 24 Aug 2013 05:58:02 -0300
Message-Id: <1377334682-7753-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by  Fengguang Wu <fengguang.wu@intel.com>

   drivers/built-in.o: In function `vb2_ioctl_streamon':
>> (.text+0x8d354): undefined reference to `video_devdata'
   drivers/built-in.o: In function `vb2_ioctl_streamoff':
>> (.text+0x8d397): undefined reference to `video_devdata'
   drivers/built-in.o: In function `vb2_ioctl_expbuf':
...

That happens when:
	CONFIG_VIDEO_DEV=y
	CONFIG_VIDEO_V4L2=m
	CONFIG_VIDEO_USBTV=y

As the core is module, usbtv should also be compiled as module.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/usbtv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
index 8864436..7c5b860 100644
--- a/drivers/media/usb/usbtv/Kconfig
+++ b/drivers/media/usb/usbtv/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_USBTV
         tristate "USBTV007 video capture support"
-        depends on VIDEO_DEV
+        depends on VIDEO_V4L2
         select VIDEOBUF2_VMALLOC
 
         ---help---
-- 
1.8.3.1

