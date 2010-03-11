Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758222Ab0CKWCi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Mar 2010 17:02:38 -0500
Message-Id: <201003112202.o2BM2FgS013122@imap1.linux-foundation.org>
Subject: [patch 1/5] drivers/media/video/cx23885 needs kfifo conversion
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, akpm@linux-foundation.org,
	stefani@seibold.net
From: akpm@linux-foundation.org
Date: Thu, 11 Mar 2010 14:02:15 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

linux-next:

drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_irq_handler':
drivers/media/video/cx23885/cx23888-ir.c:597: error: implicit declaration of function 'kfifo_put'
drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_rx_read':
drivers/media/video/cx23885/cx23888-ir.c:660: error: implicit declaration of function 'kfifo_get'
drivers/media/video/cx23885/cx23888-ir.c: In function 'cx23888_ir_probe':
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1172: warning: assignment makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 1 of 'kfifo_alloc' makes pointer from integer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: passing argument 3 of 'kfifo_alloc' makes integer from pointer without a cast
drivers/media/video/cx23885/cx23888-ir.c:1178: warning: assignment makes pointer from integer without a cast

Cc: Stefani Seibold <stefani@seibold.net>
DESC
drivers/media/video/cx23885: needs kfifo updates
EDESC
From: Andrew Morton <akpm@linux-foundation.org>

linux-next again.

Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx231xx/Kconfig |    1 +
 drivers/media/video/cx23885/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx231xx/Kconfig
--- a/drivers/media/video/cx231xx/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
+++ a/drivers/media/video/cx231xx/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX231XX
 	tristate "Conexant cx231xx USB video capture support"
 	depends on VIDEO_DEV && I2C && INPUT
+	depends on BROKEN
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_IR
diff -puN drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion drivers/media/video/cx23885/Kconfig
--- a/drivers/media/video/cx23885/Kconfig~drivers-media-video-cx23885-needs-kfifo-conversion
+++ a/drivers/media/video/cx23885/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_CX23885
 	tristate "Conexant cx23885 (2388x successor) support"
 	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on BROKEN
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TUNER
_
