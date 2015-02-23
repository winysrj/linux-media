Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbBWSU1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 13:20:27 -0500
Message-ID: <54EB6F66.3010200@infradead.org>
Date: Mon, 23 Feb 2015 10:20:22 -0800
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans de Goede <hdegoede@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] media: fix gspca drivers build dependencies
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Several (15) drivers in media/usb/gspca use IF_ENABLED(CONFIG_INPUT)
to decide if they should call input* interfaces, but those drivers
do not build successfully when CONFIG_INPUT=m and the gspca drivers
are builtin (=y).  Making USB_GSPCA depend on INPUT || INPUT=n
fixes the build dependencies and allows all of them to build
cleanly.

Fixes these build errors (selections, not all are listed):

drivers/built-in.o: In function `gspca_disconnect':
(.text+0x32ed0f): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `sd_isoc_irq':
konica.c:(.text+0x333098): undefined reference to `input_event'
konica.c:(.text+0x3330ab): undefined reference to `input_event'
drivers/built-in.o: In function `sd_stopN':
konica.c:(.text+0x3338d3): undefined reference to `input_event'
konica.c:(.text+0x3338e5): undefined reference to `input_event'
drivers/built-in.o: In function `ov51x_handle_button':
ov519.c:(.text+0x335ddb): undefined reference to `input_event'
drivers/built-in.o:ov519.c:(.text+0x335ded): more undefined references to `input_event' follow
pac7302.c:(.text+0x336ea1): undefined reference to `input_event'
pac7302.c:(.text+0x336eb3): undefined reference to `input_event'
drivers/built-in.o: In function `sd_pkt_scan':
spca561.c:(.text+0x338fd8): undefined reference to `input_event'
drivers/built-in.o:spca561.c:(.text+0x338feb): more undefined references to `input_event' follow
t613.c:(.text+0x33a6fd): undefined reference to `input_event'
drivers/built-in.o:t613.c:(.text+0x33a70f): more undefined references to `input_event' follow

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/usb/gspca/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20150223.orig/drivers/media/usb/gspca/Kconfig
+++ linux-next-20150223/drivers/media/usb/gspca/Kconfig
@@ -1,6 +1,7 @@
 menuconfig USB_GSPCA
 	tristate "GSPCA based webcams"
 	depends on VIDEO_V4L2
+	depends on INPUT || INPUT=n
 	default m
 	---help---
 	  Say Y here if you want to enable selecting webcams based
