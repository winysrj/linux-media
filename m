Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:50133 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400AbaKDOqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Nov 2014 09:46:03 -0500
Received: by mail-pd0-f172.google.com with SMTP id r10so13781243pdi.17
        for <linux-media@vger.kernel.org>; Tue, 04 Nov 2014 06:46:02 -0800 (PST)
Date: Tue, 4 Nov 2014 22:45:58 +0800
From: "Nibble Max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>
Cc: "linux-media" <linux-media@vger.kernel.org>,
	"Olli Salonen" <olli.salonen@iki.fi>,
	"Antti Palosaari" <crope@iki.fi>,
	"Nibble Max" <nibble.max@gmail.com>
Subject: [PATCH 1/1] smipcie: add DVBSky S952 V3 support
Message-ID: <201411042245526090717@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVBSky S952 V3 card has a dual channels of dvb-s/s2.
1>Frontend: Integrated tuner and demod: M88RS6000
2>PCIe bridge: SMI PCIe

Signed-off-by: Nibble Max <nibble.max@gmail.com>
---
 drivers/media/pci/smipcie/Kconfig   |  2 +
 drivers/media/pci/smipcie/smipcie.c | 78 +++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/media/pci/smipcie/Kconfig b/drivers/media/pci/smipcie/Kconfig
index 78b76ca..75a2992 100644
--- a/drivers/media/pci/smipcie/Kconfig
+++ b/drivers/media/pci/smipcie/Kconfig
@@ -3,9 +3,11 @@ config DVB_SMIPCIE
 	depends on DVB_CORE && PCI && I2C
 	select DVB_M88DS3103 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_M88TS2022 if MEDIA_SUBDRV_AUTOSELECT
+	select MEDIA_TUNER_M88RS6000T if MEDIA_SUBDRV_AUTOSELECT
 	help
 	  Support for cards with SMI PCIe bridge:
 	  - DVBSky S950 V3
+	  - DVBSky S952 V3
 
 	  Say Y or M if you own such a device and want to use it.
 	  If unsure say N.
diff --git a/drivers/media/pci/smipcie/smipcie.c b/drivers/media/pci/smipcie/smipcie.c
index 6ad6cc5..d1c1463 100644
--- a/drivers/media/pci/smipcie/smipcie.c
+++ b/drivers/media/pci/smipcie/smipcie.c
@@ -17,6 +17,7 @@
 #include "smipcie.h"
 #include "m88ds3103.h"
 #include "m88ts2022.h"
+#include "m88rs6000t.h"
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
@@ -542,6 +543,70 @@ err_tuner_i2c_device:
 	return ret;
 }
 
+static const struct m88ds3103_config smi_dvbsky_m88rs6000_cfg = {
+	.i2c_addr = 0x69,
+	.clock = 27000000,
+	.i2c_wr_max = 33,
+	.ts_mode = M88DS3103_TS_PARALLEL,
+	.ts_clk = 16000,
+	.ts_clk_pol = 1,
+	.agc = 0x99,
+	.lnb_hv_pol = 0,
+	.lnb_en_pol = 1,
+};
+
+static int smi_dvbsky_m88rs6000_fe_attach(struct smi_port *port)
+{
+	int ret = 0;
+	struct smi_dev *dev = port->dev;
+	struct i2c_adapter *i2c;
+	/* tuner I2C module */
+	struct i2c_adapter *tuner_i2c_adapter;
+	struct i2c_client *tuner_client;
+	struct i2c_board_info tuner_info;
+	struct m88rs6000t_config m88rs6000t_config;
+
+	memset(&tuner_info, 0, sizeof(struct i2c_board_info));
+	i2c = (port->idx == 0) ? &dev->i2c_bus[0] : &dev->i2c_bus[1];
+
+	/* attach demod */
+	port->fe = dvb_attach(m88ds3103_attach,
+			&smi_dvbsky_m88rs6000_cfg, i2c, &tuner_i2c_adapter);
+	if (!port->fe) {
+		ret = -ENODEV;
+		return ret;
+	}
+	/* attach tuner */
+	m88rs6000t_config.fe = port->fe;
+	strlcpy(tuner_info.type, "m88rs6000t", I2C_NAME_SIZE);
+	tuner_info.addr = 0x21;
+	tuner_info.platform_data = &m88rs6000t_config;
+	request_module("m88rs6000t");
+	tuner_client = i2c_new_device(tuner_i2c_adapter, &tuner_info);
+	if (tuner_client == NULL || tuner_client->dev.driver == NULL) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_device;
+	}
+
+	if (!try_module_get(tuner_client->dev.driver->owner)) {
+		ret = -ENODEV;
+		goto err_tuner_i2c_module;
+	}
+
+	/* delegate signal strength measurement to tuner */
+	port->fe->ops.read_signal_strength =
+			port->fe->ops.tuner_ops.get_rf_strength;
+
+	port->i2c_client_tuner = tuner_client;
+	return ret;
+
+err_tuner_i2c_module:
+	i2c_unregister_device(tuner_client);
+err_tuner_i2c_device:
+	dvb_frontend_detach(port->fe);
+	return ret;
+}
+
 static int smi_fe_init(struct smi_port *port)
 {
 	int ret = 0;
@@ -556,6 +621,9 @@ static int smi_fe_init(struct smi_port *port)
 	case DVBSKY_FE_M88DS3103:
 		ret = smi_dvbsky_m88ds3103_fe_attach(port);
 		break;
+	case DVBSKY_FE_M88RS6000:
+		ret = smi_dvbsky_m88rs6000_fe_attach(port);
+		break;
 	}
 	if (ret < 0)
 		return ret;
@@ -917,6 +985,15 @@ static struct smi_cfg_info dvbsky_s950_cfg = {
 	.fe_1 = DVBSKY_FE_M88DS3103,
 };
 
+static struct smi_cfg_info dvbsky_s952_cfg = {
+	.type = SMI_DVBSKY_S952,
+	.name = "DVBSky S952 V3",
+	.ts_0 = SMI_TS_DMA_BOTH,
+	.ts_1 = SMI_TS_DMA_BOTH,
+	.fe_0 = DVBSKY_FE_M88RS6000,
+	.fe_1 = DVBSKY_FE_M88RS6000,
+};
+
 /* PCI IDs */
 #define SMI_ID(_subvend, _subdev, _driverdata) {	\
 	.vendor      = SMI_VID,    .device    = SMI_PID, \
@@ -925,6 +1002,7 @@ static struct smi_cfg_info dvbsky_s950_cfg = {
 
 static const struct pci_device_id smi_id_table[] = {
 	SMI_ID(0x4254, 0x0550, dvbsky_s950_cfg),
+	SMI_ID(0x4254, 0x0552, dvbsky_s952_cfg),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, smi_id_table);

-- 
1.9.1

