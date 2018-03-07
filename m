Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38392 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754696AbeCGTX4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 14:23:56 -0500
Received: by mail-wm0-f66.google.com with SMTP id z9so6789138wmb.3
        for <linux-media@vger.kernel.org>; Wed, 07 Mar 2018 11:23:55 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: Jasmin Jessich <jasmin@anw.at>
Subject: [PATCH 1/4] [media] dvb-frontends/cxd2099: Kconfig additions
Date: Wed,  7 Mar 2018 20:23:47 +0100
Message-Id: <20180307192350.930-2-d.scheller.oss@gmail.com>
In-Reply-To: <20180307192350.930-1-d.scheller.oss@gmail.com>
References: <20180307192350.930-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The cxd2099 driver makes use of the Regmap I2C kernel API, thus add
"select REGMAP_I2C" to it's Kconfig block. Also, make it default "m" if
!MEDIA_SUBDRV_AUTOSELECT, just like every other dvb-frontend driver.
And, while at it, remove the hyphens around the help tag.

Cc: Jasmin Jessich <jasmin@anw.at>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 2ad81907c714..fcfa1135557e 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -912,7 +912,9 @@ comment "Common Interface (EN50221) controller drivers"
 config DVB_CXD2099
 	tristate "CXD2099AR Common Interface driver"
 	depends on DVB_CORE && I2C
-	---help---
+	select REGMAP_I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
 	  A driver for the CI controller currently found mostly on
 	  Digital Devices DuoFlex CI (single) addon modules.
 
-- 
2.16.1
