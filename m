Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34268 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751398AbdJOUwE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Oct 2017 16:52:04 -0400
Received: by mail-wm0-f67.google.com with SMTP id l10so6165355wmg.1
        for <linux-media@vger.kernel.org>; Sun, 15 Oct 2017 13:52:03 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH 3/8] [media] ddbridge: split off CI (common interface) from ddbridge-core
Date: Sun, 15 Oct 2017 22:51:52 +0200
Message-Id: <20171015205157.14342-4-d.scheller.oss@gmail.com>
In-Reply-To: <20171015205157.14342-1-d.scheller.oss@gmail.com>
References: <20171015205157.14342-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Move all CI device support related code from ddbridge-core to ddbridge-ci,
following the previously split off MaxS4/8 support.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile        |   4 +-
 drivers/media/pci/ddbridge/ddbridge-ci.c   | 349 +++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ci.h   |  30 +++
 drivers/media/pci/ddbridge/ddbridge-core.c | 330 +--------------------------
 4 files changed, 383 insertions(+), 330 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ci.h

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 09703312a3f1..00e89b6a0328 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -2,8 +2,8 @@
 # Makefile for the ddbridge device driver
 #
 
-ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-hw.o \
-		ddbridge-i2c.o ddbridge-maxs8.o
+ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-ci.o \
+		ddbridge-hw.o ddbridge-i2c.o ddbridge-maxs8.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.c b/drivers/media/pci/ddbridge/ddbridge-ci.c
new file mode 100644
index 000000000000..c775b17c3228
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.c
@@ -0,0 +1,349 @@
+/*
+ * ddbridge-ci.c: Digital Devices bridge CI (DuoFlex, CI Bridge) support
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
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
+ * To obtain the license, point your browser to
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+#include "ddbridge-io.h"
+#include "ddbridge-i2c.h"
+
+#include "cxd2099.h"
+
+/* Octopus CI internal CI interface */
+
+static int wait_ci_ready(struct ddb_ci *ci)
+{
+	u32 count = 10;
+
+	ndelay(500);
+	do {
+		if (ddbreadl(ci->port->dev,
+			     CI_CONTROL(ci->nr)) & CI_READY)
+			break;
+		usleep_range(1, 2);
+		if ((--count) == 0)
+			return -1;
+	} while (1);
+	return 0;
+}
+
+static int read_attribute_mem(struct dvb_ca_en50221 *ca,
+			      int slot, int address)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val, off = (address >> 1) & (CI_BUFFER_SIZE - 1);
+
+	if (address > CI_BUFFER_SIZE)
+		return -1;
+	ddbwritel(ci->port->dev, CI_READ_CMD | (1 << 16) | address,
+		  CI_DO_READ_ATTRIBUTES(ci->nr));
+	wait_ci_ready(ci);
+	val = 0xff & ddbreadl(ci->port->dev, CI_BUFFER(ci->nr) + off);
+	return val;
+}
+
+static int write_attribute_mem(struct dvb_ca_en50221 *ca, int slot,
+			       int address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
+		  CI_DO_ATTRIBUTE_RW(ci->nr));
+	wait_ci_ready(ci);
+	return 0;
+}
+
+static int read_cam_control(struct dvb_ca_en50221 *ca,
+			    int slot, u8 address)
+{
+	u32 count = 100;
+	struct ddb_ci *ci = ca->data;
+	u32 res;
+
+	ddbwritel(ci->port->dev, CI_READ_CMD | address,
+		  CI_DO_IO_RW(ci->nr));
+	ndelay(500);
+	do {
+		res = ddbreadl(ci->port->dev, CI_READDATA(ci->nr));
+		if (res & CI_READY)
+			break;
+		usleep_range(1, 2);
+		if ((--count) == 0)
+			return -1;
+	} while (1);
+	return 0xff & res;
+}
+
+static int write_cam_control(struct dvb_ca_en50221 *ca, int slot,
+			     u8 address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
+		  CI_DO_IO_RW(ci->nr));
+	wait_ci_ready(ci);
+	return 0;
+}
+
+static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, CI_POWER_ON,
+		  CI_CONTROL(ci->nr));
+	msleep(100);
+	ddbwritel(ci->port->dev, CI_POWER_ON | CI_RESET_CAM,
+		  CI_CONTROL(ci->nr));
+	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON | CI_RESET_CAM,
+		  CI_CONTROL(ci->nr));
+	usleep_range(20, 25);
+	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON,
+		  CI_CONTROL(ci->nr));
+	return 0;
+}
+
+static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	ddbwritel(ci->port->dev, 0, CI_CONTROL(ci->nr));
+	msleep(300);
+	return 0;
+}
+
+static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
+
+	ddbwritel(ci->port->dev, val | CI_BYPASS_DISABLE,
+		  CI_CONTROL(ci->nr));
+	return 0;
+}
+
+static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	struct ddb_ci *ci = ca->data;
+	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
+	int stat = 0;
+
+	if (val & CI_CAM_DETECT)
+		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
+	if (val & CI_CAM_READY)
+		stat |= DVB_CA_EN50221_POLL_CAM_READY;
+	return stat;
+}
+
+static struct dvb_ca_en50221 en_templ = {
+	.read_attribute_mem  = read_attribute_mem,
+	.write_attribute_mem = write_attribute_mem,
+	.read_cam_control    = read_cam_control,
+	.write_cam_control   = write_cam_control,
+	.slot_reset          = slot_reset,
+	.slot_shutdown       = slot_shutdown,
+	.slot_ts_enable      = slot_ts_enable,
+	.poll_slot_status    = poll_slot_status,
+};
+
+static void ci_attach(struct ddb_port *port)
+{
+	struct ddb_ci *ci = NULL;
+
+	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
+	if (!ci)
+		return;
+	memcpy(&ci->en, &en_templ, sizeof(en_templ));
+	ci->en.data = ci;
+	port->en = &ci->en;
+	ci->port = port;
+	ci->nr = port->nr - 2;
+}
+
+/* DuoFlex Dual CI support */
+
+static int write_creg(struct ddb_ci *ci, u8 data, u8 mask)
+{
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	ci->port->creg = (ci->port->creg & ~mask) | data;
+	return i2c_write_reg(i2c, adr, 0x02, ci->port->creg);
+}
+
+static int read_attribute_mem_xo2(struct dvb_ca_en50221 *ca,
+				  int slot, int address)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	int res;
+	u8 val;
+
+	res = i2c_read_reg16(i2c, adr, 0x8000 | address, &val);
+	return res ? res : val;
+}
+
+static int write_attribute_mem_xo2(struct dvb_ca_en50221 *ca, int slot,
+				   int address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	return i2c_write_reg16(i2c, adr, 0x8000 | address, value);
+}
+
+static int read_cam_control_xo2(struct dvb_ca_en50221 *ca,
+				int slot, u8 address)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	u8 val;
+	int res;
+
+	res = i2c_read_reg(i2c, adr, 0x20 | (address & 3), &val);
+	return res ? res : val;
+}
+
+static int write_cam_control_xo2(struct dvb_ca_en50221 *ca, int slot,
+				 u8 address, u8 value)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+
+	return i2c_write_reg(i2c, adr, 0x20 | (address & 3), value);
+}
+
+static int slot_reset_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x01, 0x01);
+	write_creg(ci, 0x04, 0x04);
+	msleep(20);
+	write_creg(ci, 0x02, 0x02);
+	write_creg(ci, 0x00, 0x04);
+	write_creg(ci, 0x18, 0x18);
+	return 0;
+}
+
+static int slot_shutdown_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x10, 0xff);
+	write_creg(ci, 0x08, 0x08);
+	return 0;
+}
+
+static int slot_ts_enable_xo2(struct dvb_ca_en50221 *ca, int slot)
+{
+	struct ddb_ci *ci = ca->data;
+
+	dev_info(ci->port->dev->dev, "%s\n", __func__);
+	write_creg(ci, 0x00, 0x10);
+	return 0;
+}
+
+static int poll_slot_status_xo2(struct dvb_ca_en50221 *ca, int slot, int open)
+{
+	struct ddb_ci *ci = ca->data;
+	struct i2c_adapter *i2c = &ci->port->i2c->adap;
+	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
+	u8 val = 0;
+	int stat = 0;
+
+	i2c_read_reg(i2c, adr, 0x01, &val);
+
+	if (val & 2)
+		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
+	if (val & 1)
+		stat |= DVB_CA_EN50221_POLL_CAM_READY;
+	return stat;
+}
+
+static struct dvb_ca_en50221 en_xo2_templ = {
+	.read_attribute_mem  = read_attribute_mem_xo2,
+	.write_attribute_mem = write_attribute_mem_xo2,
+	.read_cam_control    = read_cam_control_xo2,
+	.write_cam_control   = write_cam_control_xo2,
+	.slot_reset          = slot_reset_xo2,
+	.slot_shutdown       = slot_shutdown_xo2,
+	.slot_ts_enable      = slot_ts_enable_xo2,
+	.poll_slot_status    = poll_slot_status_xo2,
+};
+
+static void ci_xo2_attach(struct ddb_port *port)
+{
+	struct ddb_ci *ci;
+
+	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
+	if (!ci)
+		return;
+	memcpy(&ci->en, &en_xo2_templ, sizeof(en_xo2_templ));
+	ci->en.data = ci;
+	port->en = &ci->en;
+	ci->port = port;
+	ci->nr = port->nr - 2;
+	ci->port->creg = 0;
+	write_creg(ci, 0x10, 0xff);
+	write_creg(ci, 0x08, 0x08);
+}
+
+static struct cxd2099_cfg cxd_cfg = {
+	.bitrate =  72000,
+	.adr     =  0x40,
+	.polarity = 1,
+	.clock_mode = 1,
+	.max_i2c = 512,
+};
+
+int ddb_ci_attach(struct ddb_port *port, u32 bitrate)
+{
+	switch (port->type) {
+	case DDB_CI_EXTERNAL_SONY:
+		cxd_cfg.bitrate = bitrate;
+		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap,
+				    port->en, 0, 1);
+		break;
+
+	case DDB_CI_EXTERNAL_XO2:
+	case DDB_CI_EXTERNAL_XO2_B:
+		ci_xo2_attach(port);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+		break;
+
+	case DDB_CI_INTERNAL:
+		ci_attach(port);
+		if (!port->en)
+			return -ENODEV;
+		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
+		break;
+	}
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-ci.h b/drivers/media/pci/ddbridge/ddbridge-ci.h
new file mode 100644
index 000000000000..3a5d7ffab7b7
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ci.h
@@ -0,0 +1,30 @@
+/*
+ * ddbridge-ci.h: Digital Devices bridge CI (DuoFlex, CI Bridge) support
+ *
+ * Copyright (C) 2010-2017 Digital Devices GmbH
+ *                         Marcus Metzler <mocm@metzlerbros.de>
+ *                         Ralph Metzler <rjkm@metzlerbros.de>
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
+ * To obtain the license, point your browser to
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#ifndef __DDBRIDGE_CI_H__
+#define __DDBRIDGE_CI_H__
+
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+int ddb_ci_attach(struct ddb_port *port, u32 bitrate);
+
+#endif /* __DDBRIDGE_CI_H__ */
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 0eaa2efdcc54..6354e00f4c9b 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -38,6 +38,7 @@
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
 #include "ddbridge-maxs8.h"
