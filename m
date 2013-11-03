Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.swsoft.eu ([109.70.220.8]:51570 "EHLO relay.swsoft.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab3KCAkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Nov 2013 20:40:16 -0400
Received: from mail.swsoft.eu ([109.70.220.2])
	by relay.swsoft.eu with esmtps (TLSv1:AES128-SHA:128)
	(Exim 4.77)
	(envelope-from <mbroemme@parallels.com>)
	id 1Vcljj-0001u9-NI
	for linux-media@vger.kernel.org; Sun, 03 Nov 2013 01:40:15 +0100
Received: from parallels.com (cable-78-34-76-230.netcologne.de [78.34.76.230])
	by code.dyndns.org (Postfix) with ESMTPSA id 1C896140CAF	for
 <linux-media@vger.kernel.org>; Sun,  3 Nov 2013 01:40:15 +0100 (CET)
Date: Sun, 3 Nov 2013 01:40:15 +0100
From: Maik Broemme <mbroemme@parallels.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 08/12] ddbridge: Moved i2c interfaces into separate file
Message-ID: <20131103004014.GL7956@parallels.com>
References: <20131103002235.GD7956@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20131103002235.GD7956@parallels.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moved i2c interfaces from ddbridge-core.c into separate file.

Signed-off-by: Maik Broemme <mbroemme@parallels.com>
---
 drivers/media/pci/ddbridge/ddbridge-i2c.c | 239 ++++++++++++++++++++++++++++++
 1 file changed, 239 insertions(+)
 create mode 100644 drivers/media/pci/ddbridge/ddbridge-i2c.c

