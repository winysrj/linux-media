Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46441 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeELLYk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 07:24:40 -0400
Received: by mail-wr0-f196.google.com with SMTP id a12-v6so7659154wrn.13
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 04:24:39 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, mchehab+samsung@kernel.org
Subject: [PATCH v3 3/3] [media] ddbridge: implement IOCTL handling
Date: Sat, 12 May 2018 13:24:32 +0200
Message-Id: <20180512112432.30887-4-d.scheller.oss@gmail.com>
In-Reply-To: <20180512112432.30887-1-d.scheller.oss@gmail.com>
References: <20180512112432.30887-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This patch adds back the IOCTL API/functionality which is present in the
upstream dddvb driver package. In comparison, the IOCTL handler has been
factored to a separate object (and with that, some functionality from
-core, such as reg_wait() and ddb_flashio() has been moved there aswell).
The IOCTLs were defined in an include in include/uapi/linux/ previously
and being reused here.

The main purpose at the moment is to enable the mainline driver to handle
FPGA firmware updates of all cards supported by the ddbridge driver, which
gets even more important since the introduction of the MaxSX8 support
(this card basically implements the I2C demod/tuner drivers which are used
normally in FPGA, so any fixes need to be flashed into the card), and
the recent firmware releases for the CineS2v7 and Octopus CI S2 series
that not only carry bugfixes, but also enables support for higher
bandwidth transponders.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/pci/ddbridge/Makefile         |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +----------------
 drivers/media/pci/ddbridge/ddbridge-ioctl.c | 179 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++++
 4 files changed, 215 insertions(+), 110 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.h

diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 9b9e35f171b7..3563a3e3d7f9 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -4,7 +4,8 @@
 #
 
 ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-ci.o \
-		ddbridge-hw.o ddbridge-i2c.o ddbridge-max.o ddbridge-mci.o
+		ddbridge-hw.o ddbridge-i2c.o ddbridge-ioctl.o ddbridge-max.o \
+		ddbridge-mci.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 377269c64449..cc0db7b718b1 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -40,6 +40,7 @@
 #include "ddbridge-max.h"
 #include "ddbridge-ci.h"
 #include "ddbridge-io.h"
+#include "ddbridge-ioctl.h"
 
 #include "tda18271c2dd.h"
 #include "stv6110x.h"
@@ -2547,112 +2548,14 @@ irqreturn_t ddb_irq_handler(int irq, void *dev_id)
 /****************************************************************************/
 /****************************************************************************/
 
-static int reg_wait(struct ddb *dev, u32 reg, u32 bit)
-{
-	u32 count = 0;
-
-	while (safe_ddbreadl(dev, reg) & bit) {
-		ndelay(10);
-		if (++count == 100)
-			return -1;
-	}
-	return 0;
-}
-
-static int flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
-		   u32 rlen)
-{
-	u32 data, shift;
-	u32 tag = DDB_LINK_TAG(lnr);
-	struct ddb_link *link = &dev->link[lnr];
-
-	mutex_lock(&link->flash_mutex);
-	if (wlen > 4)
-		ddbwritel(dev, 1, tag | SPI_CONTROL);
-	while (wlen > 4) {
-		/* FIXME: check for big-endian */
-		data = swab32(*(u32 *)wbuf);
-		wbuf += 4;
-		wlen -= 4;
-		ddbwritel(dev, data, tag | SPI_DATA);
-		if (reg_wait(dev, tag | SPI_CONTROL, 4))
-			goto fail;
-	}
-	if (rlen)
-		ddbwritel(dev, 0x0001 | ((wlen << (8 + 3)) & 0x1f00),
-			  tag | SPI_CONTROL);
-	else
-		ddbwritel(dev, 0x0003 | ((wlen << (8 + 3)) & 0x1f00),
-			  tag | SPI_CONTROL);
-
-	data = 0;
-	shift = ((4 - wlen) * 8);
-	while (wlen) {
-		data <<= 8;
-		data |= *wbuf;
-		wlen--;
-		wbuf++;
-	}
-	if (shift)
-		data <<= shift;
-	ddbwritel(dev, data, tag | SPI_DATA);
-	if (reg_wait(dev, tag | SPI_CONTROL, 4))
-		goto fail;
-
-	if (!rlen) {
-		ddbwritel(dev, 0, tag | SPI_CONTROL);
-		goto exit;
-	}
-	if (rlen > 4)
-		ddbwritel(dev, 1, tag | SPI_CONTROL);
-
-	while (rlen > 4) {
-		ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
-		if (reg_wait(dev, tag | SPI_CONTROL, 4))
-			goto fail;
-		data = ddbreadl(dev, tag | SPI_DATA);
-		*(u32 *)rbuf = swab32(data);
-		rbuf += 4;
-		rlen -= 4;
-	}
-	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00),
-		  tag | SPI_CONTROL);
-	ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
-	if (reg_wait(dev, tag | SPI_CONTROL, 4))
-		goto fail;
-
-	data = ddbreadl(dev, tag | SPI_DATA);
-	ddbwritel(dev, 0, tag | SPI_CONTROL);
-
-	if (rlen < 4)
-		data <<= ((4 - rlen) * 8);
-
-	while (rlen > 0) {
-		*rbuf = ((data >> 24) & 0xff);
-		data <<= 8;
-		rbuf++;
-		rlen--;
-	}
-exit:
-	mutex_unlock(&link->flash_mutex);
-	return 0;
-fail:
-	mutex_unlock(&link->flash_mutex);
-	return -1;
-}
-
 int ddbridge_flashread(struct ddb *dev, u32 link, u8 *buf, u32 addr, u32 len)
 {
 	u8 cmd[4] = {0x03, (addr >> 16) & 0xff,
 		     (addr >> 8) & 0xff, addr & 0xff};
 
-	return flashio(dev, link, cmd, 4, buf, len);
+	return ddb_do_flashio(dev, link, cmd, 4, buf, len);
 }
 
