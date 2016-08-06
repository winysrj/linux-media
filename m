Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:16266 "EHLO
	mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbcHFUHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Aug 2016 16:07:02 -0400
Received: from ghp.homelinuxserver.org (localhost [127.0.0.1])
	by ghp.homelinuxserver.org (8.14.4/8.14.4/Debian-8) with ESMTP id u76Fb8a8004921
	for <linux-media@vger.kernel.org>; Sat, 6 Aug 2016 16:37:08 +0100
Received: (from root@localhost)
	by ghp.homelinuxserver.org (8.14.4/8.14.4/Submit) id u76Fb78v004919
	for linux-media@vger.kernel.org; Sat, 6 Aug 2016 16:37:07 +0100
Date: Sat, 6 Aug 2016 16:37:07 +0100
From: g.h.p@skynet.be
Message-Id: <201608061537.u76Fb78v004919@ghp.homelinuxserver.org>
Subject: [PATCH] Enable DVB-T with Terratec Cinergy HTC Stick HD (0ccb:0101)
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


This patch allows the Terratec Cinergy HTC Stick HD (0ccb:0101) to be used to watch DVB-T with Kaffeine, and to use its "grabber" 
functionality with Mplayer.  For the latter, no code had to be modified, it acts exactly as a "connexant video grabber". 

The patch is generated from a Linux kernel 4.6.1, to which I applied Matthias Schwarzott's patches from 26/07/2016 - as a
consequence, his work is included here, please tell me how to separate it when that's necessary.  My patch will conflict with the
one from Oleh Kravchenko 04/08/2016.

I haven't got a clue what I am messing with: no experience with TV hardware, no understanding of I2C programming, my changes are based on USB snooping and what I found in the Windows driver's .inf.   Eg. "write pll registers 0x00a0..0x00a3 at once" is no longer true.  Won't this break other HW?

