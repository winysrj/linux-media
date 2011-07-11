Return-path: <mchehab@localhost>
Received: from mx1.redhat.com ([209.132.183.28]:19021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756415Ab1GKB7k (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2011 21:59:40 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xdg2011628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:40 -0400
Received: from pedra (vpn-225-29.phx2.redhat.com [10.3.225.29])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p6B1xKKX030664
	for <linux-media@vger.kernel.org>; Sun, 10 Jul 2011 21:59:38 -0400
Date: Sun, 10 Jul 2011 22:58:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 06/21] [media] drxk: Convert an #ifdef logic as a new config
 parameter
Message-ID: <20110710225853.6023eb7e@pedra>
In-Reply-To: <cover.1310347962.git.mchehab@redhat.com>
References: <cover.1310347962.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Instead of using #ifdef I2C_LONG_ADR for some devices, convert
it into a parameter. Terratec H5 logs from the original driver
seems to need this mode.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/frontends/drxk.h b/drivers/media/dvb/frontends/drxk.h
index a7b295f..d5b6f9f 100644
--- a/drivers/media/dvb/frontends/drxk.h
+++ b/drivers/media/dvb/frontends/drxk.h
@@ -6,6 +6,7 @@
 
 struct drxk_config {
 	u8 adr;
+	u32 single_master : 1;
 };
 
 extern struct dvb_frontend *drxk_attach(const struct drxk_config *config,
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index d351e6a..c4b35a5 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -375,9 +375,10 @@ static int i2c_read(struct i2c_adapter *adap,
 static int read16_flags(struct drxk_state *state, u32 reg, u16 *data, u8 flags)
 {
 	u8 adr = state->demod_address, mm1[4], mm2[2], len;
-#ifdef I2C_LONG_ADR
-	flags |= 0xC0;
-#endif
+
+	if (state->single_master)
+		flags |= 0xC0;
+
 	if (DRXDAP_FASI_LONG_FORMAT(reg) || (flags != 0)) {
 		mm1[0] = (((reg << 1) & 0xFF) | 0x01);
 		mm1[1] = ((reg >> 16) & 0xFF);
@@ -406,9 +407,10 @@ static int read16(struct drxk_state *state, u32 reg, u16 *data)
 static int read32_flags(struct drxk_state *state, u32 reg, u32 *data, u8 flags)
 {
 	u8 adr = state->demod_address, mm1[4], mm2[4], len;
-#ifdef I2C_LONG_ADR
-	flags |= 0xC0;
-#endif
+
+	if (state->single_master)
+		flags |= 0xC0;
+
 	if (DRXDAP_FASI_LONG_FORMAT(reg) || (flags != 0)) {
 		mm1[0] = (((reg << 1) & 0xFF) | 0x01);
 		mm1[1] = ((reg >> 16) & 0xFF);
@@ -438,9 +440,9 @@ static int read32(struct drxk_state *state, u32 reg, u32 *data)
 static int write16_flags(struct drxk_state *state, u32 reg, u16 data, u8 flags)
 {
 	u8 adr = state->demod_address, mm[6], len;
-#ifdef I2C_LONG_ADR
-	flags |= 0xC0;
-#endif
+
+	if (state->single_master)
+		flags |= 0xC0;
 	if (DRXDAP_FASI_LONG_FORMAT(reg) || (flags != 0)) {
 		mm[0] = (((reg << 1) & 0xFF) | 0x01);
 		mm[1] = ((reg >> 16) & 0xFF);
@@ -469,9 +471,9 @@ static int write16(struct drxk_state *state, u32 reg, u16 data)
 static int write32_flags(struct drxk_state *state, u32 reg, u32 data, u8 flags)
 {
 	u8 adr = state->demod_address, mm[8], len;
-#ifdef I2C_LONG_ADR
-	flags |= 0xC0;
-#endif
+
+	if (state->single_master)
+		flags |= 0xC0;
 	if (DRXDAP_FASI_LONG_FORMAT(reg) || (flags != 0)) {
 		mm[0] = (((reg << 1) & 0xFF) | 0x01);
 		mm[1] = ((reg >> 16) & 0xFF);
@@ -503,9 +505,10 @@ static int write_block(struct drxk_state *state, u32 Address,
 {
 	int status = 0, BlkSize = BlockSize;
 	u8 Flags = 0;
-#ifdef I2C_LONG_ADR
-	Flags |= 0xC0;
-#endif
+
+	if (state->single_master)
+		Flags |= 0xC0;
+
 	while (BlkSize > 0) {
 		int Chunk = BlkSize > state->m_ChunkSize ?
 		    state->m_ChunkSize : BlkSize;
@@ -6355,6 +6358,7 @@ struct dvb_frontend *drxk_attach(const struct drxk_config *config,
 
 	state->i2c = i2c;
 	state->demod_address = adr;
+	state->single_master = config->single_master;
 
 	mutex_init(&state->mutex);
 	mutex_init(&state->ctlock);
diff --git a/drivers/media/dvb/frontends/drxk_hard.h b/drivers/media/dvb/frontends/drxk_hard.h
index 700f40c..b7093e9 100644
--- a/drivers/media/dvb/frontends/drxk_hard.h
+++ b/drivers/media/dvb/frontends/drxk_hard.h
@@ -326,6 +326,11 @@ struct drxk_state {
 	u16               m_AntennaSwitchDVBTDVBC;
 
 	enum DRXPowerMode m_currentPowerMode;
+
+	/* Configurable parameters at the driver */
+
+	u32 single_master : 1;		/* Use single master i2c mode */
+
 };
 
 #define NEVER_LOCK 0
-- 
1.7.1


