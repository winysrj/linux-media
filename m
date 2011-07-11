Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:22897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab1GKB7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:55 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xsVE018174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:54 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKd030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:48 -0400
Date: Sun, 10 Jul 2011 22:59:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 13/21] [media] drxk: Proper handle/propagate the error codes
Message-ID: <20110710225900.207b412b@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

This driver is very big and complex. An error happening in the middle
of any initialization may cause the frontend to not work. So, it
needs to properly propagate error codes internally and to userspace.

Also, printing the error codes at the places it happened helps to
discover were's a bug at the code.

Before this change, a do { } while (0) loop and lots of breaks inside
were used to propagate errors. While this works, if there are
loops inside other loops, it could be easy to forget to add another
break, causing the error to not abort the function.

Also, as not all functions were reporting errors, it is hard to
discover why something failed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 5233526..74e986f 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -318,11 +318,13 @@ static int i2c_read1(struct i2c_adapter *adapter, u8 adr, u8 *val)
 	struct i2c_msg msgs[1] = { {.addr = adr, .flags = I2C_M_RD,
 				    .buf = val, .len = 1}
 	};
-	return (i2c_transfer(adapter, msgs, 1) == 1) ? 0 : -1;
+
+	return i2c_transfer(adapter, msgs, 1);
 }
 
 static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 {
+	int status;
 	struct i2c_msg msg = {
 	    .addr = adr, .flags = 0, .buf = data, .len = len };
 
@@ -333,16 +335,20 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 			printk(KERN_CONT " %02x", data[i]);
 		printk(KERN_CONT "\n");
 	}
-	if (i2c_transfer(adap, &msg, 1) != 1) {
+	status = i2c_transfer(adap, &msg, 1);
+	if (status >= 0 && status != 1)
+		status = -EIO;
+
+	if (status < 0)
 		printk(KERN_ERR "drxk: i2c write error at addr 0x%02x\n", adr);
-		return -1;
-	}
-	return 0;
+
+	return status;
 }
 
 static int i2c_read(struct i2c_adapter *adap,
 		    u8 adr, u8 *msg, int len, u8 *answ, int alen)
 {
+	int status;
 	struct i2c_msg msgs[2] = {
 		{.addr = adr, .flags = 0,
 				    .buf = msg, .len = len},
@@ -356,12 +362,15 @@ static int i2c_read(struct i2c_adapter *adap,
 			printk(KERN_CONT " %02x", msg[i]);
 		printk(KERN_CONT "\n");
 	}
-	if (i2c_transfer(adap, msgs, 2) != 2) {
+	status = i2c_transfer(adap, msgs, 2);
+	if (status != 2) {
 		if (debug > 2)
 			printk(KERN_CONT ": ERROR!\n");
+		if (status >= 0)
+			status = -EIO;
 
 		printk(KERN_ERR "drxk: i2c read error at addr 0x%02x\n", adr);
-		return -1;
+		return status;
 	}
 	if (debug > 2) {
 		int i;
@@ -375,6 +384,7 @@ static int i2c_read(struct i2c_adapter *adap,
 
 static int read16_flags(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 {
+	int status;
 	u8 adr = state->demod_address, mm1[4], mm2[2], len;
 
 	if (state->single_master)
@@ -392,8 +402,9 @@ static int read16_flags(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 		len = 2;
 	}
 	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
-	if (i2c_read(state->i2c, adr, mm1, len, mm2, 2) < 0)
-		return -1;
+	status = i2c_read(state->i2c, adr, mm1, len, mm2, 2);
+	if (status < 0)
+		return status;
 	if (data)
 		*data = mm2[0] | (mm2[1] << 8);
 
@@ -407,6 +418,7 @@ static int read16(struct drxk_state *state, u32 reg, u16 *data)
 
 static int read32_flags(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 {
+	int status;
 	u8 adr = state->demod_address, mm1[4], mm2[4], len;
 
 	if (state->single_master)
@@ -424,8 +436,9 @@ static int read32_flags(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 		len = 2;
 	}
 	dprintk(2, "(0x%08x, 0x%02x)\n", reg, flags);
-	if (i2c_read(state->i2c, adr, mm1, len, mm2, 4) < 0)
-		return -1;
+	status = i2c_read(state->i2c, adr, mm1, len, mm2, 4);
+	if (status < 0)
+		return status;
 	if (data)
 		*data = mm2[0] | (mm2[1] << 8) |
 		    (mm2[2] << 16) | (mm2[3] << 24);
@@ -459,9 +472,7 @@ static int write16_flags(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 	mm[len + 1] = (data >> 8) & 0xff;
 
 	dprintk(2, "(0x%08x, 0x%04x, 0x%02x)\n", reg, data, flags);
-	if (i2c_write(state->i2c, adr, mm, len + 2) < 0)
-		return -1;
-	return 0;
+	return i2c_write(state->i2c, adr, mm, len + 2);
 }
 
 static int write16(struct drxk_state *state, u32 reg, u16 data)
@@ -491,9 +502,8 @@ static int write32_flags(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 	mm[len + 2] = (data >> 16) & 0xff;
 	mm[len + 3] = (data >> 24) & 0xff;
 	dprintk(2, "(0x%08x, 0x%08x, 0x%02x)\n", reg, data, flags);
-	if (i2c_write(state->i2c, adr, mm, len + 4) < 0)
-		return -1;
-	return 0;
+
+	return i2c_write(state->i2c, adr, mm, len + 4);
 }
 
 static int write32(struct drxk_state *state, u32 reg, u32 data)
@@ -567,33 +577,41 @@ int PowerUpDevice(struct drxk_state *state)
 	dprintk(1, "\n");
 
 	status = i2c_read1(state->i2c, state->demod_address, &data);
-	if (status < 0)
+	if (status < 0) {
 		do {
 			data = 0;
-			if (i2c_write(state->i2c,
-				      state->demod_address, &data, 1) < 0)
-				printk(KERN_ERR "drxk: powerup failed\n");
+			status = i2c_write(state->i2c, state->demod_address,
+					   &data, 1);
 			msleep(10);
 			retryCount++;
-		} while (i2c_read1(state->i2c,
-				   state->demod_address, &data) < 0 &&
+			if (status < 0)
+				continue;
+			status = i2c_read1(state->i2c, state->demod_address,
+					   &data);
+		} while (status < 0 &&
 			 (retryCount < DRXK_MAX_RETRIES_POWERUP));
-	if (retryCount >= DRXK_MAX_RETRIES_POWERUP)
-		return -1;
-	do {
-		/* Make sure all clk domains are active */
-		status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_NONE);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
-		if (status < 0)
-			break;
-		/* Enable pll lock tests */
-		status = write16(state, SIO_CC_PLL_LOCK__A, 1);
-		if (status < 0)
-			break;
-		state->m_currentPowerMode = DRX_POWER_UP;
-	} while (0);
+		if (status < 0 && retryCount >= DRXK_MAX_RETRIES_POWERUP)
+			goto error;
+	}
+
+	/* Make sure all clk domains are active */
+	status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_NONE);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+	if (status < 0)
+		goto error;
+	/* Enable pll lock tests */
+	status = write16(state, SIO_CC_PLL_LOCK__A, 1);
+	if (status < 0)
+		goto error;
+
+	state->m_currentPowerMode = DRX_POWER_UP;
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+
 	return status;
 }
 
@@ -863,28 +881,27 @@ static int DRXX_Open(struct drxk_state *state)
 	u16 key = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* stop lock indicator process */
-		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-		if (status < 0)
-			break;
-		/* Check device id */
-		status = read16(state, SIO_TOP_COMM_KEY__A, &key);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
-		if (status < 0)
-			break;
-		status = read32(state, SIO_TOP_JTAGID_LO__A, &jtag);
-		if (status < 0)
-			break;
-		status = read16(state, SIO_PDR_UIO_IN_HI__A, &bid);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_TOP_COMM_KEY__A, key);
-		if (status < 0)
-			break;
-	} while (0);
+	/* stop lock indicator process */
+	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	if (status < 0)
+		goto error;
+	/* Check device id */
+	status = read16(state, SIO_TOP_COMM_KEY__A, &key);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
+	if (status < 0)
+		goto error;
+	status = read32(state, SIO_TOP_JTAGID_LO__A, &jtag);
+	if (status < 0)
+		goto error;
+	status = read16(state, SIO_PDR_UIO_IN_HI__A, &bid);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_TOP_COMM_KEY__A, key);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -895,177 +912,183 @@ static int GetDeviceCapabilities(struct drxk_state *state)
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		/* driver 0.9.0 */
-		/* stop lock indicator process */
-		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-		if (status < 0)
-			break;
 
-		status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
-		if (status < 0)
-			break;
-		status = read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
-		if (status < 0)
-			break;
+	/* driver 0.9.0 */
+	/* stop lock indicator process */
+	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+	if (status < 0)
+		goto error;
+	status = read16(state, SIO_PDR_OHW_CFG__A, &sioPdrOhwCfg);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
+	if (status < 0)
+		goto error;
 
-		switch ((sioPdrOhwCfg & SIO_PDR_OHW_CFG_FREF_SEL__M)) {
-		case 0:
-			/* ignore (bypass ?) */
-			break;
-		case 1:
-			/* 27 MHz */
-			state->m_oscClockFreq = 27000;
-			break;
-		case 2:
-			/* 20.25 MHz */
-			state->m_oscClockFreq = 20250;
-			break;
-		case 3:
-			/* 4 MHz */
-			state->m_oscClockFreq = 20250;
-			break;
-		default:
-			return -1;
-		}
-		/*
-		   Determine device capabilities
-		   Based on pinning v14
-		 */
-		status = read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
-		if (status < 0)
-			break;
-		/* driver 0.9.0 */
-		switch ((sioTopJtagidLo >> 29) & 0xF) {
-		case 0:
-			state->m_deviceSpin = DRXK_SPIN_A1;
-			break;
-		case 2:
-			state->m_deviceSpin = DRXK_SPIN_A2;
-			break;
-		case 3:
-			state->m_deviceSpin = DRXK_SPIN_A3;
-			break;
-		default:
-			state->m_deviceSpin = DRXK_SPIN_UNKNOWN;
-			status = -1;
-			break;
-		}
-		switch ((sioTopJtagidLo >> 12) & 0xFF) {
-		case 0x13:
-			/* typeId = DRX3913K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = false;
-			state->m_hasAudio = false;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = true;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = false;
-			state->m_hasGPIO1 = false;
-			state->m_hasIRQN = false;
-			break;
-		case 0x15:
-			/* typeId = DRX3915K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = false;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = false;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x16:
-			/* typeId = DRX3916K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = false;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = false;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x18:
-			/* typeId = DRX3918K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = true;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = false;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x21:
-			/* typeId = DRX3921K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = true;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = true;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x23:
-			/* typeId = DRX3923K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = true;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = true;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x25:
-			/* typeId = DRX3925K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = true;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = true;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		case 0x26:
-			/* typeId = DRX3926K_TYPE_ID */
-			state->m_hasLNA = false;
-			state->m_hasOOB = false;
-			state->m_hasATV = true;
-			state->m_hasAudio = false;
-			state->m_hasDVBT = true;
-			state->m_hasDVBC = true;
-			state->m_hasSAWSW = true;
-			state->m_hasGPIO2 = true;
-			state->m_hasGPIO1 = true;
-			state->m_hasIRQN = false;
-			break;
-		default:
-			printk(KERN_ERR "drxk: DeviceID not supported = %02x\n",
-			       ((sioTopJtagidLo >> 12) & 0xFF));
-			status = -1;
-			break;
-		}
-	} while (0);
+	switch ((sioPdrOhwCfg & SIO_PDR_OHW_CFG_FREF_SEL__M)) {
+	case 0:
+		/* ignore (bypass ?) */
+		break;
+	case 1:
+		/* 27 MHz */
+		state->m_oscClockFreq = 27000;
+		break;
+	case 2:
+		/* 20.25 MHz */
+		state->m_oscClockFreq = 20250;
+		break;
+	case 3:
+		/* 4 MHz */
+		state->m_oscClockFreq = 20250;
+		break;
+	default:
+		printk(KERN_ERR "drxk: Clock Frequency is unkonwn\n");
+		return -EINVAL;
+	}
+	/*
+		Determine device capabilities
+		Based on pinning v14
+		*/
+	status = read32(state, SIO_TOP_JTAGID_LO__A, &sioTopJtagidLo);
+	if (status < 0)
+		goto error;
+	/* driver 0.9.0 */
+	switch ((sioTopJtagidLo >> 29) & 0xF) {
+	case 0:
+		state->m_deviceSpin = DRXK_SPIN_A1;
+		break;
+	case 2:
+		state->m_deviceSpin = DRXK_SPIN_A2;
+		break;
+	case 3:
+		state->m_deviceSpin = DRXK_SPIN_A3;
+		break;
+	default:
+		state->m_deviceSpin = DRXK_SPIN_UNKNOWN;
+		status = -EINVAL;
+		printk(KERN_ERR "drxk: Spin unknown\n");
+		goto error2;
+	}
+	switch ((sioTopJtagidLo >> 12) & 0xFF) {
+	case 0x13:
+		/* typeId = DRX3913K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = false;
+		state->m_hasAudio = false;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = true;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = false;
+		state->m_hasGPIO1 = false;
+		state->m_hasIRQN = false;
+		break;
+	case 0x15:
+		/* typeId = DRX3915K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = false;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = false;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x16:
+		/* typeId = DRX3916K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = false;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = false;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x18:
+		/* typeId = DRX3918K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = true;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = false;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x21:
+		/* typeId = DRX3921K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = true;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = true;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x23:
+		/* typeId = DRX3923K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = true;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = true;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x25:
+		/* typeId = DRX3925K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = true;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = true;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	case 0x26:
+		/* typeId = DRX3926K_TYPE_ID */
+		state->m_hasLNA = false;
+		state->m_hasOOB = false;
+		state->m_hasATV = true;
+		state->m_hasAudio = false;
+		state->m_hasDVBT = true;
+		state->m_hasDVBC = true;
+		state->m_hasSAWSW = true;
+		state->m_hasGPIO2 = true;
+		state->m_hasGPIO1 = true;
+		state->m_hasIRQN = false;
+		break;
+	default:
+		printk(KERN_ERR "drxk: DeviceID not supported = %02x\n",
+			((sioTopJtagidLo >> 12) & 0xFF));
+		status = -EINVAL;
+		goto error2;
+	}
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+
+error2:
 	return status;
 }
 
@@ -1079,7 +1102,7 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 	/* Write command */
 	status = write16(state, SIO_HI_RA_RAM_CMD__A, cmd);
 	if (status < 0)
-		return status;
+		goto error;
 	if (cmd == SIO_HI_RA_RAM_CMD_RESET)
 		msleep(1);
 
@@ -1100,11 +1123,14 @@ static int HI_Command(struct drxk_state *state, u16 cmd, u16 *pResult)
 					  &waitCmd);
 		} while ((status < 0) && (retryCount < DRXK_MAX_RETRIES)
 			 && (waitCmd != 0));
-
-		if (status == 0)
-			status = read16(state, SIO_HI_RA_RAM_RES__A,
-					pResult);
+		if (status < 0)
+			goto error;
+		status = read16(state, SIO_HI_RA_RAM_RES__A, pResult);
 	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+
 	return status;
 }
 
@@ -1115,32 +1141,34 @@ static int HI_CfgCommand(struct drxk_state *state)
 	dprintk(1, "\n");
 
 	mutex_lock(&state->mutex);
-	do {
-		status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_HICfgCtrl);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_HICfgWakeUpKey);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_HICfgBridgeDelay);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_HICfgTimingDiv);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
-		if (status < 0)
-			break;
-		status = HI_Command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
-		if (status < 0)
-			break;
 
-		state->m_HICfgCtrl &= ~SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
-	} while (0);
+	status = write16(state, SIO_HI_RA_RAM_PAR_6__A, state->m_HICfgTimeout);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_HI_RA_RAM_PAR_5__A, state->m_HICfgCtrl);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_HI_RA_RAM_PAR_4__A, state->m_HICfgWakeUpKey);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_HI_RA_RAM_PAR_3__A, state->m_HICfgBridgeDelay);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_HI_RA_RAM_PAR_2__A, state->m_HICfgTimingDiv);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+	if (status < 0)
+		goto error;
+	status = HI_Command(state, SIO_HI_RA_RAM_CMD_CONFIG, 0);
+	if (status < 0)
+		goto error;
+
+	state->m_HICfgCtrl &= ~SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
+error:
 	mutex_unlock(&state->mutex);
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1152,6 +1180,7 @@ static int InitHI(struct drxk_state *state)
 	state->m_HICfgTimeout = 0x96FF;
 	/* port/bridge/power down ctrl */
 	state->m_HICfgCtrl = SIO_HI_RA_RAM_PAR_5_CFG_SLV0_SLAVE;
+
 	return HI_CfgCommand(state);
 }
 
@@ -1162,139 +1191,139 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	u16 sioPdrMdxCfg = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* stop lock indicator process */
-		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-		if (status < 0)
-			break;
 
-		/*  MPEG TS pad configuration */
-		status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+	/* stop lock indicator process */
+	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	if (status < 0)
+		goto error;
+
+	/*  MPEG TS pad configuration */
+	status = write16(state, SIO_TOP_COMM_KEY__A, 0xFABA);
+	if (status < 0)
+		goto error;
+
+	if (mpegEnable == false) {
+		/*  Set MPEG TS pads to inputmode */
+		status = write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MCLK_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD0_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD1_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD2_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD3_CFG__A, 0x0000);
 		if (status < 0)
-			break;
+			goto error;
+		status = write16(state, SIO_PDR_MD4_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD5_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD6_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MD7_CFG__A, 0x0000);
+		if (status < 0)
+			goto error;
+	} else {
+		/* Enable MPEG output */
+		sioPdrMdxCfg =
+			((state->m_TSDataStrength <<
+			SIO_PDR_MD0_CFG_DRIVE__B) | 0x0003);
+		sioPdrMclkCfg = ((state->m_TSClockkStrength <<
+					SIO_PDR_MCLK_CFG_DRIVE__B) |
+					0x0003);
 
-		if (mpegEnable == false) {
-			/*  Set MPEG TS pads to inputmode */
-			status = write16(state, SIO_PDR_MSTRT_CFG__A, 0x0000);
+		status = write16(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);	/* Disable */
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
+		if (status < 0)
+			goto error;
+		if (state->m_enableParallel == true) {
+			/* paralel -> enable MD1 to MD7 */
+			status = write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
+			if (status < 0)
+				goto error;
+			status = write16(state, SIO_PDR_MD2_CFG__A, sioPdrMdxCfg);
+			if (status < 0)
+				goto error;
+			status = write16(state, SIO_PDR_MD3_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);
+				goto error;
+			status = write16(state, SIO_PDR_MD4_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MCLK_CFG__A, 0x0000);
+				goto error;
+			status = write16(state, SIO_PDR_MD5_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);
+				goto error;
+			status = write16(state, SIO_PDR_MD6_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MD0_CFG__A, 0x0000);
+				goto error;
+			status = write16(state, SIO_PDR_MD7_CFG__A, sioPdrMdxCfg);
 			if (status < 0)
-				break;
+				goto error;
+		} else {
+			sioPdrMdxCfg = ((state->m_TSDataStrength <<
+						SIO_PDR_MD0_CFG_DRIVE__B)
+					| 0x0003);
+			/* serial -> disable MD1 to MD7 */
 			status = write16(state, SIO_PDR_MD1_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD2_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD3_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD4_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD5_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD6_CFG__A, 0x0000);
 			if (status < 0)
-				break;
+				goto error;
 			status = write16(state, SIO_PDR_MD7_CFG__A, 0x0000);
 			if (status < 0)
-				break;
-		} else {
-			/* Enable MPEG output */
-			sioPdrMdxCfg =
-			    ((state->m_TSDataStrength <<
-			      SIO_PDR_MD0_CFG_DRIVE__B) | 0x0003);
-			sioPdrMclkCfg = ((state->m_TSClockkStrength <<
-					  SIO_PDR_MCLK_CFG_DRIVE__B) |
-					 0x0003);
-
-			status = write16(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
-			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);	/* Disable */
-			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
-			if (status < 0)
-				break;
-			if (state->m_enableParallel == true) {
-				/* paralel -> enable MD1 to MD7 */
-				status = write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD2_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD3_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD4_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD5_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD6_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD7_CFG__A, sioPdrMdxCfg);
-				if (status < 0)
-					break;
-			} else {
-				sioPdrMdxCfg = ((state->m_TSDataStrength <<
-						 SIO_PDR_MD0_CFG_DRIVE__B)
-						| 0x0003);
-				/* serial -> disable MD1 to MD7 */
-				status = write16(state, SIO_PDR_MD1_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD2_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD3_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD4_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD5_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD6_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-				status = write16(state, SIO_PDR_MD7_CFG__A, 0x0000);
-				if (status < 0)
-					break;
-			}
-			status = write16(state, SIO_PDR_MCLK_CFG__A, sioPdrMclkCfg);
-			if (status < 0)
-				break;
-			status = write16(state, SIO_PDR_MD0_CFG__A, sioPdrMdxCfg);
-			if (status < 0)
-				break;
+				goto error;
 		}
-		/*  Enable MB output over MPEG pads and ctl input */
-		status = write16(state, SIO_PDR_MON_CFG__A, 0x0000);
+		status = write16(state, SIO_PDR_MCLK_CFG__A, sioPdrMclkCfg);
 		if (status < 0)
-			break;
-		/*  Write nomagic word to enable pdr reg write */
-		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
+			goto error;
+		status = write16(state, SIO_PDR_MD0_CFG__A, sioPdrMdxCfg);
 		if (status < 0)
-			break;
-	} while (0);
+			goto error;
+	}
+	/*  Enable MB output over MPEG pads and ctl input */
+	status = write16(state, SIO_PDR_MON_CFG__A, 0x0000);
+	if (status < 0)
+		goto error;
+	/*  Write nomagic word to enable pdr reg write */
+	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1313,36 +1342,38 @@ static int BLChainCmd(struct drxk_state *state,
 	unsigned long end;
 
 	dprintk(1, "\n");
-
 	mutex_lock(&state->mutex);
+	status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_CHAIN_ADDR__A, romOffset);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_CHAIN_LEN__A, nrOfElements);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
+	if (status < 0)
+		goto error;
+
+	end = jiffies + msecs_to_jiffies(timeOut);
 	do {
-		status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_CHAIN);
+		msleep(1);
+		status = read16(state, SIO_BL_STATUS__A, &blStatus);
 		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_CHAIN_ADDR__A, romOffset);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_CHAIN_LEN__A, nrOfElements);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
-		if (status < 0)
-			break;
-		end = jiffies + msecs_to_jiffies(timeOut);
+			goto error;
+	} while ((blStatus == 0x1) &&
+			((time_is_after_jiffies(end))));
 
-		do {
-			msleep(1);
-			status = read16(state, SIO_BL_STATUS__A, &blStatus);
-			if (status < 0)
-				break;
-		} while ((blStatus == 0x1) &&
-			 ((time_is_after_jiffies(end))));
-		if (blStatus == 0x1) {
-			printk(KERN_ERR "drxk: SIO not ready\n");
-			mutex_unlock(&state->mutex);
-			return -1;
-		}
-	} while (0);
+	if (blStatus == 0x1) {
+		printk(KERN_ERR "drxk: SIO not ready\n");
+		status = -EINVAL;
+		goto error2;
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+error2:
 	mutex_unlock(&state->mutex);
 	return status;
 }
@@ -1421,25 +1452,24 @@ static int DVBTEnableOFDMTokenRing(struct drxk_state *state, bool enable)
 		desiredStatus = SIO_OFDM_SH_OFDM_RING_STATUS_DOWN;
 	}
 
