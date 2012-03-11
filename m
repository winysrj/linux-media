Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:57387 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753675Ab2CKSBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 14:01:18 -0400
Message-ID: <4F5CE86B.8040403@gmx.de>
Date: Sun, 11 Mar 2012 19:01:15 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: abraham.manu@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] stv090x: use error counter 1 for BER estimation
References: <4F4BEAAE.7050704@gmx.de> <4F5CADF2.80902@redhat.com>
In-Reply-To: <4F5CADF2.80902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/media/dvb/frontends/stv090x.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index 6c3c095..afbd50c 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -3512,6 +3512,33 @@ static int stv090x_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	return 0;
 }
 
+static int stv090x_read_ber(struct dvb_frontend *fe, u32 *ber)
+{
+	struct stv090x_state *state = fe->demodulator_priv;
+
+	u32 reg, h, m, l;
+	enum fe_status status;
+
+	stv090x_read_status(fe, &status);
+	if (!(status & FE_HAS_LOCK)) {
+		*ber = 1 << 23; /* Max BER */
+	} else {
+		/* Counter 1 */
+		reg = STV090x_READ_DEMOD(state, ERRCNT12);
+		h = STV090x_GETFIELD_Px(reg, ERR_CNT12_FIELD);
+
+		reg = STV090x_READ_DEMOD(state, ERRCNT11);
+		m = STV090x_GETFIELD_Px(reg, ERR_CNT11_FIELD);
+
+		reg = STV090x_READ_DEMOD(state, ERRCNT10);
+		l = STV090x_GETFIELD_Px(reg, ERR_CNT10_FIELD);
+
+		*ber = ((h << 16) | (m << 8) | l);
+	}
+	return 0;
+}
+
+#if 0
 static int stv090x_read_per(struct dvb_frontend *fe, u32 *per)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
@@ -3562,6 +3589,7 @@ err:
 	dprintk(FE_ERROR, 1, "I/O error");
 	return -1;
 }
+#endif
 
 static int stv090x_table_lookup(const struct stv090x_tab *tab, int max, int val)
 {
@@ -4740,7 +4768,7 @@ static struct dvb_frontend_ops stv090x_ops = {
 
 	.search				= stv090x_search,
 	.read_status			= stv090x_read_status,
-	.read_ber			= stv090x_read_per,
+	.read_ber			= stv090x_read_ber,
 	.read_signal_strength		= stv090x_read_signal_strength,
 	.read_snr			= stv090x_read_cnr,
 };
-- 
1.7.2.5
 
