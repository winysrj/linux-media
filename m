Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:40938 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0IQRBd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 13:01:33 -0400
Date: Fri, 17 Sep 2010 10:01:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] staging: cx25821 and go7007 depend on IR_CORE
Message-Id: <20100917100121.dea03063.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors in cx25821 and go7007.
They both use IR functions, so they should depend on IR_CORE.
(It's not safe to select VIDEO_IR when IR_CORE is not enabled.)

(.text+0x39065a): undefined reference to `ir_core_debug'
(.text+0x3906a4): undefined reference to `ir_core_debug'
ir-functions.c:(.text+0x39080b): undefined reference to `ir_core_debug'
(.text+0x390893): undefined reference to `ir_g_keycode_from_table'
(.text+0x390942): undefined reference to `ir_core_debug'
(.text+0x3909f5): undefined reference to `ir_core_debug'
(.text+0x390a3a): undefined reference to `ir_core_debug'
(.text+0x390ab1): undefined reference to `ir_core_debug'
(.text+0x390b36): undefined reference to `ir_core_debug'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/cx25821/Kconfig |    2 +-
 drivers/staging/go7007/Kconfig  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

(originally sent to lkml, linux-next, and staging mailing lists;
now resending to linux-media)


--- linux-next-20100914.orig/drivers/staging/cx25821/Kconfig
+++ linux-next-20100914/drivers/staging/cx25821/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
--- linux-next-20100914.orig/drivers/staging/go7007/Kconfig
+++ linux-next-20100914/drivers/staging/go7007/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
 	depends on SND
 	select VIDEOBUF_DMA_SG
 	select VIDEO_IR
--
To unsubscribe from this list: send the line "unsubscribe linux-next" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