-	status = (read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data));
-
-	if (data == desiredStatus) {
+	status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
+	if (status >= 0 && data == desiredStatus) {
 		/* tokenring already has correct status */
 		return status;
 	}
 	/* Disable/enable dvbt tokenring bridge   */
-	status =
-	    write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desiredCtrl);
+	status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, desiredCtrl);
 
 	end = jiffies + msecs_to_jiffies(DRXK_OFDM_TR_SHUTDOWN_TIMEOUT);
 	do {
 		status = read16(state, SIO_OFDM_SH_OFDM_RING_STATUS__A, &data);
-		if (status < 0)
+		if ((status >= 0 && data == desiredStatus) || time_is_after_jiffies(end))
 			break;
-	} while ((data != desiredStatus) && ((time_is_after_jiffies(end))));
+		msleep(1);
+	} while (1);
 	if (data != desiredStatus) {
 		printk(KERN_ERR "drxk: SIO not ready\n");
-		return -1;
+		return -EINVAL;
 	}
 	return status;
 }
@@ -1452,25 +1482,26 @@ static int MPEGTSStop(struct drxk_state *state)
 
 	dprintk(1, "\n");
 
-	do {
-		/* Gracefull shutdown (byte boundaries) */
-		status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
-		if (status < 0)
-			break;
-		fecOcSncMode |= FEC_OC_SNC_MODE_SHUTDOWN__M;
-		status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
-		if (status < 0)
-			break;
+	/* Gracefull shutdown (byte boundaries) */
+	status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+	if (status < 0)
+		goto error;
+	fecOcSncMode |= FEC_OC_SNC_MODE_SHUTDOWN__M;
+	status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+	if (status < 0)
+		goto error;
+
+	/* Suppress MCLK during absence of data */
+	status = read16(state, FEC_OC_IPR_MODE__A, &fecOcIprMode);
+	if (status < 0)
+		goto error;
+	fecOcIprMode |= FEC_OC_IPR_MODE_MCLK_DIS_DAT_ABS__M;
+	status = write16(state, FEC_OC_IPR_MODE__A, fecOcIprMode);
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
-		/* Suppress MCLK during absence of data */
-		status = read16(state, FEC_OC_IPR_MODE__A, &fecOcIprMode);
-		if (status < 0)
-			break;
-		fecOcIprMode |= FEC_OC_IPR_MODE_MCLK_DIS_DAT_ABS__M;
-		status = write16(state, FEC_OC_IPR_MODE__A, fecOcIprMode);
-		if (status < 0)
-			break;
-	} while (0);
 	return status;
 }
 
@@ -1482,82 +1513,83 @@ static int scu_command(struct drxk_state *state,
 #error DRXK register mapping no longer compatible with this routine!
 #endif
 	u16 curCmd = 0;
-	int status;
+	int status = -EINVAL;
 	unsigned long end;
+	u8 buffer[34];
+	int cnt = 0, ii;
 
 	dprintk(1, "\n");
 
 	if ((cmd == 0) || ((parameterLen > 0) && (parameter == NULL)) ||
 	    ((resultLen > 0) && (result == NULL)))
-		return -1;
+		goto error;
 
 	mutex_lock(&state->mutex);
+
+	/* assume that the command register is ready
+		since it is checked afterwards */
+	for (ii = parameterLen - 1; ii >= 0; ii -= 1) {
+		buffer[cnt++] = (parameter[ii] & 0xFF);
+		buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
+	}
+	buffer[cnt++] = (cmd & 0xFF);
+	buffer[cnt++] = ((cmd >> 8) & 0xFF);
+
+	write_block(state, SCU_RAM_PARAM_0__A -
+			(parameterLen - 1), cnt, buffer);
+	/* Wait until SCU has processed command */
+	end = jiffies + msecs_to_jiffies(DRXK_MAX_WAITTIME);
 	do {
-		/* assume that the command register is ready
-		   since it is checked afterwards */
-		u8 buffer[34];
-		int cnt = 0, ii;
+		msleep(1);
+		status = read16(state, SCU_RAM_COMMAND__A, &curCmd);
+		if (status < 0)
+			goto error;
+	} while (!(curCmd == DRX_SCU_READY) && (time_is_after_jiffies(end)));
+	if (curCmd != DRX_SCU_READY) {
+		printk(KERN_ERR "drxk: SCU not ready\n");
+		status = -EIO;
+		goto error2;
+	}
+	/* read results */
+	if ((resultLen > 0) && (result != NULL)) {
+		s16 err;
+		int ii;
 
-		for (ii = parameterLen - 1; ii >= 0; ii -= 1) {
-			buffer[cnt++] = (parameter[ii] & 0xFF);
-			buffer[cnt++] = ((parameter[ii] >> 8) & 0xFF);
-		}
-		buffer[cnt++] = (cmd & 0xFF);
-		buffer[cnt++] = ((cmd >> 8) & 0xFF);
-
-		write_block(state, SCU_RAM_PARAM_0__A -
-			   (parameterLen - 1), cnt, buffer);
-		/* Wait until SCU has processed command */
-		end = jiffies + msecs_to_jiffies(DRXK_MAX_WAITTIME);
-		do {
-			msleep(1);
-			status = read16(state, SCU_RAM_COMMAND__A, &curCmd);
+		for (ii = resultLen - 1; ii >= 0; ii -= 1) {
+			status = read16(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
 			if (status < 0)
-				break;
-		} while (!(curCmd == DRX_SCU_READY)
-			 && (time_is_after_jiffies(end)));
-		if (curCmd != DRX_SCU_READY) {
-			printk(KERN_ERR "drxk: SCU not ready\n");
-			mutex_unlock(&state->mutex);
-			return -1;
+				goto error;
 		}
-		/* read results */
-		if ((resultLen > 0) && (result != NULL)) {
-			s16 err;
-			int ii;
 
-			for (ii = resultLen - 1; ii >= 0; ii -= 1) {
-				status = read16(state, SCU_RAM_PARAM_0__A - ii, &result[ii]);
-				if (status < 0)
-					break;
-			}
+		/* Check if an error was reported by SCU */
+		err = (s16)result[0];
 
-			/* Check if an error was reported by SCU */
-			err = (s16) result[0];
-
-			/* check a few fixed error codes */
-			if (err == SCU_RESULT_UNKSTD) {
-				printk(KERN_ERR "drxk: SCU_RESULT_UNKSTD\n");
-				mutex_unlock(&state->mutex);
-				return -1;
-			} else if (err == SCU_RESULT_UNKCMD) {
-				printk(KERN_ERR "drxk: SCU_RESULT_UNKCMD\n");
-				mutex_unlock(&state->mutex);
-				return -1;
-			}
-			/* here it is assumed that negative means error,
-			   and positive no error */
-			else if (err < 0) {
-				printk(KERN_ERR "drxk: %s ERROR\n", __func__);
-				mutex_unlock(&state->mutex);
-				return -1;
-			}
+		/* check a few fixed error codes */
+		if (err == SCU_RESULT_UNKSTD) {
+			printk(KERN_ERR "drxk: SCU_RESULT_UNKSTD\n");
+			status = -EINVAL;
+			goto error2;
+		} else if (err == SCU_RESULT_UNKCMD) {
+			printk(KERN_ERR "drxk: SCU_RESULT_UNKCMD\n");
+			status = -EINVAL;
+			goto error2;
+		} else if (err < 0) {
+			/*
+			 * here it is assumed that a nagative result means
+			 *  error, and positive no error
+			 */
+			printk(KERN_ERR "drxk: %s ERROR: %d\n", __func__, err);
+			status = -EINVAL;
+			goto error2;
 		}
-	} while (0);
-	mutex_unlock(&state->mutex);
+	}
+
+error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: %s: status = %d\n", __func__, status);
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
+error2:
+	mutex_unlock(&state->mutex);
 	return status;
 }
 
@@ -1568,30 +1600,30 @@ static int SetIqmAf(struct drxk_state *state, bool active)
 
 	dprintk(1, "\n");
 
-	do {
-		/* Configure IQM */
-		status = read16(state, IQM_AF_STDBY__A, &data);
-		if (status < 0)
-			break;
-		if (!active) {
-			data |= (IQM_AF_STDBY_STDBY_ADC_STANDBY
-				 | IQM_AF_STDBY_STDBY_AMP_STANDBY
-				 | IQM_AF_STDBY_STDBY_PD_STANDBY
-				 | IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY
-				 | IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY);
-		} else {	/* active */
+	/* Configure IQM */
+	status = read16(state, IQM_AF_STDBY__A, &data);
+	if (status < 0)
+		goto error;
 
-			data &= ((~IQM_AF_STDBY_STDBY_ADC_STANDBY)
-				 & (~IQM_AF_STDBY_STDBY_AMP_STANDBY)
-				 & (~IQM_AF_STDBY_STDBY_PD_STANDBY)
-				 & (~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY)
-				 & (~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY)
-			    );
-		}
-		status = write16(state, IQM_AF_STDBY__A, data);
-		if (status < 0)
-			break;
-	} while (0);
+	if (!active) {
+		data |= (IQM_AF_STDBY_STDBY_ADC_STANDBY
+				| IQM_AF_STDBY_STDBY_AMP_STANDBY
+				| IQM_AF_STDBY_STDBY_PD_STANDBY
+				| IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY
+				| IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY);
+	} else {
+		data &= ((~IQM_AF_STDBY_STDBY_ADC_STANDBY)
+				& (~IQM_AF_STDBY_STDBY_AMP_STANDBY)
+				& (~IQM_AF_STDBY_STDBY_PD_STANDBY)
+				& (~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY)
+				& (~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY)
+			);
+	}
+	status = write16(state, IQM_AF_STDBY__A, data);
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1604,7 +1636,7 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 
 	/* Check arguments */
 	if (mode == NULL)
-		return -1;
+		return -EINVAL;
 
 	switch (*mode) {
 	case DRX_POWER_UP:
@@ -1624,7 +1656,7 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 		break;
 	default:
 		/* Unknow sleep mode */
-		return -1;
+		return -EINVAL;
 		break;
 	}
 
@@ -1634,14 +1666,12 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 
 	/* For next steps make sure to start from DRX_POWER_UP mode */
 	if (state->m_currentPowerMode != DRX_POWER_UP) {
-		do {
-			status = PowerUpDevice(state);
-			if (status < 0)
-				break;
-			status = DVBTEnableOFDMTokenRing(state, true);
-			if (status < 0)
-				break;
-		} while (0);
+		status = PowerUpDevice(state);
+		if (status < 0)
+			goto error;
+		status = DVBTEnableOFDMTokenRing(state, true);
+		if (status < 0)
+			goto error;
 	}
 
 	if (*mode == DRX_POWER_UP) {
@@ -1656,48 +1686,51 @@ static int CtrlPowerMode(struct drxk_state *state, enum DRXPowerMode *mode)
 		/* Power down device */
 		/* stop all comm_exec */
 		/* Stop and power down previous standard */
-		do {
-			switch (state->m_OperationMode) {
-			case OM_DVBT:
-				status = MPEGTSStop(state);
-				if (status < 0)
-					break;
-				status = PowerDownDVBT(state, false);
-				if (status < 0)
-					break;
-				break;
-			case OM_QAM_ITU_A:
-			case OM_QAM_ITU_C:
-				status = MPEGTSStop(state);
-				if (status < 0)
-					break;
-				status = PowerDownQAM(state);
-				if (status < 0)
-					break;
-				break;
-			default:
-				break;
-			}
-			status = DVBTEnableOFDMTokenRing(state, false);
+		switch (state->m_OperationMode) {
+		case OM_DVBT:
+			status = MPEGTSStop(state);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_CC_PWD_MODE__A, sioCcPwdMode);
+				goto error;
+			status = PowerDownDVBT(state, false);
 			if (status < 0)
-				break;
-			status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+				goto error;
+			break;
+		case OM_QAM_ITU_A:
+		case OM_QAM_ITU_C:
+			status = MPEGTSStop(state);
 			if (status < 0)
-				break;
+				goto error;
+			status = PowerDownQAM(state);
+			if (status < 0)
+				goto error;
+			break;
+		default:
+			break;
+		}
+		status = DVBTEnableOFDMTokenRing(state, false);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_CC_PWD_MODE__A, sioCcPwdMode);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+		if (status < 0)
+			goto error;
 
-			if (*mode != DRXK_POWER_DOWN_OFDM) {
-				state->m_HICfgCtrl |=
-				    SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
-				status = HI_CfgCommand(state);
-				if (status < 0)
-					break;
-			}
-		} while (0);
+		if (*mode != DRXK_POWER_DOWN_OFDM) {
+			state->m_HICfgCtrl |=
+				SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
+			status = HI_CfgCommand(state);
+			if (status < 0)
+				goto error;
+		}
 	}
 	state->m_currentPowerMode = *mode;
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+
 	return status;
 }
 
@@ -1710,44 +1743,45 @@ static int PowerDownDVBT(struct drxk_state *state, bool setPowerMode)
 
 	dprintk(1, "\n");
 
-	do {
-		status = read16(state, SCU_COMM_EXEC__A, &data);
+	status = read16(state, SCU_COMM_EXEC__A, &data);
+	if (status < 0)
+		goto error;
+	if (data == SCU_COMM_EXEC_ACTIVE) {
+		/* Send OFDM stop command */
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
 		if (status < 0)
-			break;
-		if (data == SCU_COMM_EXEC_ACTIVE) {
-			/* Send OFDM stop command */
-			status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
-			if (status < 0)
-				break;
-			/* Send OFDM reset command */
-			status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
-			if (status < 0)
-				break;
-		}
-
-		/* Reset datapath for OFDM, processors first */
-		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+			goto error;
+		/* Send OFDM reset command */
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
 		if (status < 0)
-			break;
+			goto error;
+	}
 
-		/* powerdown AFE                   */
-		status = SetIqmAf(state, false);
-		if (status < 0)
-			break;
+	/* Reset datapath for OFDM, processors first */
+	status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+	if (status < 0)
+		goto error;
+
+	/* powerdown AFE                   */
+	status = SetIqmAf(state, false);
+	if (status < 0)
+		goto error;
 
-		/* powerdown to OFDM mode          */
-		if (setPowerMode) {
-			status = CtrlPowerMode(state, &powerMode);
-			if (status < 0)
-				break;
-		}
-	} while (0);
+	/* powerdown to OFDM mode          */
+	if (setPowerMode) {
+		status = CtrlPowerMode(state, &powerMode);
+		if (status < 0)
+			goto error;
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1762,127 +1796,118 @@ static int SetOperationMode(struct drxk_state *state,
 	   TODO investigate total power down instead of partial
 	   power down depending on "previous" standard.
 	 */
-	do {
-		/* disable HW lock indicator */
-		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-		if (status < 0)
-			break;
 
-		if (state->m_OperationMode != oMode) {
-			switch (state->m_OperationMode) {
-				/* OM_NONE was added for start up */
-			case OM_NONE:
-				break;
-			case OM_DVBT:
-				status = MPEGTSStop(state);
-				if (status < 0)
-					break;
-				status = PowerDownDVBT(state, true);
-				if (status < 0)
-					break;
-				state->m_OperationMode = OM_NONE;
-				break;
-			case OM_QAM_ITU_B:
-				status = -1;
-				break;
-			case OM_QAM_ITU_A:	/* fallthrough */
-			case OM_QAM_ITU_C:
-				status = MPEGTSStop(state);
-				if (status < 0)
-					break;
-				status = PowerDownQAM(state);
-				if (status < 0)
-					break;
-				state->m_OperationMode = OM_NONE;
-				break;
-			default:
-				status = -1;
-			}
-			status = status;
-			if (status < 0)
-				break;
+	/* disable HW lock indicator */
+	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	if (status < 0)
+		goto error;
 
-			/*
-			   Power up new standard
-			 */
-			switch (oMode) {
-			case OM_DVBT:
-				state->m_OperationMode = oMode;
-				status = SetDVBTStandard(state, oMode);
-				if (status < 0)
-					break;
-				break;
-			case OM_QAM_ITU_B:
-				status = -1;
-				break;
-			case OM_QAM_ITU_A:	/* fallthrough */
-			case OM_QAM_ITU_C:
-				state->m_OperationMode = oMode;
-				status = SetQAMStandard(state, oMode);
-				if (status < 0)
-					break;
-				break;
-			default:
-				status = -1;
-			}
+	if (state->m_OperationMode != oMode) {
+		switch (state->m_OperationMode) {
+			/* OM_NONE was added for start up */
+		case OM_NONE:
+			break;
+		case OM_DVBT:
+			status = MPEGTSStop(state);
+			if (status < 0)
+				goto error;
+			status = PowerDownDVBT(state, true);
+			if (status < 0)
+				goto error;
+			state->m_OperationMode = OM_NONE;
+			break;
+		case OM_QAM_ITU_A:	/* fallthrough */
+		case OM_QAM_ITU_C:
+			status = MPEGTSStop(state);
+			if (status < 0)
+				goto error;
+			status = PowerDownQAM(state);
+			if (status < 0)
+				goto error;
+			state->m_OperationMode = OM_NONE;
+			break;
+		case OM_QAM_ITU_B:
+		default:
+			status = -EINVAL;
+			goto error;
 		}
-		status = status;
-		if (status < 0)
+
+		/*
+			Power up new standard
+			*/
+		switch (oMode) {
+		case OM_DVBT:
+			status = SetDVBTStandard(state, oMode);
+			if (status < 0)
+				goto error;
+			state->m_OperationMode = oMode;
 			break;
-	} while (0);
-	return 0;
+		case OM_QAM_ITU_A:	/* fallthrough */
+		case OM_QAM_ITU_C:
+			status = SetQAMStandard(state, oMode);
+			if (status < 0)
+				goto error;
+			state->m_OperationMode = oMode;
+			break;
+		case OM_QAM_ITU_B:
+		default:
+			status = -EINVAL;
+		}
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+	return status;
 }
 
 static int Start(struct drxk_state *state, s32 offsetFreq,
 		 s32 IntermediateFrequency)
 {
-	int status = 0;
+	int status = -EINVAL;
+
+	u16 IFreqkHz;
+	s32 OffsetkHz = offsetFreq / 1000;
 
 	dprintk(1, "\n");
-	do {
-		u16 IFreqkHz;
-		s32 OffsetkHz = offsetFreq / 1000;
+	if (state->m_DrxkState != DRXK_STOPPED &&
+		state->m_DrxkState != DRXK_DTV_STARTED)
+		goto error;
 
-		if (state->m_DrxkState != DRXK_STOPPED &&
-		    state->m_DrxkState != DRXK_DTV_STARTED) {
-			status = -1;
-			break;
-		}
-		state->m_bMirrorFreqSpect =
-		    (state->param.inversion == INVERSION_ON);
+	state->m_bMirrorFreqSpect = (state->param.inversion == INVERSION_ON);
 
-		if (IntermediateFrequency < 0) {
-			state->m_bMirrorFreqSpect =
-			    !state->m_bMirrorFreqSpect;
-			IntermediateFrequency = -IntermediateFrequency;
-		}
+	if (IntermediateFrequency < 0) {
+		state->m_bMirrorFreqSpect = !state->m_bMirrorFreqSpect;
+		IntermediateFrequency = -IntermediateFrequency;
+	}
 
-		switch (state->m_OperationMode) {
-		case OM_QAM_ITU_A:
-		case OM_QAM_ITU_C:
-			IFreqkHz = (IntermediateFrequency / 1000);
-			status = SetQAM(state, IFreqkHz, OffsetkHz);
-			if (status < 0)
-				break;
-			state->m_DrxkState = DRXK_DTV_STARTED;
-			break;
-		case OM_DVBT:
-			IFreqkHz = (IntermediateFrequency / 1000);
-			status = MPEGTSStop(state);
-			if (status < 0)
-				break;
-			status = SetDVBT(state, IFreqkHz, OffsetkHz);
-			if (status < 0)
-				break;
-			status = DVBTStart(state);
-			if (status < 0)
-				break;
-			state->m_DrxkState = DRXK_DTV_STARTED;
-			break;
-		default:
-			break;
-		}
-	} while (0);
+	switch (state->m_OperationMode) {
+	case OM_QAM_ITU_A:
+	case OM_QAM_ITU_C:
+		IFreqkHz = (IntermediateFrequency / 1000);
+		status = SetQAM(state, IFreqkHz, OffsetkHz);
+		if (status < 0)
+			goto error;
+		state->m_DrxkState = DRXK_DTV_STARTED;
+		break;
+	case OM_DVBT:
+		IFreqkHz = (IntermediateFrequency / 1000);
+		status = MPEGTSStop(state);
+		if (status < 0)
+			goto error;
+		status = SetDVBT(state, IFreqkHz, OffsetkHz);
+		if (status < 0)
+			goto error;
+		status = DVBTStart(state);
+		if (status < 0)
+			goto error;
+		state->m_DrxkState = DRXK_DTV_STARTED;
+		break;
+	default:
+		break;
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -1897,12 +1922,12 @@ static int ShutDown(struct drxk_state *state)
 static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus,
 			 u32 Time)
 {
-	int status = 0;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
 	if (pLockStatus == NULL)
-		return -1;
+		goto error;
 
 	*pLockStatus = NOT_LOCKED;
 
@@ -1919,82 +1944,84 @@ static int GetLockStatus(struct drxk_state *state, u32 *pLockStatus,
 	default:
 		break;
 	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int MPEGTSStart(struct drxk_state *state)
 {
-	int status = 0;
+	int status;
 
 	u16 fecOcSncMode = 0;
 
-	do {
-		/* Allow OC to sync again */
-		status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
-		if (status < 0)
-			break;
-		fecOcSncMode &= ~FEC_OC_SNC_MODE_SHUTDOWN__M;
-		status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_SNC_UNLOCK__A, 1);
-		if (status < 0)
-			break;
-	} while (0);
+	/* Allow OC to sync again */
+	status = read16(state, FEC_OC_SNC_MODE__A, &fecOcSncMode);
+	if (status < 0)
+		goto error;
+	fecOcSncMode &= ~FEC_OC_SNC_MODE_SHUTDOWN__M;
+	status = write16(state, FEC_OC_SNC_MODE__A, fecOcSncMode);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_SNC_UNLOCK__A, 1);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int MPEGTSDtoInit(struct drxk_state *state)
 {
-	int status = -1;
+	int status;
 
 	dprintk(1, "\n");
 
-	do {
-		/* Rate integration settings */
-		status = write16(state, FEC_OC_RCN_CTL_STEP_LO__A, 0x0000);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_RCN_CTL_STEP_HI__A, 0x000C);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_RCN_GAIN__A, 0x000A);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_AVR_PARM_A__A, 0x0008);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_AVR_PARM_B__A, 0x0006);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_TMD_HI_MARGIN__A, 0x0680);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_TMD_LO_MARGIN__A, 0x0080);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_TMD_COUNT__A, 0x03F4);
-		if (status < 0)
-			break;
+	/* Rate integration settings */
+	status = write16(state, FEC_OC_RCN_CTL_STEP_LO__A, 0x0000);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_RCN_CTL_STEP_HI__A, 0x000C);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_RCN_GAIN__A, 0x000A);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_AVR_PARM_A__A, 0x0008);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_AVR_PARM_B__A, 0x0006);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_TMD_HI_MARGIN__A, 0x0680);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_TMD_LO_MARGIN__A, 0x0080);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_TMD_COUNT__A, 0x03F4);
+	if (status < 0)
+		goto error;
+
+	/* Additional configuration */
+	status = write16(state, FEC_OC_OCR_INVERT__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_SNC_LWM__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_SNC_HWM__A, 12);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
-		/* Additional configuration */
-		status = write16(state, FEC_OC_OCR_INVERT__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_SNC_LWM__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_SNC_HWM__A, 12);
-		if (status < 0)
-			break;
-	} while (0);
 	return status;
 }
 
 static int MPEGTSDtoSetup(struct drxk_state *state,
 			  enum OperationMode oMode)
 {
-	int status = -1;
+	int status;
 
 	u16 fecOcRegMode = 0;	/* FEC_OC_MODE       register value */
 	u16 fecOcRegIprMode = 0;	/* FEC_OC_IPR_MODE   register value */
@@ -2010,132 +2037,127 @@ static int MPEGTSDtoSetup(struct drxk_state *state,
 
 	dprintk(1, "\n");
 
-	do {
-		/* Check insertion of the Reed-Solomon parity bytes */
-		status = read16(state, FEC_OC_MODE__A, &fecOcRegMode);
-		if (status < 0)
-			break;
-		status = read16(state, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
-		if (status < 0)
-			break;
-		fecOcRegMode &= (~FEC_OC_MODE_PARITY__M);
-		fecOcRegIprMode &= (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
-		if (state->m_insertRSByte == true) {
-			/* enable parity symbol forward */
-			fecOcRegMode |= FEC_OC_MODE_PARITY__M;
-			/* MVAL disable during parity bytes */
-			fecOcRegIprMode |= FEC_OC_IPR_MODE_MVAL_DIS_PAR__M;
-			/* TS burst length to 204 */
-			fecOcDtoBurstLen = 204;
-		}
-
-		/* Check serial or parrallel output */
-		fecOcRegIprMode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
-		if (state->m_enableParallel == false) {
-			/* MPEG data output is serial -> set ipr_mode[0] */
-			fecOcRegIprMode |= FEC_OC_IPR_MODE_SERIAL__M;
-		}
+	/* Check insertion of the Reed-Solomon parity bytes */
+	status = read16(state, FEC_OC_MODE__A, &fecOcRegMode);
+	if (status < 0)
+		goto error;
+	status = read16(state, FEC_OC_IPR_MODE__A, &fecOcRegIprMode);
+	if (status < 0)
+		goto error;
+	fecOcRegMode &= (~FEC_OC_MODE_PARITY__M);
+	fecOcRegIprMode &= (~FEC_OC_IPR_MODE_MVAL_DIS_PAR__M);
+	if (state->m_insertRSByte == true) {
+		/* enable parity symbol forward */
+		fecOcRegMode |= FEC_OC_MODE_PARITY__M;
+		/* MVAL disable during parity bytes */
+		fecOcRegIprMode |= FEC_OC_IPR_MODE_MVAL_DIS_PAR__M;
+		/* TS burst length to 204 */
+		fecOcDtoBurstLen = 204;
+	}
 
-		switch (oMode) {
-		case OM_DVBT:
-			maxBitRate = state->m_DVBTBitrate;
-			fecOcTmdMode = 3;
-			fecOcRcnCtlRate = 0xC00000;
-			staticCLK = state->m_DVBTStaticCLK;
-			break;
-		case OM_QAM_ITU_A:	/* fallthrough */
-		case OM_QAM_ITU_C:
-			fecOcTmdMode = 0x0004;
-			fecOcRcnCtlRate = 0xD2B4EE;	/* good for >63 Mb/s */
-			maxBitRate = state->m_DVBCBitrate;
-			staticCLK = state->m_DVBCStaticCLK;
-			break;
-		default:
-			status = -1;
-		}		/* switch (standard) */
-		status = status;
-		if (status < 0)
-			break;
+	/* Check serial or parrallel output */
+	fecOcRegIprMode &= (~(FEC_OC_IPR_MODE_SERIAL__M));
+	if (state->m_enableParallel == false) {
+		/* MPEG data output is serial -> set ipr_mode[0] */
+		fecOcRegIprMode |= FEC_OC_IPR_MODE_SERIAL__M;
+	}
 
-		/* Configure DTO's */
-		if (staticCLK) {
-			u32 bitRate = 0;
+	switch (oMode) {
+	case OM_DVBT:
+		maxBitRate = state->m_DVBTBitrate;
+		fecOcTmdMode = 3;
+		fecOcRcnCtlRate = 0xC00000;
+		staticCLK = state->m_DVBTStaticCLK;
+		break;
+	case OM_QAM_ITU_A:	/* fallthrough */
+	case OM_QAM_ITU_C:
+		fecOcTmdMode = 0x0004;
+		fecOcRcnCtlRate = 0xD2B4EE;	/* good for >63 Mb/s */
+		maxBitRate = state->m_DVBCBitrate;
+		staticCLK = state->m_DVBCStaticCLK;
+		break;
+	default:
+		status = -EINVAL;
+	}		/* switch (standard) */
+	if (status < 0)
+		goto error;
 
-			/* Rational DTO for MCLK source (static MCLK rate),
-			   Dynamic DTO for optimal grouping
-			   (avoid intra-packet gaps),
-			   DTO offset enable to sync TS burst with MSTRT */
-			fecOcDtoMode = (FEC_OC_DTO_MODE_DYNAMIC__M |
-					FEC_OC_DTO_MODE_OFFSET_ENABLE__M);
-			fecOcFctMode = (FEC_OC_FCT_MODE_RAT_ENA__M |
-					FEC_OC_FCT_MODE_VIRT_ENA__M);
+	/* Configure DTO's */
+	if (staticCLK) {
+		u32 bitRate = 0;
 
-			/* Check user defined bitrate */
-			bitRate = maxBitRate;
-			if (bitRate > 75900000UL) {	/* max is 75.9 Mb/s */
-				bitRate = 75900000UL;
-			}
-			/* Rational DTO period:
-			   dto_period = (Fsys / bitrate) - 2
+		/* Rational DTO for MCLK source (static MCLK rate),
+			Dynamic DTO for optimal grouping
+			(avoid intra-packet gaps),
+			DTO offset enable to sync TS burst with MSTRT */
+		fecOcDtoMode = (FEC_OC_DTO_MODE_DYNAMIC__M |
+				FEC_OC_DTO_MODE_OFFSET_ENABLE__M);
+		fecOcFctMode = (FEC_OC_FCT_MODE_RAT_ENA__M |
+				FEC_OC_FCT_MODE_VIRT_ENA__M);
 
-			   Result should be floored,
-			   to make sure >= requested bitrate
-			 */
-			fecOcDtoPeriod = (u16) (((state->m_sysClockFreq)
-						 * 1000) / bitRate);
-			if (fecOcDtoPeriod <= 2)
-				fecOcDtoPeriod = 0;
-			else
-				fecOcDtoPeriod -= 2;
-			fecOcTmdIntUpdRate = 8;
-		} else {
-			/* (commonAttr->staticCLK == false) => dynamic mode */
-			fecOcDtoMode = FEC_OC_DTO_MODE_DYNAMIC__M;
-			fecOcFctMode = FEC_OC_FCT_MODE__PRE;
-			fecOcTmdIntUpdRate = 5;
+		/* Check user defined bitrate */
+		bitRate = maxBitRate;
+		if (bitRate > 75900000UL) {	/* max is 75.9 Mb/s */
+			bitRate = 75900000UL;
 		}
+		/* Rational DTO period:
+			dto_period = (Fsys / bitrate) - 2
+
+			Result should be floored,
+			to make sure >= requested bitrate
+			*/
+		fecOcDtoPeriod = (u16) (((state->m_sysClockFreq)
+						* 1000) / bitRate);
+		if (fecOcDtoPeriod <= 2)
+			fecOcDtoPeriod = 0;
+		else
+			fecOcDtoPeriod -= 2;
+		fecOcTmdIntUpdRate = 8;
+	} else {
+		/* (commonAttr->staticCLK == false) => dynamic mode */
+		fecOcDtoMode = FEC_OC_DTO_MODE_DYNAMIC__M;
+		fecOcFctMode = FEC_OC_FCT_MODE__PRE;
+		fecOcTmdIntUpdRate = 5;
+	}
 
-		/* Write appropriate registers with requested configuration */
-		status = write16(state, FEC_OC_DTO_BURST_LEN__A, fecOcDtoBurstLen);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_DTO_PERIOD__A, fecOcDtoPeriod);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_DTO_MODE__A, fecOcDtoMode);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_FCT_MODE__A, fecOcFctMode);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_MODE__A, fecOcRegMode);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_IPR_MODE__A, fecOcRegIprMode);
-		if (status < 0)
-			break;
+	/* Write appropriate registers with requested configuration */
+	status = write16(state, FEC_OC_DTO_BURST_LEN__A, fecOcDtoBurstLen);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_DTO_PERIOD__A, fecOcDtoPeriod);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_DTO_MODE__A, fecOcDtoMode);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_FCT_MODE__A, fecOcFctMode);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_MODE__A, fecOcRegMode);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_IPR_MODE__A, fecOcRegIprMode);
+	if (status < 0)
+		goto error;
 
