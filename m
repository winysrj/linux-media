Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22906 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HSRmk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 13:42:40 -0400
Date: Thu, 19 Aug 2010 10:42:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-media@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] tm6000: depends on IR_CORE
Message-Id: <20100819104214.2f95bcf4.randy.dunlap@oracle.com>
In-Reply-To: <20100819143941.d3ea5cb4.sfr@canb.auug.org.au>
References: <20100819143941.d3ea5cb4.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

tm6000 uses IR interfaces, so it should depend on IR_CORE.

ERROR: "get_rc_map" [drivers/staging/tm6000/tm6000.ko] undefined!
ERROR: "ir_input_unregister" [drivers/staging/tm6000/tm6000.ko] undefined!
ERROR: "__ir_input_register" [drivers/staging/tm6000/tm6000.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/tm6000/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100819.orig/drivers/staging/tm6000/Kconfig
+++ linux-next-20100819/drivers/staging/tm6000/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_TM6000
 	tristate "TV Master TM5600/6000/6010 driver"
-	depends on VIDEO_DEV && I2C && INPUT && USB && EXPERIMENTAL
+	depends on VIDEO_DEV && I2C && INPUT && IR_CORE && USB && EXPERIMENTAL
 	select VIDEO_TUNER
 	select MEDIA_TUNER_XC2028
 	select MEDIA_TUNER_XC5000
