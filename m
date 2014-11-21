Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33718 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaKURwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 12:52:17 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so12754378wiv.11
        for <linux-media@vger.kernel.org>; Fri, 21 Nov 2014 09:52:13 -0800 (PST)
From: Andreas Ruprecht <rupran@einserver.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, sfr@canb.auug.org.au,
	Andreas Ruprecht <rupran@einserver.de>
Subject: [PATCH] media: pci: smipcie: Fix dependency for DVB_SMIPCIE
Date: Fri, 21 Nov 2014 18:51:59 +0100
Message-Id: <1416592319-23644-1-git-send-email-rupran@einserver.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In smipcie.c, the function i2c_bit_add_bus() is called. This
function is defined by the I2C bit-banging interfaces enabled
with CONFIG_I2C_ALGOBIT.

As there was no dependency in Kconfig, CONFIG_I2C_ALGOBIT could
be set to "m" while CONFIG_DVB_SMIPCIE was set to "y", resulting
in a build error due to an undefined reference. This patch adds
the dependency on CONFIG_I2C_ALGOBIT in Kconfig.

Signed-off-by: Andreas Ruprecht <rupran@einserver.de>
Reported-by: Jim Davis <jim.epost@gmail.com>
---
 drivers/media/pci/smipcie/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
index 75a2992..c728721 100644
--- a/drivers/media/pci/smipcie/Kconfig
+++ b/drivers/media/pci/smipcie/Kconfig
@@ -1,6 +1,6 @@
 config DVB_SMIPCIE
 	tristate "SMI PCIe DVBSky cards"
-	depends on DVB_CORE && PCI && I2C
+	depends on DVB_CORE && PCI && I2C && I2C_ALGOBIT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
-- 
1.9.1

