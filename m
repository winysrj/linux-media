Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36744 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752659AbdGITmw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 15:42:52 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so20376325wrb.3
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 12:42:51 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: [PATCH 2/4] [media] ddbridge: support MaxLinear MXL5xx based cards (MaxS4/8)
Date: Sun,  9 Jul 2017 21:42:44 +0200
Message-Id: <20170709194246.10334-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170709194246.10334-1-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This enables MaxS4/S8 and Octopus Max card support in ddbridge by adding
glue code into ddbridge-core, having another PCI ID, and have the LNB IC
control code (and all other MaxS4/8 related code) in ddbridge-maxs8.c
(rather than another ~400 LoC in ddbridge-core.c like it's done in the
original vendor driver package).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Kconfig          |   2 +
 drivers/media/pci/ddbridge/Makefile         |   2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c  |  67 ++++-
 drivers/media/pci/ddbridge/ddbridge-hw.c    |  12 +
 drivers/media/pci/ddbridge/ddbridge-hw.h    |   4 +
 drivers/media/pci/ddbridge/ddbridge-main.c  |   1 +
 drivers/media/pci/ddbridge/ddbridge-maxs8.c | 443 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-maxs8.h |  29 ++
 drivers/media/pci/ddbridge/ddbridge-regs.h  |  21 ++
 drivers/media/pci/ddbridge/ddbridge.h       |  11 +
 10 files changed, 588 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-maxs8.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-maxs8.h

diff --git a/drivers/media/pci/ddbridge/Kconfig b/drivers/media/pci/ddbridge/Kconfig
index 1330b2ecc72a..f43d0b83fc0c 100644
--- a/drivers/media/pci/ddbridge/Kconfig
+++ b/drivers/media/pci/ddbridge/Kconfig
@@ -12,6 +12,7 @@ config DVB_DDBRIDGE
 	select DVB_STV6111 if MEDIA_SUBDRV_AUTOSELECT
 	select DVB_LNBH25 if MEDIA_SUBDRV_AUTOSELECT
 	select MEDIA_TUNER_TDA18212 if MEDIA_SUBDRV_AUTOSELECT
+	select DVB_MXL5XX if MEDIA_SUBDRV_AUTOSELECT
 	---help---
 	  Support for cards with the Digital Devices PCI express bridge:
 	  - Octopus PCIe Bridge
@@ -24,6 +25,7 @@ config DVB_DDBRIDGE
 	  - CineCTv7 and DuoFlex CT2/C2T2/C2T2I (Sony CXD28xx-based)
 	  - MaxA8 series
 	  - CineS2 V7/V7A and DuoFlex S2 V4 (ST STV0910-based)
+	  - Max S4/8
 
 	  Say Y if you own such a card and want to use it.
 
diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index c4d8d6261243..caf03a82f6b1 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -3,7 +3,7 @@
 #
 
 ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-hw.o \
-		ddbridge-i2c.o ddbridge-irq.o
+		ddbridge-i2c.o ddbridge-irq.o ddbridge-maxs8.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index ff87e0462c7e..81f07dc5eeea 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -36,6 +36,7 @@
 
 #include "ddbridge.h"
 #include "ddbridge-regs.h"
+#include "ddbridge-maxs8.h"
 #include "ddbridge-io.h"
 
 #include "tda18271c2dd.h"
@@ -1424,8 +1425,9 @@ static int dvb_input_attach(struct ddb_input *input)
 	dvb->fe = dvb->fe2 = NULL;
 	switch (port->type) {
 	case DDB_TUNER_MXL5XX:
-		dev_notice(port->dev->dev, "MaxLinear MxL5xx not supported\n");
-		return -ENODEV;
+		if (fe_attach_mxl5xx(input) < 0)
+			return -ENODEV;
+		break;
 	case DDB_TUNER_DVBS_ST:
 		if (demod_attach_stv0900(input, 0) < 0)
 			return -ENODEV;
@@ -1770,6 +1772,17 @@ static void ddb_port_probe(struct ddb_port *port)
 		return;
 	}
 