diff --git a/drivers/media/pci/ddbridge/ddbridge-i2c.c b/drivers/media/pci/ddbridge/ddbridge-i2c.c
new file mode 100644
index 0000000..5e9788c
--- /dev/null
+++ b/drivers/media/pci/ddbridge/ddbridge-i2c.c
@@ -0,0 +1,239 @@
+/*
+ *  ddbridge-i2c.c: Digital Devices bridge i2c driver
+ *
+ *  Copyright (C) 2010-2013 Digital Devices GmbH
+ *  Copyright (C) 2013 Maik Broemme <mbroemme@parallels.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  version 2 only, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ *  02110-1301, USA
+ */
+
+#include "ddbridge.h"
+#include "ddbridge-regs.h"
+
+static int i2c_cmd(struct ddb_i2c *i2c, u32 adr, u32 cmd)
+{
+	struct ddb *dev = i2c->dev;
+	int stat;
+	u32 val;
+	u32 istat;
+
+	// i2c->done = 0;
+	ddbwritel(dev, (adr << 9) | cmd, i2c->regs + I2C_COMMAND);
+
+	// TODO: fix timeout issue.
+	// stat = wait_event_timeout(i2c->wq, i2c->done == 1, HZ);
+	stat = wait_for_completion_timeout(&i2c->completion, HZ);
+	if (stat <= 0) {
+		printk(KERN_ERR "DDBridge I2C timeout, card %d, port %d\n",
+		       dev->nr, i2c->nr);
+		istat = ddbreadl(dev, INTERRUPT_STATUS);
+		printk(KERN_ERR "DDBridge IRS %08x\n", istat);
+		ddbwritel(dev, istat, INTERRUPT_ACK);
+		return -EIO;
+	}
+	val = ddbreadl(dev, i2c->regs + I2C_COMMAND);
+	if (val & 0x70000)
+		return -EIO;
+	return 0;
+}
+
+static int i2c_master_xfer(struct i2c_adapter *adapter,
+			   struct i2c_msg msg[], int num)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) i2c_get_adapdata(adapter);
+	struct ddb *dev = i2c->dev;
+	u8 addr = 0;
+
+	if (num)
+		addr = msg[0].addr;
+	if (num == 2 && msg[1].flags & I2C_M_RD &&
+	    !(msg[0].flags & I2C_M_RD)) {
+		memcpy_toio(dev->regs + I2C_TASKMEM_BASE + i2c->wbuf,
+			    msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len|(msg[1].len << 16),
+			  i2c->regs + I2C_TASKLENGTH);
+		if (!i2c_cmd(i2c, addr, 1)) {
+			memcpy_fromio(msg[1].buf,
+				      dev->regs + I2C_TASKMEM_BASE + i2c->rbuf,
+				      msg[1].len);
+			return num;
+		}
+	}
+	if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
+		ddbcpyto(dev, I2C_TASKMEM_BASE + i2c->wbuf, 
+			 msg[0].buf, msg[0].len);
+		ddbwritel(dev, msg[0].len, i2c->regs + I2C_TASKLENGTH);
+		if (!i2c_cmd(i2c, addr, 2)) {
+			return num;
+		}
+	}
+	if (num == 1 && (msg[0].flags & I2C_M_RD)) {
+		ddbwritel(dev, msg[0].len << 16, i2c->regs + I2C_TASKLENGTH);
+		if (!i2c_cmd(i2c, addr, 3)) {
+			ddbcpyfrom(dev, msg[0].buf,
+				   I2C_TASKMEM_BASE + i2c->rbuf, msg[0].len);
+			return num;
+		}
+	}
+	return -EIO;
+}
+
+static u32 i2c_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_SMBUS_EMUL;
+}
+
+static void i2c_handler(unsigned long priv)
+{
+	struct ddb_i2c *i2c = (struct ddb_i2c *) priv; 
+
+	complete(&i2c->completion);
+}
+
+static struct i2c_algorithm i2c_algo = {
+	.master_xfer   = i2c_master_xfer,
+	.functionality = i2c_functionality,
+};
+
+int ddb_i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
+{
+	struct i2c_msg msg = {.addr = adr, .flags = 0, .buf = data, .len = len};
+
+	return (i2c_transfer(adap, &msg, 1) == 1) ? 0 : -1;
+}
+
+int ddb_i2c_read(struct i2c_adapter *adapter, u8 adr, u8 *val)
+{
+	struct i2c_msg msgs[1] = {{.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+}
+
+int ddb_i2c_read_regs(struct i2c_adapter *adapter,
+			 u8 adr, u8 reg, u8 *val, u8 len)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1 },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int ddb_i2c_read_regs16(struct i2c_adapter *adapter, 
+			   u8 adr, u16 reg, u8 *val, u8 len)
+{
+	u8 reg16[2] = { reg >> 8, reg };
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = reg16, .len   = 2 },
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = len } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int ddb_i2c_read_reg(struct i2c_adapter *adapter, u8 adr, u8 reg, u8 *val)
+{
+	struct i2c_msg msgs[2] = {{.addr = adr,  .flags = 0,
+				   .buf  = &reg, .len   = 1},
+				  {.addr = adr,  .flags = I2C_M_RD,
+				   .buf  = val,  .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int ddb_i2c_read_reg16(struct i2c_adapter *adapter, u8 adr,
+			  u16 reg, u8 *val)
+{
+	u8 msg[2] = {reg >> 8, reg & 0xff};
+	struct i2c_msg msgs[2] = {{.addr = adr, .flags = 0,
+				   .buf  = msg, .len   = 2},
+				  {.addr = adr, .flags = I2C_M_RD,
+				   .buf  = val, .len   = 1 } };
+	return (i2c_transfer(adapter, msgs, 2) == 2) ? 0 : -1;
+}
+
+int ddb_i2c_write_reg16(struct i2c_adapter *adap, u8 adr,
+			   u16 reg, u8 val)
+{
+	u8 msg[3] = {reg >> 8, reg & 0xff, val};
+
+	return ddb_i2c_write(adap, adr, msg, 3);
+}
+
+int ddb_i2c_write_reg(struct i2c_adapter *adap, u8 adr,
+			  u8 reg, u8 val)
+{
+	u8 msg[2] = {reg, val};
+
+	return ddb_i2c_write(adap, adr, msg, 2);
+}
+
+void ddb_i2c_release(struct ddb *dev)
+{
+	int i;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		i2c = &dev->i2c[i];
+		adap = &i2c->adap;
+		i2c_del_adapter(adap);
+	}
+}
+
+int ddb_i2c_init(struct ddb *dev)
+{
+	int i, j, stat = 0;
+	struct ddb_i2c *i2c;
+	struct i2c_adapter *adap;
+	
+	for (i = 0; i < dev->info->i2c_num; i++) {
+		i2c = &dev->i2c[i];
+		dev->handler[i] = i2c_handler;
+		dev->handler_data[i] = (unsigned long) i2c;
+		i2c->dev = dev;
+		i2c->nr = i;
+		i2c->wbuf = i * (I2C_TASKMEM_SIZE / 4);
+		i2c->rbuf = i2c->wbuf + (I2C_TASKMEM_SIZE / 8);
+		i2c->regs = 0x80 + i * 0x20;
+		ddbwritel(dev, I2C_SPEED_100, i2c->regs + I2C_TIMING);
+		ddbwritel(dev, (i2c->rbuf << 16) | i2c->wbuf,
+			  i2c->regs + I2C_TASKADDRESS);
+		// init_waitqueue_head(&i2c->wq);
+		init_completion(&i2c->completion);
+
+		adap = &i2c->adap;
+		i2c_set_adapdata(adap, i2c);
+#ifdef I2C_ADAP_CLASS_TV_DIGITAL
+		adap->class = I2C_ADAP_CLASS_TV_DIGITAL|I2C_CLASS_TV_ANALOG;
+#else
+#ifdef I2C_CLASS_TV_ANALOG
+		adap->class = I2C_CLASS_TV_ANALOG;
+#endif
+#endif
+		strcpy(adap->name, "ddbridge");
+		adap->algo = &i2c_algo;
+		adap->algo_data = (void *)i2c;
+		adap->dev.parent = dev->dev;
+		stat = i2c_add_adapter(adap);
+		if (stat)
+			break;
+	}
+	if (stat)
+		for (j = 0; j < i; j++) {
+			i2c = &dev->i2c[j];
+			adap = &i2c->adap;
+			i2c_del_adapter(adap);
+		}
+	return stat;
+}
-- 
1.8.4.2
