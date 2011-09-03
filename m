Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab1ICPNR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 3 Sep 2011 11:13:17 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p83FDGgj009490
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 3 Sep 2011 11:13:16 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] [media] dvb-core, tda18271c2dd: define get_if_frequency() callback
Date: Sat,  3 Sep 2011 12:12:57 -0300
Message-Id: <1315062777-12049-1-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DRX-K frontend needs to know the IF frequency in order to work,
just like all other frontends. However, as it is a multi-standard
FE, the IF may change if the standard is changed. So, the usual
procedure of passing it via a config struct doesn't work.

One might code it as two separate IF frequencies, one by each type
of FE, but, as, on tda18271, the IF changes if the bandwidth for
DVB-C changes, this also won't work.

So, the better is to just add a new callback for it and require
it for the tuners that can be used with MFE frontends like drx-k.

It makes sense to add support for it on all existing tuners, and
remove the IF parameter from the demods, cleaning up the code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-core/dvb_frontend.h  |    1 +
 drivers/media/dvb/frontends/drxk_hard.c    |   10 +++++++++-
 drivers/media/dvb/frontends/tda18271c2dd.c |    4 ++--
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 5590eb6..67bbfa7 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -209,6 +209,7 @@ struct dvb_tuner_ops {
 
 	int (*get_frequency)(struct dvb_frontend *fe, u32 *frequency);
 	int (*get_bandwidth)(struct dvb_frontend *fe, u32 *bandwidth);
+	int (*get_if_frequency)(struct dvb_frontend *fe, u32 *frequency);
 
 #define TUNER_STATUS_LOCKED 1
 #define TUNER_STATUS_STEREO 2
diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
index 41b0838..f6431ef 100644
--- a/drivers/media/dvb/frontends/drxk_hard.c
+++ b/drivers/media/dvb/frontends/drxk_hard.c
@@ -6211,6 +6211,14 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	u32 IF;
 
 	dprintk(1, "\n");
+
+	if (!fe->ops.tuner_ops.get_if_frequency) {
+		printk(KERN_ERR
+		       "drxk: Error: get_if_frequency() not defined at tuner. Can't work without it!\n");
+		return -EINVAL;
+	}
+
+
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (fe->ops.tuner_ops.set_params)
@@ -6218,7 +6226,7 @@ static int drxk_set_parameters(struct dvb_frontend *fe,
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
 	state->param = *p;
-	fe->ops.tuner_ops.get_frequency(fe, &IF);
+	fe->ops.tuner_ops.get_if_frequency(fe, &IF);
 	Start(state, 0, IF);
 
 	/* printk(KERN_DEBUG "drxk: %s IF=%d done\n", __func__, IF); */
diff --git a/drivers/media/dvb/frontends/tda18271c2dd.c b/drivers/media/dvb/frontends/tda18271c2dd.c
index 0384e8d..1b1bf20 100644
--- a/drivers/media/dvb/frontends/tda18271c2dd.c
+++ b/drivers/media/dvb/frontends/tda18271c2dd.c
@@ -1195,7 +1195,7 @@ static int GetSignalStrength(s32 *pSignalStrength, u32 RFAgc, u32 IFAgc)
 }
 #endif
 
-static int get_frequency(struct dvb_frontend *fe, u32 *frequency)
+static int get_if_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct tda_state *state = fe->tuner_priv;
 
@@ -1222,7 +1222,7 @@ static struct dvb_tuner_ops tuner_ops = {
 	.sleep             = sleep,
 	.set_params        = set_params,
 	.release           = release,
-	.get_frequency     = get_frequency,
+	.get_if_frequency  = get_if_frequency,
 	.get_bandwidth     = get_bandwidth,
 };
 
-- 
1.7.1

