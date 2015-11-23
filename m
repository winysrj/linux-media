Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48327 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708AbbKWTTn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2015 14:19:43 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, crope@iki.fi, mchehab@osg.samsung.com
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] tda10071: Fix dependency to REGMAP_I2C
Date: Mon, 23 Nov 2015 20:19:04 +0100
Message-Id: <1448306344-7691-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without I get this error for by dvb-card:
  tda10071: Unknown symbol devm_regmap_init_i2c (err 0)
  cx23885_dvb_register() dvb_register failed err = -22
  cx23885_dev_setup() Failed to register dvb adapters on VID_B

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 292c947..310e4b8 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -264,7 +264,7 @@ config DVB_MB86A16
 config DVB_TDA10071
 	tristate "NXP TDA10071"
 	depends on DVB_CORE && I2C
-	select REGMAP
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Say Y when you want to support this frontend.
-- 
2.6.3

