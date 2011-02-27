Return-path: <mchehab@pedra>
Received: from rcsinet10.oracle.com ([148.87.113.121]:52075 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1B0RwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 12:52:17 -0500
Date: Sun, 27 Feb 2011 09:51:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-media@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Cc: Mauro <mchehab@infradead.org>,
	Matti Aaltonen <matti.j.aaltonen@nokia.com>
Subject: [PATCH] media/radio/wl1273: fix build errors
Message-Id: <20110227095154.2741d051.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Randy Dunlap <randy.dunlap@oracle.com>

RADIO_WL1273 needs to make sure that the mfd core is built to avoid
build errors:

ERROR: "mfd_add_devices" [drivers/mfd/wl1273-core.ko] undefined!
ERROR: "mfd_remove_devices" [drivers/mfd/wl1273-core.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
---
(also needed in mainline)

 drivers/media/radio/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20110223.orig/drivers/media/radio/Kconfig
+++ linux-next-20110223/drivers/media/radio/Kconfig
@@ -441,6 +441,7 @@ config RADIO_TIMBERDALE
 config RADIO_WL1273
 	tristate "Texas Instruments WL1273 I2C FM Radio"
 	depends on I2C && VIDEO_V4L2
+	select MFD_CORE
 	select MFD_WL1273_CORE
 	select FW_LOADER
 	---help---
