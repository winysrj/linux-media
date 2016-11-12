Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51323 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752786AbcKLKey (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 05:34:54 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/9] af9035: read and store whole eeprom
Date: Sat, 12 Nov 2016 12:33:53 +0200
Message-Id: <1478946841-2807-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Read eeprom content to chip state and read values there when needed.
Also debug dump eeprom content.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 126 +++++++++++++++-------------------
 drivers/media/usb/dvb-usb-v2/af9035.h |   5 +-
 2 files changed, 60 insertions(+), 71 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index c673726..61dac6a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -496,7 +496,8 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct state *state = d_to_priv(d);
 	struct usb_interface *intf = d->intf;
-	int ret, ts_mode_invalid;
+	int ret, i, ts_mode_invalid;
+	unsigned int utmp, eeprom_addr;
 	u8 tmp;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
@@ -518,25 +519,48 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 		 state->prechip_version, state->chip_version, state->chip_type);
 
 	if (state->chip_type == 0x9135) {
-		if (state->chip_version == 0x02)
+		if (state->chip_version == 0x02) {
 			*name = AF9035_FIRMWARE_IT9135_V2;
-		else
+			utmp = 0x00461d;
+		} else {
 			*name = AF9035_FIRMWARE_IT9135_V1;
-		state->eeprom_addr = EEPROM_BASE_IT9135;
+			utmp = 0x00461b;
+		}
+
+		/* Check if eeprom exists */
+		ret = af9035_rd_reg(d, utmp, &tmp);
+		if (ret < 0)
+			goto err;
+
+		if (tmp == 0x00) {
+			dev_dbg(&intf->dev, "no eeprom\n");
+			state->no_eeprom = true;
+			goto check_firmware_status;
+		}
+
+		eeprom_addr = EEPROM_BASE_IT9135;
 	} else if (state->chip_type == 0x9306) {
 		*name = AF9035_FIRMWARE_IT9303;
-		state->eeprom_addr = EEPROM_BASE_IT9135;
+		state->no_eeprom = true;
+		goto check_firmware_status;
 	} else {
 		*name = AF9035_FIRMWARE_AF9035;
-		state->eeprom_addr = EEPROM_BASE_AF9035;
+		eeprom_addr = EEPROM_BASE_AF9035;
+	}
+
+	/* Read and store eeprom */
+	for (i = 0; i < 256; i += 32) {
+		ret = af9035_rd_regs(d, eeprom_addr + i, &state->eeprom[i], 32);
+		if (ret < 0)
+			goto err;
 	}
 
+	dev_dbg(&intf->dev, "eeprom dump:\n");
+	for (i = 0; i < 256; i += 16)
+		dev_dbg(&intf->dev, "%*ph\n", 16, &state->eeprom[i]);
 
 	/* check for dual tuner mode */
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_TS_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
+	tmp = state->eeprom[EEPROM_TS_MODE];
 	ts_mode_invalid = 0;
 	switch (tmp) {
 	case 0:
@@ -560,7 +584,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ts_mode_invalid)
 		dev_info(&intf->dev, "ts mode=%d not supported, defaulting to single tuner mode!", tmp);
 
-
+check_firmware_status:
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret < 0)
 		goto err;
@@ -750,11 +774,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 			goto err;
 
 		/* tell the slave I2C address */
-		ret = af9035_rd_reg(d,
-				state->eeprom_addr + EEPROM_2ND_DEMOD_ADDR,
-				&tmp);
-		if (ret < 0)
-			goto err;
+		tmp = state->eeprom[EEPROM_2ND_DEMOD_ADDR];
 
 		/* use default I2C address if eeprom has no address set */
 		if (!tmp)
@@ -819,7 +839,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	struct state *state = d_to_priv(d);
 	int ret, i;
 	u8 tmp;
-	u16 tmp16, addr;
+	u16 tmp16;
 
 	/* demod I2C "address" */
 	state->af9033_i2c_addr[0] = 0x38;
@@ -837,20 +857,16 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (state->chip_version == 0x02) {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_60;
 			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_60;
-			tmp16 = 0x00461d; /* eeprom memory mapped location */
 		} else {
 			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
 			state->af9033_config[1].tuner = AF9033_TUNER_IT9135_38;
-			tmp16 = 0x00461b; /* eeprom memory mapped location */
 		}
 
