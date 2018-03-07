Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:52844 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754697AbeCGTX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 14:23:57 -0500
Received: by mail-wm0-f66.google.com with SMTP id t3so6929963wmc.2
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 11:23:56 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Olli Salonen <olli.salonen@iki.fi>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/4] [media] dvb-frontends/Kconfig: move the SP2 driver to the CI section
Date: Wed,  7 Mar 2018 20:23:48 +0100
Message-Id: <20180307192350.930-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180307192350.930-1-d.scheller.oss@gmail.com>
References: <20180307192350.930-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The CIMaX SP2 driver is a EN50221 CI controller I2C driver similar to the
cxd2099 driver. Move it's Kconfig block into the newly introduced CI
subsection.

Cc: Olli Salonen <olli.salonen@iki.fi>
Cc: Antti Palosaari <crope@iki.fi>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index fcfa1135557e..687086cdb870 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -824,13 +824,6 @@ config DVB_A8293
 	depends on DVB_CORE && I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 
-config DVB_SP2
-	tristate "CIMaX SP2"
-	depends on DVB_CORE && I2C
-	default m if !MEDIA_SUBDRV_AUTOSELECT
-	help
-	  CIMaX SP2/SP2HF Common Interface module.
-
 config DVB_LGS8GL5
 	tristate "Silicon Legend LGS-8GL5 demodulator (OFDM)"
 	depends on DVB_CORE && I2C
@@ -920,6 +913,13 @@ config DVB_CXD2099
 
 	  Say Y when you want to support these devices.
 
+config DVB_SP2
+	tristate "CIMaX SP2"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  CIMaX SP2/SP2HF Common Interface module.
+
 comment "Tools to develop new frontends"
 
 config DVB_DUMMY_FE
-- 
2.16.1
