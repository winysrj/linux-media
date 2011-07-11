Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:36577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756562Ab1GKCAA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 22:00:00 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B200VM018186
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 22:00:00 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKg030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:59 -0400
Date: Sun, 10 Jul 2011 22:59:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 17/21] [media] drxk: Improves the UIO handling
Message-ID: <20110710225903.1046ca38@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The driver is too limited: it assumes that UIO is used only for
controlling the antenna, and that only UIO-1 is in usage. However,
from Terratec H7 driver [1], 3 UIO's can be used. In fact, it seems
that H7 needs to use all 3. So, make the code generic enough to handle
the most complex scenario. For now, only antena GPIO can be specified,
but is is easier now to add the other GPIO/UIO needs.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 67589b6..a756e45 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -10,18 +10,21 @@
  * adr:			I2C Address of the DRX-K
  * single_master:	Device is on the single master mode
  * no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
- * antenna_uses_gpio:	Use GPIO to control the antenna
- * antenna_dvbc:	GPIO for changing antenna to DVB-C
- * antenna_dvbt:	GPIO for changing antenna to DVB-T
+ * antenna_gpio:	GPIO bit used to control the antenna
+ * antenna_dvbt:	GPIO bit for changing antenna to DVB-C. A value of 1
+ *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
  * microcode_name:	Name of the firmware file with the microcode
+ *
+ * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
+ * UIO-3.
  */
 struct drxk_config {
 	u8	adr;
 	bool	single_master;
 	bool	no_i2c_bridge;
 
-	bool	antenna_uses_gpio;
-	u16	antenna_dvbc, antenna_dvbt;
+	bool	antenna_dvbt;
+	u16	antenna_gpio;
 
 	const char *microcode_name;
 };
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 0d288a7..aaef8e3 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -856,7 +856,6 @@ static int init_state(struct drxk_state *state)
 	state->m_agcFastClipCtrlDelay = 0;
 
 	state->m_GPIOCfg = (ulGPIOCfg);
-	state->m_GPIO = (ulGPIO == 0 ? 0 : 1);
 
 	state->m_bPowerDown = false;
 	state->m_currentPowerMode = DRX_POWER_DOWN;
@@ -5795,24 +5794,63 @@ static int WriteGPIO(struct drxk_state *state)
 		goto error;
 
 	if (state->m_hasSAWSW) {
-		/* write to io pad configuration register - output mode */
-		status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
-		if (status < 0)
-			goto error;
+		if (state->UIO_mask & 0x0001) { /* UIO-1 */
+			/* write to io pad configuration register - output mode */
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			if (status < 0)
+				goto error;
 
-		/* use corresponding bit in io data output registar */
-		status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
-		if (status < 0)
-			goto error;
-		if (state->m_GPIO == 0)
-			value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
-		else
-			value |= 0x8000;	/* write one to 15th bit - 1st UIO */
-		/* write back to io data output register */
-		status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
-		if (status < 0)
-			goto error;
+			/* use corresponding bit in io data output registar */
+			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
+			if (status < 0)
+				goto error;
+			if ((state->m_GPIO & 0x0001) == 0)
+				value &= 0x7FFF;	/* write zero to 15th bit - 1st UIO */
+			else
+				value |= 0x8000;	/* write one to 15th bit - 1st UIO */
+			/* write back to io data output register */
+			status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
+			if (status < 0)
+				goto error;
+		}
+		if (state->UIO_mask & 0x0002) { /* UIO-2 */
+			/* write to io pad configuration register - output mode */
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			if (status < 0)
+				goto error;
 
+			/* use corresponding bit in io data output registar */
+			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
+			if (status < 0)
+				goto error;
+			if ((state->m_GPIO & 0x0002) == 0)
+				value &= 0xBFFF;	/* write zero to 14th bit - 2st UIO */
+			else
+				value |= 0x4000;	/* write one to 14th bit - 2st UIO */
+			/* write back to io data output register */
+			status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
+			if (status < 0)
+				goto error;
+		}
+		if (state->UIO_mask & 0x0004) { /* UIO-3 */
+			/* write to io pad configuration register - output mode */
+			status = write16(state, SIO_PDR_SMA_TX_CFG__A, state->m_GPIOCfg);
+			if (status < 0)
+				goto error;
+
+			/* use corresponding bit in io data output registar */
+			status = read16(state, SIO_PDR_UIO_OUT_LO__A, &value);
+			if (status < 0)
+				goto error;
+			if ((state->m_GPIO & 0x0004) == 0)
+				value &= 0xFFFB;            /* write zero to 2nd bit - 3rd UIO */
+			else
+				value |= 0x0004;            /* write one to 2nd bit - 3rd UIO */
+			/* write back to io data output register */
+			status = write16(state, SIO_PDR_UIO_OUT_LO__A, value);
+			if (status < 0)
+				goto error;
+		}
 	}
 	/*  Write magic word to disable pdr reg write               */
 	status = write16(state, SIO_TOP_COMM_KEY__A, 0x0000);