+#include "ddbridge-ci.h"
 #include "ddbridge-io.h"
 
 #include "tda18271c2dd.h"
@@ -1917,333 +1918,6 @@ static void ddb_port_probe(struct ddb_port *port)
 /****************************************************************************/
 /****************************************************************************/
 
-static int wait_ci_ready(struct ddb_ci *ci)
-{
-	u32 count = 10;
-
-	ndelay(500);
-	do {
-		if (ddbreadl(ci->port->dev,
-			     CI_CONTROL(ci->nr)) & CI_READY)
-			break;
-		usleep_range(1, 2);
-		if ((--count) == 0)
-			return -1;
-	} while (1);
-	return 0;
-}
-
-static int read_attribute_mem(struct dvb_ca_en50221 *ca,
-			      int slot, int address)
-{
-	struct ddb_ci *ci = ca->data;
-	u32 val, off = (address >> 1) & (CI_BUFFER_SIZE - 1);
-
-	if (address > CI_BUFFER_SIZE)
-		return -1;
-	ddbwritel(ci->port->dev, CI_READ_CMD | (1 << 16) | address,
-		  CI_DO_READ_ATTRIBUTES(ci->nr));
-	wait_ci_ready(ci);
-	val = 0xff & ddbreadl(ci->port->dev, CI_BUFFER(ci->nr) + off);
-	return val;
-}
-
-static int write_attribute_mem(struct dvb_ca_en50221 *ca, int slot,
-			       int address, u8 value)
-{
-	struct ddb_ci *ci = ca->data;
-
-	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
-		  CI_DO_ATTRIBUTE_RW(ci->nr));
-	wait_ci_ready(ci);
-	return 0;
-}
-
-static int read_cam_control(struct dvb_ca_en50221 *ca,
-			    int slot, u8 address)
-{
-	u32 count = 100;
-	struct ddb_ci *ci = ca->data;
-	u32 res;
-
-	ddbwritel(ci->port->dev, CI_READ_CMD | address,
-		  CI_DO_IO_RW(ci->nr));
-	ndelay(500);
-	do {
-		res = ddbreadl(ci->port->dev, CI_READDATA(ci->nr));
-		if (res & CI_READY)
-			break;
-		usleep_range(1, 2);
-		if ((--count) == 0)
-			return -1;
-	} while (1);
-	return 0xff & res;
-}
-
-static int write_cam_control(struct dvb_ca_en50221 *ca, int slot,
-			     u8 address, u8 value)
-{
-	struct ddb_ci *ci = ca->data;
-
-	ddbwritel(ci->port->dev, CI_WRITE_CMD | (value << 16) | address,
-		  CI_DO_IO_RW(ci->nr));
-	wait_ci_ready(ci);
-	return 0;
-}
-
-static int slot_reset(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-
-	ddbwritel(ci->port->dev, CI_POWER_ON,
-		  CI_CONTROL(ci->nr));
-	msleep(100);
-	ddbwritel(ci->port->dev, CI_POWER_ON | CI_RESET_CAM,
-		  CI_CONTROL(ci->nr));
-	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON | CI_RESET_CAM,
-		  CI_CONTROL(ci->nr));
-	usleep_range(20, 25);
-	ddbwritel(ci->port->dev, CI_ENABLE | CI_POWER_ON,
-		  CI_CONTROL(ci->nr));
-	return 0;
-}
-
-static int slot_shutdown(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-
-	ddbwritel(ci->port->dev, 0, CI_CONTROL(ci->nr));
-	msleep(300);
-	return 0;
-}
-
-static int slot_ts_enable(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
-
-	ddbwritel(ci->port->dev, val | CI_BYPASS_DISABLE,
-		  CI_CONTROL(ci->nr));
-	return 0;
-}
-
-static int poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int open)
-{
-	struct ddb_ci *ci = ca->data;
-	u32 val = ddbreadl(ci->port->dev, CI_CONTROL(ci->nr));
-	int stat = 0;
-
-	if (val & CI_CAM_DETECT)
-		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
-	if (val & CI_CAM_READY)
-		stat |= DVB_CA_EN50221_POLL_CAM_READY;
-	return stat;
-}
-
-static struct dvb_ca_en50221 en_templ = {
-	.read_attribute_mem  = read_attribute_mem,
-	.write_attribute_mem = write_attribute_mem,
-	.read_cam_control    = read_cam_control,
-	.write_cam_control   = write_cam_control,
-	.slot_reset          = slot_reset,
-	.slot_shutdown       = slot_shutdown,
-	.slot_ts_enable      = slot_ts_enable,
-	.poll_slot_status    = poll_slot_status,
-};
-
-static void ci_attach(struct ddb_port *port)
-{
-	struct ddb_ci *ci = NULL;
-
-	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
-	if (!ci)
-		return;
-	memcpy(&ci->en, &en_templ, sizeof(en_templ));
-	ci->en.data = ci;
-	port->en = &ci->en;
-	ci->port = port;
-	ci->nr = port->nr - 2;
-}
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
-static int write_creg(struct ddb_ci *ci, u8 data, u8 mask)
-{
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-
-	ci->port->creg = (ci->port->creg & ~mask) | data;
-	return i2c_write_reg(i2c, adr, 0x02, ci->port->creg);
-}
-
-static int read_attribute_mem_xo2(struct dvb_ca_en50221 *ca,
-				  int slot, int address)
-{
-	struct ddb_ci *ci = ca->data;
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-	int res;
-	u8 val;
-
-	res = i2c_read_reg16(i2c, adr, 0x8000 | address, &val);
-	return res ? res : val;
-}
-
-static int write_attribute_mem_xo2(struct dvb_ca_en50221 *ca, int slot,
-				   int address, u8 value)
-{
-	struct ddb_ci *ci = ca->data;
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-
-	return i2c_write_reg16(i2c, adr, 0x8000 | address, value);
-}
-
-static int read_cam_control_xo2(struct dvb_ca_en50221 *ca,
-				int slot, u8 address)
-{
-	struct ddb_ci *ci = ca->data;
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-	u8 val;
-	int res;
-
-	res = i2c_read_reg(i2c, adr, 0x20 | (address & 3), &val);
-	return res ? res : val;
-}
-
-static int write_cam_control_xo2(struct dvb_ca_en50221 *ca, int slot,
-				 u8 address, u8 value)
-{
-	struct ddb_ci *ci = ca->data;
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-
-	return i2c_write_reg(i2c, adr, 0x20 | (address & 3), value);
-}
-
-static int slot_reset_xo2(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-
-	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
-	write_creg(ci, 0x01, 0x01);
-	write_creg(ci, 0x04, 0x04);
-	msleep(20);
-	write_creg(ci, 0x02, 0x02);
-	write_creg(ci, 0x00, 0x04);
-	write_creg(ci, 0x18, 0x18);
-	return 0;
-}
-
-static int slot_shutdown_xo2(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-
-	dev_dbg(ci->port->dev->dev, "%s\n", __func__);
-	write_creg(ci, 0x10, 0xff);
-	write_creg(ci, 0x08, 0x08);
-	return 0;
-}
-
-static int slot_ts_enable_xo2(struct dvb_ca_en50221 *ca, int slot)
-{
-	struct ddb_ci *ci = ca->data;
-
-	dev_info(ci->port->dev->dev, "%s\n", __func__);
-	write_creg(ci, 0x00, 0x10);
-	return 0;
-}
-
-static int poll_slot_status_xo2(struct dvb_ca_en50221 *ca, int slot, int open)
-{
-	struct ddb_ci *ci = ca->data;
-	struct i2c_adapter *i2c = &ci->port->i2c->adap;
-	u8 adr = (ci->port->type == DDB_CI_EXTERNAL_XO2) ? 0x12 : 0x13;
-	u8 val = 0;
-	int stat = 0;
-
-	i2c_read_reg(i2c, adr, 0x01, &val);
-
-	if (val & 2)
-		stat |= DVB_CA_EN50221_POLL_CAM_PRESENT;
-	if (val & 1)
-		stat |= DVB_CA_EN50221_POLL_CAM_READY;
-	return stat;
-}
-
-static struct dvb_ca_en50221 en_xo2_templ = {
-	.read_attribute_mem  = read_attribute_mem_xo2,
-	.write_attribute_mem = write_attribute_mem_xo2,
-	.read_cam_control    = read_cam_control_xo2,
-	.write_cam_control   = write_cam_control_xo2,
-	.slot_reset          = slot_reset_xo2,
-	.slot_shutdown       = slot_shutdown_xo2,
-	.slot_ts_enable      = slot_ts_enable_xo2,
-	.poll_slot_status    = poll_slot_status_xo2,
-};
-
-static void ci_xo2_attach(struct ddb_port *port)
-{
-	struct ddb_ci *ci;
-
-	ci = kzalloc(sizeof(*ci), GFP_KERNEL);
-	if (!ci)
-		return;
-	memcpy(&ci->en, &en_xo2_templ, sizeof(en_xo2_templ));
-	ci->en.data = ci;
-	port->en = &ci->en;
-	ci->port = port;
-	ci->nr = port->nr - 2;
-	ci->port->creg = 0;
-	write_creg(ci, 0x10, 0xff);
-	write_creg(ci, 0x08, 0x08);
-}
-
-/****************************************************************************/
-/****************************************************************************/
-/****************************************************************************/
-
-static struct cxd2099_cfg cxd_cfg = {
-	.bitrate =  72000,
-	.adr     =  0x40,
-	.polarity = 1,
-	.clock_mode = 1,
-	.max_i2c = 512,
-};
-
-static int ddb_ci_attach(struct ddb_port *port)
-{
-	switch (port->type) {
-	case DDB_CI_EXTERNAL_SONY:
-		cxd_cfg.bitrate = ci_bitrate;
-		port->en = cxd2099_attach(&cxd_cfg, port, &port->i2c->adap);
-		if (!port->en)
-			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap,
-				    port->en, 0, 1);
-		break;
-
-	case DDB_CI_EXTERNAL_XO2:
-	case DDB_CI_EXTERNAL_XO2_B:
-		ci_xo2_attach(port);
-		if (!port->en)
-			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
-		break;
-
-	case DDB_CI_INTERNAL:
-		ci_attach(port);
-		if (!port->en)
-			return -ENODEV;
-		dvb_ca_en50221_init(port->dvb[0].adap, port->en, 0, 1);
-		break;
-	}
-	return 0;
-}
-
 static int ddb_port_attach(struct ddb_port *port)
 {
 	int ret = 0;
@@ -2260,7 +1934,7 @@ static int ddb_port_attach(struct ddb_port *port)
 		port->input[1]->redi = port->input[1];
 		break;
 	case DDB_PORT_CI:
-		ret = ddb_ci_attach(port);
+		ret = ddb_ci_attach(port, ci_bitrate);
 		if (ret < 0)
 			break;
 		/* fall-through */
-- 
2.13.6
