Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4jCI017793
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 23/35] [media] drxk: Allow setting it on dynamic_clock mode
Date: Sat, 21 Jan 2012 14:04:25 -0200
Message-Id: <1327161877-16784-24-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-23-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is used on az6007.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/drxk.h      |   17 ++++++++++-------
 drivers/media/dvb/frontends/drxk_hard.c |   14 +++++++++-----
 2 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index 0209818..6b0fd2c 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -7,15 +7,17 @@
 /**
  * struct drxk_config - Configure the initial parameters for DRX-K
  *
- * adr:			I2C Address of the DRX-K
- * parallel_ts:		true means that the device uses parallel TS,
+ * @adr:		I2C Address of the DRX-K
+ * @parallel_ts:	True means that the device uses parallel TS,
  * 			Serial otherwise.
- * single_master:	Device is on the single master mode
- * no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
- * antenna_gpio:	GPIO bit used to control the antenna
- * antenna_dvbt:	GPIO bit for changing antenna to DVB-C. A value of 1
+ * @dynamic_clk:	True means that the clock will be dynamically
+ *			adjusted. Static clock otherwise.
+ * @single_master:	Device is on the single master mode
+ * @no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
+ * @antenna_gpio:	GPIO bit used to control the antenna
+ * @antenna_dvbt:	GPIO bit for changing antenna to DVB-C. A value of 1
  *			means that 1=DVBC, 0 = DVBT. Zero means the opposite.
- * microcode_name:	Name of the firmware file with the microcode
+ * @microcode_name:	Name of the firmware file with the microcode
  *
  * On the *_gpio vars, bit 0 is UIO-1, bit 1 is UIO-2 and bit 2 is
  * UIO-3.
@@ -25,6 +27,7 @@ struct drxk_config {
 	bool	single_master;
 	bool	no_i2c_bridge;
 	bool	parallel_ts;
+	bool	dynamic_clk;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 4b99255..6570396 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -650,9 +650,6 @@ static int init_state(struct drxk_state *state)
 	u32 ulQual83 = DEFAULT_MER_83;
 	u32 ulQual93 = DEFAULT_MER_93;
 
-	u32 ulDVBTStaticTSClock = 1;
-	u32 ulDVBCStaticTSClock = 1;
-
 	u32 ulMpegLockTimeOut = DEFAULT_DRXK_MPEG_LOCK_TIMEOUT;
 	u32 ulDemodLockTimeOut = DEFAULT_DRXK_DEMOD_LOCK_TIMEOUT;
 
@@ -815,8 +812,7 @@ static int init_state(struct drxk_state *state)
 	state->m_invertSTR = false;	/* If TRUE; invert STR signals */
 	state->m_invertVAL = false;	/* If TRUE; invert VAL signals */
 	state->m_invertCLK = (ulInvertTSClock != 0);	/* If TRUE; invert CLK signals */
-	state->m_DVBTStaticCLK = (ulDVBTStaticTSClock != 0);
-	state->m_DVBCStaticCLK = (ulDVBCStaticTSClock != 0);
+
 	/* If TRUE; static MPEG clockrate will be used;
 	   otherwise clockrate will adapt to the bitrate of the TS */
 
@@ -6390,6 +6386,14 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->antenna_dvbt = config->antenna_dvbt;
 	state->m_ChunkSize = config->chunk_size;
 
+	if (config->dynamic_clk) {
+		state->m_DVBTStaticCLK = 0;
+		state->m_DVBCStaticCLK = 0;
+	} else {
+		state->m_DVBTStaticCLK = 1;
+		state->m_DVBCStaticCLK = 1;
+	}
+
 	if (config->parallel_ts)
 		state->m_enableParallel = true;
 	else
-- 
1.7.8