-		/* Rate integration settings */
-		status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fecOcRcnCtlRate);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fecOcTmdIntUpdRate);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_TMD_MODE__A, fecOcTmdMode);
-		if (status < 0)
-			break;
-	} while (0);
+	/* Rate integration settings */
+	status = write32(state, FEC_OC_RCN_CTL_RATE_LO__A, fecOcRcnCtlRate);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_TMD_INT_UPD_RATE__A, fecOcTmdIntUpdRate);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_TMD_MODE__A, fecOcTmdMode);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int MPEGTSConfigurePolarity(struct drxk_state *state)
 {
-	int status;
 	u16 fecOcRegIprInvert = 0;
 
-	dprintk(1, "\n");
-
 	/* Data mask for the output data byte */
 	u16 InvertDataMask =
 	    FEC_OC_IPR_INVERT_MD7__M | FEC_OC_IPR_INVERT_MD6__M |
@@ -2143,6 +2165,8 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 	    FEC_OC_IPR_INVERT_MD3__M | FEC_OC_IPR_INVERT_MD2__M |
 	    FEC_OC_IPR_INVERT_MD1__M | FEC_OC_IPR_INVERT_MD0__M;
 
+	dprintk(1, "\n");
+
 	/* Control selective inversion of output bits */
 	fecOcRegIprInvert &= (~(InvertDataMask));
 	if (state->m_invertDATA == true)
@@ -2159,8 +2183,8 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 	fecOcRegIprInvert &= (~(FEC_OC_IPR_INVERT_MCLK__M));
 	if (state->m_invertCLK == true)
 		fecOcRegIprInvert |= FEC_OC_IPR_INVERT_MCLK__M;
-	status = write16(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
-	return status;
+
+	return write16(state, FEC_OC_IPR_INVERT__A, fecOcRegIprInvert);
 }
 
 #define   SCU_RAM_AGC_KI_INV_RF_POL__M 0x4000
@@ -2168,145 +2192,145 @@ static int MPEGTSConfigurePolarity(struct drxk_state *state)
 static int SetAgcRf(struct drxk_state *state,
 		    struct SCfgAgc *pAgcCfg, bool isDTV)
 {
-	int status = 0;
+	int status = -EINVAL;
+	u16 data = 0;
 	struct SCfgAgc *pIfAgcSettings;
 
 	dprintk(1, "\n");
 
 	if (pAgcCfg == NULL)
-		return -1;
-
-	do {
-		u16 data = 0;
-
-		switch (pAgcCfg->ctrlMode) {
-		case DRXK_AGC_CTRL_AUTO:
-
-			/* Enable RF AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-
-			/* Enable SCU RF AGC loop */
-			data &= ~SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
-
-			/* Polarity */
-			if (state->m_RfAgcPol)
-				data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			else
-				data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-
-			/* Set speed (using complementary reduction value) */
-			status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
-			if (status < 0)
-				break;
-
-			data &= ~SCU_RAM_AGC_KI_RED_RAGC_RED__M;
-			data |= (~(pAgcCfg->speed <<
-				   SCU_RAM_AGC_KI_RED_RAGC_RED__B)
-				 & SCU_RAM_AGC_KI_RED_RAGC_RED__M);
-
-			status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
-			if (status < 0)
-				break;
-
-			if (IsDVBT(state))
-				pIfAgcSettings = &state->m_dvbtIfAgcCfg;
-			else if (IsQAM(state))
-				pIfAgcSettings = &state->m_qamIfAgcCfg;
-			else
-				pIfAgcSettings = &state->m_atvIfAgcCfg;
-			if (pIfAgcSettings == NULL)
-				return -1;
-
-			/* Set TOP, only if IF-AGC is in AUTO mode */
-			if (pIfAgcSettings->ctrlMode == DRXK_AGC_CTRL_AUTO)
-				status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->top);
-				if (status < 0)
-					break;
-
-			/* Cut-Off current */
-			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, pAgcCfg->cutOffCurrent);
-			if (status < 0)
-				break;
-
-			/* Max. output level */
-			status = write16(state, SCU_RAM_AGC_RF_MAX__A, pAgcCfg->maxOutputLevel);
-			if (status < 0)
-				break;
-
-			break;
-
-		case DRXK_AGC_CTRL_USER:
-			/* Enable RF AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			/* Disable SCU RF AGC loop */
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-			data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
-			if (state->m_RfAgcPol)
-				data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			else
-				data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-
-			/* SCU c.o.c. to 0, enabling full control range */
-			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, 0);
-			if (status < 0)
-				break;
-
-			/* Write value to output pin */
-			status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, pAgcCfg->outputLevel);
-			if (status < 0)
-				break;
-			break;
-
-		case DRXK_AGC_CTRL_OFF:
-			/* Disable RF AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data |= IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			/* Disable SCU RF AGC loop */
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-			data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-			break;
-
-		default:
-			return -1;
-
-		}		/* switch (agcsettings->ctrlMode) */
-	} while (0);
+		goto error;
+
+	switch (pAgcCfg->ctrlMode) {
+	case DRXK_AGC_CTRL_AUTO:
+		/* Enable RF AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+
+		/* Enable SCU RF AGC loop */
+		data &= ~SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
+
+		/* Polarity */
+		if (state->m_RfAgcPol)
+			data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
+		else
+			data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Set speed (using complementary reduction value) */
+		status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
+		if (status < 0)
+			goto error;
+
+		data &= ~SCU_RAM_AGC_KI_RED_RAGC_RED__M;
+		data |= (~(pAgcCfg->speed <<
+				SCU_RAM_AGC_KI_RED_RAGC_RED__B)
+				& SCU_RAM_AGC_KI_RED_RAGC_RED__M);
+
+		status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
+		if (status < 0)
+			goto error;
+
+		if (IsDVBT(state))
+			pIfAgcSettings = &state->m_dvbtIfAgcCfg;
+		else if (IsQAM(state))
+			pIfAgcSettings = &state->m_qamIfAgcCfg;
+		else
+			pIfAgcSettings = &state->m_atvIfAgcCfg;
+		if (pIfAgcSettings == NULL) {
+			status = -EINVAL;
+			goto error;
+		}
+
+		/* Set TOP, only if IF-AGC is in AUTO mode */
+		if (pIfAgcSettings->ctrlMode == DRXK_AGC_CTRL_AUTO)
+			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->top);
+			if (status < 0)
+				goto error;
+
+		/* Cut-Off current */
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, pAgcCfg->cutOffCurrent);
+		if (status < 0)
+			goto error;
+
+		/* Max. output level */
+		status = write16(state, SCU_RAM_AGC_RF_MAX__A, pAgcCfg->maxOutputLevel);
+		if (status < 0)
+			goto error;
+
+		break;
+
+	case DRXK_AGC_CTRL_USER:
+		/* Enable RF AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data &= ~IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Disable SCU RF AGC loop */
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+		data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
+		if (state->m_RfAgcPol)
+			data |= SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
+		else
+			data &= ~SCU_RAM_AGC_CONFIG_INV_RF_POL__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+
+		/* SCU c.o.c. to 0, enabling full control range */
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI_CO__A, 0);
+		if (status < 0)
+			goto error;
+
+		/* Write value to output pin */
+		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, pAgcCfg->outputLevel);
+		if (status < 0)
+			goto error;
+		break;
+
+	case DRXK_AGC_CTRL_OFF:
+		/* Disable RF AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data |= IQM_AF_STDBY_STDBY_TAGC_RF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Disable SCU RF AGC loop */
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+		data |= SCU_RAM_AGC_CONFIG_DISABLE_RF_AGC__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+		break;
+
+	default:
+		status = -EINVAL;
+
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2321,144 +2345,146 @@ static int SetAgcIf(struct drxk_state *state,
 
 	dprintk(1, "\n");
 
-	do {
-		switch (pAgcCfg->ctrlMode) {
-		case DRXK_AGC_CTRL_AUTO:
-
-			/* Enable IF AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-
-			/* Enable SCU IF AGC loop */
-			data &= ~SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
-
-			/* Polarity */
-			if (state->m_IfAgcPol)
-				data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			else
-				data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-
-			/* Set speed (using complementary reduction value) */
-			status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
-			if (status < 0)
-				break;
-			data &= ~SCU_RAM_AGC_KI_RED_IAGC_RED__M;
-			data |= (~(pAgcCfg->speed <<
-				   SCU_RAM_AGC_KI_RED_IAGC_RED__B)
-				 & SCU_RAM_AGC_KI_RED_IAGC_RED__M);
-
-			status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
-			if (status < 0)
-				break;
-
-			if (IsQAM(state))
-				pRfAgcSettings = &state->m_qamRfAgcCfg;
-			else
-				pRfAgcSettings = &state->m_atvRfAgcCfg;
-			if (pRfAgcSettings == NULL)
-				return -1;
-			/* Restore TOP */
-			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pRfAgcSettings->top);
-			if (status < 0)
-				break;
-			break;
-
-		case DRXK_AGC_CTRL_USER:
-
-			/* Enable IF AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-
-			/* Disable SCU IF AGC loop */
-			data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
-
-			/* Polarity */
-			if (state->m_IfAgcPol)
-				data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			else
-				data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-
-			/* Write value to output pin */
-			status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->outputLevel);
-			if (status < 0)
-				break;
-			break;
-
-		case DRXK_AGC_CTRL_OFF:
-
-			/* Disable If AGC DAC */
-			status = read16(state, IQM_AF_STDBY__A, &data);
-			if (status < 0)
-				break;
-			data |= IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
-			status = write16(state, IQM_AF_STDBY__A, data);
-			if (status < 0)
-				break;
-
-			/* Disable SCU IF AGC loop */
-			status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
-			if (status < 0)
-				break;
-			data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
-			status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
-			if (status < 0)
-				break;
-			break;
-		}		/* switch (agcSettingsIf->ctrlMode) */
-
-		/* always set the top to support
-		   configurations without if-loop */
-		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, pAgcCfg->top);
-		if (status < 0)
-			break;
-
-
-	} while (0);
+	switch (pAgcCfg->ctrlMode) {
+	case DRXK_AGC_CTRL_AUTO:
+
+		/* Enable IF AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+
+		/* Enable SCU IF AGC loop */
+		data &= ~SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
+
+		/* Polarity */
+		if (state->m_IfAgcPol)
+			data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
+		else
+			data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Set speed (using complementary reduction value) */
+		status = read16(state, SCU_RAM_AGC_KI_RED__A, &data);
+		if (status < 0)
+			goto error;
+		data &= ~SCU_RAM_AGC_KI_RED_IAGC_RED__M;
+		data |= (~(pAgcCfg->speed <<
+				SCU_RAM_AGC_KI_RED_IAGC_RED__B)
+				& SCU_RAM_AGC_KI_RED_IAGC_RED__M);
+
+		status = write16(state, SCU_RAM_AGC_KI_RED__A, data);
+		if (status < 0)
+			goto error;
+
+		if (IsQAM(state))
+			pRfAgcSettings = &state->m_qamRfAgcCfg;
+		else
+			pRfAgcSettings = &state->m_atvRfAgcCfg;
+		if (pRfAgcSettings == NULL)
+			return -1;
+		/* Restore TOP */
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pRfAgcSettings->top);
+		if (status < 0)
+			goto error;
+		break;
+
+	case DRXK_AGC_CTRL_USER:
+
+		/* Enable IF AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data &= ~IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+
+		/* Disable SCU IF AGC loop */
+		data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
+
+		/* Polarity */
+		if (state->m_IfAgcPol)
+			data |= SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
+		else
+			data &= ~SCU_RAM_AGC_CONFIG_INV_IF_POL__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Write value to output pin */
+		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, pAgcCfg->outputLevel);
+		if (status < 0)
+			goto error;
+		break;
+
+	case DRXK_AGC_CTRL_OFF:
+
+		/* Disable If AGC DAC */
+		status = read16(state, IQM_AF_STDBY__A, &data);
+		if (status < 0)
+			goto error;
+		data |= IQM_AF_STDBY_STDBY_TAGC_IF_STANDBY;
+		status = write16(state, IQM_AF_STDBY__A, data);
+		if (status < 0)
+			goto error;
+
+		/* Disable SCU IF AGC loop */
+		status = read16(state, SCU_RAM_AGC_CONFIG__A, &data);
+		if (status < 0)
+			goto error;
+		data |= SCU_RAM_AGC_CONFIG_DISABLE_IF_AGC__M;
+		status = write16(state, SCU_RAM_AGC_CONFIG__A, data);
+		if (status < 0)
+			goto error;
+		break;
+	}		/* switch (agcSettingsIf->ctrlMode) */
+
+	/* always set the top to support
+		configurations without if-loop */
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, pAgcCfg->top);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int ReadIFAgc(struct drxk_state *state, u32 *pValue)
 {
 	u16 agcDacLvl;
-	int status = read16(state, IQM_AF_AGC_IF__A, &agcDacLvl);
+	int status;
+	u16 Level = 0;
 
 	dprintk(1, "\n");
 
+	status = read16(state, IQM_AF_AGC_IF__A, &agcDacLvl);
+	if (status < 0) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return status;
+	}
+
 	*pValue = 0;
 
-	if (status == 0) {
-		u16 Level = 0;
-		if (agcDacLvl > DRXK_AGC_DAC_OFFSET)
-			Level = agcDacLvl - DRXK_AGC_DAC_OFFSET;
-		if (Level < 14000)
-			*pValue = (14000 - Level) / 4;
-		else
-			*pValue = 0;
-	}
+	if (agcDacLvl > DRXK_AGC_DAC_OFFSET)
+		Level = agcDacLvl - DRXK_AGC_DAC_OFFSET;
+	if (Level < 14000)
+		*pValue = (14000 - Level) / 4;
+	else
+		*pValue = 0;
+
 	return status;
 }
 