-/*
- * TODO/FIXME: add/implement IOCTLs from upstream driver
- */
-
 #define DDB_NAME "ddbridge"
 
 static u32 ddb_num;
@@ -2678,16 +2581,6 @@ static int ddb_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	struct ddb *dev = file->private_data;
-
-	dev_warn(dev->dev, "DDB IOCTLs unsupported (cmd: %d, arg: %lu)\n",
-		 cmd, arg);
-
-	return -ENOTTY;
-}
-
 static const struct file_operations ddb_fops = {
 	.unlocked_ioctl = ddb_ioctl,
 	.open           = ddb_open,
diff --git a/drivers/media/pci/ddbridge/ddbridge-ioctl.c b/drivers/media/pci/ddbridge/ddbridge-ioctl.c
new file mode 100644
index 000000000000..f0431b468383
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ioctl.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ddbridge-ioctl.c: Digital Devices bridge IOCTL handler
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/vmalloc.h>
+
+#include "ddbridge.h"
+#include "ddbridge-i2c.h"
+#include "ddbridge-regs.h"
+#include "ddbridge-io.h"
+#include "ddbridge-ioctl.h"
+
+/******************************************************************************/
+
+static int reg_wait(struct ddb *dev, u32 reg, u32 bit)
+{
+	u32 count = 0;
+
+	while (safe_ddbreadl(dev, reg) & bit) {
+		ndelay(10);
+		if (++count == 100)
+			return -1;
+	}
+	return 0;
+}
+
+/******************************************************************************/
+
+int ddb_do_flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen,
+		   u8 *rbuf, u32 rlen)
+{
+	u32 data, shift;
+	u32 tag = DDB_LINK_TAG(lnr);
+	struct ddb_link *link = &dev->link[lnr];
+
+	mutex_lock(&link->flash_mutex);
+	if (wlen > 4)
+		ddbwritel(dev, 1, tag | SPI_CONTROL);
+	while (wlen > 4) {
+		/* FIXME: check for big-endian */
+		data = swab32(*(u32 *)wbuf);
+		wbuf += 4;
+		wlen -= 4;
+		ddbwritel(dev, data, tag | SPI_DATA);
+		if (reg_wait(dev, tag | SPI_CONTROL, 4))
+			goto fail;
+	}
+	if (rlen)
+		ddbwritel(dev, 0x0001 | ((wlen << (8 + 3)) & 0x1f00),
+			  tag | SPI_CONTROL);
+	else
+		ddbwritel(dev, 0x0003 | ((wlen << (8 + 3)) & 0x1f00),
+			  tag | SPI_CONTROL);
+
+	data = 0;
+	shift = ((4 - wlen) * 8);
+	while (wlen) {
+		data <<= 8;
+		data |= *wbuf;
+		wlen--;
+		wbuf++;
+	}
+	if (shift)
+		data <<= shift;
+	ddbwritel(dev, data, tag | SPI_DATA);
+	if (reg_wait(dev, tag | SPI_CONTROL, 4))
+		goto fail;
+
+	if (!rlen) {
+		ddbwritel(dev, 0, tag | SPI_CONTROL);
+		goto exit;
+	}
+	if (rlen > 4)
+		ddbwritel(dev, 1, tag | SPI_CONTROL);
+
+	while (rlen > 4) {
+		ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
+		if (reg_wait(dev, tag | SPI_CONTROL, 4))
+			goto fail;
+		data = ddbreadl(dev, tag | SPI_DATA);
+		*(u32 *)rbuf = swab32(data);
+		rbuf += 4;
+		rlen -= 4;
+	}
+	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00),
+		  tag | SPI_CONTROL);
+	ddbwritel(dev, 0xffffffff, tag | SPI_DATA);
+	if (reg_wait(dev, tag | SPI_CONTROL, 4))
+		goto fail;
+
+	data = ddbreadl(dev, tag | SPI_DATA);
+	ddbwritel(dev, 0, tag | SPI_CONTROL);
+
+	if (rlen < 4)
+		data <<= ((4 - rlen) * 8);
+
+	while (rlen > 0) {
+		*rbuf = ((data >> 24) & 0xff);
+		data <<= 8;
+		rbuf++;
+		rlen--;
+	}
+exit:
+	mutex_unlock(&link->flash_mutex);
+	return 0;
+fail:
+	mutex_unlock(&link->flash_mutex);
+	return -1;
+}
+
+long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct ddb *dev = file->private_data;
+	__user void *parg = (__user void *)arg;
+	int res;
+
+	switch (cmd) {
+	case DDB_IOCTL_FLASHIO:
+	{
+		struct ddb_flashio fio;
+		u8 *rbuf, *wbuf;
+
+		if (copy_from_user(&fio, parg, sizeof(fio)))
+			return -EFAULT;
+		if (fio.write_len > 1028 || fio.read_len > 1028)
+			return -EINVAL;
+		if (fio.write_len + fio.read_len > 1028)
+			return -EINVAL;
+		if (fio.link > 3)
+			return -EINVAL;
+
+		wbuf = dev->iobuf;
+		rbuf = wbuf + fio.write_len;
+
+		if (copy_from_user(wbuf, fio.write_buf, fio.write_len))
+			return -EFAULT;
+		res = ddb_do_flashio(dev, fio.link, wbuf, fio.write_len,
+				     rbuf, fio.read_len);
+		if (res)
+			return res;
+		if (copy_to_user(fio.read_buf, rbuf, fio.read_len))
+			return -EFAULT;
+		break;
+	}
+	case DDB_IOCTL_ID:
+	{
+		struct ddb_id ddbid;
+
+		ddbid.vendor = dev->link[0].ids.vendor;
+		ddbid.device = dev->link[0].ids.device;
+		ddbid.subvendor = dev->link[0].ids.subvendor;
+		ddbid.subdevice = dev->link[0].ids.subdevice;
+		ddbid.hw = ddbreadl(dev, 0);
+		ddbid.regmap = ddbreadl(dev, 4);
+		if (copy_to_user(parg, &ddbid, sizeof(ddbid)))
+			return -EFAULT;
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-ioctl.h b/drivers/media/pci/ddbridge/ddbridge-ioctl.h
new file mode 100644
index 000000000000..4865e98482ef
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ioctl.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ddbridge-ioctl.h: Digital Devices bridge IOCTL handler
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __DDBRIDGE_IOCTL_H__
+#define __DDBRIDGE_IOCTL_H__
+
+#include <linux/ddbridge-ioctl.h>
+
+#include "ddbridge.h"
+
+/******************************************************************************/
+
+int ddb_do_flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
+		   u32 rlen);
+long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+#endif /* __DDBRIDGE_IOCTL_H__ */
-- 
2.16.1
