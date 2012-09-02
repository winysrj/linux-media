Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154Ab2IBHaY (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Sep 2012 03:30:24 -0400
Date: Sun, 2 Sep 2012 09:30:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org
Subject: [PATCH] tda8261: add printk levels
Message-ID: <alpine.LNX.2.00.1209011013420.28562@deuxcents.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alan Cox <alan@linux.intel.com>

This is done as a minimal printk updating patch to ensure correctness. Yes
it should all one day use dev_foo(), but that's one for the maintainers.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=32932
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---

The file has been moved in -next, so to avoid unnecessary conflicts, I am 
passing this one over from trivial tree to media maintainers.

Thanks.

 drivers/media/dvb-frontends/tda8261.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda8261.c b/drivers/media/dvb-frontends/tda8261.c
index 53c7d8f..19c4888 100644
--- a/drivers/media/dvb-frontends/tda8261.c
+++ b/drivers/media/dvb-frontends/tda8261.c
@@ -43,7 +43,7 @@ static int tda8261_read(struct tda8261_state *state, u8 *buf)
 	struct i2c_msg msg = { .addr	= config->addr, .flags = I2C_M_RD,.buf = buf,  .len = 1 };
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1)
-		printk("%s: read error, err=%d\n", __func__, err);
+		pr_err("%s: read error, err=%d\n", __func__, err);
 
 	return err;
 }
@@ -55,7 +55,7 @@ static int tda8261_write(struct tda8261_state *state, u8 *buf)
 	struct i2c_msg msg = { .addr = config->addr, .flags = 0, .buf = buf, .len = 4 };
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1)
-		printk("%s: write error, err=%d\n", __func__, err);
+		pr_err("%s: write error, err=%d\n", __func__, err);
 
 	return err;
 }
@@ -69,11 +69,11 @@ static int tda8261_get_status(struct dvb_frontend *fe, u32 *status)
 	*status = 0;
 
 	if ((err = tda8261_read(state, &result)) < 0) {
-		printk("%s: I/O Error\n", __func__);
+		pr_err("%s: I/O Error\n", __func__);
 		return err;
 	}
 	if ((result >> 6) & 0x01) {
-		printk("%s: Tuner Phase Locked\n", __func__);
+		pr_debug("%s: Tuner Phase Locked\n", __func__);
 		*status = 1;
 	}
 
@@ -98,7 +98,7 @@ static int tda8261_get_state(struct dvb_frontend *fe,
 		tstate->bandwidth = 40000000; /* FIXME! need to calculate Bandwidth */
 		break;
 	default:
-		printk("%s: Unknown parameter (param=%d)\n", __func__, param);
+		pr_err("%s: Unknown parameter (param=%d)\n", __func__, param);
 		err = -EINVAL;
 		break;
 	}
@@ -124,11 +124,11 @@ static int tda8261_set_state(struct dvb_frontend *fe,
 		 */
 		frequency = tstate->frequency;
 		if ((frequency < 950000) || (frequency > 2150000)) {
-			printk("%s: Frequency beyond limits, frequency=%d\n", __func__, frequency);
+			pr_warn("%s: Frequency beyond limits, frequency=%d\n", __func__, frequency);
 			return -EINVAL;
 		}
 		N = (frequency + (div_tab[config->step_size] - 1)) / div_tab[config->step_size];
-		printk("%s: Step size=%d, Divider=%d, PG=0x%02x (%d)\n",
+		pr_debug("%s: Step size=%d, Divider=%d, PG=0x%02x (%d)\n",
 			__func__, config->step_size, div_tab[config->step_size], N, N);
 
 		buf[0] = (N >> 8) & 0xff;
@@ -144,25 +144,25 @@ static int tda8261_set_state(struct dvb_frontend *fe,
 
 		/* Set params */
 		if ((err = tda8261_write(state, buf)) < 0) {
-			printk("%s: I/O Error\n", __func__);
+			pr_err("%s: I/O Error\n", __func__);
 			return err;
 		}
 		/* sleep for some time */
-		printk("%s: Waiting to Phase LOCK\n", __func__);
+		pr_debug("%s: Waiting to Phase LOCK\n", __func__);
 		msleep(20);
 		/* check status */
 		if ((err = tda8261_get_status(fe, &status)) < 0) {
-			printk("%s: I/O Error\n", __func__);
+			pr_err("%s: I/O Error\n", __func__);
 			return err;
 		}
 		if (status == 1) {
-			printk("%s: Tuner Phase locked: status=%d\n", __func__, status);
+			pr_debug("%s: Tuner Phase locked: status=%d\n", __func__, status);
 			state->frequency = frequency; /* cache successful state */
 		} else {
-			printk("%s: No Phase lock: status=%d\n", __func__, status);
+			pr_debug("%s: No Phase lock: status=%d\n", __func__, status);
 		}
 	} else {
-		printk("%s: Unknown parameter (param=%d)\n", __func__, param);
+		pr_err("%s: Unknown parameter (param=%d)\n", __func__, param);
 		return -EINVAL;
 	}
 
@@ -214,7 +214,7 @@ struct dvb_frontend *tda8261_attach(struct dvb_frontend *fe,
 
 //	printk("%s: Attaching %s TDA8261 8PSK/QPSK tuner\n",
 //		__func__, fe->ops.tuner_ops.tuner_name);
-	printk("%s: Attaching TDA8261 8PSK/QPSK tuner\n", __func__);
+	pr_info("%s: Attaching TDA8261 8PSK/QPSK tuner\n", __func__);
 
 	return fe;
 
-- 
1.7.7

