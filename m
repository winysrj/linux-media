Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423Ab3AQS7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jan 2013 13:59:09 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0HIx9Ni015145
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 17 Jan 2013 13:59:09 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFCv11 16/16] [media] mb86a20s: Add CNR measurement
Date: Thu, 17 Jan 2013 16:58:30 -0200
Message-Id: <1358449110-11203-16-git-send-email-mchehab@redhat.com>
In-Reply-To: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
References: <1358449110-11203-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 328 ++++++++++++++++++++++++++++++++-
 1 file changed, 326 insertions(+), 2 deletions(-)

v2: Several fixes and cleanups for the per-layer CNR measures.

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 7d21473..3f6fd29 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -121,10 +121,14 @@ static struct regdata mb86a20s_init[] = {
 	{ 0x50, 0xb5 }, { 0x51, 0xff },
 	{ 0x50, 0xb6 }, { 0x51, 0xff },
 	{ 0x50, 0xb7 }, { 0x51, 0xff },
-	{ 0x50, 0x50 }, { 0x51, 0x02 },
+
+	{ 0x50, 0x50 }, { 0x51, 0x02 },		/* MER manual mode */
 	{ 0x50, 0x51 }, { 0x51, 0x04 },		/* MER symbol 4 */
+	{ 0x50, 0x50 }, { 0x51, 0x03 },		/* MER manual mode + RST */
+	{ 0x50, 0x50 }, { 0x51, 0x02 },		/* MER manual mode */
 	{ 0x45, 0x04 },				/* CN symbol 4 */
-	{ 0x48, 0x04 },
+	{ 0x48, 0x04 },				/* CN manual mode */
+
 	{ 0x50, 0xd5 }, { 0x51, 0x01 },		/* Serial */
 	{ 0x50, 0xd6 }, { 0x51, 0x1f },
 	{ 0x50, 0xd2 }, { 0x51, 0x03 },
@@ -897,6 +901,322 @@ static int mb86a20s_get_ber_before_vterbi(struct dvb_frontend *fe,
 	if (rc < 0)
 		return rc;
 	rc = mb86a20s_writereg(state, 0x53, 0x07);
+
+	return 0;
+}
+
+struct linear_segments {
+	unsigned x, y;
+};
+
+/*
+ * All tables below return a dB/1000 measurement
+ */
+
+static struct linear_segments cnr_to_db_table[] = {
+	{ 19648,     0},
+	{ 18187,  1000},
+	{ 16534,  2000},
+	{ 14823,  3000},
+	{ 13161,  4000},
+	{ 11622,  5000},
+	{ 10279,  6000},
+	{  9089,  7000},
+	{  8042,  8000},
+	{  7137,  9000},
+	{  6342, 10000},
+	{  5641, 11000},
+	{  5030, 12000},
+	{  4474, 13000},
+	{  3988, 14000},
+	{  3556, 15000},
+	{  3180, 16000},
+	{  2841, 17000},
+	{  2541, 18000},
+	{  2276, 19000},
+	{  2038, 20000},
+	{  1800, 21000},
+	{  1625, 22000},
+	{  1462, 23000},
+	{  1324, 24000},
+	{  1175, 25000},
+	{  1063, 26000},
+	{   980, 27000},
+	{   907, 28000},
+	{   840, 29000},
+	{   788, 30000},
+};
+
+static struct linear_segments cnr_64qam_table[] = {
+	{ 3922688,     0},
+	{ 3920384,  1000},
+	{ 3902720,  2000},
+	{ 3894784,  3000},
+	{ 3882496,  4000},
+	{ 3872768,  5000},
+	{ 3858944,  6000},
+	{ 3851520,  7000},
+	{ 3838976,  8000},
+	{ 3829248,  9000},
+	{ 3818240, 10000},
+	{ 3806976, 11000},
+	{ 3791872, 12000},
+	{ 3767040, 13000},
+	{ 3720960, 14000},
+	{ 3637504, 15000},
+	{ 3498496, 16000},
+	{ 3296000, 17000},
+	{ 3031040, 18000},
+	{ 2715392, 19000},
+	{ 2362624, 20000},
+	{ 1963264, 21000},
+	{ 1649664, 22000},
+	{ 1366784, 23000},
+	{ 1120768, 24000},
+	{  890880, 25000},
+	{  723456, 26000},
+	{  612096, 27000},
+	{  518912, 28000},
+	{  448256, 29000},
+	{  388864, 30000},
+};
+
+static struct linear_segments cnr_16qam_table[] = {
+	{ 5314816,     0},
+	{ 5219072,  1000},
+	{ 5118720,  2000},
+	{ 4998912,  3000},
+	{ 4875520,  4000},
+	{ 4736000,  5000},
+	{ 4604160,  6000},
+	{ 4458752,  7000},
+	{ 4300288,  8000},
+	{ 4092928,  9000},
+	{ 3836160, 10000},
+	{ 3521024, 11000},
+	{ 3155968, 12000},
+	{ 2756864, 13000},
+	{ 2347008, 14000},
+	{ 1955072, 15000},
+	{ 1593600, 16000},
+	{ 1297920, 17000},
+	{ 1043968, 18000},
+	{  839680, 19000},
+	{  672256, 20000},
+	{  523008, 21000},
+	{  424704, 22000},
+	{  345088, 23000},
+	{  280064, 24000},
+	{  221440, 25000},
+	{  179712, 26000},
+	{  151040, 27000},
+	{  128512, 28000},
+	{  110080, 29000},
+	{   95744, 30000},
+};
+
+struct linear_segments cnr_qpsk_table[] = {
+	{ 2834176,     0},
+	{ 2683648,  1000},
+	{ 2536960,  2000},
+	{ 2391808,  3000},
+	{ 2133248,  4000},
+	{ 1906176,  5000},
+	{ 1666560,  6000},
+	{ 1422080,  7000},
+	{ 1189632,  8000},
+	{  976384,  9000},
+	{  790272, 10000},
+	{  633344, 11000},
+	{  505600, 12000},
+	{  402944, 13000},
+	{  320768, 14000},
+	{  255488, 15000},
+	{  204032, 16000},
+	{  163072, 17000},
+	{  130304, 18000},
+	{  105216, 19000},
+	{   83456, 20000},
+	{   65024, 21000},
+	{   52480, 22000},
+	{   42752, 23000},
+	{   34560, 24000},
+	{   27136, 25000},
+	{   22016, 26000},
+	{   18432, 27000},
+	{   15616, 28000},
+	{   13312, 29000},
+	{   11520, 30000},
+};
+
+static s64 interpolate_value(u32 value, struct linear_segments *segments,
+			     unsigned len)
+{
+	struct linear_segments *seg;
+	s64 tmp64;
+	int i, dx, dy;
+
+	if (value >= segments[0].x)
+		return segments[0].y;
+	if (value < segments[len-1].x)
+		return segments[len-1].y;
+
+	for (i = 1; i < len - 1; i++)
+		if (value >= segments[i].x)
+			break;
+	seg = &segments[i];
+
+	/* Linear interpolation between the two (x,y) points */
+	dy = segments[i].y - segments[i - 1].y;
+	dx = segments[i - 1].x - segments[i].x;
+	tmp64 = dy  * ((u64)value - seg->x - (dx >> 1));
+	do_div(tmp64, dx);
+	return seg->y - tmp64;
+}
+
+static int mb86a20s_get_main_CNR(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 cnr_linear, cnr;
+	int rc, val;
+
+	/* Check if CNR is available */
+	rc = mb86a20s_readreg(state, 0x45);
+	if (rc < 0)
+		return rc;
+
+	if (!(rc & 0x40)) {
+		dev_info(&state->i2c->dev, "%s: CNR is not available yet.\n",
+			 __func__);
+		return -EBUSY;
+	}
+	val = rc;
+
+	rc = mb86a20s_readreg(state, 0x46);
+	if (rc < 0)
+		return rc;
+	cnr_linear = rc << 8;
+
+	rc = mb86a20s_readreg(state, 0x46);
+	if (rc < 0)
+		return rc;
+	cnr_linear |= rc;
+
+	cnr = interpolate_value(cnr_linear,
+				cnr_to_db_table, ARRAY_SIZE(cnr_to_db_table));
+
+	c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	c->cnr.stat[0].svalue = cnr;
+
+	dev_dbg(&state->i2c->dev, "%s: CNR is %d.%03d dB (%d)\n",
+		__func__, cnr / 1000, cnr % 1000, cnr_linear);
+
+	/* CNR counter reset */
+	rc = mb86a20s_writereg(state, 0x45, val | 0x10);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x45, val & 0x6f);
+
+	return rc;
+}
+
+static int mb86a20s_get_per_layer_CNR(struct dvb_frontend *fe)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 mer, cnr;
+	int rc, val, i;
+	struct linear_segments *segs;
+	unsigned segs_len;
+
+	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
+
+	/* Check if the measures are already available */
+	rc = mb86a20s_writereg(state, 0x50, 0x5b);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+
+	/* Check if data is available */
+	if (!(rc & 0x01)) {
+		dev_info(&state->i2c->dev,
+			"%s: MER measures aren't available yet.\n", __func__);
+		return -EBUSY;
+	}
+
+	/* Read all layers */
+	for (i = 0; i < 3; i++) {
+		if (!(c->isdbt_layer_enabled & (1 << i))) {
+			c->cnr.stat[1 + i].scale = FE_SCALE_NOT_AVAILABLE;
+			continue;
+		}
+
+		rc = mb86a20s_writereg(state, 0x50, 0x52 + i * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_readreg(state, 0x51);
+		if (rc < 0)
+			return rc;
+		mer = rc << 16;
+		rc = mb86a20s_writereg(state, 0x50, 0x53 + i * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_readreg(state, 0x51);
+		if (rc < 0)
+			return rc;
+		mer |= rc << 8;
+		rc = mb86a20s_writereg(state, 0x50, 0x54 + i * 3);
+		if (rc < 0)
+			return rc;
+		rc = mb86a20s_readreg(state, 0x51);
+		if (rc < 0)
+			return rc;
+		mer |= rc;
+
+		switch (c->layer[i].modulation) {
+		case DQPSK:
+		case QPSK:
+			segs = cnr_qpsk_table;
+			segs_len = ARRAY_SIZE(cnr_qpsk_table);
+			break;
+		case QAM_16:
+			segs = cnr_16qam_table;
+			segs_len = ARRAY_SIZE(cnr_16qam_table);
+			break;
+		default:
+		case QAM_64:
+			segs = cnr_64qam_table;
+			segs_len = ARRAY_SIZE(cnr_64qam_table);
+			break;
+		}
+		cnr = interpolate_value(mer, segs, segs_len);
+
+		c->cnr.stat[1 + i].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[1 + i].svalue = cnr;
+
+		dev_dbg(&state->i2c->dev,
+			"%s: CNR for layer %c is %d.%03d dB (MER = %d).\n",
+			__func__, 'A' + i, cnr / 1000, cnr % 1000, mer);
+
+	}
+
+	/* Start a new MER measurement */
+	/* MER counter reset */
+	rc = mb86a20s_writereg(state, 0x50, 0x50);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_readreg(state, 0x51);
+	if (rc < 0)
+		return rc;
+	val = rc;
+
+	rc = mb86a20s_writereg(state, 0x51, val | 0x01);
+	if (rc < 0)
+		return rc;
+	rc = mb86a20s_writereg(state, 0x51, val & 0x06);
 	if (rc < 0)
 		return rc;
 
@@ -948,7 +1268,11 @@ static int mb86a20s_get_stats(struct dvb_frontend *fe)
 
 	dev_dbg(&state->i2c->dev, "%s called.\n", __func__);
 
+	mb86a20s_get_main_CNR(fe);
+
 	/* Get per-layer stats */
+	mb86a20s_get_per_layer_CNR(fe);
+
 	for (i = 0; i < 3; i++) {
 		if (c->isdbt_layer_enabled & (1 << i)) {
 			/* Layer is active and has rc segments */
-- 
1.7.11.7

