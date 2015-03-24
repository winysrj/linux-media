Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44465 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbbCXVNJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Mar 2015 17:13:09 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Nibble Max <nibble.max@gmail.com>
Subject: [PATCH 5/8] smipcie: switch ts2022 to ts2020 driver
Date: Tue, 24 Mar 2015 23:12:10 +0200
Message-Id: <1427231533-4277-6-git-send-email-crope@iki.fi>
In-Reply-To: <1427231533-4277-1-git-send-email-crope@iki.fi>
References: <1427231533-4277-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change ts2022 driver to ts2020 driver. ts2020 driver supports
both tuner chip models.

Cc: Nibble Max <nibble.max@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/pci/smipcie/Kconfig   |  2 +-
 drivers/media/pci/smipcie/smipcie.c | 12 +++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
index c8de53f..21a1583 100644
--- a/drivers/media/pci/smipcie/Kconfig
+++ b/drivers/media/pci/smipcie/Kconfig
@@ -4,7 +4,7 @@ config DVB_SMIPCIE
 	select I2C_ALGOBIT
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_SI2168 if MEDIA_SUBDRV_AUTOSELECT
-	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_TS2020 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_SI2157 if MEDIA_SUBDRV_AUTOSELECT
 	help
diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index 36c8ed7..4115925 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -16,7 +16,7 @@
 
 #include "smipcie.h"
 #include "m88ds3103.h"
-#include "m88ts2022.h"
+#include "ts2020.h"
 #include "m88rs6000t.h"
 #include "si2168.h"
 #include "si2157.h"
@@ -532,9 +532,7 @@ static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
 	struct i2c_adapter *tuner_i2c_adapter;
 	struct i2c_client *tuner_client;
 	struct i2c_board_info tuner_info;
-	struct m88ts2022_config m88ts2022_config = {
-		.clock = 27000000,
-	};
+	struct ts2020_config ts2020_config = {};
 	memset(&tuner_info, 0, sizeof(struct i2c_board_info));
 	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
 
@@ -546,10 +544,10 @@ static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
 		return ret;
 	}
 	/* attach tuner */
-	m88ts2022_config.fe = port->fe;
-	strlcpy(tuner_info.type, "m88ts2022", I2C_NAME_SIZE);
+	ts2020_config.fe = port->fe;
+	strlcpy(tuner_info.type, "ts2020", I2C_NAME_SIZE);
 	tuner_info.addr = 0x60;
-	tuner_info.platform_data = &m88ts2022_config;
+	tuner_info.platform_data = &ts2020_config;
 	tuner_client = smi_add_i2c_client(tuner_i2c_adapter, &tuner_info);
 	if (!tuner_client) {
 		ret = -ENODEV;
-- 
http://palosaari.fi/