@@ -5825,14 +5863,22 @@ error:
 static int SwitchAntennaToQAM(struct drxk_state *state)
 {
 	int status = 0;
+	bool gpio_state;
 
 	dprintk(1, "\n");
 
-	if (state->m_AntennaSwitchDVBTDVBC != 0) {
-		if (state->m_GPIO != state->m_AntennaDVBC) {
-			state->m_GPIO = state->m_AntennaDVBC;
-			status = WriteGPIO(state);
-		}
+	if (!state->antenna_gpio)
+		return 0;
+
+	gpio_state = state->m_GPIO & state->antenna_gpio;
+
+	if (state->antenna_dvbt ^ gpio_state) {
+		/* Antenna is on DVB-T mode. Switch */
+		if (state->antenna_dvbt)
+			state->m_GPIO &= ~state->antenna_gpio;
+		else
+			state->m_GPIO |= state->antenna_gpio;
+		status = WriteGPIO(state);
 	}
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -5842,13 +5888,22 @@ static int SwitchAntennaToQAM(struct drxk_state *state)
 static int SwitchAntennaToDVBT(struct drxk_state *state)
 {
 	int status = 0;
+	bool gpio_state;
 
 	dprintk(1, "\n");
-	if (state->m_AntennaSwitchDVBTDVBC != 0) {
-		if (state->m_GPIO != state->m_AntennaDVBT) {
-			state->m_GPIO = state->m_AntennaDVBT;
-			status = WriteGPIO(state);
-		}
+
+	if (!state->antenna_gpio)
+		return 0;
+
+	gpio_state = state->m_GPIO & state->antenna_gpio;
+
+	if (!(state->antenna_dvbt ^ gpio_state)) {
+		/* Antenna is on DVB-C mode. Switch */
+		if (state->antenna_dvbt)
+			state->m_GPIO |= state->antenna_gpio;
+		else
+			state->m_GPIO &= ~state->antenna_gpio;
+		status = WriteGPIO(state);
 	}
 	if (status < 0)
 		printk(KERN_ERR "drxk: Error %d on %s\n", status, __func__);
@@ -6350,9 +6405,17 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->single_master = config->single_master;
 	state->microcode_name = config->microcode_name;
 	state->no_i2c_bridge = config->no_i2c_bridge;
-	state->m_AntennaSwitchDVBTDVBC = config->antenna_uses_gpio;
-	state->m_AntennaDVBC = config->antenna_dvbc;
-	state->m_AntennaDVBT = config->antenna_dvbt;
+	state->antenna_gpio = config->antenna_gpio;
+	state->antenna_dvbt = config->antenna_dvbt;
+
+	/* NOTE: as more UIO bits will be used, add them to the mask */
+	state->UIO_mask = config->antenna_gpio;
+
+	/* Default gpio to DVB-C */
+	if (!state->antenna_dvbt && state->antenna_gpio)
+		state->m_GPIO |= state->antenna_gpio;
+	else
+		state->m_GPIO &= ~state->antenna_gpio;
 
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 8b29dc8..a20a19d 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -323,17 +323,19 @@ struct drxk_state {
 
 	enum DRXPowerMode m_currentPowerMode;
 
-	/* Configurable parameters at the driver */
+	/*
+	 * Configurable parameters at the driver. They stores the values found
+	 * at struct drxk_config.
+	 */
 
-	bool              m_AntennaSwitchDVBTDVBC;
-	u16               m_AntennaDVBC;
-	u16               m_AntennaDVBT;
+	u16	UIO_mask;	/* Bits used by UIO */
 
-	u32 single_master : 1;		/* Use single master i2c mode */
-	u32 no_i2c_bridge : 1;		/* Tuner is not on port 1, don't use I2C bridge */
+	bool	single_master;
+	bool	no_i2c_bridge;
+	bool	antenna_dvbt;
+	u16	antenna_gpio;
 
 	const char *microcode_name;
-
 };
 
 #define NEVER_LOCK 0
-- 
1.7.1