+	if (dev->link[l].info->type == DDB_OCTOPUS_MAX) {
+		port->name = "DUAL DVB-S2 MAX";
+		port->type_name = "MXL5XX";
+		port->class = DDB_PORT_TUNER;
+		port->type = DDB_TUNER_MXL5XX;
+		if (port->i2c)
+			ddbwritel(dev, I2C_SPEED_400,
+				  port->i2c->regs + I2C_TIMING);
+		return;
+	}
+
 	if (port->nr > 1 && dev->link[l].info->type == DDB_OCTOPUS_CI) {
 		port->name = "CI internal";
 		port->type_name = "INTERNAL";
@@ -2531,6 +2544,20 @@ static int ddb_port_match_i2c(struct ddb_port *port)
 	return 0;
 }
 
+static int ddb_port_match_link_i2c(struct ddb_port *port)
+{
+	struct ddb *dev = port->dev;
+	u32 i;
+
+	for (i = 0; i < dev->i2c_num; i++) {
+		if (dev->i2c[i].link == port->lnr) {
+			port->i2c = &dev->i2c[i];
+			return 1;
+		}
+	}
+	return 0;
+}
+
 void ddb_ports_init(struct ddb *dev)
 {
 	u32 i, l, p;
@@ -2555,7 +2582,11 @@ void ddb_ports_init(struct ddb *dev)
 			port->obr = ci_bitrate;
 			mutex_init(&port->i2c_gate_lock);
 
-			ddb_port_match_i2c(port);
+			if (!ddb_port_match_i2c(port)) {
+				if (info->type == DDB_OCTOPUS_MAX)
+					ddb_port_match_link_i2c(port);
+			}
+
 			ddb_port_probe(port);
 
 			port->dvb[0].adap = &dev->adap[2 * p];
@@ -2603,6 +2634,7 @@ void ddb_ports_init(struct ddb *dev)
 				ddb_input_init(port, 2 * i + 1, 1, 2 * i + 1);
 				ddb_output_init(port, i);
 				break;
+			case DDB_OCTOPUS_MAX:
 			case DDB_OCTOPUS_MAX_CT:
 				ddb_input_init(port, 2 * i, 0, 2 * p);
 				ddb_input_init(port, 2 * i + 1, 1, 2 * p + 1);
@@ -3346,6 +3378,15 @@ static ssize_t regmap_show(struct device *device,
 	return sprintf(buf, "0x%08X\n", dev->link[0].ids.regmapid);
 }
 
+static ssize_t fmode_show(struct device *device,
+			 struct device_attribute *attr, char *buf)
+{
+	int num = attr->attr.name[5] - 0x30;
+	struct ddb *dev = dev_get_drvdata(device);
+
+	return sprintf(buf, "%u\n", dev->link[num].lnb.fmode);
+}
+
 static ssize_t devid_show(struct device *device,
 			  struct device_attribute *attr, char *buf)
 {
@@ -3355,6 +3396,21 @@ static ssize_t devid_show(struct device *device,
 	return sprintf(buf, "%08x\n", dev->link[num].ids.devid);
 }
 
+static ssize_t fmode_store(struct device *device, struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct ddb *dev = dev_get_drvdata(device);
+	int num = attr->attr.name[5] - 0x30;
+	unsigned int val;
+
+	if (sscanf(buf, "%u\n", &val) != 1)
+		return -EINVAL;
+	if (val > 3)
+		return -EINVAL;
+	lnb_init_fmode(dev, &dev->link[num], val);
+	return count;
+}
+
 static struct device_attribute ddb_attrs[] = {
 	__ATTR_RO(version),
 	__ATTR_RO(ports),
@@ -3364,6 +3420,10 @@ static struct device_attribute ddb_attrs[] = {
 	__ATTR(gap1, 0664, gap_show, gap_store),
 	__ATTR(gap2, 0664, gap_show, gap_store),
 	__ATTR(gap3, 0664, gap_show, gap_store),
+	__ATTR(fmode0, 0664, fmode_show, fmode_store),
+	__ATTR(fmode1, 0664, fmode_show, fmode_store),
+	__ATTR(fmode2, 0664, fmode_show, fmode_store),
+	__ATTR(fmode3, 0664, fmode_show, fmode_store),
 	__ATTR_MRO(devid0, devid_show),
 	__ATTR_MRO(devid1, devid_show),
 	__ATTR_MRO(devid2, devid_show),
@@ -3653,6 +3713,7 @@ static int ddb_init_boards(struct ddb *dev)
 
 int ddb_init(struct ddb *dev)
 {
+	mutex_init(&dev->link[0].lnb.lock);
 	mutex_init(&dev->link[0].flash_mutex);
 	if (no_init) {
 		ddb_device_create(dev);
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.c b/drivers/media/pci/ddbridge/ddbridge-hw.c
index e35b41e8d860..317dc865e99c 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.c
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.c
@@ -297,3 +297,15 @@ const struct ddb_info ddb_c2t2i_8 = {
 	.ts_quirks = TS_QUIRK_SERIAL,
 	.tempmon_irq = 24,
 };
+
+/****************************************************************************/
+
+const struct ddb_info ddb_s2_48 = {
+	.type     = DDB_OCTOPUS_MAX,
+	.name     = "Digital Devices MAX S8 4/8",
+	.regmap   = &octopus_map,
+	.port_num = 4,
+	.i2c_mask = 0x01,
+	.board_control = 1,
+	.tempmon_irq = 24,
+};
diff --git a/drivers/media/pci/ddbridge/ddbridge-hw.h b/drivers/media/pci/ddbridge/ddbridge-hw.h
index bd52c083c4a5..d26cd9c977d8 100644
--- a/drivers/media/pci/ddbridge/ddbridge-hw.h
+++ b/drivers/media/pci/ddbridge/ddbridge-hw.h
@@ -49,4 +49,8 @@ extern const struct ddb_info ddb_isdbt_8;
 extern const struct ddb_info ddb_c2t2i_v0_8;
 extern const struct ddb_info ddb_c2t2i_8;
 
+/****************************************************************************/
+
+extern const struct ddb_info ddb_s2_48;
+
 #endif /* _DDBRIDGE_HW_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-main.c b/drivers/media/pci/ddbridge/ddbridge-main.c
index 83643bc21d09..4bb238ba6339 100644
--- a/drivers/media/pci/ddbridge/ddbridge-main.c
+++ b/drivers/media/pci/ddbridge/ddbridge-main.c
@@ -312,6 +312,7 @@ static const struct pci_device_id ddb_id_table[] = {
 	DDB_DEVICE(0x0006, 0x0031, ddb_ctv7),
 	DDB_DEVICE(0x0006, 0x0032, ddb_ctv7),
 	DDB_DEVICE(0x0006, 0x0033, ddb_ctv7),
+	DDB_DEVICE(0x0007, 0x0023, ddb_s2_48),
 	DDB_DEVICE(0x0008, 0x0034, ddb_ct2_8),
 	DDB_DEVICE(0x0008, 0x0035, ddb_c2t2_8),
 	DDB_DEVICE(0x0008, 0x0036, ddb_isdbt_8),
diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.c b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
new file mode 100644
index 000000000000..a9dc5f9754da
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-maxs8.c
@@ -0,0 +1,443 @@
+/*
+ * ddbridge-maxs8.c: Digital Devices bridge MaxS4/8 support
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/poll.h>
+#include <linux/io.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/timer.h>
+#include <linux/i2c.h>
+#include <linux/swab.h>
+#include <linux/vmalloc.h>
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+#include "ddbridge-io.h"
+
+#include "ddbridge-maxs8.h"
+#include "mxl5xx.h"
+
+/******************************************************************************/
+
+/* MaxS4/8 related modparams */
+static int fmode;
+module_param(fmode, int, 0444);
+MODULE_PARM_DESC(fmode, "frontend emulation mode");
+
+static int fmode_sat = -1;
+module_param(fmode_sat, int, 0444);
+MODULE_PARM_DESC(fmode_sat, "set frontend emulation mode sat");
+
+static int old_quattro;
+module_param(old_quattro, int, 0444);
+MODULE_PARM_DESC(old_quattro, "old quattro LNB input order ");
+
+/******************************************************************************/
+
+static int lnb_command(struct ddb *dev, u32 link, u32 lnb, u32 cmd)
+{
+	u32 c, v = 0, tag = DDB_LINK_TAG(link);
+
+	v = LNB_TONE & (dev->link[link].lnb.tone << (15 - lnb));
+	ddbwritel(dev, cmd | v, tag | LNB_CONTROL(lnb));
+	for (c = 0; c < 10; c++) {
+		v = ddbreadl(dev, tag | LNB_CONTROL(lnb));
+		if ((v & LNB_BUSY) == 0)
+			break;
+		msleep(20);
+	}
+	if (c == 10)
+		dev_info(dev->dev, "%s lnb = %08x  cmd = %08x\n",
+			__func__, lnb, cmd);
+	return 0;
+}
+
+static int max_send_master_cmd(struct dvb_frontend *fe,
+			       struct dvb_diseqc_master_cmd *cmd)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	u32 tag = DDB_LINK_TAG(port->lnr);
+	int i;
+	u32 fmode = dev->link[port->lnr].lnb.fmode;
+
+	if (fmode == 2 || fmode == 1)
+		return 0;
+	if (dvb->diseqc_send_master_cmd)
+		dvb->diseqc_send_master_cmd(fe, cmd);
+
+	mutex_lock(&dev->link[port->lnr].lnb.lock);
+	ddbwritel(dev, 0, tag | LNB_BUF_LEVEL(dvb->input));
+	for (i = 0; i < cmd->msg_len; i++)
+		ddbwritel(dev, cmd->msg[i], tag | LNB_BUF_WRITE(dvb->input));
+	lnb_command(dev, port->lnr, dvb->input, LNB_CMD_DISEQC);
+	mutex_unlock(&dev->link[port->lnr].lnb.lock);
+	return 0;
+}
+
+static int lnb_send_diseqc(struct ddb *dev, u32 link, u32 input,
+			   struct dvb_diseqc_master_cmd *cmd)
+{
+	u32 tag = DDB_LINK_TAG(link);
+	int i;
+
+	ddbwritel(dev, 0, tag | LNB_BUF_LEVEL(input));
+	for (i = 0; i < cmd->msg_len; i++)
+		ddbwritel(dev, cmd->msg[i], tag | LNB_BUF_WRITE(input));
+	lnb_command(dev, link, input, LNB_CMD_DISEQC);
+	return 0;
+}
+
+static int lnb_set_sat(struct ddb *dev, u32 link, u32 input, u32 sat, u32 band,
+		       u32 hor)
+{
+	struct dvb_diseqc_master_cmd cmd = {
+		.msg = {0xe0, 0x10, 0x38, 0xf0, 0x00, 0x00},
+		.msg_len = 4
+	};
+	cmd.msg[3] = 0xf0 | (((sat << 2) & 0x0c) | (band ? 1 : 0) |
+		(hor ? 2 : 0));
+	return lnb_send_diseqc(dev, link, input, &cmd);
+}
+
+static int lnb_set_tone(struct ddb *dev, u32 link, u32 input,
+	enum fe_sec_tone_mode tone)
+{
+	int s = 0;
+	u32 mask = (1ULL << input);
+
+	switch (tone) {
+	case SEC_TONE_OFF:
+		if (!(dev->link[link].lnb.tone & mask))
+			return 0;
+		dev->link[link].lnb.tone &= ~(1ULL << input);
+		break;
+	case SEC_TONE_ON:
+		if (dev->link[link].lnb.tone & mask)
+			return 0;
+		dev->link[link].lnb.tone |= (1ULL << input);
+		break;
+	default:
+		s = -EINVAL;
+		break;
+	};
+	if (!s)
+		s = lnb_command(dev, link, input, LNB_CMD_NOP);
+	return s;
+}
+
+static int lnb_set_voltage(struct ddb *dev, u32 link, u32 input,
+	enum fe_sec_voltage voltage)
+{
+	int s = 0;
+
+	if (dev->link[link].lnb.oldvoltage[input] == voltage)
+		return 0;
+	switch (voltage) {
+	case SEC_VOLTAGE_OFF:
+		if (dev->link[link].lnb.voltage[input])
+			return 0;
+		lnb_command(dev, link, input, LNB_CMD_OFF);
+		break;
+	case SEC_VOLTAGE_13:
+		lnb_command(dev, link, input, LNB_CMD_LOW);
+		break;
+	case SEC_VOLTAGE_18:
+		lnb_command(dev, link, input, LNB_CMD_HIGH);
+		break;
+	default:
+		s = -EINVAL;
+		break;
+	};
+	dev->link[link].lnb.oldvoltage[input] = voltage;
+	return s;
+}
+
+static int max_set_input_unlocked(struct dvb_frontend *fe, int in)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int res = 0;
+
+	if (in > 3)
+		return -EINVAL;
+	if (dvb->input != in) {
+		u32 bit = (1ULL << input->nr);
+		u32 obit = dev->link[port->lnr].lnb.voltage[dvb->input] & bit;
+
+		dev->link[port->lnr].lnb.voltage[dvb->input] &= ~bit;
+		dvb->input = in;
+		dev->link[port->lnr].lnb.voltage[dvb->input] |= obit;
+	}
+	res = dvb->set_input(fe, in);
+	return res;
+}
+
+static int max_set_tone(struct dvb_frontend *fe, enum fe_sec_tone_mode tone)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int tuner = 0;
+	int res = 0;
+	u32 fmode = dev->link[port->lnr].lnb.fmode;
+
+	mutex_lock(&dev->link[port->lnr].lnb.lock);
+	dvb->tone = tone;
+	switch (fmode) {
+	default:
+	case 0:
+	case 3:
+		res = lnb_set_tone(dev, port->lnr, dvb->input, tone);
+		break;
+	case 1:
+	case 2:
+		if (old_quattro) {
+			if (dvb->tone == SEC_TONE_ON)
+				tuner |= 2;
+			if (dvb->voltage == SEC_VOLTAGE_18)
+				tuner |= 1;
+		} else {
+			if (dvb->tone == SEC_TONE_ON)
+				tuner |= 1;
+			if (dvb->voltage == SEC_VOLTAGE_18)
+				tuner |= 2;
+		}
+		res = max_set_input_unlocked(fe, tuner);
+		break;
+	}
+	mutex_unlock(&dev->link[port->lnr].lnb.lock);
+	return res;
+}
+
+static int max_set_voltage(struct dvb_frontend *fe, enum fe_sec_voltage voltage)
+{
+	struct ddb_input *input = fe->sec_priv;
+	struct ddb_port *port = input->port;
+	struct ddb *dev = port->dev;
+	struct ddb_dvb *dvb = &port->dvb[input->nr & 1];
+	int tuner = 0;
+	u32 nv, ov = dev->link[port->lnr].lnb.voltages;
+	int res = 0;
+	u32 fmode = dev->link[port->lnr].lnb.fmode;
+
+	mutex_lock(&dev->link[port->lnr].lnb.lock);
+	dvb->voltage = voltage;
+
+	switch (fmode) {
+	case 3:
+	default:
+	case 0:
+		if (fmode == 3)
+			max_set_input_unlocked(fe, 0);
+		if (voltage == SEC_VOLTAGE_OFF)
+			dev->link[port->lnr].lnb.voltage[dvb->input] &=
+				~(1ULL << input->nr);
+		else
+			dev->link[port->lnr].lnb.voltage[dvb->input] |=
+				(1ULL << input->nr);
+
+		res = lnb_set_voltage(dev, port->lnr, dvb->input, voltage);
+		break;
+	case 1:
+	case 2:
+		if (voltage == SEC_VOLTAGE_OFF)
+			dev->link[port->lnr].lnb.voltages &=
+				~(1ULL << input->nr);
+		else
+			dev->link[port->lnr].lnb.voltages |=
+				(1ULL << input->nr);
+
+		nv = dev->link[port->lnr].lnb.voltages;
+
+		if (old_quattro) {
+			if (dvb->tone == SEC_TONE_ON)
+				tuner |= 2;
+			if (dvb->voltage == SEC_VOLTAGE_18)
+				tuner |= 1;
+		} else {
+			if (dvb->tone == SEC_TONE_ON)
+				tuner |= 1;
+			if (dvb->voltage == SEC_VOLTAGE_18)
+				tuner |= 2;
+		}
+		res = max_set_input_unlocked(fe, tuner);
+
+		if (nv != ov) {
+			if (nv) {
+				lnb_set_voltage(dev,
+					port->lnr, 0, SEC_VOLTAGE_13);
+				if (fmode == 1) {
+					lnb_set_voltage(dev, port->lnr,
+						0, SEC_VOLTAGE_13);
+					if (old_quattro) {
+						lnb_set_voltage(dev, port->lnr,
+							1, SEC_VOLTAGE_18);
+						lnb_set_voltage(dev, port->lnr,
+							2, SEC_VOLTAGE_13);
+					} else {
+						lnb_set_voltage(dev, port->lnr,
+							1, SEC_VOLTAGE_13);
+						lnb_set_voltage(dev, port->lnr,
+							2, SEC_VOLTAGE_18);
+					}
+					lnb_set_voltage(dev, port->lnr,
+						3, SEC_VOLTAGE_18);
+				}
+			} else {
+				lnb_set_voltage(dev, port->lnr,
+					0, SEC_VOLTAGE_OFF);
+				if (fmode == 1) {
+					lnb_set_voltage(dev, port->lnr,
+						1, SEC_VOLTAGE_OFF);
+					lnb_set_voltage(dev, port->lnr,
+						2, SEC_VOLTAGE_OFF);
+					lnb_set_voltage(dev, port->lnr,
+						3, SEC_VOLTAGE_OFF);
+				}
+			}
+		}
+		break;
+	}
+	mutex_unlock(&dev->link[port->lnr].lnb.lock);
+	return res;
+}
+
+static int max_enable_high_lnb_voltage(struct dvb_frontend *fe, long arg)
+{
+
+	return 0;
+}
+
+static int max_send_burst(struct dvb_frontend *fe, enum fe_sec_mini_cmd burst)
+{
+	return 0;
+}
+
+static int mxl_fw_read(void *priv, u8 *buf, u32 len)
+{
+	struct ddb_link *link = priv;
+	struct ddb *dev = link->dev;
+
+	dev_info(dev->dev, "Read mxl_fw from link %u\n", link->nr);
+
+	return ddbridge_flashread(dev, link->nr, buf, 0xc0000, len);
+}
+
+int lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm)
+{
+	u32 l = link->nr;
+
+	if (link->lnb.fmode == fm)
+		return 0;
+	dev_info(dev->dev, "Set fmode link %u = %u\n", l, fm);
+	mutex_lock(&link->lnb.lock);
+	if (fm == 2 || fm == 1) {
+		if (fmode_sat >= 0) {
+			lnb_set_sat(dev, l, 0, fmode_sat, 0, 0);
+			if (old_quattro) {
+				lnb_set_sat(dev, l, 1, fmode_sat, 0, 1);
+				lnb_set_sat(dev, l, 2, fmode_sat, 1, 0);
+			} else {
+				lnb_set_sat(dev, l, 1, fmode_sat, 1, 0);
+				lnb_set_sat(dev, l, 2, fmode_sat, 0, 1);
+			}
+			lnb_set_sat(dev, l, 3, fmode_sat, 1, 1);
+		}
+		lnb_set_tone(dev, l, 0, SEC_TONE_OFF);
+		if (old_quattro) {
+			lnb_set_tone(dev, l, 1, SEC_TONE_OFF);
+			lnb_set_tone(dev, l, 2, SEC_TONE_ON);
+		} else {
+			lnb_set_tone(dev, l, 1, SEC_TONE_ON);
+			lnb_set_tone(dev, l, 2, SEC_TONE_OFF);
+		}
+		lnb_set_tone(dev, l, 3, SEC_TONE_ON);
+	}
+	link->lnb.fmode = fm;
+	mutex_unlock(&link->lnb.lock);
+	return 0;
+}
+
+static struct mxl5xx_cfg mxl5xx = {
+	.adr      = 0x60,
+	.type     = 0x01,
+	.clk      = 27000000,
+	.ts_clk   = 139,
+	.cap      = 12,
+	.fw_read  = mxl_fw_read,
+};
+
+int fe_attach_mxl5xx(struct ddb_input *input)
+{
+	struct ddb *dev = input->port->dev;
+	struct i2c_adapter *i2c = &input->port->i2c->adap;
+	struct ddb_dvb *dvb = &input->port->dvb[input->nr & 1];
+	struct ddb_port *port = input->port;
+	struct ddb_link *link = &dev->link[port->lnr];
+	struct mxl5xx_cfg cfg;
+	int demod, tuner;
+
+	cfg = mxl5xx;
+	cfg.fw_priv = link;
+	dvb->set_input = NULL;
+
+	demod = input->nr;
+	tuner = demod & 3;
+	if (fmode == 3)
+		tuner = 0;
+
+	dvb->fe = dvb_attach(mxl5xx_attach, i2c, &cfg,
+		demod, tuner, &dvb->set_input);
+
+	if (!dvb->fe) {
+		dev_err(dev->dev, "No MXL5XX found!\n");
+		return -ENODEV;
+	}
+
+	if (!dvb->set_input) {
+		dev_err(dev->dev, "No mxl5xx_set_input function pointer!\n");
+		return -ENODEV;
+	}
+
+	if (input->nr < 4) {
+		lnb_command(dev, port->lnr, input->nr, LNB_CMD_INIT);
+		lnb_set_voltage(dev, port->lnr, input->nr, SEC_VOLTAGE_OFF);
+	}
+	lnb_init_fmode(dev, link, fmode);
+
+	dvb->fe->ops.set_voltage = max_set_voltage;
+	dvb->fe->ops.enable_high_lnb_voltage = max_enable_high_lnb_voltage;
+	dvb->fe->ops.set_tone = max_set_tone;
+	dvb->diseqc_send_master_cmd = dvb->fe->ops.diseqc_send_master_cmd;
+	dvb->fe->ops.diseqc_send_master_cmd = max_send_master_cmd;
+	dvb->fe->ops.diseqc_send_burst = max_send_burst;
+	dvb->fe->sec_priv = input;
+	dvb->input = tuner;
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-maxs8.h b/drivers/media/pci/ddbridge/ddbridge-maxs8.h
new file mode 100644
index 000000000000..bb8884811a46
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-maxs8.h
@@ -0,0 +1,29 @@
+/*
+ * ddbridge-maxs8.h: Digital Devices bridge MaxS4/8 support
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 only, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _DDBRIDGE_MAXS8_H_
+#define _DDBRIDGE_MAXS8_H_
+
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+int lnb_init_fmode(struct ddb *dev, struct ddb_link *link, u32 fm);
+int fe_attach_mxl5xx(struct ddb_input *input);
+
+#endif /* _DDBRIDGE_MAXS8_H */
diff --git a/drivers/media/pci/ddbridge/ddbridge-regs.h b/drivers/media/pci/ddbridge/ddbridge-regs.h
index 73a40f847318..391e601ac78f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-regs.h
+++ b/drivers/media/pci/ddbridge/ddbridge-regs.h
@@ -133,3 +133,24 @@
 #define CI_BUFFER_SIZE                  (0x0800)
 
 #define CI_BUFFER(i)                  (CI_BUFFER_BASE + (i) * CI_BUFFER_SIZE)
+
+/* ------------------------------------------------------------------------- */
+/* LNB commands (mxl5xx / Max S8) */
+
+#define LNB_BASE			(0x400)
+#define LNB_CONTROL(i)			(LNB_BASE + (i) * 0x20 + 0x00)
+
+#define LNB_CMD				(7ULL <<  0)
+#define LNB_CMD_NOP			0
+#define LNB_CMD_INIT			1
+#define LNB_CMD_LOW			3
+#define LNB_CMD_HIGH			4
+#define LNB_CMD_OFF			5
+#define LNB_CMD_DISEQC			6
+
+#define LNB_BUSY			(1ULL <<  4)
+#define LNB_TONE			(1ULL << 15)
+
+#define LNB_BUF_LEVEL(i)		(LNB_BASE + (i) * 0x20 + 0x10)
+#define LNB_BUF_WRITE(i)		(LNB_BASE + (i) * 0x20 + 0x14)
+
diff --git a/drivers/media/pci/ddbridge/ddbridge.h b/drivers/media/pci/ddbridge/ddbridge.h
index 96a904516627..038ecae3fd18 100644
--- a/drivers/media/pci/ddbridge/ddbridge.h
+++ b/drivers/media/pci/ddbridge/ddbridge.h
@@ -115,6 +115,7 @@ struct ddb_info {
 #define DDB_NONE         0
 #define DDB_OCTOPUS      1
 #define DDB_OCTOPUS_CI   2
+#define DDB_OCTOPUS_MAX  5
 #define DDB_OCTOPUS_MAX_CT  6
 	char *name;
 	u32   i2c_mask;
@@ -295,6 +296,15 @@ struct ddb_port {
 
 #define TS_CAPTURE_LEN  (4096)
 
+struct ddb_lnb {
+	struct mutex           lock;
+	u32                    tone;
+	enum fe_sec_voltage    oldvoltage[4];
+	u32                    voltage[4];
+	u32                    voltages;
+	u32                    fmode;
+};
+
 struct ddb_link {
 	struct ddb            *dev;
 	struct ddb_info       *info;
@@ -302,6 +312,7 @@ struct ddb_link {
 	u32                    regs;
 	spinlock_t             lock;
 	struct mutex           flash_mutex;
+	struct ddb_lnb         lnb;
 	struct tasklet_struct  tasklet;
 	struct ddb_ids         ids;
 
-- 
2.13.0
