Return-path: <linux-media-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:52944 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab0BJRyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 12:54:35 -0500
Date: Wed, 10 Feb 2010 09:53:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Michel Ludwig <michel.ludwig@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [PATCH -next] tm6000: fix build errors
Message-Id: <20100210095357.34b86082.randy.dunlap@oracle.com>
In-Reply-To: <20100210175521.0fd0866e.sfr@canb.auug.org.au>
References: <20100210175521.0fd0866e.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

(1) tm6000 uses usb_*() interfaces, so it should depend on USB.

drivers/built-in.o: In function `tm6000_usb_disconnect':
tm6000-cards.c:(.text+0x4abb44): undefined reference to `usb_put_dev'
drivers/built-in.o: In function `tm6000_usb_probe':
tm6000-cards.c:(.text+0x4ac923): undefined reference to `usb_get_dev'
tm6000-cards.c:(.text+0x4ac93c): undefined reference to `usb_set_interface'
drivers/built-in.o: In function `tm6000_read_write_usb':
(.text+0x4ad274): undefined reference to `usb_control_msg'
drivers/built-in.o: In function `tm6000_uninit_isoc':
tm6000-video.c:(.text+0x4b00d5): undefined reference to `usb_kill_urb'
tm6000-video.c:(.text+0x4b00e4): undefined reference to `usb_unlink_urb'
tm6000-video.c:(.text+0x4b013c): undefined reference to `usb_buffer_free'
tm6000-video.c:(.text+0x4b014b): undefined reference to `usb_free_urb'
drivers/built-in.o: In function `tm6000_prepare_isoc':
tm6000-video.c:(.text+0x4b0773): undefined reference to `usb_alloc_urb'
tm6000-video.c:(.text+0x4b0835): undefined reference to `usb_buffer_alloc'
drivers/built-in.o: In function `tm6000_irq_callback':
tm6000-video.c:(.text+0x4b1ad3): undefined reference to `usb_submit_urb'
drivers/built-in.o: In function `tm6000_module_init':
tm6000-cards.c:(.init.text+0x24499): undefined reference to `usb_register_driver'
drivers/built-in.o: In function `tm6000_module_exit':
tm6000-cards.c:(.exit.text+0x5cb0): undefined reference to `usb_deregister'

(2) tm6000-alsa uses interfaces from tm6000-core, so when they are
both built as modules, the core interfaces need to be exported.

ERROR: "tm6000_set_reg" [drivers/staging/tm6000/tm6000-alsa.ko] undefined!
ERROR: "tm6000_get_reg" [drivers/staging/tm6000/tm6000-alsa.ko] undefined!


Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michel Ludwig <michel.ludwig@gmail.com>
---
 drivers/staging/tm6000/Kconfig       |    2 +-
 drivers/staging/tm6000/tm6000-core.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20100210.orig/drivers/staging/tm6000/Kconfig
+++ linux-next-20100210/drivers/staging/tm6000/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_TM6000
 	tristate "TV Master TM5600/6000/6010 driver"
-	depends on VIDEO_DEV && I2C && INPUT && EXPERIMENTAL
+	depends on VIDEO_DEV && I2C && INPUT && USB && EXPERIMENTAL
 	select VIDEO_TUNER
 	select TUNER_XC2028
 	select VIDEOBUF_VMALLOC
--- linux-next-20100210.orig/drivers/staging/tm6000/tm6000-core.c
+++ linux-next-20100210/drivers/staging/tm6000/tm6000-core.c
@@ -108,6 +108,7 @@ int tm6000_set_reg (struct tm6000_core *
 		tm6000_read_write_usb (dev, USB_DIR_OUT | USB_TYPE_VENDOR,
 				       req, value, index, NULL, 0);
 }
+EXPORT_SYMBOL_GPL(tm6000_set_reg);
 
 int tm6000_get_reg (struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
@@ -122,6 +123,7 @@ int tm6000_get_reg (struct tm6000_core *
 
 	return *buf;
 }
+EXPORT_SYMBOL_GPL(tm6000_get_reg);
 
 int tm6000_get_reg16 (struct tm6000_core *dev, u8 req, u16 value, u16 index)
 {