@@ -2466,55 +2492,55 @@ static int GetQAMSignalToNoise(struct drxk_state *state,
 			       s32 *pSignalToNoise)
 {
 	int status = 0;
+	u16 qamSlErrPower = 0;	/* accum. error between
+					raw and sliced symbols */
+	u32 qamSlSigPower = 0;	/* used for MER, depends of
+					QAM constellation */
+	u32 qamSlMer = 0;	/* QAM MER */
 
 	dprintk(1, "\n");
 
-	do {
-		/* MER calculation */
-		u16 qamSlErrPower = 0;	/* accum. error between
-					   raw and sliced symbols */
-		u32 qamSlSigPower = 0;	/* used for MER, depends of
-					   QAM constellation */
-		u32 qamSlMer = 0;	/* QAM MER */
+	/* MER calculation */
 
-		/* get the register value needed for MER */
-		status = read16(state, QAM_SL_ERR_POWER__A, &qamSlErrPower);
-		if (status < 0)
-			break;
+	/* get the register value needed for MER */
+	status = read16(state, QAM_SL_ERR_POWER__A, &qamSlErrPower);
+	if (status < 0) {
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+		return -EINVAL;
+	}
 
-		switch (state->param.u.qam.modulation) {
-		case QAM_16:
-			qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM16 << 2;
-			break;
-		case QAM_32:
-			qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM32 << 2;
-			break;
-		case QAM_64:
-			qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM64 << 2;
-			break;
-		case QAM_128:
-			qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM128 << 2;
-			break;
-		default:
-		case QAM_256:
-			qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM256 << 2;
-			break;
-		}
+	switch (state->param.u.qam.modulation) {
+	case QAM_16:
+		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM16 << 2;
+		break;
+	case QAM_32:
+		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM32 << 2;
+		break;
+	case QAM_64:
+		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM64 << 2;
+		break;
+	case QAM_128:
+		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM128 << 2;
+		break;
+	default:
+	case QAM_256:
+		qamSlSigPower = DRXK_QAM_SL_SIG_POWER_QAM256 << 2;
+		break;
+	}
+
+	if (qamSlErrPower > 0) {
+		qamSlMer = Log10Times100(qamSlSigPower) -
+			Log10Times100((u32) qamSlErrPower);
+	}
+	*pSignalToNoise = qamSlMer;
 
-		if (qamSlErrPower > 0) {
-			qamSlMer = Log10Times100(qamSlSigPower) -
-			    Log10Times100((u32) qamSlErrPower);
-		}
-		*pSignalToNoise = qamSlMer;
-	} while (0);
 	return status;
 }
 
 static int GetDVBTSignalToNoise(struct drxk_state *state,
 				s32 *pSignalToNoise)
 {
-	int status = 0;
-
+	int status;
 	u16 regData = 0;
 	u32 EqRegTdSqrErrI = 0;
 	u32 EqRegTdSqrErrQ = 0;
@@ -2530,86 +2556,88 @@ static int GetDVBTSignalToNoise(struct drxk_state *state,
 	u16 transmissionParams = 0;
 
 	dprintk(1, "\n");
-	do {
-		status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
-		if (status < 0)
-			break;
-		status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &EqRegTdReqSmbCnt);
-		if (status < 0)
-			break;
-		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &EqRegTdSqrErrExp);
-		if (status < 0)
-			break;
-		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &regData);
-		if (status < 0)
-			break;
-		/* Extend SQR_ERR_I operational range */
-		EqRegTdSqrErrI = (u32) regData;
-		if ((EqRegTdSqrErrExp > 11) &&
-		    (EqRegTdSqrErrI < 0x00000FFFUL)) {
-			EqRegTdSqrErrI += 0x00010000UL;
-		}
-		status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &regData);
-		if (status < 0)
-			break;
-		/* Extend SQR_ERR_Q operational range */
-		EqRegTdSqrErrQ = (u32) regData;
-		if ((EqRegTdSqrErrExp > 11) &&
-		    (EqRegTdSqrErrQ < 0x00000FFFUL))
-			EqRegTdSqrErrQ += 0x00010000UL;
 
-		status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmissionParams);
-		if (status < 0)
-			break;
+	status = read16(state, OFDM_EQ_TOP_TD_TPS_PWR_OFS__A, &EqRegTdTpsPwrOfs);
+	if (status < 0)
+		goto error;
+	status = read16(state, OFDM_EQ_TOP_TD_REQ_SMB_CNT__A, &EqRegTdReqSmbCnt);
+	if (status < 0)
+		goto error;
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_EXP__A, &EqRegTdSqrErrExp);
+	if (status < 0)
+		goto error;
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_I__A, &regData);
+	if (status < 0)
+		goto error;
+	/* Extend SQR_ERR_I operational range */
+	EqRegTdSqrErrI = (u32) regData;
+	if ((EqRegTdSqrErrExp > 11) &&
+		(EqRegTdSqrErrI < 0x00000FFFUL)) {
+		EqRegTdSqrErrI += 0x00010000UL;
+	}
+	status = read16(state, OFDM_EQ_TOP_TD_SQR_ERR_Q__A, &regData);
+	if (status < 0)
+		goto error;
+	/* Extend SQR_ERR_Q operational range */
+	EqRegTdSqrErrQ = (u32) regData;
+	if ((EqRegTdSqrErrExp > 11) &&
+		(EqRegTdSqrErrQ < 0x00000FFFUL))
+		EqRegTdSqrErrQ += 0x00010000UL;
 
-		/* Check input data for MER */
+	status = read16(state, OFDM_SC_RA_RAM_OP_PARAM__A, &transmissionParams);
+	if (status < 0)
+		goto error;
 
-		/* MER calculation (in 0.1 dB) without math.h */
-		if ((EqRegTdTpsPwrOfs == 0) || (EqRegTdReqSmbCnt == 0))
-			iMER = 0;
-		else if ((EqRegTdSqrErrI + EqRegTdSqrErrQ) == 0) {
-			/* No error at all, this must be the HW reset value
-			 * Apparently no first measurement yet
-			 * Set MER to 0.0 */
-			iMER = 0;
-		} else {
-			SqrErrIQ = (EqRegTdSqrErrI + EqRegTdSqrErrQ) <<
-			    EqRegTdSqrErrExp;
-			if ((transmissionParams &
-			     OFDM_SC_RA_RAM_OP_PARAM_MODE__M)
-			    == OFDM_SC_RA_RAM_OP_PARAM_MODE_2K)
-				tpsCnt = 17;
-			else
-				tpsCnt = 68;
+	/* Check input data for MER */
 
-			/* IMER = 100 * log10 (x)
-			   where x = (EqRegTdTpsPwrOfs^2 *
-			   EqRegTdReqSmbCnt * tpsCnt)/SqrErrIQ
+	/* MER calculation (in 0.1 dB) without math.h */
+	if ((EqRegTdTpsPwrOfs == 0) || (EqRegTdReqSmbCnt == 0))
+		iMER = 0;
+	else if ((EqRegTdSqrErrI + EqRegTdSqrErrQ) == 0) {
+		/* No error at all, this must be the HW reset value
+			* Apparently no first measurement yet
+			* Set MER to 0.0 */
+		iMER = 0;
+	} else {
+		SqrErrIQ = (EqRegTdSqrErrI + EqRegTdSqrErrQ) <<
+			EqRegTdSqrErrExp;
+		if ((transmissionParams &
+			OFDM_SC_RA_RAM_OP_PARAM_MODE__M)
+			== OFDM_SC_RA_RAM_OP_PARAM_MODE_2K)
+			tpsCnt = 17;
+		else
+			tpsCnt = 68;
 
-			   => IMER = a + b -c
-			   where a = 100 * log10 (EqRegTdTpsPwrOfs^2)
-			   b = 100 * log10 (EqRegTdReqSmbCnt * tpsCnt)
-			   c = 100 * log10 (SqrErrIQ)
-			 */
+		/* IMER = 100 * log10 (x)
+			where x = (EqRegTdTpsPwrOfs^2 *
+			EqRegTdReqSmbCnt * tpsCnt)/SqrErrIQ
 
-			/* log(x) x = 9bits * 9bits->18 bits  */
-			a = Log10Times100(EqRegTdTpsPwrOfs *
-					  EqRegTdTpsPwrOfs);
-			/* log(x) x = 16bits * 7bits->23 bits  */
-			b = Log10Times100(EqRegTdReqSmbCnt * tpsCnt);
-			/* log(x) x = (16bits + 16bits) << 15 ->32 bits  */
-			c = Log10Times100(SqrErrIQ);
+			=> IMER = a + b -c
+			where a = 100 * log10 (EqRegTdTpsPwrOfs^2)
+			b = 100 * log10 (EqRegTdReqSmbCnt * tpsCnt)
+			c = 100 * log10 (SqrErrIQ)
+			*/
 
-			iMER = a + b;
-			/* No negative MER, clip to zero */
-			if (iMER > c)
-				iMER -= c;
-			else
-				iMER = 0;
-		}
-		*pSignalToNoise = iMER;
-	} while (0);
+		/* log(x) x = 9bits * 9bits->18 bits  */
+		a = Log10Times100(EqRegTdTpsPwrOfs *
+					EqRegTdTpsPwrOfs);
+		/* log(x) x = 16bits * 7bits->23 bits  */
+		b = Log10Times100(EqRegTdReqSmbCnt * tpsCnt);
+		/* log(x) x = (16bits + 16bits) << 15 ->32 bits  */
+		c = Log10Times100(SqrErrIQ);
+
+		iMER = a + b;
+		/* No negative MER, clip to zero */
+		if (iMER > c)
+			iMER -= c;
+		else
+			iMER = 0;
+	}
+	*pSignalToNoise = iMER;
 
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2775,50 +2803,54 @@ static int GetQuality(struct drxk_state *state, s32 *pQuality)
 
 static int ConfigureI2CBridge(struct drxk_state *state, bool bEnableBridge)
 {
-	int status;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
 	if (state->m_DrxkState == DRXK_UNINITIALIZED)
-		return -1;
+		goto error;
 	if (state->m_DrxkState == DRXK_POWERED_DOWN)
-		return -1;
+		goto error;
 
 	if (state->no_i2c_bridge)
 		return 0;
-	do {
-		status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
-		if (status < 0)
-			break;
-		if (bEnableBridge) {
-			status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
-			if (status < 0)
-				break;
-		} else {
-			status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
-			if (status < 0)
-				break;
-		}
 
-		status = HI_Command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
+	status = write16(state, SIO_HI_RA_RAM_PAR_1__A, SIO_HI_RA_RAM_PAR_1_PAR1_SEC_KEY);
+	if (status < 0)
+		goto error;
+	if (bEnableBridge) {
+		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_CLOSED);
+		if (status < 0)
+			goto error;
+	} else {
+		status = write16(state, SIO_HI_RA_RAM_PAR_2__A, SIO_HI_RA_RAM_PAR_2_BRD_CFG_OPEN);
 		if (status < 0)
-			break;
-	} while (0);
+			goto error;
+	}
+
+	status = HI_Command(state, SIO_HI_RA_RAM_CMD_BRDCTRL, 0);
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int SetPreSaw(struct drxk_state *state,
 		     struct SCfgPreSaw *pPreSawCfg)
 {
-	int status;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
 	if ((pPreSawCfg == NULL)
 	    || (pPreSawCfg->reference > IQM_AF_PDREF__M))
-		return -1;
+		goto error;
 
 	status = write16(state, IQM_AF_PDREF__A, pPreSawCfg->reference);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2834,38 +2866,40 @@ static int BLDirectCmd(struct drxk_state *state, u32 targetAddr,
 	dprintk(1, "\n");
 
 	mutex_lock(&state->mutex);
-	do {
-		status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_DIRECT);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_TGT_HDR__A, blockbank);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_TGT_ADDR__A, offset);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_SRC_ADDR__A, romOffset);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_SRC_LEN__A, nrOfElements);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
-		if (status < 0)
-			break;
+	status = write16(state, SIO_BL_MODE__A, SIO_BL_MODE_DIRECT);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_TGT_HDR__A, blockbank);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_TGT_ADDR__A, offset);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_SRC_ADDR__A, romOffset);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_SRC_LEN__A, nrOfElements);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_BL_ENABLE__A, SIO_BL_ENABLE_ON);
+	if (status < 0)
+		goto error;
 
-		end = jiffies + msecs_to_jiffies(timeOut);
-		do {
-			status = read16(state, SIO_BL_STATUS__A, &blStatus);
-			if (status < 0)
-				break;
-		} while ((blStatus == 0x1) && time_is_after_jiffies(end));
-		if (blStatus == 0x1) {
-			printk(KERN_ERR "drxk: SIO not ready\n");
-			mutex_unlock(&state->mutex);
-			return -1;
-		}
-	} while (0);
+	end = jiffies + msecs_to_jiffies(timeOut);
+	do {
+		status = read16(state, SIO_BL_STATUS__A, &blStatus);
+		if (status < 0)
+			goto error;
+	} while ((blStatus == 0x1) && time_is_after_jiffies(end));
+	if (blStatus == 0x1) {
+		printk(KERN_ERR "drxk: SIO not ready\n");
+		status = -EINVAL;
+		goto error2;
+	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
+error2:
 	mutex_unlock(&state->mutex);
 	return status;
 
@@ -2878,32 +2912,34 @@ static int ADCSyncMeasurement(struct drxk_state *state, u16 *count)
 
 	dprintk(1, "\n");
 
-	do {
-		/* Start measurement */
-		status = write16(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_START_LOCK__A, 1);
-		if (status < 0)
-			break;
+	/* Start measurement */
+	status = write16(state, IQM_AF_COMM_EXEC__A, IQM_AF_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_START_LOCK__A, 1);
+	if (status < 0)
+		goto error;
 
-		*count = 0;
-		status = read16(state, IQM_AF_PHASE0__A, &data);
-		if (status < 0)
-			break;
-		if (data == 127)
-			*count = *count + 1;
-		status = read16(state, IQM_AF_PHASE1__A, &data);
-		if (status < 0)
-			break;
-		if (data == 127)
-			*count = *count + 1;
-		status = read16(state, IQM_AF_PHASE2__A, &data);
-		if (status < 0)
-			break;
-		if (data == 127)
-			*count = *count + 1;
-	} while (0);
+	*count = 0;
+	status = read16(state, IQM_AF_PHASE0__A, &data);
+	if (status < 0)
+		goto error;
+	if (data == 127)
+		*count = *count + 1;
+	status = read16(state, IQM_AF_PHASE1__A, &data);
+	if (status < 0)
+		goto error;
+	if (data == 127)
+		*count = *count + 1;
+	status = read16(state, IQM_AF_PHASE2__A, &data);
+	if (status < 0)
+		goto error;
+	if (data == 127)
+		*count = *count + 1;
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -2914,39 +2950,40 @@ static int ADCSynchronization(struct drxk_state *state)
 
 	dprintk(1, "\n");
 
-	do {
+	status = ADCSyncMeasurement(state, &count);
+	if (status < 0)
+		goto error;
+
+	if (count == 1) {
+		/* Try sampling on a diffrent edge */
+		u16 clkNeg = 0;
+
+		status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
+		if (status < 0)
+			goto error;
+		if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
+			IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
+			clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
+			clkNeg |=
+				IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
+		} else {
+			clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
+			clkNeg |=
+				IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
+		}
+		status = write16(state, IQM_AF_CLKNEG__A, clkNeg);
+		if (status < 0)
+			goto error;
 		status = ADCSyncMeasurement(state, &count);
 		if (status < 0)
-			break;
+			goto error;
+	}
 
-		if (count == 1) {
-			/* Try sampling on a diffrent edge */
-			u16 clkNeg = 0;
-
-			status = read16(state, IQM_AF_CLKNEG__A, &clkNeg);
-			if (status < 0)
-				break;
-			if ((clkNeg | IQM_AF_CLKNEG_CLKNEGDATA__M) ==
-			    IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS) {
-				clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
-				clkNeg |=
-				    IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_NEG;
-			} else {
-				clkNeg &= (~(IQM_AF_CLKNEG_CLKNEGDATA__M));
-				clkNeg |=
-				    IQM_AF_CLKNEG_CLKNEGDATA_CLK_ADC_DATA_POS;
-			}
-			status = write16(state, IQM_AF_CLKNEG__A, clkNeg);
-			if (status < 0)
-				break;
-			status = ADCSyncMeasurement(state, &count);
-			if (status < 0)
-				break;
-		}
-
-		if (count < 2)
-			status = -1;
-	} while (0);
+	if (count < 2)
+		status = -EINVAL;
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3011,6 +3048,8 @@ static int SetFrequencyShifter(struct drxk_state *state,
 	/* frequencyShift += tunerFreqOffset; TODO */
 	status = write32(state, IQM_FS_RATE_OFS_LO__A,
 			 state->m_IqmFsRateOfs);
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3037,177 +3076,175 @@ static int InitAGC(struct drxk_state *state, bool isDTV)
 
 	dprintk(1, "\n");
 
-	do {
-		/* Common settings */
-		snsSumMax = 1023;
-		ifIaccuHiTgtMin = 2047;
-		clpCyclen = 500;
-		clpSumMax = 1023;
+	/* Common settings */
+	snsSumMax = 1023;
+	ifIaccuHiTgtMin = 2047;
+	clpCyclen = 500;
+	clpSumMax = 1023;
 
-		if (IsQAM(state)) {
-			/* Standard specific settings */
-			clpSumMin = 8;
-			clpDirTo = (u16) -9;
-			clpCtrlMode = 0;
-			snsSumMin = 8;
-			snsDirTo = (u16) -9;
-			kiInnergainMin = (u16) -1030;
-		} else
-			status = -1;
-		status = (status);
-		if (status < 0)
-			break;
-		if (IsQAM(state)) {
-			ifIaccuHiTgtMax = 0x2380;
-			ifIaccuHiTgt = 0x2380;
-			ingainTgtMin = 0x0511;
-			ingainTgt = 0x0511;
-			ingainTgtMax = 5119;
-			fastClpCtrlDelay =
-			    state->m_qamIfAgcCfg.FastClipCtrlDelay;
-		} else {
-			ifIaccuHiTgtMax = 0x1200;
-			ifIaccuHiTgt = 0x1200;
-			ingainTgtMin = 13424;
-			ingainTgt = 13424;
-			ingainTgtMax = 30000;
-			fastClpCtrlDelay =
-			    state->m_dvbtIfAgcCfg.FastClipCtrlDelay;
-		}
-		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
-		if (status < 0)
-			break;
+	if (IsQAM(state)) {
+		/* Standard specific settings */
+		clpSumMin = 8;
+		clpDirTo = (u16) -9;
+		clpCtrlMode = 0;
+		snsSumMin = 8;
+		snsDirTo = (u16) -9;
+		kiInnergainMin = (u16) -1030;
+	} else {
+		status = -EINVAL;
+		goto error;
+	}
+	if (IsQAM(state)) {
+		ifIaccuHiTgtMax = 0x2380;
+		ifIaccuHiTgt = 0x2380;
+		ingainTgtMin = 0x0511;
+		ingainTgt = 0x0511;
+		ingainTgtMax = 5119;
+		fastClpCtrlDelay =
+			state->m_qamIfAgcCfg.FastClipCtrlDelay;
+	} else {
+		ifIaccuHiTgtMax = 0x1200;
+		ifIaccuHiTgt = 0x1200;
+		ingainTgtMin = 13424;
+		ingainTgt = 13424;
+		ingainTgtMax = 30000;
+		fastClpCtrlDelay =
+			state->m_dvbtIfAgcCfg.FastClipCtrlDelay;
+	}
+	status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, fastClpCtrlDelay);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_INGAIN_TGT__A, ingainTgt);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingainTgtMin);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingainTgtMax);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, ifIaccuHiTgtMin);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, ifIaccuHiTgtMax);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_LO__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_RF_IACCU_LO__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clpSumMax);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_SUM_MAX__A, snsSumMax);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_AGC_CLP_CTRL_MODE__A, clpCtrlMode);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT__A, ingainTgt);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MIN__A, ingainTgtMin);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, ingainTgtMax);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MIN__A, ifIaccuHiTgtMin);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT_MAX__A, ifIaccuHiTgtMax);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_LO__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_RF_IACCU_HI__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_RF_IACCU_LO__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_SUM_MAX__A, clpSumMax);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_SUM_MAX__A, snsSumMax);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, kiInnergainMin);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, ifIaccuHiTgt);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clpCyclen);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_AGC_KI_INNERGAIN_MIN__A, kiInnergainMin);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_IF_IACCU_HI_TGT__A, ifIaccuHiTgt);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_CYCLEN__A, clpCyclen);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MAX__A, 1023);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MIN__A, (u16) -1023);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_FAST_SNS_CTRL_DELAY__A, 50);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MAX__A, 1023);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_RF_SNS_DEV_MIN__A, (u16) -1023);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_FAST_SNS_CTRL_DELAY__A, 50);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_AGC_KI_MAXMINGAIN_TH__A, 20);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clpSumMin);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_SUM_MIN__A, snsSumMin);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_DIR_TO__A, clpDirTo);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_DIR_TO__A, snsDirTo);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_KI_MAXGAIN__A, 0x0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_KI_MIN__A, 0x0117);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_KI_MAX__A, 0x0657);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_SUM__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_CYCCNT__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_DIR_WD__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_CLP_DIR_STP__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_SUM__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_CYCCNT__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_DIR_WD__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_DIR_STP__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_SNS_CYCLEN__A, 500);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_KI_CYCLEN__A, 500);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_AGC_KI_MAXMINGAIN_TH__A, 20);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_SUM_MIN__A, clpSumMin);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_SUM_MIN__A, snsSumMin);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_DIR_TO__A, clpDirTo);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_DIR_TO__A, snsDirTo);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_KI_MINGAIN__A, 0x7fff);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_KI_MAXGAIN__A, 0x0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_KI_MIN__A, 0x0117);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_KI_MAX__A, 0x0657);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_SUM__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_CYCCNT__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_DIR_WD__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_CLP_DIR_STP__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_SUM__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_CYCCNT__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_DIR_WD__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_DIR_STP__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_SNS_CYCLEN__A, 500);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_KI_CYCLEN__A, 500);
+	if (status < 0)
+		goto error;
 
