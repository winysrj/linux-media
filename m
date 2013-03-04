Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758335Ab3CDThw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Mar 2013 14:37:52 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24JbqAl030926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 4 Mar 2013 14:37:52 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/2] [media] mb86a20s: Don't assume a 32.57142MHz clock
Date: Mon,  4 Mar 2013 16:37:44 -0300
Message-Id: <1362425864-29292-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362425864-29292-1-git-send-email-mchehab@redhat.com>
References: <1362425864-29292-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that some devices initialize register 0x2a with different
values, add the calculus formula, instead of hardcoding it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb-frontends/mb86a20s.c | 26 ++++++++++++++++++++++++--
 drivers/media/dvb-frontends/mb86a20s.h |  8 ++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 1859e9d..d04b52e 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -70,7 +70,6 @@ static struct regdata mb86a20s_init1[] = {
 	{ 0x70, 0xff },
 	{ 0x08, 0x01 },
 	{ 0x50, 0xd1 }, { 0x51, 0x20 },
-	{ 0x28, 0x2a }, { 0x29, 0x00 }, { 0x2a, 0xff }, { 0x2b, 0x80 },
 };
 
 static struct regdata mb86a20s_init2[] = {
@@ -1776,6 +1775,7 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
 	u64 pll;
+	u32 fclk;
 	int rc;
 	u8  regD5 = 1, reg71, reg09 = 0x3a;
 
@@ -1810,6 +1810,10 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	fclk = state->config->fclk;
+	if (!fclk)
+		fclk = 32571428;
+
 	/* Adjust IF frequency to match tuner */
 	if (fe->ops.tuner_ops.get_if_frequency)
 		fe->ops.tuner_ops.get_if_frequency(fe, &state->if_freq);
@@ -1817,6 +1821,24 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	if (!state->if_freq)
 		state->if_freq = 3300000;
 
+	pll = (((u64)1) << 34) * state->if_freq;
+	do_div(pll, 63 * fclk);
+	pll = (1 << 25) - pll;
+	rc = mb86a20s_writereg(state, 0x28, 0x2a);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x29, (pll >> 16) & 0xff);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x2a, (pll >> 8) & 0xff);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x2b, pll & 0xff);
+	if (rc < 0)
+		goto err;
+	dev_dbg(&state->i2c->dev, "%s: fclk=%d, IF=%d, clock reg=0x%06llx\n",
+		__func__, fclk, state->if_freq, (long long)pll);
+
 	/* pll = freq[Hz] * 2^24/10^6 / 16.285714286 */
 	pll = state->if_freq * 1677721600L;
 	do_div(pll, 1628571429L);
@@ -1832,7 +1854,7 @@ static int mb86a20s_initfe(struct dvb_frontend *fe)
 	rc = mb86a20s_writereg(state, 0x2b, pll & 0xff);
 	if (rc < 0)
 		goto err;
-	dev_dbg(&state->i2c->dev, "%s: IF=%d, PLL=0x%06llx\n",
+	dev_dbg(&state->i2c->dev, "%s: IF=%d, IF reg=0x%06llx\n",
 		__func__, state->if_freq, (long long)pll);
 
 	if (!state->config->is_serial) {
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index bf22e77..1a7dea2 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -21,12 +21,16 @@
 /**
  * struct mb86a20s_config - Define the per-device attributes of the frontend
  *
+ * @fclk:		Clock frequency. If zero, assumes the default
+ *			(32.57142 Mhz)
  * @demod_address:	the demodulator's i2c address
+ * @is_serial:		if true, TS is serial. Otherwise, TS is parallel
  */
 
 struct mb86a20s_config {
-	u8 demod_address;
-	bool is_serial;
+	u32	fclk;
+	u8	demod_address;
+	bool	is_serial;
 };
 
 #if defined(CONFIG_DVB_MB86A20S) || (defined(CONFIG_DVB_MB86A20S_MODULE) \
-- 
1.8.1.4

