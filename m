Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbFZT2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2015 15:28:16 -0400
Message-ID: <558DA7CD.60708@infradead.org>
Date: Fri, 26 Jun 2015 12:28:13 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: [PATCH -next] media/dvb: fix ts2020.c Kconfig and build
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <rdunlap@infradead.org>

Fix kconfig warning that is caused by DVB_TS2020:

warning: (DVB_TS2020 && SND_SOC_ADAU1761_I2C && SND_SOC_ADAU1781_I2C && SND_SOC_ADAU1977_I2C && SND_SOC_RT5677 && EXTCON_MAX14577 && EXTCON_MAX77693 && EXTCON_MAX77843) selects REGMAP_I2C which has unmet direct dependencies (I2C)

This fixes many subsequent build errors.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
---
 drivers/media/dvb-frontends/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20150626.orig/drivers/media/dvb-frontends/Kconfig
+++ linux-next-20150626/drivers/media/dvb-frontends/Kconfig
@@ -240,7 +240,7 @@ config DVB_SI21XX
 
 config DVB_TS2020
 	tristate "Montage Tehnology TS2020 based tuners"
-	depends on DVB_CORE
+	depends on DVB_CORE && I2C
 	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
