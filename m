Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:56145 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3LXQRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 11:17:19 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so6162511wes.12
        for <linux-media@vger.kernel.org>; Tue, 24 Dec 2013 08:17:18 -0800 (PST)
Received: from [192.168.1.100] (94.196.117.167.threembb.co.uk. [94.196.117.167])
        by mx.google.com with ESMTPSA id po3sm12760103wjc.3.2013.12.24.08.17.16
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=RC4-SHA bits=128/128);
        Tue, 24 Dec 2013 08:17:17 -0800 (PST)
Message-ID: <1387901832.24033.39.camel@canaries32-MCP7A>
Subject: [PATCH 1/2] m88rs2000: add m88rs2000_set_carrieroffset
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Tue, 24 Dec 2013 16:17:12 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the carrier offset correctly using the default mclk values.

Add function m88rs2000_get_mclk to calculate the mclk value
against crystal frequency which will later be used for
other functions.

Add function m88rs2000_set_carrieroffset to calculate
and set the offset value.

variable offset becomes a signed value.

Register 0x86 is set the appropriate value according to
remainder value of frequency % 192857 calculation as
shown.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: stable@vger.kernel.org # v3.9+

---
 drivers/media/dvb-frontends/m88rs2000.c | 77 ++++++++++++++++++++++++---------
 drivers/media/dvb-frontends/m88rs2000.h |  2 +
 2 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 4da5272..8091653 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -110,6 +110,52 @@ static u8 m88rs2000_readreg(struct m88rs2000_state *state, u8 reg)
 	return b1[0];
 }
 
+static u32 m88rs2000_get_mclk(struct dvb_frontend *fe)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	u32 mclk;
+	u8 reg;
+	/* Must not be 0x00 or 0xff */
+	reg = m88rs2000_readreg(state, 0x86);
+	if (!reg || reg == 0xff)
+		return 0;
+
+	reg /= 2;
+	reg += 1;
+
+	mclk = (u32)(reg * RS2000_FE_CRYSTAL_KHZ + 28 / 2) / 28;
+
+	return mclk;
+}
+
+static int m88rs2000_set_carrieroffset(struct dvb_frontend *fe, s16 offset)
+{
+	struct m88rs2000_state *state = fe->demodulator_priv;
+	u32 mclk;
+	s32 tmp;
+	u8 reg;
+	int ret;
+
+	mclk = m88rs2000_get_mclk(fe);
+	if (!mclk)
+		return -EINVAL;
+
+	tmp = (offset * 4096 + (s32)mclk / 2) / (s32)mclk;
+	if (tmp < 0)
+		tmp += 4096;
+
+	/* Carrier Offset */
+	ret = m88rs2000_writereg(state, 0x9c, (u8)(tmp >> 4));
+
+	reg = m88rs2000_readreg(state, 0x9d);
+	reg &= 0xf;
+	reg |= (u8)(tmp & 0xf) << 4;
+
+	ret |= m88rs2000_writereg(state, 0x9d, reg);
+
+	return ret;
+}
+
 static int m88rs2000_set_symbolrate(struct dvb_frontend *fe, u32 srate)
 {
 	struct m88rs2000_state *state = fe->demodulator_priv;
@@ -540,9 +586,8 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	fe_status_t status;
 	int i, ret = 0;
-	s32 tmp;
 	u32 tuner_freq;
-	u16 offset = 0;
+	s16 offset = 0;
 	u8 reg;
 
 	state->no_lock_count = 0;
@@ -567,26 +612,18 @@ static int m88rs2000_set_frontend(struct dvb_frontend *fe)
 	if (ret < 0)
 		return -ENODEV;
 
-	offset = tuner_freq - c->frequency;
+	offset = (s16)((s32)tuner_freq - c->frequency);
 
-	/* calculate offset assuming 96000kHz*/
-	tmp = offset;
-	tmp *= 65536;
-
-	tmp = (2 * tmp + 96000) / (2 * 96000);
-	if (tmp < 0)
-		tmp += 65536;
-
-	offset = tmp & 0xffff;
-
-	ret = m88rs2000_writereg(state, 0x9a, 0x30);
-	/* Unknown usually 0xc6 sometimes 0xc1 */
-	reg = m88rs2000_readreg(state, 0x86);
-	ret |= m88rs2000_writereg(state, 0x86, reg);
-	/* Offset lower nibble always 0 */
-	ret |= m88rs2000_writereg(state, 0x9c, (offset >> 8));
-	ret |= m88rs2000_writereg(state, 0x9d, offset & 0xf0);
+	/* default mclk value 96.4285 * 2 * 1000 = 192857 */
+	if (((c->frequency % 192857) >= (192857 - 3000)) ||
+				(c->frequency % 192857) <= 3000)
+		ret = m88rs2000_writereg(state, 0x86, 0xc2);
+	else
+		ret = m88rs2000_writereg(state, 0x86, 0xc6);
 
+	ret |= m88rs2000_set_carrieroffset(fe, offset);
+	if (ret < 0)
+		return -ENODEV;
 
 	/* Reset Demod */
 	ret = m88rs2000_tab_set(state, fe_reset);
diff --git a/drivers/media/dvb-frontends/m88rs2000.h b/drivers/media/dvb-frontends/m88rs2000.h
index 14ce31e..0a50ea9 100644
--- a/drivers/media/dvb-frontends/m88rs2000.h
+++ b/drivers/media/dvb-frontends/m88rs2000.h
@@ -53,6 +53,8 @@ static inline struct dvb_frontend *m88rs2000_attach(
 }
 #endif /* CONFIG_DVB_M88RS2000 */
 
+#define RS2000_FE_CRYSTAL_KHZ 27000
+
 enum {
 	DEMOD_WRITE = 0x1,
 	WRITE_DELAY = 0x10,
-- 
1.8.5.2

