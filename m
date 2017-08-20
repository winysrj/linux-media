Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35701 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbdHTLI7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:08:59 -0400
Received: by mail-wr0-f193.google.com with SMTP id p8so10312112wrf.2
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 04:08:58 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH] [media] ddbridge: add IOCTLs
Date: Sun, 20 Aug 2017 13:08:55 +0200
Message-Id: <20170820110855.7127-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

This patch adds back the IOCTL API/functionality which is present in the
upstream dddvb driver package. In comparison, the IOCTL handler has been
factored to a separate object (and with that, some functionality from
-core has been moved there aswell), the IOCTLs are defined in an include
in the uAPI, and ioctl-number.txt is updated to document that there are
IOCTLs present in this driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
This patch depends on the ddbridge-0.9.29 bump, see [1]. The
functionality was part of the driver before.

[1] http://www.spinics.net/lists/linux-media/msg119911.html

 Documentation/ioctl/ioctl-number.txt        |   1 +
 MAINTAINERS                                 |   1 +
 drivers/media/pci/ddbridge/Makefile         |   2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c  | 111 +--------
 drivers/media/pci/ddbridge/ddbridge-ioctl.c | 334 ++++++++++++++++++++++++++++
 drivers/media/pci/ddbridge/ddbridge-ioctl.h |  32 +++
 include/uapi/linux/ddbridge-ioctl.h         | 110 +++++++++
 7 files changed, 481 insertions(+), 110 deletions(-)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.c
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-ioctl.h
 create mode 100644 include/uapi/linux/ddbridge-ioctl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 3e3fdae5f3ed..d78d1cd092d2 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -215,6 +215,7 @@ Code  Seq#(hex)	Include File		Comments
 'c'	A0-AF   arch/x86/include/asm/msr.h	conflict!
 'd'	00-FF	linux/char/drm/drm.h	conflict!
 'd'	02-40	pcmcia/ds.h		conflict!
+'d'	00-0B	linux/ddbridge-ioctl.h	conflict!
 'd'	F0-FF	linux/digi1.h
 'e'	all	linux/digi1.h		conflict!
 'e'	00-1F	drivers/net/irda/irtty-sir.h	conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index 0453a1365c3a..2fd5055f8a60 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8428,6 +8428,7 @@ W:	https://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/pci/ddbridge/*
+F:	include/uapi/linux/ddbridge-ioctl.h
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
diff --git a/drivers/media/pci/ddbridge/Makefile b/drivers/media/pci/ddbridge/Makefile
index 3ef3048a89ac..2cde91b376f6 100644
--- a/drivers/media/pci/ddbridge/Makefile
+++ b/drivers/media/pci/ddbridge/Makefile
@@ -3,7 +3,7 @@
 #
 
 ddbridge-objs := ddbridge-main.o ddbridge-core.o ddbridge-hw.o \
-		ddbridge-i2c.o
+		ddbridge-i2c.o ddbridge-ioctl.o
 
 obj-$(CONFIG_DVB_DDBRIDGE) += ddbridge.o
 
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index e051a691eb42..5c514b814cd8 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -38,6 +38,7 @@
 #include "ddbridge-i2c.h"
 #include "ddbridge-regs.h"
 #include "ddbridge-io.h"
+#include "ddbridge-ioctl.h"
 
 #include "tda18271c2dd.h"
 #include "stv6110x.h"
@@ -2750,112 +2751,14 @@ irqreturn_t ddb_irq_handler(int irq, void *dev_id)
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
-	u32 rlen)
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
-		data = swab32(*(u32 *) wbuf);
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
-		*(u32 *) rbuf = swab32(data);
-		rbuf += 4;
-		rlen -= 4;
-	}
-	ddbwritel(dev, 0x0003 | ((rlen << (8 + 3)) & 0x1F00),
-		tag | SPI_CONTROL);
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
+	return ddb_flashio(dev, link, cmd, 4, buf, len);
 }
 
