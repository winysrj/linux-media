Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab2AEBBM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Jan 2012 20:01:12 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0511Chh002517
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 4 Jan 2012 20:01:12 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 47/47] [media] drxk: Add support for parallel mode and prints mpeg mode
Date: Wed,  4 Jan 2012 23:00:58 -0200
Message-Id: <1325725258-27934-48-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
References: <1325725258-27934-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While the driver has support for both serial and parallel mode,
There's was way to select serial mode via configuration. Add
a config option for that, while keeping the default in serial mode.

Also, at debug mode, it will now print a message when mpeg is
enabled/disabled, and showing if parallel or serial mode were
selected, helping developers to double-check if the DRX-K is at
the right mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk.h      |    3 +++
 drivers/media/dvb/frontends/drxk_hard.c |   14 ++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index e6d42e2..870432f 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -8,6 +8,8 @@
  * struct drxk_config - Configure the initial parameters for DRX-K
  *
  * adr:			I2C Address of the DRX-K
+ * parallel_ts:		true means that the device uses parallel TS,
+ * 			Serial otherwise.
  * single_master:	Device is on the single master mode
  * no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
  * antenna_gpio:	GPIO bit used to control the antenna
@@ -22,6 +24,7 @@ struct drxk_config {
 	u8	adr;
 	bool	single_master;
 	bool	no_i2c_bridge;
+	bool	parallel_ts;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 817d3ec..c8213f6 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -660,7 +660,6 @@ static int init_state(struct drxk_state *state)
 	/* io_pad_cfg_mode output mode is drive always */
 	/* io_pad_cfg_drive is set to power 2 (23 mA) */
 	u32 ulGPIOCfg = 0x0113;
-	u32 ulSerialMode = 1;
 	u32 ulInvertTSClock = 0;
 	u32 ulTSDataStrength = DRXK_MPEG_SERIAL_OUTPUT_PIN_DRIVE_STRENGTH;
 	u32 ulTSClockkStrength = DRXK_MPEG_OUTPUT_CLK_DRIVE_STRENGTH;
@@ -811,8 +810,6 @@ static int init_state(struct drxk_state *state)
 	/* MPEG output configuration */
 	state->m_enableMPEGOutput = true;	/* If TRUE; enable MPEG ouput */
 	state->m_insertRSByte = false;	/* If TRUE; insert RS byte */
-	state->m_enableParallel = true;	/* If TRUE;
-					   parallel out otherwise serial */
 	state->m_invertDATA = false;	/* If TRUE; invert DATA signals */
 	state->m_invertERR = false;	/* If TRUE; invert ERR signal */
 	state->m_invertSTR = false;	/* If TRUE; invert STR signals */
@@ -857,8 +854,6 @@ static int init_state(struct drxk_state *state)
 	state->m_bPowerDown = false;
 	state->m_currentPowerMode = DRX_POWER_DOWN;
 
-	state->m_enableParallel = (ulSerialMode == 0);
-
 	state->m_rfmirror = (ulRfMirror == 0);
 	state->m_IfAgcPol = false;
 	return 0;
@@ -1195,7 +1190,9 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	u16 sioPdrMclkCfg = 0;
 	u16 sioPdrMdxCfg = 0;
 
-	dprintk(1, "\n");
+	dprintk(1, ": mpeg %s, %s mode\n",
+		mpegEnable ? "enable" : "disable",
+		state->m_enableParallel ? "parallel" : "serial");
 
 	/* stop lock indicator process */
 	status = write16(state, SCU_RAM_GPIO__A, SCU_RAM_GPIO_HW_LOCK_IND_DISABLE);
@@ -6432,6 +6429,11 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->antenna_dvbt = config->antenna_dvbt;
 	state->m_ChunkSize = config->chunk_size;
 
+	if (config->parallel_ts)
+		state->m_enableParallel = true;
+	else
+		state->m_enableParallel = false;
+
 	/* NOTE: as more UIO bits will be used, add them to the mask */
 	state->UIO_mask = config->antenna_gpio;
 
-- 
1.7.7.5

