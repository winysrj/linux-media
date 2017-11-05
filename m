Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44646 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdKEOZS (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:18 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 03/15] si2165: Make checkpatch happy
Date: Sun,  5 Nov 2017 15:24:59 +0100
Message-Id: <20171105142511.16563-3-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix almost all of checkpatch --strict warnings.

The remaining warnings are about:
* macro REG16 (should be enclosed in parentheses)
* macro REG16 (Macro argument reuse)

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 87 ++++++++++++++++---------------
 drivers/media/dvb-frontends/si2165.h      | 37 ++++++-------
 drivers/media/dvb-frontends/si2165_priv.h | 35 +++++++------
 drivers/media/pci/cx23885/cx23885-dvb.c   |  2 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c   |  4 +-
 5 files changed, 86 insertions(+), 79 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 7110b3b37f23..6b22d079ecef 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -63,11 +63,12 @@ struct si2165_state {
 };
 
 static int si2165_write(struct si2165_state *state, const u16 reg,
-		       const u8 *src, const int count)
+			const u8 *src, const int count)
 {
 	int ret;
 
-	dev_dbg(&state->client->dev, "i2c write: reg: 0x%04x, data: %*ph\n", reg, count, src);
+	dev_dbg(&state->client->dev, "i2c write: reg: 0x%04x, data: %*ph\n",
+		reg, count, src);
 
 	ret = regmap_bulk_write(state->regmap, reg, src, count);
 
@@ -88,13 +89,14 @@ static int si2165_read(struct si2165_state *state,
 		return ret;
 	}
 
-	dev_dbg(&state->client->dev, "i2c read: reg: 0x%04x, data: %*ph\n", reg, count, val);
+	dev_dbg(&state->client->dev, "i2c read: reg: 0x%04x, data: %*ph\n",
+		reg, count, val);
 
 	return 0;
 }
 
 static int si2165_readreg8(struct si2165_state *state,
-		       const u16 reg, u8 *val)
+			   const u16 reg, u8 *val)
 {
 	unsigned int val_tmp;
 	int ret = regmap_read(state->regmap, reg, &val_tmp);
@@ -104,7 +106,7 @@ static int si2165_readreg8(struct si2165_state *state,
 }
 
 static int si2165_readreg16(struct si2165_state *state,
-		       const u16 reg, u16 *val)
+			    const u16 reg, u16 *val)
 {
 	u8 buf[2];
 
@@ -161,7 +163,9 @@ static int si2165_writereg_mask8(struct si2165_state *state, const u16 reg,
 	return si2165_writereg8(state, reg, val);
 }
 
-#define REG16(reg, val) { (reg), (val) & 0xff }, { (reg)+1, (val)>>8 & 0xff }
+#define REG16(reg, val) \
+	{ (reg), (val) & 0xff }, \
+	{ (reg) + 1, (val) >> 8 & 0xff }
 struct si2165_reg_value_pair {
 	u16 reg;
 	u8 val;
@@ -191,7 +195,7 @@ static int si2165_get_tune_settings(struct dvb_frontend *fe,
 
 static int si2165_init_pll(struct si2165_state *state)
 {
-	u32 ref_freq_Hz = state->config.ref_freq_Hz;
+	u32 ref_freq_hz = state->config.ref_freq_hz;
 	u8 divr = 1; /* 1..7 */
 	u8 divp = 1; /* only 1 or 4 */
 	u8 divn = 56; /* 1..63 */
@@ -203,7 +207,7 @@ static int si2165_init_pll(struct si2165_state *state)
 	 * hardcoded values can be deleted if calculation is verified
 	 * or it yields the same values as the windows driver
 	 */
-	switch (ref_freq_Hz) {
+	switch (ref_freq_hz) {
 	case 16000000u:
 		divn = 56;
 		break;
@@ -214,23 +218,23 @@ static int si2165_init_pll(struct si2165_state *state)
 		break;
 	default:
 		/* ref_freq / divr must be between 4 and 16 MHz */
-		if (ref_freq_Hz > 16000000u)
+		if (ref_freq_hz > 16000000u)
 			divr = 2;
 
 		/*
 		 * now select divn and divp such that
 		 * fvco is in 1624..1824 MHz
 		 */
-		if (1624000000u * divr > ref_freq_Hz * 2u * 63u)
+		if (1624000000u * divr > ref_freq_hz * 2u * 63u)
 			divp = 4;
 
 		/* is this already correct regarding rounding? */
-		divn = 1624000000u * divr / (ref_freq_Hz * 2u * divp);
+		divn = 1624000000u * divr / (ref_freq_hz * 2u * divp);
 		break;
 	}
 
 	/* adc_clk and sys_clk depend on xtal and pll settings */
-	state->fvco_hz = ref_freq_Hz / divr
+	state->fvco_hz = ref_freq_hz / divr
 			* 2u * divn * divp;
 	state->adc_clk = state->fvco_hz / (divm * 4u);
 	state->sys_clk = state->fvco_hz / (divl * 2u);
@@ -272,7 +276,8 @@ static int si2165_wait_init_done(struct si2165_state *state)
 }
 
 static int si2165_upload_firmware_block(struct si2165_state *state,
-	const u8 *data, u32 len, u32 *poffset, u32 block_count)
+					const u8 *data, u32 len, u32 *poffset,
+					u32 block_count)
 {
 	int ret;
 	u8 buf_ctrl[4] = { 0x00, 0x00, 0x00, 0xc0 };
@@ -286,15 +291,15 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		return -EINVAL;
 
 	dev_dbg(&state->client->dev,
-		"fw load: si2165_upload_firmware_block called with len=0x%x offset=0x%x blockcount=0x%x\n",
-				len, offset, block_count);
-	while (offset+12 <= len && cur_block < block_count) {
+		"fw load: %s: called with len=0x%x offset=0x%x blockcount=0x%x\n",
+		__func__, len, offset, block_count);
+	while (offset + 12 <= len && cur_block < block_count) {
 		dev_dbg(&state->client->dev,
-			"fw load: si2165_upload_firmware_block in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
-					len, offset, cur_block, block_count);
+			"fw load: %s: in while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+			__func__, len, offset, cur_block, block_count);
 		wordcount = data[offset];
-		if (wordcount < 1 || data[offset+1] ||
-		    data[offset+2] || data[offset+3]) {
+		if (wordcount < 1 || data[offset + 1] ||
+		    data[offset + 2] || data[offset + 3]) {
 			dev_warn(&state->client->dev,
 				 "bad fw data[0..3] = %*ph\n",
 				 4, data);
@@ -313,14 +318,14 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 		ret = si2165_write(state, 0x0364, buf_ctrl, 4);
 		if (ret < 0)
 			goto error;
-		ret = si2165_write(state, 0x0368, data+offset+4, 4);
+		ret = si2165_write(state, 0x0368, data + offset + 4, 4);
 		if (ret < 0)
 			goto error;
 
 		offset += 8;
 
 		while (wordcount > 0) {
-			ret = si2165_write(state, 0x36c, data+offset, 4);
+			ret = si2165_write(state, 0x36c, data + offset, 4);
 			if (ret < 0)
 				goto error;
 			wordcount--;
@@ -330,15 +335,15 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 	}
 
 	dev_dbg(&state->client->dev,
-		"fw load: si2165_upload_firmware_block after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
-				len, offset, cur_block, block_count);
+		"fw load: %s: after while len=0x%x offset=0x%x cur_block=0x%x blockcount=0x%x\n",
+		__func__, len, offset, cur_block, block_count);
 
 	if (poffset)
 		*poffset = offset;
 
 	dev_dbg(&state->client->dev,
-		"fw load: si2165_upload_firmware_block returned offset=0x%x\n",
-				offset);
+		"fw load: %s: returned offset=0x%x\n",
+		__func__, offset);
 
 	return 0;
 error:
@@ -367,7 +372,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 		break;
 	default:
 		dev_info(&state->client->dev, "no firmware file for revision=%d\n",
-			state->chip_revcode);
+			 state->chip_revcode);
 		return 0;
 	}
 
@@ -375,7 +380,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	ret = request_firmware(&fw, fw_file, &state->client->dev);
 	if (ret) {
 		dev_warn(&state->client->dev, "firmware file '%s' not found\n",
-			fw_file);
+			 fw_file);
 		goto error;
 	}
 
@@ -383,7 +388,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	len = fw->size;
 
 	dev_info(&state->client->dev, "downloading firmware from file '%s' size=%d\n",
-			fw_file, len);
+		 fw_file, len);
 
 	if (len % 4 != 0) {
 		dev_warn(&state->client->dev, "firmware size is not multiple of 4\n");
@@ -436,8 +441,8 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	/* start right after the header */
 	offset = 8;
 
-	dev_info(&state->client->dev, "si2165_upload_firmware extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
-		patch_version, block_count, crc_expected);
+	dev_info(&state->client->dev, "%s: extracted patch_version=0x%02x, block_count=0x%02x, crc_expected=0x%04x\n",
+		 __func__, patch_version, block_count, crc_expected);
 
 	ret = si2165_upload_firmware_block(state, data, len, &offset, 1);
 	if (ret < 0)
@@ -963,7 +968,7 @@ static const struct dvb_frontend_ops si2165_ops = {
 };
 
 static int si2165_probe(struct i2c_client *client,
-		const struct i2c_device_id *id)
+			const struct i2c_device_id *id)
 {
 	struct si2165_state *state = NULL;
 	struct si2165_platform_data *pdata = client->dev.platform_data;
@@ -979,8 +984,8 @@ static int si2165_probe(struct i2c_client *client,
 	};
 
 	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
-	if (state == NULL) {
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state) {
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -996,20 +1001,20 @@ static int si2165_probe(struct i2c_client *client,
 	state->client = client;
 	state->config.i2c_addr = client->addr;
 	state->config.chip_mode = pdata->chip_mode;
-	state->config.ref_freq_Hz = pdata->ref_freq_Hz;
+	state->config.ref_freq_hz = pdata->ref_freq_hz;
 	state->config.inversion = pdata->inversion;
 
-	if (state->config.ref_freq_Hz < 4000000
-	    || state->config.ref_freq_Hz > 27000000) {
+	if (state->config.ref_freq_hz < 4000000 ||
+	    state->config.ref_freq_hz > 27000000) {
 		dev_err(&state->client->dev, "ref_freq of %d Hz not supported by this driver\n",
-			 state->config.ref_freq_Hz);
+			state->config.ref_freq_hz);
 		ret = -EINVAL;
 		goto error;
 	}
 
 	/* create dvb_frontend */
 	memcpy(&state->fe.ops, &si2165_ops,
-		sizeof(struct dvb_frontend_ops));
+	       sizeof(struct dvb_frontend_ops));
 	state->fe.ops.release = NULL;
 	state->fe.demodulator_priv = state;
 	i2c_set_clientdata(client, state);
@@ -1060,12 +1065,12 @@ static int si2165_probe(struct i2c_client *client,
 	}
 
 	dev_info(&state->client->dev,
-		"Detected Silicon Labs %s-%c (type %d, rev %d)\n",
+		 "Detected Silicon Labs %s-%c (type %d, rev %d)\n",
 		chip_name, rev_char, state->chip_type,
 		state->chip_revcode);
 
 	strlcat(state->fe.ops.info.name, chip_name,
-			sizeof(state->fe.ops.info.name));
+		sizeof(state->fe.ops.info.name));
 
 	n = 0;
 	if (state->has_dvbt) {
diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
index 76c2ca7d7edb..74a57b7ecd26 100644
--- a/drivers/media/dvb-frontends/si2165.h
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -1,21 +1,22 @@
 /*
-    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
-
-    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-    References:
-    http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
-*/
+ * Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+ *
+ * Copyright (C) 2013-2017 Matthias Schwarzott <zzam@gentoo.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ * References:
+ *   http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2165-short.pdf
+ *
+ */
 
 #ifndef _DVB_SI2165_H
 #define _DVB_SI2165_H
@@ -44,7 +45,7 @@ struct si2165_platform_data {
 	/* frequency of external clock or xtal in Hz
 	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
 	 */
-	u32 ref_freq_Hz;
+	u32 ref_freq_hz;
 
 	/* invert the spectrum */
 	bool inversion;
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index e5932118834b..3d10cb4486c5 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -1,19 +1,19 @@
 /*
-    Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
-
-    Copyright (C) 2013-2014 Matthias Schwarzott <zzam@gentoo.org>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-
-    This program is distributed in the hope that it will be useful,
-    but WITHOUT ANY WARRANTY; without even the implied warranty of
-    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-    GNU General Public License for more details.
-
-*/
+ * Driver for Silicon Labs SI2165 DVB-C/-T Demodulator
+ *
+ * Copyright (C) 2013-2017 Matthias Schwarzott <zzam@gentoo.org>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ */
 
 #ifndef _DVB_SI2165_PRIV
 #define _DVB_SI2165_PRIV
@@ -22,7 +22,8 @@
 
 struct si2165_config {
 	/* i2c addr
-	 * possible values: 0x64,0x65,0x66,0x67 */
+	 * possible values: 0x64,0x65,0x66,0x67
+	 */
 	u8 i2c_addr;
 
 	/* external clock or XTAL */
@@ -31,7 +32,7 @@ struct si2165_config {
 	/* frequency of external clock or xtal in Hz
 	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
 	 */
-	u32 ref_freq_Hz;
+	u32 ref_freq_hz;
 
 	/* invert the spectrum */
 	bool inversion;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index e795ddeb7fe2..b33ded461308 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1853,7 +1853,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 			si2165_pdata.fe = &fe0->dvb.frontend;
 			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
-			si2165_pdata.ref_freq_Hz = 16000000,
+			si2165_pdata.ref_freq_hz = 16000000,
 			memset(&info, 0, sizeof(struct i2c_board_info));
 			strlcpy(info.type, "si2165", I2C_NAME_SIZE);
 			info.addr = 0x64;
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index c18bb33e060e..4e462edf044f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -763,7 +763,7 @@ static int dvb_init(struct cx231xx *dev)
 		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend;
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL,
-		si2165_pdata.ref_freq_Hz = 16000000,
+		si2165_pdata.ref_freq_hz = 16000000,
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
@@ -810,7 +810,7 @@ static int dvb_init(struct cx231xx *dev)
 		memset(&si2165_pdata, 0, sizeof(si2165_pdata));
 		si2165_pdata.fe = &dev->dvb->frontend;
 		si2165_pdata.chip_mode = SI2165_MODE_PLL_EXT,
-		si2165_pdata.ref_freq_Hz = 24000000,
+		si2165_pdata.ref_freq_hz = 24000000,
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
 		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
-- 
2.15.0