-		/* check if eeprom exists */
-		ret = af9035_rd_reg(d, tmp16, &tmp);
-		if (ret < 0)
-			goto err;
+		if (state->no_eeprom) {
+			/* Remote controller to NEC polling by default */
+			state->ir_mode = 0x05;
+			state->ir_type = 0x00;
 
-		if (tmp == 0x00) {
-			dev_dbg(&intf->dev, "no eeprom\n");
 			goto skip_eeprom;
 		}
 	} else if (state->chip_type == 0x9306) {
@@ -861,29 +877,24 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		return 0;
 	}
 
+	/* Remote controller */
+	state->ir_mode = state->eeprom[EEPROM_IR_MODE];
+	state->ir_type = state->eeprom[EEPROM_IR_TYPE];
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
-		ret = af9035_rd_reg(d,
-				state->eeprom_addr + EEPROM_2ND_DEMOD_ADDR,
-				&tmp);
-		if (ret < 0)
-			goto err;
-
+		tmp = state->eeprom[EEPROM_2ND_DEMOD_ADDR];
 		if (tmp)
 			state->af9033_i2c_addr[1] = tmp;
 
 		dev_dbg(&intf->dev, "2nd demod I2C addr=%02x\n", tmp);
 	}
 
-	addr = state->eeprom_addr;
-
 	for (i = 0; i < state->dual_mode + 1; i++) {
-		/* tuner */
-		ret = af9035_rd_reg(d, addr + EEPROM_1_TUNER_ID, &tmp);
-		if (ret < 0)
-			goto err;
+		unsigned int eeprom_offset = 0;
 
+		/* tuner */
+		tmp = state->eeprom[EEPROM_1_TUNER_ID + eeprom_offset];
 		dev_dbg(&intf->dev, "[%d]tuner=%02x\n", i, tmp);
 
 		/* tuner sanity check */
@@ -956,21 +967,13 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		}
 
 		/* tuner IF frequency */
-		ret = af9035_rd_reg(d, addr + EEPROM_1_IF_L, &tmp);
-		if (ret < 0)
-			goto err;
-
-		tmp16 = tmp;
-
-		ret = af9035_rd_reg(d, addr + EEPROM_1_IF_H, &tmp);
-		if (ret < 0)
-			goto err;
-
+		tmp = state->eeprom[EEPROM_1_IF_L + eeprom_offset];
+		tmp16 = tmp << 0;
+		tmp = state->eeprom[EEPROM_1_IF_H + eeprom_offset];
 		tmp16 |= tmp << 8;
-
 		dev_dbg(&intf->dev, "[%d]IF=%d\n", i, tmp16);
 
-		addr += 0x10; /* shift for the 2nd tuner params */
+		eeprom_offset += 0x10; /* shift for the 2nd tuner params */
 	}
 
 skip_eeprom:
@@ -1872,25 +1875,13 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
 	struct state *state = d_to_priv(d);
 	struct usb_interface *intf = d->intf;
-	int ret;
-	u8 tmp;
 
-	ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_IR_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
-	dev_dbg(&intf->dev, "ir_mode=%02x\n", tmp);
+	dev_dbg(&intf->dev, "ir_mode=%02x ir_type=%02x\n",
+		state->ir_mode, state->ir_type);
 
 	/* don't activate rc if in HID mode or if not available */
-	if (tmp == 5) {
-		ret = af9035_rd_reg(d, state->eeprom_addr + EEPROM_IR_TYPE,
-				&tmp);
-		if (ret < 0)
-			goto err;
-
-		dev_dbg(&intf->dev, "ir_type=%02x\n", tmp);
-
-		switch (tmp) {
+	if (state->ir_mode == 0x05) {
+		switch (state->ir_type) {
 		case 0: /* NEC */
 		default:
 			rc->allowed_protos = RC_BIT_NEC | RC_BIT_NECX |
@@ -1910,11 +1901,6 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	}
 
 	return 0;
-
-err:
-	dev_dbg(&intf->dev, "failed=%d\n", ret);
-
-	return ret;
 }
 #else
 	#define af9035_get_rc_config NULL
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 1f83c92..89a08a4 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -61,9 +61,12 @@ struct state {
 	u8 prechip_version;
 	u8 chip_version;
 	u16 chip_type;
+	u8 eeprom[256];
+	bool no_eeprom;
+	u8 ir_mode;
+	u8 ir_type;
 	u8 dual_mode:1;
 	u8 no_read:1;
-	u16 eeprom_addr;
 	u8 af9033_i2c_addr[2];
 	struct af9033_config af9033_config[2];
 	struct af9033_ops ops;
-- 
http://palosaari.fi/