Signed-off-by: Gerard H. Pille <g.h.p@skynet.be>
---
 drivers/media/dvb-frontends/Kconfig        |   1 +
 drivers/media/dvb-frontends/si2165.c       | 278 +++++++++++++++++------------
 drivers/media/dvb-frontends/si2165.h       |  27 +--
 drivers/media/dvb-frontends/si2165_priv.h  |  17 ++
 drivers/media/pci/cx23885/cx23885-dvb.c    |  30 +++-
 drivers/media/tuners/si2157.c              |  52 ++++--
 drivers/media/tuners/si2157_priv.h         |   2 +
 drivers/media/tuners/tuner-types.c         |   4 +
 drivers/media/usb/cx231xx/cx231xx-avcore.c |   8 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c  |  57 +++++-
 drivers/media/usb/cx231xx/cx231xx-core.c   |   3 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c    | 168 ++++++++++++++---
 drivers/media/usb/cx231xx/cx231xx.h        |   2 +
 include/media/tuner.h                      |   2 +
 14 files changed, 461 insertions(+), 190 deletions(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index c645aa8..8272c08 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -67,6 +67,7 @@ config DVB_TDA18271C2DD
 config DVB_SI2165
 	tristate "Silicon Labs si2165 based"
 	depends on DVB_CORE && I2C
+	select REGMAP_I2C
 	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  A DVB-C/T demodulator.
diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 8bf716a..efbc43e 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -25,6 +25,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
+#include <linux/regmap.h>
 
 #include "dvb_frontend.h"
 #include "dvb_math.h"
@@ -40,7 +41,9 @@
  */
 
 struct si2165_state {
-	struct i2c_adapter *i2c;
+	struct i2c_client *client;
+
+	struct regmap *regmap;
 
 	struct dvb_frontend fe;
 
@@ -108,61 +111,27 @@ static int si2165_write(struct si2165_state *state, const u16 reg,
 		       const u8 *src, const int count)
 {
 	int ret;
-	struct i2c_msg msg;
-	u8 buf[2 + 4]; /* write a maximum of 4 bytes of data */
-
-	if (count + 2 > sizeof(buf)) {
-		dev_warn(&state->i2c->dev,
-			  "%s: i2c wr reg=%04x: count=%d is too big!\n",
-			  KBUILD_MODNAME, reg, count);
-		return -EINVAL;
-	}
-	buf[0] = reg >> 8;
-	buf[1] = reg & 0xff;
-	memcpy(buf + 2, src, count);
-
-	msg.addr = state->config.i2c_addr;
-	msg.flags = 0;
-	msg.buf = buf;
-	msg.len = count + 2;
 
 	if (debug & DEBUG_I2C_WRITE)
 		deb_i2c_write("reg: 0x%04x, data: %*ph\n", reg, count, src);
 
-	ret = i2c_transfer(state->i2c, &msg, 1);
+	ret = regmap_bulk_write(state->regmap, reg, src, count);
 
-	if (ret != 1) {
-		dev_err(&state->i2c->dev, "%s: ret == %d\n", __func__, ret);
-		if (ret < 0)
-			return ret;
-		else
-			return -EREMOTEIO;
-	}
+	if (ret)
+		dev_err(&state->client->dev, "%s: ret == %d\n", __func__, ret);
 
-	return 0;
+	return ret;
 }
 
 static int si2165_read(struct si2165_state *state,
 		       const u16 reg, u8 *val, const int count)
 {
-	int ret;
-	u8 reg_buf[] = { reg >> 8, reg & 0xff };
-	struct i2c_msg msg[] = {
-		{ .addr = state->config.i2c_addr,
-		  .flags = 0, .buf = reg_buf, .len = 2 },
-		{ .addr = state->config.i2c_addr,
-		  .flags = I2C_M_RD, .buf = val, .len = count },
-	};
-
-	ret = i2c_transfer(state->i2c, msg, 2);
+	int ret = regmap_bulk_read(state->regmap, reg, val, count);
 
-	if (ret != 2) {
-		dev_err(&state->i2c->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
+	if (ret) {
+		dev_err(&state->client->dev, "%s: error (addr %02x reg %04x error (ret == %i)\n",
 			__func__, state->config.i2c_addr, reg, ret);
-		if (ret < 0)
-			return ret;
-		else
-			return -EREMOTEIO;
+		return ret;
 	}
 
 	if (debug & DEBUG_I2C_READ)
@@ -174,9 +143,9 @@ static int si2165_read(struct si2165_state *state,
 static int si2165_readreg8(struct si2165_state *state,
 		       const u16 reg, u8 *val)
 {
-	int ret;
-
-	ret = si2165_read(state, reg, val, 1);
+	unsigned int val_tmp;
+	int ret = regmap_read(state->regmap, reg, &val_tmp);
+	*val = (u8)val_tmp;
 	deb_readreg("R(0x%04x)=0x%02x\n", reg, *val);
 	return ret;
 }
@@ -194,7 +163,7 @@ static int si2165_readreg16(struct si2165_state *state,
 
 static int si2165_writereg8(struct si2165_state *state, const u16 reg, u8 val)
 {
-	return si2165_write(state, reg, &val, 1);
+	return regmap_write(state->regmap, reg, val);
 }
 
 static int si2165_writereg16(struct si2165_state *state, const u16 reg, u16 val)
@@ -206,20 +175,23 @@ static int si2165_writereg16(struct si2165_state *state, const u16 reg, u16 val)
 
 static int si2165_writereg24(struct si2165_state *state, const u16 reg, u32 val)
 {
+	int ret;
 	u8 buf[3] = { val & 0xff, (val >> 8) & 0xff, (val >> 16) & 0xff };
 
-	return si2165_write(state, reg, buf, 3);
+	ret = si2165_write(state, reg, buf, 2);
+	if (ret == 0)
+		return si2165_write(state, reg+2, buf+2, 1);
+	return ret;
 }
 
 static int si2165_writereg32(struct si2165_state *state, const u16 reg, u32 val)
 {
-	u8 buf[4] = {
-		val & 0xff,
-		(val >> 8) & 0xff,
-		(val >> 16) & 0xff,
-		(val >> 24) & 0xff
-	};
-	return si2165_write(state, reg, buf, 4);
+	int ret;
+	ret = si2165_writereg16(state, reg, val & 0xffff);
+	if (ret == 0) {
+		ret = si2165_writereg16(state, reg+2, (val >> 16)  & 0xffff);
+	}
+	return ret;
 }
 
 static int si2165_writereg_mask8(struct si2165_state *state, const u16 reg,
@@ -276,6 +248,7 @@ static int si2165_init_pll(struct si2165_state *state)
 	u8 divm = 8;
 	u8 divl = 12;
 	u8 buf[4];
+	int ret;
 
 	/*
 	 * hardcoded values can be deleted if calculation is verified
@@ -316,9 +289,18 @@ static int si2165_init_pll(struct si2165_state *state)
 	/* write pll registers 0x00a0..0x00a3 at once */
 	buf[0] = divl;
 	buf[1] = divm;
+	/*
 	buf[2] = (divn & 0x3f) | ((divp == 1) ? 0x40 : 0x00) | 0x80;
 	buf[3] = divr;
 	return si2165_write(state, 0x00a0, buf, 4);
+	*/
+	ret = si2165_write(state, 0x00a0, buf, 2);
+	if  (ret == 0) {
+		buf[0] = (divn & 0x3f) | ((divp == 1) ? 0x40 : 0x00) | 0x80;
+		buf[1] = divr;
+		ret = si2165_write(state, 0x00a2, buf, 2);
+	}
+	return ret;
 }
 
 static int si2165_adjust_pll_divl(struct si2165_state *state, u8 divl)
@@ -345,7 +327,7 @@ static int si2165_wait_init_done(struct si2165_state *state)
 			return 0;
 		usleep_range(1000, 50000);
 	}
-	dev_err(&state->i2c->dev, "%s: init_done was not set\n",
+	dev_err(&state->client->dev, "%s: init_done was not set\n",
 		KBUILD_MODNAME);
 	return ret;
 }
@@ -374,14 +356,14 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		wordcount = data[offset];
 		if (wordcount < 1 || data[offset+1] ||
 		    data[offset+2] || data[offset+3]) {
-			dev_warn(&state->i2c->dev,
+			dev_warn(&state->client->dev,
 				 "%s: bad fw data[0..3] = %*ph\n",
 				KBUILD_MODNAME, 4, data);
 			return -EINVAL;
 		}
 
 		if (offset + 8 + wordcount * 4 > len) {
-			dev_warn(&state->i2c->dev,
+			dev_warn(&state->client->dev,
 				 "%s: len is too small for block len=%d, wordcount=%d\n",
 				KBUILD_MODNAME, len, wordcount);
 			return -EINVAL;
@@ -389,17 +371,26 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 
 		buf_ctrl[0] = wordcount - 1;
 
-		ret = si2165_write(state, 0x0364, buf_ctrl, 4);
+		ret = si2165_write(state, 0x0364, buf_ctrl, 2);
+		if (ret < 0)
+			goto error;
+		ret = si2165_write(state, 0x0366, buf_ctrl+2, 2);
 		if (ret < 0)
 			goto error;
-		ret = si2165_write(state, 0x0368, data+offset+4, 4);
+		ret = si2165_write(state, 0x0368, data+offset+4, 2);
+		if (ret < 0)
+			goto error;
+		ret = si2165_write(state, 0x036a, data+offset+6, 2);
 		if (ret < 0)
 			goto error;
 
 		offset += 8;
 
 		while (wordcount > 0) {
-			ret = si2165_write(state, 0x36c, data+offset, 4);
+			ret = si2165_write(state, 0x36c, data+offset, 2);
+			if (ret < 0)
+				goto error;
+			ret = si2165_write(state, 0x36e, data+offset+2, 2);
 			if (ret < 0)
 				goto error;
 			wordcount--;
@@ -444,15 +435,15 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		fw_file = SI2165_FIRMWARE_REV_D;
 		break;
 	default:
-		dev_info(&state->i2c->dev, "%s: no firmware file for revision=%d\n",
+		dev_info(&state->client->dev, "%s: no firmware file for revision=%d\n",
 			KBUILD_MODNAME, state->chip_revcode);
 		return 0;
 	}
 
 	/* request the firmware, this will block and timeout */
-	ret = request_firmware(&fw, fw_file, state->i2c->dev.parent);
+	ret = request_firmware(&fw, fw_file, &state->client->dev);
 	if (ret) {
-		dev_warn(&state->i2c->dev, "%s: firmware file '%s' not found\n",
+		dev_warn(&state->client->dev, "%s: firmware file '%s' not found\n",
 				KBUILD_MODNAME, fw_file);
 		goto error;
 	}
@@ -460,11 +451,11 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	data = fw->data;
 	len = fw->size;
 
-	dev_info(&state->i2c->dev, "%s: downloading firmware from file '%s' size=%d\n",
+	dev_info(&state->client->dev, "%s: downloading firmware from file '%s' size=%d\n",
 			KBUILD_MODNAME, fw_file, len);
 
 	if (len % 4 != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware size is not multiple of 4\n",
+		dev_warn(&state->client->dev, "%s: firmware size is not multiple of 4\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
@@ -472,14 +463,14 @@ static int si2165_upload_firmware(struct si2165_state *state)
 
 	/* check header (8 bytes) */
 	if (len < 8) {
-		dev_warn(&state->i2c->dev, "%s: firmware header is missing\n",
+		dev_warn(&state->client->dev, "%s: firmware header is missing\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
 	}
 
 	if (data[0] != 1 || data[1] != 0) {
-		dev_warn(&state->i2c->dev, "%s: firmware file version is wrong\n",
+		dev_warn(&state->client->dev, "%s: firmware file version is wrong\n",
 				KBUILD_MODNAME);
 		ret = -EINVAL;
 		goto error;
@@ -517,7 +508,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	/* start right after the header */
 	offset = 8;
 
-	dev_info(&state->i2c->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
+	dev_info(&state->client->dev, "%s: si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
 		KBUILD_MODNAME, patch_version, block_count, crc_expected);
 
 	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
@@ -536,7 +527,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	ret = si2165_upload_firmware_block(state, data, len,
 					   &offset, block_count);
 	if (ret < 0) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware could not be uploaded\n",
 			KBUILD_MODNAME);
 		goto error;
@@ -548,7 +539,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		goto error;
 
 	if (val16 != crc_expected) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware crc mismatch %04x != %04x\n",
 			KBUILD_MODNAME, val16, crc_expected);
 		ret = -EINVAL;
@@ -560,7 +551,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		goto error;
 
 	if (len != offset) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: firmware len mismatch %04x != %04x\n",
 			KBUILD_MODNAME, len, offset);
 		ret = -EINVAL;
@@ -577,7 +568,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret < 0)
 		goto error;
 
-	dev_info(&state->i2c->dev, "%s: fw load finished\n", KBUILD_MODNAME);
+	dev_info(&state->client->dev, "%s: fw load finished\n", KBUILD_MODNAME);
 
 	ret = 0;
 	state->firmware_loaded = true;
@@ -611,7 +602,7 @@ static int si2165_init(struct dvb_frontend *fe)
 	if (ret < 0)
 		goto error;
 	if (val != state->config.chip_mode) {
-		dev_err(&state->i2c->dev, "%s: could not set chip_mode\n",
+		dev_err(&state->client->dev, "%s: could not set chip_mode\n",
 			KBUILD_MODNAME);
 		return -EINVAL;
 	}
@@ -672,9 +663,13 @@ static int si2165_init(struct dvb_frontend *fe)
 		goto error;
 
 	/* dsp_addr_jump */
-	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
+	ret = si2165_writereg16(state, 0x0348, 0x0000);
+	if (ret < 0)
+		goto error;
+	ret = si2165_writereg16(state, 0x034a, 0xf400);
 	if (ret < 0)
 		goto error;
+
 	/* boot/wdog status */
 	ret = si2165_readreg8(state, 0x0341, &val);
 	if (ret < 0)
@@ -751,6 +746,9 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	u64 oversamp;
 	u32 reg_value;
 
+	if (!dvb_rate)
+		return -EINVAL;
+
 	oversamp = si2165_get_fe_clk(state);
 	oversamp <<= 23;
 	do_div(oversamp, dvb_rate);
@@ -769,12 +767,15 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 	u32 IF = 0;
 
 	if (!fe->ops.tuner_ops.get_if_frequency) {
-		dev_err(&state->i2c->dev,
+		dev_err(&state->client->dev,
 			"%s: Error: get_if_frequency() not defined at tuner. Can't work without it!\n",
 			KBUILD_MODNAME);
 		return -EINVAL;
 	}
 
+	if (!fe_clk)
+		return -EINVAL;
+
 	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	if_freq_shift = IF;
 	if_freq_shift <<= 29;
@@ -1003,14 +1004,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static void si2165_release(struct dvb_frontend *fe)
-{
-	struct si2165_state *state = fe->demodulator_priv;
-
-	dprintk("%s: called\n", __func__);
-	kfree(state);
-}
-
 static struct dvb_frontend_ops si2165_ops = {
 	.info = {
 		.name = "Silicon Labs ",
@@ -1046,67 +1039,83 @@ static struct dvb_frontend_ops si2165_ops = {
 
 	.set_frontend      = si2165_set_frontend,
 	.read_status       = si2165_read_status,
-
-	.release = si2165_release,
 };
 
-struct dvb_frontend *si2165_attach(const struct si2165_config *config,
-				   struct i2c_adapter *i2c)
+static int si2165_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
 {
 	struct si2165_state *state = NULL;
+	struct si2165_platform_data *pdata = client->dev.platform_data;
 	int n;
-	int io_ret;
+	int ret = 0;
 	u8 val;
 	char rev_char;
 	const char *chip_name;
-
-	if (config == NULL || i2c == NULL)
-		goto error;
+	static const struct regmap_config regmap_config = {
+		.reg_bits = 16,
+		.val_bits = 8,
+		.max_register = 0x08ff,
+	};
 
 	/* allocate memory for the internal state */
 	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
-	if (state == NULL)
+	if (state == NULL) {
+		ret = -ENOMEM;
 		goto error;
+	}
+
+	/* create regmap */
+	state->regmap = devm_regmap_init_i2c(client, &regmap_config);
+	if (IS_ERR(state->regmap)) {
+		ret = PTR_ERR(state->regmap);
+		goto error;
+	}
 
 	/* setup the state */
-	state->i2c = i2c;
-	state->config = *config;
+	state->client = client;
+	state->config.i2c_addr = client->addr;
+	state->config.chip_mode = pdata->chip_mode;
+	state->config.ref_freq_Hz = pdata->ref_freq_Hz;
+	state->config.inversion = pdata->inversion;
 
 	if (state->config.ref_freq_Hz < 4000000
 	    || state->config.ref_freq_Hz > 27000000) {
-		dev_err(&state->i2c->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
+		dev_err(&state->client->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
 			 KBUILD_MODNAME, state->config.ref_freq_Hz);
+		ret = -EINVAL;
 		goto error;
 	}
 
 	/* create dvb_frontend */
 	memcpy(&state->fe.ops, &si2165_ops,
 		sizeof(struct dvb_frontend_ops));
+	state->fe.ops.release = NULL;
 	state->fe.demodulator_priv = state;
+	i2c_set_clientdata(client, state);
 
 	/* powerup */
-	io_ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
-	if (io_ret < 0)
-		goto error;
+	ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
+	if (ret < 0)
+		goto nodev_error;
 
-	io_ret = si2165_readreg8(state, 0x0000, &val);
-	if (io_ret < 0)
-		goto error;
+	ret = si2165_readreg8(state, 0x0000, &val);
+	if (ret < 0)
+		goto nodev_error;
 	if (val != state->config.chip_mode)
-		goto error;
+		goto nodev_error;
 
-	io_ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
-	if (io_ret < 0)
-		goto error;
+	ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
+	if (ret < 0)
+		goto nodev_error;
 
-	io_ret = si2165_readreg8(state, 0x0118, &state->chip_type);
-	if (io_ret < 0)
-		goto error;
+	ret = si2165_readreg8(state, 0x0118, &state->chip_type);
+	if (ret < 0)
+		goto nodev_error;
 
 	/* powerdown */
-	io_ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
-	if (io_ret < 0)
-		goto error;
+	ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
+	if (ret < 0)
+		goto nodev_error;
 
 	if (state->chip_revcode < 26)
 		rev_char = 'A' + state->chip_revcode;
@@ -1124,12 +1133,12 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 		state->has_dvbc = true;
 		break;
 	default:
-		dev_err(&state->i2c->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
+		dev_err(&state->client->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
 			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
-		goto error;
+		goto nodev_error;
 	}
 
-	dev_info(&state->i2c->dev,
+	dev_info(&state->client->dev,
 		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
 		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
 		state->chip_revcode);
@@ -1149,13 +1158,46 @@ struct dvb_frontend *si2165_attach(const struct si2165_config *config,
 			sizeof(state->fe.ops.info.name));
 	}
 
-	return &state->fe;
+	/* return fe pointer */
+	*pdata->fe = &state->fe;
 
+	return 0;
+
+nodev_error:
+	ret = -ENODEV;
 error:
 	kfree(state);
-	return NULL;
+	dev_dbg(&client->dev, "failed=%d\n", ret);
+	return ret;
+}
+
+static int si2165_remove(struct i2c_client *client)
+{
+	struct si2165_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(state);
+	return 0;
 }
-EXPORT_SYMBOL(si2165_attach);
+
+static const struct i2c_device_id si2165_id_table[] = {
+	{"si2165", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, si2165_id_table);
+
+static struct i2c_driver si2165_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "si2165",
+	},
+	.probe		= si2165_probe,
+	.remove		= si2165_remove,
+	.id_table	= si2165_id_table,
+};
+
+module_i2c_driver(si2165_driver);
 
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
index 8a15d6a..76c2ca7 100644
--- a/drivers/media/dvb-frontends/si2165.h
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -28,10 +28,15 @@ enum {
 	SI2165_MODE_PLL_XTAL = 0x21
 };
 
-struct si2165_config {
-	/* i2c addr
-	 * possible values: 0x64,0x65,0x66,0x67 */
-	u8 i2c_addr;
+/* I2C addresses
+ * possible values: 0x64,0x65,0x66,0x67
+ */
+struct si2165_platform_data {
+	/*
+	 * frontend
+	 * returned by driver
+	 */
+	struct dvb_frontend **fe;
 
 	/* external clock or XTAL */
 	u8 chip_mode;
@@ -45,18 +50,4 @@ struct si2165_config {
 	bool inversion;
 };
 
-#if IS_REACHABLE(CONFIG_DVB_SI2165)
-struct dvb_frontend *si2165_attach(
-	const struct si2165_config *config,
-	struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend *si2165_attach(
-	const struct si2165_config *config,
-	struct i2c_adapter *i2c)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif /* CONFIG_DVB_SI2165 */
-
 #endif /* _DVB_SI2165_H */
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 2b70cf1..e593211 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -20,4 +20,21 @@
 
 #define SI2165_FIRMWARE_REV_D "dvb-demod-si2165.fw"
 
+struct si2165_config {
+	/* i2c addr
+	 * possible values: 0x64,0x65,0x66,0x67 */
+	u8 i2c_addr;
+
+	/* external clock or XTAL */
+	u8 chip_mode;
+
+	/* frequency of external clock or xtal in Hz
+	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
+	 */
+	u32 ref_freq_Hz;
+
+	/* invert the spectrum */
+	bool inversion;
+};
+
 #endif /* _DVB_SI2165_PRIV */
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e5748a9..5d0bbe4 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -867,12 +867,6 @@ static const struct tda10071_platform_data hauppauge_tda10071_pdata = {
 	.tuner_i2c_addr = 0x54,
 };
 
-static const struct si2165_config hauppauge_hvr4400_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_XTAL,
-	.ref_freq_Hz	= 16000000,
-};
-
 static const struct m88ds3103_config dvbsky_t9580_m88ds3103_config = {
 	.i2c_addr = 0x68,
 	.clock = 27000000,
@@ -1182,6 +1176,7 @@ static int dvb_register(struct cx23885_tsport *port)
 	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
 	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
 	struct si2168_config si2168_config;
+	struct si2165_platform_data si2165_pdata;
 	struct si2157_config si2157_config;
 	struct ts2020_config ts2020_config;
 	struct i2c_board_info info;
@@ -1839,9 +1834,26 @@ static int dvb_register(struct cx23885_tsport *port)
 			break;
 		/* port c */
 		case 2:
-			fe0->dvb.frontend = dvb_attach(si2165_attach,
-					&hauppauge_hvr4400_si2165_config,
-					&i2c_bus->i2c_adap);
+			/* attach frontend */
+			memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+			si2165_pdata.fe = &fe0->dvb.frontend;
+			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
+			si2165_pdata.ref_freq_Hz = 16000000,
+			memset(&info, 0, sizeof(struct i2c_board_info));
+			strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+			info.addr = 0x64;
+			info.platform_data = &si2165_pdata;
+			request_module(info.type);
+			client_demod = i2c_new_device(&i2c_bus->i2c_adap, &info);
+			if (client_demod == NULL ||
+					client_demod->dev.driver == NULL)
+				goto frontend_detach;
+			if (!try_module_get(client_demod->dev.driver->owner)) {
+				i2c_unregister_device(client_demod);
+				goto frontend_detach;
+			}
+			port->i2c_client_demod = client_demod;
+
 			if (fe0->dvb.frontend == NULL)
 				break;
 			fe0->dvb.frontend->ops.i2c_gate_ctrl = NULL;
diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 57b2508..39fb443 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -80,7 +80,7 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct i2c_client *client = fe->tuner_priv;
 	struct si2157_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, len, remaining;
+	int ret, len, remaining, fw_chunk, inc;
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
 	const char *fw_name;
@@ -103,12 +103,12 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto warm;
 
 	/* power up */
-	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
-		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
-		cmd.wlen = 9;
-	} else {
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2157) {
 		memcpy(cmd.args, "\xc0\x00\x0c\x00\x00\x01\x01\x01\x01\x01\x01\x02\x00\x00\x01", 15);
 		cmd.wlen = 15;
+	} else {
+		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
+		cmd.wlen = 9;
 	}
 	cmd.rlen = 1;
 	ret = si2157_cmd_execute(client, &cmd);
@@ -131,11 +131,17 @@ static int si2157_init(struct dvb_frontend *fe)
 	#define SI2157_A30 ('A' << 24 | 57 << 16 | '3' << 8 | '0' << 0)
 	#define SI2147_A30 ('A' << 24 | 47 << 16 | '3' << 8 | '0' << 0)
 	#define SI2146_A10 ('A' << 24 | 46 << 16 | '1' << 8 | '0' << 0)
+	#define SI2173_A31 ('A' << 24 | 73 << 16 | '3' << 8 | '1' << 0)
 
 	switch (chip_id) {
 	case SI2158_A20:
 	case SI2148_A20:
 		fw_name = SI2158_A20_FIRMWARE;
+		fw_chunk = 17;
+		break;
+	case SI2173_A31:
+		fw_name = SI2173_A31_FIRMWARE;
+		fw_chunk = 8;
 		break;
 	case SI2157_A30:
 	case SI2147_A30:
@@ -164,25 +170,29 @@ static int si2157_init(struct dvb_frontend *fe)
 		goto err;
 	}
 
-	/* firmware should be n chunks of 17 bytes */
-	if (fw->size % 17 != 0) {
+	/* firmware should be n chunks of 8 or 17 bytes */
+	if (fw->size % fw_chunk != 0) {
 		dev_err(&client->dev, "firmware file '%s' is invalid\n",
 				fw_name);
 		ret = -EINVAL;
 		goto err_release_firmware;
 	}
 
-	dev_info(&client->dev, "downloading firmware from file '%s'\n",
-			fw_name);
+	dev_info(&client->dev, "downloading firmware from file '%s', size %zu bytes\n",
+			fw_name, fw->size);
 
-	for (remaining = fw->size; remaining > 0; remaining -= 17) {
-		len = fw->data[fw->size - remaining];
+	if (fw_chunk == 8)
+		inc = 0;
+	else
+		inc = 1;
+	for (remaining = fw->size; remaining > 0; remaining -= fw_chunk) {
+		len = fw_chunk == 8 ? 8 : fw->data[fw->size - remaining];
 		if (len > SI2157_ARGLEN) {
 			dev_err(&client->dev, "Bad firmware length\n");
 			ret = -EINVAL;
 			goto err_release_firmware;
 		}
-		memcpy(cmd.args, &fw->data[(fw->size - remaining) + 1], len);
+		memcpy(cmd.args, &fw->data[(fw->size - remaining) + inc], len);
 		cmd.wlen = len;
 		cmd.rlen = 1;
 		ret = si2157_cmd_execute(client, &cmd);
@@ -371,7 +381,7 @@ static int si2157_get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 
 static const struct dvb_tuner_ops si2157_ops = {
 	.info = {
-		.name           = "Silicon Labs Si2146/2147/2148/2157/2158",
+		.name           = "Silicon Labs Si2146/2147/2148/2157/2158/2173",
 		.frequency_min  = 42000000,
 		.frequency_max  = 870000000,
 	},
@@ -395,7 +405,11 @@ static void si2157_stat_work(struct work_struct *work)
 
 	memcpy(cmd.args, "\x42\x00", 2);
 	cmd.wlen = 2;
-	cmd.rlen = 12;
+	if (dev->chiptype == SI2157_CHIPTYPE_SI2173) {
+		cmd.rlen = 9;
+	} else {
+		cmd.rlen = 12;
+	}
 	ret = si2157_cmd_execute(client, &cmd);
 	if (ret)
 		goto err;
@@ -470,9 +484,13 @@ static int si2157_probe(struct i2c_client *client,
 	}
 #endif
 
-	dev_info(&client->dev, "Silicon Labs %s successfully attached\n",
+	dev_info(&client->dev, "Silicon Labs %s (chiptype %d) successfully attached\n",
 			dev->chiptype == SI2157_CHIPTYPE_SI2146 ?
-			"Si2146" : "Si2147/2148/2157/2158");
+			"Si2146" : 
+			dev->chiptype == SI2157_CHIPTYPE_SI2173 ?
+			"Si2173" :
+                        "Si2147/2148/2157/2158",
+			dev->chiptype);
 
 	return 0;
 
@@ -506,6 +524,7 @@ static int si2157_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id si2157_id_table[] = {
+	{"si2173", SI2157_CHIPTYPE_SI2173},
 	{"si2157", SI2157_CHIPTYPE_SI2157},
 	{"si2146", SI2157_CHIPTYPE_SI2146},
 	{}
@@ -528,3 +547,4 @@ MODULE_DESCRIPTION("Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
 MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(SI2158_A20_FIRMWARE);
+MODULE_FIRMWARE(SI2173_A31_FIRMWARE);
diff --git a/drivers/media/tuners/si2157_priv.h b/drivers/media/tuners/si2157_priv.h
index d6b2c7b..f1a3f69 100644
--- a/drivers/media/tuners/si2157_priv.h
+++ b/drivers/media/tuners/si2157_priv.h
@@ -42,6 +42,7 @@ struct si2157_dev {
 
 #define SI2157_CHIPTYPE_SI2157 0
 #define SI2157_CHIPTYPE_SI2146 1
+#define SI2157_CHIPTYPE_SI2173 2
 
 /* firmware command struct */
 #define SI2157_ARGLEN      30
@@ -52,5 +53,6 @@ struct si2157_cmd {
 };
 
 #define SI2158_A20_FIRMWARE "dvb-tuner-si2158-a20-01.fw"
+#define SI2173_A31_FIRMWARE "terratec_cinergy_htc_stick_hd0101.fw"
 
 #endif
diff --git a/drivers/media/tuners/tuner-types.c b/drivers/media/tuners/tuner-types.c
index 98bc15a..0dc57b1 100644
--- a/drivers/media/tuners/tuner-types.c
+++ b/drivers/media/tuners/tuner-types.c
@@ -1941,6 +1941,10 @@ struct tunertype tuners[] = {
 		.params = tuner_sony_btf_pg463z_params,
 		.count  = ARRAY_SIZE(tuner_sony_btf_pg463z_params),
 	},
+	[TUNER_SI2173] = { /* Silicon Labs 2173 */
+		.name   = "Silicon Labs 2173",
+	},
+
 };
 EXPORT_SYMBOL(tuners);
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
index 4919137..d408354 100644
--- a/drivers/media/usb/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/usb/cx231xx/cx231xx-avcore.c
@@ -360,6 +360,7 @@ int cx231xx_afe_update_power_control(struct cx231xx *dev,
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL:
 	case CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC:
 	case CX231XX_BOARD_OTG102:
+	case CX231XX_BOARD_TERRATEC_CNRG_HTC_HD:
 		if (avmode == POLARIS_AVMODE_ANALOGT_TV) {
 			while (afe_power_status != (FLD_PWRDN_TUNING_BIAS |
 						FLD_PWRDN_ENABLE_PLL)) {
@@ -599,7 +600,8 @@ int cx231xx_set_video_input_mux(struct cx231xx *dev, u8 input)
 				return status;
 			}
 		}
-		if (dev->tuner_type == TUNER_NXP_TDA18271)
+		if ((dev->tuner_type == TUNER_NXP_TDA18271) ||
+		    (dev->tuner_type == TUNER_SI2173))
 			status = cx231xx_set_decoder_video_input(dev,
 							CX231XX_VMUX_TELEVISION,
 							INPUT(input)->vmux);
@@ -906,7 +908,8 @@ int cx231xx_set_decoder_video_input(struct cx231xx *dev,
 
 			status = vid_blk_write_word(dev, AFE_CTRL, value);
 
-			if (dev->tuner_type == TUNER_NXP_TDA18271) {
+			if ((dev->tuner_type == TUNER_NXP_TDA18271) ||
+			    (dev->tuner_type == TUNER_SI2173)) {
 				status = vid_blk_read_word(dev, PIN_CTRL,
 				 &value);
 				status = vid_blk_write_word(dev, PIN_CTRL,
@@ -1197,6 +1200,7 @@ int cx231xx_set_audio_decoder_input(struct cx231xx *dev,
 					cx231xx_set_field(FLD_SIF_EN, 1));
 			break;
 		case TUNER_NXP_TDA18271:
+		case TUNER_SI2173:
 			/* Normal mode: SIF passthrough at 14.32 MHz */
 			status = cx231xx_read_modify_write_i2c_dword(dev,
 					VID_BLK_I2C_ADDRESS,
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index c63248a..8c851ab 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -815,6 +815,52 @@ struct cx231xx_board cx231xx_boards[] = {
 			.gpio = NULL,
 		} },
 	},
+ 	[CX231XX_BOARD_TERRATEC_CNRG_HTC_HD] = {
+ 		.name = "Terratec Cinergy HTC Stick HD",
+ 		.tuner_type = TUNER_ABSENT,
+ 		.tuner_addr = 0x60,
+ 		.tuner_gpio = RDE250_XCV_TUNER,
+ 		.tuner_sif_gpio = 0x05,
+ 		.tuner_scl_gpio = 0x1a,
+ 		.tuner_sda_gpio = 0x1b,
+ 		.tuner_i2c_master = I2C_1_MUX_3,
+ 		.demod_addr = 0x64,
+ 		.demod_i2c_master = I2C_2,
+ 		.has_dvb = 1,
+ 		.decoder = CX231XX_AVDECODER,
+ 		.output_mode = OUT_MODE_VIP11,
+ 		.ctl_pin_status_mask = 0xFFFFFFC4,
+ 		.agc_analog_digital_select_gpio = 0x1c,
+ 		.gpio_pin_status_mask = 0x4001000,
+ 		.norm = V4L2_STD_PAL,
+ 		.no_alt_vanc = 1,
+ 		.external_av = 1,
+ 		/* Actually, it has a 417, but it isn't working correctly.
+ 		 * So set to 0 for now until someone can manage to get this
+ 		 * to work reliably. */
+ 		.has_417 = 0,
+ 		.gpio_pin_status_mask = 0x4001000,
+ 		.agc_analog_digital_select_gpio = 0x1c,
+ 		.input = {{
+ 				.type = CX231XX_VMUX_TELEVISION,
+ 				.vmux = CX231XX_VIN_3_1,
+ 				.amux = CX231XX_AMUX_VIDEO,
+ 				.gpio = NULL,
+ 			}, {
+ 				.type = CX231XX_VMUX_COMPOSITE1,
+ 				.vmux = CX231XX_VIN_2_1,
+ 				.amux = CX231XX_AMUX_LINE_IN,
+ 				.gpio = NULL,
+ 			}, {
+ 				.type = CX231XX_VMUX_SVIDEO,
+ 				.vmux = CX231XX_VIN_1_1 |
+ 					(CX231XX_VIN_1_2 << 8) |
+ 					CX25840_SVIDEO_ON,
+ 				.amux = CX231XX_AMUX_LINE_IN,
+ 				.gpio = NULL,
+ 			}
+ 		},
+ 	},
 	[CX231XX_BOARD_TERRATEC_GRABBY] = {
 		.name = "Terratec Grabby",
 		.tuner_type = TUNER_ABSENT,
@@ -864,6 +910,8 @@ struct usb_device_id cx231xx_id_table[] = {
 	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
 	{USB_DEVICE(0x0572, 0x58A0),
 	 .driver_info = CX231XX_BOARD_CNXT_RDU_250},
+	{USB_DEVICE(0x0ccd, 0x0101),
+	.driver_info = CX231XX_BOARD_TERRATEC_CNRG_HTC_HD},
 	{USB_DEVICE(0x2040, 0xb110),
 	 .driver_info = CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL},
 	{USB_DEVICE(0x2040, 0xb111),
@@ -937,6 +985,11 @@ int cx231xx_tuner_callback(void *ptr, int component, int command, int arg)
 					       1);
 			msleep(10);
 		}
+ 	} else if (dev->tuner_type == TUNER_SI2173) {
+ 			dev_dbg(dev->dev,
+ 				"Tuner CB: RESET: cmd %d : tuner type %d\n",
+ 				command, dev->tuner_type);
+ 			rc = cx231xx_set_agc_analog_digital_mux_select(dev, arg);
 	} else if (dev->tuner_type == TUNER_NXP_TDA18271) {
 		switch (command) {
 		case TDA18271_CALLBACK_CMD_AGC_ENABLE:
@@ -1263,6 +1316,7 @@ static int cx231xx_init_dev(struct cx231xx *dev, struct usb_device *udev,
 	/*To workaround error number=-71 on EP0 for VideoGrabber,
 		 need set alt here.*/
 	if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER ||
+	    dev->model == CX231XX_BOARD_TERRATEC_CNRG_HTC_HD ||
 	    dev->model == CX231XX_BOARD_HAUPPAUGE_USBLIVE2) {
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
 		cx231xx_set_alt_setting(dev, INDEX_VANC, 1);
@@ -1674,7 +1728,8 @@ static int cx231xx_usb_probe(struct usb_interface *interface,
 		}
 	}
 
-	if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER) {
+	if (dev->model == CX231XX_BOARD_CNXT_VIDEO_GRABBER ||
+	    dev->model == CX231XX_BOARD_TERRATEC_CNRG_HTC_HD)  {
 		cx231xx_enable_OSC(dev);
 		cx231xx_reset_out(dev);
 		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 630f4fc..b942fe4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -52,7 +52,7 @@ MODULE_PARM_DESC(alt, "alternate setting to use for video endpoint");
 
 #define cx231xx_isocdbg(fmt, arg...) do { 	if (core_debug) -		printk(KERN_INFO "%s %s :"fmt, +		printk(KERN_INFO "%s %s :"fmt" ",  			 dev->name, __func__ , ##arg); } while (0)
 
 /*****************************************************************
@@ -272,6 +272,7 @@ static int __usb_control_msg(struct cx231xx *dev, unsigned int pipe,
 	if (reg_debug) {
 		if (unlikely(rc < 0)) {
 			printk(KERN_CONT "FAILED!\n");
+			dump_stack();
 			return rc;
 		}
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index ab2fb9f..a890be3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -65,6 +65,7 @@ struct cx231xx_dvb {
 	struct dmx_frontend fe_hw;
 	struct dmx_frontend fe_mem;
 	struct dvb_net net;
+	struct i2c_client *i2c_client_demod;
 	struct i2c_client *i2c_client_tuner;
 };
 
@@ -150,18 +151,6 @@ static struct tda18271_config pv_tda18271_config = {
 	.small_i2c = TDA18271_03_BYTE_CHUNK_INIT,
 };
 
-static const struct si2165_config hauppauge_930C_HD_1113xx_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_XTAL,
-	.ref_freq_Hz	= 16000000,
-};
-
-static const struct si2165_config pctv_quatro_stick_1114xx_si2165_config = {
-	.i2c_addr	= 0x64,
-	.chip_mode	= SI2165_MODE_PLL_EXT,
-	.ref_freq_Hz	= 24000000,
-};
-
 static struct lgdt3306a_config hauppauge_955q_lgdt3306a_config = {
 	.i2c_addr           = 0x59,
 	.qam_if_khz         = 4000,
@@ -586,8 +575,14 @@ static void unregister_dvb(struct cx231xx_dvb *dvb)
 	dvb->demux.dmx.remove_frontend(&dvb->demux.dmx, &dvb->fe_hw);
 	dvb_dmxdev_release(&dvb->dmxdev);
 	dvb_dmx_release(&dvb->demux);
-	client = dvb->i2c_client_tuner;
 	/* remove I2C tuner */
+	client = dvb->i2c_client_tuner;
+	if (client) {
+		module_put(client->dev.driver->owner);
+		i2c_unregister_device(client);
+	}
+	/* remove I2C demod */
+	client = dvb->i2c_client_demod;
 	if (client) {
 		module_put(client->dev.driver->owner);
 		i2c_unregister_device(client);
@@ -749,19 +744,38 @@ static int dvb_init(struct cx231xx *dev)
 		break;
 
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx:
+	{
+		struct i2c_client *client;
+		struct i2c_board_info info;
+		struct si2165_platform_data si2165_pdata;
 
-		dev->dvb->frontend = dvb_attach(si2165_attach,
-			&hauppauge_930C_HD_1113xx_si2165_config,
-			demod_i2c
-			);
+		/* attach demod */
+		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+		si2165_pdata.fe = &dev->dvb->frontend;
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
+		si2165_pdata.ref_freq_Hz = 16000000,
 
-		if (dev->dvb->frontend == NULL) {
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+		info.addr = 0x64;
+		info.platform_data = &si2165_pdata;
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
 
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod = client;
+
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
@@ -774,27 +788,131 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->cx231xx_reset_analog_tuner = NULL;
 		break;
+	}
+
+ 	case CX231XX_BOARD_TERRATEC_CNRG_HTC_HD:
+ 	{
+ 		struct i2c_client *client;
+ 		struct i2c_board_info info;
+		struct si2165_platform_data si2165_pdata;
+ 		struct si2157_config si2157_config;
+ 
+		/* attach demod */
+		dev_info(dev->dev,
+			 "%s: attach demod\n",
+		       __func__);
+		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+		si2165_pdata.fe = &dev->dvb->frontend;
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
+		si2165_pdata.ref_freq_Hz = 24000000,
+ 
+ 		memset(&info, 0, sizeof(struct i2c_board_info));
+ 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+ 		info.addr = 0x64;
+ 		info.platform_data = &si2165_pdata;
+ 		request_module(info.type);
+ 		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
+			dev_err(dev->dev,
+				"Failed to attach SI2165 front end\n");
+			result = -EINVAL;
+			goto out_free;
+		}
+ 
+ 		if (!try_module_get(client->dev.driver->owner)) {
+ 			i2c_unregister_device(client);
+ 			result = -ENODEV;
+ 			goto out_free;
+ 		}
+		dev_info(dev->dev,
+			 "%s: demod attached\n",
+		       __func__);
+ 
+		dvb->i2c_client_demod = client;
 
+		memset(&info, 0, sizeof(struct i2c_board_info));
+
+ 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
+ 
+ 		/* define general-purpose callback pointer */
+ 		dvb->frontend->callback = cx231xx_tuner_callback;
+ 
+ 		/* attach tuner */
+		dev_info(dev->dev,
+			 "%s: attach tuner\n",
+		       __func__);
+ 		memset(&si2157_config, 0, sizeof(si2157_config));
+ 		si2157_config.fe = dev->dvb->frontend;
+#ifdef CONFIG_MEDIA_CONTROLLER_DVB
+ 		si2157_config.mdev = dev->media_dev;
+#endif
+ 		si2157_config.if_port = 0;
+ 		si2157_config.inversion = true;
+		strlcpy(info.type, "si2173", I2C_NAME_SIZE);
+		info.addr = 0x60;
+		info.platform_data = &si2157_config;
+		request_module("si2157");
+
+		client = i2c_new_device(
+			tuner_i2c,
+			&info);
+		if (client == NULL || client->dev.driver == NULL) {
+			dvb_frontend_detach(dev->dvb->frontend);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			dvb_frontend_detach(dev->dvb->frontend);
+			result = -ENODEV;
+			goto out_free;
+		}
+		dev_info(dev->dev,
+			 "%s: tuner attached\n",
+		       __func__);
+ 
+ 		dev->cx231xx_reset_analog_tuner = NULL;
+ 
+ 		dev->dvb->i2c_client_tuner = client;
+ 		break;
+ 	}
 	case CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx:
 	{
 		struct i2c_client *client;
 		struct i2c_board_info info;
+		struct si2165_platform_data si2165_pdata;
 		struct si2157_config si2157_config;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
+		/* attach demod */
+		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
+		si2165_pdata.fe = &dev->dvb->frontend;
+		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
+		si2165_pdata.ref_freq_Hz = 24000000,
 
-		dev->dvb->frontend = dvb_attach(si2165_attach,
-			&pctv_quatro_stick_1114xx_si2165_config,
-			demod_i2c
-			);
-
-		if (dev->dvb->frontend == NULL) {
+		memset(&info, 0, sizeof(struct i2c_board_info));
+		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+		info.addr = 0x64;
+		info.platform_data = &si2165_pdata;
+		request_module(info.type);
+		client = i2c_new_device(demod_i2c, &info);
+		if (client == NULL || client->dev.driver == NULL || dev->dvb->frontend == NULL) {
 			dev_err(dev->dev,
 				"Failed to attach SI2165 front end\n");
 			result = -EINVAL;
 			goto out_free;
 		}
 
+		if (!try_module_get(client->dev.driver->owner)) {
+			i2c_unregister_device(client);
+			result = -ENODEV;
+			goto out_free;
+		}
+
+		dvb->i2c_client_demod = client;
+
+		memset(&info, 0, sizeof(struct i2c_board_info));
+
 		dev->dvb->frontend->ops.i2c_gate_ctrl = NULL;
 
 		/* define general-purpose callback pointer */
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 90c8676..603023d 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -78,6 +78,8 @@
 #define CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx 20
 #define CX231XX_BOARD_HAUPPAUGE_955Q 21
 #define CX231XX_BOARD_TERRATEC_GRABBY 22
+#define CX231XX_BOARD_TERRATEC_CNRG_HTC_HD 23
+
 
 /* Limits minimum and default number of buffers */
 #define CX231XX_MIN_BUF                 4
diff --git a/include/media/tuner.h b/include/media/tuner.h
index b3edc14..975fb89 100644
--- a/include/media/tuner.h
+++ b/include/media/tuner.h
@@ -141,6 +141,8 @@
 #define TUNER_SONY_BTF_PG472Z		89	/* PAL+SECAM */
 #define TUNER_SONY_BTF_PK467Z		90	/* NTSC_JP */
 #define TUNER_SONY_BTF_PB463Z		91	/* NTSC */
+#define TUNER_SI2173			92	/* Silicon Labs 2173 */
+
 
 /* tv card specific */
 #define TDA9887_PRESENT			(1<<0)
-- 
2.1.4

