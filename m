Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:50888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab1GKB7l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:41 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xf2V018130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:41 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKY030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:40 -0400
Date: Sun, 10 Jul 2011 22:58:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/21] [media] drxk: Add a parameter for the microcode name
Message-ID: <20110710225854.57f9c6a0@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

The microcode firmware provided on Terratec H5 seems to be
different. Add a parameter to allow specifying a different
firmware per-device.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index d5b6f9f..dd54512 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -7,6 +7,7 @@
 struct drxk_config {
 	u8 adr;
 	u32 single_master : 1;
+	const char *microcode_name;
 };
 
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 1452e82..adb454a 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -343,10 +343,11 @@ static int i2c_write(struct i2c_adapter *adap, u8 adr, u8 *data, int len)
 static int i2c_read(struct i2c_adapter *adap,
 		    u8 adr, u8 *msg, int len, u8 *answ, int alen)
 {
-	struct i2c_msg msgs[2] = { {.addr = adr, .flags = 0,
+	struct i2c_msg msgs[2] = {
+		{.addr = adr, .flags = 0,
 				    .buf = msg, .len = len},
-	{.addr = adr, .flags = I2C_M_RD,
-	 .buf = answ, .len = alen}
+		{.addr = adr, .flags = I2C_M_RD,
+		 .buf = answ, .len = alen}
 	};
 	dprintk(3, ":");
 	if (debug > 2) {
@@ -5904,7 +5905,7 @@ static int PowerDownDevice(struct drxk_state *state)
 	return 0;
 }
 
-static int load_microcode(struct drxk_state *state, char *mc_name)
+static int load_microcode(struct drxk_state *state, const char *mc_name)
 {
 	const struct firmware *fw = NULL;
 	int err = 0;
@@ -6010,20 +6011,11 @@ static int init_drxk(struct drxk_state *state)
 			if (status < 0)
 				break;
 
-#if 0
-			if (state->m_DRXK_A3_PATCH_CODE)
-				status = DownloadMicrocode(state, DRXK_A3_microcode, DRXK_A3_microcode_length);
-				if (status < 0)
-					break;
-#else
-			load_microcode(state, "drxk_a3.mc");
-#endif
-#if NOA1ROM
-			if (state->m_DRXK_A2_PATCH_CODE)
-				status = DownloadMicrocode(state, DRXK_A2_microcode, DRXK_A2_microcode_length);
-				if (status < 0)
-					break;
-#endif
+			if (!state->microcode_name)
+				load_microcode(state, "drxk_a3.mc");
+			else
+				load_microcode(state, state->microcode_name);
+
 			/* disable token-ring bus through OFDM block for possible ucode upload */
 			status = write16(state, SIO_OFDM_SH_OFDM_RING_ENABLE__A, SIO_OFDM_SH_OFDM_RING_ENABLE_OFF);
 			if (status < 0)
@@ -6367,6 +6359,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 	state->i2c = i2c;
 	state->demod_address = adr;
 	state->single_master = config->single_master;
+	state->microcode_name = config->microcode_name;
 
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index b7093e9..8cdadce 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -330,6 +330,7 @@ struct drxk_state {
 	/* Configurable parameters at the driver */
 
 	u32 single_master : 1;		/* Use single master i2c mode */
+	const char *microcode_name;
 
 };
 
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index b8686c1..93f0af5 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -301,10 +301,10 @@ static struct drxd_config em28xx_drxd = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
-#define TERRATEC_H5_DRXK_I2C_ADDR	0x29
-
 struct drxk_config terratec_h5_drxk = {
 	.adr = 0x29,
+	.single_master = 1,
+	.microcode_name = "terratec_h5.fw",
 };
 
 static int drxk_gate_ctrl(struct dvb_frontend *fe, int enable)
-- 
1.7.1


