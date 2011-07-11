Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:49027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756664Ab1GKB74 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:56 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xuSh023478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:56 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKe030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:55 -0400
Date: Sun, 10 Jul 2011 22:59:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 15/21] [media] drxk: Fix the antenna switch logic
Message-ID: <20110710225901.446e2f7d@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Terratec H5 doesn't require to switch mode, but generates
an error due to this logic. Also, GPIO's are board-dependent.

So, add it at the board config struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 9c99f31..67589b6 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -4,10 +4,25 @@
 #include <linux/types.h>
 #include <linux/i2c.h>
 
+/**
+ * struct drxk_config - Configure the initial parameters for DRX-K
+ *
+ * adr:			I2C Address of the DRX-K
+ * single_master:	Device is on the single master mode
+ * no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
+ * antenna_uses_gpio:	Use GPIO to control the antenna
+ * antenna_dvbc:	GPIO for changing antenna to DVB-C
+ * antenna_dvbt:	GPIO for changing antenna to DVB-T
+ * microcode_name:	Name of the firmware file with the microcode
+ */
 struct drxk_config {
-	u8 adr;
-	u32 single_master : 1;
-	u32 no_i2c_bridge : 1;
+	u8	adr;
+	bool	single_master;
+	bool	no_i2c_bridge;
+
+	bool	antenna_uses_gpio;
+	u16	antenna_dvbc, antenna_dvbt;
+
 	const char *microcode_name;
 };
 
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 1d29ed2..91f3296 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -618,6 +618,10 @@ error:
 
 static int init_state(struct drxk_state *state)
 {
+	/*
+	 * FIXME: most (all?) of the values bellow should be moved into
+	 * struct drxk_config, as they are probably board-specific
+	 */
 	u32 ulVSBIfAgcMode = DRXK_AGC_CTRL_AUTO;
 	u32 ulVSBIfAgcOutputLevel = 0;
 	u32 ulVSBIfAgcMinLevel = 0;
@@ -672,10 +676,6 @@ static int init_state(struct drxk_state *state)
 	u32 ulRfMirror = 1;
 	u32 ulPowerDown = 0;
 
-	u32 ulAntennaDVBT = 1;
-	u32 ulAntennaDVBC = 0;
-	u32 ulAntennaSwitchDVBTDVBC = 0;
-
 	dprintk(1, "\n");
 
 	state->m_hasLNA = false;
@@ -858,11 +858,6 @@ static int init_state(struct drxk_state *state)
 	state->m_GPIOCfg = (ulGPIOCfg);
 	state->m_GPIO = (ulGPIO == 0 ? 0 : 1);
 
-	state->m_AntennaDVBT = (ulAntennaDVBT == 0 ? 0 : 1);
-	state->m_AntennaDVBC = (ulAntennaDVBC == 0 ? 0 : 1);
-	state->m_AntennaSwitchDVBTDVBC =
-	    (ulAntennaSwitchDVBTDVBC == 0 ? 0 : 1);
-
 	state->m_bPowerDown = false;
 	state->m_currentPowerMode = DRX_POWER_DOWN;
 
@@ -5819,9 +5814,10 @@ error:
 
 static int SwitchAntennaToQAM(struct drxk_state *state)
 {
-	int status = -EINVAL;
+	int status = 0;
 
 	dprintk(1, "\n");
+
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
 		if (state->m_GPIO != state->m_AntennaDVBC) {
 			state->m_GPIO = state->m_AntennaDVBC;
@@ -5835,7 +5831,7 @@ static int SwitchAntennaToQAM(struct drxk_state *state)
 
 static int SwitchAntennaToDVBT(struct drxk_state *state)
 {
-	int status = -EINVAL;
+	int status = 0;
 
 	dprintk(1, "\n");
 	if (state->m_AntennaSwitchDVBTDVBC != 0) {
@@ -6344,6 +6340,9 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->single_master = config->single_master;
 	state->microcode_name = config->microcode_name;
 	state->no_i2c_bridge = config->no_i2c_bridge;
+	state->m_AntennaSwitchDVBTDVBC = config->antenna_uses_gpio;
+	state->m_AntennaDVBC = config->antenna_dvbc;
+	state->m_AntennaDVBT = config->antenna_dvbt;
 
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index b042755..8b29dc8 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -321,16 +321,17 @@ struct drxk_state {
 	u8                m_deviceSpin;
 	u32               m_iqmRcRate;
 
-	u16               m_AntennaDVBC;
-	u16               m_AntennaDVBT;
-	u16               m_AntennaSwitchDVBTDVBC;
-
 	enum DRXPowerMode m_currentPowerMode;
 
 	/* Configurable parameters at the driver */
 
+	bool              m_AntennaSwitchDVBTDVBC;
+	u16               m_AntennaDVBC;
+	u16               m_AntennaDVBT;
+
 	u32 single_master : 1;		/* Use single master i2c mode */
 	u32 no_i2c_bridge : 1;		/* Tuner is not on port 1, don't use I2C bridge */
+
 	const char *microcode_name;
 
 };
-- 
1.7.1


