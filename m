Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:62280 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbcCNWkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 18:40:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [media] cobalt: add MTD dependency
Date: Mon, 14 Mar 2016 23:40:07 +0100
Message-Id: <1457995225-1199991-1-git-send-email-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cobalt driver fails to link when it is built-in and MTD is disabled or a
loadable module:

drivers/media/built-in.o: In function `cobalt_flash_probe':
:(.text+0xb8b46): undefined reference to `mtd_device_parse_register'
:(.text+0xb8b88): undefined reference to `do_map_probe'
drivers/media/built-in.o: In function `cobalt_flash_remove':
:(.text+0xb8bb4): undefined reference to `mtd_device_unregister'
:(.text+0xb8bbe): undefined reference to `map_destroy'

This adds a Kconfig dependency to ensure we can call the API.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/pci/cobalt/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cobalt/Kconfig b/drivers/media/pci/cobalt/Kconfig
index a01f0cc745cc..70343829a125 100644
--- a/drivers/media/pci/cobalt/Kconfig
+++ b/drivers/media/pci/cobalt/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_COBALT
 	depends on PCI_MSI && MTD_COMPLEX_MAPPINGS
 	depends on GPIOLIB || COMPILE_TEST
 	depends on SND
+	depends on MTD
 	select I2C_ALGOBIT
 	select VIDEO_ADV7604
 	select VIDEO_ADV7511
-- 
2.7.0

