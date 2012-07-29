Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.19]:36511 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab2G2Uu7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Jul 2012 16:50:59 -0400
Message-ID: <5015A230.4020502@sfr.fr>
Date: Sun, 29 Jul 2012 22:50:56 +0200
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, o.endriss@gmx.de,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Patrice Chotard <patrice.chotard@sfr.fr>
Subject: [PATCH 2/2] [media] ngene: add support for Terratec Cynergy 2400i,
 Dual DVB-T
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[media] ngene: add support for Terratec Cynergy 2400i
 Dual DVB-T

This code is based on ngene initial check-in
(dae52d009fc950b5c209260d50fcc000f5becd3c)

Signed-off-by: Patrice Chotard <patricechotard@free.fr>
---
 drivers/media/dvb/ngene/ngene-cards.c |  263
+++++++++++++++++++++++++++++++++
 1 files changed, 263 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c
b/drivers/media/dvb/ngene/ngene-cards.c
index 7539a5d..08c610f 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -42,6 +42,8 @@
 #include "mt2131.h"
 #include "tda18271c2dd.h"
 #include "drxk.h"
+#include "drxd.h"
+#include "dvb-pll.h"


 /****************************************************************************/
@@ -312,6 +314,235 @@ static int demod_attach_lg330x(struct
ngene_channel *chan)
 	return (chan->fe) ? 0 : -ENODEV;
 }