-		/* Initialize inner-loop KI gain factors */
-		status = read16(state, SCU_RAM_AGC_KI__A, &data);
-		if (status < 0)
-			break;
-		if (IsQAM(state)) {
-			data = 0x0657;
-			data &= ~SCU_RAM_AGC_KI_RF__M;
-			data |= (DRXK_KI_RAGC_QAM << SCU_RAM_AGC_KI_RF__B);
-			data &= ~SCU_RAM_AGC_KI_IF__M;
-			data |= (DRXK_KI_IAGC_QAM << SCU_RAM_AGC_KI_IF__B);
-		}
-		status = write16(state, SCU_RAM_AGC_KI__A, data);
-		if (status < 0)
-			break;
-	} while (0);
+	/* Initialize inner-loop KI gain factors */
+	status = read16(state, SCU_RAM_AGC_KI__A, &data);
+	if (status < 0)
+		goto error;
+	if (IsQAM(state)) {
+		data = 0x0657;
+		data &= ~SCU_RAM_AGC_KI_RF__M;
+		data |= (DRXK_KI_RAGC_QAM << SCU_RAM_AGC_KI_RF__B);
+		data &= ~SCU_RAM_AGC_KI_IF__M;
+		data |= (DRXK_KI_IAGC_QAM << SCU_RAM_AGC_KI_IF__B);
+	}
+	status = write16(state, SCU_RAM_AGC_KI__A, data);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3216,17 +3253,12 @@ static int DVBTQAMGetAccPktErr(struct drxk_state *state, u16 *packetErr)
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		if (packetErr == NULL) {
-			status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
-			if (status < 0)
-				break;
-		} else {
-			status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packetErr);
-			if (status < 0)
-				break;
-		}
-	} while (0);
+	if (packetErr == NULL)
+		status = write16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, 0);
+	else
+		status = read16(state, SCU_RAM_FEC_ACCUM_PKT_FAILURES__A, packetErr);
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3245,8 +3277,10 @@ static int DVBTScCommand(struct drxk_state *state,
 	status = read16(state, OFDM_SC_COMM_EXEC__A, &scExec);
 	if (scExec != 1) {
 		/* SC is not running */
-		return -1;
+		status = -EINVAL;
 	}
+	if (status < 0)
+		goto error;
 
 	/* Wait until sc is ready to receive command */
 	retryCnt = 0;
@@ -3255,21 +3289,23 @@ static int DVBTScCommand(struct drxk_state *state,
 		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
 		retryCnt++;
 	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
-	if (retryCnt >= DRXK_MAX_RETRIES)
-		return -1;
+	if (retryCnt >= DRXK_MAX_RETRIES && (status < 0))
+		goto error;
+
 	/* Write sub-command */
 	switch (cmd) {
 		/* All commands using sub-cmd */
 	case OFDM_SC_RA_RAM_CMD_PROC_START:
 	case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
 	case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
-		status =
-		    write16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, subcmd);
+		status = write16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, subcmd);
+		if (status < 0)
+			goto error;
 		break;
 	default:
 		/* Do nothing */
 		break;
-	}			/* switch (cmd->cmd) */
+	}
 
 	/* Write needed parameters and the command */
 	switch (cmd) {
@@ -3280,13 +3316,11 @@ static int DVBTScCommand(struct drxk_state *state,
 	case OFDM_SC_RA_RAM_CMD_PROC_START:
 	case OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM:
 	case OFDM_SC_RA_RAM_CMD_PROGRAM_PARAM:
-		status =
-		    write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
+		status = write16(state, OFDM_SC_RA_RAM_PARAM1__A, param1);
 		/* All commands using 1 parameters */
 	case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
 	case OFDM_SC_RA_RAM_CMD_USER_IO:
-		status =
-		    write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
+		status = write16(state, OFDM_SC_RA_RAM_PARAM0__A, param0);
 		/* All commands using 0 parameters */
 	case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
 	case OFDM_SC_RA_RAM_CMD_NULL:
@@ -3295,8 +3329,10 @@ static int DVBTScCommand(struct drxk_state *state,
 		break;
 	default:
 		/* Unknown command */
-		return -EINVAL;
-	}			/* switch (cmd->cmd) */
+		status = -EINVAL;
+	}
+	if (status < 0)
+		goto error;
 
 	/* Wait until sc is ready processing command */
 	retryCnt = 0;
@@ -3305,15 +3341,17 @@ static int DVBTScCommand(struct drxk_state *state,
 		status = read16(state, OFDM_SC_RA_RAM_CMD__A, &curCmd);
 		retryCnt++;
 	} while ((curCmd != 0) && (retryCnt < DRXK_MAX_RETRIES));
-	if (retryCnt >= DRXK_MAX_RETRIES)
-		return -1;
+	if (retryCnt >= DRXK_MAX_RETRIES && (status < 0))
+		goto error;
 
 	/* Check for illegal cmd */
 	status = read16(state, OFDM_SC_RA_RAM_CMD_ADDR__A, &errCode);
 	if (errCode == 0xFFFF) {
 		/* illegal command */
-		return -EINVAL;
+		status = -EINVAL;
 	}
+	if (status < 0)
+		goto error;
 
 	/* Retreive results parameters from SC */
 	switch (cmd) {
@@ -3324,8 +3362,7 @@ static int DVBTScCommand(struct drxk_state *state,
 		/* All commands yielding 1 result */
 	case OFDM_SC_RA_RAM_CMD_USER_IO:
 	case OFDM_SC_RA_RAM_CMD_GET_OP_PARAM:
-		status =
-		    read16(state, OFDM_SC_RA_RAM_PARAM0__A, &(param0));
+		status = read16(state, OFDM_SC_RA_RAM_PARAM0__A, &(param0));
 		/* All commands yielding 0 results */
 	case OFDM_SC_RA_RAM_CMD_SET_ECHO_TIMING:
 	case OFDM_SC_RA_RAM_CMD_SET_TIMER:
@@ -3336,9 +3373,12 @@ static int DVBTScCommand(struct drxk_state *state,
 		break;
 	default:
 		/* Unknown command */
-		return -EINVAL;
+		status = -EINVAL;
 		break;
 	}			/* switch (cmd->cmd) */
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3348,11 +3388,9 @@ static int PowerUpDVBT(struct drxk_state *state)
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		status = CtrlPowerMode(state, &powerMode);
-		if (status < 0)
-			break;
-	} while (0);
+	status = CtrlPowerMode(state, &powerMode);
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3365,7 +3403,8 @@ static int DVBTCtrlSetIncEnable(struct drxk_state *state, bool *enabled)
 		status = write16(state, IQM_CF_BYPASSDET__A, 0);
 	else
 		status = write16(state, IQM_CF_BYPASSDET__A, 1);
-
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3384,6 +3423,8 @@ static int DVBTCtrlSetFrEnable(struct drxk_state *state, bool *enabled)
 		/* write mask to 0 */
 		status = write16(state, OFDM_SC_RA_RAM_FR_THRES_8K__A, 0);
 	}
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -3395,43 +3436,39 @@ static int DVBTCtrlSetEchoThreshold(struct drxk_state *state,
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		status = read16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, &data);
-		if (status < 0)
-			break;
+	status = read16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, &data);
+	if (status < 0)
+		goto error;
 
-		switch (echoThres->fftMode) {
-		case DRX_FFTMODE_2K:
-			data &= ~OFDM_SC_RA_RAM_ECHO_THRES_2K__M;
-			data |=
-			    ((echoThres->threshold <<
-			      OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
-			     & (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
-			break;
-		case DRX_FFTMODE_8K:
-			data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
-			data |=
-			    ((echoThres->threshold <<
-			      OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
-			     & (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
-			break;
-		default:
-			return -1;
-			break;
-		}
-
-		status = write16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, data);
-		if (status < 0)
-			break;
-	} while (0);
+	switch (echoThres->fftMode) {
+	case DRX_FFTMODE_2K:
+		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_2K__M;
+		data |= ((echoThres->threshold <<
+			OFDM_SC_RA_RAM_ECHO_THRES_2K__B)
+			& (OFDM_SC_RA_RAM_ECHO_THRES_2K__M));
+		goto error;
+	case DRX_FFTMODE_8K:
+		data &= ~OFDM_SC_RA_RAM_ECHO_THRES_8K__M;
+		data |= ((echoThres->threshold <<
+			OFDM_SC_RA_RAM_ECHO_THRES_8K__B)
+			& (OFDM_SC_RA_RAM_ECHO_THRES_8K__M));
+		goto error;
+	default:
+		return -EINVAL;
+		goto error;
+	}
 
+	status = write16(state, OFDM_SC_RA_RAM_ECHO_THRES__A, data);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
 			       enum DRXKCfgDvbtSqiSpeed *speed)
 {
-	int status;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 
@@ -3441,10 +3478,13 @@ static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
 	case DRXK_DVBT_SQI_SPEED_SLOW:
 		break;
 	default:
-		return -EINVAL;
+		goto error;
 	}
 	status = write16(state, SCU_RAM_FEC_PRE_RS_BER_FILTER_SH__A,
 			   (u16) *speed);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3461,31 +3501,29 @@ static int DVBTCtrlSetSqiSpeed(struct drxk_state *state,
 static int DVBTActivatePresets(struct drxk_state *state)
 {
 	int status;
+	bool setincenable = false;
+	bool setfrenable = true;
 
 	struct DRXKCfgDvbtEchoThres_t echoThres2k = { 0, DRX_FFTMODE_2K };
 	struct DRXKCfgDvbtEchoThres_t echoThres8k = { 0, DRX_FFTMODE_8K };
 
 	dprintk(1, "\n");
-	do {
-		bool setincenable = false;
-		bool setfrenable = true;
-		status = DVBTCtrlSetIncEnable(state, &setincenable);
-		if (status < 0)
-			break;
-		status = DVBTCtrlSetFrEnable(state, &setfrenable);
-		if (status < 0)
-			break;
-		status = DVBTCtrlSetEchoThreshold(state, &echoThres2k);
-		if (status < 0)
-			break;
-		status = DVBTCtrlSetEchoThreshold(state, &echoThres8k);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbtIfAgcCfg.IngainTgtMax);
-		if (status < 0)
-			break;
-	} while (0);
-
+	status = DVBTCtrlSetIncEnable(state, &setincenable);
+	if (status < 0)
+		goto error;
+	status = DVBTCtrlSetFrEnable(state, &setfrenable);
+	if (status < 0)
+		goto error;
+	status = DVBTCtrlSetEchoThreshold(state, &echoThres2k);
+	if (status < 0)
+		goto error;
+	status = DVBTCtrlSetEchoThreshold(state, &echoThres8k);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_AGC_INGAIN_TGT_MAX__A, state->m_dvbtIfAgcCfg.IngainTgtMax);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3509,192 +3547,189 @@ static int SetDVBTStandard(struct drxk_state *state,
 	dprintk(1, "\n");
 
 	PowerUpDVBT(state);
-	do {
-		/* added antenna switch */
-		SwitchAntennaToDVBT(state);
-		/* send OFDM reset command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
-
-		/* send OFDM setenv command */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
-
-		/* reset datapath for OFDM, processors first */
-		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
-		if (status < 0)
-			break;
-
-		/* IQM setup */
-		/* synchronize on ofdstate->m_festart */
-		status = write16(state, IQM_AF_UPD_SEL__A, 1);
-		if (status < 0)
-			break;
-		/* window size for clipping ADC detection */
-		status = write16(state, IQM_AF_CLP_LEN__A, 0);
-		if (status < 0)
-			break;
-		/* window size for for sense pre-SAW detection */
-		status = write16(state, IQM_AF_SNS_LEN__A, 0);
-		if (status < 0)
-			break;
-		/* sense threshold for sense pre-SAW detection */
-		status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
-		if (status < 0)
-			break;
-		status = SetIqmAf(state, true);
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_AF_AGC_RF__A, 0);
-		if (status < 0)
-			break;
-
-		/* Impulse noise cruncher setup */
-		status = write16(state, IQM_AF_INC_LCT__A, 0);	/* crunch in IQM_CF */
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_DET_LCT__A, 0);	/* detect in IQM_CF */
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_WND_LEN__A, 3);	/* peak detector window length */
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_RC_STRETCH__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_OUT_ENA__A, 0x4);	/* enable output 2 */
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_DS_ENA__A, 0x4);	/* decimate output 2 */
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_SCALE__A, 1600);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_SCALE_SH__A, 0);
-		if (status < 0)
-			break;
-
-		/* virtual clipping threshold for clipping ADC detection */
-		status = write16(state, IQM_AF_CLP_TH__A, 448);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_DATATH__A, 495);	/* crunching threshold */
-		if (status < 0)
-			break;
-
-		status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_CF_PKDTH__A, 2);	/* peak detector threshold */
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_POW_MEAS_LEN__A, 2);
-		if (status < 0)
-			break;
-		/* enable power measurement interrupt */
-		status = write16(state, IQM_CF_COMM_INT_MSK__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
-		if (status < 0)
-			break;
-
-		/* IQM will not be reset from here, sync ADC and update/init AGC */
-		status = ADCSynchronization(state);
-		if (status < 0)
-			break;
-		status = SetPreSaw(state, &state->m_dvbtPreSawCfg);
-		if (status < 0)
-			break;
-
-		/* Halt SCU to enable safe non-atomic accesses */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
-		if (status < 0)
-			break;
-
-		status = SetAgcRf(state, &state->m_dvbtRfAgcCfg, true);
-		if (status < 0)
-			break;
-		status = SetAgcIf(state, &state->m_dvbtIfAgcCfg, true);
-		if (status < 0)
-			break;
-
-		/* Set Noise Estimation notch width and enable DC fix */
-		status = read16(state, OFDM_SC_RA_RAM_CONFIG__A, &data);
-		if (status < 0)
-			break;
-		data |= OFDM_SC_RA_RAM_CONFIG_NE_FIX_ENABLE__M;
-		status = write16(state, OFDM_SC_RA_RAM_CONFIG__A, data);
-		if (status < 0)
-			break;
-
-		/* Activate SCU to enable SCU commands */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-
-		if (!state->m_DRXK_A3_ROM_CODE) {
-			/* AGCInit() is not done for DVBT, so set agcFastClipCtrlDelay  */
-			status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbtIfAgcCfg.FastClipCtrlDelay);
-			if (status < 0)
-				break;
-		}
-
-		/* OFDM_SC setup */
+	/* added antenna switch */
+	SwitchAntennaToDVBT(state);
+	/* send OFDM reset command */
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
+	if (status < 0)
+		goto error;
+
+	/* send OFDM setenv command */
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_SET_ENV, 0, NULL, 1, &cmdResult);
+	if (status < 0)
+		goto error;
+
+	/* reset datapath for OFDM, processors first */
+	status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+	if (status < 0)
+		goto error;
+
+	/* IQM setup */
+	/* synchronize on ofdstate->m_festart */
+	status = write16(state, IQM_AF_UPD_SEL__A, 1);
+	if (status < 0)
+		goto error;
+	/* window size for clipping ADC detection */
+	status = write16(state, IQM_AF_CLP_LEN__A, 0);
+	if (status < 0)
+		goto error;
+	/* window size for for sense pre-SAW detection */
+	status = write16(state, IQM_AF_SNS_LEN__A, 0);
+	if (status < 0)
+		goto error;
+	/* sense threshold for sense pre-SAW detection */
+	status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
+	if (status < 0)
+		goto error;
+	status = SetIqmAf(state, true);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_AF_AGC_RF__A, 0);
+	if (status < 0)
+		goto error;
+
+	/* Impulse noise cruncher setup */
+	status = write16(state, IQM_AF_INC_LCT__A, 0);	/* crunch in IQM_CF */
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_DET_LCT__A, 0);	/* detect in IQM_CF */
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_WND_LEN__A, 3);	/* peak detector window length */
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_RC_STRETCH__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_OUT_ENA__A, 0x4);	/* enable output 2 */
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_DS_ENA__A, 0x4);	/* decimate output 2 */
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_SCALE__A, 1600);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_SCALE_SH__A, 0);
+	if (status < 0)
+		goto error;
+
+	/* virtual clipping threshold for clipping ADC detection */
+	status = write16(state, IQM_AF_CLP_TH__A, 448);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_DATATH__A, 495);	/* crunching threshold */
+	if (status < 0)
+		goto error;
+
+	status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_DVBT, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_CF_PKDTH__A, 2);	/* peak detector threshold */
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_POW_MEAS_LEN__A, 2);
+	if (status < 0)
+		goto error;
+	/* enable power measurement interrupt */
+	status = write16(state, IQM_CF_COMM_INT_MSK__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
+	if (status < 0)
+		goto error;
+
+	/* IQM will not be reset from here, sync ADC and update/init AGC */
+	status = ADCSynchronization(state);
+	if (status < 0)
+		goto error;
+	status = SetPreSaw(state, &state->m_dvbtPreSawCfg);
+	if (status < 0)
+		goto error;
+
+	/* Halt SCU to enable safe non-atomic accesses */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+	if (status < 0)
+		goto error;
+
+	status = SetAgcRf(state, &state->m_dvbtRfAgcCfg, true);
+	if (status < 0)
+		goto error;
+	status = SetAgcIf(state, &state->m_dvbtIfAgcCfg, true);
+	if (status < 0)
+		goto error;
+
+	/* Set Noise Estimation notch width and enable DC fix */
+	status = read16(state, OFDM_SC_RA_RAM_CONFIG__A, &data);
+	if (status < 0)
+		goto error;
+	data |= OFDM_SC_RA_RAM_CONFIG_NE_FIX_ENABLE__M;
+	status = write16(state, OFDM_SC_RA_RAM_CONFIG__A, data);
+	if (status < 0)
+		goto error;
+
+	/* Activate SCU to enable SCU commands */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
+
+	if (!state->m_DRXK_A3_ROM_CODE) {
+		/* AGCInit() is not done for DVBT, so set agcFastClipCtrlDelay  */
+		status = write16(state, SCU_RAM_AGC_FAST_CLP_CTRL_DELAY__A, state->m_dvbtIfAgcCfg.FastClipCtrlDelay);
+		if (status < 0)
+			goto error;
+	}
+
+	/* OFDM_SC setup */
 #ifdef COMPILE_FOR_NONRT
-		status = write16(state, OFDM_SC_RA_RAM_BE_OPT_DELAY__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, OFDM_SC_RA_RAM_BE_OPT_INIT_DELAY__A, 2);
-		if (status < 0)
-			break;
+	status = write16(state, OFDM_SC_RA_RAM_BE_OPT_DELAY__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, OFDM_SC_RA_RAM_BE_OPT_INIT_DELAY__A, 2);
+	if (status < 0)
+		goto error;
 #endif
 
-		/* FEC setup */
-		status = write16(state, FEC_DI_INPUT_CTL__A, 1);	/* OFDM input */
-		if (status < 0)
-			break;
+	/* FEC setup */
+	status = write16(state, FEC_DI_INPUT_CTL__A, 1);	/* OFDM input */
+	if (status < 0)
+		goto error;
 
 
 #ifdef COMPILE_FOR_NONRT
-		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x400);
-		if (status < 0)
-			break;
+	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x400);
+	if (status < 0)
+		goto error;
 #else
-		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x1000);
-		if (status < 0)
-			break;
+	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, 0x1000);
+	if (status < 0)
+		goto error;
 #endif
-		status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, 0x0001);
-		if (status < 0)
-			break;
-
-		/* Setup MPEG bus */
-		status = MPEGTSDtoSetup(state, OM_DVBT);
-		if (status < 0)
-			break;
-		/* Set DVBT Presets */
-		status = DVBTActivatePresets(state);
-		if (status < 0)
-			break;
-
-	} while (0);
+	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, 0x0001);
+	if (status < 0)
+		goto error;
 
+	/* Setup MPEG bus */
+	status = MPEGTSDtoSetup(state, OM_DVBT);
 	if (status < 0)
-		printk(KERN_ERR "drxk: %s status - %08x\n", __func__, status);
+		goto error;
+	/* Set DVBT Presets */
+	status = DVBTActivatePresets(state);
+	if (status < 0)
+		goto error;
 
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3713,19 +3748,20 @@ static int DVBTStart(struct drxk_state *state)
 	dprintk(1, "\n");
 	/* Start correct processes to get in lock */
 	/* DRXK: OFDM_SC_RA_RAM_PROC_LOCKTRACK is no longer in mapfile! */
-	do {
-		param1 = OFDM_SC_RA_RAM_LOCKTRACK_MIN;
-		status = DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0, OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1, 0, 0, 0);
-		if (status < 0)
-			break;
-		/* Start FEC OC */
-		status = MPEGTSStart(state);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-	} while (0);
+	param1 = OFDM_SC_RA_RAM_LOCKTRACK_MIN;
+	status = DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_PROC_START, 0, OFDM_SC_RA_RAM_SW_EVENT_RUN_NMASK__M, param1, 0, 0, 0);
+	if (status < 0)
+		goto error;
+	/* Start FEC OC */
+	status = MPEGTSStart(state);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -3749,318 +3785,300 @@ static int SetDVBT(struct drxk_state *state, u16 IntermediateFreqkHz,
 	u16 param1;
 	int status;
 
-	dprintk(1, "\n");
-	/* printk(KERN_DEBUG "drxk: %s IF =%d, TFO = %d\n", __func__, IntermediateFreqkHz, tunerFreqOffset); */
-	do {
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
+	dprintk(1, "IF =%d, TFO = %d\n", IntermediateFreqkHz, tunerFreqOffset);
 
-		/* Halt SCU to enable safe non-atomic accesses */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
-		if (status < 0)
-			break;
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
+	if (status < 0)
+		goto error;
 
-		/* Stop processors */
-		status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
+	/* Halt SCU to enable safe non-atomic accesses */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+	if (status < 0)
+		goto error;
 
-		/* Mandatory fix, always stop CP, required to set spl offset back to
-		   hardware default (is set to 0 by ucode during pilot detection */
-		status = write16(state, OFDM_CP_COMM_EXEC__A, OFDM_CP_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
+	/* Stop processors */
+	status = write16(state, OFDM_SC_COMM_EXEC__A, OFDM_SC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, OFDM_LC_COMM_EXEC__A, OFDM_LC_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
 
-		/*== Write channel settings to device =====================================*/
+	/* Mandatory fix, always stop CP, required to set spl offset back to
+		hardware default (is set to 0 by ucode during pilot detection */
+	status = write16(state, OFDM_CP_COMM_EXEC__A, OFDM_CP_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
 
-		/* mode */
-		switch (state->param.u.ofdm.transmission_mode) {
-		case TRANSMISSION_MODE_AUTO:
-		default:
-			operationMode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
-			/* fall through , try first guess DRX_FFTMODE_8K */
-		case TRANSMISSION_MODE_8K:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
-			break;
-		case TRANSMISSION_MODE_2K:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_MODE_2K;
-			break;
-		}
+	/*== Write channel settings to device =====================================*/
 
-		/* guard */
-		switch (state->param.u.ofdm.guard_interval) {
-		default:
-		case GUARD_INTERVAL_AUTO:
-			operationMode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
-			/* fall through , try first guess DRX_GUARD_1DIV4 */
-		case GUARD_INTERVAL_1_4:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
-			break;
-		case GUARD_INTERVAL_1_32:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_GUARD_32;
-			break;
-		case GUARD_INTERVAL_1_16:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_GUARD_16;
-			break;
-		case GUARD_INTERVAL_1_8:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_GUARD_8;
-			break;
-		}
+	/* mode */
+	switch (state->param.u.ofdm.transmission_mode) {
+	case TRANSMISSION_MODE_AUTO:
+	default:
+		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_MODE__M;
+		/* fall through , try first guess DRX_FFTMODE_8K */
+	case TRANSMISSION_MODE_8K:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_8K;
+		goto error;
+	case TRANSMISSION_MODE_2K:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_MODE_2K;
+		goto error;
+	}
 
-		/* hierarchy */
-		switch (state->param.u.ofdm.hierarchy_information) {
-		case HIERARCHY_AUTO:
-		case HIERARCHY_NONE:
-		default:
-			operationMode |= OFDM_SC_RA_RAM_OP_AUTO_HIER__M;
-			/* fall through , try first guess SC_RA_RAM_OP_PARAM_HIER_NO */
-			/* transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_NO; */
-			/* break; */
-		case HIERARCHY_1:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_HIER_A1;
-			break;
-		case HIERARCHY_2:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_HIER_A2;
-			break;
-		case HIERARCHY_4:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_HIER_A4;
-			break;
-		}
+	/* guard */
+	switch (state->param.u.ofdm.guard_interval) {
+	default:
+	case GUARD_INTERVAL_AUTO:
+		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_GUARD__M;
+		/* fall through , try first guess DRX_GUARD_1DIV4 */
+	case GUARD_INTERVAL_1_4:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_4;
+		goto error;
+	case GUARD_INTERVAL_1_32:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_32;
+		goto error;
+	case GUARD_INTERVAL_1_16:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_16;
+		goto error;
+	case GUARD_INTERVAL_1_8:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_GUARD_8;
+		goto error;
+	}
 
+	/* hierarchy */
+	switch (state->param.u.ofdm.hierarchy_information) {
+	case HIERARCHY_AUTO:
+	case HIERARCHY_NONE:
+	default:
+		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_HIER__M;
+		/* fall through , try first guess SC_RA_RAM_OP_PARAM_HIER_NO */
+		/* transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_NO; */
+		/* break; */
+	case HIERARCHY_1:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A1;
+		break;
+	case HIERARCHY_2:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A2;
+		break;
+	case HIERARCHY_4:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_HIER_A4;
+		break;
+	}
 
-		/* constellation */
-		switch (state->param.u.ofdm.constellation) {
-		case QAM_AUTO:
-		default:
-			operationMode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
-			/* fall through , try first guess DRX_CONSTELLATION_QAM64 */
-		case QAM_64:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM64;
-			break;
-		case QPSK:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_CONST_QPSK;
-			break;
-		case QAM_16:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM16;
-			break;
-		}
+
+	/* constellation */
+	switch (state->param.u.ofdm.constellation) {
+	case QAM_AUTO:
+	default:
+		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_CONST__M;
+		/* fall through , try first guess DRX_CONSTELLATION_QAM64 */
+	case QAM_64:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM64;
+		break;
+	case QPSK:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QPSK;
+		break;
+	case QAM_16:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_CONST_QAM16;
+		break;
+	}
 #if 0
-		/* No hierachical channels support in BDA */
-		/* Priority (only for hierarchical channels) */
-		switch (channel->priority) {
-		case DRX_PRIORITY_LOW:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_PRIO_LO;
-			WR16(devAddr, OFDM_EC_SB_PRIOR__A,
-			     OFDM_EC_SB_PRIOR_LO);
-			break;
-		case DRX_PRIORITY_HIGH:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
-			WR16(devAddr, OFDM_EC_SB_PRIOR__A,
-			     OFDM_EC_SB_PRIOR_HI));
-			break;
-		case DRX_PRIORITY_UNKNOWN:	/* fall through */
-		default:
-			return DRX_STS_INVALID_ARG;
-			break;
-		}
-#else
-		/* Set Priorty high */
+	/* No hierachical channels support in BDA */
+	/* Priority (only for hierarchical channels) */
+	switch (channel->priority) {
+	case DRX_PRIORITY_LOW:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_LO;
+		WR16(devAddr, OFDM_EC_SB_PRIOR__A,
+			OFDM_EC_SB_PRIOR_LO);
+		break;
+	case DRX_PRIORITY_HIGH:
 		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
-		status = write16(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
-		if (status < 0)
-			break;
+		WR16(devAddr, OFDM_EC_SB_PRIOR__A,
+			OFDM_EC_SB_PRIOR_HI));
+		break;
+	case DRX_PRIORITY_UNKNOWN:	/* fall through */
+	default:
+		status = -EINVAL;
+		goto error;
+	}
+#else
+	/* Set Priorty high */
+	transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_PRIO_HI;
+	status = write16(state, OFDM_EC_SB_PRIOR__A, OFDM_EC_SB_PRIOR_HI);
+	if (status < 0)
+		goto error;
 #endif
 
-		/* coderate */
-		switch (state->param.u.ofdm.code_rate_HP) {
-		case FEC_AUTO:
-		default:
-			operationMode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
-			/* fall through , try first guess DRX_CODERATE_2DIV3 */
-		case FEC_2_3:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_RATE_2_3;
-			break;
-		case FEC_1_2:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_RATE_1_2;
-			break;
-		case FEC_3_4:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_RATE_3_4;
-			break;
-		case FEC_5_6:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_RATE_5_6;
-			break;
-		case FEC_7_8:
-			transmissionParams |=
-			    OFDM_SC_RA_RAM_OP_PARAM_RATE_7_8;
-			break;
-		}
+	/* coderate */
+	switch (state->param.u.ofdm.code_rate_HP) {
+	case FEC_AUTO:
+	default:
+		operationMode |= OFDM_SC_RA_RAM_OP_AUTO_RATE__M;
+		/* fall through , try first guess DRX_CODERATE_2DIV3 */
+	case FEC_2_3:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_2_3;
+		break;
+	case FEC_1_2:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_1_2;
+		break;
+	case FEC_3_4:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_3_4;
+		break;
+	case FEC_5_6:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_5_6;
+		break;
+	case FEC_7_8:
+		transmissionParams |= OFDM_SC_RA_RAM_OP_PARAM_RATE_7_8;
+		break;
+	}
 
-		/* SAW filter selection: normaly not necesarry, but if wanted
-		   the application can select a SAW filter via the driver by using UIOs */
-		/* First determine real bandwidth (Hz) */
-		/* Also set delay for impulse noise cruncher */
-		/* Also set parameters for EC_OC fix, note EC_OC_REG_TMD_HIL_MAR is changed
-		   by SC for fix for some 8K,1/8 guard but is restored by InitEC and ResetEC
-		   functions */
-		switch (state->param.u.ofdm.bandwidth) {
-		case BANDWIDTH_AUTO:
-		case BANDWIDTH_8_MHZ:
-			bandwidth = DRXK_BANDWIDTH_8MHZ_IN_HZ;
-			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
-			if (status < 0)
-				break;
-			/* cochannel protection for PAL 8 MHz */
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 7);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 7);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 7);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
-			if (status < 0)
-				break;
-			break;
-		case BANDWIDTH_7_MHZ:
-			bandwidth = DRXK_BANDWIDTH_7MHZ_IN_HZ;
-			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
-			if (status < 0)
-				break;
-			/* cochannel protection for PAL 7 MHz */
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 8);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 8);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 4);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
-			if (status < 0)
-				break;
-			break;
-		case BANDWIDTH_6_MHZ:
-			bandwidth = DRXK_BANDWIDTH_6MHZ_IN_HZ;
-			status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
-			if (status < 0)
-				break;
-			/* cochannel protection for NTSC 6 MHz */
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 19);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 19);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 14);
-			if (status < 0)
-				break;
-			status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
-			if (status < 0)
-				break;
-			break;
-		default:
-			return -EINVAL;
-		}
+	/* SAW filter selection: normaly not necesarry, but if wanted
+		the application can select a SAW filter via the driver by using UIOs */
+	/* First determine real bandwidth (Hz) */
+	/* Also set delay for impulse noise cruncher */
+	/* Also set parameters for EC_OC fix, note EC_OC_REG_TMD_HIL_MAR is changed
+		by SC for fix for some 8K,1/8 guard but is restored by InitEC and ResetEC
+		functions */
+	switch (state->param.u.ofdm.bandwidth) {
+	case BANDWIDTH_AUTO:
+	case BANDWIDTH_8_MHZ:
+		bandwidth = DRXK_BANDWIDTH_8MHZ_IN_HZ;
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3052);
+		if (status < 0)
+			goto error;
+		/* cochannel protection for PAL 8 MHz */
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 7);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 7);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 7);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		if (status < 0)
+			goto error;
+		break;
+	case BANDWIDTH_7_MHZ:
+		bandwidth = DRXK_BANDWIDTH_7MHZ_IN_HZ;
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 3491);
+		if (status < 0)
+			goto error;
+		/* cochannel protection for PAL 7 MHz */
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 8);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 8);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 4);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		if (status < 0)
+			goto error;
+		break;
+	case BANDWIDTH_6_MHZ:
+		bandwidth = DRXK_BANDWIDTH_6MHZ_IN_HZ;
+		status = write16(state, OFDM_SC_RA_RAM_SRMM_FIX_FACT_8K__A, 4073);
+		if (status < 0)
+			goto error;
+		/* cochannel protection for NTSC 6 MHz */
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_LEFT__A, 19);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_8K_PER_RIGHT__A, 19);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_LEFT__A, 14);
+		if (status < 0)
+			goto error;
+		status = write16(state, OFDM_SC_RA_RAM_NI_INIT_2K_PER_RIGHT__A, 1);
+		if (status < 0)
+			goto error;
+		break;
+	default:
+		status = -EINVAL;
+		goto error;
+	}
 
