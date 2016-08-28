Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36052 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755669AbcH1SAl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Aug 2016 14:00:41 -0400
To: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] media: usb: dvb-usb: fix DIBUSB_MB usage of dib3000mc
 functions
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <a052b0e8-068f-5299-265e-d47f4b654d69@infradead.org>
Date: Sun, 28 Aug 2016 11:00:30 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

The problem is that this driver uses a "common" driver supplement
which calls a few dib3000mc*() functions but that driver is not
"select"ed by DVB_USB_DIBUSB_MB. We can fix the build errors by
selecting DVB_DIB3000MC (at the expense of around 8 KB on x86_64)
just to add a few "library-like" functions.

Or someone can split the required functions into a separate
buildable file, but for such an ancient driver, I don't see the
need to do this.

Fixes these build errors:

drivers/built-in.o: In function `dibusb_dib3000mc_frontend_attach':
(.text+0x1a63bd): undefined reference to `dib3000mc_pid_parse'
drivers/built-in.o: In function `dibusb_dib3000mc_frontend_attach':
(.text+0x1a63c5): undefined reference to `dib3000mc_pid_control'
drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
(.text+0x1a6610): undefined reference to `dib3000mc_set_config'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/usb/dvb-usb/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- lnx-48-rc3.orig/drivers/media/usb/dvb-usb/Kconfig
+++ lnx-48-rc3/drivers/media/usb/dvb-usb/Kconfig
@@ -34,6 +34,7 @@ config DVB_USB_DIBUSB_MB
 	depends on DVB_USB
 	select DVB_PLL if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_DIB3000MB
+	select DVB_DIB3000MC
 	select MEDIA_TUNER_MT2060 if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for USB 1.1 and 2.0 DVB-T receivers based on reference designs made by
