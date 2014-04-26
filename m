Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56239 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbaDZUVn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Apr 2014 16:21:43 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: zzam@gentoo.org, crope@iki.fi, xpert-reactos@gmx.de
Subject: [PATCH 1/3] si2165: Add demod driver for DVB-T only
Date: Sat, 26 Apr 2014 22:21:18 +0200
Message-Id: <1398543680-21374-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

DVB-T was tested  with 8MHz BW channels in germany
This driver is the simplest possible, it uses automatic mode for all
parameters (TPS).

Firmware file can be extracted via get_dvb_firmware.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 Documentation/dvb/get_dvb_firmware        |  33 +-
 drivers/media/dvb-frontends/Kconfig       |   9 +
 drivers/media/dvb-frontends/Makefile      |   1 +
 drivers/media/dvb-frontends/si2165.c      | 890 ++++++++++++++++++++++++++++++
 drivers/media/dvb-frontends/si2165.h      |  61 ++
 drivers/media/dvb-frontends/si2165_priv.h |  23 +
 6 files changed, 1016 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/dvb-frontends/si2165.c
 create mode 100644 drivers/media/dvb-frontends/si2165.h
 create mode 100644 drivers/media/dvb-frontends/si2165_priv.h

diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
index d91b8be..26c623d 100755
--- a/Documentation/dvb/get_dvb_firmware
+++ b/Documentation/dvb/get_dvb_firmware
@@ -29,7 +29,7 @@ use IO::Handle;
 		"af9015", "ngene", "az6027", "lme2510_lg", "lme2510c_s7395",
 		"lme2510c_s7395_old", "drxk", "drxk_terratec_h5",
 		"drxk_hauppauge_hvr930c", "tda10071", "it9135", "drxk_pctv",
-		"drxk_terratec_htc_stick", "sms1xxx_hcw");
+		"drxk_terratec_htc_stick", "sms1xxx_hcw", "si2165");
 
 # Check args
 syntax() if (scalar(@ARGV) != 1);
@@ -783,6 +783,37 @@ sub sms1xxx_hcw {
     $allfiles;
 }
 
+sub si2165 {
+    my $sourcefile = "model_111xxx_122xxx_driver_6_0_119_31191_WHQL.zip";
+    my $url = "http://www.hauppauge.de/files/drivers/";
+    my $hash = "76633e7c76b0edee47c3ba18ded99336";
+    my $fwfile = "dvb-demod-si2165.fw";
+    my $tmpdir = tempdir(DIR => "/tmp", CLEANUP => 1);
+
+    checkstandard();
+
+    wgetfile($sourcefile, $url . $sourcefile);
+    verify($sourcefile, $hash);
+    unzip($sourcefile, $tmpdir);
+    extract("$tmpdir/Driver10/Hcw10bda.sys", 0x80788, 0x81E08-0x80788, "$tmpdir/fw1");
+
+    delzero("$tmpdir/fw1","$tmpdir/fw1-1");
+    #verify("$tmpdir/fw1","5e0909858fdf0b5b09ad48b9fe622e70");
+
+    my $CRC="\x0A\xCC";
+    my $BLOCKS_MAIN="\x27";
+    open FW,">$fwfile";
+    print FW "\x01\x00"; # just a version id for the driver itself
+    print FW "\x9A"; # fw version
+    print FW "\x00"; # padding
+    print FW "$BLOCKS_MAIN"; # number of blocks of main part
+    print FW "\x00"; # padding
+    print FW "$CRC"; # 16bit crc value of main part
+    appendfile(FW,"$tmpdir/fw1");
+
+    "$fwfile";
+}
+
 # ---------------------------------------------------------------
 # Utilities
 
diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 1469d44..0da53c2 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -63,6 +63,15 @@ config DVB_TDA18271C2DD
 
 	  Say Y when you want to support this tuner.
 
+config DVB_SI2165
+	tristate "Silicon Labs si2165 based"
+	depends on DVB_CORE && I2C
+	default m if !MEDIA_SUBDRV_AUTOSELECT
+	help
+	  A DVB-C/T demodulator.
+
+	  Say Y when you want to support this frontend.
+
 comment "DVB-S (satellite) frontends"
 	depends on DVB_CORE
 
diff --git a/drivers/media/dvb-frontends/Makefile b/drivers/media/dvb-frontends/Makefile
index dda0bee..595dd8d 100644
--- a/drivers/media/dvb-frontends/Makefile
+++ b/drivers/media/dvb-frontends/Makefile
@@ -100,6 +100,7 @@ obj-$(CONFIG_DVB_STV0367) += stv0367.o
 obj-$(CONFIG_DVB_CXD2820R) += cxd2820r.o
 obj-$(CONFIG_DVB_DRXK) += drxk.o
 obj-$(CONFIG_DVB_TDA18271C2DD) += tda18271c2dd.o