-		if (iqmRcRateOfs == 0) {
-			/* Now compute IQM_RC_RATE_OFS
-			   (((SysFreq/BandWidth)/2)/2) -1) * 2^23)
-			   =>
-			   ((SysFreq / BandWidth) * (2^21)) - (2^23)
-			 */
-			/* (SysFreq / BandWidth) * (2^28)  */
-			/* assert (MAX(sysClk)/MIN(bandwidth) < 16)
-			   => assert(MAX(sysClk) < 16*MIN(bandwidth))
-			   => assert(109714272 > 48000000) = true so Frac 28 can be used  */
-			iqmRcRateOfs = Frac28a((u32)
-					       ((state->m_sysClockFreq *
-						 1000) / 3), bandwidth);
-			/* (SysFreq / BandWidth) * (2^21), rounding before truncating  */
-			if ((iqmRcRateOfs & 0x7fL) >= 0x40)
-				iqmRcRateOfs += 0x80L;
-			iqmRcRateOfs = iqmRcRateOfs >> 7;
-			/* ((SysFreq / BandWidth) * (2^21)) - (2^23)  */
-			iqmRcRateOfs = iqmRcRateOfs - (1 << 23);
-		}
+	if (iqmRcRateOfs == 0) {
+		/* Now compute IQM_RC_RATE_OFS
+			(((SysFreq/BandWidth)/2)/2) -1) * 2^23)
+			=>
+			((SysFreq / BandWidth) * (2^21)) - (2^23)
+			*/
+		/* (SysFreq / BandWidth) * (2^28)  */
+		/* assert (MAX(sysClk)/MIN(bandwidth) < 16)
+			=> assert(MAX(sysClk) < 16*MIN(bandwidth))
+			=> assert(109714272 > 48000000) = true so Frac 28 can be used  */
+		iqmRcRateOfs = Frac28a((u32)
+					((state->m_sysClockFreq *
+						1000) / 3), bandwidth);
+		/* (SysFreq / BandWidth) * (2^21), rounding before truncating  */
+		if ((iqmRcRateOfs & 0x7fL) >= 0x40)
+			iqmRcRateOfs += 0x80L;
+		iqmRcRateOfs = iqmRcRateOfs >> 7;
+		/* ((SysFreq / BandWidth) * (2^21)) - (2^23)  */
+		iqmRcRateOfs = iqmRcRateOfs - (1 << 23);
+	}
 
-		iqmRcRateOfs &=
-		    ((((u32) IQM_RC_RATE_OFS_HI__M) <<
-		      IQM_RC_RATE_OFS_LO__W) | IQM_RC_RATE_OFS_LO__M);
-		status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRateOfs);
-		if (status < 0)
-			break;
+	iqmRcRateOfs &=
+		((((u32) IQM_RC_RATE_OFS_HI__M) <<
+		IQM_RC_RATE_OFS_LO__W) | IQM_RC_RATE_OFS_LO__M);
+	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRateOfs);
+	if (status < 0)
+		goto error;
 
-		/* Bandwidth setting done */
+	/* Bandwidth setting done */
 
 #if 0
-		status = DVBTSetFrequencyShift(demod, channel, tunerOffset);
-		if (status < 0)
-			break;
+	status = DVBTSetFrequencyShift(demod, channel, tunerOffset);
+	if (status < 0)
+		goto error;
 #endif
-		status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
-		if (status < 0)
-			break;
+	status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
+	if (status < 0)
+		goto error;
 
-		/*== Start SC, write channel settings to SC ===============================*/
+	/*== Start SC, write channel settings to SC ===============================*/
 
-		/* Activate SCU to enable SCU commands */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
+	/* Activate SCU to enable SCU commands */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
 
-		/* Enable SC after setting all other parameters */
-		status = write16(state, OFDM_SC_COMM_STATE__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, OFDM_SC_COMM_EXEC__A, 1);
-		if (status < 0)
-			break;
+	/* Enable SC after setting all other parameters */
+	status = write16(state, OFDM_SC_COMM_STATE__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, OFDM_SC_COMM_EXEC__A, 1);
+	if (status < 0)
+		goto error;
 
 
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_OFDM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
+	if (status < 0)
+		goto error;
 
-		/* Write SC parameter registers, set all AUTO flags in operation mode */
-		param1 = (OFDM_SC_RA_RAM_OP_AUTO_MODE__M |
-			  OFDM_SC_RA_RAM_OP_AUTO_GUARD__M |
-			  OFDM_SC_RA_RAM_OP_AUTO_CONST__M |
-			  OFDM_SC_RA_RAM_OP_AUTO_HIER__M |
-			  OFDM_SC_RA_RAM_OP_AUTO_RATE__M);
-		status =
-		    DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM,
-				  0, transmissionParams, param1, 0, 0, 0);
-		if (!state->m_DRXK_A3_ROM_CODE)
-			status = DVBTCtrlSetSqiSpeed(state, &state->m_sqiSpeed);
-			if (status < 0)
-				break;
+	/* Write SC parameter registers, set all AUTO flags in operation mode */
+	param1 = (OFDM_SC_RA_RAM_OP_AUTO_MODE__M |
+			OFDM_SC_RA_RAM_OP_AUTO_GUARD__M |
+			OFDM_SC_RA_RAM_OP_AUTO_CONST__M |
+			OFDM_SC_RA_RAM_OP_AUTO_HIER__M |
+			OFDM_SC_RA_RAM_OP_AUTO_RATE__M);
+	status = DVBTScCommand(state, OFDM_SC_RA_RAM_CMD_SET_PREF_PARAM,
+				0, transmissionParams, param1, 0, 0, 0);
+	if (status < 0)
+		goto error;
 
-	} while (0);
+	if (!state->m_DRXK_A3_ROM_CODE)
+		status = DVBTCtrlSetSqiSpeed(state, &state->m_sqiSpeed);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4088,16 +4106,18 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 
 	dprintk(1, "\n");
 
+	*pLockStatus = NOT_LOCKED;
 	/* driver 0.9.0 */
 	/* Check if SC is running */
 	status = read16(state, OFDM_SC_COMM_EXEC__A, &ScCommExec);
-	if (ScCommExec == OFDM_SC_COMM_EXEC_STOP) {
-		/* SC not active; return DRX_NOT_LOCKED */
-		*pLockStatus = NOT_LOCKED;
-		return status;
-	}
+	if (status < 0)
+		goto end;
+	if (ScCommExec == OFDM_SC_COMM_EXEC_STOP)
+		goto end;
 
 	status = read16(state, OFDM_SC_RA_RAM_LOCK__A, &ScRaRamLock);
+	if (status < 0)
+		goto end;
 
 	if ((ScRaRamLock & mpeg_lock_mask) == mpeg_lock_mask)
 		*pLockStatus = MPEG_LOCK;
@@ -4107,8 +4127,9 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 		*pLockStatus = DEMOD_LOCK;
 	else if (ScRaRamLock & OFDM_SC_RA_RAM_LOCK_NODVBT__M)
 		*pLockStatus = NEVER_LOCK;
-	else
-		*pLockStatus = NOT_LOCKED;
+end:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4116,15 +4137,12 @@ static int GetDVBTLockStatus(struct drxk_state *state, u32 *pLockStatus)
 static int PowerUpQAM(struct drxk_state *state)
 {
 	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
-	int status = 0;
+	int status;
 
 	dprintk(1, "\n");
-	do {
-		status = CtrlPowerMode(state, &powerMode);
-		if (status < 0)
-			break;
-
-	} while (0);
+	status = CtrlPowerMode(state, &powerMode);
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4138,28 +4156,28 @@ static int PowerDownQAM(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		status = read16(state, SCU_COMM_EXEC__A, &data);
+	status = read16(state, SCU_COMM_EXEC__A, &data);
+	if (status < 0)
+		goto error;
+	if (data == SCU_COMM_EXEC_ACTIVE) {
+		/*
+			STOP demodulator
+			QAM and HW blocks
+			*/
+		/* stop all comstate->m_exec */
+		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
 		if (status < 0)
-			break;
-		if (data == SCU_COMM_EXEC_ACTIVE) {
-			/*
-			   STOP demodulator
-			   QAM and HW blocks
-			 */
-			/* stop all comstate->m_exec */
-			status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
-			if (status < 0)
-				break;
-			status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
-			if (status < 0)
-				break;
-		}
-		/* powerdown AFE                   */
-		status = SetIqmAf(state, false);
+			goto error;
+		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_STOP, 0, NULL, 1, &cmdResult);
 		if (status < 0)
-			break;
-	} while (0);
+			goto error;
+	}
+	/* powerdown AFE                   */
+	status = SetIqmAf(state, false);
+
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4190,73 +4208,64 @@ static int SetQAMMeasurement(struct drxk_state *state,
 	dprintk(1, "\n");
 
 	fecRsPrescale = 1;
-	do {
-
-		/* fecBitsDesired = symbolRate [kHz] *
-		   FrameLenght [ms] *
-		   (constellation + 1) *
-		   SyncLoss (== 1) *
-		   ViterbiLoss (==1)
-		 */
-		switch (constellation) {
-		case DRX_CONSTELLATION_QAM16:
-			fecBitsDesired = 4 * symbolRate;
-			break;
-		case DRX_CONSTELLATION_QAM32:
-			fecBitsDesired = 5 * symbolRate;
-			break;
-		case DRX_CONSTELLATION_QAM64:
-			fecBitsDesired = 6 * symbolRate;
-			break;
-		case DRX_CONSTELLATION_QAM128:
-			fecBitsDesired = 7 * symbolRate;
-			break;
-		case DRX_CONSTELLATION_QAM256:
-			fecBitsDesired = 8 * symbolRate;
-			break;
-		default:
-			status = -EINVAL;
-		}
-		status = status;
-		if (status < 0)
-			break;
-
-		fecBitsDesired /= 1000;	/* symbolRate [Hz] -> symbolRate [kHz]  */
-		fecBitsDesired *= 500;	/* meas. period [ms] */
+	/* fecBitsDesired = symbolRate [kHz] *
+		FrameLenght [ms] *
+		(constellation + 1) *
+		SyncLoss (== 1) *
+		ViterbiLoss (==1)
+		*/
+	switch (constellation) {
+	case DRX_CONSTELLATION_QAM16:
+		fecBitsDesired = 4 * symbolRate;
+		break;
+	case DRX_CONSTELLATION_QAM32:
+		fecBitsDesired = 5 * symbolRate;
+		break;
+	case DRX_CONSTELLATION_QAM64:
+		fecBitsDesired = 6 * symbolRate;
+		break;
+	case DRX_CONSTELLATION_QAM128:
+		fecBitsDesired = 7 * symbolRate;
+		break;
+	case DRX_CONSTELLATION_QAM256:
+		fecBitsDesired = 8 * symbolRate;
+		break;
+	default:
+		status = -EINVAL;
+	}
+	if (status < 0)
+		goto error;
 
-		/* Annex A/C: bits/RsPeriod = 204 * 8 = 1632 */
-		/* fecRsPeriodTotal = fecBitsDesired / 1632 */
-		fecRsPeriodTotal = (fecBitsDesired / 1632UL) + 1;	/* roughly ceil */
+	fecBitsDesired /= 1000;	/* symbolRate [Hz] -> symbolRate [kHz]  */
+	fecBitsDesired *= 500;	/* meas. period [ms] */
 
-		/* fecRsPeriodTotal =  fecRsPrescale * fecRsPeriod  */
-		fecRsPrescale = 1 + (u16) (fecRsPeriodTotal >> 16);
-		if (fecRsPrescale == 0) {
-			/* Divide by zero (though impossible) */
-			status = -1;
-		}
-		status = status;
-		if (status < 0)
-			break;
-		fecRsPeriod =
-		    ((u16) fecRsPeriodTotal +
-		     (fecRsPrescale >> 1)) / fecRsPrescale;
+	/* Annex A/C: bits/RsPeriod = 204 * 8 = 1632 */
+	/* fecRsPeriodTotal = fecBitsDesired / 1632 */
+	fecRsPeriodTotal = (fecBitsDesired / 1632UL) + 1;	/* roughly ceil */
 
-		/* write corresponding registers */
-		status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fecRsPeriod);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
+	/* fecRsPeriodTotal =  fecRsPrescale * fecRsPeriod  */
+	fecRsPrescale = 1 + (u16) (fecRsPeriodTotal >> 16);
+	if (fecRsPrescale == 0) {
+		/* Divide by zero (though impossible) */
+		status = -EINVAL;
 		if (status < 0)
-			break;
-		status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fecRsPeriod);
-		if (status < 0)
-			break;
-
-	} while (0);
-
+			goto error;
+	}
+	fecRsPeriod =
+		((u16) fecRsPeriodTotal +
+		(fecRsPrescale >> 1)) / fecRsPrescale;
+
+	/* write corresponding registers */
+	status = write16(state, FEC_RS_MEASUREMENT_PERIOD__A, fecRsPeriod);
 	if (status < 0)
-		printk(KERN_ERR "drxk: %s: status - %08x\n", __func__, status);
-
+		goto error;
+	status = write16(state, FEC_RS_MEASUREMENT_PRESCALE__A, fecRsPrescale);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_OC_SNC_FAIL_PERIOD__A, fecRsPeriod);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4265,183 +4274,184 @@ static int SetQAM16(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* QAM Equalizer Setup */
-		/* Equalizer */
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13517);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 13517);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 13517);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13517);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13517);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 13517);
-		if (status < 0)
-			break;
-		/* Decision Feedback Equalizer */
-		status = write16(state, QAM_DQ_QUAL_FUN0__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN1__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN2__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN3__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN4__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
-		if (status < 0)
-			break;
+	/* QAM Equalizer Setup */
+	/* Equalizer */
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13517);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 13517);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 13517);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13517);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13517);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 13517);
+	if (status < 0)
+		goto error;
+	/* Decision Feedback Equalizer */
+	status = write16(state, QAM_DQ_QUAL_FUN0__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN1__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN2__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN3__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN4__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
-		if (status < 0)
-			break;
+	status = write16(state, QAM_SY_SYNC_HWM__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_AWM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_LWM__A, 3);
+	if (status < 0)
+		goto error;
 
-		/* QAM Slicer Settings */
-		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM16);
-		if (status < 0)
-			break;
+	/* QAM Slicer Settings */
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM16);
+	if (status < 0)
+		goto error;
 
-		/* QAM Loop Controller Coeficients */
-		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
-		if (status < 0)
-			break;
+	/* QAM Loop Controller Coeficients */
+	status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 32);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 32);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+	if (status < 0)
+		goto error;
 
 
-		/* QAM State Machine (FSM) Thresholds */
+	/* QAM State Machine (FSM) Thresholds */
 
-		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 140);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 95);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 120);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 230);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 105);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 140);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 95);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 120);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 230);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 105);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 24);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 24);
+	if (status < 0)
+		goto error;
 
 
-		/* QAM FSM Tracking Parameters */
+	/* QAM FSM Tracking Parameters */
 
-		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 220);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 25);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 6);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -65);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -127);
-		if (status < 0)
-			break;
-	} while (0);
+	status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 220);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 25);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -65);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -127);
+	if (status < 0)
+		goto error;
 
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4457,187 +4467,186 @@ static int SetQAM32(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* QAM Equalizer Setup */
-		/* Equalizer */
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6707);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6707);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6707);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6707);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6707);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 6707);
-		if (status < 0)
-			break;
-
-		/* Decision Feedback Equalizer */
-		status = write16(state, QAM_DQ_QUAL_FUN0__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN1__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN2__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN3__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
-		if (status < 0)
-			break;
-
-		status = write16(state, QAM_SY_SYNC_HWM__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_AWM__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
-		if (status < 0)
-			break;
-
-		/* QAM Slicer Settings */
-
-		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM32);
-		if (status < 0)
-			break;
-
-
-		/* QAM Loop Controller Coeficients */
-
-		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
-		if (status < 0)
-			break;
-
-
-		/* QAM State Machine (FSM) Thresholds */
-
-		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 90);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 170);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 10);
-		if (status < 0)
-			break;
-
-
-		/* QAM FSM Tracking Parameters */
-
-		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 140);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) -8);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) -16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -26);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -56);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -86);
-		if (status < 0)
-			break;
-	} while (0);
 
+	/* QAM Equalizer Setup */
+	/* Equalizer */
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6707);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6707);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6707);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6707);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6707);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 6707);
+	if (status < 0)
+		goto error;
+
+	/* Decision Feedback Equalizer */
+	status = write16(state, QAM_DQ_QUAL_FUN0__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN1__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN2__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN3__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, QAM_SY_SYNC_HWM__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_AWM__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_LWM__A, 3);
+	if (status < 0)
+		goto error;
+
+	/* QAM Slicer Settings */
+
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM32);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM Loop Controller Coeficients */
+
+	status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 20);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 20);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM State Machine (FSM) Thresholds */
+
+	status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 90);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 170);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 10);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM FSM Tracking Parameters */
+
+	status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 140);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) -8);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) -16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -26);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -56);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -86);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -4653,185 +4662,184 @@ static int SetQAM64(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* QAM Equalizer Setup */
-		/* Equalizer */
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13336);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12618);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 11988);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13809);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13809);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15609);
-		if (status < 0)
-			break;
+	/* QAM Equalizer Setup */
+	/* Equalizer */
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 13336);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12618);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 11988);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 13809);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13809);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15609);
+	if (status < 0)
+		goto error;
 
-		/* Decision Feedback Equalizer */
-		status = write16(state, QAM_DQ_QUAL_FUN0__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN1__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN2__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN3__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
-		if (status < 0)
-			break;
+	/* Decision Feedback Equalizer */
+	status = write16(state, QAM_DQ_QUAL_FUN0__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN1__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN2__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN3__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN4__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
-		if (status < 0)
-			break;
+	status = write16(state, QAM_SY_SYNC_HWM__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_AWM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_LWM__A, 3);
+	if (status < 0)
+		goto error;
 
-		/* QAM Slicer Settings */
-		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM64);
-		if (status < 0)
-			break;
+	/* QAM Slicer Settings */
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM64);
+	if (status < 0)
+		goto error;
 
 
-		/* QAM Loop Controller Coeficients */
+	/* QAM Loop Controller Coeficients */
 