+static int demod_attach_drxd(struct ngene_channel *chan)
+{
+	struct drxd_config *feconf;
+
+	feconf = chan->dev->card_info->fe_config[chan->number];
+
+	chan->fe = dvb_attach(drxd_attach, feconf, chan,
+			&chan->i2c_adapter, &chan->dev->pci_dev->dev);
+	if (!chan->fe) {
+		pr_err("No DRXD found!\n");
+		return -ENODEV;
+	}
+
+	if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
+			&chan->i2c_adapter,
+			feconf->pll_type)) {
+		pr_err("No pll(%d) found!\n", feconf->pll_type);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+/****************************************************************************/
+/* EEPROM TAGS
**************************************************************/
+/****************************************************************************/
+
+#define MICNG_EE_START      0x0100
+#define MICNG_EE_END        0x0FF0
+
+#define MICNG_EETAG_END0    0x0000
+#define MICNG_EETAG_END1    0xFFFF
+
+/* 0x0001 - 0x000F reserved for housekeeping */
+/* 0xFFFF - 0xFFFE reserved for housekeeping */
+
+/* Micronas assigned tags
+   EEProm tags for hardware support */
+
+#define MICNG_EETAG_DRXD1_OSCDEVIATION  0x1000  /* 2 Bytes data */
+#define MICNG_EETAG_DRXD2_OSCDEVIATION  0x1001  /* 2 Bytes data */
+
+#define MICNG_EETAG_MT2060_1_1STIF      0x1100  /* 2 Bytes data */
+#define MICNG_EETAG_MT2060_2_1STIF      0x1101  /* 2 Bytes data */
+
+/* Tag range for OEMs */
+
+#define MICNG_EETAG_OEM_FIRST  0xC000
+#define MICNG_EETAG_OEM_LAST   0xFFEF
+
+static int i2c_write_eeprom(struct i2c_adapter *adapter,
+			    u8 adr, u16 reg, u8 data)
+{
+	u8 m[3] = {(reg >> 8), (reg & 0xff), data};
+	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = m,
+			      .len = sizeof(m)};
+
+	if (i2c_transfer(adapter, &msg, 1) != 1) {
+		pr_err(DEVICE_NAME ": Error writing EEPROM!\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+static int i2c_read_eeprom(struct i2c_adapter *adapter,
+			   u8 adr, u16 reg, u8 *data, int len)
+{
+	u8 msg[2] = {(reg >> 8), (reg & 0xff)};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf = msg, .len = 2 },
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf = data, .len = len} };
+
+	if (i2c_transfer(adapter, msgs, 2) != 2) {
+		pr_err(DEVICE_NAME ": Error reading EEPROM\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+static int ReadEEProm(struct i2c_adapter *adapter,
+		      u16 Tag, u32 MaxLen, u8 *data, u32 *pLength)
+{
+	int status = 0;
+	u16 Addr = MICNG_EE_START, Length, tag = 0;
+	u8  EETag[3];
+
+	while (Addr + sizeof(u16) + 1 < MICNG_EE_END) {
+		if (i2c_read_eeprom(adapter, 0x50, Addr, EETag, sizeof(EETag)))
+			return -1;
+		tag = (EETag[0] << 8) | EETag[1];
+		if (tag == MICNG_EETAG_END0 || tag == MICNG_EETAG_END1)
+			return -1;
+		if (tag == Tag)
+			break;
+		Addr += sizeof(u16) + 1 + EETag[2];
+	}
+	if (Addr + sizeof(u16) + 1 + EETag[2] > MICNG_EE_END) {
+		pr_err(DEVICE_NAME
+		       ": Reached EOEE @ Tag = %04x Length = %3d\n",
+		       tag, EETag[2]);
+		return -1;
+	}
+	Length = EETag[2];
+	if (Length > MaxLen)
+		Length = (u16) MaxLen;
+	if (Length > 0) {
+		Addr += sizeof(u16) + 1;
+		status = i2c_read_eeprom(adapter, 0x50, Addr, data, Length);
+		if (!status) {
+			*pLength = EETag[2];
+			if (Length < EETag[2])
+				; /*status=STATUS_BUFFER_OVERFLOW; */
+		}
+	}
+	return status;
+}
+
+static int WriteEEProm(struct i2c_adapter *adapter,
+		       u16 Tag, u32 Length, u8 *data)
+{
+	int status = 0;
+	u16 Addr = MICNG_EE_START;
+	u8 EETag[3];
+	u16 tag = 0;
+	int retry, i;
+
+	while (Addr + sizeof(u16) + 1 < MICNG_EE_END) {
+		if (i2c_read_eeprom(adapter, 0x50, Addr, EETag, sizeof(EETag)))
+			return -1;
+		tag = (EETag[0] << 8) | EETag[1];
+		if (tag == MICNG_EETAG_END0 || tag == MICNG_EETAG_END1)
+			return -1;
+		if (tag == Tag)
+			break;
+		Addr += sizeof(u16) + 1 + EETag[2];
+	}
+	if (Addr + sizeof(u16) + 1 + EETag[2] > MICNG_EE_END) {
+		pr_err(DEVICE_NAME
+		       ": Reached EOEE @ Tag = %04x Length = %3d\n",
+		       tag, EETag[2]);
+		return -1;
+	}
+
+	if (Length > EETag[2])
+		return -EINVAL;
+	/* Note: We write the data one byte at a time to avoid
+	   issues with page sizes. (which are different for
+	   each manufacture and eeprom size)
+	 */
+	Addr += sizeof(u16) + 1;
+	for (i = 0; i < Length; i++, Addr++) {
+		status = i2c_write_eeprom(adapter, 0x50, Addr, data[i]);
+
+		if (status)
+			break;
+
+		/* Poll for finishing write cycle */
+		retry = 10;
+		while (retry) {
+			u8 Tmp;
+
+			msleep(50);
+			status = i2c_read_eeprom(adapter, 0x50, Addr, &Tmp, 1);
+			if (status)
+				break;
+			if (Tmp != data[i])
+				pr_err(DEVICE_NAME
+				       "eeprom write error\n");
+			retry -= 1;
+		}
+		if (status) {
+			pr_err(DEVICE_NAME
+			       ": Timeout polling eeprom\n");
+			break;
+		}
+	}
+	return status;
+}
+
+static int eeprom_read_ushort(struct i2c_adapter *adapter, u16 tag, u16
*data)
+{
+	int stat;
+	u8 buf[2];
+	u32 len = 0;
+
+	stat = ReadEEProm(adapter, tag, 2, buf, &len);
+	if (stat)
+		return stat;
+	if (len != 2)
+		return -EINVAL;
+
+	*data = (buf[0] << 8) | buf[1];
+	return 0;
+}
+
+static int eeprom_write_ushort(struct i2c_adapter *adapter, u16 tag,
u16 data)
+{
+	int stat;
+	u8 buf[2];
+
+	buf[0] = data >> 8;
+	buf[1] = data & 0xff;
+	stat = WriteEEProm(adapter, tag, 2, buf);
+	if (stat)
+		return stat;
+	return 0;
+}
+
+static s16 osc_deviation(void *priv, s16 deviation, int flag)
+{
+	struct ngene_channel *chan = priv;
+	struct i2c_adapter *adap = &chan->i2c_adapter;
+	u16 data = 0;
+
+	if (flag) {
+		data = (u16) deviation;
+		pr_info(DEVICE_NAME ": write deviation %d\n",
+		       deviation);
+		eeprom_write_ushort(adap, 0x1000 + chan->number, data);
+	} else {
+		if (eeprom_read_ushort(adap, 0x1000 + chan->number, &data))
+			data = 0;
+		pr_info(DEVICE_NAME ": read deviation %d\n",
+		       (s16) data);
+	}
+
+	return (s16) data;
+}
+
 /****************************************************************************/
 /* Switch control (I2C gates, etc.)
*****************************************/
 /****************************************************************************/
@@ -463,6 +694,37 @@ static struct ngene_info ngene_info_m780 = {
 	.fw_version	= 15,
 };

+static struct drxd_config fe_terratec_dvbt_0 = {
+	.index          = 0,
+	.demod_address  = 0x70,
+	.demod_revision = 0xa2,
+	.demoda_address = 0x00,
+	.pll_address    = 0x60,
+	.pll_type       = DVB_PLL_THOMSON_DTT7520X,
+	.clock          = 20000,
+	.osc_deviation  = osc_deviation,
+};
+
+static struct drxd_config fe_terratec_dvbt_1 = {
+	.index          = 1,
+	.demod_address  = 0x71,
+	.demod_revision = 0xa2,
+	.demoda_address = 0x00,
+	.pll_address    = 0x60,
+	.pll_type       = DVB_PLL_THOMSON_DTT7520X,
+	.clock          = 20000,
+	.osc_deviation  = osc_deviation,
+};
+
+static struct ngene_info ngene_info_terratec = {
+	.type           = NGENE_TERRATEC,
+	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
+	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
+	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
+	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
+	.i2c_access     = 1,
+};
+
 /****************************************************************************/


@@ -487,6 +749,7 @@ static const struct pci_device_id ngene_id_tbl[]
__devinitdata = {
 	NGENE_ID(0x18c3, 0xdd10, ngene_info_duoFlex),
 	NGENE_ID(0x18c3, 0xdd20, ngene_info_duoFlex),
 	NGENE_ID(0x1461, 0x062e, ngene_info_m780),
+	NGENE_ID(0x153b, 0x1167, ngene_info_terratec),
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, ngene_id_tbl);
