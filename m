Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:54655 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbcAMOYh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 09:24:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] s5c73m3: remove duplicate module device table
Date: Wed, 13 Jan 2016 15:23:51 +0100
Message-ID: <4126175.vzSgvM02WI@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Clang complains about an extraneous definition of the module
device table after the patch to add it was accidentally merged
twice:

../drivers/media/i2c/s5c73m3/s5c73m3-spi.c:40:1: error: redefinition of
      '__mod_of__s5c73m3_spi_ids_device_table'
MODULE_DEVICE_TABLE(of, s5c73m3_spi_ids);
^
../include/linux/module.h:223:27: note: expanded from macro 'MODULE_DEVICE_TABLE'
extern const typeof(name) __mod_##type##__##name##_device_table         \
                          ^
<scratch space>:99:1: note: expanded from here
__mod_of__s5c73m3_spi_ids_device_table

This removes the second definition.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: f934a94bb566 ("[media] s5c73m3: Export OF module alias information")
---
Found while doing randconfig testing with clang, this is currently only
broken in linux-next, not in 4.4

diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
index 7d65b36434b1..72ef9f936e6c 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-spi.c
@@ -37,7 +37,6 @@ enum spi_direction {
 	SPI_DIR_RX,
 	SPI_DIR_TX
 };
-MODULE_DEVICE_TABLE(of, s5c73m3_spi_ids);
 
 static int spi_xmit(struct spi_device *spi_dev, void *addr, const int len,
 							enum spi_direction dir)