-/*
- * TODO/FIXME: add/implement IOCTLs from upstream driver
- */
-
 #define DDB_NAME "ddbridge"
 
 static u32 ddb_num;
@@ -2881,16 +2784,6 @@ static int ddb_open(struct inode *inode, struct file *file)
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
index 000000000000..c95a18ae7f80
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ioctl.c
@@ -0,0 +1,334 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
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
+static int mdio_write(struct ddb *dev, u8 adr, u8 reg, u16 val)
+{
+	ddbwritel(dev, adr, MDIO_ADR);
+	ddbwritel(dev, reg, MDIO_REG);
+	ddbwritel(dev, val, MDIO_VAL);
+	ddbwritel(dev, 0x03, MDIO_CTRL);
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02)
+		ndelay(500);
+	return 0;
+}
+
+static u16 mdio_read(struct ddb *dev, u8 adr, u8 reg)
+{
+	ddbwritel(dev, adr, MDIO_ADR);
+	ddbwritel(dev, reg, MDIO_REG);
+	ddbwritel(dev, 0x07, MDIO_CTRL);
+	while (ddbreadl(dev, MDIO_CTRL) & 0x02)
+		ndelay(500);
+	return ddbreadl(dev, MDIO_VAL);
+}
+
+/******************************************************************************/
+
+int ddb_flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
+		u32 rlen)
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
+	case IOCTL_DDB_FLASHIO:
+	{
+		struct ddb_flash_io fio;
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
+		res = ddb_flashio(dev, fio.link, wbuf, fio.write_len,
+				  rbuf, fio.read_len);
+		if (res)
+			return res;
+		if (copy_to_user(fio.read_buf, rbuf, fio.read_len))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_GPIO_OUT:
+	{
+		struct ddb_gpio gpio;
+
+		if (copy_from_user(&gpio, parg, sizeof(gpio)))
+			return -EFAULT;
+		ddbwritel(dev, gpio.mask, GPIO_DIRECTION);
+		ddbwritel(dev, gpio.data, GPIO_OUTPUT);
+		break;
+	}
+	case IOCTL_DDB_ID:
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
+	case IOCTL_DDB_READ_REG:
+	{
+		struct ddb_reg reg;
+
+		if (copy_from_user(&reg, parg, sizeof(reg)))
+			return -EFAULT;
+		if ((reg.reg & 0xfffffff) >= dev->regs_len)
+			return -EINVAL;
+		reg.val = ddbreadl(dev, reg.reg);
+		if (copy_to_user(parg, &reg, sizeof(reg)))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_REG:
+	{
+		struct ddb_reg reg;
+
+		if (copy_from_user(&reg, parg, sizeof(reg)))
+			return -EFAULT;
+		if ((reg.reg & 0xfffffff) >= dev->regs_len)
+			return -EINVAL;
+		ddbwritel(dev, reg.val, reg.reg);
+		break;
+	}
+	case IOCTL_DDB_READ_MDIO:
+	{
+		struct ddb_mdio mdio;
+
+		if (!dev->link[0].info->mdio_num)
+			return -EIO;
+		if (copy_from_user(&mdio, parg, sizeof(mdio)))
+			return -EFAULT;
+		mdio.val = mdio_read(dev, mdio.adr, mdio.reg);
+		if (copy_to_user(parg, &mdio, sizeof(mdio)))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_MDIO:
+	{
+		struct ddb_mdio mdio;
+
+		if (!dev->link[0].info->mdio_num)
+			return -EIO;
+		if (copy_from_user(&mdio, parg, sizeof(mdio)))
+			return -EFAULT;
+		mdio_write(dev, mdio.adr, mdio.reg, mdio.val);
+		break;
+	}
+	case IOCTL_DDB_READ_MEM:
+	{
+		struct ddb_mem mem;
+		u8 *buf = dev->iobuf;
+
+		if (copy_from_user(&mem, parg, sizeof(mem)))
+			return -EFAULT;
+		if ((((mem.len + mem.off) & 0xfffffff) > dev->regs_len) ||
+		    mem.len > 1024)
+			return -EINVAL;
+		ddbcpyfrom(dev, buf, mem.off, mem.len);
+		if (copy_to_user(mem.buf, buf, mem.len))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_MEM:
+	{
+		struct ddb_mem mem;
+		u8 *buf = dev->iobuf;
+
+		if (copy_from_user(&mem, parg, sizeof(mem)))
+			return -EFAULT;
+		if ((((mem.len + mem.off) & 0xfffffff) > dev->regs_len) ||
+		    mem.len > 1024)
+			return -EINVAL;
+		if (copy_from_user(buf, mem.buf, mem.len))
+			return -EFAULT;
+		ddbcpyto(dev, mem.off, buf, mem.len);
+		break;
+	}
+	case IOCTL_DDB_READ_I2C:
+	{
+		struct ddb_i2c_msg i2c;
+		struct i2c_adapter *adap;
+		u8 *mbuf, *hbuf = dev->iobuf;
+
+		if (copy_from_user(&i2c, parg, sizeof(i2c)))
+			return -EFAULT;
+		if (i2c.bus > dev->link[0].info->regmap->i2c->num)
+			return -EINVAL;
+		if (i2c.mlen + i2c.hlen > 512)
+			return -EINVAL;
+
+		adap = &dev->i2c[i2c.bus].adap;
+		mbuf = hbuf + i2c.hlen;
+
+		if (copy_from_user(hbuf, i2c.hdr, i2c.hlen))
+			return -EFAULT;
+		if (i2c_io(adap, i2c.adr, hbuf, i2c.hlen, mbuf, i2c.mlen) < 0)
+			return -EIO;
+		if (copy_to_user(i2c.msg, mbuf, i2c.mlen))
+			return -EFAULT;
+		break;
+	}
+	case IOCTL_DDB_WRITE_I2C:
+	{
+		struct ddb_i2c_msg i2c;
+		struct i2c_adapter *adap;
+		u8 *buf = dev->iobuf;
+
+		if (copy_from_user(&i2c, parg, sizeof(i2c)))
+			return -EFAULT;
+		if (i2c.bus > dev->link[0].info->regmap->i2c->num)
+			return -EINVAL;
+		if (i2c.mlen + i2c.hlen > 250)
+			return -EINVAL;
+
+		adap = &dev->i2c[i2c.bus].adap;
+		if (copy_from_user(buf, i2c.hdr, i2c.hlen))
+			return -EFAULT;
+		if (copy_from_user(buf + i2c.hlen, i2c.msg, i2c.mlen))
+			return -EFAULT;
+		if (i2c_write(adap, i2c.adr, buf, i2c.hlen + i2c.mlen) < 0)
+			return -EIO;
+		break;
+	}
+	default:
+		return -ENOTTY;
+	}
+	return 0;
+}
diff --git a/drivers/media/pci/ddbridge/ddbridge-ioctl.h b/drivers/media/pci/ddbridge/ddbridge-ioctl.h
new file mode 100644
index 000000000000..90da239261ae
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-ioctl.h
@@ -0,0 +1,32 @@
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
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
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
+int ddb_flashio(struct ddb *dev, u32 lnr, u8 *wbuf, u32 wlen, u8 *rbuf,
+		u32 rlen);
+long ddb_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
+#endif /* __DDBRIDGE_IOCTL_H__ */
diff --git a/include/uapi/linux/ddbridge-ioctl.h b/include/uapi/linux/ddbridge-ioctl.h
new file mode 100644
index 000000000000..3235637ad338
--- /dev/null
+++ b/include/uapi/linux/ddbridge-ioctl.h
@@ -0,0 +1,110 @@
+/*
+ * ddbridge-ioctl.h: Digital Devices bridge IOCTL API
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
+#ifndef __LINUX_DDBRIDGE_IOCTL_H__
+#define __LINUX_DDBRIDGE_IOCTL_H__
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/******************************************************************************/
+
+#define DDB_MAGIC 'd'
+
+/* IOCTL_DDB_FLASHIO */
+struct ddb_flash_io {
+	/* write_*: userspace -> flash */
+	__user __u8 *write_buf;
+	__u32        write_len;
+	/* read_*: flash -> userspace */
+	__user __u8 *read_buf;
+	__u32        read_len;
+	/* card/addon link */
+	__u32        link;
+};
+
+/* IOCTL_DDB_GPIO_{IN,OUT} */
+struct ddb_gpio {
+	__u32 mask;
+	__u32 data;
+};
+
+/* IOCTL_DDB_ID */
+struct ddb_id {
+	/* card/PCI device data, FPGA/regmap info */
+	__u16 vendor;
+	__u16 device;
+	__u16 subvendor;
+	__u16 subdevice;
+	__u32 hw;
+	__u32 regmap;
+};
+
+/* IOCTL_DDB_{READ,WRITE}_REG */
+struct ddb_reg {
+	__u32 reg;
+	__u32 val;
+};
+
+/* IOCTL_DDB_{READ,WRITE}_MEM */
+struct ddb_mem {
+	/* read/write card mem, off = offset from base address */
+	__u32        off;
+	__user __u8 *buf;
+	__u32        len;
+};
+
+/* IOCTL_DDB_{READ,WRITE}_MDIO */
+struct ddb_mdio {
+	/* read/write from/to MDIO address/register/value */
+	__u8  adr;
+	__u8  reg;
+	__u16 val;
+};
+
+/* IOCTL_DDB_{READ,WRITE}_I2C */
+struct ddb_i2c_msg {
+	/* card's I2C bus number */
+	__u8   bus;
+	/* I2C address */
+	__u8   adr;
+	/* I2C IO header */
+	__u8  *hdr;
+	__u32  hlen;
+	/* I2C message */
+	__u8  *msg;
+	__u32  mlen;
+};
+
+/* IOCTLs */
+#define IOCTL_DDB_FLASHIO	_IOWR(DDB_MAGIC, 0x00, struct ddb_flash_io)
+#define IOCTL_DDB_GPIO_IN	_IOWR(DDB_MAGIC, 0x01, struct ddb_gpio)
+#define IOCTL_DDB_GPIO_OUT	_IOWR(DDB_MAGIC, 0x02, struct ddb_gpio)
+#define IOCTL_DDB_ID		_IOR(DDB_MAGIC,  0x03, struct ddb_id)
+#define IOCTL_DDB_READ_REG	_IOWR(DDB_MAGIC, 0x04, struct ddb_reg)
+#define IOCTL_DDB_WRITE_REG	_IOW(DDB_MAGIC,  0x05, struct ddb_reg)
+#define IOCTL_DDB_READ_MEM	_IOWR(DDB_MAGIC, 0x06, struct ddb_mem)
+#define IOCTL_DDB_WRITE_MEM	_IOR(DDB_MAGIC,  0x07, struct ddb_mem)
+#define IOCTL_DDB_READ_MDIO	_IOWR(DDB_MAGIC, 0x08, struct ddb_mdio)
+#define IOCTL_DDB_WRITE_MDIO	_IOR(DDB_MAGIC,  0x09, struct ddb_mdio)
+#define IOCTL_DDB_READ_I2C	_IOWR(DDB_MAGIC, 0x0a, struct ddb_i2c_msg)
+#define IOCTL_DDB_WRITE_I2C	_IOR(DDB_MAGIC,  0x0b, struct ddb_i2c_msg)
+
+/******************************************************************************/
+
+#endif /* __LINUX_DDBRIDGE_IOCTL_H__ */
-- 
2.13.0
