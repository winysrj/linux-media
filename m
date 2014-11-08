Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33363 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaKHIr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Nov 2014 03:47:59 -0500
Received: by mail-pd0-f170.google.com with SMTP id z10so4748594pdj.15
        for <linux-media@vger.kernel.org>; Sat, 08 Nov 2014 00:47:59 -0800 (PST)
Date: Sat, 8 Nov 2014 16:47:57 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Olli Salonen" <olli.salonen@iki.fi>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Antti Palosaari" <crope@iki.fi>
Subject: [PATCH 2/2] smipcie: add DVBSky T9580 V3 support
Message-ID: <201411081647541566078@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky T9580 V3 card is the dual tuner card, which supports S/S2 and T2/T/C.
1>DVB-S/S2 frontend: M88DS3103/M88TS2022
2>DVB-T2/T/C frontend: SI2168B40/SI2157A30
2>PCIe bridge: SMI PCIe

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/smipcie/smipcie.c | 67 +++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index c27e45b..a5707ea 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -18,6 +18,8 @@
 #include "m88ds3103.h"
 #include "m88ts2022.h"
 #include "m88rs6000t.h"
+#include "si2168.h"
+#include "si2157.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -618,6 +620,58 @@ err_tuner_i2c_device:
 	return ret;
 }
 
+static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
+{
+	int ret = 0;
+	struct smi_dev *dev = port->dev;
+	struct i2c_adapter *i2c;
+	struct i2c_adapter *tuner_i2c_adapter;
+	struct i2c_client *client_tuner, *client_demod;
+	struct i2c_board_info client_info;
+	struct si2168_config si2168_config;
+	struct si2157_config si2157_config;
+
+	/* select i2c bus */
+	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
+
+	/* attach demod */
+	memset(&si2168_config, 0, sizeof(si2168_config));
+	si2168_config.i2c_adapter = &tuner_i2c_adapter;
+	si2168_config.fe = &port->fe;
+	si2168_config.ts_mode = SI2168_TS_PARALLEL;
+
+	memset(&client_info, 0, sizeof(struct i2c_board_info));
+	strlcpy(client_info.type, "si2168", I2C_NAME_SIZE);
+	client_info.addr = 0x64;
+	client_info.platform_data = &si2168_config;
+
+	client_demod = smi_add_i2c_client(i2c, &client_info);
+	if (!client_demod) {
+		ret = -ENODEV;
+		return ret;
+	}
+	port->i2c_client_demod = client_demod;
+
+	/* attach tuner */
+	memset(&si2157_config, 0, sizeof(si2157_config));
+	si2157_config.fe = port->fe;
+
+	memset(&client_info, 0, sizeof(struct i2c_board_info));
+	strlcpy(client_info.type, "si2157", I2C_NAME_SIZE);
+	client_info.addr = 0x60;
+	client_info.platform_data = &si2157_config;
+
+	client_tuner = smi_add_i2c_client(tuner_i2c_adapter, &client_info);
+	if (!client_tuner) {
+		smi_del_i2c_client(port->i2c_client_demod);
+		port->i2c_client_demod = NULL;
+		ret = -ENODEV;
+		return ret;
+	}
+	port->i2c_client_tuner = client_tuner;
+	return ret;
+}
+
 static int smi_fe_init(struct smi_port *port)
 {
 	int ret = 0;
@@ -635,6 +689,9 @@ static int smi_fe_init(struct smi_port *port)
 	case DVBSKY_FE_M88RS6000:
 		ret = smi_dvbsky_m88rs6000_fe_attach(port);
 		break;
+	case DVBSKY_FE_SIT2:
+		ret = smi_dvbsky_sit2_fe_attach(port);
+		break;
 	}
 	if (ret < 0)
 		return ret;
@@ -1005,6 +1062,15 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
 	.fe_1 = DVBSKY_FE_M88RS6000,
 };
 
+static struct smi_cfg_info dvbsky_t9580_cfg = {
+	.type = SMI_DVBSKY_S952,
+	.name = "DVBSky T9580 V3",
+	.ts_0 = SMI_TS_DMA_BOTH,
+	.ts_1 = SMI_TS_DMA_BOTH,
+	.fe_0 = DVBSKY_FE_SIT2,
+	.fe_1 = DVBSKY_FE_M88DS3103,
+};
+
 /* PCI IDs */
 #define SMI_ID(_subvend, _subdev, _driverdata) {	\
 	.vendor      = SMI_VID,    .device    = SMI_PID, \
@@ -1014,6 +1080,7 @@ static struct smi_cfg_info dvbsky_s952_cfg = {
 static const struct pci_device_id smi_id_table[] = {
 	SMI_ID(0x4254, 0x0550, dvbsky_s950_cfg),
 	SMI_ID(0x4254, 0x0552, dvbsky_s952_cfg),
+	SMI_ID(0x4254, 0x5580, dvbsky_t9580_cfg),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, smi_id_table);
 
-- 
1.9.1