-		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 30);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 100);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 30);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 30);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 100);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 30);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+	if (status < 0)
+		goto error;
 
 
-		/* QAM State Machine (FSM) Thresholds */
+	/* QAM State Machine (FSM) Thresholds */
 
-		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 100);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 110);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 200);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 95);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 100);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 110);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 200);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 95);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 15);
-		if (status < 0)
-			break;
+	status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 15);
+	if (status < 0)
+		goto error;
 
 
-		/* QAM FSM Tracking Parameters */
+	/* QAM FSM Tracking Parameters */
 
-		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 141);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 7);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -45);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -80);
-		if (status < 0)
-			break;
-	} while (0);
+	status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 141);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 7);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -45);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -80);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -4848,187 +4856,186 @@ static int SetQAM128(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* QAM Equalizer Setup */
-		/* Equalizer */
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6564);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6598);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6394);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6409);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6656);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 7238);
-		if (status < 0)
-			break;
-
-		/* Decision Feedback Equalizer */
-		status = write16(state, QAM_DQ_QUAL_FUN0__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN1__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN2__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN3__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN4__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
-		if (status < 0)
-			break;
-
-		status = write16(state, QAM_SY_SYNC_HWM__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_AWM__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
-		if (status < 0)
-			break;
-
-
-		/* QAM Slicer Settings */
-
-		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM128);
-		if (status < 0)
-			break;
-
-
-		/* QAM Loop Controller Coeficients */
-
-		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 120);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 60);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 64);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
-		if (status < 0)
-			break;
-
-
-		/* QAM State Machine (FSM) Thresholds */
-
-		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 140);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 5);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
-		if (status < 0)
-			break;
-
-		/* QAM FSM Tracking Parameters */
-
-		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 65);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 3);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -1);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -23);
-		if (status < 0)
-			break;
-	} while (0);
+	/* QAM Equalizer Setup */
+	/* Equalizer */
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 6564);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 6598);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 6394);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 6409);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 6656);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 7238);
+	if (status < 0)
+		goto error;
+
+	/* Decision Feedback Equalizer */
+	status = write16(state, QAM_DQ_QUAL_FUN0__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN1__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN2__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN3__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN4__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, QAM_SY_SYNC_HWM__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_AWM__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_LWM__A, 3);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM Slicer Settings */
+
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM128);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM Loop Controller Coeficients */
+
+	status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 120);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 60);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 64);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 0);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM State Machine (FSM) Thresholds */
+
+	status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 140);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 100);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 5);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
+	if (status < 0)
+		goto error;
+
+	/* QAM FSM Tracking Parameters */
+
+	status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 65);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) -1);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) -12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -23);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return status;
 }
@@ -5045,187 +5052,185 @@ static int SetQAM256(struct drxk_state *state)
 	int status = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* QAM Equalizer Setup */
-		/* Equalizer */
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 11502);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12084);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 12543);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 12931);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13629);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15385);
-		if (status < 0)
-			break;
-
-		/* Decision Feedback Equalizer */
-		status = write16(state, QAM_DQ_QUAL_FUN0__A, 8);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN1__A, 8);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN2__A, 8);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN3__A, 8);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN4__A, 6);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
-		if (status < 0)
-			break;
-
-		status = write16(state, QAM_SY_SYNC_HWM__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_AWM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_SYNC_LWM__A, 3);
-		if (status < 0)
-			break;
-
-		/* QAM Slicer Settings */
-
-		status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM256);
-		if (status < 0)
-			break;
-
-
-		/* QAM Loop Controller Coeficients */
-
-		status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 250);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 125);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
-		if (status < 0)
-			break;
-
-
-		/* QAM State Machine (FSM) Thresholds */
-
-		status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 150);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 110);
-		if (status < 0)
-			break;
-
-		status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
-		if (status < 0)
-			break;
-
-
-		/* QAM FSM Tracking Parameters */
-
-		status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 74);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 18);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 13);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) 7);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) 0);
-		if (status < 0)
-			break;
-		status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -8);
-		if (status < 0)
-			break;
-	} while (0);
-
+	/* QAM Equalizer Setup */
+	/* Equalizer */
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD0__A, 11502);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD1__A, 12084);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD2__A, 12543);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD3__A, 12931);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD4__A, 13629);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_EQ_CMA_RAD5__A, 15385);
+	if (status < 0)
+		goto error;
+
+	/* Decision Feedback Equalizer */
+	status = write16(state, QAM_DQ_QUAL_FUN0__A, 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN1__A, 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN2__A, 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN3__A, 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN4__A, 6);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_DQ_QUAL_FUN5__A, 0);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, QAM_SY_SYNC_HWM__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_AWM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_SYNC_LWM__A, 3);
+	if (status < 0)
+		goto error;
+
+	/* QAM Slicer Settings */
+
+	status = write16(state, SCU_RAM_QAM_SL_SIG_POWER__A, DRXK_QAM_SL_SIG_POWER_QAM256);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM Loop Controller Coeficients */
+
+	status = write16(state, SCU_RAM_QAM_LC_CA_FINE__A, 15);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CA_COARSE__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_MEDIUM__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EP_COARSE__A, 24);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_FINE__A, 12);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_MEDIUM__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_EI_COARSE__A, 16);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_LC_CP_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_MEDIUM__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CP_COARSE__A, 250);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_MEDIUM__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CI_COARSE__A, 125);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_FINE__A, 16);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_MEDIUM__A, 25);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF_COARSE__A, 48);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_FINE__A, 5);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_MEDIUM__A, 10);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_LC_CF1_COARSE__A, 10);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM State Machine (FSM) Thresholds */
+
+	status = write16(state, SCU_RAM_QAM_FSM_RTH__A, 50);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FTH__A, 60);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_CTH__A, 80);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_PTH__A, 100);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_QTH__A, 150);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_MTH__A, 110);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, SCU_RAM_QAM_FSM_RATE_LIM__A, 40);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_COUNT_LIM__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_FREQ_LIM__A, 12);
+	if (status < 0)
+		goto error;
+
+
+	/* QAM FSM Tracking Parameters */
+
+	status = write16(state, SCU_RAM_QAM_FSM_MEDIAN_AV_MULT__A, (u16) 8);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_RADIUS_AV_LIMIT__A, (u16) 74);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET1__A, (u16) 18);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET2__A, (u16) 13);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET3__A, (u16) 7);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET4__A, (u16) 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, SCU_RAM_QAM_FSM_LCAVG_OFFSET5__A, (u16) -8);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5243,18 +5248,15 @@ static int QAMResetQAM(struct drxk_state *state)
 	u16 cmdResult;
 
 	dprintk(1, "\n");
-	do {
-		/* Stop QAM comstate->m_exec */
-		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
+	/* Stop QAM comstate->m_exec */
+	status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
 
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
-	} while (0);
-
-	/* All done, all OK */
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_RESET, 0, NULL, 1, &cmdResult);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5276,54 +5278,55 @@ static int QAMSetSymbolrate(struct drxk_state *state)
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		/* Select & calculate correct IQM rate */
-		adcFrequency = (state->m_sysClockFreq * 1000) / 3;
-		ratesel = 0;
-		/* printk(KERN_DEBUG "drxk: SR %d\n", state->param.u.qam.symbol_rate); */
-		if (state->param.u.qam.symbol_rate <= 1188750)
-			ratesel = 3;
-		else if (state->param.u.qam.symbol_rate <= 2377500)
-			ratesel = 2;
-		else if (state->param.u.qam.symbol_rate <= 4755000)
-			ratesel = 1;
-		status = write16(state, IQM_FD_RATESEL__A, ratesel);
-		if (status < 0)
-			break;
+	/* Select & calculate correct IQM rate */
+	adcFrequency = (state->m_sysClockFreq * 1000) / 3;
+	ratesel = 0;
+	/* printk(KERN_DEBUG "drxk: SR %d\n", state->param.u.qam.symbol_rate); */
+	if (state->param.u.qam.symbol_rate <= 1188750)
+		ratesel = 3;
+	else if (state->param.u.qam.symbol_rate <= 2377500)
+		ratesel = 2;
+	else if (state->param.u.qam.symbol_rate <= 4755000)
+		ratesel = 1;
+	status = write16(state, IQM_FD_RATESEL__A, ratesel);
+	if (status < 0)
+		goto error;
 
-		/*
-		   IqmRcRate = ((Fadc / (symbolrate * (4<<ratesel))) - 1) * (1<<23)
-		 */
-		symbFreq = state->param.u.qam.symbol_rate * (1 << ratesel);
-		if (symbFreq == 0) {
-			/* Divide by zero */
-			return -1;
-		}
-		iqmRcRate = (adcFrequency / symbFreq) * (1 << 21) +
-		    (Frac28a((adcFrequency % symbFreq), symbFreq) >> 7) -
-		    (1 << 23);
-		status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRate);
-		if (status < 0)
-			break;
-		state->m_iqmRcRate = iqmRcRate;
-		/*
-		   LcSymbFreq = round (.125 *  symbolrate / adcFreq * (1<<15))
-		 */
-		symbFreq = state->param.u.qam.symbol_rate;
-		if (adcFrequency == 0) {
-			/* Divide by zero */
-			return -1;
-		}
-		lcSymbRate = (symbFreq / adcFrequency) * (1 << 12) +
-		    (Frac28a((symbFreq % adcFrequency), adcFrequency) >>
-		     16);
-		if (lcSymbRate > 511)
-			lcSymbRate = 511;
-		status = write16(state, QAM_LC_SYMBOL_FREQ__A, (u16) lcSymbRate);
-		if (status < 0)
-			break;
-	} while (0);
+	/*
+		IqmRcRate = ((Fadc / (symbolrate * (4<<ratesel))) - 1) * (1<<23)
+		*/
+	symbFreq = state->param.u.qam.symbol_rate * (1 << ratesel);
+	if (symbFreq == 0) {
+		/* Divide by zero */
+		status = -EINVAL;
+		goto error;
+	}
+	iqmRcRate = (adcFrequency / symbFreq) * (1 << 21) +
+		(Frac28a((adcFrequency % symbFreq), symbFreq) >> 7) -
+		(1 << 23);
+	status = write32(state, IQM_RC_RATE_OFS_LO__A, iqmRcRate);
+	if (status < 0)
+		goto error;
+	state->m_iqmRcRate = iqmRcRate;
+	/*
+		LcSymbFreq = round (.125 *  symbolrate / adcFreq * (1<<15))
+		*/
+	symbFreq = state->param.u.qam.symbol_rate;
+	if (adcFrequency == 0) {
+		/* Divide by zero */
+		status = -EINVAL;
+		goto error;
+	}
+	lcSymbRate = (symbFreq / adcFrequency) * (1 << 12) +
+		(Frac28a((symbFreq % adcFrequency), adcFrequency) >>
+		16);
+	if (lcSymbRate > 511)
+		lcSymbRate = 511;
+	status = write16(state, QAM_LC_SYMBOL_FREQ__A, (u16) lcSymbRate);
 
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5342,8 +5345,8 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 	u16 Result[2] = { 0, 0 };
 
 	dprintk(1, "\n");
-	status =
-	    scu_command(state,
+	*pLockStatus = NOT_LOCKED;
+	status = scu_command(state,
 			SCU_RAM_COMMAND_STANDARD_QAM |
 			SCU_RAM_COMMAND_CMD_DEMOD_GET_LOCK, 0, NULL, 2,
 			Result);
@@ -5352,7 +5355,6 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 
 	if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_DEMOD_LOCKED) {
 		/* 0x0000 NOT LOCKED */
-		*pLockStatus = NOT_LOCKED;
 	} else if (Result[1] < SCU_RAM_QAM_LOCKED_LOCKED_LOCKED) {
 		/* 0x4000 DEMOD LOCKED */
 		*pLockStatus = DEMOD_LOCK;
@@ -5379,416 +5381,395 @@ static int GetQAMLockStatus(struct drxk_state *state, u32 *pLockStatus)
 static int SetQAM(struct drxk_state *state, u16 IntermediateFreqkHz,
 		  s32 tunerFreqOffset)
 {
-	int status = 0;
+	int status;
 	u8 parameterLen;
 	u16 setEnvParameters[5];
 	u16 setParamParameters[4] = { 0, 0, 0, 0 };
 	u16 cmdResult;
 
 	dprintk(1, "\n");
-	do {
-		/*
-		   STEP 1: reset demodulator
-		   resets FEC DI and FEC RS
-		   resets QAM block
-		   resets SCU variables
-		 */
-		status = write16(state, FEC_DI_COMM_EXEC__A, FEC_DI_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_RS_COMM_EXEC__A, FEC_RS_COMM_EXEC_STOP);
-		if (status < 0)
-			break;
-		status = QAMResetQAM(state);
-		if (status < 0)
-			break;
+	/*
+		STEP 1: reset demodulator
+		resets FEC DI and FEC RS
+		resets QAM block
+		resets SCU variables
+		*/
+	status = write16(state, FEC_DI_COMM_EXEC__A, FEC_DI_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_RS_COMM_EXEC__A, FEC_RS_COMM_EXEC_STOP);
+	if (status < 0)
+		goto error;
+	status = QAMResetQAM(state);
+	if (status < 0)
+		goto error;
 
-		/*
-		   STEP 2: configure demodulator
-		   -set env
-		   -set params; resets IQM,QAM,FEC HW; initializes some SCU variables
-		 */
-		status = QAMSetSymbolrate(state);
-		if (status < 0)
-			break;
+	/*
+		STEP 2: configure demodulator
+		-set env
+		-set params; resets IQM,QAM,FEC HW; initializes some SCU variables
+		*/
+	status = QAMSetSymbolrate(state);
+	if (status < 0)
+		goto error;
 
-		/* Env parameters */
-		setEnvParameters[2] = QAM_TOP_ANNEX_A;	/* Annex */
-		if (state->m_OperationMode == OM_QAM_ITU_C)
-			setEnvParameters[2] = QAM_TOP_ANNEX_C;	/* Annex */
-		setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
-		/* check for LOCKRANGE Extented */
-		/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
-		parameterLen = 4;
+	/* Env parameters */
+	setEnvParameters[2] = QAM_TOP_ANNEX_A;	/* Annex */
+	if (state->m_OperationMode == OM_QAM_ITU_C)
+		setEnvParameters[2] = QAM_TOP_ANNEX_C;	/* Annex */
+	setParamParameters[3] |= (QAM_MIRROR_AUTO_ON);
+	/* check for LOCKRANGE Extented */
+	/* setParamParameters[3] |= QAM_LOCKRANGE_NORMAL; */
+	parameterLen = 4;
 
-		/* Set params */
-		switch (state->param.u.qam.modulation) {
-		case QAM_256:
-			state->m_Constellation = DRX_CONSTELLATION_QAM256;
-			break;
-		case QAM_AUTO:
-		case QAM_64:
-			state->m_Constellation = DRX_CONSTELLATION_QAM64;
-			break;
-		case QAM_16:
-			state->m_Constellation = DRX_CONSTELLATION_QAM16;
-			break;
-		case QAM_32:
-			state->m_Constellation = DRX_CONSTELLATION_QAM32;
-			break;
-		case QAM_128:
-			state->m_Constellation = DRX_CONSTELLATION_QAM128;
-			break;
-		default:
-			status = -EINVAL;
-			break;
-		}
-		status = status;
-		if (status < 0)
-			break;
-		setParamParameters[0] = state->m_Constellation;	/* constellation     */
-		setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
+	/* Set params */
+	switch (state->param.u.qam.modulation) {
+	case QAM_256:
+		state->m_Constellation = DRX_CONSTELLATION_QAM256;
+		break;
+	case QAM_AUTO:
+	case QAM_64:
+		state->m_Constellation = DRX_CONSTELLATION_QAM64;
+		break;
+	case QAM_16:
+		state->m_Constellation = DRX_CONSTELLATION_QAM16;
+		break;
+	case QAM_32:
+		state->m_Constellation = DRX_CONSTELLATION_QAM32;
+		break;
+	case QAM_128:
+		state->m_Constellation = DRX_CONSTELLATION_QAM128;
+		break;
+	default:
+		status = -EINVAL;
+		break;
+	}
+	if (status < 0)
+		goto error;
+	setParamParameters[0] = state->m_Constellation;	/* constellation     */
+	setParamParameters[1] = DRXK_QAM_I12_J17;	/* interleave mode   */
 
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
-		if (status < 0)
-			break;
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_SET_PARAM, 4, setParamParameters, 1, &cmdResult);
+	if (status < 0)
+		goto error;
 
 
-		/* STEP 3: enable the system in a mode where the ADC provides valid signal
-		   setup constellation independent registers */
+	/* STEP 3: enable the system in a mode where the ADC provides valid signal
+		setup constellation independent registers */
 #if 0
-		status = SetFrequency (channel, tunerFreqOffset));
-		if (status < 0)
-			break;
+	status = SetFrequency(channel, tunerFreqOffset));
+	if (status < 0)
+		goto error;
 #endif
-		status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
-		if (status < 0)
-			break;
-
-		/* Setup BER measurement */
-		status = SetQAMMeasurement(state, state->m_Constellation, state->param.u. qam.symbol_rate);
-		if (status < 0)
-			break;
+	status = SetFrequencyShifter(state, IntermediateFreqkHz, tunerFreqOffset, true);
+	if (status < 0)
+		goto error;
 
-		/* Reset default values */
-		status = write16(state, IQM_CF_SCALE_SH__A, IQM_CF_SCALE_SH__PRE);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_SY_TIMEOUT__A, QAM_SY_TIMEOUT__PRE);
-		if (status < 0)
-			break;
+	/* Setup BER measurement */
+	status = SetQAMMeasurement(state, state->m_Constellation, state->param.u. qam.symbol_rate);
+	if (status < 0)
+		goto error;
 
-		/* Reset default LC values */
-		status = write16(state, QAM_LC_RATE_LIMIT__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_LPF_FACTORP__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_LPF_FACTORI__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_MODE__A, 7);
-		if (status < 0)
-			break;
+	/* Reset default values */
+	status = write16(state, IQM_CF_SCALE_SH__A, IQM_CF_SCALE_SH__PRE);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_SY_TIMEOUT__A, QAM_SY_TIMEOUT__PRE);
+	if (status < 0)
+		goto error;
 
-		status = write16(state, QAM_LC_QUAL_TAB0__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB1__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB2__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB3__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB4__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB5__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB6__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB8__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB9__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB10__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB12__A, 2);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB15__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB16__A, 3);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB20__A, 4);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_LC_QUAL_TAB25__A, 4);
-		if (status < 0)
-			break;
+	/* Reset default LC values */
+	status = write16(state, QAM_LC_RATE_LIMIT__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_LPF_FACTORP__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_LPF_FACTORI__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_MODE__A, 7);
+	if (status < 0)
+		goto error;
 
-		/* Mirroring, QAM-block starting point not inverted */
-		status = write16(state, QAM_SY_SP_INV__A, QAM_SY_SP_INV_SPECTRUM_INV_DIS);
-		if (status < 0)
-			break;
+	status = write16(state, QAM_LC_QUAL_TAB0__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB1__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB2__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB3__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB4__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB5__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB6__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB8__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB9__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB10__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB12__A, 2);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB15__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB16__A, 3);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB20__A, 4);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_LC_QUAL_TAB25__A, 4);
+	if (status < 0)
+		goto error;
 
-		/* Halt SCU to enable safe non-atomic accesses */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
-		if (status < 0)
-			break;
+	/* Mirroring, QAM-block starting point not inverted */
+	status = write16(state, QAM_SY_SP_INV__A, QAM_SY_SP_INV_SPECTRUM_INV_DIS);
+	if (status < 0)
+		goto error;
 
-		/* STEP 4: constellation specific setup */
-		switch (state->param.u.qam.modulation) {
-		case QAM_16:
-			status = SetQAM16(state);
-			if (status < 0)
-				break;
-			break;
-		case QAM_32:
-			status = SetQAM32(state);
-			if (status < 0)
-				break;
-			break;
-		case QAM_AUTO:
-		case QAM_64:
-			status = SetQAM64(state);
-			if (status < 0)
-				break;
-			break;
-		case QAM_128:
-			status = SetQAM128(state);
-			if (status < 0)
-				break;
-			break;
-		case QAM_256:
-			status = SetQAM256(state);
-			if (status < 0)
-				break;
-			break;
-		default:
-			return -1;
-			break;
-		}		/* switch */
-		/* Activate SCU to enable SCU commands */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
+	/* Halt SCU to enable safe non-atomic accesses */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+	if (status < 0)
+		goto error;
 
+	/* STEP 4: constellation specific setup */
+	switch (state->param.u.qam.modulation) {
+	case QAM_16:
+		status = SetQAM16(state);
+		break;
+	case QAM_32:
+		status = SetQAM32(state);
+		break;
+	case QAM_AUTO:
+	case QAM_64:
+		status = SetQAM64(state);
+		break;
+	case QAM_128:
+		status = SetQAM128(state);
+		break;
+	case QAM_256:
+		status = SetQAM256(state);
+		break;
+	default:
+		status = -EINVAL;
+		break;
+	}
+	if (status < 0)
+		goto error;
 
-		/* Re-configure MPEG output, requires knowledge of channel bitrate */
-		/* extAttr->currentChannel.constellation = channel->constellation; */
-		/* extAttr->currentChannel.symbolrate    = channel->symbolrate; */
-		status = MPEGTSDtoSetup(state, state->m_OperationMode);
-		if (status < 0)
-			break;
+	/* Activate SCU to enable SCU commands */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
 
-		/* Start processes */
-		status = MPEGTSStart(state);
-		if (status < 0)
-			break;
-		status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-		status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
-		if (status < 0)
-			break;
+	/* Re-configure MPEG output, requires knowledge of channel bitrate */
+	/* extAttr->currentChannel.constellation = channel->constellation; */
+	/* extAttr->currentChannel.symbolrate    = channel->symbolrate; */
+	status = MPEGTSDtoSetup(state, state->m_OperationMode);
+	if (status < 0)
+		goto error;
 
-		/* STEP 5: start QAM demodulator (starts FEC, QAM and IQM HW) */
-		status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
-		if (status < 0)
-			break;
+	/* Start processes */
+	status = MPEGTSStart(state);
+	if (status < 0)
+		goto error;
+	status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
+	status = write16(state, QAM_COMM_EXEC__A, QAM_COMM_EXEC_ACTIVE);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_ACTIVE);
+	if (status < 0)
+		goto error;
 
-		/* update global DRXK data container */
-	/*?     extAttr->qamInterleaveMode = DRXK_QAM_I12_J17; */
+	/* STEP 5: start QAM demodulator (starts FEC, QAM and IQM HW) */
+	status = scu_command(state, SCU_RAM_COMMAND_STANDARD_QAM | SCU_RAM_COMMAND_CMD_DEMOD_START, 0, NULL, 1, &cmdResult);
+	if (status < 0)
+		goto error;
 
-		/* All done, all OK */
-	} while (0);
+	/* update global DRXK data container */
+/*?     extAttr->qamInterleaveMode = DRXK_QAM_I12_J17; */
 
+error:
 	if (status < 0)