+obj-$(CONFIG_DVB_SI2165) += si2165.o
 obj-$(CONFIG_DVB_A8293) += a8293.o
 obj-$(CONFIG_DVB_TDA10071) += tda10071.o
 obj-$(CONFIG_DVB_RTL2830) += rtl2830.o
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
new file mode 100644
index 0000000..3e69a32
--- /dev/null
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -0,0 +1,890 @@
+/*
+    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+
+    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    References:
+    http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
+*/
+
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/firmware.h>
+
+#include "dvb_frontend.h"
+#include "dvb_math.h"
+#include "si2165_priv.h"
+#include "si2165.h"
+
+/* Hauppauge WinTV-HVR-930C-HD 1113xx uses 16.000 MHz xtal */
+
+struct si2165_state {
+	struct i2c_adapter *i2c;
+
+	struct dvb_frontend frontend;
+
+	struct si2165_config config;
+
+	/* chip revision */
+	u8 revcode;
+	/* chip type */
+	u8 chip_type;
+
+	/* calculated by xtal and div settings */
+	u32 fvco_hz;
+	u32 sys_clk;
+	u32 adc_clk;
+
+	/* depends on adc_clk and Ovr mode */
+	u32 fe_clk;
+
+	bool m_has_dvbc;
+	bool m_has_dvbt;
+	bool firmware_loaded;
+};
+
+#define DEBUG_OTHER	0x01
+#define DEBUG_I2C_WRITE	0x02
+#define DEBUG_I2C_READ	0x04
+#define DEBUG_REG_READ	0x08
+#define DEBUG_REG_WRITE	0x10
+#define DEBUG_FW_LOAD	0x20
+
+static int debug = 0x00;
+
+#define dprintk(args...) \
+	do { \
+		if (debug & DEBUG_OTHER) \
+			printk(KERN_DEBUG "si2165: " args); \
+	} while (0)
+
+#define deb_i2c_write(args...) \
+	do { \
+		if (debug & DEBUG_I2C_WRITE) \
+			printk(KERN_DEBUG "si2165: i2c write: " args); \
+	} while (0)
+
+#define deb_i2c_read(args...) \
+	do { \
+		if (debug & DEBUG_I2C_READ) \
+			printk(KERN_DEBUG "si2165: i2c read: " args); \
+	} while (0)
+
+#define deb_readreg(args...) \
+	do { \
+		if (debug & DEBUG_REG_READ) \
+			printk(KERN_DEBUG "si2165: reg read: " args); \
+	} while (0)
+
+#define deb_writereg(args...) \
+	do { \
+		if (debug & DEBUG_REG_WRITE) \
+			printk(KERN_DEBUG "si2165: reg write: " args); \
+	} while (0)
+
+#define deb_fw_load(args...) \
+	do { \
+		if (debug & DEBUG_FW_LOAD) \
+			printk(KERN_DEBUG "si2165: fw load: " args); \
+	} while (0)
+
+static int si2165_write(struct si2165_state *state, const u16 reg,
+		       const u8 *src, const int count)
+{
+	int ret;
+	struct i2c_msg msg;
+	u8 buf[2 + 4]; /* write a maximum of 4 bytes of data */
+	if (count + 2 > sizeof(buf)) {
+		dev_warn(&state->i2c->dev,
+			  "%s: i2c wr reg=%04x: count=%d is too big!\n",
+			  KBUILD_MODNAME, reg, count);
+		return -EINVAL;
+	}
+	buf[0] = reg >> 8;
+	buf[1] = reg & 0xff;
+	memcpy(buf + 2, src, count);
+
+	msg.addr = state->config.i2c_addr;
+	msg.flags = 0;
+	msg.buf = buf;
+	msg.len = count + 2;
+
+	if (debug & DEBUG_I2C_WRITE) {
+		int i;
+		deb_i2c_write("reg: 0x%04x, data:", reg);
+		for (i = 0; i < count; i++)
+			printk(KERN_CONT " %02x", src[i]);
+		printk(KERN_CONT "\n");
+	}
+
+	ret = i2c_transfer(state->i2c, &msg, 1);
+
+	if (ret != 1) {
+		dev_err(&state->i2c->dev, "%s: ret == %d\n", __func__, ret);
+		return -EREMOTEIO;
+	}
+
+	return 0;
+}
+
+static int si2165_read(struct si2165_state *state,
+		       const u16 reg, u8 *val, const size_t count)
+{
+	int ret;
+	u8 reg_buf[] = { reg >> 8, reg & 0xff };
+	struct i2c_msg msg[] = {
+		{ .addr = state->config.i2c_addr,
+		  .flags = 0, .buf = reg_buf, .len = 2 },
+		{ .addr = state->config.i2c_addr,
+		  .flags = I2C_M_RD, .buf = val, .len = count },
+	};
+
+	ret = i2c_transfer(state->i2c, msg, 2);
+
+	if (ret != 2) {
+		dev_err(&state->i2c->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
+			__func__, state->config.i2c_addr, reg, ret);
+		if (ret < 0)
+			return ret;
+		else
+			return -EREMOTEIO;
+	}
+
+	if (debug & DEBUG_I2C_READ) {
+		int i;
+		deb_i2c_read("reg: 0x%04x, data:", reg);
+		for (i = 0; i < count; i++)
+			printk(KERN_CONT " %02x", val[i]);
+		printk(KERN_CONT "\n");
+	}
+	return 0;
+}
+
+static int si2165_readreg8(struct si2165_state *state,
+		       const u16 reg, u8 *val)
+{
+	int ret;
+	ret = si2165_read(state, reg, val, 1);
+	deb_readreg("R(0x%04x)=0x%02x\n", reg, *val);
+	return ret;
+}
+
+static int si2165_readreg16(struct si2165_state *state,
+		       const u16 reg, u16 *val)
+{
+	u8 buf[2];
+	int ret = si2165_read(state, reg, buf, 2);
+	*val = buf[0] | buf[1] << 8;
+	deb_readreg("R(0x%04x)=0x%04x\n", reg, *val);
+	return ret;
+}
+
+#if 0
+static int si2165_readreg24(struct si2165_state *state,
+		       const u16 reg, u32 *val)
+{
+	u8 buf[3];
+	int ret = si2165_read(state, reg, buf, 3);
+	*val = buf[0] | buf[1] << 8 | buf[2] << 16;
+	deb_readreg("R(0x%04x)=0x%06x\n", reg, *val);
+	return ret;
+}
+
+static int si2165_readreg32(struct si2165_state *state,
+		       const u16 reg, u32 *val)
+{
+	u8 buf[4];
+	int ret = si2165_read(state, reg, buf, 4);
+	*val = buf[0] | buf[1] << 8 | buf[2] << 16 | buf[3] << 24;
+	deb_readreg("R(0x%04x)=0x%08x\n", reg, *val);
+	return ret;
+}
+#endif
+
+
+static int si2165_writereg8(struct si2165_state *state, const u16 reg, u8 val)
+{
+	return si2165_write(state, reg, &val, 1);
+}
+
+static int si2165_writereg16(struct si2165_state *state, const u16 reg, u16 val)
+{
+	u8 buf[2] = { val & 0xff, (val >> 8) & 0xff };
+	return si2165_write(state, reg, buf, 2);
+}
+
+static int si2165_writereg24(struct si2165_state *state, const u16 reg, u32 val)
+{
+	u8 buf[3] = { val & 0xff, (val >> 8) & 0xff, (val >> 16) & 0xff };
+	return si2165_write(state, reg, buf, 3);
+}
+
+static int si2165_writereg32(struct si2165_state *state, const u16 reg, u32 val)
+{
+	u8 buf[4] = {
+		val & 0xff,
+		(val >> 8) & 0xff,
+		(val >> 16) & 0xff,
+		(val >> 24) & 0xff
+	};
+	return si2165_write(state, reg, buf, 4);
+}
+
+static int si2165_writereg_mask8(struct si2165_state *state, const u16 reg,
+				 u8 val, u8 mask)
+{
+	int ret;
+	u8 tmp;
+
+	if (mask != 0xff) {
+		ret = si2165_readreg8(state, reg, &tmp);
+		if (ret < 0)
+			goto err;
+
+		val &= mask;
+		tmp &= ~mask;
+		val |= tmp;
+	}
+
+	ret = si2165_writereg8(state, reg, val);
+err:
+	return ret;
+}
+
+static int si2165_get_tune_settings(struct dvb_frontend *fe,
+				    struct dvb_frontend_tune_settings *s)
+{
+	s->min_delay_ms = 1000;
+	return 0;
+}
+
+static int si2165_init_pll(struct si2165_state *state)
+{
+	u8 ref_freq_MHz = state->config.ref_freq_MHz;
+	/* u8 val; */
+	u8 divr = 1; /* 1..7 */
+	u8 divp = 1; /* only 1 or 4 */
+	u8 divn = 56; /* 1..63 */
+
+	u8 divm = 8;
+	u8 divl = 12;
+	u8 buf[4];
+
+	/* ref_freq / divr must be between 4 and 16 MHz */
+	if (ref_freq_MHz > 16)
+		divr = 2;
+
+	/* now select divn and divp such that fvco is in 1624..1824 MHz */
+	if (1624 * divr > ref_freq_MHz * 2 * 63)
+		divp = 4;
+
+	/* to get exactly the same as the windows driver does */
+	if (ref_freq_MHz == 16)
+		divn = 56;
+	else {
+		/* is this already correct regarding rounding? */
+		divn = 1624 * divr / (ref_freq_MHz * 2 * divp);
+	}
+
+	/* adc_clk and sys_clk depend on xtal and pll settings */
+	/* only calculate once as long as the pll settings are not modified */
+	if (state->adc_clk == 0) {
+		u32 fvco_hz = ref_freq_MHz * 1000000ull / divr
+				* 2 * divn * divp;
+		state->adc_clk = fvco_hz / (divm * 4);
+		state->sys_clk = fvco_hz / (divl * 2);
+	}
+
+	/* write pll registers 0x00a0..0x00a3 at once */
+	buf[0] = divl;
+	buf[1] = divm;
+	buf[2] = (divn & 0x3f) | ((divp == 1) ? 0x40 : 0x00) | 0x80;
+	buf[3] = divr;
+	si2165_write(state, 0x00a0 /* first pll reg */, buf, 4);
+
+	return 0;
+}
+
+static bool si2165_wait_init_done(struct si2165_state *state)
+{
+	int ret = false;
+	u8 val;
+	int i;
+	for (i = 0; i < 10; i++) {
+		si2165_readreg8(state, 0x0054 /* init_done */, &val);
+		if (val == 0x01) {
+			ret = true;
+			break;
+		}
+		msleep(1);
+	}
+	return ret;
+}
+
+static int si2165_upload_firmware_block(struct si2165_state *state, const u8 *data, u32 len, u32 *poffset, u32 block_count)
+{
+	u8 buf_ctrl[4] = { 0x00, 0x00, 0x00, 0xc0 };
+	u8 wordcount;
+	u32 cur_block = 0;
+	u32 offset = poffset ? *poffset : 0;
+	if (len < 4)
+		return -EINVAL;
+	if (len % 4 != 0)
+		return -EINVAL;
+
+	deb_fw_load("si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
+				len, offset, block_count);
+	while (offset+12 <= len && cur_block < block_count) {
+		deb_fw_load("si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+					len, offset, cur_block, block_count);
+		wordcount = data[offset];
+		if (wordcount < 1 || data[offset+1] || data[offset+2] || data[offset+3]) {
+			dev_warn(&state->i2c->dev, "%s: bad fw data[0..3] = %02x %02x %02x %02x\n", KBUILD_MODNAME, data[0], data[1], data[2], data[3]);
+			return -EINVAL;
+		}
+
+		if (offset + 8 + wordcount * 4 > len) {
+			dev_warn(&state->i2c->dev, "%s: len is too small for block len=%d, wordcount=%d\n", KBUILD_MODNAME, len, wordcount);
+			return -EINVAL;
+		}
+
+		buf_ctrl[0] = wordcount - 1;
+
+		si2165_write(state, 0x0364, buf_ctrl, 4);
+		si2165_write(state, 0x0368, data+offset+4, 4);
+
+		offset += 8;
+
+		while (wordcount > 0) {
+			si2165_write(state, 0x36c, data+offset, 4);
+			wordcount--;
+			offset += 4;
+		}
+		cur_block++;
+	}
+
+	deb_fw_load("si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+				len, offset, cur_block, block_count);
+
+	if (poffset)
+		*poffset = offset;
+
+	deb_fw_load("si2165_upload_firmware_block returned offset=0x%x\n",
+				offset);
+
+	return 0;
+}
+
+static int si2165_upload_firmware(struct si2165_state *state)
+{
+	/* int ret; */
+	u8 val[3];
+	u16 val16;
+	int ret;
+
+	const struct firmware *fw = NULL;
+	u8 *fw_file = SI2165_FIRMWARE;
+	const u8 *data;
+	u32 len;
+	u32 offset;
+	u8 patch_version;
+	u8 block_count;
+	u16 crc_expected;
+
+	/* request the firmware, this will block and timeout */
+	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
+	if (ret) {
+		dev_warn(&state->i2c->dev, "%s: firmare file '%s' not found\n",
+				KBUILD_MODNAME, fw_file);
+		goto err;
+	}
+
+	data = fw->data;
+	len = fw->size;
+
+	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s' size=%d\n",
+			KBUILD_MODNAME, fw_file, len);
+
+	if (len % 4 != 0) {
+		dev_warn(&state->i2c->dev, "%s: firmware size is not multiple of 4\n",
+				KBUILD_MODNAME);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* check header (8 bytes) */
+	if (len < 8) {
+		dev_warn(&state->i2c->dev, "%s: firmware header is missing\n",
+				KBUILD_MODNAME);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (data[0] != 1 || data[1] != 0) {
+		dev_warn(&state->i2c->dev, "%s: firmware file version is wrong\n",
+				KBUILD_MODNAME);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	patch_version = data[2];
+	block_count = data[4];
+	crc_expected = data[7] << 8 | data[6];
+
+	/* start uploading fw */
+	si2165_writereg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, 0x00);
+	si2165_writereg8(state, 0x00c0 /* rst_all */, 0x00);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+
+	si2165_readreg8(state, 0x035c /* en_rst_error */, val); /* returned 0x03 */
+	si2165_readreg8(state, 0x035c /* en_rst_error */, val); /* returned 0x03 */
+	si2165_writereg8(state, 0x035c /* en_rst_error */, 0x02);
+
+	/* start right after the header */
+	offset = 8;
+
+	dev_info(&state->i2c->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
+				KBUILD_MODNAME, patch_version, block_count, crc_expected);
+
+	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
+
+	si2165_writereg8(state, 0x0344 /* patch_version */, patch_version);
+
+	ret = si2165_writereg8(state, 0x0379 /* rst_crc */, 0x01);
+	if (ret)
+		return ret;
+
+	ret = si2165_upload_firmware_block(state, data, len, &offset, block_count);
+
+	if (ret) {
+		dev_err(&state->i2c->dev, "%s: firmare could not be uploaded\n",
+				KBUILD_MODNAME);
+		goto err;
+	}
+
+	ret = si2165_readreg16(state, 0x037a /* crc */, &val16); /* returned 0xcc0a */
+	if (ret)
+		goto err;
+
+	if (val16 != crc_expected) {
+		dev_err(&state->i2c->dev, "%s: firmware crc mismatch %04x != %04x\n", KBUILD_MODNAME, val16, crc_expected);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = si2165_upload_firmware_block(state, data, len, &offset, 5);
+	if (ret)
+		goto err;
+
+	if (len != offset) {
+		dev_err(&state->i2c->dev, "%s: firmare len mismatch %04x != %04x\n", KBUILD_MODNAME, len, offset);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	/* reset watchdog error register, using auto return value rst_wdog_error */
+	si2165_writereg_mask8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, 0x02, 0x02);
+
+	/* enable reset on error */
+	si2165_writereg_mask8(state, 0x035c /* en_rst_error */, 0x01, 0x01);
+
+	dev_info(&state->i2c->dev, "%s: fw load finished\n", KBUILD_MODNAME);
+
+	ret = 0;
+	state->firmware_loaded = true;
+err:
+	if (fw) {
+		release_firmware(fw);
+		fw = NULL;
+	}
+
+	return ret;
+}
+
+static int si2165_init_dsp(struct si2165_state *state)
+{
+	u8 val;
+	u8 patch_version = 0x00;
+
+	si2165_readreg8(state, 0x0344 /* patch_version */, &patch_version); /* returned 0x00 */
+
+	si2165_writereg8(state, 0x00cb, 0x00);
+	if (patch_version == 0x00)
+		si2165_writereg8(state, 0x0344 /* patch_version */, 0x00);
+
+	si2165_writereg32(state, 0x0348 /* dsp_addr_jump */, 0xf4000000);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, &val); /* returned 0x01 */
+
+	if (patch_version == 0x00)
+		si2165_upload_firmware(state);
+
+	return 0;
+}
+
+static int si2165_init(struct dvb_frontend *fe)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	u8 val;
+
+	dprintk("%s: called\n", __func__);
+
+	/* powerup */
+	si2165_writereg8(state, 0x0000 /* chip_mode */, state->config.chip_mode);
+	si2165_writereg8(state, 0x0104 /* dsp_clock_enable */, 0x01);
+	si2165_readreg8(state, 0x0000 /* chip_mode */, &val);
+	if (val != state->config.chip_mode) {
+		dev_err(&state->i2c->dev, "%s: could not set chip_mode\n",
+			KBUILD_MODNAME);
+		return -EINVAL;
+	}
+
+	si2165_writereg8(state, 0x018b /* agc_if_tri */, 0x00);
+	si2165_writereg8(state, 0x0190 /* agc_if_slr */, 0x01);
+	si2165_readreg8(state, 0x0170 /* agc2_{freeze,pola,buftype} */, &val); /* returned 0x00 */
+	si2165_writereg8(state, 0x0170 /* agc2_{freeze,pola,buftype} */, 0x00);
+	si2165_readreg8(state, 0x0170 /* agc2_{freeze,pola,buftype} */, &val); /* returned 0x00 */
+	si2165_writereg8(state, 0x0170 /* agc2_{freeze,pola,buftype} */, 0x00);
+	si2165_writereg8(state, 0x0171 /* agc2_clkdiv */, 0x07);
+	si2165_writereg8(state, 0x0646 /* rssi_pad_ctrl */, 0x00);
+	si2165_readreg8(state, 0x0641 /* en_rssi,start_rssi,rssi_update_time */, &val); /* returned 0x00 */
+	si2165_writereg8(state, 0x0641 /* en_rssi,start_rssi,rssi_update_time */, 0x00);
+	si2165_writereg8(state, 0x00e0 /* adc_sampling_mode */, 0x00);
+
+	si2165_init_pll(state);
+
+	si2165_writereg8(state, 0x0050 /* chip_init */, 0x01);
+	si2165_writereg8(state, 0x0096 /* start_init */, 0x01);
+	if (!si2165_wait_init_done(state)) {
+		dev_err(&state->i2c->dev, "%s: init_done was not set\n",
+			KBUILD_MODNAME);
+		return -EINVAL;
+	}
+
+	si2165_writereg8(state, 0x0050 /* chip_init */, 0x00);
+
+	si2165_writereg16(state, 0x0470 /* ber_pkt */, 0x7530);
+
+	si2165_init_dsp(state);
+
+	si2165_writereg8(state, 0x012a /* adc_ri1 */, 0x46);
+	si2165_writereg8(state, 0x012c /* adc_ri3 */, 0x00);
+	si2165_writereg8(state, 0x012e /* adc_ri5 */, 0x0a);
+	si2165_writereg8(state, 0x012f /* adc_ri6 */, 0xff);
+	si2165_writereg8(state, 0x0123 /* adc_ri8 */, 0x70);
+
+	return 0;
+}
+
+static int si2165_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	u8 val = enable ? 0x01 : 0x00;
+	return si2165_writereg8(state, 0x0001 /* i2c passthru */, val);
+}
+
+static int si2165_sleep(struct dvb_frontend *fe)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	dprintk("%s: called\n", __func__);
+	si2165_writereg8(state, 0x0104 /* dsp clock enable */, 0x00);
+	si2165_writereg8(state, 0x0000 /* chip mode */, SI2165_MODE_OFF);
+	return 0;
+}
+
+static int si2165_read_status(struct dvb_frontend *fe, fe_status_t *status)
+{
+	u8 fec_lock = 0;
+	struct si2165_state *state = fe->demodulator_priv;
+
+	if (!state->m_has_dvbt)
+		return -EINVAL;
+
+	/* seq1 */
+	si2165_readreg8(state, 0x4e0 /* fec_lock */, &fec_lock);
+	*status = 0;
+	if (fec_lock & 0x01) {
+		*status |= FE_HAS_SIGNAL;
+		*status |= FE_HAS_CARRIER;
+		*status |= FE_HAS_VITERBI;
+		*status |= FE_HAS_SYNC;
+		*status |= FE_HAS_LOCK;
+	}
+
+	return 0;
+}
+
+static int si2165_set_parameters(struct dvb_frontend *fe)
+{
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
+	struct si2165_state *state = fe->demodulator_priv;
+	u8 val[3];
+	u32 IF;
+	u32 dvb_rate = 0;
+
+	dprintk("%s: called\n", __func__);
+
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		pr_err("Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
+		return -EINVAL;
+	}
+
+	/* If Oversampling mode Ovr4 is used */
+	state->fe_clk = state->adc_clk;
+
+	if (state->fe_clk == 0) {
+		pr_err("Error: fe_clk is 0\n");
+		return -EINVAL;
+	}
+
+	if (!state->m_has_dvbt)
+		return -EINVAL;
+
+	if (p->bandwidth_hz > 0)
+		dvb_rate = p->bandwidth_hz * 8 / 7;
+	else
+		dvb_rate = 8 * 8 / 7;
+
+	si2165_writereg8(state, 0x00ec /* standard */, 0x01);
+	si2165_writereg8(state, 0x00a0 /* pll_divl */, 0x0c);
+
+	si2165_readreg8(state, 0x00e0 /* adc_sampling_mode */, val); /* returned 0x00 */
+	si2165_writereg32(state, 0x00e8 /* if_freq_shift */, 0x00000000);
+	si2165_writereg8(state, 0x08f8 /* unknown_wr8 */, 0x00);
+	si2165_readreg8(state, 0x04e4 /* ts_output_mode */, val); /* returned 0x21 */
+	si2165_writereg8(state, 0x04e4 /* ts_output_mode */, 0x20);
+	si2165_writereg16(state, 0x04ef /* ts_data_tri */, 0x00fe);
+	si2165_writereg24(state, 0x04f4 /* ts_data0-3_slr */, 0x555555);
+	si2165_readreg8(state, 0x04e4 /* ts_output_mode */, val); /* returned 0x20 */
+	si2165_writereg8(state, 0x04e4 /* ts_output_mode */, 0x20);
+	si2165_readreg8(state, 0x04e5 /* ts_clock */, val); /* returned 0x03 */
+	si2165_writereg8(state, 0x04e5 /* ts_clock */, 0x03);
+	si2165_readreg8(state, 0x04e5 /* ts_clock */, val); /* returned 0x03 */
+	si2165_writereg8(state, 0x04e5 /* ts_clock */, 0x01);
+	si2165_writereg16(state, 0x0308 /* bandwidth */, 0x0320);
+	si2165_writereg32(state, 0x00e4 /* oversamp */, 0x03100000);
+	si2165_writereg8(state, 0x031c /* impulsive_noise_remover */, 0x01);
+	si2165_writereg8(state, 0x00cb /* unknown_wr8 */, 0x00);
+	si2165_writereg8(state, 0x016e /* agc2_min */, 0x41);
+	si2165_writereg8(state, 0x016c /* agc2_kacq */, 0x0e);
+	si2165_writereg8(state, 0x016d /* agc2_kloc */, 0x10);
+	si2165_writereg8(state, 0x015b /* agc_unfreeze_thr */, 0x03);
+	si2165_writereg8(state, 0x0150 /* agc_crestf_dbx8 */, 0x78);
+	si2165_writereg8(state, 0x01a0 /* aaf_crestf_dbx8 */, 0x78);
+	si2165_writereg8(state, 0x01c8 /* aci_crestf_dbx8 */, 0x68);
+	si2165_writereg16(state, 0x030c /* freq_sync_range */, 0x0064);
+	si2165_readreg8(state, 0x0387 /* gp_reg0 */, val); /* returned 0x00 */
+	si2165_writereg8(state, 0x0387 /* gp_reg0 */, 0x00);
+	si2165_writereg32(state, 0x0348 /* dsp_addr_jump */, 0xf4000000);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+	si2165_writereg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, 0x00);
+	si2165_writereg8(state, 0x00c0 /* rst_all */, 0x00);
+	si2165_writereg32(state, 0x0384 /* gp_reg0 */, 0x00000000);
+	si2165_writereg8(state, 0x02e0 /* start_synchro */, 0x01);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+	si2165_writereg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, 0x00);
+	si2165_writereg8(state, 0x00c0 /* rst_all */, 0x00);
+	si2165_writereg32(state, 0x0384 /* gp_reg0 */, 0x00000000);
+	si2165_writereg8(state, 0x02e0 /* start_synchro */, 0x01);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+	si2165_readreg8(state, 0x0118 /* dvb-c standard support */, val); /* returned 0x07 */
+	si2165_readreg8(state, 0x0023 /* hardware_rev */, val); /* returned 0x03 */
+	si2165_writereg8(state, 0x018b /* agc_if_tri */, 0x00);
+	si2165_writereg8(state, 0x08f8 /* unknown_wr8 */, 0x00);
+	si2165_readreg8(state, 0x04e4 /* ts_output_mode */, val); /* returned 0x20 */
+	si2165_writereg8(state, 0x04e4 /* ts_output_mode */, 0x20);
+	si2165_writereg16(state, 0x04ef /* ts_data_tri */, 0x00fe);
+	si2165_writereg24(state, 0x04f4 /* ts_data0-3_slr */, 0x555555);
+	si2165_readreg8(state, 0x04e4 /* ts_output_mode */, val); /* returned 0x20 */
+	si2165_writereg8(state, 0x04e4 /* ts_output_mode */, 0x20);
+	si2165_readreg8(state, 0x04e5 /* ts_clock */, val); /* returned 0x01 */
+	si2165_writereg8(state, 0x04e5 /* ts_clock */, 0x01);
+	si2165_readreg8(state, 0x04e5 /* ts_clock */, val); /* returned 0x01 */
+	si2165_writereg8(state, 0x04e5 /* ts_clock */, 0x01);
+
+	if (dvb_rate == 0) {
+		pr_err("Error: dvb_rate is 0\n");
+		return -EINVAL;
+	}
+
+	if (fe->ops.tuner_ops.set_params) {
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 1);
+		fe->ops.tuner_ops.set_params(fe);
+		if (fe->ops.i2c_gate_ctrl)
+			fe->ops.i2c_gate_ctrl(fe, 0);
+	}
+
+	{
+		s64 if_freq_shift;
+		u32 reg_value;
+		fe->ops.tuner_ops.get_if_frequency(fe, &IF);
+
+		if_freq_shift = IF;
+		if_freq_shift <<= 29;
+		if (state->fe_clk > 0)
+			if_freq_shift /= (u64)state->fe_clk;
+		reg_value = ((u32)if_freq_shift) & 0x1fffffff;
+
+		si2165_writereg32(state, 0x00e8 /* if_freq_shift */, reg_value);
+	}
+
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+	si2165_writereg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, 0x00);
+	si2165_writereg8(state, 0x00c0 /* rst_all */, 0x00);
+	si2165_writereg32(state, 0x0384 /* gp_reg0 */, 0x00000000);
+	si2165_writereg8(state, 0x02e0 /* start_synchro */, 0x01);
+	si2165_readreg8(state, 0x0341 /* boot_done,rst_wdog_error,wdog_error */, val); /* returned 0x01 */
+
+	return 0;
+}
+
+static void si2165_release(struct dvb_frontend *fe)
+{
+	struct si2165_state *state = fe->demodulator_priv;
+	dprintk("%s: called\n", __func__);
+	kfree(state);
+}
+
+static struct dvb_frontend_ops si2165_ops = {
+	.info = {
+		.name			= "SI2165",
+		.caps =	FE_CAN_FEC_1_2 |
+			FE_CAN_FEC_2_3 |
+			FE_CAN_FEC_3_4 |
+			FE_CAN_FEC_5_6 |
+			FE_CAN_FEC_7_8 |
+			FE_CAN_FEC_AUTO |
+			FE_CAN_QPSK |
+			FE_CAN_QAM_16 |
+			FE_CAN_QAM_32 |
+			FE_CAN_QAM_64 |
+			FE_CAN_QAM_128 |
+			FE_CAN_QAM_256 |
+			FE_CAN_QAM_AUTO |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_GUARD_INTERVAL_AUTO |
+			FE_CAN_HIERARCHY_AUTO |
+			FE_CAN_MUTE_TS |
+			FE_CAN_TRANSMISSION_MODE_AUTO |
+			FE_CAN_RECOVER
+	},
+
+	.get_tune_settings = si2165_get_tune_settings,
+
+	.init = si2165_init,
+	.sleep = si2165_sleep,
+
+	.i2c_gate_ctrl     = si2165_i2c_gate_ctrl,
+
+	.set_frontend      = si2165_set_parameters,
+	.read_status       = si2165_read_status,
+
+	.release = si2165_release,
+};
+
+struct dvb_frontend *si2165_attach(const struct si2165_config *config, struct i2c_adapter *i2c)
+{
+	struct si2165_state *state = NULL;
+	int n;
+
+	if (config == NULL)
+		goto error;
+
+	/* allocate memory for the internal state */
+	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
+	if (state == NULL)
+		goto error;
+
+	/* setup the state */
+	state->i2c = i2c;
+	state->config = *config;
+
+	if (state->config.ref_freq_MHz < 4 || state->config.ref_freq_MHz > 27) {
+		dev_info(&state->i2c->dev, "%s: ref_freq of %d MHz not supported by this driver\n",
+			 KBUILD_MODNAME, state->config.ref_freq_MHz);
+		goto error;
+	}
+
+	/* create dvb_frontend */
+	memcpy(&state->frontend.ops, &si2165_ops,
+		sizeof(struct dvb_frontend_ops));
+	state->frontend.demodulator_priv = state;
+
+	/* powerup */
+	if (si2165_writereg8(state, 0x0000 /* chip_mode */, state->config.chip_mode) < 0)
+		  goto error;
+
+	if (si2165_readreg8(state, 0x0023 /* rev code */, &state->revcode) < 0)
+		  goto error;
+
+	if (si2165_readreg8(state, 0x0118 /* chip type */, &state->chip_type) < 0)
+		  goto error;
+
+	/* powerdown */
+	if (si2165_writereg8(state, 0x0000 /* chip_mode */, SI2165_MODE_OFF) < 0)
+		  goto error;
+
+	dev_info(&state->i2c->dev, "%s: hardware revision 0x%02x, chip type 0x%02x\n",
+		 KBUILD_MODNAME, state->revcode, state->chip_type);
+
+	if (state->revcode != 0x03) {
+		dev_err(&state->i2c->dev, "%s: Unsupported hardware revision.\n",
+			KBUILD_MODNAME);
+		goto error;
+	}
+
+	/* It is a guess that register 0x0118 (chip type?) can be used to
+	 * differ between si2161, si2163 and si2165
+	 * Only si2165 has been tested.
+	 */
+	if (state->chip_type == 0x07) {
+		state->m_has_dvbt = true;
+		state->m_has_dvbc = true;
+		strcpy(state->frontend.ops.info.name, "SI2165");
+	} else {
+		dev_err(&state->i2c->dev, "%s: Unsupported Chip type.\n",
+			KBUILD_MODNAME);
+		goto error;
+	}
+
+	n = 0;
+	if (state->m_has_dvbt) {
+		state->frontend.ops.delsys[n++] = SYS_DVBT;
+		strlcat(state->frontend.ops.info.name, " DVB-T",
+			sizeof(state->frontend.ops.info.name));
+	}
+	if (state->m_has_dvbc)
+		dev_warn(&state->i2c->dev, "%s: DVB-C is not yet supported.\n",
+		       KBUILD_MODNAME);
+
+	return &state->frontend;
+
+error:
+	kfree(state);
+	return NULL;
+}
+EXPORT_SYMBOL(si2165_attach);
+
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
+
+MODULE_DESCRIPTION("Silicon Labs si2165 DVB-C/-T Demodulator driver");
+MODULE_AUTHOR("Matthias Schwarzott <zzam@gentoo.org>");
+MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(SI2165_FIRMWARE);
diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
new file mode 100644
index 0000000..cdc12e7
--- /dev/null
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -0,0 +1,61 @@
+/*
+    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+
+    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    References:
+    http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
+*/
+
+#ifndef _DVB_SI2165_H
+#define _DVB_SI2165_H
+
+#include <linux/dvb/frontend.h>
+
+#if IS_ENABLED(CONFIG_DVB_SI2165)
+
+enum {
+	SI2165_MODE_OFF = 0x00,
+	SI2165_MODE_PLL_EXT = 0x20,
+	SI2165_MODE_PLL_XTAL = 0x21
+};
+
+struct si2165_config {
+	/* i2c addr
+	 * possible values: 0x64,0x65,0x66,0x67 */
+	u8 i2c_addr;
+
+	/* external clock or XTAL */
+	u8 chip_mode;
+
+	/* frequency of external clock or xtal in Mhz
+	 * possible values: 4,16,20,24,27 in
+	 */
+	u8 ref_freq_MHz;
+};
+
+/* Addresses: 0x64,0x65,0x66,0x67 */
+struct dvb_frontend *si2165_attach(
+	const struct si2165_config *config,
+	struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *si2165_attach(
+	const struct si2165_config *config,
+	struct i2c_adapter *i2c)
+{
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
+	return NULL;
+}
+#endif /* CONFIG_DVB_SI2165 */
+
+#endif /* _DVB_SI2165_H */
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
new file mode 100644
index 0000000..d4cc93f
--- /dev/null
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -0,0 +1,23 @@
+/*
+    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+
+    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+*/
+
+#ifndef _DVB_SI2165_PRIV
+#define _DVB_SI2165_PRIV
+
+#define SI2165_FIRMWARE "dvb-demod-si2165.fw"
+
+#endif /* _DVB_SI2165_PRIV */
-- 
1.9.0

