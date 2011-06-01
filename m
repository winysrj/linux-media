Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:53712 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372Ab1FAKbb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2011 06:31:31 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QRihz-0003sX-FX
	for linux-media@vger.kernel.org; Wed, 01 Jun 2011 12:31:27 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 12:31:27 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 01 Jun 2011 12:31:27 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [bug-report] unconditionally calling cxd2820r_get_tuner_i2c_adapter() from em28xx-dvb.c creates a hard module dependency
Date: Wed, 01 Jun 2011 12:31:11 +0200
Message-ID: <87r57dn8r4.fsf@nemi.mork.no>
References: <87vcwpnavc.fsf@nemi.mork.no> <4DE60B36.9040507@iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Antti Palosaari <crope@iki.fi> writes:
> On 06/01/2011 12:45 PM, Bjørn Mork wrote:
>> Don't know the proper fix.  My naïve quick-fix was just to move struct
>> cxd2820r_priv into cxd2820r.h and making the function static inlined.
>> However, I do see that you may not want the struct in cxd2820r.h.  But I
>> trust that you have a brilliant solution to the problem :-)
>
> Actually I don't have any idea about that. Help is welcome.

Well, my straight forward approach is attached if you find that useful.
I removed the whole function call, since it was only ever called from
one place.  But that is your call.

I assume the fancy solution involves symbol trickery ala what
dvb_attach() does.  You do of course know that the symbol is available
at the point where em28xx-dvb calls it, as the cxd2820r_attach() must
have succeeded.  So "all" you need to do is to prevent the module tools
from being too smart.


Bjørn


--=-=-=
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: inline;
 filename=0001-em28xx-dvb-avoid-unwanted-dependency-on-cxd2820r.patch
Content-Transfer-Encoding: 8bit

>From 857331b809fca1003056dbc0f01f917e792981db Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Date: Tue, 31 May 2011 15:16:39 +0200
Subject: [PATCH] em28xx-dvb: avoid unwanted dependency on cxd2820r
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Calling cxd2820r_get_tuner_i2c_adapter() creates a dependency on cxd2820r
even if CONFIG_MEDIA_ATTACH is set.  Avoid this

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/media/dvb/frontends/cxd2820r.h      |   27 +++++++++++++++++----------
 drivers/media/dvb/frontends/cxd2820r_core.c |    7 -------
 drivers/media/dvb/frontends/cxd2820r_priv.h |   18 ------------------
 drivers/media/video/em28xx/em28xx-dvb.c     |    4 ++--
 4 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/drivers/media/dvb/frontends/cxd2820r.h b/drivers/media/dvb/frontends/cxd2820r.h
index ad17845..e0eeea8 100644
--- a/drivers/media/dvb/frontends/cxd2820r.h
+++ b/drivers/media/dvb/frontends/cxd2820r.h
@@ -85,6 +85,23 @@ struct cxd2820r_config {
 	u8 gpio_dvbc[3];
 };
 
+struct cxd2820r_priv {
+	struct i2c_adapter *i2c;
+	struct dvb_frontend fe[2];
+	struct cxd2820r_config cfg;
+	struct i2c_adapter tuner_i2c_adapter;
+
+	struct mutex fe_lock; /* FE lock */
+	int active_fe:2; /* FE lock, -1=NONE, 0=DVB-T/T2, 1=DVB-C */
+
+	int ber_running:1;
+
+	u8 bank[2];
+	u8 gpio[3];
+
+	fe_delivery_system_t delivery_system;
+	int last_tune_failed:1; /* for switch between T and T2 tune */
+};
 
 #if defined(CONFIG_DVB_CXD2820R) || \
 	(defined(CONFIG_DVB_CXD2820R_MODULE) && defined(MODULE))
@@ -93,9 +110,6 @@ extern struct dvb_frontend *cxd2820r_attach(
 	struct i2c_adapter *i2c,
 	struct dvb_frontend *fe
 );
-extern struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-);
 #else
 static inline struct dvb_frontend *cxd2820r_attach(
 	const struct cxd2820r_config *config,
@@ -106,13 +120,6 @@ static inline struct dvb_frontend *cxd2820r_attach(
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
-static inline struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(
-	struct dvb_frontend *fe
-)
-{
-	return NULL;
-}
-
 #endif
 
 #endif /* CXD2820R_H */
diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
index 0779f69..48e0265 100644
--- a/drivers/media/dvb/frontends/cxd2820r_core.c
+++ b/drivers/media/dvb/frontends/cxd2820r_core.c
@@ -771,13 +771,6 @@ static struct i2c_algorithm cxd2820r_tuner_i2c_algo = {
 	.functionality = cxd2820r_tuner_i2c_func,
 };
 
-struct i2c_adapter *cxd2820r_get_tuner_i2c_adapter(struct dvb_frontend *fe)
-{
-	struct cxd2820r_priv *priv = fe->demodulator_priv;
-	return &priv->tuner_i2c_adapter;
-}
-EXPORT_SYMBOL(cxd2820r_get_tuner_i2c_adapter);
-
 static struct dvb_frontend_ops cxd2820r_ops[2];
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
index 25adbee..5adeccd 100644
--- a/drivers/media/dvb/frontends/cxd2820r_priv.h
+++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
@@ -46,24 +46,6 @@ struct reg_val_mask {
 	u8  mask;
 };
 
-struct cxd2820r_priv {
-	struct i2c_adapter *i2c;
-	struct dvb_frontend fe[2];
-	struct cxd2820r_config cfg;
-	struct i2c_adapter tuner_i2c_adapter;
-
-	struct mutex fe_lock; /* FE lock */
-	int active_fe:2; /* FE lock, -1=NONE, 0=DVB-T/T2, 1=DVB-C */
-
-	int ber_running:1;
-
-	u8 bank[2];
-	u8 gpio[3];
-
-	fe_delivery_system_t delivery_system;
-	int last_tune_failed:1; /* for switch between T and T2 tune */
-};
-
 /* cxd2820r_core.c */
 
 extern int cxd2820r_debug;
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/video/em28xx/em28xx-dvb.c
index 7904ca4..e723c61 100644
--- a/drivers/media/video/em28xx/em28xx-dvb.c
+++ b/drivers/media/video/em28xx/em28xx-dvb.c
@@ -668,8 +668,8 @@ static int dvb_init(struct em28xx *dev)
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 			&em28xx_cxd2820r_config, &dev->i2c_adap, NULL);
 		if (dvb->fe[0]) {
-			struct i2c_adapter *i2c_tuner;
-			i2c_tuner = cxd2820r_get_tuner_i2c_adapter(dvb->fe[0]);
+			struct cxd2820r_priv *priv = dvb->fe[0]->demodulator_priv;
+			struct i2c_adapter *i2c_tuner = &priv->tuner_i2c_adapter;
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				i2c_tuner, &em28xx_cxd2820r_tda18271_config)) {
-- 
1.7.2.5


--=-=-=--

