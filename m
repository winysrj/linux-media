Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:53702 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbbDJUWY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2015 16:22:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Antti Palosaari <crope@iki.fi>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] [media] R820T tuner needs CONFIG_BITREVERSE
Date: Fri, 10 Apr 2015 22:22:08 +0200
Message-ID: <2673957.2kdD2H8QE5@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In a rarely hit randconfig case, the r820t tuner driver can
get built when CONFIG_BITREVERSE is not selected by any
other driver, resulting in this error:

drivers/built-in.o: In function `r820t_read.constprop.3':
:(.text+0xa0594): undefined reference to `byte_rev_table'

For consistency, this adds the 'select BITREVERSE' that
all other similar drivers have.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 983510d282f6..db4caf2b4669 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -258,6 +258,7 @@ config MEDIA_TUNER_R820T
 	tristate "Rafael Micro R820T silicon tuner"
 	depends on MEDIA_SUPPORT && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
+	select BITREVERSE
 	help
 	  Rafael Micro R820T silicon tuner driver.
 