-		printk(KERN_ERR "drxk: %s %d\n", __func__, status);
-
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int SetQAMStandard(struct drxk_state *state,
 			  enum OperationMode oMode)
 {
+	int status;
 #ifdef DRXK_QAM_TAPS
 #define DRXK_QAMA_TAPS_SELECT
 #include "drxk_filters.h"
 #undef DRXK_QAMA_TAPS_SELECT
-#else
-	int status;
 #endif
 
-	dprintk(1, "\n");
-	do {
-		/* added antenna switch */
-		SwitchAntennaToQAM(state);
-
-		/* Ensure correct power-up mode */
-		status = PowerUpQAM(state);
-		if (status < 0)
-			break;
-		/* Reset QAM block */
-		status = QAMResetQAM(state);
-		if (status < 0)
-			break;
-
-		/* Setup IQM */
-
-		status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
-		if (status < 0)
-			break;
-
-		/* Upload IQM Channel Filter settings by
-		   boot loader from ROM table */
-		switch (oMode) {
-		case OM_QAM_ITU_A:
-			status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
-			if (status < 0)
-				break;
-			break;
-		case OM_QAM_ITU_C:
-			status = BLDirectCmd(state, IQM_CF_TAP_RE0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
-			if (status < 0)
-				break;
-			status = BLDirectCmd(state, IQM_CF_TAP_IM0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
-			if (status < 0)
-				break;
-			break;
-		default:
-			status = -EINVAL;
-		}
-		status = status;
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_CF_OUT_ENA__A, (1 << IQM_CF_OUT_ENA_QAM__B));
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_SYMMETRIC__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_MIDTAP__A, ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_RC_STRETCH__A, 21);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_CLP_LEN__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_CLP_TH__A, 448);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_SNS_LEN__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_POW_MEAS_LEN__A, 0);
-		if (status < 0)
-			break;
-
-		status = write16(state, IQM_FS_ADJ_SEL__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_RC_ADJ_SEL__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_ADJ_SEL__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_UPD_SEL__A, 0);
-		if (status < 0)
-			break;
-
-		/* IQM Impulse Noise Processing Unit */
-		status = write16(state, IQM_CF_CLP_VAL__A, 500);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_DATATH__A, 1000);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_BYPASSDET__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_DET_LCT__A, 0);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_WND_LEN__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_CF_PKDTH__A, 1);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_INC_BYPASS__A, 1);
-		if (status < 0)
-			break;
-
-		/* turn on IQMAF. Must be done before setAgc**() */
-		status = SetIqmAf(state, true);
-		if (status < 0)
-			break;
-		status = write16(state, IQM_AF_START_LOCK__A, 0x01);
-		if (status < 0)
-			break;
-
-		/* IQM will not be reset from here, sync ADC and update/init AGC */
-		status = ADCSynchronization(state);
-		if (status < 0)
-			break;
-
-		/* Set the FSM step period */
-		status = write16(state, SCU_RAM_QAM_FSM_STEP_PERIOD__A, 2000);
-		if (status < 0)
-			break;
-
-		/* Halt SCU to enable safe non-atomic accesses */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
-		if (status < 0)
-			break;
-
-		/* No more resets of the IQM, current standard correctly set =>
-		   now AGCs can be configured. */
-
-		status = InitAGC(state, true);
-		if (status < 0)
-			break;
-		status = SetPreSaw(state, &(state->m_qamPreSawCfg));
-		if (status < 0)
-			break;
-
-		/* Configure AGC's */
-		status = SetAgcRf(state, &(state->m_qamRfAgcCfg), true);
-		if (status < 0)
-			break;
-		status = SetAgcIf(state, &(state->m_qamIfAgcCfg), true);
-		if (status < 0)
-			break;
-
-		/* Activate SCU to enable SCU commands */
-		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
-		if (status < 0)
-			break;
-	} while (0);
+	/* added antenna switch */
+	SwitchAntennaToQAM(state);
+
+	/* Ensure correct power-up mode */
+	status = PowerUpQAM(state);
+	if (status < 0)
+		goto error;
+	/* Reset QAM block */
+	status = QAMResetQAM(state);
+	if (status < 0)
+		goto error;
+
+	/* Setup IQM */
+
+	status = write16(state, IQM_COMM_EXEC__A, IQM_COMM_EXEC_B_STOP);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_AMUX__A, IQM_AF_AMUX_SIGNAL2ADC);
+	if (status < 0)
+		goto error;
+
+	/* Upload IQM Channel Filter settings by
+		boot loader from ROM table */
+	switch (oMode) {
+	case OM_QAM_ITU_A:
+		status = BLChainCmd(state, DRXK_BL_ROM_OFFSET_TAPS_ITU_A, DRXK_BLCC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		break;
+	case OM_QAM_ITU_C:
+		status = BLDirectCmd(state, IQM_CF_TAP_RE0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		if (status < 0)
+			goto error;
+		status = BLDirectCmd(state, IQM_CF_TAP_IM0__A, DRXK_BL_ROM_OFFSET_TAPS_ITU_C, DRXK_BLDC_NR_ELEMENTS_TAPS, DRXK_BLC_TIMEOUT);
+		break;
+	default:
+		status = -EINVAL;
+	}
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_CF_OUT_ENA__A, (1 << IQM_CF_OUT_ENA_QAM__B));
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_SYMMETRIC__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_MIDTAP__A, ((1 << IQM_CF_MIDTAP_RE__B) | (1 << IQM_CF_MIDTAP_IM__B)));
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_RC_STRETCH__A, 21);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_CLP_LEN__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_CLP_TH__A, 448);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_SNS_LEN__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_POW_MEAS_LEN__A, 0);
+	if (status < 0)
+		goto error;
+
+	status = write16(state, IQM_FS_ADJ_SEL__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_RC_ADJ_SEL__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_ADJ_SEL__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_UPD_SEL__A, 0);
+	if (status < 0)
+		goto error;
+
+	/* IQM Impulse Noise Processing Unit */
+	status = write16(state, IQM_CF_CLP_VAL__A, 500);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_DATATH__A, 1000);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_BYPASSDET__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_DET_LCT__A, 0);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_WND_LEN__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_CF_PKDTH__A, 1);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_INC_BYPASS__A, 1);
+	if (status < 0)
+		goto error;
+
+	/* turn on IQMAF. Must be done before setAgc**() */
+	status = SetIqmAf(state, true);
+	if (status < 0)
+		goto error;
+	status = write16(state, IQM_AF_START_LOCK__A, 0x01);
+	if (status < 0)
+		goto error;
+
+	/* IQM will not be reset from here, sync ADC and update/init AGC */
+	status = ADCSynchronization(state);
+	if (status < 0)
+		goto error;
+
+	/* Set the FSM step period */
+	status = write16(state, SCU_RAM_QAM_FSM_STEP_PERIOD__A, 2000);
+	if (status < 0)
+		goto error;
+
+	/* Halt SCU to enable safe non-atomic accesses */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_HOLD);
+	if (status < 0)
+		goto error;
+
+	/* No more resets of the IQM, current standard correctly set =>
+		now AGCs can be configured. */
+
+	status = InitAGC(state, true);
+	if (status < 0)
+		goto error;
+	status = SetPreSaw(state, &(state->m_qamPreSawCfg));
+	if (status < 0)
+		goto error;
+
+	/* Configure AGC's */
+	status = SetAgcRf(state, &(state->m_qamRfAgcCfg), true);
+	if (status < 0)
+		goto error;
+	status = SetAgcIf(state, &(state->m_qamIfAgcCfg), true);
+	if (status < 0)
+		goto error;
+
+	/* Activate SCU to enable SCU commands */
+	status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5798,48 +5779,47 @@ static int WriteGPIO(struct drxk_state *state)
 	u16 value = 0;
 
 	dprintk(1, "\n");
-	do {
-		/* stop lock indicator process */
-		status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-		if (status < 0)
-			break;
-
-		/*  Write magic word to enable pdr reg write               */
-		status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
-		if (status < 0)
-			break;
+	/* stop lock indicator process */
+	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
+	if (status < 0)
+		goto error;
 
-		if (state->m_hasSAWSW) {
-			/* write to io pad configuration register - output mode */
-			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
-			if (status < 0)
-				break;
+	/*  Write magic word to enable pdr reg write               */
+	status = write16(state, SIO_TOP_COMM_KEY__A, SIO_TOP_COMM_KEY_KEY);
+	if (status < 0)
+		goto error;
 
-			/* use corresponding bit in io data output registar */
-			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
-			if (status < 0)
-				break;
-			if (state->m_GPIO == 0)
-				value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
-			else
-				value |= 0x8000;	/* write one to 15th bit - 1st UIO */
-			/* write back to io data output register */
-			status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
-			if (status < 0)
-				break;
+	if (state->m_hasSAWSW) {
+		/* write to io pad configuration register - output mode */
+		status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+		if (status < 0)
+			goto error;
 
-		}
-		/*  Write magic word to disable pdr reg write               */
-		status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
+		/* use corresponding bit in io data output registar */
+		status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
+		if (status < 0)
+			goto error;
+		if (state->m_GPIO == 0)
+			value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
+		else
+			value |= 0x8000;	/* write one to 15th bit - 1st UIO */
+		/* write back to io data output register */
+		status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
 		if (status < 0)
-			break;
-	} while (0);
+			goto error;
+
+	}
+	/*  Write magic word to disable pdr reg write               */
+	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int SwitchAntennaToQAM(struct drxk_state *state)
 {
-	int status = -1;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
@@ -5848,12 +5828,14 @@ static int SwitchAntennaToQAM(struct drxk_state *state)
 			status = WriteGPIO(state);
 		}
 	}
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
 static int SwitchAntennaToDVBT(struct drxk_state *state)
 {
-	int status = -1;
+	int status = -EINVAL;
 
 	dprintk(1, "\n");
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
@@ -5862,6 +5844,8 @@ static int SwitchAntennaToDVBT(struct drxk_state *state)
 			status = WriteGPIO(state);
 		}
 	}
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 	return status;
 }
 
@@ -5877,34 +5861,30 @@ static int PowerDownDevice(struct drxk_state *state)
 	int status;
 
 	dprintk(1, "\n");
-	do {
-		if (state->m_bPDownOpenBridge) {
-			/* Open I2C bridge before power down of DRXK */
-			status = ConfigureI2CBridge(state, true);
-			if (status < 0)
-				break;
-		}
-		/* driver 0.9.0 */
-		status = DVBTEnableOFDMTokenRing(state, false);
+	if (state->m_bPDownOpenBridge) {
+		/* Open I2C bridge before power down of DRXK */
+		status = ConfigureI2CBridge(state, true);
 		if (status < 0)
-			break;
-
-		status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_CLOCK);
-		if (status < 0)
-			break;
-		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
-		if (status < 0)
-			break;
-		state->m_HICfgCtrl |= SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
-		status = HI_CfgCommand(state);
-		if (status < 0)
-			break;
-	} while (0);
+			goto error;
+	}
+	/* driver 0.9.0 */
+	status = DVBTEnableOFDMTokenRing(state, false);
+	if (status < 0)
+		goto error;
 
+	status = write16(state, SIO_CC_PWD_MODE__A, SIO_CC_PWD_MODE_LEVEL_CLOCK);
+	if (status < 0)
+		goto error;
+	status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+	if (status < 0)
+		goto error;
+	state->m_HICfgCtrl |= SIO_HI_RA_RAM_PAR_5_CFG_SLEEP_ZZZ;
+	status = HI_CfgCommand(state);
+error:
 	if (status < 0)
-		return -1;
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
-	return 0;
+	return status;
 }
 
 static int load_microcode(struct drxk_state *state, const char *mc_name)
@@ -5929,188 +5909,189 @@ static int load_microcode(struct drxk_state *state, const char *mc_name)
 
 static int init_drxk(struct drxk_state *state)
 {
-	int status;
+	int status = 0;
 	enum DRXPowerMode powerMode = DRXK_POWER_DOWN_OFDM;
 	u16 driverVersion;
 
 	dprintk(1, "\n");
 	if ((state->m_DrxkState == DRXK_UNINITIALIZED)) {
-		do {
-			status = PowerUpDevice(state);
-			if (status < 0)
-				break;
-			status = DRXX_Open(state);
-			if (status < 0)
-				break;
-			/* Soft reset of OFDM-, sys- and osc-clockdomain */
-			status = write16(state, SIO_CC_SOFT_RST__A, SIO_CC_SOFT_RST_OFDM__M | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M);
-			if (status < 0)
-				break;
-			status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
-			if (status < 0)
-				break;
-			/* TODO is this needed, if yes how much delay in worst case scenario */
-			msleep(1);
-			state->m_DRXK_A3_PATCH_CODE = true;
-			status = GetDeviceCapabilities(state);
-			if (status < 0)
-				break;
+		status = PowerUpDevice(state);
+		if (status < 0)
+			goto error;
+		status = DRXX_Open(state);
+		if (status < 0)
+			goto error;
+		/* Soft reset of OFDM-, sys- and osc-clockdomain */
+		status = write16(state, SIO_CC_SOFT_RST__A, SIO_CC_SOFT_RST_OFDM__M | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M);
+		if (status < 0)
+			goto error;
+		status = write16(state, SIO_CC_UPDATE__A, SIO_CC_UPDATE_KEY);
+		if (status < 0)
+			goto error;
+		/* TODO is this needed, if yes how much delay in worst case scenario */
+		msleep(1);
+		state->m_DRXK_A3_PATCH_CODE = true;
+		status = GetDeviceCapabilities(state);
+		if (status < 0)
+			goto error;
 
-			/* Bridge delay, uses oscilator clock */
-			/* Delay = (delay (nano seconds) * oscclk (kHz))/ 1000 */
-			/* SDA brdige delay */
+		/* Bridge delay, uses oscilator clock */
+		/* Delay = (delay (nano seconds) * oscclk (kHz))/ 1000 */
+		/* SDA brdige delay */
+		state->m_HICfgBridgeDelay =
+			(u16) ((state->m_oscClockFreq / 1000) *
+				HI_I2C_BRIDGE_DELAY) / 1000;
+		/* Clipping */
+		if (state->m_HICfgBridgeDelay >
+			SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
 			state->m_HICfgBridgeDelay =
-			    (u16) ((state->m_oscClockFreq / 1000) *
-				   HI_I2C_BRIDGE_DELAY) / 1000;
-			/* Clipping */
-			if (state->m_HICfgBridgeDelay >
-			    SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M) {
-				state->m_HICfgBridgeDelay =
-				    SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M;
-			}
-			/* SCL bridge delay, same as SDA for now */
-			state->m_HICfgBridgeDelay +=
-			    state->m_HICfgBridgeDelay <<
-			    SIO_HI_RA_RAM_PAR_3_CFG_DBL_SCL__B;
+				SIO_HI_RA_RAM_PAR_3_CFG_DBL_SDA__M;
+		}
+		/* SCL bridge delay, same as SDA for now */
+		state->m_HICfgBridgeDelay +=
+			state->m_HICfgBridgeDelay <<
+			SIO_HI_RA_RAM_PAR_3_CFG_DBL_SCL__B;
 
-			status = InitHI(state);
-			if (status < 0)
-				break;
-			/* disable various processes */
+		status = InitHI(state);
+		if (status < 0)
+			goto error;
+		/* disable various processes */
 #if NOA1ROM
-			if (!(state->m_DRXK_A1_ROM_CODE)
-			    && !(state->m_DRXK_A2_ROM_CODE))
+		if (!(state->m_DRXK_A1_ROM_CODE)
+			&& !(state->m_DRXK_A2_ROM_CODE))
 #endif
-			{
-				status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
-				if (status < 0)
-					break;
-			}
-
-			/* disable MPEG port */
-			status = MPEGTSDisable(state);
+		{
+			status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
 			if (status < 0)
-				break;
+				goto error;
+		}
 
-			/* Stop AUD and SCU */
-			status = write16(state, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
-			if (status < 0)
-				break;
-			status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_STOP);
-			if (status < 0)
-				break;
+		/* disable MPEG port */
+		status = MPEGTSDisable(state);
+		if (status < 0)
+			goto error;
 
-			/* enable token-ring bus through OFDM block for possible ucode upload */
-			status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
-			if (status < 0)
-				break;
+		/* Stop AUD and SCU */
+		status = write16(state, AUD_COMM_EXEC__A, AUD_COMM_EXEC_STOP);
+		if (status < 0)
+			goto error;
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_STOP);
+		if (status < 0)
+			goto error;
 
-			/* include boot loader section */
-			status = write16(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
-			if (status < 0)
-				break;
-			status = BLChainCmd(state, 0, 6, 100);
-			if (status < 0)
-				break;
+		/* enable token-ring bus through OFDM block for possible ucode upload */
+		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_ON);
+		if (status < 0)
+			goto error;
 
-			if (!state->microcode_name)
-				load_microcode(state, "drxk_a3.mc");
-			else
-				load_microcode(state, state->microcode_name);
+		/* include boot loader section */
+		status = write16(state, SIO_BL_COMM_EXEC__A, SIO_BL_COMM_EXEC_ACTIVE);
+		if (status < 0)
+			goto error;
+		status = BLChainCmd(state, 0, 6, 100);
+		if (status < 0)
+			goto error;
 
-			/* disable token-ring bus through OFDM block for possible ucode upload */
-			status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
-			if (status < 0)
-				break;
+		if (!state->microcode_name)
+			load_microcode(state, "drxk_a3.mc");
+		else
+			load_microcode(state, state->microcode_name);
 
-			/* Run SCU for a little while to initialize microcode version numbers */
-			status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
-			if (status < 0)
-				break;
-			status = DRXX_Open(state);
-			if (status < 0)
-				break;
-			/* added for test */
-			msleep(30);
+		/* disable token-ring bus through OFDM block for possible ucode upload */
+		status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
+		if (status < 0)
+			goto error;
 
-			powerMode = DRXK_POWER_DOWN_OFDM;
-			status = CtrlPowerMode(state, &powerMode);
-			if (status < 0)
-				break;
+		/* Run SCU for a little while to initialize microcode version numbers */
+		status = write16(state, SCU_COMM_EXEC__A, SCU_COMM_EXEC_ACTIVE);
+		if (status < 0)
+			goto error;
+		status = DRXX_Open(state);
+		if (status < 0)
+			goto error;
+		/* added for test */
+		msleep(30);
 
-			/* Stamp driver version number in SCU data RAM in BCD code
-			   Done to enable field application engineers to retreive drxdriver version
-			   via I2C from SCU RAM.
-			   Not using SCU command interface for SCU register access since no
-			   microcode may be present.
-			 */
-			driverVersion =
-			    (((DRXK_VERSION_MAJOR / 100) % 10) << 12) +
-			    (((DRXK_VERSION_MAJOR / 10) % 10) << 8) +
-			    ((DRXK_VERSION_MAJOR % 10) << 4) +
-			    (DRXK_VERSION_MINOR % 10);
-			status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driverVersion);
-			if (status < 0)
-				break;
-			driverVersion =
-			    (((DRXK_VERSION_PATCH / 1000) % 10) << 12) +
-			    (((DRXK_VERSION_PATCH / 100) % 10) << 8) +
-			    (((DRXK_VERSION_PATCH / 10) % 10) << 4) +
-			    (DRXK_VERSION_PATCH % 10);
-			status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driverVersion);
-			if (status < 0)
-				break;
+		powerMode = DRXK_POWER_DOWN_OFDM;
+		status = CtrlPowerMode(state, &powerMode);
+		if (status < 0)
+			goto error;
 
-			printk(KERN_INFO "DRXK driver version %d.%d.%d\n",
-			       DRXK_VERSION_MAJOR, DRXK_VERSION_MINOR,
-			       DRXK_VERSION_PATCH);
+		/* Stamp driver version number in SCU data RAM in BCD code
+			Done to enable field application engineers to retreive drxdriver version
+			via I2C from SCU RAM.
+			Not using SCU command interface for SCU register access since no
+			microcode may be present.
+			*/
+		driverVersion =
+			(((DRXK_VERSION_MAJOR / 100) % 10) << 12) +
+			(((DRXK_VERSION_MAJOR / 10) % 10) << 8) +
+			((DRXK_VERSION_MAJOR % 10) << 4) +
+			(DRXK_VERSION_MINOR % 10);
+		status = write16(state, SCU_RAM_DRIVER_VER_HI__A, driverVersion);
+		if (status < 0)
+			goto error;
+		driverVersion =
+			(((DRXK_VERSION_PATCH / 1000) % 10) << 12) +
+			(((DRXK_VERSION_PATCH / 100) % 10) << 8) +
+			(((DRXK_VERSION_PATCH / 10) % 10) << 4) +
+			(DRXK_VERSION_PATCH % 10);
+		status = write16(state, SCU_RAM_DRIVER_VER_LO__A, driverVersion);
+		if (status < 0)
+			goto error;
 
-			/* Dirty fix of default values for ROM/PATCH microcode
-			   Dirty because this fix makes it impossible to setup suitable values
-			   before calling DRX_Open. This solution requires changes to RF AGC speed
-			   to be done via the CTRL function after calling DRX_Open */
+		printk(KERN_INFO "DRXK driver version %d.%d.%d\n",
+			DRXK_VERSION_MAJOR, DRXK_VERSION_MINOR,
+			DRXK_VERSION_PATCH);
 
-			/* m_dvbtRfAgcCfg.speed = 3; */
+		/* Dirty fix of default values for ROM/PATCH microcode
+			Dirty because this fix makes it impossible to setup suitable values
+			before calling DRX_Open. This solution requires changes to RF AGC speed
+			to be done via the CTRL function after calling DRX_Open */
 
-			/* Reset driver debug flags to 0 */
-			status = write16(state, SCU_RAM_DRIVER_DEBUG__A, 0);
-			if (status < 0)
-				break;
-			/* driver 0.9.0 */
-			/* Setup FEC OC:
-			   NOTE: No more full FEC resets allowed afterwards!! */
-			status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
-			if (status < 0)
-				break;
-			/* MPEGTS functions are still the same */
-			status = MPEGTSDtoInit(state);
-			if (status < 0)
-				break;
-			status = MPEGTSStop(state);
-			if (status < 0)
-				break;
-			status = MPEGTSConfigurePolarity(state);
-			if (status < 0)
-				break;
-			status = MPEGTSConfigurePins(state, state->m_enableMPEGOutput);
-			if (status < 0)
-				break;
-			/* added: configure GPIO */
-			status = WriteGPIO(state);
-			if (status < 0)
-				break;
+		/* m_dvbtRfAgcCfg.speed = 3; */
+
+		/* Reset driver debug flags to 0 */
+		status = write16(state, SCU_RAM_DRIVER_DEBUG__A, 0);
+		if (status < 0)
+			goto error;
+		/* driver 0.9.0 */
+		/* Setup FEC OC:
+			NOTE: No more full FEC resets allowed afterwards!! */
+		status = write16(state, FEC_COMM_EXEC__A, FEC_COMM_EXEC_STOP);
+		if (status < 0)
+			goto error;
+		/* MPEGTS functions are still the same */
+		status = MPEGTSDtoInit(state);
+		if (status < 0)
+			goto error;
+		status = MPEGTSStop(state);
+		if (status < 0)
+			goto error;
+		status = MPEGTSConfigurePolarity(state);
+		if (status < 0)
+			goto error;
+		status = MPEGTSConfigurePins(state, state->m_enableMPEGOutput);
+		if (status < 0)
+			goto error;
+		/* added: configure GPIO */
+		status = WriteGPIO(state);
+		if (status < 0)
+			goto error;
 
+		state->m_DrxkState = DRXK_STOPPED;
+
+		if (state->m_bPowerDown) {
+			status = PowerDownDevice(state);
+			if (status < 0)
+				goto error;
+			state->m_DrxkState = DRXK_POWERED_DOWN;
+		} else
 			state->m_DrxkState = DRXK_STOPPED;
-
-			if (state->m_bPowerDown) {
-				status = PowerDownDevice(state);
-				if (status < 0)
-					break;
-				state->m_DrxkState = DRXK_POWERED_DOWN;
-			} else
-				state->m_DrxkState = DRXK_STOPPED;
-		} while (0);
 	}
+error:
+	if (status < 0)
+		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
 
 	return 0;
 }
@@ -6210,7 +6191,7 @@ static int drxk_read_signal_strength(struct dvb_frontend *fe,
 				     u16 *strength)
 {
 	struct drxk_state *state = fe->demodulator_priv;
-	u32 val;
+	u32 val = 0;
 
 	dprintk(1, "\n");
 	ReadIFAgc(state, &val);
-- 
1.7.1


