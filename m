Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab2AUQEp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:45 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4jm1023695
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 26/35] [media] drxk: Allow enabling MERR/MVAL cfg
Date: Sat, 21 Jan 2012 14:04:28 -0200
Message-Id: <1327161877-16784-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-26-git-send-email-mchehab@redhat.com>
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
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Those two settings are different when used with az6007. Add
a config option to enable it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c      |    1 +
 drivers/media/dvb/frontends/drxk.h      |    2 ++
 drivers/media/dvb/frontends/drxk_hard.c |   11 +++++++++--
 drivers/media/dvb/frontends/drxk_hard.h |    1 +
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index bf8d201..81fdc90 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -67,6 +67,7 @@ static struct drxk_config terratec_h7_drxk = {
 	.parallel_ts = true,
 	.dynamic_clk = true,
 	.single_master = true,
+	.enable_merr_cfg = true,
 	.no_i2c_bridge = false,
 	.chunk_size = 64,
 	.mpeg_out_clk_strength = 0x02,
diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index ca921c7..9d64e4f 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -12,6 +12,7 @@
  * 			Serial otherwise.
  * @dynamic_clk:	True means that the clock will be dynamically
  *			adjusted. Static clock otherwise.
+ * @enable_merr_cfg:	Enable SIO_PDR_PERR_CFG/SIO_PDR_MVAL_CFG.
  * @single_master:	Device is on the single master mode
  * @no_i2c_bridge:	Don't switch the I2C bridge to talk with tuner
  * @antenna_gpio:	GPIO bit used to control the antenna
@@ -29,6 +30,7 @@ struct drxk_config {
 	bool	no_i2c_bridge;
 	bool	parallel_ts;
 	bool	dynamic_clk;
+	bool	enable_merr_cfg;
 
 	bool	antenna_dvbt;
 	u16	antenna_gpio;
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index d25b0d2..5fa1927 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -1179,6 +1179,7 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 	int status = -1;
 	u16 sioPdrMclkCfg = 0;
 	u16 sioPdrMdxCfg = 0;
+	u16 err_cfg = 0;
 
 	dprintk(1, ": mpeg %s, %s mode\n",
 		mpegEnable ? "enable" : "disable",
@@ -1244,12 +1245,17 @@ static int MPEGTSConfigurePins(struct drxk_state *state, bool mpegEnable)
 		status = write16(state, SIO_PDR_MSTRT_CFG__A, sioPdrMdxCfg);
 		if (status < 0)
 			goto error;
-		status = write16(state, SIO_PDR_MERR_CFG__A, 0x0000);	/* Disable */
+
+		if (state->enable_merr_cfg)
+			err_cfg = sioPdrMdxCfg;
+
+		status = write16(state, SIO_PDR_MERR_CFG__A, err_cfg);
 		if (status < 0)
 			goto error;
-		status = write16(state, SIO_PDR_MVAL_CFG__A, 0x0000);	/* Disable */
+		status = write16(state, SIO_PDR_MVAL_CFG__A, err_cfg);
 		if (status < 0)
 			goto error;
+
 		if (state->m_enableParallel == true) {
 			/* paralel -> enable MD1 to MD7 */
 			status = write16(state, SIO_PDR_MD1_CFG__A, sioPdrMdxCfg);
@@ -6379,6 +6385,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->antenna_gpio = config->antenna_gpio;
 	state->antenna_dvbt = config->antenna_dvbt;
 	state->m_ChunkSize = config->chunk_size;
+	state->enable_merr_cfg = config->enable_merr_cfg;
 
 	if (config->dynamic_clk) {
 		state->m_DVBTStaticCLK = 0;
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 3a58b73..4bbf841 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -332,6 +332,7 @@ struct drxk_state {
 
 	u16	UIO_mask;	/* Bits used by UIO */
 
+	bool	enable_merr_cfg;
 	bool	single_master;
 	bool	no_i2c_bridge;
 	bool	antenna_dvbt;
-- 
1.7.8

